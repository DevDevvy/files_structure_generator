# Project File Structure Script

This script is designed to help developers generate a clear, navigable file structure of their project, making it easier to create context within developer tools. It filters out non-coding and media files and can include comments from the source code, facilitating better project understanding and documentation.

## Features

- **Generate File Structure**: Prints a tree-like structure of the project's directories and files starting from the root.
- **Comment Extraction**: Optionally extracts comments from code files, separating `TODO:` comments for better task tracking.
- **Customizable Exclusions**: Allows specification of directories and file types to exclude.
- **Flexible Output**: Supports printing to console or saving to a text file, with optional inclusion of detailed comments.

## Prerequisites

Before you start, make sure you have a bash shell available (like Git Bash on Windows, or the default terminal on macOS and Linux).

## Installation

1. **Clone the repository**:

   ```bash
   git clone git@github.com:DevDevvy/files_structure_generator.git
   cd files_structure_generator
   ```

2. **Make the script executable:**:

   ```bash
   chmod +x files_structure_generator.sh
   ```

3. **_Set an alias in your shell configuration file (e.g., .bashrc, .zshrc):_**
   ```bash
   echo "alias tree='/path/to/your/files_structure_generator.sh'" >> ~/.zshrc
   source ~/.zshrc
   ```

## USAGE

Run the script using the alias you set up:

```bash
tree [flags]
```

### Flags

- `-p`: Print the file structure directly to the console.
- `-c`: Include comments from the code files in the output.
- `-n`: Do not save the output to a file, only print to console (overrides any other settings).

## Configurations

You can customize the behavior of the script by editing the arrays at the beginning of the script:

- **EXCLUDE_DIRS**: Directories to exclude from the output.
- **EXCLUDE_FILES**: Specific file patterns to exclude.
- **MEDIA_EXTENSIONS**: Media file types to exclude.
- **CODE_EXTENSIONS**: File extensions to treat as code files.

## Example:

EXCLUDE_DIRS=("node_modules" ".vscode")\
EXCLUDE_FILES=("\*.lock" ".env") \
MEDIA_EXTENSIONS=("png" "jpg" "jpeg" "gif") \
CODE_EXTENSIONS=("js" "jsx" "ts" "tsx" "py")

## Output

- **File Structure**: Displays all directories and coding files from the root of the project, with optional links to the actual files.
- **Comments**: If enabled, shows all extracted comments and specifically lists `TODO:` comments separately.

## Contributing

Contributions are welcome! Feel free to fork the repository and submit pull requests.
