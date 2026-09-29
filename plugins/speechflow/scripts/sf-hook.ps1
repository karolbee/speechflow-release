# SpeechFlow plugin - SessionStart hook (runs with asyncRewake).
# Hands the starting Claude Code session to the SpeechFlow bridge. If the session owns a
# SpeechFlow agent, the bridge listens for tasks in the background and exits with code 2
# when one arrives, which wakes the session. Any other session ends quietly with code 0.
# Does nothing when SpeechFlow is missing or older than 2.0.5.
$ErrorActionPreference = 'SilentlyContinue'
$bridge = Join-Path $env:LOCALAPPDATA 'SpeechFlow\bridge\sf-agent.ps1'
if (-not (Test-Path -LiteralPath $bridge)) { exit 0 }
if (-not (Select-String -LiteralPath $bridge -SimpleMatch 'session-hook' -Quiet)) { exit 0 }
$in = [Console]::In.ReadToEnd()
if (-not $in) { exit 0 }
# hook data goes through a file: piping to another process would drop non-ASCII characters
$tmp = Join-Path $env:TEMP ('sf-hook-' + [Guid]::NewGuid().ToString('N') + '.json')
[IO.File]::WriteAllText($tmp, $in, (New-Object System.Text.UTF8Encoding($false)))
& $bridge hook -HookFile $tmp
exit $LASTEXITCODE
