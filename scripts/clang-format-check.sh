#!/bin/bash
# Clang Format Check Script

TARGET_DIR="$1"
STYLE_ARG="$2"

# 引数がない場合はカレントディレクトリ
if [ -z "$TARGET_DIR" ]; then
  TARGET_DIR="."
fi

# スタイルの決定
if [ -f ".clang-format" ]; then
  echo "ℹ️  Found .clang-format file. Using configuration from file."
  STYLE_FLAG="--style=file"
else
  if [ -z "$STYLE_ARG" ] || [ "$STYLE_ARG" = "file" ]; then
     STYLE_ARG="Google"
  fi
  echo "ℹ️  No .clang-format file found. Using style: $STYLE_ARG"
  STYLE_FLAG="--style=$STYLE_ARG"
fi

echo "🔍 Checking formatting in: $TARGET_DIR"

output=$(find "$TARGET_DIR" \
  -type d \( -name ".git" -o -name "build" -o -name "node_modules" -o -name "target" \) -prune \
  -o \
  -type f \( -name "*.cpp" -o -name "*.h" -o -name "*.hpp" -o -name "*.c" -o -name "*.cc" -o -name "*.cxx" \) \
  -exec clang-format $STYLE_FLAG --dry-run --Werror {} + 2>&1)

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
  echo "✅ All files are correctly formatted."
  exit 0
else
  echo "❌ Formatting errors found:"
  echo "$output"
  echo ""
  echo "::error::Code formatting issues found. Please run clang-format locally."
  exit 1
fi
