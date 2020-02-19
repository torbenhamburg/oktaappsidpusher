### Okta Application Profile GUID Pusher
### Version 1.0
### 17.02.2020 by Torben Jaster
### Pushes the SID for a known AD User to an Okta App Profile based on the SAM Account

### Import Powershell Module
Import-Module OktaAPI
Import-Module ActiveDirectory

### Variables
$OktaLogFile = "$PSScriptRoot\sidpush.log"
$OktaAPIKey = ""
$OktaInstance = "https://myinstance.okta.com"
$OktaUserLimit = 500
$OktaAppID = "xxxxxxxxxxxxxxxxxxxx"

### Connect to Okta Instance
Connect-Okta $OktaAPIKey $OktaInstance
$OktaLogTime = Get-Date
Add-Content -Path $OktaLogFile -Value "$OktaLogTime SID run has started"

### Collect App Users
$OktaAppUsers = Get-OktaAppUser -appid $OktaAppID

### Get Users AD SID Information

$i = 0
ForEach ($OktaAppUser in $OktaAppUsers)
	{
	$i++
	$ADUser = Get-AdUser -Identity $OktaAppUser.credentials.userName -Properties SamAccountName,SID
	$OktaUserSID = $AdUser.SID
	$OktaUserID = $OktaAppUser.id
	$OktaAppProfile = @{
            profile = @{objectSID = "$OktaUserSID"}
            scope = "USER"
        }
	Set-OktaAppUser -appid $OktaAppID -userid $OktaUserID -appuser $OktaAppProfile
	}
$OktaLogTime = Get-Date
Add-Content -Path $OktaLogFile -Value "$OktaLogTime $i Users have been adjusted"
