# Connecting ORMCP to gilhari_streaming_example

ORMCP Server connects an AI agent (Claude Desktop, Gemini CLI, OpenAI GPTs and other MCP clients) to this Gilhari microservice, so you can query and manipulate Employee objects in natural language. ORMCP discovers the object model automatically through the microservice's `getObjectModelSummary` endpoint.

This example demonstrates Gilhari's streaming API, which returns large result sets in batches; the streaming calls are in `curlCommandsStreamingSync` and `curlCommandsStreamingAsync` in this directory.

---

## Prerequisites

- The `gilhari_streaming_example` microservice is built and running. From the project root:
  ```
  gilhari\build.cmd               # Windows
  gilhari\run_docker_app.cmd

  ./gilhari/build.sh              # macOS / Linux
  ./gilhari/run_docker_app.sh
  ```
- Verify that it responds:
  ```
  curl http://localhost:80/gilhari/v1/getObjectModelSummary/now
  ```

---

## Step 1 — Install ORMCP Server

```bash
pip install ormcp-server
```

> **macOS note:** Do not create a Python virtual environment for ORMCP inside `~/Desktop/` or `~/Documents/`. macOS restricts access to those folders, and Claude Desktop then fails with a `PermissionError` on `pyvenv.cfg`. Use a location such as `~/.ormcp-venv` instead.

---

## Step 2 — Configure your AI client

### Claude Desktop

Add the following to `claude_desktop_config.json`:

**Windows:** `%APPDATA%\Claude\claude_desktop_config.json`
**macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "gilhari_streaming_example-ormcp": {
      "command": "ormcp-server",
      "args": [],
      "env": {
        "GILHARI_BASE_URL": "http://localhost:80/gilhari/v1/",
        "MCP_SERVER_NAME": "gilhari_streaming_example-ormcp",
        "READONLY_MODE": "True"
      }
    }
  }
}
```

Claude Desktop starts ORMCP Server automatically; no separate terminal is needed.

> **Windows note:** If `ormcp-server` is not found, use its full path as the `command`, e.g.
> `"C:\\Users\\<YourUsername>\\AppData\\Roaming\\Python\\Python313\\Scripts\\ormcp-server.exe"`.
> Run `where ormcp-server` in a Command Prompt to find the exact path.

### Other MCP clients (Gemini CLI, OpenAI GPTs, etc.)

Set these environment variables, then start the server with `ormcp-server`:

```bash
# macOS / Linux
export GILHARI_BASE_URL="http://localhost:80/gilhari/v1/"
export MCP_SERVER_NAME="gilhari_streaming_example-ormcp"
export READONLY_MODE="True"

# Windows (Command Prompt)
set GILHARI_BASE_URL=http://localhost:80/gilhari/v1/
set MCP_SERVER_NAME=gilhari_streaming_example-ormcp
set READONLY_MODE=True
```

Some clients (e.g., Gemini CLI, OpenAI GPTs) require ORMCP Server to run in HTTP mode (`ormcp-server --transport http`). See the [ORMCP documentation](https://github.com/SoftwareTree/ormcp-docs) for client-specific configuration.

---

## Step 3 — Example interactions

Once connected, try asking your AI agent:

- *"Show me 10 employees"*
- *"How many employees are there?"*
- *"What's the average compensation of exempt employees?"*
- *"Give me a summary of the object model"*

The configuration above sets `READONLY_MODE` to `True`, so only query tools are available to the agent. To try requests that change data, such as the following, set `READONLY_MODE` to `False`:

- *"Add a new non-exempt employee named Maria with id 501 and compensation 62000"*
- *"Delete the employee with id 39"*

---

## ORMCP environment variables reference

| Variable | Value for this example | Description |
|---|---|---|
| `GILHARI_BASE_URL` | `http://localhost:80/gilhari/v1/` | Base URL of the running Gilhari microservice |
| `MCP_SERVER_NAME` | `gilhari_streaming_example-ormcp` | Name shown in AI client tool lists |
| `READONLY_MODE` | `True` | `True` exposes only query tools; `False` also exposes tools that insert, update and delete data |
| `GILHARI_TIMEOUT` | `30` (default) | API timeout in seconds |
| `LOG_LEVEL` | `INFO` (default) | `DEBUG`, `INFO`, `WARNING` or `ERROR` |
| `GILHARI_NAME`, `GILHARI_IMAGE`, `GILHARI_PORT` | not set | Optional: let ORMCP Server start the microservice container itself (e.g., `GILHARI_IMAGE` = `gilhari_streaming_example:1.0`) if none is running. See the ORMCP documentation. |

If you run the microservice on a different host port (e.g., `-p 8888:8081` in `gilhari/run_docker_app`), change the port in `GILHARI_BASE_URL` to match.

---

## Further reading

- [ORMCP documentation](https://github.com/SoftwareTree/ormcp-docs)
- [ORMCP troubleshooting guide](https://github.com/SoftwareTree/ormcp-docs/blob/main/guides/troubleshooting.md)
- [ORMCP product page](https://www.softwaretree.com/products/ormcp/)
