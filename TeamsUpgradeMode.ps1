# First we need credentials to use to connect to O365
	$UserCredential = Get-Credential

# Then we need to define the PS session to connect to O365
	$Session = new-csonlinesession -Credential $UserCredential

# Now we Open the Session
	Import-PSSession $Session

# This var is used in our loop later. Gives us a Yes or No choice
    $choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&Y","&N")

# Let's create a loop so we only have to run once...
while ( $true ) {

	# Prompt for vars
	    $user = Read-Host -Prompt 'User to change to Teams Only mode:'

	# Do the work
	    grant-csteamsupgradepolicy -policyname UpgradeToTeams -identity $user

	# Ask if user needs to run again. If not, break the loop
	    $choice = $Host.UI.PromptForChoice("Run Again?","Change another mailbox?",$choices,0)
	    if ( $choice -ne 0 ) {
	    break
	    }
}

# Close the Session or bad things happen!!!
	Remove-PSSession $Session
