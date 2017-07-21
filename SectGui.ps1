Add-Type -AssemblyName System.Windows.forms

$form=New-Object System.Windows.Forms.Form

$b=New-Object System.Windows.Forms.Textbox
$b.Location='10,10'
$form.Controls.Add($b)

$b=New-Object System.Windows.Forms.Textbox
$b.Location='10,40'
$form.Controls.Add($b)


$form.ShowDialog()