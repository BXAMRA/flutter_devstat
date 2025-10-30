# 🧰 flutter_devstat

**flutter_devstat** is a lightweight command-line utility that helps you maintain clean and consistent Flutter project structures.  
It automatically annotates all Dart files in your Flutter app with their file paths (like `// lib/config.dart`), making large projects easier to navigate and refactor.

---

## 🚀 Features

- 🗂 **Annotate Dart files** with file path headers
- 🔁 **Update existing annotations** automatically when files move or rename
- 📄 **Analyze project structure** or generate reports
- 🧭 **Flexible CLI flags:**
  - `-a` → Annotate or update all Dart files
  - `-v` → Show current version
  - `-u`, `-h` → Show usage/help info
  - `-p`, `--paths` → Show all Dart file paths instead of the tree view

---

## 📦 Installation

### 🔹 Add to a Flutter project

```bash
flutter pub add flutter_devstat --dev
```

### 🔹 Activate globally

```bash
dart pub global activate flutter_devstat
```

---

## 🧑‍💻 Usage

### Annotate or update all Dart files:

```bash
dart run flutter_devstat -a
```

### Display help/usage:

```bash
dart run flutter_devstat -h
```

### Show version:

```bash
dart run flutter_devstat -v
```

### Example output:

```text
✅ Annotating Dart files...
🔹 Updated: // lib/main.dart
🔹 Added:   // lib/widgets/button.dart
✅ 23 files processed successfully.
```

---

## 🧩 Example Dart File

**Before:**

```dart
import 'package:flutter/material.dart';

class AppConfig {}
```

**After running `flutter_devstat -a`:**

```dart
// lib/config.dart

import 'package:flutter/material.dart';

class AppConfig {}
```

---

## ⚙️ Development

If you want to modify or contribute to the tool locally:

### Clone the repository:

```bash
git clone https://github.com/bxamra/flutter_devstat.git
cd flutter_devstat
```

### Run directly:

```bash
dart run bin/flutter_devstat.dart -a
```

### Run tests:

```bash
dart test
```

---

## 📤 Publishing (for maintainers)

Before publishing to [pub.dev](https://pub.dev):

1. Update version in `pubspec.yaml`
2. Run checks:
   ```bash
   dart pub publish --dry-run
   ```
3. Then publish:
   ```bash
   dart pub publish
   ```

---

## 🧾 Example Output (Project Tree Mode)

```text
🚀 Flutter Project Structure Analyzer (DevStat)
v1.1 © BXAMRA

│flutter_devstat/
│
└──│lib/ - 5 files
   │
   ├──|config.dart
   ├──|utils/
   │  ├──-logger.dart
   │  └──-validator.dart
   └──-main.dart

Total 5 files across 2 directories
```

---

## 🏷 License

This project is licensed under the [MIT License](LICENSE).

---

## 👤 Author

**BXAMRA**  
📧 bxamra@icloud.com  
🌐 [bxamra.github.io](https://bxamra.github.io/)
