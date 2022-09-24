
function Show-dbRefreshv2_psf {

	#----------------------------------------------
	#region Import the Assemblies
	#----------------------------------------------
	[void][reflection.assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
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
	$formDatabaseRefreshFromB = New-Object 'System.Windows.Forms.Form'
	$button7 = New-Object 'System.Windows.Forms.Button'
	$button6 = New-Object 'System.Windows.Forms.Button'
	$labelFile = New-Object 'System.Windows.Forms.Label'
	$buttonDBRecoveryModel = New-Object 'System.Windows.Forms.Button'
	$buttonRunDatabaseSync = New-Object 'System.Windows.Forms.Button'
	$button5 = New-Object 'System.Windows.Forms.Button'
	$button4 = New-Object 'System.Windows.Forms.Button'
	$buttonListOutUserEmails = New-Object 'System.Windows.Forms.Button'
	$button3 = New-Object 'System.Windows.Forms.Button'
	$button1 = New-Object 'System.Windows.Forms.Button'
	$buttonEnableSQLTracking = New-Object 'System.Windows.Forms.Button'
	$buttonCleanUpPowerBI = New-Object 'System.Windows.Forms.Button'
	$button2 = New-Object 'System.Windows.Forms.Button'
	$buttonPauseBatchJobs = New-Object 'System.Windows.Forms.Button'
	$buttonTruncateBatchTables = New-Object 'System.Windows.Forms.Button'
	$buttonEnableUsers = New-Object 'System.Windows.Forms.Button'
	$buttonAddSysAdminUser = New-Object 'System.Windows.Forms.Button'
	$textbox1 = New-Object 'System.Windows.Forms.TextBox'
	$labelSysAdmin = New-Object 'System.Windows.Forms.Label'
	$buttonAdminEmailAdd = New-Object 'System.Windows.Forms.Button'
	$labelMain = New-Object 'System.Windows.Forms.Label'
	$checkbox5 = New-Object 'System.Windows.Forms.CheckBox'
	$checkbox4 = New-Object 'System.Windows.Forms.CheckBox'
	$checkbox3 = New-Object 'System.Windows.Forms.CheckBox'
	$checkbox2 = New-Object 'System.Windows.Forms.CheckBox'
	$checkbox1 = New-Object 'System.Windows.Forms.CheckBox'
	$labellog = New-Object 'System.Windows.Forms.Label'
	$mainprogressbaroverlay = New-Object 'SAPIENTypes.ProgressBarOverlay'
	$checkboxDBRecoveryModel = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxTruncateBatchTables = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxEnableUsers = New-Object 'System.Windows.Forms.CheckBox'
	$buttonRun = New-Object 'System.Windows.Forms.Button'
	$checkboxListOutUserEmails = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxRunDatabaseSync = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxCleanUpPowerBI = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxEnableSQLTracking = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxPauseBatchJobs = New-Object 'System.Windows.Forms.CheckBox'
	$textboxAdminEmailAddress = New-Object 'System.Windows.Forms.TextBox'
	$buttonAdd = New-Object 'System.Windows.Forms.Button'
	$txtFile = New-Object 'System.Windows.Forms.TextBox'
	$txtLink = New-Object 'System.Windows.Forms.TextBox'
	$labelSASLink = New-Object 'System.Windows.Forms.Label'
	$labelAdminEmail = New-Object 'System.Windows.Forms.Label'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	
	$formDatabaseRefreshFromB_Load={
		#TODO: Initialize Form Controls here
		Set-ControlTheme $formDatabaseRefreshFromB -Theme Dark
	}
	
	
	#region Control Theme Helper Function
	<#
		.SYNOPSIS
			Applies a theme to the control and its children.
		
		.PARAMETER Control
			The control to theme. Usually the form itself.
		
		.PARAMETER Theme
			The color theme:
			Light
			Dark
	
		.PARAMETER CustomColor
			A hashtable that contains the color values.
			Keys:
			WindowColor
			ContainerColor
			BackColor
			ForeColor
			BorderColor
			SelectionForeColor
			SelectionBackColor
			MenuSelectionColor
		.EXAMPLE
			PS C:\> Set-ControlTheme -Control $form1 -Theme Dark
		
		.EXAMPLE
			PS C:\> Set-ControlTheme -Control $form1 -CustomColor @{ WindowColor = 'White'; ContainerBackColor = 'Gray'; BackColor... }
		.NOTES
			Created by SAPIEN Technologies, Inc.
	#>
	function Set-ControlTheme
	{
		[CmdletBinding()]
		param
		(
			[Parameter(Mandatory = $true)]
			[ValidateNotNull()]
			[System.ComponentModel.Component]$Control,
			[ValidateSet('Light', 'Dark')]
			[string]$Theme = 'Dark',
			[System.Collections.Hashtable]$CustomColor
		)
		
		$Font = [System.Drawing.Font]::New('Segoe UI', 9)
		
		#Initialize the colors
		if ($Theme -eq 'Dark')
		{
			$WindowColor = [System.Drawing.Color]::FromArgb(32, 32, 32)
			$ContainerColor = [System.Drawing.Color]::FromArgb(45, 45, 45)
			$BackColor = [System.Drawing.Color]::FromArgb(32, 32, 32)
			$ForeColor = [System.Drawing.Color]::White
			$BorderColor = [System.Drawing.Color]::DimGray
			$SelectionBackColor = [System.Drawing.SystemColors]::Highlight
			$SelectionForeColor = [System.Drawing.Color]::White
			$MenuSelectionColor = [System.Drawing.Color]::DimGray
		}
		
		
		if ($CustomColor)
		{
			#Check and Validate the custom colors:
			$Color = $CustomColor.WindowColor -as [System.Drawing.Color]
			if ($Color) { $WindowColor = $Color }
			$Color = $CustomColor.ContainerColor -as [System.Drawing.Color]
			if ($Color) { $ContainerColor = $Color }
			$Color = $CustomColor.BackColor -as [System.Drawing.Color]
			if ($Color) { $BackColor = $Color }
			$Color = $CustomColor.ForeColor -as [System.Drawing.Color]
			if ($Color) { $ForeColor = $Color }
			$Color = $CustomColor.BorderColor -as [System.Drawing.Color]
			if ($Color) { $BorderColor = $Color }
			$Color = $CustomColor.SelectionBackColor -as [System.Drawing.Color]
			if ($Color) { $SelectionBackColor = $Color }
			$Color = $CustomColor.SelectionForeColor -as [System.Drawing.Color]
			if ($Color) { $SelectionForeColor = $Color }
			$Color = $CustomColor.MenuSelectionColor -as [System.Drawing.Color]
			if ($Color) { $MenuSelectionColor = $Color }
		}
		
		#Define the custom renderer for the menus
		#region Add-Type definition
		try
		{
			[SAPIENTypes.SAPIENColorTable] | Out-Null
		}
		catch
		{
			if ($PSVersionTable.PSVersion.Major -ge 7)
			{
				$Assemblies = 'System.Windows.Forms', 'System.Drawing', 'System.Drawing.Primitives'
			}
			else
			{
				$Assemblies = 'System.Windows.Forms', 'System.Drawing'
			}
			Add-Type -ReferencedAssemblies $Assemblies -TypeDefinition "
using System;
using System.Windows.Forms;
using System.Drawing;
namespace SAPIENTypes
{
    public class SAPIENColorTable : ProfessionalColorTable
    {
        Color ContainerBackColor;
        Color BackColor;
        Color BorderColor;
		Color SelectBackColor;

        public SAPIENColorTable(Color containerColor, Color backColor, Color borderColor, Color selectBackColor)
        {
            ContainerBackColor = containerColor;
            BackColor = backColor;
            BorderColor = borderColor;
			SelectBackColor = selectBackColor;
        } 
		public override Color MenuStripGradientBegin { get { return ContainerBackColor; } }
        public override Color MenuStripGradientEnd { get { return ContainerBackColor; } }
        public override Color ToolStripBorder { get { return BorderColor; } }
        public override Color MenuItemBorder { get { return SelectBackColor; } }
        public override Color MenuItemSelected { get { return SelectBackColor; } }
        public override Color SeparatorDark { get { return BorderColor; } }
        public override Color ToolStripDropDownBackground { get { return BackColor; } }
        public override Color MenuBorder { get { return BorderColor; } }
        public override Color MenuItemSelectedGradientBegin { get { return SelectBackColor; } }
        public override Color MenuItemSelectedGradientEnd { get { return SelectBackColor; } }      
        public override Color MenuItemPressedGradientBegin { get { return ContainerBackColor; } }
        public override Color MenuItemPressedGradientEnd { get { return ContainerBackColor; } }
        public override Color MenuItemPressedGradientMiddle { get { return ContainerBackColor; } }
        public override Color ImageMarginGradientBegin { get { return BackColor; } }
        public override Color ImageMarginGradientEnd { get { return BackColor; } }
        public override Color ImageMarginGradientMiddle { get { return BackColor; } }
    }
}"
		}
		#endregion
		
		$colorTable = New-Object SAPIENTypes.SAPIENColorTable -ArgumentList $ContainerColor, $BackColor, $BorderColor, $MenuSelectionColor
		$render = New-Object System.Windows.Forms.ToolStripProfessionalRenderer -ArgumentList $colorTable
		[System.Windows.Forms.ToolStripManager]::Renderer = $render
		
		#Set up our processing queue
		$Queue = New-Object System.Collections.Generic.Queue[System.ComponentModel.Component]
		$Queue.Enqueue($Control)
		
		Add-Type -AssemblyName System.Core
		
		#Only process the controls once.
		$Processed = New-Object System.Collections.Generic.HashSet[System.ComponentModel.Component]
		
		#Apply the colors to the controls
		while ($Queue.Count -gt 0)
		{
			$target = $Queue.Dequeue()
			
			#Skip controls we already processed
			if ($Processed.Contains($target)) { continue }
			$Processed.Add($target)
			
			#Set the text color
			$target.ForeColor = $ForeColor
			
			#region Handle Controls
			if ($target -is [System.Windows.Forms.Form])
			{
				#Set Font
				$target.Font = $Font
				$target.BackColor = $ContainerColor
			}
			elseif ($target -is [System.Windows.Forms.SplitContainer])
			{
				$target.BackColor = $BorderColor
			}
			elseif ($target -is [System.Windows.Forms.PropertyGrid])
			{
				$target.BackColor = $BorderColor
				$target.ViewBackColor = $BackColor
				$target.ViewForeColor = $ForeColor
				$target.ViewBorderColor = $BorderColor
				$target.CategoryForeColor = $ForeColor
				$target.CategorySplitterColor = $ContainerColor
				$target.HelpBackColor = $BackColor
				$target.HelpForeColor = $ForeColor
				$target.HelpBorderColor = $BorderColor
				$target.CommandsBackColor = $BackColor
				$target.CommandsBorderColor = $BorderColor
				$target.CommandsForeColor = $ForeColor
				$target.LineColor = $ContainerColor
			}
			elseif ($target -is [System.Windows.Forms.ContainerControl] -or
				$target -is [System.Windows.Forms.Panel])
			{
				#Set the BackColor for the container
				$target.BackColor = $ContainerColor
				
			}
			elseif ($target -is [System.Windows.Forms.GroupBox])
			{
				$target.FlatStyle = 'Flat'
			}
			elseif ($target -is [System.Windows.Forms.Button])
			{
				$target.FlatStyle = 'Flat'
				$target.FlatAppearance.BorderColor = $BorderColor
				$target.BackColor = $BackColor
			}
			elseif ($target -is [System.Windows.Forms.CheckBox] -or
				$target -is [System.Windows.Forms.RadioButton] -or
				$target -is [System.Windows.Forms.Label])
			{
				#$target.FlatStyle = 'Flat'
			}
			elseif ($target -is [System.Windows.Forms.ComboBox])
			{
				$target.BackColor = $BackColor
				$target.FlatStyle = 'Flat'
			}
			elseif ($target -is [System.Windows.Forms.TextBox])
			{
				$target.BorderStyle = 'FixedSingle'
				$target.BackColor = $BackColor
			}
			elseif ($target -is [System.Windows.Forms.DataGridView])
			{
				$target.GridColor = $BorderColor
				$target.BackgroundColor = $ContainerColor
				$target.DefaultCellStyle.BackColor = $WindowColor
				$target.DefaultCellStyle.SelectionBackColor = $SelectionBackColor
				$target.DefaultCellStyle.SelectionForeColor = $SelectionForeColor
				$target.ColumnHeadersDefaultCellStyle.BackColor = $ContainerColor
				$target.ColumnHeadersDefaultCellStyle.ForeColor = $ForeColor
				$target.EnableHeadersVisualStyles = $false
				$target.ColumnHeadersBorderStyle = 'Single'
				$target.RowHeadersBorderStyle = 'Single'
				$target.RowHeadersDefaultCellStyle.BackColor = $ContainerColor
				$target.RowHeadersDefaultCellStyle.ForeColor = $ForeColor
				
			}
			elseif ($PSVersionTable.PSVersion.Major -le 5 -and $target -is [System.Windows.Forms.DataGrid])
			{
				$target.CaptionBackColor = $WindowColor
				$target.CaptionForeColor = $ForeColor
				$target.BackgroundColor = $ContainerColor
				$target.BackColor = $WindowColor
				$target.ForeColor = $ForeColor
				$target.HeaderBackColor = $ContainerColor
				$target.HeaderForeColor = $ForeColor
				$target.FlatMode = $true
				$target.BorderStyle = 'FixedSingle'
				$target.GridLineColor = $BorderColor
				$target.AlternatingBackColor = $ContainerColor
				$target.SelectionBackColor = $SelectionBackColor
				$target.SelectionForeColor = $SelectionForeColor
			}
			elseif ($target -is [System.Windows.Forms.ToolStrip])
			{
				
				$target.BackColor = $BackColor
				$target.Renderer = $render
				
				foreach ($item in $target.Items)
				{
					$Queue.Enqueue($item)
				}
			}
			elseif ($target -is [System.Windows.Forms.ToolStripMenuItem] -or
				$target -is [System.Windows.Forms.ToolStripDropDown] -or
				$target -is [System.Windows.Forms.ToolStripDropDownItem])
			{
				$target.BackColor = $BackColor
				foreach ($item in $target.DropDownItems)
				{
					$Queue.Enqueue($item)
				}
			}
			elseif ($target -is [System.Windows.Forms.ListBox] -or
				$target -is [System.Windows.Forms.ListView] -or
				$target -is [System.Windows.Forms.TreeView])
			{
				$target.BackColor = $WindowColor
			}
			else
			{
				$target.BackColor = $BackColor
			}
			#endregion
			
			if ($target -is [System.Windows.Forms.Control])
			{
				#Queue all the child controls
				foreach ($child in $target.Controls)
				{
					$Queue.Enqueue($child)
				}
			}
		}
	}
	#endregion
	$f = ''
	$Stamp = (Get-Date).toString("yyyy-MM-dd")
	$Logfile = "C:\Users\$env:UserName\DBRefresh_$env:computername_$Stamp.log"
	$txtLink_TextChanged = {
		$txtFile.Text = ''
	}
	
	$txtFile_TextChanged = {
		$txtLink.Text = ''
	}
	
	
	
	$buttonAdd_Click = {
		$txtFile.Visible = $true
		$labelBacBakFileLocation.Visible = $true
		Add-Type -AssemblyName System.Windows.Forms
		$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
		$FileBrowser.ShowDialog()
		$txtFile.Text = $FileBrowser.FileName
	}
	
	
	function WriteLog
	{
		Param ([string]$LogString)
		$Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
		Write-Host "$LogString ($Stamp)" -ForegroundColor Yellow
		$labellog.Text = "$LogString ($Stamp)"
		$LogMessage = "$Stamp - $LogString"
		Add-content $LogFile -value $LogMessage 
		Return $LogString
	}
	
	function count-checkbox
	{
		if ($checkboxBackupCompletedAxDB.Checked) { $mainprogressbaroverlay.Maximum += 1 }
		if ($checkboxCleanUpPowerBI.Checked) { $mainprogressbaroverlay.Maximum += 1 }
		if ($checkboxEnableSQLTracking.Checked) { $mainprogressbaroverlay.Maximum += 1 }
		if ($checkboxEnableUsers.Checked) { $mainprogressbaroverlay.Maximum += 1 }
		if ($checkboxListOutUserEmails.Checked) { $mainprogressbaroverlay.Maximum += 1 }
		if ($checkboxNewAdmin.Checked) { $mainprogressbaroverlay.Maximum += 1 }
		if ($checkboxPauseBatchJobs.Checked) { $mainprogressbaroverlay.Maximum += 1 }
		if ($checkboxRunDatabaseSync.Checked) { $mainprogressbaroverlay.Maximum += 1  }
		if ($checkboxDBRecoveryModel.Checked) { $mainprogressbaroverlay.Maximum += 1 }
		if ($checkboxTruncateBatchTables.Checked) { $mainprogressbaroverlay.Maximum += 1 }
	}
	
	function Install-D365foDbatools
	{
		Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/D365tools.ps1)
	}
	
	
	$buttonRun_Click = {
	Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/DBRun.ps1)
		}
	
	
	
	$checkboxNewAdmin_CheckStateChanged={
		if ($checkboxNewAdmin.Checked)
		{
			$textboxAdminEmailAddress.Enabled = $true
			$textboxAdminEmailAddress.Visible = $true
			$labelAdminEmail.Visible = $true
			
		}
		else
		{
			$textboxAdminEmailAddress.Enabled = $false
			$textboxAdminEmailAddress.Visible = $false
			$labelAdminEmail.Visible = $false
		}
	}
	
	$buttonSQLStatus_Click={
		#TODO: Place custom script here
		
		[string]$dt = get-date -Format "yyyyMMdd"
		$oldFile = Get-Item 'G:\MSSQL_DATA\AxDB*Primary.mdf' -Exclude AxDB*$dt*Primary.mdf
		$newFile = Get-Item G:\MSSQL_DATA\AxDB*$dt*Primary.mdf
		$sqlprogressbaroverlay1.Maximum = (Get-Item $oldFile).length/1MB
		$sqlprogressbaroverlay1.Value = 0
		#[System.Windows.MessageBox]::Show($oldFile)
		#[System.Windows.MessageBox]::Show($sqlprogressbaroverlay.Maximum)
		#[System.Windows.MessageBox]::Show(($newFile).length/1MB)
		$counter = 0
		while ($sqlprogressbaroverlay1.Value -lt $sqlprogressbaroverlay1.Maximum)
		{
			$counter += 1
			$labelSysAdmin.Text = $counter
			if ($newFile -ne '')
			{
				$newFile = Get-Item G:\MSSQL_DATA\AxDB*$dt*Primary.mdf
				$sqlprogressbaroverlay1.Value = ($newFile).length/1MB
			}
			Start-Sleep -Seconds 30;
		}
	}
	
	
	$buttonAdminEmailAdd_Click={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/NewAdmin.ps1)
		
	}
	
	$checkboxTruncateBatchTables_CheckedChanged={
		https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/TruncateBatch.ps1)
		
	}
	
	$buttonCleanUpPowerBI_Click={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/CleanPowerBI.ps1)
		
	}
	
	$buttonDBRecoveryModel_Click={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/SetDBRecoveryModel.ps1)
		
	}
	
	$buttonListOutUserEmails_Click={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/ListOutUserEmails.ps1)
		
	}
	
	$buttonEnableUsers_Click={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/EnableUsers.ps1)
		
	}
	
	$buttonRunDatabaseSync_Click={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/DBSync.ps1)
		
	}
	
	$buttonTruncateBatchTables_Click={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/TruncateBatch.ps1)
		
	}
	
	$buttonEnableSQLTracking_Click={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/SQLTracking.ps1)
		
	}
	
	$buttonPauseBatchJobs_Click={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/BatchHold.ps1)
		
	}
	
	$button1_Click={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/1)
		
	}
	
	$button2_Click={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/2)
		
	}
	
	$button3_Click={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/3)
		
	}
	
	$button4_Click={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/4)
		
	}
	
	$button5_Click={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/5)
		
	}
	
	$checkbox5_CheckedChanged={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/5)
		
	}
	
	$checkbox4_CheckedChanged={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/4)
		
	}
	
	$checkbox3_CheckedChanged={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/3)
		
	}
	
	$checkbox2_CheckedChanged={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/2)
		
	}
	
	$checkbox1_CheckedChanged={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/1)
		
	}
	
	$checkboxPauseBatchJobs_CheckedChanged={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/BatchHold.ps1)
		
	}
	
	$checkboxEnableSQLTracking_CheckedChanged={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/SQLTracking.ps1)
		
	}
	
	$checkboxDBRecoveryModel_CheckedChanged={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/SetDBRecoveryModel.ps1)
		
	}
	
	$checkboxListOutUserEmails_CheckedChanged={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/ListOutUserEmails.ps1)
		
	}
	
	$checkboxEnableUsers_CheckedChanged={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/EnableUsers.ps1)
		
	}
	
	$checkboxRunDatabaseSync_CheckedChanged={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/DBSync.ps1)
		
	}
	
	$checkboxCleanUpPowerBI_CheckedChanged={
		Invoke-Expression $(Invoke-WebRequest https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/CleanPowerBI.ps1)
	}
	
	$buttonAddSysAdminUser_Click={
		Invoke-Expression $(Invoke-WebRequest  )
	}
	

	
	# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$formDatabaseRefreshFromB.WindowState = $InitialFormWindowState
	}
	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$labelFile.remove_Click($labelFile_Click)
			$buttonDBRecoveryModel.remove_Click($buttonDBRecoveryModel_Click)
			$buttonRunDatabaseSync.remove_Click($buttonRunDatabaseSync_Click)
			$button5.remove_Click($button5_Click)
			$button4.remove_Click($button4_Click)
			$buttonListOutUserEmails.remove_Click($buttonListOutUserEmails_Click)
			$button3.remove_Click($button3_Click)
			$button1.remove_Click($button1_Click)
			$buttonEnableSQLTracking.remove_Click($buttonEnableSQLTracking_Click)
			$buttonCleanUpPowerBI.remove_Click($buttonCleanUpPowerBI_Click)
			$button2.remove_Click($button2_Click)
			$buttonPauseBatchJobs.remove_Click($buttonPauseBatchJobs_Click)
			$buttonTruncateBatchTables.remove_Click($buttonTruncateBatchTables_Click)
			$buttonEnableUsers.remove_Click($buttonEnableUsers_Click)
			$buttonAddSysAdminUser.remove_Click($buttonAddSysAdminUser_Click)
			$labelSysAdmin.remove_Click($labelSysAdmin_Click)
			$buttonAdminEmailAdd.remove_Click($buttonAdminEmailAdd_Click)
			$checkbox5.remove_CheckedChanged($checkbox5_CheckedChanged)
			$checkbox4.remove_CheckedChanged($checkbox4_CheckedChanged)
			$checkbox3.remove_CheckedChanged($checkbox3_CheckedChanged)
			$checkbox2.remove_CheckedChanged($checkbox2_CheckedChanged)
			$checkbox1.remove_CheckedChanged($checkbox1_CheckedChanged)
			$checkboxDBRecoveryModel.remove_CheckedChanged($checkboxDBRecoveryModel_CheckedChanged)
			$checkboxTruncateBatchTables.remove_CheckedChanged($checkboxTruncateBatchTables_CheckedChanged)
			$checkboxEnableUsers.remove_CheckedChanged($checkboxEnableUsers_CheckedChanged)
			$buttonRun.remove_Click($buttonRun_Click)
			$checkboxListOutUserEmails.remove_CheckedChanged($checkboxListOutUserEmails_CheckedChanged)
			$checkboxRunDatabaseSync.remove_CheckedChanged($checkboxRunDatabaseSync_CheckedChanged)
			$checkboxCleanUpPowerBI.remove_CheckedChanged($checkboxCleanUpPowerBI_CheckedChanged)
			$checkboxEnableSQLTracking.remove_CheckedChanged($checkboxEnableSQLTracking_CheckedChanged)
			$checkboxPauseBatchJobs.remove_CheckedChanged($checkboxPauseBatchJobs_CheckedChanged)
			$buttonAdd.remove_Click($buttonAdd_Click)
			$txtFile.remove_TextChanged($txtFile_TextChanged)
			$txtLink.remove_TextChanged($txtLink_TextChanged)
			$labelAdminEmail.remove_Click($labelAdminEmail_Click)
			$formDatabaseRefreshFromB.remove_Load($formDatabaseRefreshFromB_Load)
			$formDatabaseRefreshFromB.remove_Load($Form_StateCorrection_Load)
			$formDatabaseRefreshFromB.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch { Out-Null <# Prevent PSScriptAnalyzer warning #> }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$formDatabaseRefreshFromB.SuspendLayout()
	#
	# formDatabaseRefreshFromB
	#
	$formDatabaseRefreshFromB.Controls.Add($button7)
	$formDatabaseRefreshFromB.Controls.Add($button6)
	$formDatabaseRefreshFromB.Controls.Add($labelFile)
	$formDatabaseRefreshFromB.Controls.Add($buttonDBRecoveryModel)
	$formDatabaseRefreshFromB.Controls.Add($buttonRunDatabaseSync)
	$formDatabaseRefreshFromB.Controls.Add($button5)
	$formDatabaseRefreshFromB.Controls.Add($button4)
	$formDatabaseRefreshFromB.Controls.Add($buttonListOutUserEmails)
	$formDatabaseRefreshFromB.Controls.Add($button3)
	$formDatabaseRefreshFromB.Controls.Add($button1)
	$formDatabaseRefreshFromB.Controls.Add($buttonEnableSQLTracking)
	$formDatabaseRefreshFromB.Controls.Add($buttonCleanUpPowerBI)
	$formDatabaseRefreshFromB.Controls.Add($button2)
	$formDatabaseRefreshFromB.Controls.Add($buttonPauseBatchJobs)
	$formDatabaseRefreshFromB.Controls.Add($buttonTruncateBatchTables)
	$formDatabaseRefreshFromB.Controls.Add($buttonEnableUsers)
	$formDatabaseRefreshFromB.Controls.Add($buttonAddSysAdminUser)
	$formDatabaseRefreshFromB.Controls.Add($textbox1)
	$formDatabaseRefreshFromB.Controls.Add($labelSysAdmin)
	$formDatabaseRefreshFromB.Controls.Add($buttonAdminEmailAdd)
	$formDatabaseRefreshFromB.Controls.Add($labelMain)
	$formDatabaseRefreshFromB.Controls.Add($checkbox5)
	$formDatabaseRefreshFromB.Controls.Add($checkbox4)
	$formDatabaseRefreshFromB.Controls.Add($checkbox3)
	$formDatabaseRefreshFromB.Controls.Add($checkbox2)
	$formDatabaseRefreshFromB.Controls.Add($checkbox1)
	$formDatabaseRefreshFromB.Controls.Add($labellog)
	$formDatabaseRefreshFromB.Controls.Add($mainprogressbaroverlay)
	$formDatabaseRefreshFromB.Controls.Add($checkboxDBRecoveryModel)
	$formDatabaseRefreshFromB.Controls.Add($checkboxTruncateBatchTables)
	$formDatabaseRefreshFromB.Controls.Add($checkboxEnableUsers)
	$formDatabaseRefreshFromB.Controls.Add($buttonRun)
	$formDatabaseRefreshFromB.Controls.Add($checkboxListOutUserEmails)
	$formDatabaseRefreshFromB.Controls.Add($checkboxRunDatabaseSync)
	$formDatabaseRefreshFromB.Controls.Add($checkboxCleanUpPowerBI)
	$formDatabaseRefreshFromB.Controls.Add($checkboxEnableSQLTracking)
	$formDatabaseRefreshFromB.Controls.Add($checkboxPauseBatchJobs)
	$formDatabaseRefreshFromB.Controls.Add($textboxAdminEmailAddress)
	$formDatabaseRefreshFromB.Controls.Add($buttonAdd)
	$formDatabaseRefreshFromB.Controls.Add($txtFile)
	$formDatabaseRefreshFromB.Controls.Add($txtLink)
	$formDatabaseRefreshFromB.Controls.Add($labelSASLink)
	$formDatabaseRefreshFromB.Controls.Add($labelAdminEmail)
	$formDatabaseRefreshFromB.AutoScaleMode = 'None'
	$formDatabaseRefreshFromB.ClientSize = New-Object System.Drawing.Size(628, 509)
	$formDatabaseRefreshFromB.ControlBox = $False
	$formDatabaseRefreshFromB.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	#region Binary Data
	$Formatter_binaryFomatter = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
	$System_IO_MemoryStream = New-Object System.IO.MemoryStream (,[byte[]][System.Convert]::FromBase64String('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'))
	#endregion
	$formDatabaseRefreshFromB.Icon = $Formatter_binaryFomatter.Deserialize($System_IO_MemoryStream)
	$Formatter_binaryFomatter = $null
	$System_IO_MemoryStream = $null
	$formDatabaseRefreshFromB.Margin = '8, 8, 8, 8'
	$formDatabaseRefreshFromB.MaximizeBox = $False
	$formDatabaseRefreshFromB.MaximumSize = New-Object System.Drawing.Size(650, 565)
	$formDatabaseRefreshFromB.MinimizeBox = $False
	$formDatabaseRefreshFromB.MinimumSize = New-Object System.Drawing.Size(650, 565)
	$formDatabaseRefreshFromB.Name = 'formDatabaseRefreshFromB'
	$formDatabaseRefreshFromB.SizeGripStyle = 'Hide'
	$formDatabaseRefreshFromB.Text = 'Database Refresh from BacBak'
	$formDatabaseRefreshFromB.TopMost = $True
	$formDatabaseRefreshFromB.add_Load($formDatabaseRefreshFromB_Load)
	#
	# button7
	#
	$button7.Location = New-Object System.Drawing.Point(420, 408)
	$button7.Margin = '4, 4, 4, 4'
	$button7.Name = 'button7'
	$button7.Size = New-Object System.Drawing.Size(96, 32)
	$button7.TabIndex = 64
	$button7.Text = 'button7'
	$button7.UseVisualStyleBackColor = $True
	$button7.Visible = $False
	#
	# button6
	#
	$button6.Location = New-Object System.Drawing.Point(321, 408)
	$button6.Margin = '4, 4, 4, 4'
	$button6.Name = 'button6'
	$button6.Size = New-Object System.Drawing.Size(91, 32)
	$button6.TabIndex = 63
	$button6.Text = 'button6'
	$button6.UseVisualStyleBackColor = $True
	$button6.Visible = $False
	#
	# labelFile
	#
	$labelFile.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$labelFile.Location = New-Object System.Drawing.Point(43, 42)
	$labelFile.Margin = '0, 0, 0, 0'
	$labelFile.Name = 'labelFile'
	$labelFile.Size = New-Object System.Drawing.Size(48, 31)
	$labelFile.TabIndex = 62
	$labelFile.Text = 'File'
	$labelFile.TextAlign = 'MiddleRight'
	$labelFile.Visible = $False
	$labelFile.add_Click($labelFile_Click)
	#
	# buttonDBRecoveryModel
	#
	$buttonDBRecoveryModel.Location = New-Object System.Drawing.Point(361, 367)
	$buttonDBRecoveryModel.Margin = '4, 4, 4, 4'
	$buttonDBRecoveryModel.Name = 'buttonDBRecoveryModel'
	$buttonDBRecoveryModel.Size = New-Object System.Drawing.Size(254, 32)
	$buttonDBRecoveryModel.TabIndex = 61
	$buttonDBRecoveryModel.Text = 'DB Recovery Model'
	$buttonDBRecoveryModel.UseVisualStyleBackColor = $True
	$buttonDBRecoveryModel.add_Click($buttonDBRecoveryModel_Click)
	#
	# buttonRunDatabaseSync
	#
	$buttonRunDatabaseSync.Location = New-Object System.Drawing.Point(361, 241)
	$buttonRunDatabaseSync.Margin = '4, 4, 4, 4'
	$buttonRunDatabaseSync.Name = 'buttonRunDatabaseSync'
	$buttonRunDatabaseSync.Size = New-Object System.Drawing.Size(254, 32)
	$buttonRunDatabaseSync.TabIndex = 60
	$buttonRunDatabaseSync.Text = 'Run Database Sync'
	$buttonRunDatabaseSync.UseVisualStyleBackColor = $True
	$buttonRunDatabaseSync.add_Click($buttonRunDatabaseSync_Click)
	#
	# button5
	#
	$button5.Location = New-Object System.Drawing.Point(38, 409)
	$button5.Margin = '4, 4, 4, 4'
	$button5.Name = 'button5'
	$button5.Size = New-Object System.Drawing.Size(258, 32)
	$button5.TabIndex = 59
	$button5.Text = '5'
	$button5.UseVisualStyleBackColor = $True
	$button5.add_Click($button5_Click)
	#
	# button4
	#
	$button4.Location = New-Object System.Drawing.Point(39, 367)
	$button4.Margin = '4, 4, 4, 4'
	$button4.Name = 'button4'
	$button4.Size = New-Object System.Drawing.Size(257, 32)
	$button4.TabIndex = 58
	$button4.Text = '4'
	$button4.UseVisualStyleBackColor = $True
	$button4.add_Click($button4_Click)
	#
	# buttonListOutUserEmails
	#
	$buttonListOutUserEmails.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$buttonListOutUserEmails.Location = New-Object System.Drawing.Point(361, 325)
	$buttonListOutUserEmails.Margin = '4, 4, 4, 4'
	$buttonListOutUserEmails.Name = 'buttonListOutUserEmails'
	$buttonListOutUserEmails.Size = New-Object System.Drawing.Size(254, 32)
	$buttonListOutUserEmails.TabIndex = 57
	$buttonListOutUserEmails.Text = 'List out User emails'
	$buttonListOutUserEmails.UseVisualStyleBackColor = $True
	$buttonListOutUserEmails.add_Click($buttonListOutUserEmails_Click)
	#
	# button3
	#
	$button3.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$button3.Location = New-Object System.Drawing.Point(39, 325)
	$button3.Margin = '4, 4, 4, 4'
	$button3.Name = 'button3'
	$button3.Size = New-Object System.Drawing.Size(257, 32)
	$button3.TabIndex = 56
	$button3.Text = '3'
	$button3.UseVisualStyleBackColor = $True
	$button3.add_Click($button3_Click)
	#
	# button1
	#
	$button1.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$button1.Location = New-Object System.Drawing.Point(40, 241)
	$button1.Margin = '4, 4, 4, 4'
	$button1.Name = 'button1'
	$button1.Size = New-Object System.Drawing.Size(256, 32)
	$button1.TabIndex = 55
	$button1.Text = '1'
	$button1.UseVisualStyleBackColor = $True
	$button1.add_Click($button1_Click)
	#
	# buttonEnableSQLTracking
	#
	$buttonEnableSQLTracking.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$buttonEnableSQLTracking.Location = New-Object System.Drawing.Point(40, 157)
	$buttonEnableSQLTracking.Margin = '4, 4, 4, 4'
	$buttonEnableSQLTracking.Name = 'buttonEnableSQLTracking'
	$buttonEnableSQLTracking.Size = New-Object System.Drawing.Size(256, 32)
	$buttonEnableSQLTracking.TabIndex = 54
	$buttonEnableSQLTracking.Text = 'Enable SQL Tracking '
	$buttonEnableSQLTracking.UseVisualStyleBackColor = $True
	$buttonEnableSQLTracking.add_Click($buttonEnableSQLTracking_Click)
	#
	# buttonCleanUpPowerBI
	#
	$buttonCleanUpPowerBI.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$buttonCleanUpPowerBI.Location = New-Object System.Drawing.Point(361, 157)
	$buttonCleanUpPowerBI.Margin = '4, 4, 4, 4'
	$buttonCleanUpPowerBI.Name = 'buttonCleanUpPowerBI'
	$buttonCleanUpPowerBI.Size = New-Object System.Drawing.Size(254, 32)
	$buttonCleanUpPowerBI.TabIndex = 53
	$buttonCleanUpPowerBI.Text = 'Clean up Power BI'
	$buttonCleanUpPowerBI.UseVisualStyleBackColor = $True
	$buttonCleanUpPowerBI.add_Click($buttonCleanUpPowerBI_Click)
	#
	# button2
	#
	$button2.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$button2.Location = New-Object System.Drawing.Point(40, 283)
	$button2.Margin = '4, 4, 4, 4'
	$button2.Name = 'button2'
	$button2.Size = New-Object System.Drawing.Size(256, 32)
	$button2.TabIndex = 52
	$button2.Text = '2'
	$button2.UseVisualStyleBackColor = $True
	$button2.add_Click($button2_Click)
	#
	# buttonPauseBatchJobs
	#
	$buttonPauseBatchJobs.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$buttonPauseBatchJobs.Location = New-Object System.Drawing.Point(40, 199)
	$buttonPauseBatchJobs.Margin = '4, 4, 4, 4'
	$buttonPauseBatchJobs.Name = 'buttonPauseBatchJobs'
	$buttonPauseBatchJobs.Size = New-Object System.Drawing.Size(256, 32)
	$buttonPauseBatchJobs.TabIndex = 51
	$buttonPauseBatchJobs.Text = 'Pause Batch Jobs'
	$buttonPauseBatchJobs.UseVisualStyleBackColor = $True
	$buttonPauseBatchJobs.add_Click($buttonPauseBatchJobs_Click)
	#
	# buttonTruncateBatchTables
	#
	$buttonTruncateBatchTables.Enabled = $False
	$buttonTruncateBatchTables.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$buttonTruncateBatchTables.Location = New-Object System.Drawing.Point(361, 199)
	$buttonTruncateBatchTables.Margin = '0, 0, 0, 0'
	$buttonTruncateBatchTables.Name = 'buttonTruncateBatchTables'
	$buttonTruncateBatchTables.Size = New-Object System.Drawing.Size(254, 32)
	$buttonTruncateBatchTables.TabIndex = 50
	$buttonTruncateBatchTables.Text = 'Truncate Batch tables'
	$buttonTruncateBatchTables.TextAlign = 'TopCenter'
	$buttonTruncateBatchTables.UseVisualStyleBackColor = $True
	$buttonTruncateBatchTables.add_Click($buttonTruncateBatchTables_Click)
	#
	# buttonEnableUsers
	#
	$buttonEnableUsers.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$buttonEnableUsers.Location = New-Object System.Drawing.Point(361, 283)
	$buttonEnableUsers.Margin = '0, 0, 0, 0'
	$buttonEnableUsers.Name = 'buttonEnableUsers'
	$buttonEnableUsers.Size = New-Object System.Drawing.Size(254, 32)
	$buttonEnableUsers.TabIndex = 49
	$buttonEnableUsers.Text = 'Enable Users'
	$buttonEnableUsers.UseVisualStyleBackColor = $True
	$buttonEnableUsers.add_Click($buttonEnableUsers_Click)
	#
	# buttonAddSysAdminUser
	#
	$buttonAddSysAdminUser.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$buttonAddSysAdminUser.Location = New-Object System.Drawing.Point(557, 116)
	$buttonAddSysAdminUser.Margin = '5, 5, 5, 5'
	$buttonAddSysAdminUser.Name = 'buttonAddSysAdminUser'
	$buttonAddSysAdminUser.Size = New-Object System.Drawing.Size(66, 30)
	$buttonAddSysAdminUser.TabIndex = 48
	$buttonAddSysAdminUser.Text = 'Add'
	$buttonAddSysAdminUser.UseVisualStyleBackColor = $True
	$buttonAddSysAdminUser.add_Click($buttonAddSysAdminUser_Click)
	#
	# textbox1
	#
	$textbox1.Enabled = $False
	$textbox1.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$textbox1.Location = New-Object System.Drawing.Point(96, 116)
	$textbox1.Margin = '5, 5, 5, 5'
	$textbox1.Name = 'textbox1'
	$textbox1.Size = New-Object System.Drawing.Size(458, 30)
	$textbox1.TabIndex = 46
	#
	# labelSysAdmin
	#
	$labelSysAdmin.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$labelSysAdmin.Location = New-Object System.Drawing.Point(4, 115)
	$labelSysAdmin.Margin = '0, 0, 0, 0'
	$labelSysAdmin.Name = 'labelSysAdmin'
	$labelSysAdmin.Size = New-Object System.Drawing.Size(102, 31)
	$labelSysAdmin.TabIndex = 47
	$labelSysAdmin.Text = 'SysAdmin'
	$labelSysAdmin.UseCompatibleTextRendering = $True
	$labelSysAdmin.add_Click($labelSysAdmin_Click)
	#
	# buttonAdminEmailAdd
	#
	$buttonAdminEmailAdd.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$buttonAdminEmailAdd.Location = New-Object System.Drawing.Point(557, 79)
	$buttonAdminEmailAdd.Margin = '5, 5, 5, 5'
	$buttonAdminEmailAdd.Name = 'buttonAdminEmailAdd'
	$buttonAdminEmailAdd.Size = New-Object System.Drawing.Size(66, 30)
	$buttonAdminEmailAdd.TabIndex = 45
	$buttonAdminEmailAdd.Text = 'Add'
	$buttonAdminEmailAdd.UseVisualStyleBackColor = $True
	$buttonAdminEmailAdd.add_Click($buttonAdminEmailAdd_Click)
	#
	# labelMain
	#
	$labelMain.AutoSize = $True
	$labelMain.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '8')
	$labelMain.Location = New-Object System.Drawing.Point(5, 402)
	$labelMain.Margin = '4, 0, 4, 0'
	$labelMain.Name = 'labelMain'
	$labelMain.Size = New-Object System.Drawing.Size(0, 20)
	$labelMain.TabIndex = 44
	#
	# checkbox5
	#
	$checkbox5.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkbox5.Location = New-Object System.Drawing.Point(12, 408)
	$checkbox5.Margin = '5, 5, 5, 5'
	$checkbox5.Name = 'checkbox5'
	$checkbox5.Size = New-Object System.Drawing.Size(33, 37)
	$checkbox5.TabIndex = 41
	$checkbox5.UseVisualStyleBackColor = $True
	$checkbox5.Visible = $False
	$checkbox5.add_CheckedChanged($checkbox5_CheckedChanged)
	#
	# checkbox4
	#
	$checkbox4.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkbox4.Location = New-Object System.Drawing.Point(12, 366)
	$checkbox4.Margin = '5, 5, 5, 5'
	$checkbox4.Name = 'checkbox4'
	$checkbox4.Size = New-Object System.Drawing.Size(34, 37)
	$checkbox4.TabIndex = 40
	$checkbox4.UseVisualStyleBackColor = $True
	$checkbox4.Visible = $False
	$checkbox4.add_CheckedChanged($checkbox4_CheckedChanged)
	#
	# checkbox3
	#
	$checkbox3.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkbox3.Location = New-Object System.Drawing.Point(12, 324)
	$checkbox3.Margin = '5, 5, 5, 5'
	$checkbox3.Name = 'checkbox3'
	$checkbox3.Size = New-Object System.Drawing.Size(33, 37)
	$checkbox3.TabIndex = 39
	$checkbox3.UseVisualStyleBackColor = $True
	$checkbox3.Visible = $False
	$checkbox3.add_CheckedChanged($checkbox3_CheckedChanged)
	#
	# checkbox2
	#
	$checkbox2.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkbox2.Location = New-Object System.Drawing.Point(12, 282)
	$checkbox2.Margin = '5, 5, 5, 5'
	$checkbox2.Name = 'checkbox2'
	$checkbox2.Size = New-Object System.Drawing.Size(34, 37)
	$checkbox2.TabIndex = 38
	$checkbox2.UseVisualStyleBackColor = $True
	$checkbox2.Visible = $False
	$checkbox2.add_CheckedChanged($checkbox2_CheckedChanged)
	#
	# checkbox1
	#
	$checkbox1.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkbox1.Location = New-Object System.Drawing.Point(12, 240)
	$checkbox1.Margin = '5, 5, 5, 5'
	$checkbox1.Name = 'checkbox1'
	$checkbox1.Size = New-Object System.Drawing.Size(34, 37)
	$checkbox1.TabIndex = 37
	$checkbox1.UseVisualStyleBackColor = $True
	$checkbox1.Visible = $False
	$checkbox1.add_CheckedChanged($checkbox1_CheckedChanged)
	#
	# labellog
	#
	$labellog.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '8', [System.Drawing.FontStyle]'Bold')
	$labellog.ForeColor = [System.Drawing.Color]::Cyan 
	$labellog.Location = New-Object System.Drawing.Point(5, 480)
	$labellog.Margin = '8, 0, 8, 0'
	$labellog.Name = 'labellog'
	$labellog.Size = New-Object System.Drawing.Size(616, 30)
	$labellog.TabIndex = 36
	#
	# mainprogressbaroverlay
	#
	$mainprogressbaroverlay.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$mainprogressbaroverlay.Location = New-Object System.Drawing.Point(5, 446)
	$mainprogressbaroverlay.Margin = '0, 0, 0, 0'
	$mainprogressbaroverlay.Name = 'mainprogressbaroverlay'
	$mainprogressbaroverlay.Size = New-Object System.Drawing.Size(616, 33)
	$mainprogressbaroverlay.TabIndex = 35
	$mainprogressbaroverlay.Visible = $False
	#
	# checkboxDBRecoveryModel
	#
	$checkboxDBRecoveryModel.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkboxDBRecoveryModel.Location = New-Object System.Drawing.Point(333, 371)
	$checkboxDBRecoveryModel.Margin = '5, 5, 5, 5'
	$checkboxDBRecoveryModel.Name = 'checkboxDBRecoveryModel'
	$checkboxDBRecoveryModel.Size = New-Object System.Drawing.Size(34, 26)
	$checkboxDBRecoveryModel.TabIndex = 24
	$checkboxDBRecoveryModel.UseVisualStyleBackColor = $True
	$checkboxDBRecoveryModel.add_CheckedChanged($checkboxDBRecoveryModel_CheckedChanged)
	#
	# checkboxTruncateBatchTables
	#
	$checkboxTruncateBatchTables.Checked = $True
	$checkboxTruncateBatchTables.CheckState = 'Checked'
	$checkboxTruncateBatchTables.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '12')
	$checkboxTruncateBatchTables.Location = New-Object System.Drawing.Point(333, 203)
	$checkboxTruncateBatchTables.Margin = '0, 0, 0, 0'
	$checkboxTruncateBatchTables.Name = 'checkboxTruncateBatchTables'
	$checkboxTruncateBatchTables.Size = New-Object System.Drawing.Size(34, 26)
	$checkboxTruncateBatchTables.TabIndex = 26
	$checkboxTruncateBatchTables.UseVisualStyleBackColor = $True
	$checkboxTruncateBatchTables.add_CheckedChanged($checkboxTruncateBatchTables_CheckedChanged)
	#
	# checkboxEnableUsers
	#
	$checkboxEnableUsers.Checked = $True
	$checkboxEnableUsers.CheckState = 'Checked'
	$checkboxEnableUsers.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkboxEnableUsers.Location = New-Object System.Drawing.Point(333, 287)
	$checkboxEnableUsers.Margin = '5, 5, 5, 5'
	$checkboxEnableUsers.Name = 'checkboxEnableUsers'
	$checkboxEnableUsers.Size = New-Object System.Drawing.Size(33, 26)
	$checkboxEnableUsers.TabIndex = 34
	$checkboxEnableUsers.UseVisualStyleBackColor = $True
	$checkboxEnableUsers.add_CheckedChanged($checkboxEnableUsers_CheckedChanged)
	#
	# buttonRun
	#
	$buttonRun.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$buttonRun.Location = New-Object System.Drawing.Point(525, 409)
	$buttonRun.Margin = '5, 5, 5, 5'
	$buttonRun.Name = 'buttonRun'
	$buttonRun.Size = New-Object System.Drawing.Size(90, 32)
	$buttonRun.TabIndex = 32
	$buttonRun.Text = 'Run'
	$buttonRun.UseVisualStyleBackColor = $True
	$buttonRun.add_Click($buttonRun_Click)
	#
	# checkboxListOutUserEmails
	#
	$checkboxListOutUserEmails.Checked = $True
	$checkboxListOutUserEmails.CheckState = 'Checked'
	$checkboxListOutUserEmails.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkboxListOutUserEmails.Location = New-Object System.Drawing.Point(333, 329)
	$checkboxListOutUserEmails.Margin = '5, 5, 5, 5'
	$checkboxListOutUserEmails.Name = 'checkboxListOutUserEmails'
	$checkboxListOutUserEmails.Size = New-Object System.Drawing.Size(31, 26)
	$checkboxListOutUserEmails.TabIndex = 31
	$checkboxListOutUserEmails.UseVisualStyleBackColor = $True
	$checkboxListOutUserEmails.add_CheckedChanged($checkboxListOutUserEmails_CheckedChanged)
	#
	# checkboxRunDatabaseSync
	#
	$checkboxRunDatabaseSync.Checked = $True
	$checkboxRunDatabaseSync.CheckState = 'Checked'
	$checkboxRunDatabaseSync.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkboxRunDatabaseSync.Location = New-Object System.Drawing.Point(333, 245)
	$checkboxRunDatabaseSync.Margin = '5, 5, 5, 5'
	$checkboxRunDatabaseSync.Name = 'checkboxRunDatabaseSync'
	$checkboxRunDatabaseSync.Size = New-Object System.Drawing.Size(34, 26)
	$checkboxRunDatabaseSync.TabIndex = 28
	$checkboxRunDatabaseSync.UseVisualStyleBackColor = $True
	$checkboxRunDatabaseSync.add_CheckedChanged($checkboxRunDatabaseSync_CheckedChanged)
	#
	# checkboxCleanUpPowerBI
	#
	$checkboxCleanUpPowerBI.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkboxCleanUpPowerBI.Location = New-Object System.Drawing.Point(333, 161)
	$checkboxCleanUpPowerBI.Margin = '5, 5, 5, 5'
	$checkboxCleanUpPowerBI.Name = 'checkboxCleanUpPowerBI'
	$checkboxCleanUpPowerBI.Size = New-Object System.Drawing.Size(34, 26)
	$checkboxCleanUpPowerBI.TabIndex = 27
	$checkboxCleanUpPowerBI.UseVisualStyleBackColor = $True
	$checkboxCleanUpPowerBI.add_CheckedChanged($checkboxCleanUpPowerBI_CheckedChanged)
	#
	# checkboxEnableSQLTracking
	#
	$checkboxEnableSQLTracking.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkboxEnableSQLTracking.Location = New-Object System.Drawing.Point(12, 161)
	$checkboxEnableSQLTracking.Margin = '5, 5, 5, 5'
	$checkboxEnableSQLTracking.Name = 'checkboxEnableSQLTracking'
	$checkboxEnableSQLTracking.Size = New-Object System.Drawing.Size(34, 26)
	$checkboxEnableSQLTracking.TabIndex = 25
	$checkboxEnableSQLTracking.UseVisualStyleBackColor = $True
	$checkboxEnableSQLTracking.add_CheckedChanged($checkboxEnableSQLTracking_CheckedChanged)
	#
	# checkboxPauseBatchJobs
	#
	$checkboxPauseBatchJobs.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkboxPauseBatchJobs.Location = New-Object System.Drawing.Point(12, 208)
	$checkboxPauseBatchJobs.Margin = '5, 5, 5, 5'
	$checkboxPauseBatchJobs.Name = 'checkboxPauseBatchJobs'
	$checkboxPauseBatchJobs.Size = New-Object System.Drawing.Size(34, 26)
	$checkboxPauseBatchJobs.TabIndex = 23
	$checkboxPauseBatchJobs.UseVisualStyleBackColor = $True
	$checkboxPauseBatchJobs.add_CheckedChanged($checkboxPauseBatchJobs_CheckedChanged)
	#
	# textboxAdminEmailAddress
	#
	$textboxAdminEmailAddress.Enabled = $False
	$textboxAdminEmailAddress.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$textboxAdminEmailAddress.Location = New-Object System.Drawing.Point(96, 79)
	$textboxAdminEmailAddress.Margin = '5, 5, 5, 5'
	$textboxAdminEmailAddress.Name = 'textboxAdminEmailAddress'
	$textboxAdminEmailAddress.Size = New-Object System.Drawing.Size(458, 30)
	$textboxAdminEmailAddress.TabIndex = 21
	#
	# buttonAdd
	#
	$buttonAdd.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$buttonAdd.Location = New-Object System.Drawing.Point(557, 41)
	$buttonAdd.Margin = '5, 5, 5, 5'
	$buttonAdd.Name = 'buttonAdd'
	$buttonAdd.Size = New-Object System.Drawing.Size(66, 32)
	$buttonAdd.TabIndex = 19
	$buttonAdd.Text = 'Add'
	$buttonAdd.UseVisualStyleBackColor = $True
	$buttonAdd.Visible = $False
	$buttonAdd.add_Click($buttonAdd_Click)
	#
	# txtFile
	#
	$txtFile.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$txtFile.Location = New-Object System.Drawing.Point(96, 42)
	$txtFile.Margin = '5, 5, 5, 5'
	$txtFile.Name = 'txtFile'
	$txtFile.Size = New-Object System.Drawing.Size(458, 30)
	$txtFile.TabIndex = 17
	$txtFile.Visible = $False
	$txtFile.add_TextChanged($txtFile_TextChanged)
	#
	# txtLink
	#
	$txtLink.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$txtLink.Location = New-Object System.Drawing.Point(96, 8)
	$txtLink.Margin = '5, 5, 5, 5'
	$txtLink.Name = 'txtLink'
	$txtLink.Size = New-Object System.Drawing.Size(521, 30)
	$txtLink.TabIndex = 15
	$txtLink.add_TextChanged($txtLink_TextChanged)
	#
	# labelSASLink
	#
	$labelSASLink.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$labelSASLink.Location = New-Object System.Drawing.Point(5, 11)
	$labelSASLink.Margin = '0, 0, 0, 0'
	$labelSASLink.Name = 'labelSASLink'
	$labelSASLink.Size = New-Object System.Drawing.Size(101, 31)
	$labelSASLink.TabIndex = 16
	$labelSASLink.Text = 'SAS Link'
	#
	# labelAdminEmail
	#
	$labelAdminEmail.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '8')
	$labelAdminEmail.Location = New-Object System.Drawing.Point(-3, 82)
	$labelAdminEmail.Margin = '0, 0, 0, 0'
	$labelAdminEmail.Name = 'labelAdminEmail'
	$labelAdminEmail.Size = New-Object System.Drawing.Size(100, 27)
	$labelAdminEmail.TabIndex = 22
	$labelAdminEmail.Text = 'Admin Email'
	$labelAdminEmail.TextAlign = 'MiddleCenter'
	$labelAdminEmail.UseCompatibleTextRendering = $True
	$labelAdminEmail.add_Click($labelAdminEmail_Click)
	$formDatabaseRefreshFromB.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $formDatabaseRefreshFromB.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$formDatabaseRefreshFromB.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$formDatabaseRefreshFromB.add_FormClosed($Form_Cleanup_FormClosed)
	#Show the Form
	return $formDatabaseRefreshFromB.ShowDialog()

} #End Function

#Call the form
Show-dbRefreshv2_psf | Out-Null
