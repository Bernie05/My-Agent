# Opens one Windows Terminal window named "court" with Clerk (runs the trial),
# Attacker, Defender and Judge - as 4 panes in one tab (-Layout split, default)
# or as 4 tabs (-Layout tabs). It returns right away; the trial is over when
# <Dir>\trial.done exists.
param(
    [Parameter(Mandatory)][string]$Dir,          # fresh trial folder containing casefile.md
    [int]$Rounds = 2,
    [string]$ProjectDir = (Get-Location).Path,   # agents run here so they can read project files
    [ValidateSet('tabs', 'split')][string]$Layout = 'split'
)

$ErrorActionPreference = 'Stop'
$Dir = (Resolve-Path $Dir).Path
$ProjectDir = (Resolve-Path $ProjectDir).Path
if (-not (Test-Path (Join-Path $Dir 'casefile.md'))) { throw "casefile.md not found in $Dir" }
if (Get-ChildItem $Dir -Filter '*.out.md') { throw "$Dir already holds a trial - use a new folder" }
Remove-Item (Join-Path $Dir 'trial.done'), (Join-Path $Dir 'status.md') -ErrorAction SilentlyContinue
$Rounds = [Math]::Max(1, [Math]::Min(5, $Rounds))

$ps = 'powershell.exe -NoLogo -NoExit -ExecutionPolicy Bypass -File'
$agentTab = "`"$PSScriptRoot\agent-tab.ps1`" -Dir `"$Dir`""
$tabs = @(
    @{ Title = 'Clerk';    Color = '#767676'; Cmd = "$ps `"$PSScriptRoot\clerk.ps1`" -Dir `"$Dir`" -Rounds $Rounds" },
    @{ Title = 'Attacker'; Color = '#C50F1F'; Cmd = "$ps $agentTab -Agent lawyer-attacker -Model sonnet -Tools Read,Grep,Glob,WebSearch,WebFetch" },
    @{ Title = 'Defender'; Color = '#0037DA'; Cmd = "$ps $agentTab -Agent lawyer-defender -Model sonnet -Tools Read,Grep,Glob,WebSearch,WebFetch" },
    @{ Title = 'Judge';    Color = '#F1C40F'; Cmd = "$ps $agentTab -Agent judge -Model opus -Tools Read,Grep,Glob" }
)

if (Get-Command wt.exe -ErrorAction SilentlyContinue) {
    $pane = { param($t) "--title $($t.Title) --suppressApplicationTitle --tabColor $($t.Color) -d `"$ProjectDir`" $($t.Cmd)" }
    if ($Layout -eq 'split') {
        # 2x2 grid: Clerk | Attacker on top, Judge | Defender below.
        $parts = @(
            "new-tab $(& $pane $tabs[0])",
            "split-pane -V $(& $pane $tabs[1])",
            "split-pane -H $(& $pane $tabs[2])",
            'move-focus left',
            "split-pane -H $(& $pane $tabs[3])"
        )
    }
    else {
        $parts = $tabs | ForEach-Object { "new-tab $(& $pane $_)" }
    }
    Start-Process wt.exe -ArgumentList ('-w court ' + ($parts -join ' ; '))
}
else {
    # No Windows Terminal: one PowerShell window per agent instead.
    foreach ($t in $tabs) {
        $argLine = $t.Cmd -replace '^powershell\.exe ', ''
        Start-Process powershell.exe -ArgumentList $argLine -WorkingDirectory $ProjectDir
    }
}
Write-Output "Trial started ($Layout): $Dir"
