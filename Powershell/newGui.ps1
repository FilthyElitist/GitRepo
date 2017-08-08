. "C:\Users\Keegan\AppData\Local\GitHubDesktop\app-0.6.2\GitRepo\Powershell\newFunction.ps1"
. "C:\Users\Keegan\AppData\Local\GitHubDesktop\app-0.6.2\GitRepo\Powershell\SqlVariables.ps1"

Clear-Host
# Begin GUI
Add-Type -AssemblyName System.Windows.Forms

# Create Form
$Form = New-Object system.Windows.Forms.Form
$Form.Text = "Posh CCC" 
$Form.TopMost = $true # Force to top
$Form.Width = 700  
$Form.Height = 550

# Create Tabs
$tabControl = New-object System.Windows.Forms.tabControl
$tabPageOne = New-Object System.Windows.Forms.TabPage
# $tabPageTwo = New-Object System.Windows.Forms.TabPage
$tabPageThree = New-Object System.Windows.Forms.TabPage
$tabPageFour = New-Object System.Windows.Forms.TabPage


#Tab Control 
$tabControl.DataBindings.DefaultDataSourceUpdateMode = 0
$tabControl.Width = 650
$tabControl.Height = 480
$tabControl.Location = New-Object System.Drawing.Point(20,25)
$tabControl.Name = "tabControl"
$form.Controls.Add($tabControl)
<## Make tabs active/inactive
$TabSizeMode = New-object System.Windows.Forms.TabSizeMode
$TabSizeMode = "Fixed"
$TabControl.SizeMode =$TabSizeMode
$TabControl.ItemSize = New-Object System.Drawing.Size(0,1)
$TabAppearance = New-object System.Windows.Forms.TabAppearance
$TabAppearance = "Buttons"
$TabControl.Appearance = $TabAppearance
$tabPageOne.BackColor = "White"
$tabPageTwo.BackColor = "Red"
#>
# Tab One
$tabPageOne.DataBindings.DefaultDataSourceUpdateMode = 0
$tabPageOne.UseVisualStyleBackColor = $True
$tabPageOne.Name = "tabPageOne"
$tabPageOne.Text = "Step One: Prepare"
$tabPageOne.TabIndex = 1
$tabPageFour.Enabled = $false
$tabControl.Controls.Add($tabPageOne)

<# Tab Two
$tabPageTwo.DataBindings.DefaultDataSourceUpdateMode = 0
$tabPageTwo.UseVisualStyleBackColor = $true
$tabPageTwo.Name = "tabPageTwo"
$tabPageTwo.Text = "Step Two: Choose Options"
$tabPageTwo.TabIndex = 2
$tabControl.Controls.Add($tabPageTwo)#>

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




##################################
########### TAB ONE ##############
##################################

# Find source site's ID
$srcCIDBox = New-Object System.Windows.Forms.TextBox
$srcCIDBox.Width = 200
$srcCIDBox.Height = 40
$srcCIDBox.Location = New-Object System.Drawing.Point(15,30)
$srcCID = $($srcCIDBox.Text)
$tabPageOne.Controls.Add($srcCIDBox)

# use Label to show status/relevant info. Good for troubleshooting
$srcCidLabel = New-Object System.Windows.Forms.Label
$srcCidLabel.Width = 200
$srcCidLabel.Height = 65
$srcCidLabel.Location = New-Object System.Drawing.Point(15,65)
$srcCidLabel.Font = "Microsoft Sans Serif,8"
$srcCidLabel.Visible = $false
$srcCidLabel.Text = "Entered CID: "
$tabPageOne.Controls.Add($srcCidLabel)

