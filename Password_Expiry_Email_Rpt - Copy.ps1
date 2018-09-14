#This script will send a report on AD user account password expiration dates to your email address.

function sendMail()
{
	$smartHost = "<host>.mail.protection.outlook.com"
	$sendto = "<youremailaddress>"
	$sendFrom = "noreply@<domain>"
	$mailSubject = "Password Expiry Report"
	$mailBody = (Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | out-string )
	Send-MailMessage -Subject $mailSubject -From $sendFrom -To $sendTo -SmtpServer $smartHost -body $mailBody
}

sendmail