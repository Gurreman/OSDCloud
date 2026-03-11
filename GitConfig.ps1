#Start-OSDCloud
add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;

public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint,
        X509Certificate certificate,
        WebRequest request,
        int certificateProblem) {
        return true;
    }
}
"@

[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

Write-Output "Basically trusting everything now..."

Write-Output "Starting OSDCloud. Good luck."

Start-OSDCloud -OSName 'Windows 11 25H2 x64' -OSLanguage en-us -OSEdition Enterprise -OSActivation Volume -SkipODT -ZTI -Restart
# Removed
#  -CloudDriver Dell,USB











