# How to Run the Test

1. Enter the API key in [.env](./.env).

    This repogitory uses OpenAI. Please enter the your API key in [.env](./.env).

2. Build and Start the container.

    ```
    docker compose up -d
    ```

3. Run a test of Agen.

    login to the agent container.
    ```
    docker exec -it aihub-2container-agent-1 bash
    ```
    login to iris
    ```
    iris session iris
    ```
    run test method
    ```
    do ##class(Demo.Agent.ChatTest).TestChat()
    ```
    You will recieve these error
    ```
    USER>do ##class(Demo.Agent.ChatTest).TestChat()

        Set sc=agent.%Init() Throw:('sc) ##class(%Exception.StatusException).ThrowIf
                                        ^
    Interrupt(sc)
    <THROW>TestChat+2^Demo.Agent.ChatTest.1 *%Exception.StatusException エラー <%AICore>McpError: MCP protocol error: Failed to add tool spec 'mcp:remote:http://mcpserver:51403/mcp/': Resolver error: MCP protocol handshake failed: Send message error Transport [rmcp::transport::worker::WorkerTransport<rmcp::transport::streamable_http_client::StreamableHttpClientWorker<reqwest::async_impl::client::Client>>] error: unexpected server response: HTTP 403 Forbidden: Forbidden: Host header is not allowed, when send initia
    USER 2d1>q
    ```