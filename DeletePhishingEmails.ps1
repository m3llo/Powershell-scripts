###				Delete Phishing Emails Script				###
###				Written by Jason Merrifield				###
###		This script is designed to delete phishing emails by sender.		###
###		Emails are sent to recipient's Deleted Items folder			###
###		This script is written for Office 365/Exchange Online.			###
###		By using this script, you accept all responsibility and liability.	###
###		The creator is not responsible or liable for any damages caused		###
###		by running this script.							###

# On error, stop the script
	$ErrorActionPreference = "Stop"
# Let's create a var to ask yes and no questions.
	$choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&Y","&N")

# Let's put in an explicit disclaimer so that what this script does is fully understood
	Write-Host "

						DISCLAIMER

		THIS SCRIPT IS FOR PHISHING OR SPAM EMAILS THAT ARE RECEIVED FROM RANDOM EMAIL ADDRESSES
		AND SHOULD NOT BE USED IF THE SENDER IS SOMEONE WHOM ANY USER IN YOUR COMPANY HAS RECEIVED
		EMAIL FROM IN THE PAST. THIS SCRIPT WILL DELETE ALL EMAILS EVER RECEIVED BY ANYONE FROM
		THE SPECIFIED SENDER.

		BY USING THIS SCRIPT, YOU ACCEPT ALL RESPONSIBILITY AND LIABILITY FOR THE RESULTS. 
		THE CREATOR IS NOT RESPONSIBLE OR LIABLE FOR ANY DAMAGES CAUSED BY RUNNING THIS SCRIPT.

		IT SHOULD ONLY BE USED FOR OFFICE 365/EXCHANGE ONLINE SYSTEMS.
		 
		IF YOU ARE UNSURE ABOUT ANY OF THE ABOVE, DO NOT CONTINUE.
		IF YOU ARE SURE YOU WANT TO CONTINUE, DO SO AT YOUR OWN RISK."

# Ask if user wants to continue. If not, do not run
	    $choice = $Host.UI.PromptForChoice("Continue?","Are you sure you want to run this script?",$choices,0)
	    if ( $choice -ne 0 ) {
	    exit
	    }


### BEGIN SCRIPT ###
# First we need credentials to use to connect to O365
	Write-Host "Please enter your Office 365 Global Administrator credentials"
	$UserCredential = Get-Credential

# Then we need to define the PS session to connect to O365 Security and Compliance Center
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid -Credential $UserCredential -Authentication Basic -AllowRedirection 

#Import the session
	Write-Host "Connecting to Microsoft 365 Security and Compliance Center"
	Import-PSSession $Session -AllowClobber -DisableNameChecking 
	Write-Host "Connection Successful"

# Get the email sender's address or domain name, then run, create, and start the search
	$sender = Read-Host -Prompt 'Offending Sender email address or domain name: '
	New-ComplianceSearch -Name $sender -ExchangeLocation all -ContentMatchQuery From:$sender
	Write-Host "Beginning Search for offending emails"
	Start-ComplianceSearch -Identity $sender

# Let's check to see the status of the search and loop until it is completed:
	while ( $true ) {
		# Keep checking for search status until it is completed
		$search = Get-ComplianceSearch -Identity $sender
		if ( $search.status -eq 'Completed' ) {
			Write-Host 'The search is completed'
			break
			}
			else {
			Write-Host 'The search is not complete. Please wait. Checking again...'
			Start-Sleep -s 5
		}
	}

# Let's review the search results
	Write-Host "Returning list of recipients"
	Get-ComplianceSearch -Identity $sender | Format-List
	Write-Host "
		Please review the above list to make sure you aren't deleting an unusual amount of emails.
		You may also be interested in seeing who received these email(s)."

# Ask if user wants to continue. If not, do not run
	$choice = $Host.UI.PromptForChoice("Continue?","Do you want to send these emails to the recipient's Deleted Items folder? If no, script will end.",$choices,0)
	if ( $choice -ne 0 ) {
		Remove-PSSession $Session
		exit
	}

# Do the needful
	Write-Host "Sending email to user(s) Deleted Items folder(s)"
	New-ComplianceSearchAction -SearchName $sender -Purge -PurgeType SoftDelete

# Let's check to see the status of the deletion and loop until it is completed:
	while ( $true ) {
		# Keep checking for search status until it is completed
		$search = Get-ComplianceSearchAction -Identity $sender'_Purge'
		if ( $search.status -eq 'Completed' ) {
			Write-Host 'The email has been deleted. Have a great day!'
			break
			}
			else {
			Write-Host 'The deletion is not complete. Please wait Checking again...'
			Start-Sleep -s 5
		}
	}

Remove-PSSession $Session

### END SCRIPT ###


	


	