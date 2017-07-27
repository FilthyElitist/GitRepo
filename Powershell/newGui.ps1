# Begin GUI
Add-Type -AssemblyName System.Windows.Forms


# Create Form
$Form = New-Object system.Windows.Forms.Form
$Form.Text = "Posh CCC" # Name of window
$Form.TopMost = $true # Force to top
# Dimensions
$Form.Width = 600  
$Form.Height = 350




[void]$Form.ShowDialog()
$Form.Dispose()

