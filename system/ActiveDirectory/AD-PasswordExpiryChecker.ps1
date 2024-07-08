# In console displays all accounts whose password will expire soon. A “daysUntilExpiration” variable allows you to define the number of days you want.
# Can be run on any computer that has an account with sufficient rights

# Import Active Directory module
Import-Module ActiveDirectory

# Set the number of days to check for password expiration
$daysUntilExpiration = 5

# Get current date
$currentDate = Get-Date

# Calculate deadline
$expirationDate = $currentDate.AddDays($daysUntilExpiration)

# Get all Active Directory users with the msDS-UserPasswordExpiryTimeComputed property
$users = Get-ADUser -Filter * -Properties "msDS-UserPasswordExpiryTimeComputed"

# Filter users whose password expires based on the number of days set (daysUntilExpiration)
$expiringUsers = $users | Where-Object {
    if ($_. "msDS-UserPasswordExpiryTimeComputed" -ne $null) {
        try {
            [datetime]::FromFileTime($_. "msDS-UserPasswordExpiryTimeComputed") -lt $expirationDate
        } catch {
            $false  # Ignores users whose conversion fails
        }
    } else {
        $false  # Ignore users whose msDS-UserPasswordExpiryTimeComputed is $null
    }
}

# Sort users by password expiration date
$sortedExpiringUsers = $expiringUsers | Sort-Object {
    [datetime]::FromFileTime($_. "msDS-UserPasswordExpiryTimeComputed")
}

# Show users whose password is about to expire, sorted by expiration date
$sortedExpiringUsers | Select-Object Name, SamAccountName, @{Name="PasswordExpiryDate";Expression={[datetime]::FromFileTime($_. "msDS-UserPasswordExpiryTimeComputed")}} | Format-Table -AutoSize