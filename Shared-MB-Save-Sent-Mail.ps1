#First we need credentials to use to connect to O365
	$UserCredential = Get-Credential
#Then we need to define the PS session to connect to O365
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
#Now we Open the Session
	Import-PSSession $Session
#Time to do work!
	set-mailbox <mailbox@domain.com> -MessageCopyForSentAsEnabled $True
	set-mailbox <mailbox@domain.com> -MessageCopyForSendOnBehalfEnabled $True
#Close the Session or bad things happen!!!
	Remove-PSSession $Session
#For reference: https://blogs.technet.microsoft.com/exchange/2015/03/03/want-more-control-over-sent-items-when-using-shared-mailboxes/