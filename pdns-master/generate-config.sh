#!/bin/sh
set -e

# Function to load .env files safely
load_env_file() {
    file="$1"
    if [ -f "$file" ]; then
        echo "Loading $file"
        set -a
        . "$file"
        set +a
    else
        echo "Warning: $file not found"
    fi
}

# Load environment variables from both env files
load_env_file "../pdns-db/.env-master"
load_env_file "./.env"

# Define templates and targets
CONFIGS="
sql.conf
api.conf
"

for file in $CONFIGS; do
    template="./config/templates/${file}.template"
    target="./config/pdns.d/${file}"

    if [ -f "$template" ]; then
        echo "Rendering $template → $target"
        envsubst <"$template" >"$target"
    else
        echo "Template not found: $template"
        exit 1
    fi
done
