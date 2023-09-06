# disable network adapters if the network name contains $notWanted

$notWanted = "mschool"
$notWanted = $notWanted.ToUpper()

ForEach ($profile in Get-NetConnectionProfile)
{
    if ($profile.Name.ToUpper().Contains($notWanted))
    {
        Get-NetAdapter | Where InterfaceIndex -eq $profile.InterfaceIndex | Disable-NetAdapter -Confirm:$false
    }
}
