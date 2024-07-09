# Import Active Directory module
Import-Module ActiveDirectory

# Number of days of inactivity
$daysInactive = 90
$inactiveDate = (Get-Date).AddDays(-$daysInactive)

# Find inactive users
$inactiveUsers = Get-ADUser -Filter {LastLogonDate -lt $inactiveDate} -Properties LastLogonDate

# Show results in console with Write-Host
$inactiveUsers | ForEach-Object {
    $name = $_.Name
    $userPrincipalName = $_.UserPrincipalName
    $lastLogonDate = $_.LastLogonDate
    Write-Host "Name: $name"
    Write-Host "UserPrincipalName: $userPrincipalName"
    Write-Host "LastLogonDate: $lastLogonDate"
    Write-Host "-------------------------"
}