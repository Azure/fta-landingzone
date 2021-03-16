#example 
#$rgName = "lztest1"
$rgName = ""

#example 
#$resourceName = "Landing Zone Workbook Workbook resource"
$resourceName = ""

#example = "https://raw.githubusercontent.com/fskelly/lzreview/main/LZReview/landingzonereview-workbookGalleryTemplatev2.json"
$templateURI = "https://raw.githubusercontent.com/vanessabruwer/lzreview/main/LZReview/landingzonereview-workbookGalleryTemplatev2.1.json"

#check to see if Resource Group exists
$rgExist = Get-AzResourceGroup -Name $RgName -ErrorAction SilentlyContinue

if ($rgExist)
{
    Write-host "Deploying to $rgName"
    New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateUri $templateURI -resourceName $resourceName 
}
else 
{
    write-host "$rgName does not exist"
    $location = read-host "Which Azure Region should it be deployed to?"
    New-AzResourceGroup -Name $rgName -Location $location
    New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateUri $templateURI -resourceName $resourceName 
}
