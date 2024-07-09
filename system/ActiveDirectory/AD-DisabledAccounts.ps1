# Find disabled accounts
$disabledUsers = Get-ADUser -Filter {Enabled -eq $false} -Properties LastLogonDate

# Show results in console
$disabledUsers | ForEach-Object {
    $name = $_.Name
    $userPrincipalName = $_.UserPrincipalName
    $lastLogonDate = $_.LastLogonDate
    Write-Host "Name: $name"
    Write-Host "UserPrincipalName: $userPrincipalName"
    Write-Host "LastLogonDate: $lastLogonDate"
    Write-Host "-------------------------"
}