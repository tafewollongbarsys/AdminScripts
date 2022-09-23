﻿<# === CREATE RANDOM === #>
<# Functions #>
function Select-FolderDialog
{
    param([string]$Description="Select Folder",[string]$RootFolder="Desktop")

    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null     

    $objForm = New-Object System.Windows.Forms.FolderBrowserDialog
    $objForm.Rootfolder = $RootFolder
    $objForm.Description = $Description
    $Show = $objForm.ShowDialog()
    If ($Show -eq "OK")
    {
        Return $objForm.SelectedPath
    }
    Else
    {
    Write-Error "Operation cancelled by user."
    }
}
<# ==== #>

# Intro
Clear-Host;
Write-Host "Random file generator `n" -ForegroundColor Blue -BackgroundColor White;
Write-Host "Create a large random number of files with random small file sizes `n";

# Generate random number of files between 30 and 100
$numberOfFiles = Get-Random -Minimum 30 -Maximum 100
Write-Host "Number of files to be created: " $numberOfFiles
$maximumTotalFileSize = $numberOfFiles * '10'
Write-Host "Each file will be a maximum of 10MB, `n for a maximum total of" $maximumTotalFileSize"MB.";
Write-Host "Please ensure you have enough space on the target drive."
Read-Host -Prompt "Press ENTER to Continue or CTRL+C to quit"

# Choose a target folder
$targetFolder = Select-FolderDialog;

if ((Get-ChildItem $targetFolder | Measure-Object).Count -eq 0) {
        Write-Host "Folder is empty`n" -ForegroundColor Green
    } else {
    Write-Host "Folder is NOT empty. Proceed at your own risk.`n" -ForegroundColor Red;
    }
Read-Host -Prompt "Press ENTER to Continue or CTRL+C to quit"

# Creation loop
$i = 0;
While ($i -lt $numberOfFiles) {
    $fileSizeBytes = Get-Random -Minimum 1 -Maximum 10485760;
    $fileSizeMB = $fileSizeBytes / 1048576;
    $fileSizeMBRound = [math]::Round($fileSizeMB);
    $fileName = @($i+1)+'.ext';
    Write-Host "Creating file:" `'$fileName`' -ForegroundColor Green
    Write-Host "File size:" $fileSizeMBRound "MB";
    Write-Host "In target folder" $targetFolder;
    fsutil file createnew $targetFolder\$fileName $fileSizeBytes;
    Write-Host "";
    $i++;
}

Read-Host -Prompt "Press ENTER to exit"