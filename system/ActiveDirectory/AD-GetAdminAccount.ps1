# Définir les groupes d'administrateurs à vérifier
$adminGroups = @("Administrators", "Domain Admins", "Enterprise Admins", "Schema Admins")

# Parcourir chaque groupe et lister les membres
foreach ($group in $adminGroups) {
    Get-ADGroupMember -Identity $group | Select-Object Name,SamAccountName,DistinguishedName, @{Name="Group";Expression={$group}}
}