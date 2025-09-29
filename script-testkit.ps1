# script-testkit.ps1
# ==================================================
# Description
# ==================================================
# Usage
# ==================================================


Write-Host "Starting script-testkit.ps1 ..."

# include
# . ".\functions.ps1"

# var
# $var = ""

Write-Host ""
Write-Host "================================================================================"
Write-Host "Script - TestKit"
Write-Host "================================================================================"
Write-Host ""

# Documentation
Write-Host "List of Tests"
##################################################
Write-Host "BIOS"
Write-Host "Power_ACCharging"
Write-Host "HardwareSpecs"
Write-Host "Keyboard"
Write-Host "Trackpad/Mouse"
Write-Host "Speakers and Microphone"
Write-Host "Camera"
Write-Host "WiFi"
Write-Host "Bluetooth"
Write-Host "Ports_USB-C/A"
Write-Host "Ports_Display"
Write-Host "Ports_Others"
Write-Host ""
##################################################

Write-Host ""
Write-Host ""

# start
Write-Host "Let's get started!"
pause
Write-Host ""

# "BIOS"
Write-Host "BIOS"
Write-Host "Serial Number:" (Get-CimInstance -ClassName Win32_BIOS).SerialNumber
Write-Host "BIOS Version:" (Get-CimInstance -ClassName Win32_BIOS).SMBIOSBIOSVersion
# older

Write-Host ""

# "Power_ACCharging"
Write-Host "Power_ACCharging"
Write-Host "AC charging:" (Get-WmiObject -Class BatteryStatus -Namespace root\wmi).PowerOnline
# (Get-WmiObject -Class BatteryStatus -Namespace root\wmi).PowerOnline
Write-Host "Plug out AC power to check if battery can hold charge ..."

pause
Write-Host ""

# "HardwareSpecs"
Write-Host "Hardware"
# 
# Processor
Write-Host "Processor:" (Get-CimInstance -ClassName Win32_Processor).Name
# 
# RAM
$ram_array = (Get-CimInstance -ClassName Win32_PhysicalMemory).Capacity
$ram_array_sum = 0
$ram_array | % { $ram_array_sum += $_}
Write-Host -NoNewline "RAM: "
foreach ($item in $ram_array) {
    Write-Host -NoNewline "$([math]::Round($item/1073741824,1)) GB + "
}
Write-Host "= $([math]::Round($ram_array_sum/1073741824,1)) GB"
# 
# SSD Type
Write-Host "PhysicalDisk Type:" (Get-PhysicalDisk).MediaType
# 
# SSD Capacity
$ssd_array = (Get-CimInstance -ClassName Win32_DiskDrive).Size
$ssd_array_sum = 0
$ssd_array | % { $ssd_array_sum += $_}
Write-Host -NoNewline "PhysicalDisk Capacity: "
foreach ($item in $ssd_array) {
    Write-Host -NoNewline "$([math]::Round($item/1073741824,1)) GB + "
}
Write-Host "= $([math]::Round($ssd_array_sum/1073741824,1)) GB"
# 
# SSD SMART Test
Write-Host "PhysicalDisk SMART Test ..."
# CDI Folder
if (Test-Path -Path "CDI") {
    Get-ChildItem -Path "CDI" -Recurse | Remove-Item -Recurse -Force
}
# 
# extract CrystalDiskInfo
Get-ChildItem -Filter "Crystal*.zip" | ForEach-Object { .\SevenZip\7za.exe x $_.FullName -o"CDI" -aoa }
# Get-ChildItem -Filter "Crystal*.zip" | Expand-Archive -DestinationPath "CDI" -Force
# 
Start-Process -FilePath "CDI\DiskInfo64.exe" -Wait
# Run SMARTTest

pause
Write-Host ""

# "Keyboard"
Write-Host "Keyboard"
Write-Host ""

Write-Host "Keyboard Test Utility"
Start-Process -FilePath "keyboardtestutility.exe" -Wait
# Run KeyboardTestUtility

pause
Write-Host ""

# prep wordpad
Get-ChildItem -Filter "wordpad.zip" | ForEach-Object {
    .\SevenZip\7za.exe x $_.FullName "Accessories\*" -o"$env:ProgramFiles\Windows NT" -aoa
    .\SevenZip\7za.exe x $_.FullName "Wordpad.lnk" -o"$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories" -aoa
}
# 
Write-Host "Keyboard Test (manual): Type each key manually"
Start-Process -FilePath "$env:ProgramFiles\Windows NT\Accessories\wordpad.exe" -ArgumentList "test.docx"

pause
Write-Host ""

# "Trackpad/Mouse"
Write-Host "Trackpad/Mouse (check manually)"

pause
Write-Host ""

# "Speakers and Microphone"
Write-Host "Speakers and Microphone"
# 
# extract Audacity
Get-ChildItem -Filter "audacity*.zip" | ForEach-Object { .\SevenZip\7za.exe x $_.FullName -o"ADCT" -aoa }
# Get-ChildItem -Filter "audacity*.zip" | Expand-Archive -DestinationPath "ADCT" -Force
$subfoldername_audacity = (Get-ChildItem -Path "ADCT").Name
# 
Write-Host ""

Write-Host "Test Speaker by playing MP3"
Start-Process -FilePath "ADCT\$subfoldername_audacity\Audacity.exe" -ArgumentList "StereoAudio.mp3" -Wait
# start "StereoAudio.mp3"

pause
Write-Host ""

Write-Host "Test Mic using Audacity"
Start-Process -FilePath "ADCT\$subfoldername_audacity\Audacity.exe" -Wait

# Write-Host "Test Mic using Windows Sound Recorder"
# start shell:AppsFolder\Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe!App

pause
Write-Host ""

# "Camera"
Write-Host "Camera"
start shell:AppsFolder\Microsoft.WindowsCamera_8wekyb3d8bbwe!App

pause
Write-Host ""

# "WiFi"
Write-Host "WiFi (connect manually)"
start ms-settings:network-wifi

pause
Write-Host ""

# "Bluetooth"
Write-Host "Bluetooth (connect manually)"
start ms-settings:bluetooth

pause
Write-Host ""

# "Ports_USB-C/A"
Write-Host "Ports_USB-C/A (check manually)"

pause
Write-Host ""

# "Ports_Display"
Write-Host "Ports_Display (check manually)"

pause
Write-Host ""

# "Ports_Others"
Write-Host "Ports_Others (check manually)"

pause
Write-Host ""

Write-Host ""

Write-Host "Terminating script-testkit.ps1 ..."
# pause


# ==================================================
# Notes
# ==================================================
