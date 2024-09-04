# Import Active Directory module
Import-Module ActiveDirectory

# Specify the username and attribute to delete
$Username = "dupond"
$Attribute = "msExchALObjectVersion"

# Remove user attribute
Set-ADUser -Identity $Username -Clear $Attribute

# Check if the attribute was deleted
$User = Get-ADUser -Identity $Username -Properties $Attribute
$User.$Attribute
