$root = 'c:\Joshua\workspace\media-and-communcation\repocentric-media-and-communication'
for ($i=1;$i -le 7; $i++) {
  $index = Join-Path $root ('docs\unit' + $i + '\index.md')
  if (-not (Test-Path $index)) { Write-Output ("Missing unit index: {0}" -f $index); continue }
  $lines = Get-Content -LiteralPath $index -ErrorAction Stop
  $has = $lines -join "`n" -match '\/unit' + $i + '\/content\/'
  if ($has) { Write-Output ("Already has content link: unit{0}" -f $i); continue }
  # Insert Content link under Sections if exists, else append
  $out = @()
  $inserted = $false
  for ($j=0;$j -lt $lines.Count; $j++) {
    $out += $lines[$j]
    if (-not $inserted -and $lines[$j] -match '^\s*- \[Short Notes\]') {
      $out += ("- [Content]({{ '/unit{0}/content/' | relative_url }})" -f $i)
      $inserted = $true
    }
  }
  if (-not $inserted) { $out += ''; $out += ("- [Content]({{ '/unit{0}/content/' | relative_url }})" -f $i) }
  Set-Content -LiteralPath $index -Value $out -Encoding UTF8
  Write-Output ("Updated unit index: {0}" -f $index)
}
