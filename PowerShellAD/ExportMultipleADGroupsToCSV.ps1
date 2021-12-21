$GroupList = "ExampleGroupName1","ExampleGroupName2"

foreach ($Group in $GroupList) {

Get-ADGroupMember $Group | Select name | Export-CSV "C:\Temp\AD Groups\$Group.csv" -NoTypeInformation

}
