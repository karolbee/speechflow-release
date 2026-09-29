---
name: wake
description: Reconnect all SpeechFlow voice-task agents whose Claude Code sessions stopped listening, for example after a computer restart. Use when the user says "wznów agentów SpeechFlow", "obudź agentów SpeechFlow", "połącz ponownie agentów", "wake SpeechFlow agents" or "reconnect SpeechFlow agents", or when SpeechFlow reports that agents stopped listening after a restart.
---

# Wake SpeechFlow agents

Each agent listens in a background process that belongs to its own Claude Code session. A computer restart kills those processes, and nothing restarts them on its own. The agents themselves survive: their approval stays valid, and tasks sent in the meantime wait in the queue.

This skill asks the session of each offline agent to reconnect, so the user does not have to open every session. Talk to the user in their language and keep it short.

## 1. List the agents

```bash
powershell -NoProfile -ExecutionPolicy Bypass -File "$LOCALAPPDATA/SpeechFlow/bridge/sf-agent.ps1" list
```

Each line looks like this:

```
agent_id: <id> | state: <listening|working|offline|pending> | queued: <n> | host_session: <local_... or -> | project: <path> | name: <ascii name>
```

If the bridge is missing, or the lines have no `state:` field, SpeechFlow is older than 2.0.4. Tell the user to update SpeechFlow, then stop.

## 2. Wake every agent whose state is `offline`

Skip agents that are `listening` or `working`, since they are fine. Also skip `pending` agents, which the user must approve in SpeechFlow first.

For each offline agent:

1. **The agent belongs to this session.** This is the case when `host_session` equals `$CLAUDE_CODE_HOST_SESSION_ID` here. Reconnect it directly with the `speechflow:connect` skill, using `connect -Id <agent_id>`.
2. **`host_session` is set to another session.** Send that session a message with `mcp__ccd_session_mgmt__send_message` (`session_id` = `host_session`). If that tool is unavailable, use `SendMessage`. Use this text, with the values filled in:

   > SpeechFlow: nasłuch agenta <agent_id> zatrzymał się (np. po restarcie komputera) – połącz ponownie tę sesję z SpeechFlow.
   > Użyj umiejętności speechflow:connect z istniejącym agentem: connect -Id <agent_id>. Nie twórz nowego agenta – zatwierdzenie i zadania z kolejki zostają. Po połączeniu uruchom nasłuch w tle.

3. **`host_session` is `-`.** The agent was connected by an older version. Find its session with `mcp__ccd_session_mgmt__search_session_transcripts`, using the agent_id as the query. Use a hit whose snippet contains `SPEECHFLOW_CONNECTED` and that same agent_id.
   - If exactly one non-archived session matches, send it the message from step 2.
   - If several sessions match, pick the one with the latest `lastActivityAt`.
   - If none match, report the agent as needing manual reconnection.

Send each message only once. Do not wait for replies and do not poll.

## 3. Report

Show a short list: each agent with its result. The result is one of:

- **obudzony** — a message was sent to its session,
- **połączony tutaj** — it belongs to this session,
- **wymaga ręcznego połączenia** — open that project's session and say „połącz SpeechFlow”.

Mention that queued tasks are delivered as soon as each agent listens again.

## Notes

- Sending messages between sessions only works in the Claude desktop app. In the terminal CLI, tell the user to open each agent's session and say „połącz SpeechFlow”.
- A woken session may hold the message for the user's approval if it runs in a different permission mode. That is expected; mention it if some agents do not come back.
- Never send anything other than the reconnect message to other sessions.
