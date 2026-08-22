# AI Hub Remote MCP Two-Container Reproducer

> [!NOTE]
> The issue found in build 126 was fixed in build 136.
> [The single-container configuration](https://github.com/iijimam/AIHub-1container) works correctly with build 136.
>
> However, Remote MCP does not work when the Agent and MCP Server run in separate containers.

## Environment

### Agent Container

- InterSystems IRIS Community 2026.3.0AI.136.0

### MCP Server Container

- InterSystems IRIS Community 2026.3.0AI.136.0
- iris-mcp-server
- transport=http
- host=0.0.0.0
- port=51403
- base_route=/mcp

## ToolSet Configuration

[Demo.Agent.ToolSet.cls](./agent/src/Demo/Agent/ToolSet.cls)

```xml
<MCP Name="RemoteServer">
    <Remote
        URL="http://mcpserver:51403/mcp"
        AuthType="basic"
        Username="SuperUser"
        Password="SYS"
    />
</MCP>
```

The same Basic authentication configuration works in the single-container configuration.

---

# Expected Result

The Agent should connect to the MCP Server and discover the MCP tools.

Expected flow:

```text
Agent
  -> MCP list_tools
  -> iris-mcp-server
  -> wgproto GET /v1/services
  -> IRIS
  -> ToolManager.%Discover()
```

---

# Actual Result

The Agent does not connect to the MCP Server.

`ToolManager.%Discover()` on the MCP Server is not called.

---

# How to Reproduce

## 1. Start the Containers

```bash
docker compose up -d
```

## 2. Check Connectivity from the Agent Container

Enter the Agent container:

```bash
docker compose exec agent bash
```

Check DNS:

```bash
getent hosts mcpserver
```

Example:

```text
172.19.0.2 mcpserver
```

Check the MCP endpoint:

```bash
curl -v \
  --connect-timeout 5 \
  -H "Authorization: Basic U3VwZXJVc2VyOlNZUw==" \
  -H "Accept: application/json, text/event-stream" \
  http://mcpserver:51403/mcp
```

Example response:

```text
Connected to mcpserver (...) port 51403

HTTP/1.1 400 Bad Request
Bad Request: Session ID is required
```

This confirms that the Agent container can connect to the MCP Server container.

## 3. Capture MCP Traffic

In the MCP Server container:

```bash
docker compose exec -u root mcpserver bash
```
```bash
tcpdump -i any -nn 'port 51403 or port 1972'
```

Leave `tcpdump` running.

## 4. Run the Agent Test

In the Agent container:

```bash
iris session iris
```

Run:

```objectscript
do ##class(Demo.Agent.ChatTest).TestChat()
```

## 5. Check tcpdump

No traffic is observed:

```text
(no traffic on port 51403 or 1972)
```

---

# Result

Direct communication from the Agent container works:

```text
Agent container
  -> curl
  -> mcpserver:51403
  -> OK
```

However, communication from the AI Hub Agent does not start:

```text
AI Hub Agent
  X
  -> mcpserver:51403
```

No connection to port 51403 is observed, so the request does not reach `iris-mcp-server`.

As a result, there is also no wgproto traffic on port 1972 and IRIS `ToolManager.%Discover()` is not called.

The same Remote MCP ToolSet configuration works correctly in [the single-container configuration](https://github.com/iijimam/AIHub-1container).