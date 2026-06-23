Class Demo.Agent.ChatTest Extends %AI.Agent
{
/// Provider to use
Parameter PROVIDER = "OpenAI";

/// Model to use
Parameter MODEL = "gpt-4.1-mini";

/// API key -- expand from environment variable at runtime
Parameter APIKEY = "@{env.OPENAI_API_KEY}";

/// 
Parameter TOOLSETS = "Demo.Agent.ToolSet";

/// System Instructions in Markdown
XData INSTRUCTIONS [ MimeType = text/markdown ]
{
You are an AI agent designed to assist sales representatives in preparing for meetings.
When you receive a request from a user—such as "Please prepare for tomorrow"s meeting with Company A"—identify the meeting participants and use the available tools to gather the following information:
- Customer information
- Client contact information
- Past meeting minutes
- Support history
- Recent news
Based on the information you"ve gathered, please create a briefing that the sales representative should review before the meeting.
Please note that the "keyPeople" in your response should include only the representatives from the client company; do not include your company"s sales representatives or account owners.
Guidelines:
1. If the meeting participants are unknown, do not make assumptions; instead, include a note in the JSON stating that confirmation is required.
2. Prioritize information obtained through the tool; do not fill in gaps with speculation.
3. Review past meeting minutes to identify key points discussed in previous meetings, outstanding items, and topics to be addressed in the next meeting.
4. Review the support history to identify current concerns and risks that should be addressed during the meeting.
5. Review recent news to identify information that could serve as conversation starters or angles for proposals.
6. Ensure the final output is in a format that sales representatives can use directly to prepare for the meeting.
Be sure to return your response in the following JSON format.
- Output must be in JSON only.
- Markdown is prohibited.
- Explanatory text is prohibited.
- Return the JSON in a compact, single-line format.
- For missing information, use an empty string or an empty array.
{
  "customerName": "Customer Name",
  "meetingPurpose": "Anticipated Meeting Purpose",
  "customerSummary": "Customer Overview",
  "keyPeople": [
    {
      "name": "Contact Name",
      "role": "Title/Role",
      
"interestArea": "Area of Interest",
      "notes": "Points to Note During the Meeting"
    }
  ],
  "recentTopics": [
    {
      "source": "MeetingMinutes or CustomerNews",
      "summary": "Recent Topics"
    }
  ],
  
"openIssues": [
    {
      "source": "SupportTicket or MeetingMinutes",
      "summary": "Unresolved Issues",
      "priority": "High / Medium / Low"
    }
  ],
  
"preparationItems": [
    "Materials and items to prepare in advance"
  ],
  "toolUseSummary": [
    {
      "toolName": "Name of the tool used",
      "result": "Summary of the information obtained"
    }
  ]
}

}

ClassMethod TestChat() As %Status
{
    Set agent = ..%New()
    $$$ThrowOnError(agent.%Init())

    Set tools = agent.ToolManager.%Discover()
    Write !,"=== registerd tools ===",!
    Do tools.%ToJSON()

    // Create chat session
    Set session = agent.CreateSession({
        "max_iterations": 10,
        "temperature": 0.2,
        "max_tokens": 3000
    })

    Set resp = agent.Chat(session,"Please prepare for tomorrow's meeting with ABC Trading.")
    Write !,"===return from LLM ===",!
    Write resp.Content,!

    return $$$OK
}
}
