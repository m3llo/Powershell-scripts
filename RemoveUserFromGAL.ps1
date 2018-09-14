$choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&Y","&N")
while ( $true ) {
	$user = Read-Host -Prompt 'Username: '
	$usercommand = get-aduser $user -properties *
	$usercommand.msExchHideFromAddressLists = "True"
    Set-ADUser -Instance $usercommand
	Write-Host "$usercommand.DisplayName will be removed from the GAL when Azure AD Sync and replication has taken place..."
	$choice = $Host.UI.PromptForChoice("Rerun the script?","",$choices,0)
	if ( $choice -ne 0 ) {
		break
	}
}