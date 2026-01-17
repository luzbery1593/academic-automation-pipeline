# 6_Unificador_Maestro.ps1
$BaseDir = $PSScriptRoot
$CitasFile = Join-Path $BaseDir "REFERENCIAS_FINALES_APA7.txt"
$PromptFile = Join-Path $BaseDir "PROMPT_FINAL_ARTICULO.txt"

Write-Host "--- FASE 6: UNIFICANDO PROYECTO Y GENERANDO PROMPT Q1 ---" -ForegroundColor Cyan

if (Test-Path $CitasFile) {
    $Citas = Get-Content $CitasFile | Where-Object { $_.Trim() -ne "" }
    $MapaCitas = New-Object System.Text.StringBuilder
    $i = 1
    
    foreach ($Cita in $Citas) { 
        [void]$MapaCitas.AppendLine("REF_${i}: $($Cita.Trim())")
        $i++ 
    }

    # Instrucciones mejoradas para asegurar el nivel Doctorado Q1
    $PromptBase = @"
ACTÚA COMO UN INVESTIGADOR DE NIVEL DOCTORADO, EXPERTO EN IA EDUCATIVA Y METODOLOGÍA CUANTITATIVA. 
TU OBJETIVO ES REDACTAR UN ARTÍCULO CIENTÍFICO ORIGINAL DE ALTO IMPACTO (ESTILO Q1).

### 1. DATOS DEL DISEÑO DE INVESTIGACIÓN:
- Enfoque: Cuantitativo, de alcance correlacional.
- Muestra: n=120 participantes (docentes de educación superior).
- Dimensiones de análisis: 
  1. Competencia Pedagógica Digital.
  2. Integración Curricular de la IA.
  3. Desarrollo Profesional Docente.

### 2. BIBLIOGRAFÍA REAL (OBLIGATORIO CITAR USANDO ESTOS IDs):
$($MapaCitas.ToString())

### 3. REQUERIMIENTO DE TABLAS ESTADÍSTICAS (FORMATO APA 7):
Genera datos simulados coherentes para 120 sujetos e incluye estas 3 tablas en la sección de RESULTADOS:
- Tabla 1: Estadísticos descriptivos (Media, Desviación Estándar) para las 3 dimensiones.
- Tabla 2: Coeficiente de Correlación de Pearson (r) entre dimensiones (debe haber correlaciones significativas p < 0.05).
- Tabla 3: Distribución de frecuencias de las herramientas de IA más utilizadas.

### 4. NORMAS DE ESTILO Y ESTRUCTURA:
- Sé ALTAMENTE REFLEXIVO y crítico. No te limites a describir, analiza el impacto.
- Metodología: Describe el proceso técnico de recolección de metadatos mediante scripts de PowerShell y el análisis correlacional.
- Formato: Markdown completo, con títulos (#), negritas y tablas bien definidas.

RESPONDE EMPEZANDO DIRECTAMENTE CON EL TÍTULO DEL ARTÍCULO.
"@

    $PromptBase | Out-File -FilePath $PromptFile -Encoding utf8
    
    Write-Host "----------------------------------------------" -ForegroundColor Gray
    Write-Host "¡PROCESO COMPLETADO EXITOSAMENTE!" -ForegroundColor Green
    Write-Host "Citas integradas: $($Citas.Count)" -ForegroundColor White
    Write-Host "Archivo generado: PROMPT_FINAL_ARTICULO.txt" -ForegroundColor Yellow
    Write-Host "----------------------------------------------" -ForegroundColor Gray
    Write-Host "PRÓXIMO PASO: Copia el contenido del archivo .txt y pégalo en tu IA." -ForegroundColor Cyan
}
else {
    Write-Host "ERROR: No se encuentra 'REFERENCIAS_FINALES_APA7.txt'." -ForegroundColor Red
}