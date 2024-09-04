# Import Active Directory module
Import-Module ActiveDirectory

# Number of days of inactivity
$daysInactive = 90
$inactiveDate = (Get-Date).AddDays(-$daysInactive)

# Find inactive users
$inactiveUsers = Get-ADUser -Filter {LastLogonDate -lt $inactiveDate} -Properties LastLogonDate

# Target OU for inactive accounts
$targetOU = "OU=AccountToDelete,DC=my,DC=lan"

# Process each inactive user
$inactiveUsers | ForEach-Object {
    $name = $_.Name
    $userPrincipalName = $_.UserPrincipalName
    $lastLogonDate = $_.LastLogonDate
    $distinguishedName = $_.DistinguishedName

    Write-Host "Name: $name"
    Write-Host "UserPrincipalName: $userPrincipalName"
    Write-Host "LastLogonDate: $lastLogonDate"
    Write-Host "-------------------------"
    
    # Move the user to the target OU
    try {
        Move-ADObject -Identity $distinguishedName -TargetPath $targetOU
        Write-Host "User $name moved to $targetOU"
    } catch {
        Write-Host "Failed to move user $name : $_"
    }
}
