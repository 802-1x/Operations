Install-Module Subnet -Scope CurrentUser -Force
$Subnet = Get-Subnet "x.x.x.x/x"


$Gateway1 = $Subnet.HostAddresses[0]
$Gateway2 = $Subnet.HostAddresses[1]
$HostRange = @()
foreach ($HostAddress in $Subnet.HostAddresses) {
        if (($HostAddress –ne $Gateway1) -and ($HostAddress -ne $Gateway2)) { $HostRange = $HostRange += $HostAddress }
    }
$Broadcast = $Subnet.BroadcastAddress.IPAddressToString

$Tasks = $HostRange | % { [System.Net.NetworkInformation.Ping]::new().SendPingAsync($_) }; [Threading.Tasks.Task]::WaitAll($Tasks)

$SuccessfulPing = $Tasks.Result | where { $_.Status -eq 'Success' }
$ValidHosts = @()
foreach ($IP in $SuccessfulPing) { $ValidHosts = $ValidHosts += $IP.Address.IPAddressToString }

Write-Host $ValidHosts
