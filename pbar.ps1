function Show-dd_psf {

	#----------------------------------------------
	#region Import the Assemblies
	#----------------------------------------------
	[void][reflection.assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	#endregion Import Assemblies

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$form1 = New-Object 'System.Windows.Forms.Form'
	$label1 = New-Object 'System.Windows.Forms.Label'
	$button1 = New-Object 'System.Windows.Forms.Button'
	$progressbar1 = New-Object 'System.Windows.Forms.ProgressBar'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	
	$form1_Load={
		$file = ''
		$progressbar1.Maximum = (Get-Item $file).length/1MB
		$progressbar1.Value = 0
		$timeout = new-timespan -Hours 6
	}
	
	$button1_Click={
		#TODO: Place custom script here
		$label1.Text = [String]$($($progressbar1.Value * 100) / $progressbar1.Maximum)
		
		while ($progressbar1.Value -lt $progressbar1.Maximum)
		{
			$progressbar1.Value = $progressbar1.Value + 50
			$label1.Text = [String]$($($progressbar1.Value * 100) / $progressbar1.Maximum)
			start-sleep -seconds 1
		}
	}
	
	# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$form1.WindowState = $InitialFormWindowState
	}
	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$button1.remove_Click($button1_Click)
			$form1.remove_Load($form1_Load)
			$form1.remove_Load($Form_StateCorrection_Load)
			$form1.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch { Out-Null <# Prevent PSScriptAnalyzer warning #> }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$form1.SuspendLayout()
	#
	# form1
	#
	$form1.Controls.Add($label1)
	$form1.Controls.Add($button1)
	$form1.Controls.Add($progressbar1)
	$form1.AutoScaleDimensions = New-Object System.Drawing.SizeF(6, 13)
	$form1.AutoScaleMode = 'Font'
	$form1.ClientSize = New-Object System.Drawing.Size(426, 60)
	$form1.Margin = '2, 2, 2, 2'
	$form1.Name = 'form1'
	$form1.Text = 'Form'
	$form1.add_Load($form1_Load)
	#
	# label1
	#
	$label1.AutoSize = $True
	$label1.Location = New-Object System.Drawing.Point(351, 37)
	$label1.Margin = '2, 0, 2, 0'
	$label1.Name = 'label1'
	$label1.Size = New-Object System.Drawing.Size(35, 13)
	$label1.TabIndex = 2
	$label1.Text = 'label1'
	#
	# button1
	#
	$button1.Location = New-Object System.Drawing.Point(35, 57)
	$button1.Name = 'button1'
	$button1.Size = New-Object System.Drawing.Size(75, 23)
	$button1.TabIndex = 1
	$button1.Text = 'button1'
	$button1.UseVisualStyleBackColor = $True
	$button1.add_Click($button1_Click)
	#
	# progressbar1
	#
	$progressbar1.Location = New-Object System.Drawing.Point(8, 8)
	$progressbar1.Name = 'progressbar1'
	$progressbar1.Size = New-Object System.Drawing.Size(413, 23)
	$progressbar1.TabIndex = 0
	$form1.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $form1.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$form1.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$form1.add_FormClosed($Form_Cleanup_FormClosed)
	#Show the Form
	$formSQLProgress.Show()
	
	
	[string]$dt = get-date -Format "yyyyMMdd"
	$oldFile = Get-Item 'G:\MSSQL_DATA\AxDB*Primary.mdf' -Exclude *$dt*
	$newFile = Get-Item G:\MSSQL_DATA\AxDB*$dt*Primary.mdf
	$sqlprogressbaroverlay.Maximum = (Get-Item $oldFile).length/1MB
	$sqlprogressbaroverlay.Value = 0
	[System.Windows.MessageBox]::Show($oldFile)
	[System.Windows.MessageBox]::Show($newFile)
	#[System.Windows.MessageBox]::Show($sqlprogressbaroverlay.Maximum)
	#[System.Windows.MessageBox]::Show(($newFile).length/1MB)
	$counter = 0
	while ($sqlprogressbaroverlay.Value -lt $sqlprogressbaroverlay.Maximum)
	{
		$counter += 1
		$label1.Text = $counter
		if (Test-Path -Path $newFile)
		{
			$newFile = Get-Item G:\MSSQL_DATA\AxDB*$dt*Primary.mdf
			$sqlprogressbaroverlay.Value = ($newFile).length/1MB
		}
		Start-Sleep -Seconds 8;
	}
} #End Function

#Call the form
Show-dd_psf | Out-Null
