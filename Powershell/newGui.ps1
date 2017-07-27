# Begin GUI
Add-Type -AssemblyName System.Windows.Forms

# Create Form
$Form = New-Object system.Windows.Forms.Form
$Form.Text = "Posh CCC" # Name of window
$Form.TopMost = $true # Force to top
$Form.Width = 700  
$Form.Height = 550

# Create Objects
$tabControl = New-object System.Windows.Forms.tabControl
$tabPageOne = New-Object System.Windows.Forms.TabPage
$tabPageTwo = New-Object System.Windows.Forms.TabPage
$tabPageThree = New-Object System.Windows.Forms.TabPage


#Tab Control 
$tabControl.DataBindings.DefaultDataSourceUpdateMode = 0
$tabControl.Width = 500
$tabControl.Height = 400
$tabControl.Location = New-Object System.Drawing.Point(20,25)
$tabControl.Name = "tabControl"
$Form.Controls.Add($tabControl)

#Memory Page
$tabPageOne.DataBindings.DefaultDataSourceUpdateMode = 0
$tabPageOne.UseVisualStyleBackColor = $True
$tabPageOne.Name = "tabPageOne"
$tabPageOne.Text = "tab one"
$tabControl.Controls.Add($tabPageOne)

#Test Page
$tabPageTwo.DataBindings.DefaultDataSourceUpdateMode = 0
$tabPageTwo.UseVisualStyleBackColor = $true
$tabPageTwo.Name = "tabPageTwo"
$tabPageTwo.Text = "tab two"
$tabControl.Controls.Add($tabPageTwo)


#Test Page
$tabPageThree.DataBindings.DefaultDataSourceUpdateMode = 0
$tabPageThree.UseVisualStyleBackColor = $true
$tabPageThree.Name = "tabPageTwo"
$tabPageThree.Text = "tab two"
$tabControl.Controls.Add($tabPageThree)


[void]$Form.ShowDialog()
$Form.Dispose()

