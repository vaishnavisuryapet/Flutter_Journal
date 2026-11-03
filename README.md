# 📔 Flutter Journal – Personal Journal and Mood Tracker

## 1. Aim

To design and develop a user-friendly journal application using Flutter that allows users to write, edit, and manage journal entries, record their moods, and view basic mood analytics.

## 2. Introduction

Flutter Journal is a journal application developed using Flutter and Dart. It provides a simple interface where users can record their thoughts, select a mood, and review their saved entries.

The application includes a demonstration login screen, journal entry management, local storage, and mood analytics.

The main goal of this project is to make daily journaling simple while helping users review the moods they record.

> The login screen is for demonstration only. It does not provide real authentication, and entries are not separated by user account.

## 3. Objectives

- Develop a journal application using Flutter.
- Provide a simple and attractive user interface.
- Create a login interface with basic form validation.
- Allow users to add, view, edit, and delete journal entries.
- Allow users to select a mood for each entry.
- Store journal entries locally.
- Display mood counts and percentages.
- Demonstrate navigation, form handling, and local data storage.

## 4. Technologies Used

| Technology | Purpose |
|------------|---------|
| Flutter | Application development |
| Dart | Application programming language |
| Visual Studio Code | Code editing |
| GitHub Codespaces | Cloud development environment |
| Material 3 | User interface components and styling |
| shared_preferences | Local storage of journal entries |
| JSON | Encoding and decoding entry data |
| flutter_test | Widget testing |
| Git and GitHub | Version control and repository hosting |

## 5. Features of the Application

### 5.1 Login Screen

- Provides email and password input fields.
- Checks that the email is not empty and contains `@`.
- Checks that the password contains at least six characters.
- Opens the journal home screen after successful form validation.

This screen validates input only. It does not verify credentials or create an account.

### 5.2 Home Screen

- Displays saved journal entries.
- Shows entry titles, note previews, dates, and moods.
- Arranges entries with the newest first.
- Provides access to entry creation and mood analytics.
- Includes logout navigation.

### 5.3 Add Journal Entry

- Allows users to enter a title and note.
- Provides mood selection.
- Validates required fields.
- Saves the entry with its creation date and time.

### 5.4 Edit Journal Entry

- Opens an existing entry.
- Allows changes to its title, note, and mood.
- Saves the updated entry.
- Retains the original creation date.

### 5.5 Delete Journal Entry

- Provides a delete option in each entry's menu.
- Displays a confirmation dialog.
- Removes the selected entry from local storage after confirmation.

### 5.6 Mood Selection

Users can choose one mood for each entry:

- Happy
- Calm
- Neutral
- Sad
- Angry

Each mood has an associated icon and color.

### 5.7 Mood Analytics

- Displays the total number of journal entries.
- Displays the most common recorded mood.
- Shows the number of entries for each mood.
- Calculates each mood's percentage of all entries.
- Uses progress bars to display the mood distribution.
- Displays an empty state when no entries exist.

Analytics cover all stored entries. If multiple moods share the highest count, the current implementation displays one of them.

### 5.8 Local Storage

- Saves journal entries using `shared_preferences`.
- Converts entries into JSON for storage.
- Loads previously saved entries when opening the home screen.

## 6. Data Storage and Processing

The application does not use an external API or a cloud database.

Each journal entry contains:

| Field | Description |
|-------|-------------|
| ID | Identifier for the entry |
| Title | Short heading |
| Note | Journal content |
| Mood | Selected mood |
| Date | Entry creation date and time |

Entries are converted into JSON and stored locally under the key:

```text
journal_entries
```

Mood percentages are calculated as:

```text
Mood percentage = (Entries with that mood / Total entries) × 100
```

## 7. Packages and Dependencies

The project uses the following packages:

- `flutter` — Application framework and UI components.
- `shared_preferences` — Local persistence of journal data.
- `flutter_test` — Widget testing.
- `flutter_lints` — Code analysis rules.

The application also uses Dart's built-in `dart:convert` library for JSON encoding and decoding.

## 8. Project Structure

