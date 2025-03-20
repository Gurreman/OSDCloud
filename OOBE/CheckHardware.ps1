# Check Mouse Connection
$MouseInfo = Get-WmiObject Win32_PointingDevice | Select-Object Name, DeviceID, Status
 
# Check Audio Devices (Sound Input/Output)
$SoundDevices = Get-WmiObject Win32_SoundDevice | Select-Object Name, Status
 
# Check Camera (Webcam)
$CameraInfo = Get-WmiObject Win32_PnPEntity | Where-Object { $_.Name -match "Camera|Webcam" } | Select-Object Name, Status
 
# Check if any process is using the camera (optional)
$CameraProcesses = Get-WmiObject Win32_Process | Where-Object { $_.CommandLine -match "camera|webcam|video" }
 
# Launch Camera App (Windows default Camera app)
Start-Process "microsoft.windows.camera:"  # This opens the Camera app
 
# Display Mouse Information
Write-Host "`n=== MOUSE CHECK ==="
if ($MouseInfo) {
    Write-Host "Mouse connected: $($MouseInfo.Name)"
    Write-Host "Mouse Status: $($MouseInfo.Status)"
} else {
    Write-Host "No mouse detected."
}
 
# Display Sound Device Information
Write-Host "`n=== SOUND DEVICE CHECK ==="
if ($SoundDevices) {
    $SoundDevices | Format-Table -Property Name, Status
} else {
    Write-Host "No sound devices detected."
}
 
# Display Camera (Webcam) Information
Write-Host "`n=== CAMERA CHECK ==="
if ($CameraInfo) {
    $CameraInfo | Format-Table -Property Name, Status
} else {
    Write-Host "No camera detected."
}
 
# Display if camera is in use (optional)
Write-Host "`n=== CAMERA USAGE CHECK ==="
if ($CameraProcesses) {
    Write-Host "Camera is currently in use by the following processes:"
    $CameraProcesses | Format-Table -Property ProcessName, CommandLine
} else {
    Write-Host "No processes currently using the camera."
}
 
Write-Host "`nHardware Check Complete. Review the above information."