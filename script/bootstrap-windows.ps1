$ErrorActionPreference = "Stop"

$packages = @(
  "Microsoft.WindowsTerminal",
  "Microsoft.PowerShell",
  "Git.Git",
  "DEVCOM.JetBrainsMonoNerdFont"
)

function Set-JsonProperty {
  param(
    [Parameter(Mandatory = $true)] [object] $Object,
    [Parameter(Mandatory = $true)] [string] $Name,
    [Parameter(Mandatory = $true)] [AllowNull()] $Value
  )

  if ($Object.PSObject.Properties.Name -contains $Name) {
    $Object.$Name = $Value
  } else {
    $Object | Add-Member -MemberType NoteProperty -Name $Name -Value $Value
  }
}

function Remove-JsonProperty {
  param(
    [Parameter(Mandatory = $true)] [object] $Object,
    [Parameter(Mandatory = $true)] [string] $Name
  )

  if ($Object.PSObject.Properties.Name -contains $Name) {
    $Object.PSObject.Properties.Remove($Name)
  }
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  throw "winget is required. Install App Installer from Microsoft Store first."
}

foreach ($id in $packages) {
  Write-Host "==> Installing/updating $id"
  winget upgrade --id $id --exact --silent --accept-package-agreements --accept-source-agreements | Out-Host
  winget install --id $id --exact --source winget --silent --accept-package-agreements --accept-source-agreements | Out-Host
}

Write-Host "==> Installing/updating uv"
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex" | Out-Host

$settingsPath = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (-not (Test-Path $settingsPath)) {
  throw "Windows Terminal settings not found at $settingsPath"
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupPath = "$settingsPath.dotfiles-backup-$timestamp"
Copy-Item -LiteralPath $settingsPath -Destination $backupPath
Write-Host "==> Backed up Windows Terminal settings to $backupPath"

$settings = Get-Content -LiteralPath $settingsPath -Raw | ConvertFrom-Json

$scheme = [pscustomobject]@{
  name = "Catppuccin Mocha"
  foreground = "#CDD6F4"
  background = "#1E1E2E"
  cursorColor = "#F5E0DC"
  selectionBackground = "#45475A"
  black = "#45475A"
  red = "#F38BA8"
  green = "#A6E3A1"
  yellow = "#F9E2AF"
  blue = "#89B4FA"
  purple = "#F5C2E7"
  cyan = "#94E2D5"
  white = "#BAC2DE"
  brightBlack = "#585B70"
  brightRed = "#F38BA8"
  brightGreen = "#A6E3A1"
  brightYellow = "#F9E2AF"
  brightBlue = "#89B4FA"
  brightPurple = "#F5C2E7"
  brightCyan = "#94E2D5"
  brightWhite = "#A6ADC8"
}

if (-not $settings.schemes) {
  Set-JsonProperty -Object $settings -Name "schemes" -Value @()
}

$existingScheme = @($settings.schemes | Where-Object { $_.name -eq "Catppuccin Mocha" })[0]
if ($existingScheme) {
  $scheme.PSObject.Properties | ForEach-Object {
    Set-JsonProperty -Object $existingScheme -Name $_.Name -Value $_.Value
  }
} else {
  $settings.schemes = @($settings.schemes) + $scheme
}

$powershellProfile = @($settings.profiles.list | Where-Object {
  $_.source -eq "Windows.Terminal.PowershellCore"
})[0]

$ubuntuProfile = @($settings.profiles.list | Where-Object {
  $_.source -eq "Microsoft.WSL" -and $_.name -eq "Ubuntu"
})[0]

if (-not $ubuntuProfile) {
  $ubuntuProfile = @($settings.profiles.list | Where-Object { $_.source -eq "Microsoft.WSL" })[0]
}

if (-not $ubuntuProfile) {
  throw "No WSL profile found in Windows Terminal settings."
}

if (-not $powershellProfile) {
  throw "PowerShell 7 profile not found in Windows Terminal settings."
}

Set-JsonProperty -Object $settings -Name "defaultProfile" -Value $powershellProfile.guid

$themedProfiles = @($powershellProfile, $ubuntuProfile)
foreach ($profile in $themedProfiles) {
  Set-JsonProperty -Object $profile -Name "colorScheme" -Value "Catppuccin Mocha"
  Set-JsonProperty -Object $profile -Name "cursorShape" -Value "filledBox"
  Set-JsonProperty -Object $profile -Name "padding" -Value "10, 8, 10, 8"

  if (-not $profile.font) {
    Set-JsonProperty -Object $profile -Name "font" -Value ([pscustomobject]@{})
  }
  Set-JsonProperty -Object $profile.font -Name "face" -Value "JetBrainsMono Nerd Font"
  Set-JsonProperty -Object $profile.font -Name "size" -Value 12
}

Remove-JsonProperty -Object $ubuntuProfile -Name "startingDirectory"

$settings | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $settingsPath -Encoding UTF8
Write-Host "==> Windows Terminal now defaults to PowerShell 7"
Write-Host "==> PowerShell 7 and Ubuntu profiles now use Catppuccin Mocha and JetBrainsMono Nerd Font"
$vsCodeSettingsPath = Join-Path $env:APPDATA "Code\User\settings.json"
if (Test-Path $vsCodeSettingsPath) {
  Copy-Item -LiteralPath $vsCodeSettingsPath -Destination "$vsCodeSettingsPath.dotfiles-backup-$timestamp"
  $vsCodeSettings = Get-Content -LiteralPath $vsCodeSettingsPath -Raw | ConvertFrom-Json
  Set-JsonProperty -Object $vsCodeSettings -Name "terminal.integrated.fontFamily" -Value "JetBrainsMono NFM, JetBrainsMono NF, 'JetBrains Mono', Consolas, monospace"
  $vsCodeSettings | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $vsCodeSettingsPath -Encoding UTF8
  Write-Host "==> VS Code integrated terminal now uses JetBrainsMono Nerd Font"
} else {
  Write-Host "==> VS Code settings not found; skipping integrated terminal font setup"
}

$profilePath = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "PowerShell\Microsoft.PowerShell_profile.ps1"
$profileDir = Split-Path -Parent $profilePath
New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
if (Test-Path $profilePath) {
  Copy-Item -LiteralPath $profilePath -Destination "$profilePath.dotfiles-backup-$timestamp"
}

$profileText = if (Test-Path $profilePath) { Get-Content -LiteralPath $profilePath -Raw } else { "" }
$blockStart = "# >>> dotfiles aliases >>>"
$blockEnd = "# <<< dotfiles aliases <<<"
$profileBlock = @'
# >>> dotfiles aliases >>>
function Add-DotfilesFunction {
  param(
    [Parameter(Mandatory = $true)] [string] $Name,
    [Parameter(Mandatory = $true)] [scriptblock] $Body
  )

  if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
    Set-Item -Path "Function:\global:$Name" -Value $Body
  }
}

