# 7_Inyector_Final.ps1
$BaseDir = $PSScriptRoot
$InputFile = Join-Path $BaseDir "articulo_completo_ia.md"
$OutputDir = Join-Path $BaseDir "manuscrito"

if (!(Test-Path $OutputDir)) { New-Item -ItemType Directory -Path $OutputDir }

Write-Host "--- FASE 7: DISTRIBUCIÓN MAESTRA DE SECCIONES ---" -ForegroundColor Cyan

if (!(Test-Path $InputFile)) {
    Write-Host "ERROR: No se encontró 'articulo_completo_ia.md'. Asegúrate de haber guardado la respuesta de la IA." -ForegroundColor Red
    return
}

# Leemos el contenido completo
$Contenido = Get-Content $InputFile -Raw -Encoding UTF8

# Diccionario de Secciones con Regex mejorado
# (?si) = Ignora mayúsculas/minúsculas y permite que el punto (.) incluya saltos de línea
# (?=#|$) = Busca hasta el siguiente título (#) o hasta el final del archivo ($)
$Secciones = @{
    "01_Abstract.md"     = "(?si)#+.*?(RESUMEN|ABSTRACT).*?(?=#+|$)"
    "02_Introduccion.md" = "(?si)#+.*?(INTRODUC).*?(?=#+|$)"
    "03_Revision.md"     = "(?si)#+.*?(REVISI|MARCO|LITERAT).*?(?=#+|$)"
    "04_Metodologia.md"  = "(?si)#+.*?(METODOLO|MÉTODO).*?(?=#+|$)"
    "05_Resultados.md"   = "(?si)#+.*?(RESULTAD).*?(?=#+|$)"
    "06_Conclusiones.md" = "(?si)#+.*?(CONCLU|DISCUS|REFEREN|BIBLIOGR).*?(?=#+|$)"
}

foreach ($File in ($Secciones.Keys | Sort-Object)) {
    Write-Host "Buscando contenido para $File... " -NoNewline
    
    if ($Contenido -match $Secciones[$File]) {
        # Extraemos el texto, eliminamos espacios innecesarios y lo guardamos
        $TextoSeccion = $Matches[0].Trim()
        $Path = Join-Path $OutputDir $File
        
        $TextoSeccion | Out-File -FilePath $Path -Encoding utf8
        Write-Host "[OK]" -ForegroundColor Green
    } else {
        Write-Host "[NO DETECTADO]" -ForegroundColor Yellow
    }
}

Write-Host "--- PROCESO DE INYECCIÓN FINALIZADO ---" -ForegroundColor Cyan