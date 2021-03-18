function get-MSAAccounts () {
  param()

  ## Build empty array for Findings
  $Findings = @()

  $test = Get-AzRoleAssignment -Scope /subscriptions/$subscription | Where-Object {$_.SignInName -like "*#EXT#*"} | ForEach-Object {
    [pscustomobject]@{
      Check = "001-MicrosoftAccounts"
      Area = "Enterprise Agreement enrollment and Azure Active Directory tenants"
      Category = "Plan for enterprise enrollment"
      Level = "Warning"
      Description = $_.DisplayName + $_.RoleDefinitionName
      Information = "Link or recommendation to more information"
      Subscription = $subscription
      CollectionTime = [System.DateTime]::UtcNow
    }
  }

  $Findings = $test

  ## send check to ALA
  $logAnalyticsParams = @{
    CustomerId = "$customerId"
    SharedKey = "$sharedKey"
    TimeStampField = "CollectionTime"
    LogType = "$LogType"
  }
  
  ### DO NOT MODIFY ANYTHING FROM HERE DOWN - YOU WILL BREAK CODE
  ## UPLOAD TO ALA
  Export-LogAnalytics @logAnalyticsParams $Findings
  return $Findings
  
}