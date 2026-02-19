---
name: neovim-dev
description: use this when coding in lua to customize neovim
---

# Instructions

Read below carefully and make sure you adhere strictly to those guidelines.

## Neovim Lua Development Guidelines

### Core Context & Assumptions

#### Environment Setup
- **Package Manager**: lazy.nvim is the primary plugin manager
- **Linting**: Use luacheck for static analysis and error detection
- **Formatting**: Use stylua for consistent code formatting
- **Target**: Neovim configuration and plugin development in Lua

#### Code Quality Standards
- Follow Neovim Lua conventions and idioms
- Prioritize readability and maintainability
- Use proper error handling with `pcall` when appropriate
- Leverage Neovim's built-in Lua APIs (`vim.*` modules)

### Package Management with lazy.nvim

#### Plugin Specification Format
```lua
-- Always structure plugins like this:
{
  "author/plugin-name",
  dependencies = { "required/dependency" },
  event = "VeryLazy", -- or appropriate lazy-loading event
  opts = {}, -- for plugins that accept setup() options
  config = function()
    -- configuration code here
  end,
}
```

### Linting Rules (luacheck)

#### Required .luacheckrc Configuration
```lua
-- Include these settings for Neovim development:
globals = {
  "vim",
  "describe", "it", "before_each", "after_each", -- for testing
}
ignore = {
  "212", -- unused argument (common in Neovim callbacks)
  "213", -- unused loop variable
}
max_line_length = 100
```

#### Code Standards to Enforce
- Declare all variables explicitly (avoid implicit globals)
- Use meaningful variable names
- Prefer local variables over global ones
- Handle unused parameters with underscore prefix: `_unused_param`

### Formatting Rules (stylua)

#### stylua.toml Configuration
```toml
indent_type = "Spaces"
indent_width = 2
column_width = 100
line_endings = "Unix"
quote_style = "AutoPreferDouble"
call_parentheses = "Always"
```

#### Style Guidelines
- Use 2-space indentation consistently
- Prefer double quotes for strings
- Always use parentheses for function calls
- Keep lines under 100 characters
- Use trailing commas in multi-line tables

### Neovim Lua Patterns & Best Practices

#### Module Structure
```lua
-- Always structure modules like this:
local M = {}

-- Local helper functions
local function helper_function()
  -- implementation
end

-- Public API
function M.setup(opts)
  opts = opts or {}
  -- setup logic
end

function M.main_function()
  -- main functionality
end

return M
```

#### Common Neovim APIs to Suggest
- `vim.api.*` - Core Neovim API functions
- `vim.fn.*` - Vimscript function access
- `vim.opt.*` - Option management
- `vim.keymap.set()` - Keymap creation
- `vim.cmd()` - Execute Vim commands
- `vim.notify()` - User notifications
- `vim.schedule()` - Defer execution to main loop

#### Error Handling Patterns
```lua
-- Prefer pcall for operations that might fail:
local ok, result = pcall(require, "optional_module")
if not ok then
  vim.notify("Failed to load module: " .. result, vim.log.levels.WARN)
  return
end

-- Use assertions for required dependencies:
local required_plugin = require("essential_plugin")
assert(required_plugin, "essential_plugin is required")
```

### Debugging

#### Debugging Patterns
```lua
-- Use vim.inspect for debugging complex tables:
print(vim.inspect(complex_table))

-- Use vim.notify for user-facing messages:
vim.notify("Debug: operation completed", vim.log.levels.INFO)

-- Use assert for catching logic errors early:
assert(type(config) == "table", "config must be a table")
```

### Performance Considerations

#### Memory Management
- Avoid creating unnecessary closures in loops
- Clear large tables when no longer needed
- Use weak references for caches when appropriate

### Common Antipatterns to Avoid

#### Plugin Configuration
- Don't call `setup()` multiple times on the same plugin
- Avoid mixing lazy.nvim with other package managers
- Don't use deprecated APIs (check `:help deprecated`)

#### Code Organization
- Avoid deeply nested configuration tables
- Don't put everything in init.lua
- Avoid global variables (except vim namespace)
- Don't ignore luacheck warnings without good reason

### Response Guidelines for LLM

#### When Providing Code Examples
1. Always include proper error handling
2. Use lazy.nvim syntax for plugin specifications
3. Follow the established module pattern
4. Include relevant comments explaining Neovim-specific concepts

#### When Explaining Concepts
1. Draw parallels to Python/web development when helpful
2. Explain Neovim-specific terminology
3. Provide context for why certain patterns exist
4. Include links to relevant Neovim help (`:help topic`)

#### When Debugging Issues
1. Check plugin loading order and dependencies
2. Verify lazy.nvim configuration syntax
3. Suggest using `:checkhealth` for diagnostics
4. Recommend appropriate logging/debugging approaches
