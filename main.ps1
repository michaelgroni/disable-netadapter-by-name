# Disable network adapters or IP protocols if the network name contains $notWanted.

# You can see the network name, for example, with the PowerShell command Get-NetConnectionProfile.

## configuration

$notWanted = "labor" # Not case-sensitive. It is sufficient to enter a part of the name.

$disableCompletely = $false
$disableIPv4 = $true
$disableIPv6 = $true


# When $disableCompletely is true, the network adapter ist disabled and the other variables are ignored.
# Otherwise the network adapter stays enabled with the IP protocols switced on or off according to the variables.

# WARNING: This script only detects an active network adapter. If you have completely disabled it or switched off
#          both IP protocols, you have to reactivate ist manually.


## script

$notWanted = $notWanted.ToUpper()

ForEach ($profile in Get-NetConnectionProfile)
{    
    if ($profile.Name.ToUpper().Contains($notWanted))
    {
        $adapters = Get-NetAdapter | Where InterfaceIndex -eq $profile.InterfaceIndex
        $adapter = $adapters[0]
        
        if ($disableCompletely)
        {
            Disable-NetAdapter $adapter.Name -Confirm:$false
        }
        else # enable the network adapter
        {
            if ($disableIPv4)
            {
                Disable-NetAdapterBinding $adapter.Name -ComponentID ms_tcpip
            }
            else
            {
                Enable-NetAdapterBinding $adapter.Name -ComponentID ms_tcpip
            }


            if ($disableIPv6)
            {
                Disable-NetAdapterBinding $adapter.Name -ComponentID ms_tcpip6   
            }
            else
            {
                Enable-NetAdapterBinding $adapter.Name -ComponentID ms_tcpip6
            }
        }
        
    }
}
