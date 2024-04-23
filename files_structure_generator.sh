#!/bin/bash

# Set the output file name and path
OUTPUT_FILE="file_structure.txt"
OUTPUT_FILE_PATH="./$OUTPUT_FILE"

# Set the current working directory
CURRENT_DIR=$(pwd)

# Exclusion list for directories and certain file patterns
EXCLUDE_DIRS=("node_modules" ".vscode")
EXCLUDE_FILES=("*.lock" ".env")

# Media file extensions to exclude
MEDIA_EXTENSIONS=("png" "jpg" "jpeg" "gif" "mp3" "wav" "mp4" "avi" "mov" "flv")

# Define code file extensions
CODE_EXTENSIONS=("js" "jsx" "ts" "tsx" "py" "go" "html" "cs" "swift" "kt" "sh" "bash" "zsh" "sql" "yml" "json" "xml" "toml" "ini" "cfg" "md" "markdown" "txt" "log" "csv" "tsv" "rmd" "rmarkdown" "ipynb" "jupyter" "notebook" "dockerfile" "yaml" "jsp" "tsx" "vue" "svelte" "ejs" )

# Flags
PRINT_TO_CONSOLE=false
INCLUDE_COMMENTS=false
SAVE_TO_FILE=true

# Parse flags
for arg in "$@"; do
  case "$arg" in
    -p) PRINT_TO_CONSOLE=true ;;
    -c) INCLUDE_COMMENTS=true ;;
    -n) SAVE_TO_FILE=false; PRINT_TO_CONSOLE=true ;;
  esac
done

# Function to check if the file is a media file
is_media_file() {
  local filename=$1
  local extension="${filename##*.}"
  for ext in "${MEDIA_EXTENSIONS[@]}"; do
    [[ "$extension" == "$ext" ]] && return 0
  done
  return 1
}

# Function to check if the file is a code file
is_code_file() {
  local filename=$1
  local extension="${filename##*.}"
  for ext in "${CODE_EXTENSIONS[@]}"; do
    [[ "$extension" == "$ext" ]] && return 0
  done
  return 1
}

# Initialize a variable to store comments
comments_output=""
todo_comments_output=""

# Function to extract and store comments from files
extract_comments() {
  local file=$1
  if is_code_file "$file"; then
    local comments=""
    # Extract single-line comments
    local comment_lines=$(grep -oE '//.*|#.*' "$file")
    while read -r line; do
      if [[ "$line" =~ TODO: ]]; then
        # Extract only the TODO comment part
        local todo_comment=$(echo "$line" | grep -oE 'TODO:.*')
        todo_comments_output+="${file#$CURRENT_DIR/}: $todo_comment\n"
      else
        comments+="$line, "
      fi
    done <<< "$comment_lines"
    # Extract multi-line comments (These lines can also be adjusted if multi-line TODO comments need to be captured)
    comments+="$(awk '/\/\*/,/\*\//{print}' "$file" | tr '\n' ' ' | sed 's/  /, /g')"
    comments+="$(awk '/\"\"\"/,/\"\"\"/{print}' "$file" | tr '\n' ' ' | sed 's/  /, /g')"
    comments+="$(awk "/'''/,/'''/{print}" "$file" | tr '\n' ' ' | sed 's/  /, /g')"
    if [[ ! -z "$comments" ]]; then
      comments_output+="${file#$CURRENT_DIR/}: $comments\n"
    fi
  fi
}


# Function to generate the file structure with exclusions, proper nesting
generate_file_structure() {
  local dir=$1
  local indent=$2
  local prefix=$3

  # Iterate through the files and directories
  for file in "$dir"/*; do
    # Check for directory and file exclusions
    local base_file=$(basename "$file")
    for exclude in "${EXCLUDE_DIRS[@]}"; do
      [[ "$base_file" == $exclude ]] && continue 2
    done
    for pattern in "${EXCLUDE_FILES[@]}"; do
      [[ "$file" == $pattern ]] && continue 2
    done

    # Skip media files
    if is_media_file "$file"; then
      continue
    fi

    if [ -d "$file" ]; then
      # Directory, recurse into it
      echo -en "${prefix}┣━ ${base_file}\n"
      generate_file_structure "$file" "$indent  " "${prefix}┃  "
    else
      # File, print it
      echo -en "${prefix}┃  ${base_file}\n"
      # Extract comments if -c flag is set
      if $INCLUDE_COMMENTS; then
        extract_comments "$file"
      fi
    fi
  done
}

# Output the file structure and optionally the comments
if $PRINT_TO_CONSOLE; then
  # Print the file structure to the console
  echo "Generating file structure..."
  echo "┣━ $(basename $CURRENT_DIR)"
  generate_file_structure "$CURRENT_DIR" "" "┃  "
  if [[ ! -z "$todo_comments_output" ]]; then
    echo -e "\nTODO Comments:\n$todo_comments_output"
  fi
  if $INCLUDE_COMMENTS && [[ ! -z "$comments_output" ]]; then
    echo -e "\nOther Comments:\n$comments_output"
  fi
fi

if $SAVE_TO_FILE; then
  # Generate the file structure and save it to the file
  > "$OUTPUT_FILE_PATH"
  echo "┣━ $(basename $CURRENT_DIR)" >> "$OUTPUT_FILE_PATH"
  generate_file_structure "$CURRENT_DIR" "" "┃  " >> "$OUTPUT_FILE_PATH"
  if [[ ! -z "$todo_comments_output" ]]; then
    echo -e "\nTODO Comments:\n$todo_comments_output" >> "$OUTPUT_FILE_PATH"
  fi
  if $INCLUDE_COMMENTS && [[ ! -z "$comments_output" ]]; then
    echo -e "\nOther Comments:\n$comments_output" >> "$OUTPUT_FILE_PATH"
  fi
  echo "File structure saved to $OUTPUT_FILE_PATH"
fi