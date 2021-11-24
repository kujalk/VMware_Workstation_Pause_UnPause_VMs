<#
        .SYNOPSIS
        To Pause/Unpause VMware Workstation VMs using vmrun utility
        Developer - K.Janarthanan
        .DESCRIPTION
        To Pause/Unpause VMware Workstation VMs using vmrun utility
        Date - 19/11/2021
        .OUTPUTS
        Log file with name VMware_Pause_Unpause.log in the same directory of the script
        .EXAMPLE
        PS> .\VMRun_Pause_Unpause.ps1
#>


$Global:LogFile = "$PSScriptRoot\VMware_Pause_Unpause.log" #Log file location
function Write-Log #Function for logging
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [Validateset("INFO","ERR","WARN")]
        [string]$Type="INFO"
    )

    $DateTime = Get-Date -Format "MM-dd-yyyy HH:mm:ss"
    $FinalMessage = "[{0}]::[{1}]::[{2}]" -f $DateTime,$Type,$Message

    #Storing the output in the log file
    $FinalMessage | Out-File -FilePath $LogFile -Append

    if($Type -eq "ERR")
    {
        Write-Host "$FinalMessage" -ForegroundColor Red
    }
    else 
    {
        Write-Host "$FinalMessage" -ForegroundColor Green
    }
}

$VMX_Location = @("D:\VM_Folder\VM_2\VM_2.vmx","D:\VM_Folder\VM_1.vmx")
$VMRun_Location = "D:\Vmware"
$Currnet_Location = $PSScriptRoot

try 
{
    Write-Log "Script Started"
    Write-Log "Switch directory to $VMRun_Location"
    
    cd $VMRun_Location

    foreach($VMX in $VMX_Location)
    {
        $VM_Name = $VMX.split("\")[-1].split(".")[0]
        Write-Log "Working on VM $VM_Name"

        try 
        {
            Write-Log "Pausing VM"
            .\vmrun.exe -T ws pause $VMX
            Write-Log "Successfully Paused the VM"
        }
        catch 
        {
            Write-Log "Error while pausing the VM - $_" -Type ERR
        }
    }

    Write-Host "Start the desired process. I am sleeping for 10s"
    Start-Sleep 10

    foreach($VMX in $VMX_Location)
    {
        $VM_Name = $VMX.split("\")[-1].split(".")[0]
        Write-Log "Working on VM $VM_Name"

        try 
        {
            Write-Log "UnPausing VM"
            .\vmrun.exe -T ws unpause $VMX
            Write-Log "Successfully UnPaused the VM"
        }
        catch 
        {
            Write-Log "Error while unpausing the VM - $_" -Type ERR
        }
    }

    cd $Currnet_Location
}
catch 
{
    Write-Log "$_" -Type ERR
    cd $Currnet_Location
}
