#Force English culture so date parsing in OSD works under a Swedish WinPE locale
$culture = [System.Globalization.CultureInfo]::GetCultureInfo('en-US')
[System.Threading.Thread]::CurrentThread.CurrentCulture = $culture
[System.Threading.Thread]::CurrentThread.CurrentUICulture = $culture

#Variables to define the Windows OS / Edition etc to be applied during OSDCloud
$OSName = 'Windows 11 26H2 x64'
$OSEdition = 'Pro'
$OSActivation = 'Retail'
$OSLanguage = 'en-us'

#Set OSDCloud Vars
$Global:MyOSDCloud = [ordered]@{
    Restart = [bool]$True
    RecoveryPartition = [bool]$true
    OEMActivation = [bool]$True
    WindowsUpdate = [bool]$false
    ClearDiskConfirm = [bool]$True
    WindowsUpdateDrivers = [bool]$false
    WindowsDefenderUpdate = [bool]$true
    SetTimeZone = [bool]$false
    ShutdownSetupComplete = [bool]$false
    SyncMSUpCatDriverUSB = [bool]$false
    CheckSHA1 = [bool]$false
}

#Launch OSDCloud
Write-Host "Starting OSDCloud Stralfors edition!" -ForegroundColor Green
Write-Host "Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage"

Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage -SkipODT -ZTI
