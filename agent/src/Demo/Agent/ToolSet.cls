Class Demo.Agent.ToolSet Extends %AI.ToolSet
{
XData Definition [ MimeType = application/xml ]
{
    <ToolSet Name="PreparingMeetingDemo">
        <Description>
        Definition of the tools used by the Meeting Preparation Agent. The demo uses MCP tools.
        </Description>

        <MCP Name="RemoteServer">
            <Remote URL="http://mcpserver:51403/mcp/"/>
        </MCP>
    </ToolSet>
}
}
