# Ruta de salida del archivo CSV en la carpeta de Descargas del usuario actual
$OutputFile = [Environment]::GetFolderPath("Desktop") + "\invitados.csv"

# Crear el contenido del archivo CSV
$CSVContent = @()
$CSVContent += 'version:v1.0'
$CSVContent += 'Direccion de correo electronico para enviar la invitacion [inviteeEmail] Obligatorio,URL de redireccionamiento [inviteRedirectURL] Obligatorio,Enviar el mensaje de invitacion (true o false) [sendEmail],Mensaje de invitacion personalizado [customizedMessageBody]'

# Pedir al usuario que ingrese los datos de los invitados
do {
    $GuestEmail = Read-Host "Ingrese la direccion de correo electronico para enviar la invitacion (inviteeEmail) o presione Enter para salir"
    if ([string]::IsNullOrWhiteSpace($GuestEmail)) {
        break
    }
    $RedirectURL =  "https://myapplications.microsoft.com"
    $SendEmail = $FALSE
    $CustomizedMessage = "Welcome to GMV!!"
    
    $CSVContent += "$GuestEmail,$RedirectURL,$SendEmail,$CustomizedMessage"
    
} while ($true)

# Verificar si se ingresaron datos de invitados
if ($CSVContent.Count -le 2) {
    Write-Host "No se ingresaron datos de invitados. Saliendo..."
    exit
}

# Guardar el contenido en el archivo CSV con la codificacion correcta
$CSVContent | Out-File -FilePath $OutputFile -Encoding UTF8

Write-Host "Archivo CSV generado con exito: $OutputFile"

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
            Write-Host "Valor invalido en la columna 'sendEmail' para el usuario $inviteeEmail. Se omitira la invitacion."
            continue
        }

        $invitation = New-AzureADMSInvitation -InvitedUserEmailAddress $inviteeEmail `
                                              -InviteRedirectUrl $inviteRedirectURL `
                                              -SendInvitationMessage $sendEmail

        Write-Host "Invitacion enviada a $inviteeEmail"
    }
} catch {
    Write-Host "Error: $_"
}

# Desconectarse de Azure AD
Disconnect-AzureAD