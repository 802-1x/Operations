$ServerServices = Get-ComputerInfo | Select CSName
Get-WmiObject win32_service -properties * -Filter "StartName='netbiosdomainname\\useraccountusername'" | Select Name, DisplayName, StartName, StartMode, State | Export-Csv C:\Temp\Services\$server.csv
