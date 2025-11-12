#!/usr/bin/env bash
set -e

echo "⚙️ Installing Android SDK and required components..."

ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$HOME/android-sdk}"
mkdir -p "$ANDROID_SDK_ROOT"
echo "✅ Created SDK directory at: $ANDROID_SDK_ROOT"

# -------------------------------------------------------------
# 1️⃣ Download command-line tools if missing
# -------------------------------------------------------------
if [ ! -d "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin" ]; then
  echo "📦 Downloading Android command-line tools..."
  mkdir -p "$ANDROID_SDK_ROOT/cmdline-tools"
  cd "$ANDROID_SDK_ROOT/cmdline-tools"
  curl -sSL https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -o cmdline-tools.zip
  unzip -q cmdline-tools.zip
  mv cmdline-tools latest
  rm cmdline-tools.zip
fi

# -------------------------------------------------------------
# 2️⃣ Set up environment variables for current step
# -------------------------------------------------------------
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export ANDROID_SDK_ROOT="$ANDROID_SDK_ROOT"
export PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator:$PATH"

# -------------------------------------------------------------
# 3️⃣ Install required Android SDK components
# -------------------------------------------------------------
echo "📦 Installing required Android packages..."
yes | sdkmanager --licenses >/dev/null
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# -------------------------------------------------------------
# 4️⃣ Persist env & path for subsequent steps
# -------------------------------------------------------------
{
  echo "ANDROID_HOME=$ANDROID_SDK_ROOT"
  echo "ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT"
} >> "$GITHUB_ENV"

{
  echo "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"
  echo "$ANDROID_SDK_ROOT/platform-tools"
  echo "$ANDROID_SDK_ROOT/emulator"
} >> "$GITHUB_PATH"

# -------------------------------------------------------------
# 5️⃣ Enforce Gradle 8.7 manually (no dependency on system Gradle)
# -------------------------------------------------------------
GRADLE_DIR="gradle/wrapper"
WRAPPER_JAR="$GRADLE_DIR/gradle-wrapper.jar"
WRAPPER_PROPS="$GRADLE_DIR/gradle-wrapper.properties"

mkdir -p "$GRADLE_DIR"

echo "⚙️ Forcin
