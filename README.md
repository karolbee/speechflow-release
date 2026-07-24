# SpeechFlow — release channel

Public update channel for the [SpeechFlow](https://github.com/karolbee/speechflow) app.

The app polls **`latest.json`** (raw file from the `main` branch):

```
https://raw.githubusercontent.com/karolbee/speechflow-release/main/latest.json
```

## `latest.json` format

```json
{
  "version": "1.4.0",
  "url": "https://github.com/karolbee/speechflow-release/releases/download/v1.4.0/SpeechFlow-Setup-1.4.0.exe",
  "notes": "Short changelog"
}
```

- `version` — the latest release number (the app offers an update when it is higher than the installed one).
- `url` — a direct **HTTPS** link to the installer (e.g. a file attached to a GitHub Release in this repo).
- `notes` — optional changelog shown to the user.

## How to publish a new version

1. Build the installer (`build.ps1`) in the source repo.
2. Create a GitHub Release in this repo and attach `SpeechFlow-Setup-<version>.exe` to it.
3. Update `version`, `url` and `notes` in `latest.json` and commit.
