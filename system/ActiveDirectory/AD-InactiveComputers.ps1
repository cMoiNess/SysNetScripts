# Import Active Directory module
Import-Module ActiveDirectory

# Number of days of inactivity
$daysInactive = 90
$inactiveDate = (Get-Date).AddDays(-$daysInactive)

# Find inactive computer accounts
$inactiveComputers = Get-ADComputer -Filter {LastLogonDate -lt $inactiveDate} -Properties LastLogonDate

# View inactive computer accounts
foreach ($computer in $inactiveComputers) {
    Write-Host "Nom de l'ordinateur: $($computer.Name), Derniere connexion: $($computer.LastLogonDate)"
}