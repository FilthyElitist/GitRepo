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
        $srcCid = $srcCIDBox.Text 
        $srcCidLabel.Visible = $true
        write-host "updated src: " $srcCid
        Test-FindMbStudio $srcCIDBox.Text
        $srcCidLabel.Text += $($srcCIDBox.Text) + "`n" `
                                + "Found db short: " + $rs.StudioShort + "`n" `
                                + "Found db path: " + $rs.dbPath + "`n" `
                                + "Valid site: "  
        if ($rs.dbPath -eq $null) {$srcCidLabel.Text += "no"} else {$srcCidLabel.Text=+ "yes"}
        return $srcCid
})
$tabPageOne.controls.Add($goButton)

# BUILD TARGET LOOKUP
# Find target site's ID
$targetCidBox = New-Object System.Windows.Forms.TextBox
$targetCidBox.Width = 200
$targetCidBox.Height = 40
$targetCidBox.Location = New-Object System.Drawing.Point(15,160)
$tabPageOne.Controls.Add($targetCidBox)

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
        Test-FindMbStudio $targetCidBox.Text
        $targetCidLabel.Text += $($targetCidBox.Text) + "`n" `
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
        Run-SqlSource $clientsBak.Replace("@xxyyxx", $srcCIDBox.Text) -test
        Run-SqlSource $tblCcNumbersBak.Replace("@xxyyxx", $srcCIDBox.Text) -test
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
        Run-SqlSource $srcClientsTable.Replace("@xxyyxx", $srcCIDBox.Text) -test
        Run-SqlSource $srcCcNumbersTable.Replace("@xxyyxx", $srcCIDBox.Text) -test
        $createSourceButton.Text = "Source Tables Created"
        $createSourceButton.Enabled = $false
})
$tabPageThree.controls.Add($createSourceButton)

##################################
########### TAB FOUR  ##############
##################################

$backupTargetButton = New-Object system.windows.Forms.Button
$backupTargetButton.DataBindings.DefaultDataSourceUpdateMode = 0
$backupTargetButton.Text = "Create Backups"
$backupTargetButton.UseVisualStyleBackColor = $true
$backupTargetButton.Width = 200
$backupTargetButton.Height = 70
$backupTargetButton.location = new-object system.drawing.point(85,30)
$backupTargetButton.Add_Click({
        Run-SqlSource $clientsBak.Replace("@xxyyxx", $targetCidBox.Text) -test
        Run-SqlSource $tblCcNumbersBak.Replace("@xxyyxx", $targetCidBox.Text) -test
        $backupTargetButton.Text = "Backups Created"
        $backupTargetButton.Enabled = $false
        $prepareTargetButton.Enabled = $true
        #$createSourceButton.Enabled = $true
})
$tabPageFour.controls.Add($backupTargetButton)

$prepareTargetButton = New-Object system.windows.Forms.Button
$prepareTargetButton.DataBindings.DefaultDataSourceUpdateMode = 0
$prepareTargetButton.Text = "Update IDs to avoid overlap ja feel"
$prepareTargetButton.UseVisualStyleBackColor = $true
$prepareTargetButton.Width = 200
$prepareTargetButton.Height = 70
$prepareTargetButton.location = new-object system.drawing.point(85,230)
$prepareTargetButton.Add_Click({
        Run-SqlSource $overlapQuery.Replace("@xxyyxx", $srcCIDBox.Text).Replace("@xykk", $overlapUpdateNum) -test

        $overlapCount = (Run-SqlSource $overlapQuery.Replace("@xxyyxx", $srcCIDBox.Text).Replace("@xykk", $overlapUpdateNum) -test).Column1
        write-host "overlap: " $overlapCount
        $overlapCount = 500 #test
        while ($overlapCount -gt 0)
        {
            $overlapUpdateNum = [int]$overlapUpdateNum + 50000
            $overlapCount = (Run-SqlSource $overlapQuery.Replace("@xxyyxx", $srcCIDBox.Text).Replace("@xykk", $overlapUpdateNum) -test).Column1
            write-host "overlap: " $overlapCount
        }
        $prepareTargetButton.Text = "Prepared"
        $prepareTargetButton.Enabled = $false
})
$tabPageFour.controls.Add($prepareTargetButton)

[void]$Form.ShowDialog()
$Form.Dispose()

