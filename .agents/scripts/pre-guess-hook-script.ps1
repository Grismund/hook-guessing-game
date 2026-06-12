try {
    $raw = [Console]::In.ReadToEnd()
    $payload = $raw | ConvertFrom-Json -ErrorAction Stop

    $toolArgs = $payload.toolArgs
    $toolArgsStr = if ($toolArgs -is [string]) {
        $toolArgs
    } else {
        $toolArgs | ConvertTo-Json -Compress -ErrorAction SilentlyContinue
    }

    if ($null -eq $toolArgsStr -or $toolArgsStr -notmatch "GUESS\.md") {
        exit 0
    }

    $repoRoot     = (Resolve-Path (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "..\..")).Path
    $outputsDir   = Join-Path $repoRoot "outputs"
    $solutionFile = Join-Path $outputsDir "SOLUTION.md"
    $guessFile    = Join-Path $outputsDir "GUESS.md"

    if (-not (Test-Path $solutionFile)) {
        $solution = Get-Random -Minimum 1 -Maximum 101
        Set-Content -Path $solutionFile -Value "$solution" -NoNewline
    }

    if (-not (Test-Path $guessFile)) {
        Set-Content -Path $guessFile -Value "" -NoNewline
    }
} catch {
    # Fail-closed: always exit 0 to avoid blocking the tool call
}

exit 0
