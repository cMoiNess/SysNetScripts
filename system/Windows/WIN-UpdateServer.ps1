# List of servers to update
$servers = @("SRV-AD01", "SRV-AD02", "SRV-AD03")

# Function to install updates without restarting
function Install-WindowsUpdates {
    Write-Output "Starting updates on $env:COMPUTERNAME"
    
    # Check for updates
    $updates = Get-WindowsUpdate -AcceptAll -IgnoreReboot

    if ($updates.Count -eq 0) {
        Write-Output "No updates available on $env:COMPUTERNAME"
        return
    }

    # Install updates
    Install-WindowsUpdate -AcceptAll -IgnoreReboot -Install

    Write-Output "Updates installed on $env:COMPUTERNAME. A reboot is required to complete installation."
}

# Command to execute on each server
$scriptBlock = {
    Install-Module PSWindowsUpdate -Force -Confirm:$false
    Import-Module PSWindowsUpdate
    Install-WindowsUpdates
}

# Run updates on each server
foreach ($server in $servers) {
    Invoke-Command -ComputerName $server -ScriptBlock $scriptBlock -Credential (Get-Credential)
}
