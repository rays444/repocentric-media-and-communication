$root = 'c:\Joshua\workspace\media-and-communcation\repocentric-media-and-communication'
for ($i = 1; $i -le 7; $i++) {
  $unitDir = Join-Path $root ('docs\unit' + $i + '\content')
  if (Test-Path $unitDir) {
    $outFile = Join-Path $unitDir 'index.md'
    $title = "Unit $i Content"
    $lines = @()
    $lines += '---'
    $lines += 'layout: default'
    $lines += "title: $title"
    $lines += '---'
    $lines += ''
    $lines += "# Unit $i Content"
    $lines += ''
    
    # Get all folders (not .md files) in this unit's content directory
    $folders = Get-ChildItem -Path $unitDir -Recurse -Directory | Where-Object { $_.Parent.FullName -like "*$unitDir*" -and $_.Name -ne 'index' } | Sort-Object FullName
    
    foreach ($folder in $folders) {
      # Skip deep nested structures; only link to direct content folders
      $depth = ($folder.FullName.Substring($unitDir.Length) -split '\\' | Measure-Object).Count
      if ($depth -gt 2) { continue }
      
      $indexFile = Join-Path $folder.FullName 'index.md'
      if (Test-Path $indexFile) {
        $content = Get-Content -LiteralPath $indexFile -TotalCount 20 | Out-String
        $tMatch = $content -match 'title:\s*(.+)'
        $t = if ($tMatch) { $matches[1].Trim() } else { $folder.Name -replace '_',' ' }
        
        # Relative path from unit content to this folder
        $rel = $folder.FullName.Substring($unitDir.Length).TrimStart('\')
        $href = "./$rel/"
        
        $lines += "- [$t]($href)"
      }
    }
    
    Set-Content -Path $outFile -Value $lines -Encoding UTF8
    Write-Output ("Regenerated unit $i content index")
  }
}
