function Show-bar_psf {

	#----------------------------------------------
	#region Import the Assemblies
	#----------------------------------------------
	[void][reflection.assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	[void][reflection.assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	#endregion Import Assemblies

	#----------------------------------------------
	#region Define SAPIEN Types
	#----------------------------------------------
	try{
		[ProgressBarOverlay] | Out-Null
	}
	catch
	{
        if ($PSVersionTable.PSVersion.Major -ge 7)
		{
			$Assemblies = 'System.Windows.Forms', 'System.Drawing', 'System.Drawing.Primitives', 'System.ComponentModel.Primitives', 'System.Drawing.Common', 'System.Runtime'
            if ($PSVersionTable.PSVersion.Minor -ge 1)
			{
				$Assemblies += 'System.Windows.Forms.Primitives'
			}
		}
		else
		{
			$Assemblies = 'System.Windows.Forms', 'System.Drawing'  

        }
		Add-Type -ReferencedAssemblies $Assemblies -TypeDefinition @"
		using System;
		using System.Windows.Forms;
		using System.Drawing;
        namespace SAPIENTypes
        {
		    public class ProgressBarOverlay : System.Windows.Forms.ProgressBar
	        {
                public ProgressBarOverlay() : base() { SetStyle(ControlStyles.OptimizedDoubleBuffer | ControlStyles.AllPaintingInWmPaint, true); }
	            protected override void WndProc(ref Message m)
	            { 
	                base.WndProc(ref m);
	                if (m.Msg == 0x000F)// WM_PAINT
	                {
	                    if (Style != System.Windows.Forms.ProgressBarStyle.Marquee || !string.IsNullOrEmpty(this.Text))
                        {
                            using (Graphics g = this.CreateGraphics())
                            {
                                using (StringFormat stringFormat = new StringFormat(StringFormatFlags.NoWrap))
                                {
                                    stringFormat.Alignment = StringAlignment.Center;
                                    stringFormat.LineAlignment = StringAlignment.Center;
                                    if (!string.IsNullOrEmpty(this.Text))
                                        g.DrawString(this.Text, this.Font, Brushes.Black, this.ClientRectangle, stringFormat);
                                    else
                                    {
                                        int percent = (int)(((double)Value / (double)Maximum) * 100);
                                        g.DrawString(percent.ToString() + "%", this.Font, Brushes.Black, this.ClientRectangle, stringFormat);
                                    }
                                }
                            }
                        }
	                }
	            }
              
                public string TextOverlay
                {
                    get
                    {
                        return base.Text;
                    }
                    set
                    {
                        base.Text = value;
                        Invalidate();
                    }
                }
	        }
        }
"@ -IgnoreWarnings | Out-Null
	}
	#endregion Define SAPIEN Types

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$formSQLProgress = New-Object 'System.Windows.Forms.Form'
	$label1 = New-Object 'System.Windows.Forms.Label'
	$sqlprogressbaroverlay = New-Object 'SAPIENTypes.ProgressBarOverlay'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	$formSQLProgress_Load={
		#TODO: Initialize Form Controls here
		Set-ControlTheme $formSQLProgress -Theme Dark
	}
	
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$formSQLProgress.WindowState = $InitialFormWindowState
	}
	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$formSQLProgress.remove_Load($formSQLProgress_Load)
			$formSQLProgress.remove_Load($Form_StateCorrection_Load)
			$formSQLProgress.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch { Out-Null <# Prevent PSScriptAnalyzer warning #> }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$formSQLProgress.SuspendLayout()
	#
	# formSQLProgress
	#
	$formSQLProgress.Controls.Add($label1)
	$formSQLProgress.Controls.Add($sqlprogressbaroverlay)
	$formSQLProgress.AutoScaleDimensions = New-Object System.Drawing.SizeF(10, 20)
	$formSQLProgress.AutoScaleMode = 'Font'
	$formSQLProgress.ClientSize = New-Object System.Drawing.Size(684, 60)
	$formSQLProgress.Name = 'formSQLProgress'
	$formSQLProgress.Text = 'SQL Progress'
	$formSQLProgress.add_Load($formSQLProgress_Load)
	#
	# label1
	#
	$label1.AutoSize = $True
	$label1.Location = New-Object System.Drawing.Point(622, 21)
	$label1.Margin = '5, 0, 5, 0'
	$label1.Name = 'label1'
	$label1.Size = New-Object System.Drawing.Size(53, 20)
	$label1.TabIndex = 1
	$label1.Text = 'label1'
	#
	# sqlprogressbaroverlay
	#
	$sqlprogressbaroverlay.Location = New-Object System.Drawing.Point(14, 14)
	$sqlprogressbaroverlay.Margin = '2, 2, 2, 2'
	$sqlprogressbaroverlay.Name = 'sqlprogressbaroverlay'
	$sqlprogressbaroverlay.Size = New-Object System.Drawing.Size(600, 35)
	$sqlprogressbaroverlay.TabIndex = 0
	$formSQLProgress.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------
	Add-Type -AssemblyName PresentationCore,PresentationFramework
	#Save the initial state of the form
	$InitialFormWindowState = $formSQLProgress.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$formSQLProgress.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$formSQLProgress.add_FormClosed($Form_Cleanup_FormClosed)
	#Show the Form
	$formSQLProgress.Show()
	
	
	[string]$dt = get-date -Format "yyyyMMdd"
	#$oldFile = Get-Item 'G:\MSSQL_DATA\AxDB*Primary.mdf'
	
	$oldFile = Get-Item G:\MSSQL_DATA\AxDB_20220517_Primary.mdf -Exclude AxDB_$dt_Primary.mdf
	#$newFile = Get-Item G:\MSSQL_DATA\AxDB*$dt*Primary.mdf
	$newFile = "‪G:\MSSQL_DATA\AxDB_20220521_Primary.mdf"
	
	$sqlprogressbaroverlay.Maximum = (Get-Item $oldFile).length/1MB
	$sqlprogressbaroverlay.Value = 0
	#[System.Windows.MessageBox]::Show($oldFile)
	#[System.Windows.MessageBox]::Show($sqlprogressbaroverlay.Maximum)
	[System.Windows.MessageBox]::Show($newFile)
	
	while ($sqlprogressbaroverlay.Value -lt $sqlprogressbaroverlay.Maximum)
	{
		
		if (Test-Path -Path $newFile)
		{
			$sqlprogressbaroverlay.Value = (Get-Item $newFile).length/1MB
		}
		Start-Sleep -Seconds 8;
	}
	
} #End Function

#Call the form
Show-bar_psf | Out-Null

