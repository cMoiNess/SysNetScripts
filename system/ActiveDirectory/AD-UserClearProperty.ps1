# Import Active Directory module
Import-Module ActiveDirectory

# Spécifiez le nom d'utilisateur et l'attribut à supprimer
$Username = "dupond"
$Attribute = "msExchALObjectVersion"

# Supprimez l'attribut de l'utilisateur
Set-ADUser -Identity $Username -Clear $Attribute

# Vérifiez si l'attribut a été supprimé (optionnel)
$User = Get-ADUser -Identity $Username -Properties $Attribute
$User.$Attribute
