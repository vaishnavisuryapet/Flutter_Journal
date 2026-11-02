# Flutter Journal

A simple journal app built with Flutter and Dart.

## Features

- Login page with form validation
- Home page displaying journal entries
- Add, edit, and delete entries
- Mood selection: Happy, Calm, Neutral, Sad, Angry
- Mood analytics with counts and percentages
- Local storage using shared_preferences

## Tech Used

- Flutter and Dart
- Material 3
- shared_preferences

## Run in GitHub Codespaces

With Flutter installed in the codespace, run:

```bash
flutter pub get
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

Open port 8080 from the Codespaces Ports panel.

## Note

Login is for demonstration only, not real authentication.
Entries are stored locally and are not separated by user.
