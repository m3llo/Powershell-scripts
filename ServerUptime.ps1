$choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&Y","&N")
while ( $true ) {
	$server = Read-Host -Prompt 'Server name: '
	$LastBootUpTime = Get-WmiObject Win32_OperatingSystem -Comp $server | select -Exp LastBootUpTime
	$BootTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($LastBootUpTime)
	Write-Host "'$server' last boot up time was '$BootTime'"
	$choice = $Host.UI.PromptForChoice("Rerun the script?","",$choices,0)
	if ( $choice -ne 0 ) {
		break
	}
}