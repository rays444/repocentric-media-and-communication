$root = 'c:\Joshua\workspace\media-and-communcation\repocentric-media-and-communication\docs'

Write-Output "=== FOLDER STRUCTURE VERIFICATION ===" | Out-String
Write-Output "" | Out-String

for ($i = 1; $i -le 1; $i++) {
    $unitPath = Join-Path $root "unit$i\content"
    Write-Output "Unit $i Content Structure:" | Out-String
    Get-ChildItem -Path $unitPath -Recurse -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'index.md') } | Select-Object -First 10 | ForEach-Object {
        $rel = $_.FullName.Substring($unitPath.Length).TrimStart('\') -replace '\\', '/'
        $indexPath = Join-Path $_.FullName 'index.md'
        $title = (Get-Content -Path $indexPath | Select-String -Pattern '^title: (.+)$' | ForEach-Object { $_.Matches[0].Groups[1].Value })
        Write-Output ("  ✓ /$rel/ — $title") | Out-String
    }
    Write-Output "" | Out-String
}

Write-Output "=== UNIT INDEX LINKS ===" | Out-String
$unit1Index = Join-Path $root 'unit1\index.md'
$content = Get-Content -Raw -Path $unit1Index
$contentLink = $content | Select-String -Pattern '\[Content\]\(.*\)' 
Write-Output ($contentLink | Out-String)
