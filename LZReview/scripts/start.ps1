# Adapted from https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-data-collector-api
# gist used - https://gist.githubusercontent.com/taddison/d49bd8c6f7fc1d45aa8e7b0906c180ae/raw/a42445b25af483774a01af102dee763889141794/postToLogAnalytics.ps1

##### SCRIPT VARIABLES #####
##### Update as needed #####

## Subscription variables
$subscription = ""
$tenant = ""

## ALA variables
# Replace with your Workspace ID
$customerId = ""  
# Replace with your Primary Key
$sharedKey = ""
# Specify the name of the record type that you'll be creating
$LogType = "CommunityWorkbook_V2"
# You can use an optional field to specify the timestamp from the data. If the time field is not specified, Azure Monitor assumes the time is the message ingestion time
$TimeStampField = ""


##### FUNCTIONS - DO NOT CHANGE ##### 
Function Get-LogAnalyticsSignature {
  [cmdletbinding()]
  Param (
    $customerId,
    $sharedKey,
    $date,
    $contentLength,
    $method,
    $contentType,
    $resource
  )
  $xHeaders = "x-ms-date:" + $date
  $stringToHash = $method + "`n" + $contentLength + "`n" + $contentType + "`n" + $xHeaders + "`n" + $resource

  $bytesToHash = [Text.Encoding]::UTF8.GetBytes($stringToHash)
  $keyBytes = [Convert]::FromBase64String($sharedKey)

  $sha256 = New-Object System.Security.Cryptography.HMACSHA256
  $sha256.Key = $keyBytes
  $calculatedHash = $sha256.ComputeHash($bytesToHash)
  $encodedHash = [Convert]::ToBase64String($calculatedHash)
  $authorization = 'SharedKey {0}:{1}' -f $customerId,$encodedHash
  return $authorization
}
##### FUNCTIONS - DO NOT CHANGE ##### 


##### FUNCTIONS - DO NOT CHANGE ##### 
Function Export-LogAnalytics {
  [cmdletbinding()]
  Param(
    $customerId,
    $sharedKey,
    $object,
    $logType,
    $TimeStampField
  )
  $bodyAsJson = ConvertTo-Json $object
  $body = [System.Text.Encoding]::UTF8.GetBytes($bodyAsJson)

  $method = "POST"
  $contentType = "application/json"
  $resource = "/api/logs"
  $rfc1123date = [DateTime]::UtcNow.ToString("r")
  $contentLength = $body.Length

  $signatureArguments = @{
    CustomerId = $customerId
    SharedKey = $sharedKey
    Date = $rfc1123date
    ContentLength = $contentLength
    Method = $method
    ContentType = $contentType
    Resource = $resource
  }

  $signature = Get-LogAnalyticsSignature @signatureArguments
    
  $uri = "https://" + $customerId + ".ods.opinsights.azure.com" + $resource + "?api-version=2016-04-01"

  $headers = @{
    "Authorization" = $signature;
    "Log-Type" = $logType;
    "x-ms-date" = $rfc1123date;
    "time-generated-field" = $TimeStampField;
  }

  $response = Invoke-WebRequest -Uri $uri -Method $method -ContentType $contentType -Headers $headers -Body $body -UseBasicParsing
  return $response.StatusCode
}
##### FUNCTIONS - DO NOT CHANGE ##### 

### Connecting to Azure Subscriptions
### Expect an auth window to appear
Connect-AzAccount -Tenant $tenant
$context = Get-AzSubscription -SubscriptionId $subscription -TenantId $tenant
Set-AzContext $context

## Tests that are run based on Folder structure
## add folders for more tests
$TestFolders = @()
$TestFolders += ".\modules\EA\"
## $TestFolders += ".\vms\" ##another sample folder

### DO NOT MODIFY ANYTHING FROM HERE DOWN - YOU WILL BREAK CODE
## Build empty array for Findings
$Findings = @()

# Browse all folders for tests
# Use folder structure and .psm1 files for tests
foreach ($Folder in $TestFolders) {
  Write-Host "Exploring $Folder for modules..."
  Get-ChildItem -Path $Folder -Recurse | ForEach-Object {
    $File = $_
    # For each module found, import it and look for all the functions contained
    if ($File.Extension -eq ".psm1") {
      Write-Host "Found module $($File.BaseName)"
      Remove-Module -Name $File.BaseName -ErrorAction SilentlyContinue
      Import-Module $File.FullName
      $TestFunctions = Get-Command -Module $File.BaseName
      # For each function in the module, run it and add the results to the Findings variable
      foreach ($TestFunction in $TestFunctions) {
        $Findings += & $TestFunction
            }
        }
    }
}