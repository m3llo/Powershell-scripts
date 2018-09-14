## This script pulls the product key from the motherboard and activates windows with it 		##
## Written by Jason Merrifield on 8/27/2018 								##
## Ref: https://blogs.technet.microsoft.com/rgullick/2013/06/13/activating-windows-with-powershell/ 	##


$computer = gc env:computername

$key = (Get-WmiObject -Class SoftwareLicensingService).OA3xOriginalProductKey

$service = get-wmiObject -Query "select * from SoftwareLicensingService" -computername $computer

$service.InstallProductKey($key)

$service.RefreshLicenseStatus()