#!/bin/bash

echo "Fixing trailing spaces in YAML files..."

# List of files to fix
files=(
  ".github/workflows/ci.yml"
  ".github/workflows/cd.yml"
)

for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    echo "Processing $file..."
    # Remove trailing spaces
    sed -i '' 's/[[:space:]]*$//' "$file"
    # Ensure newline at end of file
    sed -i '' -e '$a\' "$file"
  else
    echo "File $file not found, skipping..."
  fi
done

echo "Fix complete! Validating files..."
yamllint .github/workflows/
