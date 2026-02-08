$root = 'c:\Joshua\workspace\media-and-communcation\repocentric-media-and-communication'
$docs = Join-Path $root 'docs'
Get-ChildItem -Path $docs -Recurse -Filter '*.md' | ForEach-Object {
    $path = $_.FullName
    $content = Get-Content -Raw -LiteralPath $path
    $orig = $content
    $changed = $false
    # Remove leading ```markdown or ``` lines
    if ($content -match '^```.*\r?\n') {
        $content = $content -replace '^```.*\r?\n', ''
        $changed = $true
    }
    # Remove trailing ```
    if ($content -match '\r?\n```\s*$') {
        $content = $content -replace '\r?\n```\s*$', ''
        $changed = $true
    }
    if ($changed -and $content -ne $orig) {
        Set-Content -LiteralPath $path -Value $content -Encoding UTF8
        Write-Output ("Removed code fences: {0}" -f $path)
    }
}
