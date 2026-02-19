---
name: bash-dev
description: use this when coding bash/shell scripts
---

# Instructions

Read below carefully and make sure you adhere strictly to those guidelines.

## Bash Development Guidelines

### Core Development Environment

#### Code Quality & Formatting
- **Use ShellCheck for linting and shfmt for formatting**
- **Line length: 110 characters maximum** (enforced by shfmt)

### Code Style Guidelines

#### General Bash Practices
- Always start scripts with `#!/usr/bin/env bash` (portability)
- Use `set -euo pipefail` at the beginning for robust error handling
- Prefer `printf` over `echo` for consistent output
- Quote all variable expansions to prevent word splitting and globbing
- Use `[[ ... ]]` for conditional tests; avoid `[ ... ]` unless required for POSIX compatibility
- Use `readonly` for constants and `local` for function variables
- Prefer `$(...)` over backticks for command substitution
- Use `lowercase_with_underscores` for variable and function names
- Use `UPPERCASE` only for environment variables and exported constants
- Use `if cmd; then ...` instead of `if [ $? -eq 0 ]; then ...`
- Use `mapfile` or `read -a` for arrays; avoid splitting strings
- Use `declare -A` for associative arrays when needed

### Code Organization Principles

#### Function Design
- Keep functions small and focused (single responsibility)
- Use descriptive names that explain intent
- Limit function parameters; use global variables sparingly and document them
- Return early with `return` and use exit codes (0 for success, non-zero for failure)
- Use `return` to exit functions, not `exit` (unless script should terminate)
- Document the purpose, arguments, and return status of functions

#### Documentation
- Include a header comment with script purpose, usage, and author
- Include comments for complex logic
- For functions, add a brief description, list of arguments, and return status
- Use `#` for comments, not inline with code if it reduces readability

### Structure Best Practices

#### Configuration Management
- Use environment variables for configuration (e.g., `export VAR=value`)
- Source configuration files when needed (e.g., `.env` or `/etc/script.conf`)
- Validate required environment variables at script start

### Error Handling and Logging

#### Errors Management
- Define a `trap` for cleanup on EXIT and error signals
- Use `set -e` to exit on error, and `set -u` to fail on unset variables
- Write error messages to stderr: `echo "Error: ..." >&2`
- Use functions for logging: `log_info`, `log_error`, etc.
- Include context in error messages (e.g., filename, line number, function name)

#### Logging Configuration
- Use timestamps in logs: `date +"%Y-%m-%d %H:%M:%S"`
- Log levels can be controlled via environment variables (e.g., `LOG_LEVEL`)
- Avoid logging sensitive information (passwords, tokens)

### Security Practices
- Validate all input data (e.g., arguments, environment variables)
- Avoid using `eval`; use safer alternatives
- Use `--` to separate options from arguments in commands
- Sanitize filenames and paths to prevent command injection
- Use `mktemp` for temporary files and clean up with trap
- Run with least privileges; avoid running as root unless necessary

### Development Workflow

#### Code Review Checklist
- Code follows the style guidelines (shellcheck, shfmt)
- Scripts have proper shebang and `set -euo pipefail`
- Functions are documented and have clear purpose
- Error handling is robust and includes cleanup
- Security considerations are addressed
- Performance impact is considered (avoid unnecessary subshells, loops)

#### When Providing Code Examples
- Always include error handling and input validation
- Show both the implementation and usage examples
- Include comments explaining non‑obvious parts
- Consider edge cases (empty input, spaces in filenames, etc.)

### Response Format Guidelines

#### When Explaining Concepts
- Start with a brief overview
- Provide concrete examples
- Break complex topics into smaller, digestible parts
- Use analogies to relate new concepts to familiar ones
- Include practical applications and use cases

#### When Providing Code Solutions
- Explain the approach before showing code
- Include comments explaining non-obvious logic
- Show alternative approaches when relevant
- Discuss trade-offs and considerations
- Provide guidance on when to use different patterns
