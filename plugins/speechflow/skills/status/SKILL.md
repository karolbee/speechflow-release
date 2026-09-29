---
name: status
description: Show whether this Claude Code session is connected to SpeechFlow as a voice-task agent, whether it is listening, and how many dictated tasks are waiting; can also list all SpeechFlow agents. Use when the user asks about the SpeechFlow connection, e.g. "czy SpeechFlow jest połączony", "status SpeechFlow", "którzy agenci nasłuchują".
---

# SpeechFlow agent status

1. List all agents. The output is one ASCII line per agent, with `agent_id`, `state`, `queued`, `host_session`, `project` and `name`:

   ```bash
   powershell -NoProfile -ExecutionPolicy Bypass -File "$LOCALAPPDATA/SpeechFlow/bridge/sf-agent.ps1" list
   ```

   On SpeechFlow 2.0.0–2.0.3 the lines contain only the id and the project folder. For the state, use step 2.

2. For this session's agent, use the agent id from earlier in this conversation. If there is none, pick the agent whose `host_session` equals `$CLAUDE_CODE_HOST_SESSION_ID`, or whose project folder is the current one:

   ```bash
   powershell -NoProfile -ExecutionPolicy Bypass -File "$LOCALAPPDATA/SpeechFlow/bridge/sf-agent.ps1" status -Id <agent_id>
   ```

3. Explain the result in one or two sentences, in the user's language:
   - **`paired: no` / `pending`:** the user still has to approve the agent in SpeechFlow (🤖 button).
   - **`listening`:** it is ready.
   - **`offline` with `queued` above 0:** tasks are waiting. Reconnect with the `connect` skill (same agent). To wake several agents after a restart, use the `wake` skill ("wznów agentów SpeechFlow").
