# author: Chen Mo
# version: 1.0.1.3
# created on 2023-01-10
# modified on 2023-02-17

# Func to add an env path
function Add-EnvPath
{
  param(
    [Parameter(Mandatory=$true)]
    [string]$Path
  )

  if ($Path -eq "") 
  {
      return "<Add-EnvPath>: Empty path supplied"
  }

  [bool]$PathValid = Test-Path $Path;
  if (-not $PathValid) 
  {
      return "<Add-EnvPath>: $Path does not exist."
  }

  [string[]]$OldPaths = [System.Environment]::GetEnvironmentVariable("Path") -split ";"

  if($OldPaths -contains $Path)
  {
      return "<Add-EnvPath>: $Path already exist in env"
  }

  $OldPaths += $Path;
  $NewPathStr = $OldPaths -join ";"

  [System.Environment]::SetEnvironmentVariable("Path", $NewPathStr)

  return "<Add-EnvPath>: $Path added to env successfully!"
}

Add-EnvPath "C:\Vim\Vim90\"
Add-EnvPath "c:\sqlite\sqlite-tools-win32-x86-3400100\"
Add-EnvPath "C:\Users\mochen\AppData\Local\Programs\Git\bin\"
Add-EnvPath "C:\Program Files\7-Zip\"

#Testing for if current principal contains admin
[bool]$isAdmin =  `
    (
        [Security.Principal.WindowsPrincipal] `
        [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")

if ($isAdmin) {$promptSymbol = "$";} else {$promptSymbol = "%"}

[System.Environment]::SetEnvironmentVariable("PromptSymbol", $promptSymbol)

function prompt 
{
  $str3=$(Get-History | Select -Last 1 | Select -Property "Id")
  if ($str3.Id -eq $Null) {$str3=0} else {$str3=$str3.Id}
  $promptnum="$str3"
  Write-Host "[" -NoNewLine -ForegroundColor Gray
  Write-Host $(hostname) -NoNewline -ForegroundColor Yellow
  Write-Host ":" -NoNewLine -ForegroundColor Gray
  Write-Host $env:UserName -NoNewline -ForegroundColor Red
  Write-Host "][" -NoNewLine -ForegroundColor Gray
  Write-Host $promptnum -NoNewline -ForegroundColor Green
  Write-Host "] $env:promptSymbol" -NoNewline -ForegroundColor Gray
  return " "
}

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
