###			Add Domain or Email Address to Allow list script			###
###				 Written by Jason Merrifield				###
###				  marynjasonmerri@yahoo.com				###

# On error, stop the script
	$ErrorActionPreference = "Stop"

# First we need credentials to use to connect to O365
    Write-Host "Enter your O365 Global Administrator credentials"
	$UserCredential = Get-Credential

# Then we need to define the PS session to connect to O365
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

# Now we Open the Session
	Import-PSSession $Session -AllowClobber

# Prompt for vars
    $domainlist = Read-Host -Prompt 'Domain(s) to add to Allow list (press ENTER if none, use single space between entries): '
	$addresslist = Read-Host -Prompt 'Email address to add to Allow list (press ENTER if none, use single space between entries): '
    $domains = $domainlist -split " "
    $addresses = $addresslist -split " "

# Add Domains to list, if any
    if (!$domainlist) {
        Write-Host "No domains to add...skipping"
    } else {
        Write-Host "Adding domain name(s) to Default spam Allow list...."
        Set-HostedContentFilterPolicy -Identity Default -AllowedSenderDomains @{Add=$domains}
    }

# Add email addresses to list, if any
    if (!$addresslist) {
        Write-Host "No addresses to add...skipping"
    } else {
        Write-Host "Adding email address(es) to Default spam Allow list...."
        Set-HostedContentFilterPolicy -Identity Default -AllowedSenders @{Add=$addresses}
    }

# Close the Session or bad things happen!!!
	Remove-PSSession $Session