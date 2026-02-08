$root = 'c:\Joshua\workspace\media-and-communcation\repocentric-media-and-communication'
$search = Join-Path $root 'docs\unit*\content\**\*.md'
Get-ChildItem -Path $root -Recurse -Filter '*.md' | Where-Object { $_.FullName -like (Join-Path $root 'docs\unit*\content\*') } | ForEach-Object {
    $path = $_.FullName
    $content = Get-Content -Raw -ErrorAction Stop -LiteralPath $path
    $original = $content
    $changed = $false

    # Remove wrapping ```markdown and ``` code fences at start/end
    if ($content -match '^[\s\S]*?```markdown\r?\n') {
        $content = $content -replace '^[\s\S]*?```markdown\r?\n', ''
        $changed = $true
    }
    if ($content -match '\r?\n```\s*$') {
        $content = $content -replace '\r?\n```\s*$', ''
        $changed = $true
    }

    # Trim leading BOM and whitespace
    $content = $content.TrimStart([char]0xFEFF)

    # If file doesn't start with YAML front matter, add one
    if (-not ($content -match '^(---\s*\r?\n)')) {
        $fname = [System.IO.Path]::GetFileNameWithoutExtension($path)
        $title = $fname -replace '^[0-9_\-\s]*', '' -replace '_', ' ' -replace '-', ' '
        $fm = "---`r`nlayout: page`r`ntitle: $title`r`n---`r`n`r`n"
        $content = $fm + $content
        $changed = $true
    }

    if ($changed -and $content -ne $original) {
        Set-Content -LiteralPath $path -Value $content -Encoding UTF8
        Write-Output ("Fixed front matter: {0}" -f $path)
    }
    else {
        Write-Output ("No change: {0}" -f $path)
    }
}
