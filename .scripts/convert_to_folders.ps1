$root = 'c:\Joshua\workspace\media-and-communcation\repocentric-media-and-communication'
$docs = Join-Path $root 'docs'

# Find all .md files under docs/unit*/content/
Get-ChildItem -Path $docs -Recurse -Filter '*.md' | Where-Object {
  $_.FullName -like (Join-Path $docs 'unit*\content\*')
} | ForEach-Object {
  $file = $_
  $fileName = $file.Name
  $fileDir = $file.Directory.FullName
  
  # Skip if already an index.md in a proper structure
  if ($fileName -eq 'index.md') { 
    Write-Output ("Skipping index: {0}" -f $file.FullName)
    return 
  }
  
  # Create folder name from file name (remove .md extension)
  $folderName = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
  $newFolder = Join-Path $fileDir $folderName
  
  # Create folder if it doesn't exist
  if (-not (Test-Path $newFolder)) {
    New-Item -ItemType Directory -Force -Path $newFolder | Out-Null
  }
  
  $indexPath = Join-Path $newFolder 'index.md'
  
  # Read content
  $content = Get-Content -Raw -LiteralPath $file.FullName
  
  # Remove code fence wrappers if present
  if ($content -match '^```.*\r?\n') {
    $content = $content -replace '^```.*\r?\n',''
  }
  if ($content -match '\r?\n```\s*$') {
    $content = $content -replace '\r?\n```\s*$',''
  }
  
  # Trim BOM
  $content = $content.TrimStart([char]0xFEFF)
  
  # Check if front matter exists
  if (-not ($content -match '^(---\s*\r?\n)')) {
    # Extract title from filename or first heading
    $title = $folderName -replace '^[0-9_\-\s]*','' -replace '_',' ' -replace '-',' '
    # Try to extract title from ## heading if exists
    $headingMatch = $content -match '^\s*#{1,2}\s+(.+)$'
    if ($headingMatch) {
      $title = $matches[1]
    }
    $fm = "---`r`nlayout: default`r`ntitle: $title`r`n---`r`n`r`n"
    $content = $fm + $content
  }
  
  # Write to index.md
  Set-Content -LiteralPath $indexPath -Value $content -Encoding UTF8
  
  # Delete original .md file
  Remove-Item -LiteralPath $file.FullName -Force
  
  Write-Output ("Converted: {0} -> {1}/index.md" -f $fileName, $folderName)
}
