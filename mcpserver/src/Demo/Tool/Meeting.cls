///Class for Defining MCP Server Tools for the Meeting Preparation Agent
Class Demo.Tool.Meeting Extends %AI.Tool
{
Property Name As %String [ InitialExpression = "Meeting" ];

Property Description As %String(MAXLEN = "") [ InitialExpression = "PreparingMeeting MCP server tools" ];

/// Retrieves an ID from a client's company name.
/// Arguments: Client name (e.g., ABC Trading.)
/// Return value: JSON string
/// { "customer_id":"C001"}
ClassMethod GetCustomerID(name As %String) As %DynamicObject
{
    #dim ex As %Exception.AbstractException
    set response={"customer_id":"C001"}
    return response

}

/// Retrieve the sales representative for a client company
/// Arguments: Client company ID (e.g., C001)
/// Return value: JSON string
/// {
///     "account_owner": ["Misaki Sato"],
/// }
ClassMethod GetAccountOwner(custid As %String) As %DynamicObject
{
    #dim ex As %Exception.AbstractException
    set response={
        "account_owner":[
            "Misaki Sato",
            "Taro Yamada"
        ]
    }
    return response
}


/// Retrieves customer company information based on the customer ID (customer_id) (similar to the information in the CRM)
/// Argument: Customer ID (e.g., C001)
/// Return: JSON string
/// response= {
///     "customer_id": "C001",
///     "customer_name": "ABC Trading",
///     "industry": "Manufacturing",
///     "region": "Kanto",
///     "contract_plan": "Enterprise",
///     "annual_revenue_range": "100 billion yen or more",
///     "employee_count": 200,
///     "main_system": "ERP, Production Management, Data Warehouse",
///     "current_interests":"Generative AI adoption, data integration, integration with existing systems",
///     "current_challenges":"Customer, inventory, and inquiry information is scattered across different departments, making it time-consuming to gather information before meetings",
///     "next_meeting_date":"2026-06-05",
///     "next_meeting_purpose":"Consultation on a demo of information integration for the sales and support departments using AI agents",
///     "last_contact_date":"2026-05-22",
///     "notes":"Led by the DX Promotion Office. A short demo that is easy to explain to frontline departments is requested."
///    }
ClassMethod GetCustomerInfo(custid As %String) As %DynamicObject
{
    #dim ex As %Exception.AbstractException
    set response= {
     "customer_id": "C001",
     "customer_name": "ABC Trading",
     "industry": "Manufacturing",
     "region": "Kanto",
     "contract_plan": "Enterprise",
     "annual_revenue_range": "100 billion yen or more",
     "employee_count": 200,
     "main_system": "ERP, Production Management, Data Warehouse",
     "current_interests":"Generative AI adoption, data integration, integration with existing systems",
     "current_challenges":"Customer, inventory, and inquiry information is scattered across different departments, making it time-consuming to gather information before meetings",
     "next_meeting_date":"2026-06-05",
     "next_meeting_purpose":"Consultation on a demo of information integration for the sales and support departments using AI agents",
     "last_contact_date":"2026-05-22",
     "notes":"Led by the DX Promotion Office. A short demo that is easy to explain to frontline departments is requested."
    }

    return response
}

/// Retrieves customer contact information based on the customer ID.
/// Arguments: Customer ID (e.g., C001)
/// Return value: JSON string
/// {
///  [{
///     "contact_id": "P001",
///     "customer_id" : "C001",
///     "contact_name": "鈴木 一郎",
///     "role_title":"DX推進室 室長"
///     "department":"室長	DX推進室",
///     "email":"ichiro.suzuki@example.com",
///     "interest_area":"AIエージェント, 業務効率化",
///     "decision_influence":"High",
///     "communication_style":"要点を先に知りたい",
///     "last_interaction_summary":"会議準備や社内問い合わせ対応でAIエージェントを試したいと発言"
///  }]
///  ,[]
/// }
/// 
ClassMethod GetCustomerContacts(custid As %String) As %DynamicObject
{
    #dim ex As %Exception.AbstractException
    set response={
        "contacts":[
            {
            "contact_id" :"P001",
            "customer_id": "C001",
            "contact_name": "Ichiro Suzuki",
            "role_title": "Head of the DX Promotion Office",
            "department": "Head, DX Promotion Office",
            "email": "ichiro.suzuki@example.com",
            "interest_area": "AI Agents, Operational Efficiency",
            "decision_influence":"High",
            "communication_style":"Prefers to hear the main points first",
            "last_interaction_summary":"Stated a desire to try out AI agents for meeting preparation and handling internal inquiries"
            }
        ]
    }
    return response
}

/// Retrieve meeting minutes by customer ID
/// Arguments: Business partner ID (e.g., C001)
/// Return value: JSON string
/// {
///  "mieeting_minutes":[
///     {
//      "meeting_id": "M001",
///     "customer_id": "C001",
///     "meeting_date": "2026-04-18",
///     "title": "Initial Consultation on Ideas for Utilizing AI",
///     "participants":"Ichiro Suzuki; Yumi Takahashi; Misaki Sato",
///     "summary":"At ABC Trading, sales representatives individually review the CRM, support history, and internal meeting minutes before each meeting, which takes more than 30 minutes to prepare. We want to use an AI agent to compile the necessary information.",
///     "key_topics":"Meeting Preparation Automation; MCP; Integration with Existing APIs",
///     "decisions":"At the next meeting, review a simple demo using customer information and support history",
///     "action_items":"Misaki Sato will draft a demo scenario; Takahashi will verify available internal APIs",
///     "sentiment":"Positive",
///     "risk_level":"Low"
///     }
///     ]
/// }
ClassMethod GetMeetingMinutes(custid As %String) As %DynamicObject
{
    #dim ex As %Exception.AbstractException
    set response={
        "mieeting_minutes":[
        {
            "meeting_id": "M001",
            "customer_id": "C001",
            "meeting_date": "2026-04-18",
            "title": "Initial Consultation on Ideas for Utilizing AI",
            "participants":"Ichiro Suzuki; Yumi Takahashi; Misaki Sato",
            "summary":"At ABC Trading, sales representatives individually review the CRM, support history, and internal meeting minutes before each meeting, which takes more than 30 minutes to prepare. We want to use an AI agent to compile the necessary information.",
            "key_topics":"Meeting Preparation Automation; MCP; Integration with Existing APIs",
            "decisions":"At the next meeting, review a simple demo using customer information and support history",
            "action_items":"Misaki Sato will draft a demo scenario; Takahashi will verify available internal APIs",
            "sentiment":"Positive",
            "risk_level":"Low"
        }
        ]
    }
    return response
}

/// Retrieve past ticket information based on a client company ID
/// Arguments: Client company ID (e.g., C001)
/// Return value: JSON string
/// {   
/// "tickets":[
///  {   "ticket_id": "T001",
///     "customer_id" : "C001",
///     "opened_at": "2026-05-10 09:20:00",
///     "closed_at":"2026-05-10 15:40:00",
///     "status":"Closed",
///     "priority":"High",
///     "category":"Integration",
///     "subject":"CRM連携バッチの遅延",
///     "description":"夜間バッチ後にCRM連携データの反映が遅れ、営業画面で一部情報が古い状態になった。",
///     "resolution_summary":"連携処理のリトライ設定を調整し、監視項目を追加した。",
///     "customer_inpact":"営業担当者の朝会準備に影響",
///     "related_product":"IRIS Interoperability",
///     "owner_name":"中村 拓也"
/// }
/// ]
/// }
ClassMethod GetSupportTicket(custid As %String) As %DynamicObject
{
    #dim ex As %Exception.AbstractException
    set response={
        "tickets":[
        {
            "ticket_id": "T001",
            "customer_id" : "C001",
            "opened_at": "2026-05-10 09:20:00",
            "closed_at":"2026-05-10 15:40:00",
            "status":"Closed",
            "priority":"High",
            "category":"Integration",
            "subject":"Delay in CRM Integration Batch",
            "description":"After the nightly batch run, there was a delay in reflecting CRM integration data, causing some information on the sales screen to become outdated.",
            "resolution_summary":"We adjusted the retry settings for the integration process and added monitoring metrics. ",
            "customer_impact":"Impacted sales representatives preparation for the morning meeting",
            "related_product":"IRIS Interoperability",
            "owner_name":"Takuya Nakamura"
        }
    ]
    }
    return response
}

/// Retrieve related news articles based on a business partner ID
/// Arguments: Business partner ID (e.g., C001)
/// Return value: JSON string
/// {   
///     "news":[
///    {
///     "news_id": "N001",
///     "customer_id": "C001",
///     "news_at": "2026-05-20",
///     "source_name":"Demo News",
///     "headline":"ABC Corporation Expands DX Investment in Manufacturing",
///     "description":"ABC Corporation announced a plan to strengthen data integration between its manufacturing and sales departments. The company will combine existing systems with AI to improve operational efficiency. ",
///     "relevance":"Highly compatible with proposals from the meeting preparation agent",
///     "url":"https://example.com/news/abc-dx"
///     }
///     ]
/// }
ClassMethod GetCustomerNews(custid As %String) As %DynamicObject
{
    #dim ex As %Exception.AbstractException
    set response={
        "news":[
        {
            "news_id": "N001",
            "customer_id": "C001",
            "news_at": "2026-05-20",
            "source_name":"Demo News",
            "headline":"ABC Corporation Expands DX Investment in Manufacturing",
            "description":"ABC Corporation announced a plan to strengthen data integration between its manufacturing and sales departments. The company will combine existing systems with AI to improve operational efficiency. ",
            "relevance":"Highly compatible with proposals from the meeting preparation agent",
            "url":"https://example.com/news/abc-dx"
        }
        ]
    }
    return response
}
}