# Execute button
$goButton = New-Object system.windows.Forms.Button
$goButton.DataBindings.DefaultDataSourceUpdateMode = 0
$goButton.Text = "get source ID"
$goButton.UseVisualStyleBackColor = $true
$goButton.Width = 100
$goButton.Height = 30
$goButton.location = new-object system.drawing.point(250,30)
$goButton.Add_Click({
        $srcCidLabel.Visible = $true
        $srcCID = $($srcCIDBox.Text)
        Test-FindMbStudio $srcCIDBox.Text
        $srcCidLabel.Text += $($srcCIDBox.Text) + "`n" `
                                + "Found db short: " + $rs.StudioShort + "`n" `
                                + "Found db path: " + $rs.dbPath + "`n" `
                                + "Valid site: "  
        if ($rs.dbPath -eq $null) {$srcCidLabel.Text += "no"} else {$srcCidLabel.Text=+ "yes"}
})
$tabPageOne.controls.Add($goButton)

# BUILD TARGET LOOKUP
# Find target site's ID
$targetCID = New-Object System.Windows.Forms.TextBox
$targetCID.Width = 200
$targetCID.Height = 40
$targetCID.Location = New-Object System.Drawing.Point(15,160)
$tabPageOne.Controls.Add($targetCID)

# use Label to show status/relevant info. Good for troubleshooting
$targetCidLabel = New-Object System.Windows.Forms.Label
$targetCidLabel.Width = 200
$targetCidLabel.Height = 225
$targetCidLabel.Location = New-Object System.Drawing.Point(15,225)
$targetCidLabel.Font = "Microsoft Sans Serif,8"
$targetCidLabel.Visible = $false
$targetCidLabel.Text = "Entered CID: "
$tabPageOne.Controls.Add($targetCidLabel)

# Execute button
$goButtonTgt = New-Object system.windows.Forms.Button
$goButtonTgt.DataBindings.DefaultDataSourceUpdateMode = 0
$goButtonTgt.Text = "get target ID"
$goButtonTgt.UseVisualStyleBackColor = $true
$goButtonTgt.Width = 100
$goButtonTgt.Height = 30
$goButtonTgt.location = new-object system.drawing.point(250,160)
$goButtonTgt.Add_Click({
        $targetCidLabel.Visible = $true
        Test-FindMbStudio $targetCID.Text
        $targetCidLabel.Text += $($targetCid.Text) + "`n" `
                                + "Found db short: " + $rs.StudioShort + "`n" `
                                + "Found db path: " + $rs.dbPath + "`n" `
                                + "Valid site: "  
        if ($rs.dbPath -eq $null) {$targetCidLabel.Text += "no"} else {$targetCidLabel.Text=+ "yes"}
})
$tabPageOne.controls.Add($goButtonTgt)


##################################
########### TAB THREE ##############
##################################


$backupSourceButton = New-Object system.windows.Forms.Button
$backupSourceButton.DataBindings.DefaultDataSourceUpdateMode = 0
$backupSourceButton.Text = "Create Backups"
$backupSourceButton.UseVisualStyleBackColor = $true
$backupSourceButton.Width = 200
$backupSourceButton.Height = 70
$backupSourceButton.location = new-object system.drawing.point(85,30)
$backupSourceButton.Add_Click({
        Run-SqlSource $clientsBak -test
        Run-SqlSource $tblCcNumbersBak -test
        $backupSourceButton.Text = "Backups Created"
        $backupSourceButton.Enabled = $false
        $createSourceButton.Enabled = $true
})
$tabPageThree.controls.Add($backupSourceButton)


$createSourceButton = New-Object system.windows.Forms.Button
$createSourceButton.DataBindings.DefaultDataSourceUpdateMode = 0
$createSourceButton.Text = "Create Source Tables"
$createSourceButton.UseVisualStyleBackColor = $true
$createSourceButton.Enabled = $false
$createSourceButton.Width = 200
$createSourceButton.Height = 70
$createSourceButton.location = new-object system.drawing.point(85,230)
$createSourceButton.Add_Click({
        Run-SqlSource $srcClientsTable -test
        Run-SqlSource $srcCcNumbersTable -test
        $createSourceButton.Text = "Source Tables Created"
        $createSourceButton.Enabled = $false
})
$tabPageThree.controls.Add($createSourceButton)

[void]$Form.ShowDialog()
$Form.Dispose()

