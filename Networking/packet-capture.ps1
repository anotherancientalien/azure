## This script will run packet capture on EVERY VIRTUAL MACHINE in the resource group
## Ensure that Network Watcher Extension is installed on the VMs

$VMResourceGroup = "demo-packet-capture"

# Storage account to save the packet captures
$StorageAccountId = "/subscriptions/0000000-0000-0000-0000-000000000000/resourceGroups/demo-packet-capture/providers/Microsoft.Storage/storageAccounts/packetcapture"

# Network Watcher
$NWResourceGroup = "NetworkWatcherRG"
$NWNamePrefix = "NetworkWatcher_"

$PacketCaptureDurationInSeconds = 60

$PacketCaptureNamePrefix = "LOS"
$PacketCaptureNameSuffix = $(get-date -f yyyy-MM-dd-HHmmss)
$VMs = Get-AzureRmVM -ResourceGroup $VMResourceGroup

ForEach ($VM in $VMs)
{
    $NWName = $NWNamePrefix + $VM.Location
    $PacketCaptureName = $PacketCaptureNamePrefix + "-" + $VM.Name + "-" + $PacketCaptureNameSuffix

    $networkWatcher = Get-AzureRmNetworkWatcher -Name $NWName -ResourceGroupName $NWResourceGroup

    #Initiate packet capture on the VM that fired the alert
    Write-Output "Initiating Packet Capture on $($VM.Name)"
    New-AzureRmNetworkWatcherPacketCapture -NetworkWatcher $networkWatcher -TargetVirtualMachineId $VM.Id -PacketCaptureName $PacketCaptureName -StorageAccountId $StorageAccountId -TimeLimitInSeconds $PacketCaptureDurationInSeconds
}