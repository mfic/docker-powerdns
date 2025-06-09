#!/bin/sh
set -e

TEMPLATE_FILE="init.sql.template"
OUTPUT_FILE="init.sql"

# Combine all env files
ENV_FILES=".env .env-master .env-admin"

echo "🔧 Loading env files:"
for file in $ENV_FILES; do
    if [ -f "$file" ]; then
        echo "  ➕ $file"
        export $(grep -v '^#' "$file" | xargs)
    else
        echo "  ⚠️  Skipping missing $file"
    fi
done

# Generate final SQL
echo "📄 Rendering template: $TEMPLATE_FILE ➜ $OUTPUT_FILE"
envsubst <"$TEMPLATE_FILE" >"$OUTPUT_FILE"

echo "✅ Done: $OUTPUT_FILE"
