$root = 'c:\Joshua\workspace\media-and-communcation\repocentric-media-and-communication'
$docs = Join-Path $root 'docs'
$count = 0
Get-ChildItem -Path $docs -Recurse -Filter 'index.md' | ForEach-Object {
    $path = $_.FullName
    $content = Get-Content -Raw -LiteralPath $path
    $orig = $content
  
    # Remove leading ```markdown or other code fence at start
    if ($content -match '^```') {
        $content = $content -replace '^```[^\n]*\n', ''
    }
  
    # Remove trailing ``` code fence
    if ($content -match '\n```\s*$') {
        $content = $content -replace '\n```\s*$', ''
    }
  
    if ($content -ne $orig) {
        Set-Content -LiteralPath $path -Value $content -Encoding UTF8
        $count++
        Write-Output ("Removed fences: {0}" -f (Split-Path $path -Parent))
    }
}
Write-Output ("Total files fixed: {0}" -f $count)
