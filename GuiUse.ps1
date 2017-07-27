function Test-Function
    {
        PARAM ($siteID)
        Write-output $siteID
    }


Add-Type -AssemblyName System.Windows.Forms

$Form = New-Object system.Windows.Forms.Form
$Form.Text = "Posh CCC"
$Form.TopMost = $true
$Form.Width = 600
$Form.Height = 350

$userSourceIdBox = New-Object system.windows.Forms.TextBox
$userSourceIdBox.Text = "Enter source site ID"
$userSourceIdBox.Width = 200
$userSourceIdBox.Height = 20
$userSourceIdBox.location = new-object system.drawing.point(10,20)
$userSourceIdBox.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($userSourceIdBox)
$userSourceIdBox.Add_Click({
#add here code triggered by the event
$userSourceIdBox.Text = ''
})

$userGoButton = New-Object system.windows.Forms.Button
$userGoButton.Text = "go"
$userGoButton.Width = 60
$userGoButton.Height = 25
$userGoButton.location = new-object system.drawing.point(220,16)
$userGoButton.Font = "Microsoft Sans Serif,8"
$Form.controls.Add($userGoButton)
$userGoButton.Add_Click({
    write-output "it works" #Test-Function $userSourceIdBox
})


$userTargetIdBox = New-Object system.windows.Forms.TextBox
$userTargetIdBox.Text = "Enter source site ID"
$userTargetIdBox.Width = 200
$userTargetIdBox.Height = 20
$userTargetIdBox.location = new-object system.drawing.point(10,80)
$userTargetIdBox.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($userTargetIdBox)
$userTargetIdBox.Add_Click({
#add here code triggered by the event
$userTargetIdBox.Text = ''
})


$userGoButton = New-Object system.windows.Forms.Button
$userGoButton.Text = "go"
$userGoButton.Width = 60
$userGoButton.Height = 25
$userGoButton.location = new-object system.drawing.point(220,80)
$userGoButton.Font = "Microsoft Sans Serif,8"
$Form.controls.Add($userGoButton)




[void]$Form.ShowDialog()
$Form.Dispose()

Test-Function $userSourceIdBox.Text