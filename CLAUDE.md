# MCP Performance Review Data - Development Guide

## Build/Run Commands
- Install dependencies: `just install`
- Run the application: `just run`

## Code Style Guidelines
- Ruby style: Follow standard Ruby conventions (2-space indentation)
- Use frozen_string_literal comment in all Ruby files
- Prefer module/class namespacing (like `Tools::ListUserPullRequestActivity`)
- Environment variables: Use in class variables, check/warn if missing
- Error handling: Use stderr for warnings (`$stderr.puts`)
- Module pattern: Define tools in `lib/tools/` and require in `lib/tools.rb`
- MCP tools: Define in main.rb with description and proper argument definitions
- Naming: Use snake_case for methods/variables, CamelCase for classes
- Documentation: Include descriptive comments for tools and methods
