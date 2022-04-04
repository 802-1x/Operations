#Description:	Change adaptor settings for Ubiquiti runups and disable proxy

#Defining variables
$IP = '192.168.1.50'
$PrefixLength = '24'
$Gateway = '192.168.1.1'
$DNS = '8.8.8.8'
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

#Enable the proxy if it is enabled
If ($ProxySettings.ProxyEnable -eq '1') {
	Set-ItemProperty -Path $RegProxy -Name ProxyEnable -Value 0
}
