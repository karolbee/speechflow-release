# SpeechFlow plugin - SessionStart hook (runs with asyncRewake).
# Hands the starting Claude Code session to the SpeechFlow bridge. If the session owns a
# SpeechFlow agent, the bridge listens for tasks in the background and exits with code 2
# when one arrives, which wakes the session. Any other session ends quietly with code 0.
# Does nothing when SpeechFlow is missing or older than 2.0.5.
# Every run leaves one line in %LOCALAPPDATA%\SpeechFlow\hooks.log, so "did the hook run?"
# always has an answer.
$ErrorActionPreference = 'SilentlyContinue'
$sfDir = Join-Path $env:LOCALAPPDATA 'SpeechFlow'
function HookLog([string]$msg) {
    try {
        if (-not (Test-Path -LiteralPath $sfDir)) { return }
        $f = Join-Path $sfDir 'hooks.log'
        if ((Test-Path -LiteralPath $f) -and (Get-Item -LiteralPath $f).Length -gt 200KB) { Remove-Item -LiteralPath $f }
        Add-Content -LiteralPath $f -Value ((Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + " pid=$PID " + $msg) -Encoding UTF8
    } catch { }
}
HookLog 'start'
$bridge = Join-Path $sfDir 'bridge\sf-agent.ps1'
if (-not (Test-Path -LiteralPath $bridge)) { HookLog 'no SpeechFlow bridge - nothing to do'; exit 0 }
if (-not (Select-String -LiteralPath $bridge -SimpleMatch 'session-hook' -Quiet)) { HookLog 'SpeechFlow older than 2.0.5 - nothing to do'; exit 0 }
$in = [Console]::In.ReadToEnd()
if (-not $in) { HookLog 'no hook input on stdin'; exit 0 }
try { $j = $in | ConvertFrom-Json; HookLog ("source=" + $j.source + " session=" + $j.session_id) } catch { HookLog 'hook input is not JSON' }
# hook data goes through a file: piping to another process would drop non-ASCII characters
$tmp = Join-Path $env:TEMP ('sf-hook-' + [Guid]::NewGuid().ToString('N') + '.json')
[IO.File]::WriteAllText($tmp, $in, (New-Object System.Text.UTF8Encoding($false)))
& $bridge hook -HookFile $tmp
$code = $LASTEXITCODE
HookLog ("bridge finished, code " + $code)
exit $code
