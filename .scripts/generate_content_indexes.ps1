$root = 'c:\Joshua\workspace\media-and-communcation\repocentric-media-and-communication'
for ($i = 1; $i -le 7; $i++) {
    $unitDir = Join-Path $root ('docs\unit' + $i + '\content')
    if (Test-Path $unitDir) {
        $outFile = Join-Path $unitDir 'index.md'
        $title = "Unit $i Content"
        $lines = @()
        $lines += '---'
        $lines += 'layout: page'
        $lines += "title: $title"
        $lines += '---'
        $lines += ''
        $mdFiles = Get-ChildItem -Path $unitDir -Recurse -Filter '*.md' | Where-Object { $_.Name -ne 'index.md' } | Sort-Object FullName
        foreach ($f in $mdFiles) {
            $tMatch = Select-String -Path $f.FullName -Pattern '^title:\s*(.+)$' -SimpleMatch -Quiet:$false
            $t = $null
            if ($tMatch) {
                $t = (Select-String -Path $f.FullName -Pattern '^title:\s*(.+)$' -SimpleMatch).Matches[0].Groups[1].Value
            }
            if (-not $t) { $t = [System.IO.Path]::GetFileNameWithoutExtension($f.Name) -replace '_', ' ' }
            $rel = $f.FullName.Substring($root.Length) -replace '\\', '/'
            $relUrl = $rel -replace '^/docs', ''
            $relUrl = $relUrl -replace '\.md$', '.html'
            $liquid = "{{ '" + $relUrl + "' | relative_url }}"
            $lines += "- [$t]($liquid)"
        }
        Set-Content -Path $outFile -Value $lines -Encoding UTF8
        Write-Output ("Wrote index: {0}" -f $outFile)
    }
    else {
        Write-Output ("Missing unit dir: {0}" -f $unitDir)
    }
}
