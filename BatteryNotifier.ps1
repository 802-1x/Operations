#Final Version
Function ToastNotifcation {
#Shows Popup in Notifcation Area
$ErrorActionPreference = "Stop"
$notificationTitle = "Battery Percentage remaining: " + "{0:P0}" -f ($ChargeRem/100)

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
$template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText01)
#Convert to .NET type for XML manipuration
$toastXml = [xml] $template.GetXml()
$toastXml.GetElementsByTagName("text").AppendChild($toastXml.CreateTextNode($notificationTitle)) > $null

#Convert back to WinRT type
$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$xml.LoadXml($toastXml.OuterXml)

$toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
$toast.Tag = "PowerShell"
$toast.Group = "PowerShell"
$toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(5)
#$toast.SuppressPopup = $true
$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell")
$notifier.Show($toast);

}
Function CheckBatteryPercent{
#Battery Monitor Script 0.2
# based on http://www.rivnet.ro/2010/05/log-battery-and-power-levels-using-powershell.html
#-------------------------------
$batteryLogWarn =  15
#-------------------------------
#create custom event-log if it doesn't exist already
$condition = ((get-wmiobject -class "Win32_NTEventlogFile" | where {$_.LogFileName -like 'BatteryMonitor'} | measure-object ).count -eq '0')
if($condition) 
{'create event log' 
New-EventLog -Source BattMon -LogName BatteryMonitor}

    $PowstatMsg = $null
    $ChargeRemMsg = $null
  	$ChargeRem = $null
    $RemTimeMsg = $null

#create a Message object that we can add values to    
    $Message = ''
    $Message =  $Message | select-object *,PowStatMsg,ChargeRemMsg,RemTimeMsg
        
    $batt = Get-WmiObject -Class Win32_Battery
#1 means on battery, 2 on ac power
  If ($batt.BatteryStatus -like '1') {$Message.PowstatMsg = 'On_Battery'}
    elseif ($batt.BatteryStatus -like '2') {$Message.PowstatMsg = 'AC_Power'}

$ChargeRem = $batt.EstimatedChargeRemaining
$Message.ChargeRemMsg = "Charge Remaining : "+ $batt.EstimatedChargeRemaining
write-host $chargeRemMsg
$BatteryStatus =  $batt.BatteryStatus

if ($BatteryStatus -like '2') 
        {#AC Power
		$EventMsg = "$($Message.PowStatMsg), $($Message.ChargeRemMsg)"
	    Write-EventLog -LogName BatteryMonitor -Source BattMon -EventID 100 -Message $EventMsg -EntryType Information -ComputerName $env:computername -ErrorAction:SilentlyContinue}
	    elseif ($BatteryStatus -like '1') 
            {#Battery power
			 $EventMsg = "$($Message.PowStatMsg), $($Message.ChargeRemMsg)"
			  if ($ChargeRem -le $batteryLogWarn) 
                    {
                    ToastNotifcation
				    Write-EventLog -LogName BatteryMonitor -Source BattMon -EventID 200 -Message $EventMsg -EntryType Warning -ComputerName $env:computername -ErrorAction:SilentlyContinue
                    } 
                        else 
                        {
				        Write-EventLog -LogName BatteryMonitor -Source BattMon -EventID 200 -Message $EventMsg -EntryType Information -ComputerName $env:computername -ErrorAction:SilentlyContinue			
			            }
		        }
	   }
CheckBatteryPercent
