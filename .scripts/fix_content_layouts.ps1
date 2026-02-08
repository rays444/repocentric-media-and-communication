$root = 'c:\Joshua\workspace\media-and-communcation\repocentric-media-and-communication\docs'
$count = 0
Get-ChildItem -Path $root -Recurse -Filter 'index.md' | Where-Object { $_.FullName -like '*\content\*' } | ForEach-Object {
  $path = $_.FullName
  $content = Get-Content -Raw -LiteralPath $path
  if ($content -match 'layout: page') {
    $content = $content -replace 'layout: page','layout: default'
    Set-Content -LiteralPath $path -Value $content -Encoding UTF8
    $count++
  }
}
Write-Output "Fixed $count content pages from layout: page to layout: default"
