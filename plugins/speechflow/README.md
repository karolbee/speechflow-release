# SpeechFlow for Claude Code

With this plugin you can send tasks dictated in [SpeechFlow](https://github.com/karolbee/speechflow-release) to a chosen Claude Code session.

The session waits in the background and uses no tokens while waiting. It wakes up only when a task arrives, and it works on the task with the full context of its project and conversation.

**Requires SpeechFlow 2.0 or newer (Windows).**

## Install

In Claude Code:

```
/plugin marketplace add karolbee/speechflow-release
/plugin install speechflow@speechflow
```

## Use

1. Open a Claude Code session in your project and say, for example: *połącz SpeechFlow, nazwij go Agent aplikacji do raportów* (or run `/speechflow:connect Agent aplikacji do raportów`).
2. Claude shows a 6-digit code.
3. In SpeechFlow, press your dictation hotkey, click 🤖 and approve the new agent with the same code. You only do this once per agent.
4. From then on: dictate, click 🤖 and pick the agent.
   - Clicking the row sends the recording when you stop.
   - The button at the end of the row stops and sends right away.

Other commands: `/speechflow:status`, `/speechflow:disconnect` and `/speechflow:wake`.

**After a computer restart** everything comes back by itself (SpeechFlow 2.0.5 or newer with the Claude desktop app):

1. When Windows starts, SpeechFlow opens the Claude sessions of agents whose listeners stopped. Opening a session by its `claude://` link starts it.
2. When a session starts or resumes, this plugin's `SessionStart` hook resumes listening for its agent. The hook runs with `asyncRewake`, so it needs no model turn and uses no tokens. It wakes Claude only when a task arrives.

Agents, approvals and queued tasks are never lost. If an agent does not come back, say *wznów agentów SpeechFlow* in any Claude session (or run `/speechflow:wake`): Claude then messages each offline agent's session. The automatic restore can be turned off in SpeechFlow → Settings → Agents.

Tip: when Claude asks whether it may run the `sf-agent.ps1 wait` and `done` commands, choose *don't ask again*. The loop can then run unattended.

## How it works and what it protects against

Everything happens locally, through files in `%LOCALAPPDATA%\SpeechFlow`:

- **Waiting uses no tokens and almost no CPU.** Claude runs `sf-agent.ps1 wait` as a background command. The command waits for file-system events and uses about 0.2% of one CPU core. It exits only when a task arrives, and that wakes the session.
- **Pairing.** SpeechFlow sends tasks only to agents you approved with the code that Claude showed. A new agent stays "pending" until you approve it.
- **Signatures.** When you approve an agent, SpeechFlow creates a key for it. The bridge delivers only tasks signed with that key. Any other file in the agent's inbox is rejected and does not wake Claude. The same task cannot be delivered twice.
- **Limits.** This protects against mistakes and against other programs placing files in the inbox. It does not protect against malicious software running under your own Windows account, which can already do anything you can.
- **Claude's permissions stay on.** A dictated task is treated like a message you typed in the chat. Claude still asks before destructive actions.
