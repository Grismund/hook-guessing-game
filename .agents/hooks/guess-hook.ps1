$repoRoot   = (Resolve-Path (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "..\..")).Path
$guess      = (Get-Content (Join-Path $repoRoot "GUESS.md") -Raw).Trim()
$secret     = (Get-Content (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "..\secret.txt") -Raw).Trim()

if ([int]$guess -eq [int]$secret) {
    "{`"additionalContext`": `"CORRECT! The number was $secret.`"}"
    exit 0
} elseif ([int]$guess -gt [int]$secret) {
    "{`"additionalContext`": `"LOWER`"}"
    exit 0
} else {
    "{`"additionalContext`": `"HIGHER`"}"
    exit 0
}
