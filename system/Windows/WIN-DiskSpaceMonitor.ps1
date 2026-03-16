# Monitors disk space on a list of servers and sends an alert email when usage exceeds the defined threshold.
# It is recommended to deploy this script with Task Scheduler

# List of servers to monitor
$servers = @("SRV-AD01", "SRV-AD02", "SRV-AD03")

# Alert threshold in percent (alert if used space exceeds this value)
$thresholdPercent = 80

# Set SMTP server and sender email address
$smtpServer = "smtp.exemple.com"
$smtpFrom = "noreply@exemple.fr"
$smtpTo = "admin@exemple.fr"
$smtpSubject = "Alerte espace disque"
$smtpBodyTemplate = @"
<html>
<body style='font-size:16px;'>
Bonjour,<br><br>
<span style='color:red;'>Le serveur <b>{0}</b> - disque <b>{1}</b> est à <b>{2}%</b> de capacité utilisée ({3} Go libres sur {4} Go).</span><br><br>
Veuillez libérer de l'espace ou augmenter la capacité du disque.<br><br>
Merci,<br>
Le service informatique
</body>
</html>
"@

# Function to check disk space on a remote server
function Check-DiskSpace {
    param (
        [string]$server
    )

    try {
        $disks = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $server -Filter "DriveType=3" -ErrorAction Stop

        foreach ($disk in $disks) {
            $totalGB   = [math]::Round($disk.Size / 1GB, 2)
            $freeGB    = [math]::Round($disk.FreeSpace / 1GB, 2)
            $usedPercent = [math]::Round((($disk.Size - $disk.FreeSpace) / $disk.Size) * 100, 1)

            Write-Output "$server - $($disk.DeviceID) : $usedPercent% used ($freeGB GB free / $totalGB GB)"

            if ($usedPercent -ge $thresholdPercent) {
                $smtpBody = [string]::Format($smtpBodyTemplate, $server, $disk.DeviceID, $usedPercent, $freeGB, $totalGB)

                $mailMessage = New-Object System.Net.Mail.MailMessage
                $mailMessage.From = $smtpFrom
                $mailMessage.To.Add($smtpTo)
                $mailMessage.Subject = "$smtpSubject - $server ($($disk.DeviceID))"
                $mailMessage.Body = $smtpBody
                $mailMessage.IsBodyHtml = $true
                $mailMessage.BodyEncoding = [System.Text.Encoding]::UTF8

                $smtpClient = New-Object System.Net.Mail.SmtpClient($smtpServer)
                $smtpClient.Send($mailMessage)

                Write-Output "Alert sent for $server - $($disk.DeviceID)"
            }
        }
    }
    catch {
        Write-Output "Failed to check disk space on $server : $_"
    }
}

# Run check on each server
foreach ($server in $servers) {
    Check-DiskSpace -server $server
}
