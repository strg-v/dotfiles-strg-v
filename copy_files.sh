#!/bin/bash

# Usage: ./copy_files.sh paths.txt

# Determine script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_FILE="$1"
DEST_DIR="$SCRIPT_DIR/dotfiles"

# Check input file
if [ -z "$INPUT_FILE" ]; then
    echo "Usage: $0 <file_with_paths>"
    exit 1
fi

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found."
    exit 1
fi

mkdir -p "$DEST_DIR"

while IFS= read -r line || [ -n "$line" ]; do
    # Skip comments and empty lines
    [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue

    # Expand ~ and $HOME
    eval "filepath=\"$line\""

    if [ -f "$filepath" ]; then
        # Remove leading slash to avoid absolute paths under DEST_DIR
        relative_path="${filepath#/}"
        dest_path="$DEST_DIR/$relative_path"

        # Create target directory
        mkdir -p "$(dirname "$dest_path")"

        echo "Copying: $filepath -> $dest_path"
        cp "$filepath" "$dest_path"
    else
        echo "Warning: File not found - $filepath"
    fi

done < "$INPUT_FILE"
