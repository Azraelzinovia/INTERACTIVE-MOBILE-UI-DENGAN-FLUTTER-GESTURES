#!/usr/bin/env bash
set -e

# Versi Flutter yang membawa Dart SDK 3.13.5 (sesuai pubspec.yaml)
FLUTTER_VERSION="${FLUTTER_VERSION:-3.47.7}"
FLUTTER_DIR="${HOME}/flutter-${FLUTTER_VERSION}"

if ! command -v flutter >/dev/null 2>&1; then
  if [ ! -x "${FLUTTER_DIR}/bin/flutter" ]; then
    echo "Mengunduh Flutter SDK ${FLUTTER_VERSION}..."
    mkdir -p "${FLUTTER_DIR}"
    curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
      | tar -xJ -C "${FLUTTER_DIR}" --strip-components=1
  fi
  export PATH="${FLUTTER_DIR}/bin:${PATH}"
fi

# Flutter membaca versinya lewat git (`git -c ...`). Pastikan memakai binary git
# asli, bukan wrapper terbatas yang mungkin ada lebih dulu di PATH.
REAL_GIT=""
for candidate in /usr/bin/git /bin/git /usr/local/bin/git; do
  if [ -x "${candidate}" ]; then
    REAL_GIT="${candidate}"
    break
  fi
done
if [ -n "${REAL_GIT}" ]; then
  GIT_SHIM_DIR="${HOME}/.flutter-git-bin"
  mkdir -p "${GIT_SHIM_DIR}"
  ln -sf "${REAL_GIT}" "${GIT_SHIM_DIR}/git"
  export PATH="${GIT_SHIM_DIR}:${PATH}"
fi

# Tandai repo Flutter sebagai aman untuk git tanpa mengubah konfigurasi global
export GIT_CONFIG_COUNT=1
export GIT_CONFIG_KEY_0="safe.directory"
export GIT_CONFIG_VALUE_0="*"

flutter config --no-analytics >/dev/null 2>&1 || true
flutter --version
flutter pub get
flutter build web --release