if (Get-Module -ListAvailable -Name PSReadLine) {
  Import-Module PSReadLine
  try {
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle InlineView
    Set-PSReadLineOption -EditMode Windows
    Set-PSReadLineOption -Colors @{
      Command = "#89B4FA"
      Parameter = "#CBA6F7"
      Operator = "#89DCEB"
      Variable = "#F9E2AF"
      String = "#A6E3A1"
      Number = "#FAB387"
      Type = "#F5C2E7"
      Comment = "#6C7086"
      InlinePrediction = "#6C7086"
      Error = "#F38BA8"
    }
  } catch {
    Write-Verbose "PSReadLine color setup skipped: $($_.Exception.Message)"
  }
}

Add-DotfilesFunction c { Clear-Host }

if (Get-Command nvim -ErrorAction SilentlyContinue) {
  Add-DotfilesFunction vim { nvim @args }
}

if (Get-Command eza -ErrorAction SilentlyContinue) {
  Add-DotfilesFunction ll { eza --group-directories-first --icons=auto -lah @args }
  Add-DotfilesFunction la { eza --group-directories-first --icons=auto -a @args }
  Add-DotfilesFunction lt { eza --group-directories-first --icons=auto --tree --level=2 @args }
}

$uvBin = Join-Path $HOME ".local\bin"
if (Test-Path $uvBin) {
  $pathParts = [System.Collections.Generic.List[string]]::new()
  $env:PATH -split [System.IO.Path]::PathSeparator | Where-Object { $_ } | ForEach-Object { [void] $pathParts.Add($_) }
  if (-not ($pathParts -contains $uvBin)) {
    $env:PATH = "$uvBin$([System.IO.Path]::PathSeparator)$env:PATH"
  }
}
# <<< dotfiles aliases <<<
'@

$pattern = "(?s)$([regex]::Escape($blockStart)).*?$([regex]::Escape($blockEnd))"
if ($profileText -match $pattern) {
  $profileText = [regex]::Replace($profileText, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $profileBlock })
} else {
  $profileText = ($profileText.TrimEnd() + "`r`n`r`n" + $profileBlock + "`r`n")
}

Set-Content -LiteralPath $profilePath -Value $profileText -Encoding UTF8
Write-Host "==> PowerShell profile aliases updated at $profilePath"

