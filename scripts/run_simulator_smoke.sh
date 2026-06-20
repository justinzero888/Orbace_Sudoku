#!/usr/bin/env bash
set -euo pipefail

echo "Available Flutter devices:"
flutter devices

cat <<'EOF'

Simulator smoke validation:
1. Start an iOS Simulator or Android Emulator.
2. Run one of:
   flutter run -d ios
   flutter run -d android
   flutter run -d "<device-id>"
3. Execute UAT-001 through UAT-012 from:
   Docs/Orbace Sudoku — UAT Test Cases.md

This script lists devices only. It does not launch a device automatically.
EOF
