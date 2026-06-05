$repoRoot     = (Resolve-Path (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "..\..")).Path
$solutionFile = Join-Path $repoRoot "SOLUTION.md"

# No active game — skip silently
if (-not (Test-Path $solutionFile)) { exit 0 }

$guessRaw = Get-Content (Join-Path $repoRoot "GUESS.md") -Raw -ErrorAction SilentlyContinue
if ($null -eq $guessRaw) { exit 0 }
$guess  = $guessRaw.Trim()
$secret = (Get-Content $solutionFile -Raw).Trim()

if ([string]::IsNullOrEmpty($guess)) { exit 0 }

if ([int]$guess -eq [int]$secret) {
    Remove-Item $solutionFile -Force
    "{`"additionalContext`": `"CORRECT! The number was $secret.`"}"
    exit 0
} elseif ([int]$guess -gt [int]$secret) {
    "{`"additionalContext`": `"LOWER`"}"
    exit 0
} else {
    "{`"additionalContext`": `"HIGHER`"}"
    exit 0
}
