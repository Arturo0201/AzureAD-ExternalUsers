# Ruta de salida del archivo CSV en la carpeta de Descargas del usuario actual
$OutputFile = [Environment]::GetFolderPath("Desktop") + "\invitados.csv"

# Crear el contenido del archivo CSV
$CSVContent = @()
$CSVContent += 'version:v1.0'
$CSVContent += 'Direccion de correo electronico para enviar la invitacion [inviteeEmail] Obligatorio,URL de redireccionamiento [inviteRedirectURL] Obligatorio,Enviar el mensaje de invitacion (true o false) [sendEmail],Mensaje de invitacion personalizado [customizedMessageBody]'

# Pedir al usuario que ingrese los datos de los invitados
do {
    $GuestEmail = Read-Host "Ingrese la direccion de correo electronico para enviar la invitacion (inviteeEmail)"
    $RedirectURL =  "https://myapplications.microsoft.com"
    $SendEmail = $true
    $CustomizedMessage = "Welcome to GMV!!"
    
    $CSVContent += "$GuestEmail,$RedirectURL,$SendEmail,$CustomizedMessage"
    
    $Continue = Read-Host "¿Desea agregar otro invitado? (Si/No)"
} while ($Continue.ToUpper() -eq "SI")

# Verificar si se ingresaron datos de invitados
if ($CSVContent.Count -le 2) {
    Write-Host "No se ingresaron datos de invitados. Saliendo..."
    exit
}

# Guardar el contenido en el archivo CSV con la codificacion correcta
$CSVContent | Out-File -FilePath $OutputFile -Encoding UTF8

Write-Host "Archivo CSV generado con exito: $OutputFile"