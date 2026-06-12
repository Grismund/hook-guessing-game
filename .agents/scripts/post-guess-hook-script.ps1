$repoRoot     = (Resolve-Path (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "..\..")).Path
$outputsDir   = Join-Path $repoRoot "outputs"
$solutionFile = Join-Path $outputsDir "SOLUTION.md"
$guessFile    = Join-Path $outputsDir "GUESS.md"

# No active game — skip silently
if (-not (Test-Path $solutionFile)) { exit 0 }

$guessRaw = Get-Content $guessFile -Raw -ErrorAction SilentlyContinue
if ($null -eq $guessRaw) { exit 0 }
$guess  = $guessRaw.Trim()
$solution = (Get-Content $solutionFile -Raw).Trim()

if ([string]::IsNullOrEmpty($guess)) { exit 0 }

if ([int]$guess -eq [int]$solution) {
    Remove-Item $solutionFile -Force
    Remove-Item $guessFile    -Force
    "{`"additionalContext`": `"CORRECT! The number was $solution.`"}"
    exit 0
} elseif ([int]$guess -gt [int]$solution) {
    "{`"additionalContext`": `"LOWER - Guess again!`"}"
    exit 0
} else {
    "{`"additionalContext`": `"HIGHER - Guess again!`"}"
    exit 0
}
