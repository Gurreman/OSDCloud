#Säkerställ senaste OSD-modulen (startnet-uppdateringen kan ha missats p.g.a. sent nätverk)
try {
    $installed = (Get-Module OSD -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1).Version
    $gallery   = (Find-Module OSD -ErrorAction Stop).Version
    if ([version]$gallery -gt [version]$installed) {
        Write-Host "Uppdaterar OSD $installed -> $gallery" -ForegroundColor Cyan
        Install-Module OSD -Scope AllUsers -Force -SkipPublisherCheck -ErrorAction Stop
    }
    Remove-Module OSD -Force -ErrorAction SilentlyContinue
    Import-Module OSD -Force
} catch {
    Write-Warning "Kunde inte uppdatera OSD-modulen: $_"
}
Write-Host "OSD-version: $((Get-Module OSD).Version)" -ForegroundColor Green

#Force English culture so date parsing in OSD works under a Swedish WinPE locale
$culture = [System.Globalization.CultureInfo]::GetCultureInfo('en-US')
[System.Threading.Thread]::CurrentThread.CurrentCulture = $culture
[System.Threading.Thread]::CurrentThread.CurrentUICulture = $culture

#Variables to define the Windows OS / Edition etc to be applied during OSDCloud
$OSName = 'Windows 11 26H2 x64'
$OSEdition = 'Pro'
$OSActivation = 'Retail'
$OSLanguage = 'en-us'

#Fallback om modulen fortfarande inte känner till vald OS-version
$valid = (Get-Command Start-OSDCloud).Parameters['OSName'].Attributes |
    Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] } |
    Select-Object -ExpandProperty ValidValues
if ($OSName -notin $valid) {
    Write-Warning "$OSName stöds inte av OSD $((Get-Module OSD).Version) – använder Windows 11 25H2 x64"
    $OSName = 'Windows 11 25H2 x64'
}

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
