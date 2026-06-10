<#
.SYNOPSIS
    Install Power BI Optimization Skill for GitHub Copilot

.DESCRIPTION
    Installs the Power BI Optimization Skill to your user profile or workspace.
    
.PARAMETER Scope
    Installation scope: 'user' (default) or 'workspace'
    
.PARAMETER Path
    Custom installation path (optional)

.EXAMPLE
    .\install.ps1
    # Installs to user scope (~/.github/skills/)

.EXAMPLE
    .\install.ps1 -Scope workspace
    # Installs to current workspace (.github/skills/)

.EXAMPLE
    .\install.ps1 -Path "C:\MyCustomPath\.github\skills"
    # Installs to custom path
#>

param(
    [Parameter()]
    [ValidateSet('user', 'workspace')]
    [string]$Scope = 'user',
    
    [Parameter()]
    [string]$Path = $null
)

$ErrorActionPreference = 'Stop'

# Banner
Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host " Power BI Optimization Skill Installer" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Determine installation path
if ($Path) {
    $installPath = Join-Path $Path "powerbi-optimization"
    Write-Host "Installing to custom path: $installPath" -ForegroundColor Yellow
} elseif ($Scope -eq 'user') {
    $userProfile = $env:USERPROFILE
    $installPath = Join-Path $userProfile ".github\skills\powerbi-optimization"
    Write-Host "Installing to user scope: $installPath" -ForegroundColor Green
} else {
    $installPath = ".github\skills\powerbi-optimization"
    Write-Host "Installing to workspace: $installPath" -ForegroundColor Green
}

# Create directory if it doesn't exist
if (-not (Test-Path $installPath)) {
    Write-Host "Creating directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $installPath -Force | Out-Null
}

# Copy skill files
Write-Host "Copying skill files..." -ForegroundColor Yellow

$sourceFiles = @(
    @{Source = ".github\skills\powerbi-optimization\*"; Destination = $installPath; Recurse = $true}
)

foreach ($file in $sourceFiles) {
    if ($file.Recurse) {
        Copy-Item -Path $file.Source -Destination $file.Destination -Recurse -Force
    } else {
        Copy-Item -Path $file.Source -Destination $file.Destination -Force
    }
}

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Installed skills:" -ForegroundColor Cyan
Write-Host "  - @powerbi-optimization (Hub skill)" -ForegroundColor White
Write-Host "  - @dax-mastery (Specialist)" -ForegroundColor White
Write-Host "  - @model-design (Specialist)" -ForegroundColor White
Write-Host "  - @report-performance (Specialist)" -ForegroundColor White
Write-Host "  - @powerquery-m (Specialist)" -ForegroundColor White
Write-Host "  - @security-rls (Specialist)" -ForegroundColor White
Write-Host ""
Write-Host "Usage in GitHub Copilot:" -ForegroundColor Cyan
Write-Host "  @powerbi-optimization optimize my report" -ForegroundColor White
Write-Host "  @dax-mastery check this measure" -ForegroundColor White
Write-Host "  @model-design analyze unused objects" -ForegroundColor White
Write-Host ""
Write-Host "Documentation:" -ForegroundColor Cyan
Write-Host "  https://github.com/PBI-Guy/Power-BI-Optimization-Skill" -ForegroundColor White
Write-Host ""
