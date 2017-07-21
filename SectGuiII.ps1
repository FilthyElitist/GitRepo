Add-Type -AssemblyName System.Windows.Forms

$Form = New-Object system.Windows.Forms.Form
$Form.Text = "Posh CCC"
$Form.TopMost = $true
$Form.Width = 600
$Form.Height = 350

$userSourceSiteId = New-Object system.windows.Forms.TextBox
$userSourceSiteId.Text = "Enter source site ID"
$userSourceSiteId.Width = 134
$userSourceSiteId.Height = 20
$userSourceSiteId.location = new-object system.drawing.point(10,20)
$userSourceSiteId.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($userSourceSiteId)


$button4 = New-Object system.windows.Forms.Button
$button4.Text = "go"
$button4.Width = 60
$button4.Height = 20
$button4.location = new-object system.drawing.point(160,18)
$button4.Font = "Microsoft Sans Serif,8"
$Form.controls.Add($button4)


[void]$Form.ShowDialog()
$Form.Dispose()