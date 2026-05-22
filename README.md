# catdir

A robust directory-to-context text aggregator. catdir crawls a directory, filters out binary files, respects depth and size constraints, and outputs a cleanly structured layout or JSON stream. Ideal for gathering codebase context for analysis, documentation, or feeding into AI models.

## Features

- Recursive directory traversal with configurable depth limits
- Automatic binary file detection and filtering
- File size constraints to skip large files
- Multiple output formats: plain text, markdown, JSON
- SHA256 hashing support for file integrity verification
- Extension/pattern filtering with glob or strict matching
- Pattern-based file exclusion (ignore patterns)
- Sorting by alphabetical order or modification time
- Tree summary mode with file counts and total sizes
- Parallel processing support for large directories
- Multiple search engines: standard find, fd, ripgrep
- Portable across GNU and BSD systems

## Installation

### From Launchpad PPA (Recommended)

```bash
sudo add-apt-repository ppa:awesomeshot5051/catdir
sudo apt update
sudo apt install catdir
```

### Manual Installation

Clone the repository and install manually:

```bash
git clone https://github.com/awesomeshot5051/catdir.git
cd catdir
sudo bash -c 'cp catdir-pkg/usr/local/bin/catdir /usr/local/bin/catdir && chmod +x /usr/local/bin/catdir'
```

### Dependencies

catdir requires the following packages:

- bash
- coreutils
- findutils (or fd-find or ripgrep for faster searching)
- jq (for JSON output)
- tree (optional, for tree summary display)

Install dependencies on Debian/Ubuntu:

```bash
sudo apt install bash coreutils findutils jq tree
```

## Usage

### Basic Help Menu

```
Usage: catdir [directory] [-e extension] [-d directory] [-md maxdepth] [-o output_file]
         [-m] [-or alpha|mtime] [-s max_bytes] [-i pattern]
         [-md|--markdown] [-h|--hash] [-O json] [-fd|--fd] [-rg|--rg]
         [-t|--tree] [-tx|--threads #]

Options:
  [directory]          Target directory (default: current directory)
  -e,  --ext           File extension filter (e.g. 'py', '*.txt'). Omit to cat all files.
  -d,  -directory      Set target directory (default: current directory)
  -md, -maxdepth       Set max recursion depth (default: fully recursive)
  -o,  -output         Write output to a specific file instead of stdout
  -m,  -match          Use glob matching for extension (default: strict suffix match)
  -or, -ordered        Sort output: 'alpha' (alphabetical) or 'mtime' (modification time)
  -s,  -size           Skip files larger than this many bytes (e.g. 102400 for 100 KB)
  -i,  -ignore         Ignore files matching this pattern (can be used multiple times)
  --markdown           Wrap file contents in markdown code blocks based on extension
  -H,  --hash          Prepend the SHA256 hash of each file
  -O                   Output format ('text' or 'json')
  --fd                 Use 'fd' instead of 'find' for faster searching
  --rg                 Use 'rg' (ripgrep) instead of 'find' for faster searching
  -t,  --tree          Tree summary mode (calculates total size and counts files)
  -tx, --threads       Number of threads for parallel stat calls (ONLY usable with -t/--tree)
```

## Common Usage Examples

### Example 1: Basic Directory Concatenation

Concatenate all text files in the current directory:

```bash
catdir
```

### Example 2: Extract All Python Files

Extract all Python files from a project:

```bash
catdir /path/to/project -e py
```

### Example 3: Markdown Output

Output all files wrapped in markdown code blocks:

```bash
catdir -md
```

### Example 4: JSON Output for Automation

Output files as JSON (useful for piping to other tools):

```bash
catdir -O json
```

### Example 5: Limit File Size

Skip files larger than 100 KB:

```bash
catdir -s 102400
```

### Example 6: Depth Limitation

Only process files up to 2 levels deep:

```bash
catdir -md 2
```

### Example 7: Glob Pattern Matching

Use glob patterns for extension matching:

```bash
catdir -e "*.test.js" -m
```

### Example 8: SHA256 Hashing

Include SHA256 hash for each file:

```bash
catdir -H
```

### Example 9: Ignore Patterns

Exclude specific files or patterns:

```bash
catdir -i "*.min.js" -i "*.lock"
```

### Example 10: Alphabetical Sorting

Sort output alphabetically:

```bash
catdir -or alpha
```

### Example 11: Modification Time Sorting

Sort by modification time (oldest first):

```bash
catdir -or mtime
```

### Example 12: Tree Summary

Generate a tree summary with file counts and total size:

```bash
catdir -t
```

### Example 13: Parallel Processing

Use multiple threads for faster processing (tree mode only):

```bash
catdir -t -tx 4
```

### Example 14: JSON with Hashes

Output JSON format with SHA256 hashes:

```bash
catdir -O json -H
```

### Example 15: Fast Search with Ripgrep

Use ripgrep for faster searching:

```bash
catdir -rg -e py
```

### Example 16: Save to File

Save concatenated output to a file:

```bash
catdir -o output.txt
```

### Example 17: Generate AI Context

Gather Python and JavaScript files for AI model context:

```bash
catdir /path/to/project -e py -o python_context.txt
catdir /path/to/project -e js -o js_context.txt
```

### Example 18: Complex Filtering

Extract Markdown files, exclude node_modules, limit to 3 levels deep:

```bash
catdir /path/to/project -e md -md 3 -i "node_modules" -i ".git"
```

### Example 19: Markdown with Hashes

Output markdown code blocks with file hashes:

```bash
catdir -md -H
```

### Example 20: Fast Directory Analysis

Quick analysis with fd and multiple threads:

```bash
catdir --fd -t -tx 8
```

## Output Format Examples

### Text Format (Default)

```
======================== path/to/file.py ========================
print("Hello, World!")

======================== path/to/other.py ========================
def greet(name):
    return f"Hello, {name}"
```

### Markdown Format

```
======================== path/to/file.py ========================
```python
print("Hello, World!")
```

======================== path/to/other.py ========================
```python
def greet(name):
    return f"Hello, {name}"
```
```

### JSON Format

```json
[
  {
    "file": "path/to/file.py",
    "content": "print(\"Hello, World!\")\n"
  },
  {
    "file": "path/to/other.py",
    "content": "def greet(name):\n    return f\"Hello, {name}\"\n"
  }
]
```

### JSON with Hashes

```json
[
  {
    "file": "path/to/file.py",
    "hash": "a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3",
    "content": "print(\"Hello, World!\")\n"
  }
]
```

## Performance Tips

- Use `--fd` or `--rg` for significantly faster searching on large codebases
- Use `-md` to limit recursion depth for faster processing
- Use `-s` to skip large binary files early
- Use `-tx` with multiple threads for tree mode on massive directories
- Combine `-i` patterns to exclude common non-essential directories (node_modules, .git, etc.)

## Use Cases

- Gathering codebase context for AI model analysis
- Creating comprehensive code documentation
- Building searchable code archives
- Preparing code for code review tools
- Integrating with build systems and documentation generators
- Extracting specific file types for analysis
- Creating backups of source code in structured formats

## License

Licensed under the Apache License 2.0. See LICENSE file for details.

## Contributing

Contributions are welcome! Please submit pull requests or open issues for bug reports and feature requests.

## Support

For issues, questions, or feature requests, visit the GitHub repository:
https://github.com/awesomeshot5051/catdir

Report issues at:
https://github.com/awesomeshot5051/catdir/issues
