# Worker for one court agent. Runs in its own Windows Terminal tab, waits for
# "<agent>.<step>.in.md" files in the trial folder, runs the agent headless on
# each one, prints the brief and writes "<agent>.<step>.out.md" (or .err.md).
param(
    [Parameter(Mandatory)][string]$Agent,
    [Parameter(Mandatory)][string]$Dir,
    [string]$Model = 'sonnet',
    [string]$Tools = 'Read,Grep,Glob'
)

$OutputEncoding = [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding $false
$Host.UI.RawUI.WindowTitle = $Agent
$colors = @{ 'lawyer-attacker' = 'Red'; 'lawyer-defender' = 'Blue'; 'judge' = 'Yellow' }
$color = $colors[$Agent]; if (-not $color) { $color = 'Cyan' }
$toolList = $Tools -split ','

Write-Host (" $($Agent.ToUpper()) ".PadRight(40)) -BackgroundColor $color -ForegroundColor Black
Write-Host "=== $Agent ($Model) - waiting for work ===" -ForegroundColor $color
Write-Host "Trial folder: $Dir`n" -ForegroundColor DarkGray

while (-not (Test-Path (Join-Path $Dir 'trial.done'))) {
    $pending = Get-ChildItem $Dir -Filter "$Agent.*.in.md" -ErrorAction SilentlyContinue |
        Where-Object {
            -not (Test-Path ($_.FullName -replace '\.in\.md$', '.out.md')) -and
            -not (Test-Path ($_.FullName -replace '\.in\.md$', '.err.md'))
        } | Sort-Object Name
    if (-not $pending) { Start-Sleep -Seconds 2; continue }

    foreach ($in in $pending) {
        $out = $in.FullName -replace '\.in\.md$', '.out.md'
        $err = $in.FullName -replace '\.in\.md$', '.err.md'
        $step = $in.Name -replace '\.in\.md$', ''
        Write-Host "--- $step  ($(Get-Date -Format HH:mm:ss))" -ForegroundColor $color

        # Show what the agent is asked. The Case File is replaced by a note (the
        # Clerk pane shows it) and long questions are cut to $maxLines lines.
        $prompt = Get-Content $in.FullName -Raw -Encoding UTF8
        $case = Get-Content (Join-Path $Dir 'casefile.md') -Raw -Encoding UTF8
        $ask = $prompt.Replace($case.Trim(), '[Case File - see the Clerk pane]').Trim() -replace '(\r?\n){3,}', "`n`n" -split "`r?`n"
        $maxLines = 40
        Write-Host ' QUESTION ' -BackgroundColor DarkGray -ForegroundColor White
        Write-Host (($ask | Select-Object -First $maxLines) -join "`n") -ForegroundColor Gray
        if ($ask.Count -gt $maxLines) {
            Write-Host "... ($($ask.Count - $maxLines) more lines in $($in.Name))" -ForegroundColor DarkGray
        }
        Write-Host "`nworking..." -ForegroundColor $color

        $text = $prompt |
            & claude -p --agent $Agent --model $Model --allowedTools $toolList `
                --permission-mode dontAsk --no-session-persistence 2>&1 | Out-String

        if ($LASTEXITCODE -ne 0 -or -not $text.Trim()) {
            Set-Content $err "exit $LASTEXITCODE`n$text" -Encoding UTF8
            Write-Host "FAILED (exit $LASTEXITCODE)`n$text" -ForegroundColor Red
            continue
        }
        # Write to a temp file first so the clerk never reads a half-written brief.
        Set-Content "$out.tmp" $text -Encoding UTF8
        Move-Item "$out.tmp" $out -Force
        Write-Host ''
        Write-Host ' ANSWER ' -BackgroundColor $color -ForegroundColor Black
        Write-Host $text
        Write-Host "--- $step  done ($(Get-Date -Format HH:mm:ss))`n" -ForegroundColor $color
    }
}
Write-Host "=== Trial closed ===" -ForegroundColor $color
