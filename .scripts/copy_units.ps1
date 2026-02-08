$root = 'c:\Joshua\workspace\media-and-communcation\repocentric-media-and-communication'
for ($i = 1; $i -le 7; $i++) {
    $pattern = '{0:D2}_Unit_*' -f $i
    $src = Get-ChildItem -Path $root -Directory | Where-Object { $_.Name -like $pattern } | Select-Object -First 1
    if ($src) {
        $dest = Join-Path $root ('docs\unit' + $i + '\content')
        New-Item -ItemType Directory -Force -Path $dest | Out-Null
        Copy-Item -Path (Join-Path $src.FullName '*') -Destination $dest -Recurse -Force
        Write-Output ("Copied {0} -> {1}" -f $src.Name, $dest)
    }
    else {
        Write-Output ("No source for unit {0}" -f $i)
    }
}
