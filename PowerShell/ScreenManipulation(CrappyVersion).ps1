# Setup environment

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

Add-Type -MemberDefinition '[DllImport("user32.dll")] public static extern void mouse_event(int flags, int dx, int dy, int cButtons, int info);' -Name U32 -Namespace W;

<# Get cursor position on screen:

$X = [System.Windows.Forms.Cursor]::Position.X
$Y = [System.Windows.Forms.Cursor]::Position.Y
Write-Output "X: $X | Y: $Y"

# Explanation:
	# This denotes a single mouse click
	[W.U32]::mouse_event(6,0,0,0,0);

	# This denotes a hold mouse action
	[W.U32]::mouse_event(0x00000002, 0, 0, 0, 0);
	
	# This denotes depressing the hold action (effectively another click)
	[W.U32]::mouse_event(0x00000004, 0, 0, 0, 0);
#>

# Load authentication details into form

$x = 1246
$y = 406
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
Start-Sleep -Seconds 15
[W.U32]::mouse_event(6,0,0,0,0);

$x = 1218
$y = 429
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
Start-Sleep -Seconds 1
[W.U32]::mouse_event(6,0,0,0,0);

# Next mouse click to authenticate to xxx

$x = 1271
$y = 464
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
Start-Sleep -Seconds 7
[W.U32]::mouse_event(6,0,0,0,0);

#$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru

# Next mouse clicks to open dashboard

$x = 3585
$y = 98
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
Start-Sleep -Seconds 20
[W.U32]::mouse_event(6,0,0,0,0);

$x = 3408
$y = 172
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
#[W.U32]::mouse_event(6,0,0,0,0);
[W.U32]::mouse_event(0x00000002, 0, 0, 0, 0);
Start-Sleep -Seconds 1
[W.U32]::mouse_event(0x00000004, 0, 0, 0, 0);

$x = 3192
$y = 178
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
[W.U32]::mouse_event(0x00000002, 0, 0, 0, 0);
Start-Sleep -Seconds 1
[W.U32]::mouse_event(0x00000004, 0, 0, 0, 0);

# Maximise the dashboard
Start-Sleep -Seconds 5
[System.Windows.Forms.SendKeys]::SendWait("{F11}")
