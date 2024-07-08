# Send an email to users whose password will expire soon. Send the email every day until the change or expiration.

# Import Active Directory module
Import-Module ActiveDirectory

# Set the number of days before the password expires
$daysToExpire = 5

# Set SMTP server and sender email address
$smtpServer = "smtp.exemple.com"
$smtpFrom = "noreply@exemple.fr"
$smtpSubject = "Votre mot de passe va bientôt expirer"
$smtpBodyTemplate = @"
<html>
Bonjour {0},<br><br>
<body style='font-size:32px;'>
<span style='color:red;'>Votre mot de passe va expirer dans {1} jours. Veuillez le changer dès que possible.</span><br><br>
</body>
Merci,<br>
Le service informatique
</html>
"@

# Set current date and end date
$startDate = Get-Date
$endDate = $startDate.AddDays($daysToExpire)

# Get the list of users whose password will expire between today and the expiration date

$users = Get-ADUser -Filter {Enabled -eq $true -and PasswordNeverExpires -eq $false} -Property "DisplayName", "EmailAddress", "msDS-UserPasswordExpiryTimeComputed" | Where-Object {
    $_."msDS-UserPasswordExpiryTimeComputed" -ne $null
} | Where-Object {
    $_."msDS-UserPasswordExpiryTimeComputed" -ge $startDate.ToFileTime() -and $_."msDS-UserPasswordExpiryTimeComputed" -le $endDate.ToFileTime()
}

# Send an email to each user
foreach ($user in $users) {
    $emailAddress = $user.EmailAddress
    $displayName = $user.DisplayName
    $expiryDate = [DateTime]::FromFileTime($user."msDS-UserPasswordExpiryTimeComputed")
    $daysLeft = ($expiryDate - $startDate).Days

    if ($emailAddress) {
        $smtpBody = [string]::Format($smtpBodyTemplate, $displayName, $daysLeft)

        # Create a message with UTF-8 encoding
        $mailMessage = New-Object System.Net.Mail.MailMessage
        $mailMessage.From = $smtpFrom
        $mailMessage.To.Add($emailAddress)
        $mailMessage.Subject = $smtpSubject
        $mailMessage.Body = $smtpBody
        $mailMessage.IsBodyHtml = $true
        $mailMessage.BodyEncoding = [System.Text.Encoding]::UTF8

        # Configure the SMTP client
        $smtpClient = New-Object System.Net.Mail.SmtpClient($smtpServer)
        $smtpClient.Send($mailMessage)
    }
}
