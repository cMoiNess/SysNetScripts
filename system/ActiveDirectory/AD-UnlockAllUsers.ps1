# Import Active Directory module
Import-Module ActiveDirectory

# Recovers all locked user accounts
$lockedUsers = Search-ADAccount -LockedOut -UsersOnly

# Unlocks each user account
foreach ($user in $lockedUsers) {
    Unlock-ADAccount -Identity $user
    Write-Host "Compte déverrouillé : $($user.SamAccountName)"
}

Write-Host "Tous les comptes verrouillés ont été déverrouillés."