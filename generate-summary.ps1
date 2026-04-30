param(
    [string]$DocsRoot = $PSScriptRoot
)

$docsRootResolved = (Resolve-Path $DocsRoot).Path.TrimEnd('\\')
$summaryPath = Join-Path $docsRootResolved 'SUMMARY.md'
$excludeDirs = @('node_modules', '_book', '.git')

$mdFiles = Get-ChildItem -Path $docsRootResolved -Recurse -File -Filter '*.md' |
    Where-Object {
        $fullName = $_.FullName
        foreach ($exclude in $excludeDirs) {
            if ($fullName -match "[\\/]$([Regex]::Escape($exclude))([\\/]|$)") {
                return $false
            }
        }

        return $_.Name -ne 'SUMMARY.md'
    } |
    Sort-Object FullName

$rootFiles = @()
$grouped = [ordered]@{}

foreach ($file in $mdFiles) {
    $fullPath = $file.FullName
    if (-not $fullPath.StartsWith($docsRootResolved, [System.StringComparison]::OrdinalIgnoreCase)) {
        continue
    }

    $relativePath = $fullPath.Substring($docsRootResolved.Length).TrimStart('\\')
    $relativePath = $relativePath -replace '\\', '/'

    $parts = $relativePath.Split('/')
    $label = [IO.Path]::GetFileNameWithoutExtension($file.Name)

    if ($parts.Length -eq 1) {
        $rootFiles += [PSCustomObject]@{ Label = $label; Path = $relativePath }
        continue
    }

    $section = $parts[0]
    if (-not $grouped.Contains($section)) {
        $grouped[$section] = @()
    }

    $grouped[$section] += [PSCustomObject]@{ Label = $label; Path = $relativePath }
}

$lines = @('# Summary', '')

foreach ($item in $rootFiles) {
    $lines += "* [$($item.Label)]($($item.Path))"
}

if ($rootFiles.Count -gt 0 -and $grouped.Count -gt 0) {
    $lines += ''
}

foreach ($section in $grouped.Keys) {
    $lines += "## $section"
    foreach ($item in $grouped[$section]) {
        $lines += "* [$($item.Label)]($($item.Path))"
    }
    $lines += ''
}

while ($lines.Count -gt 0 -and $lines[$lines.Count - 1] -eq '') {
    $lines = $lines[0..($lines.Count - 2)]
}

Set-Content -Path $summaryPath -Value $lines -Encoding UTF8
Write-Output "Updated: $summaryPath"
