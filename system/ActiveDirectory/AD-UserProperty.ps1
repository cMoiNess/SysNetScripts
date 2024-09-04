# Import Active Directory module
Import-Module ActiveDirectory

# Specify the username whose attributes you want to display
$Username = "dupond"

# Retrieve user information
$User = Get-ADUser -Identity $Username -Properties *

# View all user attributes
$User | Select-Object -Property *