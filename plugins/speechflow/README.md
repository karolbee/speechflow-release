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

**After a computer restart** the background listeners stop. Agents, approvals and queued tasks stay. In any Claude session say *wznów agentów SpeechFlow* (or run `/speechflow:wake`). Claude then messages each offline agent's session, and each one reconnects the same agent. This requires SpeechFlow 2.0.4 or newer and the Claude desktop app.

Tip: when Claude asks whether it may run the `sf-agent.ps1 wait` and `done` commands, choose *don't ask again*. The loop can then run unattended.

## How it works and what it protects against

Everything happens locally, through files in `%LOCALAPPDATA%\SpeechFlow`:

- **Waiting uses no tokens and almost no CPU.** Claude runs `sf-agent.ps1 wait` as a background command. The command waits for file-system events and uses about 0.2% of one CPU core. It exits only when a task arrives, and that wakes the session.
- **Pairing.** SpeechFlow sends tasks only to agents you approved with the code that Claude showed. A new agent stays "pending" until you approve it.
- **Signatures.** When you approve an agent, SpeechFlow creates a key for it. The bridge delivers only tasks signed with that key. Any other file in the agent's inbox is rejected and does not wake Claude. The same task cannot be delivered twice.
- **Limits.** This protects against mistakes and against other programs placing files in the inbox. It does not protect against malicious software running under your own Windows account, which can already do anything you can.
- **Claude's permissions stay on.** A dictated task is treated like a message you typed in the chat. Claude still asks before destructive actions.
