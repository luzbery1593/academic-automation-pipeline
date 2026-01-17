# 5_Generar_Mapa_Citas.ps1
$BaseDir = $PSScriptRoot
$InputFile = Join-Path $BaseDir "REFERENCIAS_FINALES_APA7.txt"
$MapaFile = Join-Path $BaseDir "mapa_citas.txt"

Write-Host "--- FASE 5: GENERANDO MAPA DE CITAS PARA LA IA ---" -ForegroundColor Cyan

if (Test-Path $InputFile) {
    # Leemos las citas eliminando líneas vacías y espacios extra
    $Citas = Get-Content $InputFile | Where-Object { $_.Trim() -ne "" }
    
    if ($Citas.Count -eq 0) {
        Write-Host "AVISO: El archivo de referencias está vacío." -ForegroundColor Red
        return
    }

    $Contador = 1
    $Resultado = foreach ($Cita in $Citas) {
        # Formato estandarizado: REF_1, REF_2, etc. 
        # Es el lenguaje que mejor entiende ChatGPT/Gemini
        "REF_${Contador}: $($Cita.Trim())"
        $Contador++
    }

    # Guardamos en UTF8 para que no se rompan las tildes
    $Resultado | Out-File $MapaFile -Encoding utf8
    
    Write-Host "----------------------------------------------" -ForegroundColor Gray
    Write-Host "[OK] Mapa de citas generado con éxito." -ForegroundColor Green
    Write-Host "Total de referencias mapeadas: $($Citas.Count)" -ForegroundColor White
    Write-Host "Archivo: mapa_citas.txt" -ForegroundColor Yellow
    Write-Host "----------------------------------------------" -ForegroundColor Gray
} else {
    Write-Host "ERROR: No se encontró 'REFERENCIAS_FINALES_APA7.txt'. Ejecuta el paso 3." -ForegroundColor Red
}