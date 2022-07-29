function Show-bar_psf {

	[void][reflection.assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')

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
	$formSQL = New-Object 'System.Windows.Forms.Form'
	$label1000 = New-Object 'System.Windows.Forms.Label'
	$SQL = New-Object 'System.Windows.Forms.Label'
	$progressbaroverlay1 = New-Object 'SAPIENTypes.ProgressBarOverlay'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	
	$formSQL_Load={
		#TODO: Initialize Form Controls here
		Set-ControlTheme $formSQL -Theme Dark
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
		else
		{
			$WindowColor = [System.Drawing.Color]::White
			$ContainerColor = [System.Drawing.Color]::WhiteSmoke
			$BackColor = [System.Drawing.Color]::Gainsboro
			$ForeColor = [System.Drawing.Color]::Black
			$BorderColor = [System.Drawing.Color]::DimGray
			$SelectionBackColor = [System.Drawing.SystemColors]::Highlight
			$SelectionForeColor = [System.Drawing.Color]::White
			$MenuSelectionColor = [System.Drawing.Color]::LightSteelBlue
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
	
	# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$formSQL.WindowState = $InitialFormWindowState
	}
	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$formSQL.remove_Load($formSQL_Load)
			$formSQL.remove_Load($Form_StateCorrection_Load)
			$formSQL.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch { Out-Null <# Prevent PSScriptAnalyzer warning #> }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$formSQL.SuspendLayout()
	#
	# formSQL
	#
	$formSQL.Controls.Add($label1000)
	$formSQL.Controls.Add($SQL)
	$formSQL.Controls.Add($progressbaroverlay1)
	$formSQL.AutoScaleDimensions = New-Object System.Drawing.SizeF(12, 25)
	$formSQL.AutoScaleMode = 'Font'
	$formSQL.ClientSize = New-Object System.Drawing.Size(563, 37)
	$formSQL.ControlBox = $False
	$formSQL.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '10')
	$formSQL.FormBorderStyle = 'None'
	$formSQL.Margin = '10, 10, 10, 10'
	$formSQL.MaximizeBox = $False
	$formSQL.MinimizeBox = $False
	$formSQL.Name = 'formSQL'
	$formSQL.Opacity = 0.8
	$formSQL.ShowIcon = $False
	$formSQL.StartPosition = 'CenterScreen'
	$formSQL.Text = 'SQL'
	$formSQL.add_Load($formSQL_Load)
	#
	# label1000
	#
	$label1000.AutoSize = $True
	$label1000.BackColor = [System.Drawing.Color]::Transparent 
	$label1000.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '8')
	$label1000.Location = New-Object System.Drawing.Point(502, 8)
	$label1000.Margin = '0, 0, 0, 0'
	$label1000.Name = 'label1000'
	$label1000.Size = New-Object System.Drawing.Size(45, 20)
	$label1000.TabIndex = 2
	$label1000.Text = '1000'
	#
	# SQL
	#
	$SQL.AutoSize = $True
	$SQL.BackColor = [System.Drawing.Color]::Transparent 
	$SQL.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '12')
	$SQL.Location = New-Object System.Drawing.Point(25, 3)
	$SQL.Margin = '0, 0, 0, 0'
	$SQL.Name = 'SQL'
	$SQL.Size = New-Object System.Drawing.Size(61, 29)
	$SQL.TabIndex = 1
	$SQL.Text = 'SQL'
	#
	# progressbaroverlay1
	#
	$progressbaroverlay1.Cursor = 'WaitCursor'
	$progressbaroverlay1.Location = New-Object System.Drawing.Point(0, 0)
	$progressbaroverlay1.Margin = '0, 0, 0, 0'
	$progressbaroverlay1.Name = 'progressbaroverlay1'
	$progressbaroverlay1.Size = New-Object System.Drawing.Size(562, 37)
	$progressbaroverlay1.Step = 20
	$progressbaroverlay1.TabIndex = 0
	$progressbaroverlay1.UseWaitCursor = $True
	$formSQL.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $formSQL.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$formSQL.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$formSQL.add_FormClosed($Form_Cleanup_FormClosed)
	#Show the Form
	$formSQL.Show()
	
	
	[string]$dt = get-date -Format "yyyyMMdd"
	$oldFile = Get-Item 'G:\MSSQL_DATA\AxDB_backup_20220729_Primary.mdf'
	$newFile = Get-Item 'G:\MSSQL_DATA\AxDB20220729_Primary.mdf'
	
	$progressbaroverlay1.Maximum = (Get-Item $oldFile).length/1MB
	$progressbaroverlay1.Value = 0
	
	while ($progressbaroverlay1.Value -lt $progressbaroverlay1.Maximum)
	{
		if (Test-Path -Path $newFile)
		{
			$progressbaroverlay1.Value = (Get-Item $newFile).length/1MB
			start-sleep -seconds 30
		}
	}

} #End Function

#Call the form
Show-bar_psf | Out-Null
