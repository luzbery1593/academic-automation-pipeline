# 1_Extraer_Dois_PRO.ps1

# MEJORA 1: Ruta dinámica (funciona donde sea que pongas la carpeta)
$BaseDir = $PSScriptRoot
$ArchivoSalida = Join-Path $BaseDir "lista_dois.txt"
$DoiPattern = "10\.\d{4,9}/[-._;()/:a-zA-Z0-9]+"

Write-Host "--- FASE 1: RECOLECCION DE IDENTIFICADORES (MODO PRO) ---" -ForegroundColor Cyan
Write-Host "Carpeta de trabajo: $BaseDir" -ForegroundColor Gray

# Verificamos si existe pdftotext
if (!(Get-Command pdftotext -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: pdftotext no está instalado o no está en el PATH." -ForegroundColor Red
    return
}

$Documentos = Get-ChildItem -Path $BaseDir -Filter *.pdf

$Resultados = foreach ($Doc in $Documentos) {
    Write-Host "Analizando: $($Doc.Name)... " -NoNewline
    
    # Extraemos solo las primeras 2 páginas para ir más rápido (el DOI suele estar ahí)
    $Texto = pdftotext -l 2 -nopgbrk -enc UTF-8 "$($Doc.FullName)" - 2>$null
    
    # MEJORA 2: Búsqueda más robusta
    $Match = [regex]::Match($Texto, $DoiPattern)
    
    if ($Match.Success) {
        Write-Host "[OK]" -ForegroundColor Green
        $Match.Value.TrimEnd('.') # Limpieza por si captura un punto al final de una frase
    } else {
        Write-Host "[NO DETECTADO]" -ForegroundColor Yellow
    }
}

# MEJORA 3: Filtrar duplicados y valores vacíos antes de guardar
$DoisLimpios = $Resultados | Where-Object { $_ } | Select-Object -Unique

$DoisLimpios | Out-File -FilePath $ArchivoSalida -Encoding utf8

Write-Host "`n===============================================" -ForegroundColor Cyan
Write-Host " PROCESO FINALIZADO" -ForegroundColor White
Write-Host " PDFs analizados: $($Documentos.Count)" -ForegroundColor Gray
Write-Host " DOIs únicos encontrados: $($DoisLimpios.Count)" -ForegroundColor Green
Write-Host " Archivo: lista_dois.txt" -ForegroundColor Yellow
Write-Host "===============================================" -ForegroundColor Cyan