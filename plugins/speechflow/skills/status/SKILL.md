---
name: status
description: Show whether this Claude Code session is connected to SpeechFlow as a voice-task agent, whether it is listening, and how many dictated tasks are waiting. Use when the user asks about the SpeechFlow connection, e.g. "czy SpeechFlow jest połączony", "status SpeechFlow".
---

# SpeechFlow agent status

1. Find the agent id used earlier in this conversation. If there is none, list all agents and pick the one whose project folder is the current one:

   ```bash
   powershell -NoProfile -ExecutionPolicy Bypass -File "$LOCALAPPDATA/SpeechFlow/bridge/sf-agent.ps1" list
   ```

2. Show its state:

   ```bash
   powershell -NoProfile -ExecutionPolicy Bypass -File "$LOCALAPPDATA/SpeechFlow/bridge/sf-agent.ps1" status -Id <agent_id>
   ```

3. Explain it in one or two sentences in the user's language:
   - `paired: no` means the user still has to approve the agent in SpeechFlow (🤖 button).
   - `listening` with a heartbeat under ~45 s means it is ready.
   - `queued_tasks` above 0 while nothing is listening means a listener should be started: use the `connect` skill, which reconnects the same agent.
