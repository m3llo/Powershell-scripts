#You need to retrieve the MessageID of the email you need the headers for by running a message trace before running these commands.

# First we need credentials to use to connect to O365
	$UserCredential = Get-Credential

# Then we need to define the PS session to connect to O365
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

# Now we Open the Session
	Import-PSSession $Session -DisableNameChecking

# This var is used in our loop later. Gives us a Yes or No choice
    $choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&Y","&N")

# Let's create a loop so we only have to run once...
while ( $true ) {

	# Prompt for vars
	    $MessageID = Read-Host -Prompt 'MessageID: '

	# Do the work
	    Get-MessageTrace -MessageId $MessageID | Get-MessageTraceDetail | Select  MessageID, Date, Event, Action, Detail, Data | Out-GridView

	# Ask if user needs to run again. If not, break the loop
	    $choice = $Host.UI.PromptForChoice("Run Again?","Change another mailbox?",$choices,0)
	    if ( $choice -ne 0 ) {
	    break
	    }
}

# Close the Session or bad things happen!!!
	Remove-PSSession $Session