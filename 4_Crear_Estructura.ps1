# 4_Crear_Estructura.ps1
$BaseDir = $PSScriptRoot
$ManuscritoDir = Join-Path $BaseDir "manuscrito"

Write-Host "--- FASE 4: ARQUITECTURA DEL MANUSCRITO Q1 ---" -ForegroundColor Cyan

# 1. Crear la carpeta del manuscrito si no existe
if (!(Test-Path $ManuscritoDir)) {
    New-Item -ItemType Directory -Path $ManuscritoDir
    Write-Host "[OK] Carpeta 'manuscrito' creada en: $ManuscritoDir" -ForegroundColor Green
}

# 2. Definir las secciones críticas para un artículo de alto impacto (Q1)
# Nota: Los nombres coinciden con los patrones de búsqueda del Módulo 7
$Secciones = @(
    "01_Abstract.md",
    "02_Introduccion.md",
    "03_Revision.md",
    "04_Metodologia.md",
    "05_Resultados.md",
    "06_Conclusiones.md"
)

# 3. Generar los archivos con metadatos base
foreach ($Archivo in $Secciones) {
    $Path = Join-Path $ManuscritoDir $Archivo
    
    # Extraemos un título limpio para el encabezado
    $TituloLimpio = ($Archivo -replace '^\d+_', '' -replace '\.md$', '').ToUpper()
    
    $Plantilla = @"
# $TituloLimpio

> Sección generada automáticamente para el flujo de investigación IA.
> Estado: Pendiente de Inyección de Contenido.

---
"@
    
    # Solo creamos el archivo si NO existe (para no borrar trabajo previo)
    if (!(Test-Path $Path)) {
        $Plantilla | Out-File -FilePath $Path -Encoding utf8
        Write-Host "Archivo generado: $Archivo" -ForegroundColor Gray
    } else {
        Write-Host "Saltando: $Archivo (ya existe)" -ForegroundColor Yellow
    }
}

Write-Host "`nEstructura lista. Puedes proceder a la Fase 5." -ForegroundColor Cyan