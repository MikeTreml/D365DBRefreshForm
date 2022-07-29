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
                    get{return base.Text;}
                    set{base.Text = value;Invalidate();}
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
	$buttonSQLStatus = New-Object 'System.Windows.Forms.Button'
	$labelMain = New-Object 'System.Windows.Forms.Label'
	$labelSQL = New-Object 'System.Windows.Forms.Label'
	$sqlprogressbaroverlay1 = New-Object 'SAPIENTypes.ProgressBarOverlay'
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
	$checkboxNewAdmin = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxBackupCompletedAxDB = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxRunDatabaseSync = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxCleanUpPowerBI = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxEnableSQLTracking = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxPauseBatchJobs = New-Object 'System.Windows.Forms.CheckBox'
	$textboxAdminEmailAddress = New-Object 'System.Windows.Forms.TextBox'
	$buttonAddFile = New-Object 'System.Windows.Forms.Button'
	$txtFile = New-Object 'System.Windows.Forms.TextBox'
	$txtLink = New-Object 'System.Windows.Forms.TextBox'
	$labelBacBakFileLocation = New-Object 'System.Windows.Forms.Label'
	$labelSASLink = New-Object 'System.Windows.Forms.Label'
	$labelAdminEmailAddress = New-Object 'System.Windows.Forms.Label'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	
	$formDatabaseRefreshFromB_Load={
		#TODO: Initialize Form Controls here
		Set-ControlTheme $formDatabaseRefreshFromB -Theme Dark
	}
	
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
	$txtLink_TextChanged = {
		$txtFile.Text = ''
	}
	
	$txtFile_TextChanged = {
		$txtLink.Text = ''
	}
	
	
	
	$buttonAddFile_Click = {
		$txtFile.Visible = $true
		$labelBacBakFileLocation.Visible = $true
		Add-Type -AssemblyName System.Windows.Forms
		$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
		$FileBrowser.ShowDialog()
		$txtFile.Text = $FileBrowser.FileName
	}
	
	$Stamp = (Get-Date).toString("yyyy-MM-dd")
	$LogFile = "C:\Users\$env:UserName\Desktop\DBRefresh_$env:computername_$Stamp.log"
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
		#region Installing d365fo.tools and dbatools <--
		# This is required by Find-Module, by doing it beforehand we remove some warning messages
		WriteLog "Installing PowerShell modules d365fo.tools and dbatools" -ForegroundColor Yellow
		
		Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope AllUsers
		Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
		$modules2Install = @('d365fo.tools', 'dbatools')
		foreach ($module in $modules2Install)
		{
			WriteLog "..working on module $module"
			if ($null -eq $(Get-Command -Module $module))
			{
				WriteLog "....installing module $module" -ForegroundColor Gray
				Install-Module -Name $module -SkipPublisherCheck -Scope AllUsers -Verbose
			}
			else
			{
				WriteLog "....updating module" $module -ForegroundColor Gray
				Update-Module -Name $module -Verbose
			}
			$mainprogressbaroverlay.PerformStep()
		}
		#endregion Installing d365fo.tools and dbatools -->
	}
	
	
	$buttonRun_Click = {
		$ErrorActionPreference = 'Inquire'
		$sqlprogressbaroverlay1.Visible =$false
		$mainprogressbaroverlay.Maximum = 12
		$mainprogressbaroverlay.Step = 1
		$mainprogressbaroverlay.Value = 0
		$mainprogressbaroverlay.Visible = $True
		count-checkbox
		[string]$dt = get-date -Format "yyyyMMdd" #Generate the datetime stamp to make DB files unique
		
		WriteLog $oldFile = Get-Item G:\MSSQL_DATA\AxDB*Primary.mdf -Verbose
		$renameOldFile = $('G:\MSSQL_DATA\AxDB_PrimaryOld_') + $dt + $('.mdf')
		WriteLog $oldFile -ForegroundColor Yellow
		WriteLog $renameOldFile -ForegroundColor Yellow
		Start-Sleep -Seconds 3;
		Install-D365foDbatools 
		$NewDB = $('AxDB')+ $dt #Database name. No spaces in the name!
		
		if ($txtLink.Text -ne '')
		{
			#If you are going to download BACPAC file from the LCS Asset Library, please use in this section
			$BacpacSasLinkFromLCS = $txtLink.Text
			
			$TempFolder = 'd:\temp\' # 'c:\temp\'  #$env:TEMP
			#region Download bacpac from LCS
			if ($BacpacSasLinkFromLCS.StartsWith('http'))
			{
				WriteLog "Downloading BACPAC from the LCS Asset library" -ForegroundColor Yellow
				New-Item -Path $TempFolder -ItemType Directory -Force -Verbose
				$TempFileName = Join-path $TempFolder -ChildPath "$NewDB.bacpac"
				
				WriteLog "..Downloading file" $TempFileName -ForegroundColor Yellow
				
				Invoke-D365InstallAzCopy -Verbose
				Invoke-D365AzCopyTransfer -SourceUri $BacpacSasLinkFromLCS -DestinationUri $TempFileName -ShowOriginalProgress -Verbose
				
				$f = Get-ChildItem $TempFileName
				$NewDB = $($f.BaseName).Replace(' ', '_')
			}
		}
		elseif ($txtFile.Text -ne '')
		{
			$f = Get-ChildItem $txtFile.Text #Please note that this file should be accessible from SQL server service account
			$downloadedDB = $($f.BaseName).Replace(' ', '_') + $('_') + $dt; #'AxDB_CTS1005BU2'  #Temporary Database name for new AxDB. Use a file name or any meaningful name.
			Move-Item -Path $downloadedDB -Destination $NewDB
		}
		if ($checkboxTruncateBatchTables.Checked)
		{
			Clear-D365BacpacTableData -Path $NewDB -Table "dbo.BATCHHISTORY","BATCHJOBHISTORY","SYSSERVERCONFIG","SYSSERVERSESSIONS","SYSCORPNETPRINTERS","SYSCLIENTSESSIONS","BATCHSERVERCONFIG","BATCHSERVERGROUP" -ClearFromSource -Verbose
		}
		$mainprogressbaroverlay.PerformStep()
		
		## Stop D365FO instance.
		WriteLog "Stopping D365FO environment" -ForegroundColor Yellow
		
		Stop-D365Environment -All -Kill -Verbose
		$mainprogressbaroverlay.PerformStep()
		WriteLog "Enable-D365Exception"
		Enable-D365Exception
		$mainprogressbaroverlay.PerformStep()
		WriteLog "Start SQLbar"
		Start-Job -ScriptBlock { Invoke-Expression $(Invoke-WebRequest  https://raw.githubusercontent.com/MikeTreml/D365DBRefreshForm/main/pbar.ps1) }
		WriteLog "SQL bar"
		start-sleep -seconds 10
		WriteLog "Installing modern SqlPackage"
		Invoke-D365InstallSqlPackage #Installing modern SqlPackage just in case  
		$mainprogressbaroverlay.PerformStep()
		## Import bacpac to SQL Database
		WriteLog "Checking SQL file"
		If (-not (Test-DbaPath -SqlInstance localhost -Path $($f.FullName)))
		{
			Write-Warning "Database file $($f.FullName) could not be found by SQL Server. Try to move it to C:\Temp or D:\Temp"
			throw "Database file $($f.FullName) could not be found by SQL Server. Try to move it to C:\Temp or D:\Temp"
		}
		$mainprogressbaroverlay.PerformStep()
		WriteLog "Unblock-File"
		$f | Unblock-File
		
		WriteLog "Import BACPAC file to the SQL database" $NewDB -ForegroundColor Yellow
		
		$mainprogressbaroverlay.PerformStep()
		WriteLog "Import-D365Bacpac"
		Import-D365Bacpac -ImportModeTier1 -BacpacFile $f.FullName -NewDatabaseName $NewDB -ShowOriginalProgress
		
		## Removing AxDB_orig database and Switching AxDB:   NULL <-1- AxDB_original <-2- AxDB <-3- [NewDB]
		WriteLog "Stopping D365FO environment and Switching Databases" -ForegroundColor Yellow
		Stop-D365Environment -All -Kill -Verbose
		WriteLog "Switch-D365ActiveDatabase"
		if(Get-D365Database -Name AXDB)
		{
			Switch-D365ActiveDatabase -NewDatabaseName $NewDB -Verbose
			
			$mainprogressbaroverlay.PerformStep()
			#WriteLog "Remove-D365Database"
			$decision = $Host.UI.PromptForChoice('something', 'Do you wish to delete old database or keep', ('&Delete', '&Keep'), 1)
			if ($decision -eq 0) 
			{
				$mainprogressbaroverlay.PerformStep()
				Remove-D365Database -DatabaseName 'AxDB_Original' -Verbose
			} 
			else 
			{
			    	#move the file
				$mainprogressbaroverlay.PerformStep()
				WriteLog "Stop-Service MSSQLSERVER, SQLSERVERAGENT"
				Stop-Service MSSQLSERVER, SQLSERVERAGENT -Force -Verbose

				[string]$dt = get-date -Format "yyyyMMdd"
				$newFile = Get-Item G:\MSSQL_DATA\AxDB*$dt*Primary.mdf
				[string]$oldFile = Get-Item 'G:\MSSQL_DATA\AxDB*Primary.mdf' -Exclude AxDB*$dt*Primary.mdf
				if ($oldFile -ne '')
				{
					WriteLog "Move-Item -Path $oldFile -Destination G:\MSSQL_DATA\AxDB_Primaryold_" + $dt
					Move-Item -Path $oldFile -Destination G:\MSSQL_DATA\AxDB_Primaryold_$dt.mdf
				}
				WriteLog "Start-Service MSSQLSERVER, SQLSERVERAGENT "
				Start-Service MSSQLSERVER, SQLSERVERAGENT -Verbose
			}
			## Start D365FO instance
			WriteLog "Starting D365FO environment. Then open UI and refresh Data Entities." -ForegroundColor Yellow
			Start-D365Environment
			$mainprogressbaroverlay.PerformStep()
		}
		else
		{	
			Write-Host "is not standard names"
		}
		if ($checkboxBackupNewlyCompleted.Checked)
		{
			WriteLog "Backup AxDB" -ForegroundColor Yellow
			$labelInfo = ""
			Invoke-DbaQuery -Verbose -SqlInstance localhost -Database AxDB -Type Full -CompressBackup -BackupFileName "dbname-$NewDB-backuptype-timestamp.bak" -ReplaceInName
			$mainprogressbaroverlay.PerformStep()
		}
		
		if ($checkboxCleanUpPowerBISettin.Checked)
		{
			## Clean up Power BI settings
			WriteLog "Cleaning up Power BI settings" -ForegroundColor Yellow
			#Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "UPDATE PowerBIConfig set CLIENTID = '', APPLICATIONKEY = '', REDIRECTURL = ''" 
			Invoke-D365SqlScript -Verbose -DatabaseServer localhost -DatabaseName AxDB -Command "UPDATE PowerBIConfig set CLIENTID = '', APPLICATIONKEY = '', REDIRECTURL = ''"
			$mainprogressbaroverlay.PerformStep()
		}
		
		if ($checkboxEnableSQLChangeTrack.Checked)
		{
			## Enable SQL Change Tracking
			WriteLog "Enabling SQL Change Tracking" -ForegroundColor Yellow
			#Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "ALTER DATABASE AxDB SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 6 DAYS, AUTO_CLEANUP = ON)" 
			Invoke-D365SqlScript -Verbose -DatabaseServer localhost -DatabaseName AxDB -Command "ALTER DATABASE AxDB SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 6 DAYS, AUTO_CLEANUP = ON)"
			$mainprogressbaroverlay.PerformStep()
		}
		
		if ($checkboxPromoteNewAdmin.Checked)
		{
			## Promote user as admin and set default tenant  (Optional)
			WriteLog "Setting up new Admin" -ForegroundColor Yellow
			Set-D365Admin -Verbose -AdminSignInName textboxAdminEmailAddress.Text
			$mainprogressbaroverlay.PerformStep()
		}
		
		if ($checkboxTruncateBatchTables.Checked)
		{
			WriteLog "Truncate Batch Tables"
			Invoke-D365SqlScript -Verbose -DatabaseServer localhost -DatabaseName AxDB -Command "
			TRUNCATE TABLE SYSSERVERCONFIG
			TRUNCATE TABLE SYSSERVERSESSIONS
			TRUNCATE TABLE SYSCORPNETPRINTERS
			TRUNCATE TABLE SYSCLIENTSESSIONS
			TRUNCATE TABLE BATCHSERVERCONFIG
			TRUNCATE TABLE BATCHSERVERGROUP"
			$mainprogressbaroverlay.PerformStep()
		}
		
		if ($checkboxPutAllBatchJobsOnHol.Checked)
		{
			## Put on hold all Batch Jobs
			WriteLog "Disabling all current Batch Jobs" -ForegroundColor Yellow
			#Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "UPDATE BatchJob SET STATUS = 0 WHERE STATUS IN (1,2,5,7)  --Set any waiting, executing, ready, or canceling batches to withhold."
			Invoke-D365SqlScript -Verbose -DatabaseServer localhost -DatabaseName AxDB -Command "UPDATE BatchJob SET STATUS = 0 WHERE STATUS IN (1,2,5,7)  --Set any waiting, executing, ready, or canceling batches to withhold."
			$mainprogressbaroverlay.PerformStep()
		}
		
		if ($checkboxRunDatabaseSync.Checked)
		{
			## Run Database Sync
			WriteLog "Executing Database Sync" -ForegroundColor Yellow
			Invoke-D365DBSync -ShowOriginalProgress -Verbose
			$mainprogressbaroverlay.PerformStep()
		}
		
		if ($checkboxSetDBRecoveryModel.Checked)
		{
			## Set DB Recovery Model to Simple  (Optional)
			WriteLog "Setting DB Recovery Model to Simple" -ForegroundColor Yellow
			Set-DbaDbRecoveryModel -Verbose -SqlInstance localhost -RecoveryModel Simple -Database AxDB -Confirm:$false
			$mainprogressbaroverlay.PerformStep()
		}
		
		if ($checkboxEnableUsersExceptGue.Checked)
		{
			## Enable Users except Guest
			WriteLog "Enable all users except Guest" -ForegroundColor Yellow
			#Invoke-DbaQuery -SqlInstance localhost -Database AxDB -Query "Update USERINFO set ENABLE = 1 where ID != 'Guest'"
			Invoke-D365SqlScript -Verbose -DatabaseServer localhost -DatabaseName AxDB -Command "Update USERINFO set ENABLE = 1 where ID != 'Guest'"
			Update-D365User
			$mainprogressbaroverlay.PerformStep()
		}
		
		if ($checkboxListOutUserEmails.Checked)
		{
			WriteLog "List Out User Email Addresses" -ForegroundColor Yellow
			Invoke-D365SqlScript -Verbose -DatabaseServer localhost -DatabaseName AxDB -Command "
			select ID, Name, NetworkAlias, NETWORKDOMAIN, Enable from userInfo
			where NETWORKALIAS not like '%@contosoax7.onmicrosoft.com'
			and NETWORKALIAS not like '%@capintegration01.onmicrosoft.com'
			and NETWORKALIAS not like '%@devtesttie.ccsctp.net'
		 	and NETWORKALIAS not like '%@DAXMDSRunner.com'
			and NETWORKALIAS not like '%@dynamics.com'
			and NETWORKALIAS != ''"
			$mainprogressbaroverlay.PerformStep()
		}
	}
	
	$checkboxNewAdmin_CheckStateChanged={
		if ($checkboxNewAdmin.Checked)
		{
			$textboxAdminEmailAddress.Enabled = $true
			$textboxAdminEmailAddress.Visible = $true
			$labelAdminEmailAddress.Visible = $true
		}
		else
		{
			$textboxAdminEmailAddress.Enabled = $false
			$textboxAdminEmailAddress.Visible = $false
			$labelAdminEmailAddress.Visible = $false
		}
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
			$buttonSQLStatus.remove_Click($buttonSQLStatus_Click)
			$buttonRun.remove_Click($buttonRun_Click)
			$checkboxNewAdmin.remove_CheckStateChanged($checkboxNewAdmin_CheckStateChanged)
			$buttonAddFile.remove_Click($buttonAddFile_Click)
			$txtFile.remove_TextChanged($txtFile_TextChanged)
			$txtLink.remove_TextChanged($txtLink_TextChanged)
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
	$formDatabaseRefreshFromB.Controls.Add($buttonSQLStatus)
	$formDatabaseRefreshFromB.Controls.Add($labelMain)
	$formDatabaseRefreshFromB.Controls.Add($labelSQL)
	$formDatabaseRefreshFromB.Controls.Add($sqlprogressbaroverlay1)
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
	$formDatabaseRefreshFromB.Controls.Add($checkboxNewAdmin)
	$formDatabaseRefreshFromB.Controls.Add($checkboxBackupCompletedAxDB)
	$formDatabaseRefreshFromB.Controls.Add($checkboxRunDatabaseSync)
	$formDatabaseRefreshFromB.Controls.Add($checkboxCleanUpPowerBI)
	$formDatabaseRefreshFromB.Controls.Add($checkboxEnableSQLTracking)
	$formDatabaseRefreshFromB.Controls.Add($checkboxPauseBatchJobs)
	$formDatabaseRefreshFromB.Controls.Add($textboxAdminEmailAddress)
	$formDatabaseRefreshFromB.Controls.Add($buttonAddFile)
	$formDatabaseRefreshFromB.Controls.Add($txtFile)
	$formDatabaseRefreshFromB.Controls.Add($txtLink)
	$formDatabaseRefreshFromB.Controls.Add($labelBacBakFileLocation)
	$formDatabaseRefreshFromB.Controls.Add($labelSASLink)
	$formDatabaseRefreshFromB.Controls.Add($labelAdminEmailAddress)
	$formDatabaseRefreshFromB.AutoScaleMode = 'None'
	$formDatabaseRefreshFromB.ClientSize = New-Object System.Drawing.Size(628, 594)
	$formDatabaseRefreshFromB.ControlBox = $False
	#region Binary Data
	$Formatter_binaryFomatter = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
	$System_IO_MemoryStream = New-Object System.IO.MemoryStream (,[byte[]][System.Convert]::FromBase64String('
AAEAAAD/////AQAAAAAAAAAMAgAAAFFTeXN0ZW0uRHJhd2luZywgVmVyc2lvbj00LjAuMC4wLCBD
dWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPWIwM2Y1ZjdmMTFkNTBhM2EFAQAAABNTeXN0
ZW0uRHJhd2luZy5JY29uAgAAAAhJY29uRGF0YQhJY29uU2l6ZQcEAhNTeXN0ZW0uRHJhd2luZy5T
aXplAgAAAAIAAAAJAwAAAAX8////E1N5c3RlbS5EcmF3aW5nLlNpemUCAAAABXdpZHRoBmhlaWdo
dAAACAgCAAAAAAAAAAAAAAAPAwAAAMlQAAACAAABAAEAAAAAAAEAIACzUAAAFgAAAIlQTkcNChoK
AAAADUlIRFIAAAEAAAABAAgGAAAAXHKoZgAAUHpJREFUeNrtnXl8FPX9/1+fmdl7N4RTQDEXeIAB
hbZCDrQe9erX/tqqYG2tCsohucjBWcUDqiByJRDwW9vaWgUC2sNeX6tyY1tUTpFLQeQMR5I9ssfM
/P6Y+czObjbJJtkku8nn2UcaTHY3O5+dz/vzvt9ElmUZXYjwiyHhv5dlSJIEnucBAPWeenz0wQd4
+623sG3bNsTrchCOg9vjwdChQ/Hee+/BaDZBlmUQQtr+4oxui9DZb6Cj0G98nudRV1OLP//5z9hY
VYVPdu2Cz++H2Wzu7LfJYHQoXU4AEIRqAbIsQ5ZlcBwHnudx8cJFrF+3Dm+++Sa++OIL8ITAZrPB
ZjQiEAiwE5XRrehyAgAICgFZksBxHAghqD5fjaqqKrz9hz/g888/h8FoRJLDAUIIZEmCJEls8zO6
HQkvACLZwZIogeM5EI6Ds86JtW+/jTfeeAMHDx6EwWBAco8ekCQJsiRBJgSIU7ufwWhvEl4A6KGn
OMdz8Hl9+POf/oTf/OY3+O9//gNeEJCclARZliGKYvBJbPMzujEJLwAIISF2PgDs2LYdq1atwgcf
fABZkpDkcEBS1Xy9l5/IgMy0fkY3JuEFgKSz809+fRL/+9preOutt1BTUwOr1QqeEIiiGCIgAGXz
MxjdnYQVAPpTXxYlbKiqQvmKFTh06BDMZrNy6qsbHwhqCtrz2cnPYCSmAKCOP0IIDn1+EEtefRV/
+9vfIEkS7Ha7EvPX2/kMBiMiCSUA9Ke+3+/Hm2++iVUrynH8+HEkJSUBUEwCBoMRHQkjAPSn/vEv
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
TmrZ8wUAAAAASUVORK5CYIIL'))
	#endregion
	$formDatabaseRefreshFromB.Icon = $Formatter_binaryFomatter.Deserialize($System_IO_MemoryStream)
	$Formatter_binaryFomatter = $null
	$System_IO_MemoryStream = $null
	$formDatabaseRefreshFromB.Margin = '8, 8, 8, 8'
	$formDatabaseRefreshFromB.MaximizeBox = $False
	$formDatabaseRefreshFromB.MaximumSize = New-Object System.Drawing.Size(650, 650)
	$formDatabaseRefreshFromB.MinimizeBox = $False
	$formDatabaseRefreshFromB.MinimumSize = New-Object System.Drawing.Size(650, 650)
	$formDatabaseRefreshFromB.Name = 'formDatabaseRefreshFromB'
	$formDatabaseRefreshFromB.SizeGripStyle = 'Hide'
	$formDatabaseRefreshFromB.Text = 'Database Refresh from BacBak'
	$formDatabaseRefreshFromB.add_Load($formDatabaseRefreshFromB_Load)
	#
	# buttonSQLStatus
	#
	$buttonSQLStatus.Location = New-Object System.Drawing.Point(509, 417)
	$buttonSQLStatus.Margin = '4, 4, 4, 4'
	$buttonSQLStatus.Name = 'buttonSQLStatus'
	$buttonSQLStatus.Size = New-Object System.Drawing.Size(112, 34)
	$buttonSQLStatus.TabIndex = 45
	$buttonSQLStatus.Text = 'SQL Status'
	$buttonSQLStatus.UseVisualStyleBackColor = $True
	$buttonSQLStatus.add_Click($buttonSQLStatus_Click)
	#
	# labelMain
	#
	$labelMain.AutoSize = $True
	$labelMain.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '8')
	$labelMain.Location = New-Object System.Drawing.Point(5, 471)
	$labelMain.Margin = '4, 0, 4, 0'
	$labelMain.Name = 'labelMain'
	$labelMain.Size = New-Object System.Drawing.Size(43, 20)
	$labelMain.TabIndex = 44
	$labelMain.Text = 'Main'
	#
	# labelSQL
	#
	$labelSQL.AutoSize = $True
	$labelSQL.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '8')
	$labelSQL.Location = New-Object System.Drawing.Point(5, 507)
	$labelSQL.Margin = '4, 0, 4, 0'
	$labelSQL.Name = 'labelSQL'
	$labelSQL.Size = New-Object System.Drawing.Size(41, 20)
	$labelSQL.TabIndex = 43
	$labelSQL.Text = 'SQL'
	#
	# sqlprogressbaroverlay1
	#
	$sqlprogressbaroverlay1.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$sqlprogressbaroverlay1.Location = New-Object System.Drawing.Point(52, 501)
	$sqlprogressbaroverlay1.Margin = '4, 4, 4, 4'
	$sqlprogressbaroverlay1.Name = 'sqlprogressbaroverlay1'
	$sqlprogressbaroverlay1.Size = New-Object System.Drawing.Size(569, 33)
	$sqlprogressbaroverlay1.TabIndex = 42
	#
	# checkbox5
	#
	$checkbox5.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkbox5.Location = New-Object System.Drawing.Point(333, 418)
	$checkbox5.Margin = '5, 5, 5, 5'
	$checkbox5.Name = 'checkbox5'
	$checkbox5.Size = New-Object System.Drawing.Size(213, 37)
	$checkbox5.TabIndex = 41
	$checkbox5.Text = 'checkbox5'
	$checkbox5.UseVisualStyleBackColor = $True
	$checkbox5.Visible = $False
	#
	# checkbox4
	#
	$checkbox4.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkbox4.Location = New-Object System.Drawing.Point(13, 418)
	$checkbox4.Margin = '5, 5, 5, 5'
	$checkbox4.Name = 'checkbox4'
	$checkbox4.Size = New-Object System.Drawing.Size(310, 37)
	$checkbox4.TabIndex = 40
	$checkbox4.Text = 'checkbox4'
	$checkbox4.UseVisualStyleBackColor = $True
	$checkbox4.Visible = $False
	#
	# checkbox3
	#
	$checkbox3.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkbox3.Location = New-Object System.Drawing.Point(333, 383)
	$checkbox3.Margin = '5, 5, 5, 5'
	$checkbox3.Name = 'checkbox3'
	$checkbox3.Size = New-Object System.Drawing.Size(213, 37)
	$checkbox3.TabIndex = 39
	$checkbox3.Text = 'checkbox3'
	$checkbox3.UseVisualStyleBackColor = $True
	$checkbox3.Visible = $False
	#
	# checkbox2
	#
	$checkbox2.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkbox2.Location = New-Object System.Drawing.Point(13, 383)
	$checkbox2.Margin = '5, 5, 5, 5'
	$checkbox2.Name = 'checkbox2'
	$checkbox2.Size = New-Object System.Drawing.Size(310, 37)
	$checkbox2.TabIndex = 38
	$checkbox2.Text = 'checkbox2'
	$checkbox2.UseVisualStyleBackColor = $True
	$checkbox2.Visible = $False
	#
	# checkbox1
	#
	$checkbox1.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkbox1.Location = New-Object System.Drawing.Point(333, 349)
	$checkbox1.Margin = '5, 5, 5, 5'
	$checkbox1.Name = 'checkbox1'
	$checkbox1.Size = New-Object System.Drawing.Size(213, 37)
	$checkbox1.TabIndex = 37
	$checkbox1.Text = 'checkbox1'
	$checkbox1.UseVisualStyleBackColor = $True
	$checkbox1.Visible = $False
	#
	# labellog
	#
	$labellog.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '8', [System.Drawing.FontStyle]'Bold')
	$labellog.ForeColor = [System.Drawing.Color]::Cyan 
	$labellog.Location = New-Object System.Drawing.Point(12, 542)
	$labellog.Margin = '8, 0, 8, 0'
	$labellog.Name = 'labellog'
	$labellog.Size = New-Object System.Drawing.Size(609, 53)
	$labellog.TabIndex = 36
	#
	# mainprogressbaroverlay
	#
	$mainprogressbaroverlay.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$mainprogressbaroverlay.Location = New-Object System.Drawing.Point(52, 464)
	$mainprogressbaroverlay.Margin = '0, 0, 0, 0'
	$mainprogressbaroverlay.Name = 'mainprogressbaroverlay'
	$mainprogressbaroverlay.Size = New-Object System.Drawing.Size(569, 33)
	$mainprogressbaroverlay.TabIndex = 35
	$mainprogressbaroverlay.Visible = $False
	#
	# checkboxDBRecoveryModel
	#
	$checkboxDBRecoveryModel.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkboxDBRecoveryModel.Location = New-Object System.Drawing.Point(333, 279)
	$checkboxDBRecoveryModel.Margin = '5, 5, 5, 5'
	$checkboxDBRecoveryModel.Name = 'checkboxDBRecoveryModel'
	$checkboxDBRecoveryModel.Size = New-Object System.Drawing.Size(297, 26)
	$checkboxDBRecoveryModel.TabIndex = 24
	$checkboxDBRecoveryModel.Text = 'DB Recovery Model'
	$checkboxDBRecoveryModel.UseVisualStyleBackColor = $True
	#
	# checkboxTruncateBatchTables
	#
	$checkboxTruncateBatchTables.Checked = $True
	$checkboxTruncateBatchTables.CheckState = 'Checked'
	$checkboxTruncateBatchTables.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkboxTruncateBatchTables.Location = New-Object System.Drawing.Point(333, 244)
	$checkboxTruncateBatchTables.Margin = '5, 5, 5, 5'
	$checkboxTruncateBatchTables.Name = 'checkboxTruncateBatchTables'
	$checkboxTruncateBatchTables.Size = New-Object System.Drawing.Size(297, 26)
	$checkboxTruncateBatchTables.TabIndex = 26
	$checkboxTruncateBatchTables.Text = 'Truncate Batch tables'
	$checkboxTruncateBatchTables.UseVisualStyleBackColor = $True
	#
	# checkboxEnableUsers
	#
	$checkboxEnableUsers.Checked = $True
	$checkboxEnableUsers.CheckState = 'Checked'
	$checkboxEnableUsers.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkboxEnableUsers.Location = New-Object System.Drawing.Point(333, 314)
	$checkboxEnableUsers.Margin = '5, 5, 5, 5'
	$checkboxEnableUsers.Name = 'checkboxEnableUsers'
	$checkboxEnableUsers.Size = New-Object System.Drawing.Size(297, 26)
	$checkboxEnableUsers.TabIndex = 34
	$checkboxEnableUsers.Text = 'Enable Users'
	$checkboxEnableUsers.UseVisualStyleBackColor = $True
	#
	# buttonRun
	#
	$buttonRun.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$buttonRun.Location = New-Object System.Drawing.Point(544, 365)
	$buttonRun.Margin = '5, 5, 5, 5'
	$buttonRun.Name = 'buttonRun'
	$buttonRun.Size = New-Object System.Drawing.Size(77, 43)
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
	$checkboxListOutUserEmails.Location = New-Object System.Drawing.Point(13, 349)
	$checkboxListOutUserEmails.Margin = '5, 5, 5, 5'
	$checkboxListOutUserEmails.Name = 'checkboxListOutUserEmails'
	$checkboxListOutUserEmails.Size = New-Object System.Drawing.Size(310, 26)
	$checkboxListOutUserEmails.TabIndex = 31
	$checkboxListOutUserEmails.Text = 'List out User emails'
	$checkboxListOutUserEmails.UseVisualStyleBackColor = $True
	#
	# checkboxNewAdmin
	#
	$checkboxNewAdmin.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkboxNewAdmin.Location = New-Object System.Drawing.Point(483, 172)
	$checkboxNewAdmin.Margin = '5, 5, 5, 5'
	$checkboxNewAdmin.Name = 'checkboxNewAdmin'
	$checkboxNewAdmin.Size = New-Object System.Drawing.Size(147, 26)
	$checkboxNewAdmin.TabIndex = 30
	$checkboxNewAdmin.Text = 'New Admin'
	$checkboxNewAdmin.UseVisualStyleBackColor = $True
	$checkboxNewAdmin.add_CheckStateChanged($checkboxNewAdmin_CheckStateChanged)
	#
	# checkboxBackupCompletedAxDB
	#
	$checkboxBackupCompletedAxDB.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkboxBackupCompletedAxDB.Location = New-Object System.Drawing.Point(13, 314)
	$checkboxBackupCompletedAxDB.Margin = '5, 5, 5, 5'
	$checkboxBackupCompletedAxDB.Name = 'checkboxBackupCompletedAxDB'
	$checkboxBackupCompletedAxDB.Size = New-Object System.Drawing.Size(310, 26)
	$checkboxBackupCompletedAxDB.TabIndex = 29
	$checkboxBackupCompletedAxDB.Text = 'Backup Completed AxDB'
	$checkboxBackupCompletedAxDB.UseVisualStyleBackColor = $True
	#
	# checkboxRunDatabaseSync
	#
	$checkboxRunDatabaseSync.Checked = $True
	$checkboxRunDatabaseSync.CheckState = 'Checked'
	$checkboxRunDatabaseSync.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkboxRunDatabaseSync.Location = New-Object System.Drawing.Point(333, 210)
	$checkboxRunDatabaseSync.Margin = '5, 5, 5, 5'
	$checkboxRunDatabaseSync.Name = 'checkboxRunDatabaseSync'
	$checkboxRunDatabaseSync.Size = New-Object System.Drawing.Size(297, 26)
	$checkboxRunDatabaseSync.TabIndex = 28
	$checkboxRunDatabaseSync.Text = 'Run Database Sync'
	$checkboxRunDatabaseSync.UseVisualStyleBackColor = $True
	#
	# checkboxCleanUpPowerBI
	#
	$checkboxCleanUpPowerBI.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkboxCleanUpPowerBI.Location = New-Object System.Drawing.Point(13, 244)
	$checkboxCleanUpPowerBI.Margin = '5, 5, 5, 5'
	$checkboxCleanUpPowerBI.Name = 'checkboxCleanUpPowerBI'
	$checkboxCleanUpPowerBI.Size = New-Object System.Drawing.Size(310, 26)
	$checkboxCleanUpPowerBI.TabIndex = 27
	$checkboxCleanUpPowerBI.Text = 'Clean up Power BI'
	$checkboxCleanUpPowerBI.UseVisualStyleBackColor = $True
	#
	# checkboxEnableSQLTracking
	#
	$checkboxEnableSQLTracking.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkboxEnableSQLTracking.Location = New-Object System.Drawing.Point(13, 279)
	$checkboxEnableSQLTracking.Margin = '5, 5, 5, 5'
	$checkboxEnableSQLTracking.Name = 'checkboxEnableSQLTracking'
	$checkboxEnableSQLTracking.Size = New-Object System.Drawing.Size(310, 26)
	$checkboxEnableSQLTracking.TabIndex = 25
	$checkboxEnableSQLTracking.Text = 'Enable SQL Tracking '
	$checkboxEnableSQLTracking.UseVisualStyleBackColor = $True
	#
	# checkboxPauseBatchJobs
	#
	$checkboxPauseBatchJobs.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$checkboxPauseBatchJobs.Location = New-Object System.Drawing.Point(13, 210)
	$checkboxPauseBatchJobs.Margin = '5, 5, 5, 5'
	$checkboxPauseBatchJobs.Name = 'checkboxPauseBatchJobs'
	$checkboxPauseBatchJobs.Size = New-Object System.Drawing.Size(310, 26)
	$checkboxPauseBatchJobs.TabIndex = 23
	$checkboxPauseBatchJobs.Text = 'Pause Batch Jobs'
	$checkboxPauseBatchJobs.UseVisualStyleBackColor = $True
	#
	# textboxAdminEmailAddress
	#
	$textboxAdminEmailAddress.Enabled = $False
	$textboxAdminEmailAddress.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$textboxAdminEmailAddress.Location = New-Object System.Drawing.Point(13, 171)
	$textboxAdminEmailAddress.Margin = '5, 5, 5, 5'
	$textboxAdminEmailAddress.Name = 'textboxAdminEmailAddress'
	$textboxAdminEmailAddress.Size = New-Object System.Drawing.Size(461, 30)
	$textboxAdminEmailAddress.TabIndex = 21
	#
	# buttonAddFile
	#
	$buttonAddFile.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$buttonAddFile.Location = New-Object System.Drawing.Point(523, 95)
	$buttonAddFile.Margin = '5, 5, 5, 5'
	$buttonAddFile.Name = 'buttonAddFile'
	$buttonAddFile.Size = New-Object System.Drawing.Size(98, 38)
	$buttonAddFile.TabIndex = 19
	$buttonAddFile.Text = 'Add File'
	$buttonAddFile.UseVisualStyleBackColor = $True
	$buttonAddFile.add_Click($buttonAddFile_Click)
	#
	# txtFile
	#
	$txtFile.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$txtFile.Location = New-Object System.Drawing.Point(13, 100)
	$txtFile.Margin = '5, 5, 5, 5'
	$txtFile.Name = 'txtFile'
	$txtFile.Size = New-Object System.Drawing.Size(501, 30)
	$txtFile.TabIndex = 17
	$txtFile.add_TextChanged($txtFile_TextChanged)
	#
	# txtLink
	#
	$txtLink.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$txtLink.Location = New-Object System.Drawing.Point(13, 31)
	$txtLink.Margin = '5, 5, 5, 5'
	$txtLink.Name = 'txtLink'
	$txtLink.Size = New-Object System.Drawing.Size(604, 30)
	$txtLink.TabIndex = 15
	$txtLink.add_TextChanged($txtLink_TextChanged)
	#
	# labelBacBakFileLocation
	#
	$labelBacBakFileLocation.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$labelBacBakFileLocation.Location = New-Object System.Drawing.Point(13, 73)
	$labelBacBakFileLocation.Margin = '0, 0, 0, 0'
	$labelBacBakFileLocation.Name = 'labelBacBakFileLocation'
	$labelBacBakFileLocation.Size = New-Object System.Drawing.Size(175, 31)
	$labelBacBakFileLocation.TabIndex = 18
	$labelBacBakFileLocation.Text = 'File Location'
	$labelBacBakFileLocation.UseCompatibleTextRendering = $True
	#
	# labelSASLink
	#
	$labelSASLink.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$labelSASLink.Location = New-Object System.Drawing.Point(13, 5)
	$labelSASLink.Margin = '0, 0, 0, 0'
	$labelSASLink.Name = 'labelSASLink'
	$labelSASLink.Size = New-Object System.Drawing.Size(130, 31)
	$labelSASLink.TabIndex = 16
	$labelSASLink.Text = 'SAS Link'
	#
	# labelAdminEmailAddress
	#
	$labelAdminEmailAddress.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$labelAdminEmailAddress.Location = New-Object System.Drawing.Point(13, 142)
	$labelAdminEmailAddress.Margin = '0, 0, 0, 0'
	$labelAdminEmailAddress.Name = 'labelAdminEmailAddress'
	$labelAdminEmailAddress.Size = New-Object System.Drawing.Size(283, 31)
	$labelAdminEmailAddress.TabIndex = 22
	$labelAdminEmailAddress.Text = 'Admin Email Address'
	$labelAdminEmailAddress.UseCompatibleTextRendering = $True
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
