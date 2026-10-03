# Runs the trial: attacker -> defender for N rounds (early stop when the attacker
# finds no material holes), then the judge. It hands work to the agent tabs through
# "<agent>.<step>.in.md" files and waits for their ".out.md". It ends by writing
# verdict.md, status.md and trial.done.
param(
    [Parameter(Mandatory)][string]$Dir,
    [int]$Rounds = 2,
    [int]$StepTimeoutMin = 15
)

$OutputEncoding = [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding $false
$Host.UI.RawUI.WindowTitle = 'Clerk'
$colors = @{ 'lawyer-attacker' = 'Red'; 'lawyer-defender' = 'Blue'; 'judge' = 'Yellow' }

function Invoke-Step([string]$Agent, [string]$Tag, [string]$Prompt) {
    $in = Join-Path $Dir "$Agent.$Tag.in.md"
    $out = Join-Path $Dir "$Agent.$Tag.out.md"
    $err = Join-Path $Dir "$Agent.$Tag.err.md"
    Set-Content $in $Prompt -Encoding UTF8
    Write-Host "[$(Get-Date -Format HH:mm:ss)] -> $Agent ($Tag)" -ForegroundColor $colors[$Agent]
    $deadline = (Get-Date).AddMinutes($StepTimeoutMin)
    while (-not (Test-Path $out)) {
        if (Test-Path $err) { throw "$Agent $Tag failed: $(Get-Content $err -Raw)" }
        if ((Get-Date) -gt $deadline) { throw "$Agent $Tag timed out after $StepTimeoutMin min" }
        Start-Sleep -Seconds 2
    }
    Write-Host "[$(Get-Date -Format HH:mm:ss)] <- $Agent ($Tag) done" -ForegroundColor $colors[$Agent]
    return (Get-Content $out -Raw -Encoding UTF8)
}

try {
    $case = Get-Content (Join-Path $Dir 'casefile.md') -Raw -Encoding UTF8
    Write-Host ' CLERK '.PadRight(40) -BackgroundColor Gray -ForegroundColor Black
    Write-Host "=== Court in session: $Rounds round(s) max ===`n" -ForegroundColor White
    Write-Host $case

    $record = @()
    $lastDefense = $null
    $roundsRun = 0
    $early = $false

    for ($r = 1; $r -le $Rounds; $r++) {
        $roundsRun = $r
        $p = "Round $r of $Rounds.`n`n$case"
        if ($lastDefense) {
            $p += "`n`n# Previous defense brief (its ENHANCED VERSION is now the work under attack)`n`n$lastDefense"
        }
        $attack = Invoke-Step 'lawyer-attacker' "r$r" $p
        $record += "## Round $r - attack`n`n$attack"
        if ($attack -match 'No further material holes') { $early = $true; break }

        $p = "Round $r of $Rounds.`n`n$case"
        if ($lastDefense) { $p += "`n`n# Your previous defense brief`n`n$lastDefense" }
        $p += "`n`n# Attack brief to answer`n`n$attack"
        $lastDefense = Invoke-Step 'lawyer-defender' "r$r" $p
        $record += "## Round $r - defense`n`n$lastDefense"
    }

    $note = if ($early) { ', ended early: no further material holes' } else { '' }
    $p = "Deliver the final verdict.`n`n$case`n`n# Trial record ($roundsRun round(s)$note)`n`n" + ($record -join "`n`n")
    $verdict = Invoke-Step 'judge' 'final' $p

    $verdictFile = Join-Path $Dir 'verdict.md'
    Set-Content $verdictFile $verdict -Encoding UTF8
    Set-Content (Join-Path $Dir 'status.md') "done`nrounds: $roundsRun`nended early: $early" -Encoding UTF8
    Write-Host "`n=== Verdict delivered: $verdictFile ===" -ForegroundColor Green

    # Open the verdict for reading: VS Code (current window) if installed, else Notepad.
    if (Get-Command code -ErrorAction SilentlyContinue) { & code -r $verdictFile }
    else { Start-Process notepad.exe $verdictFile }
}
catch {
    Set-Content (Join-Path $Dir 'status.md') "failed`n$($_.Exception.Message)" -Encoding UTF8
    Write-Host "Trial failed: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    New-Item (Join-Path $Dir 'trial.done') -ItemType File -Force | Out-Null
}
