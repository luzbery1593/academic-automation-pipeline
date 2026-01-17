# 2_Obtener_Citas.ps1
$BaseDir = $PSScriptRoot
$InputFile = Join-Path $BaseDir "lista_dois.txt"
$OutputFile = Join-Path $BaseDir "bibliografia_previa.txt"

Write-Host "--- FASE 2: DESCARGANDO CITAS APA 7ma (API CROSSREF) ---" -ForegroundColor Yellow

# Verificamos si existe la lista de la Fase 1
if (Test-Path $InputFile) {
    # Leemos DOIs saltando líneas vacías
    $Dois = Get-Content $InputFile | Where-Object { $_.Trim() -ne "" }
    
    if ($Dois.Count -eq 0) {
        Write-Host "AVISO: El archivo lista_dois.txt está vacío." -ForegroundColor Red
        return
    }
    
    # Limpiamos/Creamos el archivo de salida
    $null | Out-File $OutputFile -Encoding utf8

    foreach ($Doi in $Dois) {
        $Doi = $Doi.Trim()
        Write-Host "Solicitando datos de: $Doi... " -NoNewline
        
        $ApiUrl = "https://doi.org/$Doi"
        try {
            # Solicitud con formato específico APA y Timeout de seguridad
            $Response = Invoke-WebRequest -Uri $ApiUrl -Headers @{"Accept"="text/x-bibliography; style=apa"} -TimeoutSec 20 -ErrorAction Stop
            
            $Cita = $Response.Content.Trim()
            
            # Guardamos la cita y nos aseguramos de que haya un salto de línea
            $Cita + "`r`n" | Out-File $OutputFile -Append -Encoding utf8
            
            Write-Host "[DESCARGADO]" -ForegroundColor Green
            
            # PAUSA TÁCTICA: 2 segundos para ser "amigables" con el servidor
            Start-Sleep -Seconds 2
            
        } catch {
            Write-Host "[ERROR: $($_.Exception.Message)]" -ForegroundColor Red
        }
    }
    Write-Host "`nFase completada. Revisa bibliografia_previa.txt" -ForegroundColor Cyan
} else {
    Write-Host "ERROR: No se encontró lista_dois.txt en esta carpeta." -ForegroundColor Red
}