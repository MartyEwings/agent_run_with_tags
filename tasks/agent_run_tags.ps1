# Puppet Task Name: agent_run_tags (PowerShell implementation)
#
# Triggers a Puppet agent run restricted to the supplied --tags, with any
# optional extra agent flags. Parameters are provided as environment variables
# (PT_tags, PT_flags) by the task runner.

$ErrorActionPreference = 'Stop'

# Locate the puppet executable. PATH is not guaranteed to include the agent's
# bin directory, so fall back to the standard AIO install location.
$puppet = (Get-Command puppet -ErrorAction SilentlyContinue).Source
if (-not $puppet) {
  $default = Join-Path $env:ProgramFiles 'Puppet Labs\Puppet\bin\puppet.bat'
  if (Test-Path $default) {
    $puppet = $default
  } else {
    Write-Error 'Unable to locate the puppet executable on PATH or in the default Puppet Labs install path'
    exit 1
  }
}

# Build the argument list, splitting the optional space-separated flags.
$arguments = @('agent', '--test', '--tags', $env:PT_tags)
if (-not [string]::IsNullOrWhiteSpace($env:PT_flags)) {
  $arguments += $env:PT_flags.Trim() -split '\s+'
}

& $puppet @arguments
exit $LASTEXITCODE