```text
Flutter_Journal/
│
├── android/
├── ios/
│
├── lib/
│   └── main.dart
│
├── linux/
├── macos/
│
├── test/
│   └── widget_test.dart
│
├── web/
├── windows/
│
├── .gitignore
├── .metadata
├── analysis_options.yaml
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

The current application keeps its screens, entry model, storage logic, and mood helpers in `lib/main.dart`.

Platform folders are included in the repository. This does not mean every platform has been built or tested.

## 9. Software and Hardware Requirements

### Software Requirements

- Flutter SDK, which includes Dart.
- Git.
- Visual Studio Code or GitHub Codespaces.
- A browser for web testing.
- Internet access for initial setup and dependency downloads.
- Platform-specific development tools when building native applications.

### Development Environment

This project can be developed and run in GitHub Codespaces without installing Flutter on the local computer.

When using Codespaces, Flutter and the project dependencies must be available inside the cloud environment.

## 10. Steps to Install and Run the Project

### Step 1: Clone the Repository

```bash
git clone [https://github.com/vaishnavisuryapet/Flutter_Journal.git](https://github.com/vaishnavisuryapet/Flutter_Journal.git)
```

### Step 2: Navigate to the Project Folder

```bash
cd Flutter_Journal
```

### Step 3: Install Dependencies

```bash
flutter pub get
```

### Step 4: Check Flutter Configuration

```bash
flutter doctor
```

Some platform-specific tools are only necessary if you intend to build for those platforms.

### Step 5: View Available Devices

```bash
flutter devices
```

### Step 6: Run the Application

#### In GitHub Codespaces

```bash
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

Then:

1. Open the Ports panel.
2. Forward port `8080` if it is not already listed.
3. Open its forwarded address in the browser.
4. Keep the Flutter process running while using the app.

Keep the forwarded port private when working with personal information.

#### Locally in Chrome

With Flutter and Chrome available:

```bash
flutter run -d chrome
```

#### On a Configured Device

```bash
flutter run
```

### Step 7: Run Code Checks

Format the code:

```bash
dart format lib test
```

Run static analysis:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

## 11. Working Procedure

1. The user opens the application.
2. The login screen displays email and password fields.
3. The user enters an email containing `@` and a password of at least six characters.
4. After form validation, the home screen opens.
5. Previously stored entries are loaded.
6. The user selects New entry.
7. The user enters a title and note, then selects a mood.
8. The application saves the entry locally.
9. The user can open an entry to edit it.
10. The user can delete an entry after confirmation.
11. The user can open Mood Analytics to review recorded moods.
12. The logout button returns the user to the login screen.

Use fictional credentials while testing. No real account is created.

## 12. Advantages

- Simple journal-writing interface.
- Easy entry creation, editing, and deletion.
- Mood selection with visual indicators.
- Basic mood distribution summaries.
- Local data persistence.
- No external API required for the journal features.
- Demonstrates Flutter navigation, forms, and storage.

## 13. Current Limitations

- Login is a UI demonstration, not real authentication.
- Entries are not separated by email or user account.
- Logging out does not delete stored entries.
- No cloud synchronization or backup is implemented.
- No encryption is implemented by the application.
- Clearing the application's stored data can remove entries.
- Analytics do not include date filtering or mood trends over time.
- Mood analytics summarize recorded selections and do not assess mental health.

This is a learning and demonstration project. It should not be used to store sensitive personal information.

## 14. Future Enhancements

- Real authentication and separate user accounts.
- Secure storage and cloud backups.
- Cross-device synchronization.
- Search and tags.
- Calendar-based entry browsing.
- Date-filtered mood analytics.
- Mood trend charts.
- Dark and light theme switching.
- Journal reminders.
- Export and import functionality.
- Additional widget and integration tests.
- Separate files for screens, models, and storage services.

## 15. Conclusion

Flutter Journal demonstrates the development of a journal and mood-tracking interface using Flutter and Dart.

The application provides entry management, mood selection, local persistence, and basic mood analytics. It demonstrates Flutter widgets, navigation, form validation, JSON processing, and local data storage.

The project provides a foundation for future improvements such as authentication, cloud synchronization, and more detailed analytics.

## 16. Repository

GitHub: https://github.com/vaishnavisuryapet/Flutter_Journal

Project Name: Flutter Journal – Personal Journal and Mood Tracker
