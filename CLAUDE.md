# MCP Performance Review Data - Development Guide

## Build/Run Commands
- Install dependencies: `just install`
- Run the application: `just run`
- Format the code `just format-code`

Format each file you edit before finishing your work!

## Code Style Guidelines
- Prefer module/class namespacing (like `Tools::ListUserPullRequestActivity`)
- Environment variables: Use in class variables, check/warn if missing
- Use `warn` for logging (since MCP servers use stdout for communication)
- Module pattern: Define tools in `lib/tools/` and require in `lib/tools.rb`
- MCP tools: Define in main.rb with description and proper argument definitions
- Naming: Use snake_case for methods/variables, CamelCase for classes
- Documentation: Include descriptive comments for tools and methods
