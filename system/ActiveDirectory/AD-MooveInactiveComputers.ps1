# Import Active Directory module
Import-Module ActiveDirectory

# Number of days of inactivity
$daysInactive = 90
$inactiveDate = (Get-Date).AddDays(-$daysInactive)

# Find inactive computer accounts
$inactiveComputers = Get-ADComputer -Filter {LastLogonDate -lt $inactiveDate} -Properties LastLogonDate

# Target OU for inactive computer accounts
$targetOU = "OU=ComputerToDelete,DC=my,DC=lan"

# Process each inactive computer
$inactiveComputers | ForEach-Object {
    $name = $_.Name
    $lastLogonDate = $_.LastLogonDate
    $distinguishedName = $_.DistinguishedName

    Write-Host "Nom de l'ordinateur: $name"
    Write-Host "Derniere connexion: $lastLogonDate"
    Write-Host "-------------------------"

    # Move the computer to the target OU
    try {
        Move-ADObject -Identity $distinguishedName -TargetPath $targetOU
        Write-Host "Ordinateur $name déplacé vers $targetOU"
    } catch {
        Write-Host "Échec du déplacement de l'ordinateur $name : $_"
    }
}
