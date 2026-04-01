## 1.3.3

- Fixed file annotation newline handling:
  - Prevents accumulation of extra blank lines at the end of Dart files across repeated runs.
  - Ensures exactly one trailing newline is maintained (POSIX-compliant file ending).

- Improved annotation idempotency:
  - Re-running annotation no longer alters already-correct files.
  - Stabilized output to avoid unnecessary formatting drift.

- Refined header cleanup logic:
  - More resilient removal of existing headers and developer blocks.
  - Improved regex handling for edge cases with varying newline counts.

- Minor internal optimizations to file write operations and formatting consistency.

## 1.3.2

- Added support for project identity configuration via `pubspec.yaml`:
  - Optional developer metadata injection (`name`, `email`, `website`, `project`).
  - Optional automatic copyright generation.
- Implemented strict file header normalization:
  - Always enforces a single path header at the top of each Dart file.
  - Ensures exactly one blank line after headers.
  - Updates existing headers and developer blocks in-place.
- Improved annotation reliability and formatting consistency.

## 1.3.1

- Added LICENSE file with MIT License.
- Improved pubspec.yaml description and metadata.

## 1.3.0

- Added CLI flags:
  - `-a` — Add or update file path headers in all Dart files.
  - `-v` — Show package version.
  - `-h` or `-u` — Display usage and help info.
- Improved command-line interface and error handling.
- Enhanced directory scanning and file updating performance.
- Refactored internal file management utilities.

## 1.2.0

- Added automatic update feature for existing path headers.
- Improved compatibility with nested project structures.
- Minor code cleanup and documentation updates.

## 1.1.0

- Added directory tree visualization.
- Improved output formatting and logging.

## 1.0.0

- Initial release.
- Added base functionality for project structure analysis.
- Implemented path header insertion for Dart files.
