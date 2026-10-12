
#!/usr/bin/env bash
set -e

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter SDK belum tersedia di lingkungan build Netlify."
  exit 1
fi

flutter pub get
flutter build web
