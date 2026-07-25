# AI Hub Remote MCP Discovery Hang Reproducer

## Environment

### Agent Container

- InterSystems IRIS Community 2026.3.0AI.126.0

### MCP Server Container

- iris-mcp-server
- transport=http
- port=51403
- base_route=/mcp

### ToolSet Configuration

[Demo.Agent.ToolSet.cls](./agent/src/Demo/Agent/ToolSet.cls)

```xml
<MCP Name="RemoteServer">
    <Remote URL="http://mcpserver:51403/mcp/"/>
</MCP>
```

---

## Expected Result

The test method is implemented in: [Demo.Agent.ChatTest.cls](./agent/src/Demo/Agent/ChatTest.cls)

The method executes:

```objectscript
Set tools = agent.ToolManager.%Discover()
```

and then calls:

```objectscript
do agent.Chat(...)
```

`%Discover()` should return the list of tools exposed by the MCP server, allowing the chat request to proceed.

---

## Actual Result

When executing:

```objectscript
do ##class(Demo.Agent.ChatTest).TestChat()
```

the method never returns.

The test method contains both:

```objectscript
Set tools = agent.ToolManager.%Discover()
```

and

```objectscript
do agent.Chat(...)
```

Based on packet capture, it appears the hang occurs during MCP discovery.

---
# How to Run the Test

## 1. Configure API Key

Edit `.env` and provide your OpenAI API key.

The repository uses OpenAI.

---

## 2. Build and Start Containers

```bash
docker compose up -d
```

---

## 3. Verify Connectivity from Agent Container

Enter the Agent container:

```bash
docker compose exec agent bash
```

### DNS Resolution

```bash
getent hosts mcpserver
```

Example output:

```text
172.19.0.2 mcpserver
```

### Network Connectivity

```bash
ping -c 1 mcpserver
```

Example output:

```text
1 packets transmitted, 1 received, 0% packet loss
```

---

## 4. Verify MCP Server Responses

### Root Endpoint

```bash
curl -v http://mcpserver:51403/
```

Expected response:

```text
HTTP/1.1 404 Not Found
```

This confirms the HTTP server is reachable.

### MCP Endpoint

```bash
curl -v http://mcpserver:51403/mcp
```

Expected response:

```text
HTTP/1.1 406 Not Acceptable
Client must accept text/event-stream
```

### MCP Endpoint with SSE Accept Header

```bash
curl -v \
  -H "Accept: text/event-stream" \
  http://mcpserver:51403/mcp
```

Expected response:

```text
HTTP/1.1 400 Bad Request
Session ID is required
```

### MCP Endpoint with Fake Session ID

```bash
curl -v \
  -H "Accept: text/event-stream" \
  -H "Mcp-Session-Id: test" \
  http://mcpserver:51403/mcp
```

Expected response:

```text
HTTP/1.1 404 Not Found
Session not found
```

These responses indicate that the MCP server is reachable and operating normally.

---

## 5. Capture Traffic on MCP Server

Open a shell in the MCP Server container:

```bash
docker compose exec -u root mcpserver bash
```

Start tcpdump:

```bash
tcpdump -i any -s 0 -A port 51403 > /tmp/mcp.dump
```

Leave tcpdump running.

---

## 6. Run the Agent Test

Open another terminal and enter the Agent container:

```bash
docker compose exec agent bash
```

Enter an IRIS session:

```bash
iris session iris
```

Run the test:

```objectscript
do ##class(Demo.Agent.ChatTest).TestChat()
```

Observed result:

```text
The call never returns.
```

---

## 7. Analyze tcpdump

Stop tcpdump with Ctrl+C.

Run:

```bash
grep -i "initialize" /tmp/mcp.dump
```

Observed:

```json
{"jsonrpc":"2.0","id":0,"method":"initialize", ... }
{"jsonrpc":"2.0","method":"notifications/initialized"}
```

Run:

```bash
grep -i "initialized" /tmp/mcp.dump
```

Observed:

```json
{"jsonrpc":"2.0","method":"notifications/initialized"}
```

Run:

```bash
grep -i "tools/list" /tmp/mcp.dump
```

Observed:

```text
(no output)
```

---

# Packet Capture Summary

The following MCP traffic is observed:

```text
initialize
  ->
200 OK + session-id

notifications/initialized
  ->
202 Accepted
```

However:

```text
tools/list
```

is never observed.

---

# Conclusion

The MCP server is reachable and responds correctly.

Packet capture indicates that MCP initialization completes successfully:

```text
initialize -> OK
initialized -> OK
```

However, the AI Hub MCP client never sends:

```text
tools/list
```

and discovery hangs indefinitely.

---

# Attached Files

- reproducer container
- README.md
- mcp.dump
