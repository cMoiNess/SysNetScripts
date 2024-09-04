# Define the administrator groups to check
$adminGroups = @("Administrators", "Domain Admins", "Enterprise Admins", "Schema Admins")

# Browse each group and list members
foreach ($group in $adminGroups) {
    Get-ADGroupMember -Identity $group | Select-Object Name,SamAccountName,DistinguishedName, @{Name="Group";Expression={$group}}
}