#First we need credentials to use to connect to O365
	$UserCredential = Get-Credential
#Then we need to define the PS session to connect to O365
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
#Now we Open the Session
	Import-PSSession $Session
#Let's create a loop so we only have to run once...
$choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&Y","&N")
while ( $true ) {
    #Define the mailbox you want to do work on...
        $MailboxAlias = Read-Host -Prompt 'Mailbox Alias: '
    #Time to do work!
	    set-mailboxregionalconfiguration $MailboxAlias -dateformat 'M/d/yyyy' -timeformat 'h:mm tt' -language 'en-US' -timezone 'Eastern Standard Time'
        set-mailboxcalendarconfiguration $MailboxAlias -workinghourstimezone 'Eastern Standard Time'
        Write-Host "'$MailboxAlias' time zone updated"
        $choice = $Host.UI.PromptForChoice("Run Again?","Change another mailbox?",$choices,0)
	    if ( $choice -ne 0 ) {
		break
	}
}
#Close the Session or bad things happen!!!
	Remove-PSSession $Session