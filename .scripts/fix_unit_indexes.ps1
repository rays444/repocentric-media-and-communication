$root = 'c:\Joshua\workspace\media-and-communcation\repocentric-media-and-communication'
for ($i = 1; $i -le 7; $i++) {
  $index = Join-Path $root ('docs\unit' + $i + '\index.md')
  if (-not (Test-Path $index)) { Write-Output ("Missing unit index: {0}" -f $index); continue }
  
  $content = Get-Content -Raw -LiteralPath $index
  
  # Check if it already has Content link with relative_url; if so, skip
  if ($content -match "relative_url \}\}\)") {
    Write-Output ("Already updated: unit{0}" -f $i)
    continue
  }
  
  # Replace or add relative_url to existing links
  $content = $content -replace "'\{\% | relative_url \}\}",""  # cleanup any malformed ones
  
  # Ensure Content link is present with relative_url
  if ($content -notmatch '\/unit' + $i + '\/content') {
    # Add after Short Notes link if it exists
    if ($content -match "(- \[Short Notes\]\({{ '\/unit$i\/short-notes\/' \| relative_url \}\}\))") {
      $content = $content -replace "(- \[Short Notes\]\({{ '\/unit$i\/short-notes\/' \| relative_url \}\}\))", "`$1`n- [Content]({ '/unit$i/content/' | relative_url }}"
    } else {
      # Append to Sections
      $content = $content -replace "(## Sections\r?\n)", "`$1`n- [Content]({ '/unit$i/content/' | relative_url })`n"
    }
  }
  
  Set-Content -LiteralPath $index -Value $content -Encoding UTF8
  Write-Output ("Updated unit{0} index" -f $i)
}
