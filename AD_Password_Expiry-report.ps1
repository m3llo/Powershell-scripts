$choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&Y","&N")
while ( $true ) {
	Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties “DisplayName”, “msDS-UserPasswordExpiryTimeComputed” | Select-Object -Property “Displayname”,@{Name=“ExpiryDate”;Expression={[datetime]::FromFileTime($_.“msDS-UserPasswordExpiryTimeComputed”)}} 
	$choice = $Host.UI.PromptForChoice("Did info display?","",$choices,0)
	if ( $choice -ne 0 ) {
		break
	}
}