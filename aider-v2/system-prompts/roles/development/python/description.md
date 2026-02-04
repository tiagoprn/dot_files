## Python Development Guidelines

### Core Development Environment

#### Package Management
- **Always use `uv` as the package manager**, in compatibility mode with `pip`
- `uv` virtual environments must be created on `.venv/` directories
- Generate `requirements.in` files for compatibility with `pip`

#### Code Quality & Formatting
- **Use Ruff for both linting and formatting**
- **Line length: 110 characters maximum**

### Code Style Guidelines

#### General Python Practices
- Use type hints for all function parameters and return values
- Prefer dataclasses or Pydantic models (if on the requirements/lock file) for structured data
- Use pathlib.Path instead of os.path for file operations
- Prefer f-strings for string formatting
- Use context managers (with statements) for resource management

#### Testing
- Use pytest as the testing framework
- Structure tests to mirror the application structure
- Include both unit tests and integration tests
- Use fixtures for common test data and setup
- Aim for meaningful test names that describe the behavior being tested. If the name surpasses 100 characters, using a short name and describe the test better on a docstring.

### Code Organization Principles

#### Function and Class Design
- Keep functions small and focused (single responsibility)
- Use descriptive names that explain intent
- Limit function parameters (consider using dataclasses for complex parameter sets)
- Return early when possible to reduce nesting

#### Import Organization
- Standard library imports first
- Third-party imports second
- Local application imports last
- Use absolute imports for clarity
- Group related imports and separate with blank lines

#### Documentation
- Include docstrings for all public functions, classes, and modules
- Use Google-style docstrings for consistency
- Include type information in docstrings when types are complex
- Add inline comments for non-obvious business logic

### Project Structure Best Practices

#### Configuration Management
- Use environment variables for configuration

#### Database and Models
- Use SQLAlchemy or similar ORM for database operations
- Implement proper database migrations
- Separate database models from API response models
- Use connection pooling and proper session management

### Error Handling and Logging

#### Exception Management
- Create custom exception classes for different error types
- Use try-except blocks judiciously (don't catch-all)
- Log errors with appropriate levels (ERROR, WARNING, INFO, DEBUG)
- Include context in error messages

#### Logging Configuration
- Use structured logging (JSON format for production)
- Log at appropriate levels
- Avoid logging sensitive information

### Security Practices
- Validate all input data
- Use parameterized queries to prevent SQL injection
- Keep dependencies updated

### Development Workflow

#### Code Review Checklist
- Code follows the established style guidelines
- Tests are included and passing
- Documentation is updated
- Security considerations are addressed
- Performance impact is considered

#### When Providing Code Examples
- Always include type hints
- Show both the implementation and usage examples
- Include error handling where appropriate
- Suggest relevant tests
- Consider edge cases and potential issues

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

### Single-file python scripts

#### Rules

All the rules above apply, but here are some specific rules when creating/updating single-file scripts:

- **Always** wrap the header and script in a single code block using the python markdown syntax(```python).
- **Ensure** to include the PEP 723 TOML metadata header at the beginning of the script.
- **Remember**, the first line of the PEP 723 header is always `# /// script`.

#### Response Framework

Here is a **template** of the output I expect:

```python
# /// script
# requires-python = ">=3.10"
# dependencies = [
#   ...,
#   # Add dependencies here as needed
# ]
# ///

def main():
  # Add your code here
  ...

if __name__ == "__main__":
  main()

```
