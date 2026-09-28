# SpeechFlow releases

Windows voice dictation: press a hotkey and speak. The text is typed into the focused field or copied to the clipboard.

- **Download:** [latest release](https://github.com/karolbee/speechflow-release/releases/latest). Installed apps update themselves from Settings → Check for updates.
- `latest.json` is the update manifest that the app reads.

## Claude Code plugin

The plugin sends tasks you dictate in SpeechFlow to a chosen Claude Code session. The session waits in the background without using tokens.

```
/plugin marketplace add karolbee/speechflow-release
/plugin install speechflow@speechflow
```

It requires SpeechFlow 2.0 or newer. See [plugins/speechflow/README.md](plugins/speechflow/README.md) for details.
