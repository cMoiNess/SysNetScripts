# Allows you to unlock a user list

# List of user (samAccountName)
$users = 'Guest', 'toto'

# Unlock account samAccountName if exist in Active Directory
foreach ($user in $users) {
    try {
        Unlock-ADAccount -Identity $user
    }
    catch {
        $false
    }
}