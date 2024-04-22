# File Tree Generator Script

## Overview

The File Tree Generator script is a Bash script designed to create a visual representation of the directory structure of a project, saving it to a text file and optionally printing it to the console. This tool is particularly useful for developers who want to quickly document or visualize the structure of their projects. It excludes common directories and files that are not typically needed in such documentation, like `node_modules`, `.vscode`, `.lock`, and `.env` files.

## Features

- **Exclusion of Unnecessary Files/Directories**: Automatically excludes directories and files like `node_modules`, `.vscode`, etc.
- **Conditional Console Output**: Only prints the file structure to the console if executed with the `-y` flag.
- **Saves to File**: Always saves the generated file structure to a text file named `file_structure.txt` in the current directory.

## Prerequisites

This script requires a Unix-like environment with Bash.

## Installation

### 1. Clone the Repository

First, clone this repository or download the `files_structure_generator.sh` script directly into your desired directory.

```bash
git clone [Your-Repository-URL]
cd [Your-Repository-Name]
```

### 2. Make the Script Executable

To make the `files_structure_generator.sh` script executable, run the following command:

```bash
chmod +x files_structure_generator.sh
```

### 3. Creating a Bash Alias

You can create an alias for easy execution of the script. Open your `~/.bashrc` or `~/.bash_profile` file and add the following line:

```bash
alias generate-tree='./path/to/files_structure_generator.sh'
```

Replace `./path/to/files_structure_generator.sh` with the actual path to the script. After adding the alias, apply the changes by running:

```bash
source ~/.bashrc  # or ~/.bash_profile
```

### Usage

#### Basic Execution

To generate the file structure and save it to `file_structure.txt` without printing to the console:

```bash
generate-tree
```

#### Execution with Console Output

To generate the file structure and also print it to the console:

```bash
generate-tree -y
```

### How It Works

The script walks through the directory starting from where the script is located (or another specified starting directory). It records each file and directory, ignoring specified exclusions, and constructs a tree-like structure. The results are saved to `file_structure.txt` and printed to the console if executed with the `-y` flag.

### Customization

You can customize the list of excluded files and directories by modifying the `EXCLUDE` array within the script:

```bash
EXCLUDE=("node_modules" ".vscode" "*.lock" ".env")
```

Feel free to add or remove items as needed for your specific project requirements.

### Contributing

Contributions are welcome. Please fork the repository, make your changes, and submit a pull request.

### License

Specify your license or state that the project is licensed under the MIT License, which allows commercial use, modification, distribution, private use, and patent use.
