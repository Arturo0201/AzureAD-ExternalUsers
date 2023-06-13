$tabla_invitados = @()

# Pedir al usuario que ingrese los datos de los invitados
do {
    $GuestEmail = Read-Host "Ingrese la direccion de correo electronico para enviar la invitacion (inviteeEmail) o presione Enter para salir"
    if ([string]::IsNullOrWhiteSpace($GuestEmail)) {
        break
    }

    $RedirectURL =  "https://myapplications.microsoft.com"
    $CustomizedMessage = "Welcome to GMV!!"
    
    $tabla_invitados += [PSCustomObject]@{

        'inviteeEmail'= $GuestEmail
        'inviteRedirectURL'= $RedirectURL
        'customizedMessageBody'= "Welcome to GMV!!"
    }
    
} while ($true)


# Importar el modulo de AzureAD
Import-Module AzureAD
Connect-AzureAD

try {

    # Leer el archivo CSV
    $users = $tabla_invitados

    # Enviar las invitaciones a los usuarios
    foreach ($user in $users) {
        $inviteeEmail = $user.inviteeEmail
        $inviteRedirectURL = $user.inviteRedirectURL
        $CustomizedMessage = $user.customizedMessageBody

         New-AzureADMSInvitation -InvitedUserEmailAddress $inviteeEmail `
                                              -InviteRedirectUrl $inviteRedirectURL `
                                              -SendInvitationMessage $True `
                                              -InvitedUserMessageInfo $CustomizedMessage
        Write-Host "Invitacion enviada a $inviteeEmail"
    }
} catch {
    Write-Host "Error: $_"
}

# Desconectarse de Azure AD
Disconnect-AzureAD