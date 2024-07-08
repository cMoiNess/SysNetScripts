# Allows you to change the suffix of Active Directory users' email addresses.
# You must be careful when executing this script because if you have hybrid azure ad join this can cause a service shutdown !


# Choose the OU where the script will be applied as well as the old and new suffix to change
$OUPath = "OU=Users,OU=IT,DC=exemple,DC=fr"
$oldMail = "@myoldmail.com"
$newMail = "@mynewmail.com"

Get-ADUser -Filter "mail -like '*$($oldMail)*'" -SearchBase $OUPath -prop mail |
ForEach-Object {
    Set-ADUser -Identity $_ -EmailAddress ($_.mail -replace $oldMail, $newMail)
}