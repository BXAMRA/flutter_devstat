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
- 🧬 **Project identity injection via `pubspec.yaml`**
  - Optional developer metadata headers (`name`, `email`, `website`, `project`)
  - Optional automatic copyright generation
  - Strict header formatting enforcement

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

## 🧾 Project Identity Configuration (v1.3.2+)

You can optionally define developer and project metadata in your `pubspec.yaml`.
When present, DevStat automatically injects and maintains a standardized
header block at the top of every Dart file.

```yaml
flutter_devstat:
  dev_info:
    name: "BXAMRA"
    email: "bxamra@icloud.com"
    website: "https://bxamra.github.io"
    project: "My App"
    generate_copyright: true
```

### Example header output:

```text
// lib/main.dart

/*
 * BXAMRA
 * bxamra@icloud.com
 * https://bxamra.github.io
 * Copyright 2026 BXAMRA. All rights reserved.
 *
 * Project : My App
 */
```

> Only the fields that exist are inserted.
> If no fields are defined, only the file path header is added.

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

/*
 * BXAMRA
 * bxamra@icloud.com
 */

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
v1.3.2 © BXAMRA

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

## Example

You can try out Flutter DevStat by running the example:

```bash
dart run example/example.dart
```

---

## 🏷 License

This project is licensed under the [MIT License](LICENSE).

---

## 👤 Author

**BXAMRA**
📧 [bxamra@icloud.com](mailto:bxamra@icloud.com)
🌐 [bxamra.github.io](https://bxamra.github.io/)
