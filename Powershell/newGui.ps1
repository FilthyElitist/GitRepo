. "C:\Users\Keegan\AppData\Local\GitHubDesktop\app-0.6.2\GitRepo\Powershell\newFunction.ps1"
. "C:\Users\Keegan\AppData\Local\GitHubDesktop\app-0.6.2\GitRepo\Powershell\SqlVariables.ps1"

Clear-Host
# Begin GUI
Add-Type -AssemblyName System.Windows.Forms

# Create Form
$Form = New-Object system.Windows.Forms.Form
$Form.Text = "Posh CCC" # Name of window
$Form.TopMost = $true # Force to top
$Form.Width = 700  
$Form.Height = 550

# Create Tabs
$tabControl = New-object System.Windows.Forms.tabControl
$tabPageOne = New-Object System.Windows.Forms.TabPage
$tabPageTwo = New-Object System.Windows.Forms.TabPage
$tabPageThree = New-Object System.Windows.Forms.TabPage
$tabPageFour = New-Object System.Windows.Forms.TabPage


#Tab Control 
$tabControl.DataBindings.DefaultDataSourceUpdateMode = 0
$tabControl.Width = 650
$tabControl.Height = 480
$tabControl.Location = New-Object System.Drawing.Point(20,25)
$tabControl.Name = "tabControl"
$form.Controls.Add($tabControl)


# Tab One
$tabPageOne.DataBindings.DefaultDataSourceUpdateMode = 0
$tabPageOne.UseVisualStyleBackColor = $True
$tabPageOne.Name = "tabPageOne"
$tabPageOne.Text = "Step One: Prepare"
$tabPageOne.TabIndex = 1
$tabControl.Controls.Add($tabPageOne)

# Tab Two
$tabPageTwo.DataBindings.DefaultDataSourceUpdateMode = 0
$tabPageTwo.UseVisualStyleBackColor = $true
$tabPageTwo.Name = "tabPageTwo"
$tabPageTwo.Text = "Step Two: Choose Options"
$tabPageTwo.TabIndex = 2
$tabControl.Controls.Add($tabPageTwo)


# Tab Three
$tabPageThree.DataBindings.DefaultDataSourceUpdateMode = 0
$tabPageThree.UseVisualStyleBackColor = $true
$tabPageThree.Name = "tabPageThree"
$tabPageThree.Text = "Step Three: Make Source Table"
$tabPageThree.TabIndex = 3
$tabControl.Controls.Add($tabPageThree)

# Tab Four
$tabPageFour.DataBindings.DefaultDataSourceUpdateMode = 0
$tabPageFour.UseVisualStyleBackColor = $true
$tabPageFour.Name = "tabPageFour"
$tabPageFour.Text = "Step Four: Insert into Destination"
$tabPageFour.TabIndex = 4
$tabControl.Controls.Add($tabPageFour)


$srcCID = New-Object System.Windows.Forms.TextBox
$srcCID.Width = 200
$srcCID.Height = 40
$srcCID.Location = New-Object System.Drawing.Point(15,30)
$tabPageOne.Controls.Add($srcCID)

$srcCidLabel = New-Object System.Windows.Forms.Label
$srcCidLabel.Width = 200
$srcCidLabel.Height = 160
$srcCidLabel.Location = New-Object System.Drawing.Point(15,65)
$srcCidLabel.Font = "Microsoft Sans Serif,8"
$srcCidLabel.Visible = $false
$srcCidLabel.Text = "Entered CID: "
$tabPageOne.Controls.Add($srcCidLabel)


$goButton = New-Object system.windows.Forms.Button
$goButton.DataBindings.DefaultDataSourceUpdateMode = 0
$goButton.Text = "get source ID"
$goButton.UseVisualStyleBackColor = $true
$goButton.Width = 100
$goButton.Height = 30
$goButton.location = new-object system.drawing.point(250,30)
#$goButton.Font = "Microsoft Sans Serif,10"
$goButton.Add_Click({
        $srcCidLabel.Visible = $true
        Test-FindMbStudio $srcCID.Text
        $srcCidLabel.Text += $($srcCid.Text) + "`n" `
                                + "Found db short: " + $rs.StudioShort + "`n" `
                                + "Found db path: " + $rs.dbPath + "`n" `
                                + "Valid site: "  
        if ($rs.dbPath -eq $null) {$srcCidLabel.Text += "no"} else {$srcCidLabel.Text=+ "yes"}
})
$tabPageOne.controls.Add($goButton)




[void]$Form.ShowDialog()
$Form.Dispose()

