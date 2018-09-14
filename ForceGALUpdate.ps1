# First, let's get our creds...
	$UserCredential = Get-Credential

#Then define the PS Session...
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

#Now we Open the Session
	Import-PSSession $Session

#Let's go to work...
	Set-AddressList -Identity "All users"

#Close the session or bad things happen!!!
	Remove-PSSession $Session
