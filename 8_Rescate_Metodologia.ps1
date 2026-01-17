# 8_Rescate_Metodologia.ps1
$BaseDir = $PSScriptRoot
$ArchivoMaster = Join-Path $BaseDir "articulo_completo_ia.md"
$ArchivoDestino = Join-Path $BaseDir "manuscrito\04_Metodologia.md"

Write-Host "--- FASE 8: RESCATE DE METODOLOGÍA CRÍTICA ---" -ForegroundColor Cyan

if (!(Test-Path $ArchivoMaster)) {
    Write-Host "ERROR: No se encontró el archivo maestro 'articulo_completo_ia.md'." -ForegroundColor Red
    return
}

# Leemos el contenido completo
$Texto = Get-Content -Path $ArchivoMaster -Raw -Encoding UTF8

# Patrón Profesional: 
# Busca desde un título que contenga METODO, DISEÑO o PROCEDIM
# Se detiene justo antes del título de RESULTADOS, DISCUSIÓN o TABLAS
$PatronMetodologia = "(?si)#+.*?(METODO|DISEÑO|PROCEDIM).*?(?=#+.*?(RESULTAD|DISCUS|TABLA|$))"

if ($Texto -match $PatronMetodologia) {
    $MetodologiaExtraida = $Matches[0].Trim()
    
    # Aseguramos que la carpeta de destino existe
    $DestDir = Split-Path $ArchivoDestino
    if (!(Test-Path $DestDir)) { New-Item -ItemType Directory -Path $DestDir }
    
    # Guardamos la sección rescatada
    $MetodologiaExtraida | Out-File -FilePath $ArchivoDestino -Encoding utf8
    
    Write-Host "----------------------------------------------" -ForegroundColor Gray
    Write-Host "¡ÉXITO! Metodología localizada y extraída." -ForegroundColor Green
    Write-Host "Archivo actualizado: 04_Metodologia.md" -ForegroundColor White
    Write-Host "----------------------------------------------" -ForegroundColor Gray
} else {
    Write-Host "AVISO: No se pudo aislar la metodología automáticamente." -ForegroundColor Yellow
    Write-Host "Verifica si el título en el archivo original usa otra palabra clave." -ForegroundColor Gray
}