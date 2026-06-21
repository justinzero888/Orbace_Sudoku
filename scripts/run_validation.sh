#!/usr/bin/env bash
set -euo pipefail

flutter pub get
dart format --set-exit-if-changed lib test scripts
dart run scripts/validate_puzzle_packs.dart
flutter analyze
flutter test
