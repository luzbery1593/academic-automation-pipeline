# 11_FINALIZADOR_TOTAL.ps1
$BaseDir = $PSScriptRoot
$ManuscritoDir = Join-Path $BaseDir "manuscrito"
$ArchivoIntermedioMd = Join-Path $BaseDir "ARTICULO_UNIFICADO_LIMPIO.md"
$ArchivoFinalWord = Join-Path $BaseDir "ARTICULO_FINAL_DOCTORADO.docx"

Write-Host "--- INICIANDO CONSOLIDACIÓN Y CONVERSIÓN FINAL ---" -ForegroundColor Cyan

# 1. LIMPIEZA INICIAL: Borramos archivos previos para evitar errores
if (Test-Path $ArchivoIntermedioMd) { Remove-Item $ArchivoIntermedioMd -Force }

# 2. UNIFICACIÓN: Listamos los archivos en orden 01, 02, 03...
$ArchivosMD = Get-ChildItem -Path $ManuscritoDir -Filter "*.md" | Sort-Object Name

if ($ArchivosMD.Count -eq 0) {
    Write-Host "ERROR: No hay archivos .md en la carpeta 'manuscrito'." -ForegroundColor Red
    return
}

# Usamos StringBuilder para máxima velocidad
$StringBuilder = New-Object System.Text.StringBuilder

foreach ($Arch in $ArchivosMD) {
    Write-Host "Añadiendo: $($Arch.Name)..." -ForegroundColor Gray
    $TextoSeccion = Get-Content -Path $Arch.FullName -Raw -Encoding UTF8
    
    [void]$StringBuilder.AppendLine($TextoSeccion)
    [void]$StringBuilder.AppendLine("`r`n") # Espacio de seguridad entre secciones
}

# Guardamos el Markdown unificado
$StringBuilder.ToString() | Out-File -FilePath $ArchivoIntermedioMd -Encoding utf8
Write-Host "[OK] Contenido unificado en Markdown." -ForegroundColor Green

# 3. CONVERSIÓN A WORD: Usamos Pandoc para el resultado profesional
Write-Host "Exportando a Word... " -NoNewline
if (Get-Command pandoc -ErrorAction SilentlyContinue) {
    # Ejecutamos la conversión
    pandoc "$ArchivoIntermedioMd" -o "$ArchivoFinalWord"
    
    if (Test-Path $ArchivoFinalWord) {
        Write-Host "[EXITO]" -ForegroundColor Green
        Write-Host "`n===============================================" -ForegroundColor Cyan
        Write-Host "¡TODO LISTO! El archivo Word ha sido generado." -ForegroundColor White
        Write-Host "Ruta: $ArchivoFinalWord" -ForegroundColor Yellow
        Write-Host "===============================================" -ForegroundColor Cyan
    }
} else {
    Write-Host "[ERROR]" -ForegroundColor Red
    Write-Host "AVISO: Pandoc no está instalado. El archivo unificado quedó en Markdown (.md)." -ForegroundColor Yellow
}