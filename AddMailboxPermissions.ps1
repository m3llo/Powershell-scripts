# First we need credentials to use to connect to O365
	$UserCredential = Get-Credential

# Then we need to define the PS session to connect to O365
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

# Now we Open the Session
	Import-PSSession $Session

# This var is used in our loop later. Gives us a Yes or No choice
    $choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&Y","&N")

# Let's create a loop so we only have to run once...
while ( $true ) {

	# Prompt for vars
	    $Mailbox = Read-Host -Prompt 'Mailbox: '
	    $User = Read-Host -Prompt 'User to grant access to: '

	# Do the work
	    Add-MailboxPermission -Identity $Mailbox -User $User -AccessRights FullAccess -InheritanceType All

	# Ask if user needs to run again. If not, break the loop
	    $choice = $Host.UI.PromptForChoice("Run Again?","Change another mailbox?",$choices,0)
	    if ( $choice -ne 0 ) {
	    break
	    }
}

# Close the Session or bad things happen!!!
	Remove-PSSession $Session
