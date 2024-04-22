#!/bin/bash

# Set the output file name and path
OUTPUT_FILE="file_structure.txt"
OUTPUT_FILE_PATH="./$OUTPUT_FILE"

# Set the current working directory
CURRENT_DIR=$(pwd)

# Exclusion list
EXCLUDE=("node_modules" ".vscode" "*.lock" ".env")

# Check for the '-y' flag to print to console
PRINT_TO_CONSOLE=false
for arg in "$@"; do
  if [ "$arg" == "-y" ]; then
    PRINT_TO_CONSOLE=true
    break
  fi
done

# Function to generate the file structure with exclusions and proper nesting
generate_file_structure() {
  local dir=$1
  local indent=$2
  local prefix=$3

  # Iterate through the files and directories
  for file in "$dir"/*; do
    # Check for exclusions
    local base_file=$(basename "$file")
    for exclude in "${EXCLUDE[@]}"; do
      [[ "$base_file" == $exclude ]] && continue 2
    done

    if [ -d "$file" ]; then
      # Directory, recurse into it
      echo -en "${prefix}┣━ ${base_file}\n"
      generate_file_structure "$file" "$indent  " "${prefix}┃  "
    else
      # File, print it
      echo -en "${prefix}┃  ${base_file}\n"
    fi
  done
}

if $PRINT_TO_CONSOLE; then
  # Print the file structure to the console
  echo "Generating file structure..."
  echo "┣━ $(basename $CURRENT_DIR)"
  generate_file_structure "$CURRENT_DIR" "" "┃  "
fi

# Generate the file structure and save it to the file
> "$OUTPUT_FILE_PATH"
echo "┣━ $(basename $CURRENT_DIR)" >> "$OUTPUT_FILE_PATH"
generate_file_structure "$CURRENT_DIR" "" "┃  " >> "$OUTPUT_FILE_PATH"

# Print a success message
echo "File structure saved to $OUTPUT_FILE_PATH"
