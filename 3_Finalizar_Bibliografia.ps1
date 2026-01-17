# 3_Finalizar_Bibliografia.ps1
$BaseDir = $PSScriptRoot
$InputFile = Join-Path $BaseDir "bibliografia_previa.txt"
$FinalFile = Join-Path $BaseDir "REFERENCIAS_FINALES_APA7.txt"

Write-Host "--- FASE 3: ORDENAMIENTO Y LIMPIEZA APA 7 ---" -ForegroundColor Magenta

if (Test-Path $InputFile) {
    # 1. Leemos las citas, eliminamos espacios en blanco al inicio/final
    $CitasRaw = Get-Content $InputFile | Where-Object { $_.Trim() -ne "" }
    
    # 2. MEJORA: Eliminamos duplicados exactos y ordenamos alfabéticamente
    # Esto asegura que cada autor aparezca una sola vez aunque esté en varios PDFs
    $CitasLimpias = $CitasRaw | Sort-Object | Select-Object -Unique
    
    # 3. Guardamos con codificación UTF8 para respetar tildes y eñes
    $CitasLimpias | Out-File -FilePath $FinalFile -Encoding utf8

    Write-Host "----------------------------------------------" -ForegroundColor Gray
    Write-Host "¡PROCESO COMPLETADO CON EXITO!" -ForegroundColor Green
    Write-Host "Citas procesadas: $($CitasRaw.Count)" -ForegroundColor Gray
    Write-Host "Citas únicas finales: $($CitasLimpias.Count)" -ForegroundColor White
    Write-Host "Archivo: REFERENCIAS_FINALES_APA7.txt" -ForegroundColor Cyan
    Write-Host "----------------------------------------------" -ForegroundColor Gray
} else {
    Write-Host "ERROR: No se encontró 'bibliografia_previa.txt'. Ejecuta el paso 2." -ForegroundColor Red
}