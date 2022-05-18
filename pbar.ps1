Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$jobScript =
{
    Start-Sleep -Seconds 20
}


function Extract() {
    $ProgressBar = New-Object System.Windows.Forms.ProgressBar
    $ProgressBar.Location = New-Object System.Drawing.Point(10, 35)
    $ProgressBar.Size = New-Object System.Drawing.Size(460, 40)
    $ProgressBar.Style = "Marquee"
    $ProgressBar.MarqueeAnimationSpeed = 20

    $main_form.Controls.Add($ProgressBar);

    $Label.Font = $procFont
    $Label.ForeColor = 'red'
    $Label.Text = "Processing ..."
    $ProgressBar.visible

    $job = Start-Job -ScriptBlock $jobScript
    do { [System.Windows.Forms.Application]::DoEvents() } until ($job.State -eq "Completed")
    Remove-Job -Job $job -Force


    $Label.Text = "Process Complete"
    $ProgressBar.Hide()
    $StartButton.Hide()
    $EndButton.Visible
}

$main_form = New-Object System.Windows.Forms.Form
$main_form.Text = 'Subtitle Software Suite'
$main_form.BackColor = 'cyan'
$main_form.Width = 520
$main_form.Height = 180

$header = New-Object System.Drawing.Font("Verdana", 13, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$procFont = New-Object System.Drawing.Font("Verdana", 20, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$Label = New-Object System.Windows.Forms.Label
$Label.Font = $header
$Label.ForeColor = 'blue'
$Label.Text = "Audio extraction can take a long time"
$Label.Location = New-Object System.Drawing.Point(10, 10)
$Label.Width = 480
$Label.Height = 50

$StartButton = New-Object System.Windows.Forms.Button
$StartButton.Location = New-Object System.Drawing.Size(350, 75)
$StartButton.Size = New-Object System.Drawing.Size(120, 50)
$StartButton.Text = "Start"
$StartButton.height = 40
$StartButton.BackColor = 'red'
$StartButton.ForeColor = 'white'
$StartButton.Add_click( { EXTRACT });

$EndButton = New-Object System.Windows.Forms.Button
$EndButton.Location = New-Object System.Drawing.Size(350, 75)
$EndButton.Size = New-Object System.Drawing.Size(120, 50)
$EndButton.Text = "OK"
$EndButton.height = 40
$EndButton.BackColor = 'red'
$EndButton.ForeColor = 'white'
$EndButton.DialogResult = [System.Windows.Forms.DialogResult]::OK

$main_form.Controls.AddRange(($Label, $StartButton, $EndButton))

$main_form.StartPosition = "manual"
$main_form.Location = New-Object System.Drawing.Size(500, 300)
$result = $main_form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $main_form.Close()
}
