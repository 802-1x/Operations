#Description:	Change adaptor settings for general use for server access and enabe proxy

#Defining variables
$IP = 'x.x.x.x'
$PrefixLength = '20'
$Gateway = 'x.x.x.x'
$DNS = 'x.x.x.x', 'x.x.x.x'
$IPType = 'IPv4'
$RegProxy = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
$ProxySettings = Get-ItemProperty -Path $RegProxy

#Retreive adapter settings to be configured
$Adapter = Get-NetAdapter -InterfaceAlias 'Ethernet'

#Remove settings if adapter has current configuration
If (($Adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) { 
	$Adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$False
}

If (($Adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
	$Adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$False
}

#Configure the IP addressing details
$Adapter | New-NetIPAddress -AddressFamily $IPType -IPAddress $IP -PrefixLength $PrefixLength -DefaultGateway $Gateway

# Configure the DNS client server IP addresses
$Adapter | Set-DnsClientServerAddress -ServerAddresses $DNS

#Enable the proxy if it is disabled
If ($ProxySettings.ProxyEnable -eq '0') {
	Set-ItemProperty -Path $RegProxy -Name ProxyEnable -Value 1
}
