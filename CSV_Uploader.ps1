
# Importar el módulo de AzureAD
Import-Module AzureAD
Connect-AzureAD

try {
    # Ruta del archivo CSV con la lista de usuarios a invitar
    $csvFile = [Environment]::GetFolderPath("Desktop") + "\invitados.csv"

    # Leer el archivo CSV
    $users = Import-Csv -Path $csvFile -Header "inviteeEmail", "inviteRedirectURL", "sendEmail", "customizedMessageBody" | Select-Object -Skip 1

    # Enviar las invitaciones a los usuarios
    foreach ($user in $users) {
        $inviteeEmail = $user.inviteeEmail
        $inviteRedirectURL = $user.inviteRedirectURL

        if ($user.sendEmail -eq "True") {
            $sendEmail = $true
        } elseif ($user.sendEmail -eq "False") {
            $sendEmail = $false
        } else {
            Write-Host "Valor inválido en la columna 'sendEmail' para el usuario $inviteeEmail. Se omitirá la invitación."
            continue
        }

        $invitation = New-AzureADMSInvitation -InvitedUserEmailAddress $inviteeEmail `
                                              -InviteRedirectUrl $inviteRedirectURL `
                                              -SendInvitationMessage $sendEmail

        Write-Host "Invitación enviada a $inviteeEmail"
    }
} catch {
    Write-Host "Error: $_"
}

# Desconectarse de Azure AD
Disconnect-AzureAD
