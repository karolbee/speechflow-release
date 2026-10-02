# SpeechFlow releases

Windows voice dictation: press a hotkey and speak. The text is typed into the focused field or copied to the clipboard.

- **Download:** [latest release](https://github.com/karolbee/speechflow-release/releases/latest). Installed apps update themselves from Settings → Check for updates.
- `latest.json` is the update manifest that the app reads.

## Claude agents (SpeechFlow 3.0)

An agent is a folder on your computer with instructions (Settings → Agents). Dictate a note, click 🤖 and pick the agent: SpeechFlow runs Claude Code there in the background on your Claude account and shows the result as a notification. Requires [Claude Code](https://docs.claude.com/en/docs/claude-code) – Settings → Agents has Install and Sign in buttons.

The Claude Code plugin that connected Claude sessions to SpeechFlow 2.x was retired in 3.0. You can remove it with `claude plugin uninstall speechflow@speechflow`.
