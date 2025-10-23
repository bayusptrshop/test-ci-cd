#!/bin/bash

echo "Cleaning YAML files..."

# List files to clean
files=(".github/workflows/ci.yml" ".github/workflows/cd.yml")

for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    echo "Cleaning $file"
    # Remove trailing spaces
    sed -i '' 's/[[:space:]]*$//' "$file"
    # Ensure Unix line endings
    sed -i '' 's/\r$//' "$file"
    # Add newline at end of file if missing
    sed -i '' -e '$a\' "$file"
  fi
done

echo "Clean complete!"
