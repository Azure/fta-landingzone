# Landing Zone Workbook

The aim of this workbook is to visualise core components of an Azure Landing Zone with the focus on the core components. This workbook currently visualises the following checks:
* Governance
    * Subscription health
    * Tag use
    * Policy Assignments
    * Resource Locks use
    * Azure Security Center/Defender status + Secure Score
    * Azure Monitor components + Log Analytics workspaces
* Identity and RBAC
    * Azure Advisor findings around Identity and Access
* Networking
    * Subnets without NSGs
    * Virtual Network Gateways
* Compute
    * Virtual Machines wih public IP addresses directly assigned
    * Virtual Machines with unmanaged disks
* Storage
    * Storage accounts with Secure Transfer Only disabled


To create this workbook in your environment, visit Azure Monitor > Workbooks, and select the New Workbook icon

![new workbook](/resources/newworkbook.jpg "new workbook")

Locate the code view button in the top bar of the workbook

![edit code](/resources/workbookcodebutton.jpg "edit code")

You can now view the code in the workbook

![new workbook](/resources/workbookcodeview.jpg "new workbook")

Replace all the code in this view with the code from the workbook provided here, and then click Apply.

You should now see the Workbook with the subscription auto-populated, and a number of tabs running across, and some counting widgets on the Overview page:

![workbook view](/resources/lz-overview.jpg "lz-overview")

**Other tabs**:
* Governance:
![Governance](/resources/lz-governance1.jpg "governance view")
* Identity and RBAC:
![Identity](/resources/lz-identity.jpg "identity view")
* Networking:
![Networking](/resources/lz-networking.jpg "Networking view")
* Compute: 
![Compute](/resources/lz-compute.jpg "compute view")
* Storage:
![Storage](/resources/lz-storage.jpg "storage view")