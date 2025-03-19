# Performance Review Data MCP Server
## Installation

### Requirements
- (Technically optional) [`just`](https://github.com/casey/just) for easy command execution

### Install gems
```sh
just install
```

### Set environment variables
```sh
cp .env.template .env
```

and add all necessary values

### Add to MCP Client
#### Claude
```json
{
  "mcpServers": {
    "performance_review_data": {
      "command": "just",
      "args": [
        "-f",
        "/absolute/path/to/mcp-server-performance-review-data/Justfile",
        "run"
      ]
    }
  }
}
```
