# SpeechFlow — kanał wydań

Publiczny kanał aktualizacji dla aplikacji [SpeechFlow](https://github.com/karolbee/speechflow).

Aplikacja odpytuje **`latest.json`** (surowy plik z gałęzi `main`):

```
https://raw.githubusercontent.com/karolbee/speechflow-release/main/latest.json
```

## Format `latest.json`

```json
{
  "version": "1.4.0",
  "url": "https://github.com/karolbee/speechflow-release/releases/download/v1.4.0/SpeechFlow-Setup-1.4.0.exe",
  "notes": "Krótki opis zmian"
}
```

- `version` — numer najnowszego wydania (aplikacja proponuje aktualizację, gdy jest wyższy niż zainstalowany).
- `url` — bezpośredni link **HTTPS** do instalatora (np. plik dołączony do GitHub Release w tym repo).
- `notes` — opcjonalny opis zmian pokazywany użytkownikowi.

## Jak wydać nową wersję

1. Zbuduj instalator (`build.ps1`) w repo z kodem.
2. Utwórz GitHub Release w tym repo i dołącz do niego `SpeechFlow-Setup-<wersja>.exe`.
3. Zaktualizuj `version`, `url` i `notes` w `latest.json` i zacommituj.
