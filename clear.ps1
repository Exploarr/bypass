Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Clear MUICache (tracks GUI program execution per-user)
Write-Host "Clearing MuiCache"
Remove-Item -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" -Recurse -Force -ErrorAction SilentlyContinue

# Clear ComDlg32 (Open/Save dialog history)
Write-Host "Clearing ComDlg32"
Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32" -Recurse -Force -ErrorAction SilentlyContinue

# Clear RecentDocs
Write-Host "Clearing RecentDocs"
Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" -Recurse -Force -ErrorAction SilentlyContinue

# Clear UserAssist (tracks program execution with timestamps)
Write-Host "Clearing UserAssist"
Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist" -Recurse -Force -ErrorAction SilentlyContinue

# Clear RunMRU (Run dialog history)
Write-Host "Clearing RunMRU"
Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Recurse -Force -ErrorAction SilentlyContinue

# Clear Compatibility Store (AppCompatCache / ShimCache)
Write-Host "Clearing Compatibility Store"
Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache" -Recurse -Force -ErrorAction SilentlyContinue

# Clear AppSwitch
Write-Host "Clearing AppSwitch"
Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AppSwitch" -Recurse -Force -ErrorAction SilentlyContinue

# Kill explorer.exe to release handles
Write-Host "Terminating explorer.exe..."
Stop-Process -Name "explorer" -Force

# Stop Windows Event Log service
Write-Host "Stopping Windows Event Log service..."
Stop-Service -Name "EventLog" -Force

# Clear Prefetch files
Write-Host "Clearing Prefetch"
Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue

# Clear Event Logs
Write-Host "Clearing Event Logs"
$logs = wevtutil.exe el
foreach ($log in $logs) { wevtutil.exe cl "$log" 2>$null }

# Clear PCA (Program Compatibility Assistant)
Write-Host "Clearing pca"
Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\PCA" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\appcompat\Programs\Amcache.hve" -Force -ErrorAction SilentlyContinue

# Clear SRUM (System Resource Usage Monitor)
Write-Host "Clearing SRUM"
Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\System32\sru\SRUDB.dat" -Force -ErrorAction SilentlyContinue

# Clear LNK Timestamps / Jump Lists
Write-Host "Clearing LNKTimestamps"
Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent\CustomDestinations\*" -Recurse -Force -ErrorAction SilentlyContinue

# Clear Recent Files
Write-Host "Clearing Recent Files"
Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent\*" -Recurse -Force -ErrorAction SilentlyContinue

# Clear PowerShell History (PSReadLine)
Write-Host "Clearing PSReadline"
$historyPath = (Get-PSReadlineOption).HistorySavePath
Remove-Item -Path $historyPath -Force -ErrorAction SilentlyContinue
Clear-History
[Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()

# Clear Temp files
Write-Host "Clearing Temp"
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:LOCALAPPDATA\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

# Clear ShimCache (redundant with Compatibility Store)
Write-Host "Clearing ShimCache"
Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache" -Recurse -Force -ErrorAction SilentlyContinue

# Delete USN Journal on C: drive (NTFS change journal)
Write-Host "Deleting USN Journal on C:"
fsutil usn deletejournal /d C:

# Restart Windows Event Log service
Write-Host "Restarting Windows Event Log service..."
Start-Service -Name "EventLog"

# Restart explorer
Start-Process "explorer.e