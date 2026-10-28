# Copy the skill into the agent skills folder.
# Usage: .\install.ps1 [target-directory]   (default: %USERPROFILE%\.claude\skills)
param(
    [string]$Target = (Join-Path $env:USERPROFILE ".claude\skills")
)

$ErrorActionPreference = "Stop"
$Name = "cavalry-motion-designer"
$Src = Join-Path $PSScriptRoot "skills\$Name"

if (-not (Test-Path $Src)) {
    Write-Error "Skill folder not found: $Src"
    exit 1
}

New-Item -ItemType Directory -Force -Path $Target | Out-Null
$Dest = Join-Path $Target $Name
if (Test-Path $Dest) { Remove-Item -Recurse -Force $Dest }
Copy-Item -Recurse $Src $Dest

Write-Host "Installed $Name to $Dest"
Write-Host "Restart your agent session to load it."
