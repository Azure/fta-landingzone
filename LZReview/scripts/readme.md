# **WORK IN PROGRESS**

# PowerShell Scripts

This is the folder within the repo that holds the PowerShell scripts. It follows a folder / sub-folder and PowerShell Module structure.

```bash
README.MD
├── folder
│   └── sub-folder
│       └── module.psm1
```

For example,

```bash
README.MD
└── modules
    └── EA
        └── checkMSAAccounts.psm1
```

In the above example, the folder structure is recursively checked and then finds the *"checkMSAAccounts.psm1"* within the *"EA"* folder, as a sub folder of *"modules"*.

## Starting the script

The key file to begin the script is *"start.ps1"* . This will be responsible for checking for the modules and then running the required tests. There is a framework in place to allow for the uploading of data into an Azure Log Analytics Workspace.

### Key Variables

#### [start.ps1](/LZReview/scripts/start.ps1)

##### subscription variables

```powershell
## Subscription variables
$subscription = ""
$tenant = ""
```

##### Azure Log Analtics Variables

```powershell
## ALA variables
# Replace with your Workspace ID
$customerId = ""  
# Replace with your Primary Key
$sharedKey = ""
# Specify the name of the record type that you'll be creating
$LogType = "CommunityWorkbook_V2"
# You can use an optional field to specify the timestamp from the data. If the time field is not specified, Azure Monitor assumes the time is the message ingestion time
$TimeStampField = ""
```

##### Connecting to Azure

```powershell
### Connecting to Azure Subscriptions
### Expect an auth window to appear
Connect-AzAccount -Tenant $tenant
$context = Get-AzSubscription -SubscriptionId $subscription -TenantId $tenant
Set-AzContext $context
```

##### Checking folders for modules

```powershell
## Tests that are run based on Folder structure
## add folders for more tests
$TestFolders = @()
$TestFolders += ".\modules\EA\"
## $TestFolders += ".\vms\" ##another sample folder
```
