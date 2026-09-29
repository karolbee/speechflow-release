---
name: disconnect
description: Disconnect this Claude Code session from SpeechFlow so it stops receiving dictated tasks, and remove the agent from SpeechFlow's list. Use when the user says "odłącz SpeechFlow", "rozłącz SpeechFlow", "disconnect SpeechFlow" or "przestań nasłuchiwać".
---

# Disconnect from SpeechFlow

1. Use the agent id from earlier in this conversation. If you do not have one, list the agents:

   ```bash
   powershell -NoProfile -ExecutionPolicy Bypass -File "$LOCALAPPDATA/SpeechFlow/bridge/sf-agent.ps1" list
   ```

   Pick the agent whose `host_session` equals `$CLAUDE_CODE_HOST_SESSION_ID`, or whose project folder is the current one. If several agents match, ask the user which one.

2. Remove it:

   ```bash
   powershell -NoProfile -ExecutionPolicy Bypass -File "$LOCALAPPDATA/SpeechFlow/bridge/sf-agent.ps1" disconnect -Id <agent_id>
   ```

   This deletes the agent's folder, including tasks that were not delivered yet, and SpeechFlow stops listing it. A background listener for this agent notices and ends with `SPEECHFLOW_AGENT_REMOVED`. When that happens, do not start it again.

3. Tell the user that the agent is disconnected. Mention that `connect` with a new name creates a new agent, which must be approved in SpeechFlow again.
