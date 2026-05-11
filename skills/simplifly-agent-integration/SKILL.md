---
name: simplifly-agent-integration
description: Use this skill when integrating any agent with Simplifly MCP tools, building a Simplifly-powered travel assistant, or defining general Simplifly tool-use, safety, confirmation, hidden-field, raw-JSON, and user-facing output rules. This is a global integration policy skill, not a consumer workflow skill. Use workflow skills such as simplifly-flight-shopping, simplifly-flight-booking, and simplifly-flight-aftercare for concrete search, booking, payment, refund, change, and order tasks.
---

# Simplifly Agent Integration

Use this skill as the global integration policy for agents using Simplifly MCP tools. It defines shared safety, privacy, confirmation, and user-facing output rules across agents.

## Relationship to Workflow Skills

This skill does not replace workflow skills.

- Use `simplifly-flight-shopping` for flight search, comparison, recommendation, and F1/F2 option selection.
- Use `simplifly-flight-booking` for price verification, passenger collection, order creation, and payment.
- Use `simplifly-flight-aftercare` for order lookup, cancellation, refund, change, and itinerary workflows.

If a consumer workflow skill applies, follow that workflow skill for task-specific steps, field lists, defaults, and output format. Use this skill only for global Simplifly MCP safety rules.

Do not let this integration skill override workflow-specific rules. For example, passenger collection format, domestic ID-card fields, international passport fields, and contact defaults are owned by `simplifly-flight-booking`.

## MCP Prompt Independence

Do not rely on Simplifly MCP server prompts being loaded.

Any agent using Simplifly tools must be self-contained about:

- hidden internal fields
- read vs write tool safety
- explicit confirmation requirements
- personal-information timing
- raw JSON handling
- normal-user Chinese output

If a safety rule matters, it must live in this skill or the relevant workflow skill, not only in MCP prompt text.

## Tool Categories

Read or quote tools may be called when needed for the user's current task:

- `flight_search`
- `flight_pricing`
- `flight_verify_solution`
- `flight_order_detail`
- `flight_order_detail_by_external_id`
- `flight_order_list`
- `flight_download_itinerary`
- `flight_change_search`
- `flight_refund_quote`
- `flight_refund_money_search`
- `flight_get_airline_alliances`
- `flight_get_airline_alliance_by_airline`
- `flight_get_balance`

Write or state-changing tools require explicit user confirmation before every call:

- `flight_create_order`
- `flight_pay_order`
- `flight_cancel_order`
- `flight_refund_request`
- `flight_refund_confirm`
- `flight_change_request`

Never treat a prior general intent such as "帮我订" or "退了吧" as enough confirmation for a write tool. Summarize the action and ask for a clear confirmation first.

## Hidden Internal Fields

Never show these fields to normal users:

- `solutionId`
- `orderKey`
- `externalOrderId`
- `confirm`
- `confirmProduction`
- `confirmOrderId`
- `confirmExternalOrderId`
- `confirmAmount`
- `idempotencyKey`
- raw `passengerIds`
- raw `segmentIds`
- internal MCP arguments
- raw MCP JSON
- authentication, signature, or internal network details

## Local Signing

For local Simplifly signed requests, use `scripts/local_sign.sh`.

The script reads local configuration from environment variables:

- `CODE`
- `API_KEY`

It generates:

- `TS`: current UTC Unix timestamp in seconds, unless `TS` is already set
- `SIG`: SHA1 hex digest of `${CODE}${TS}${API_KEY}`

Example local invocation:

```bash
CODE="your-code" API_KEY="your-api-key" scripts/local_sign.sh
```

Do not place real `CODE` or `API_KEY` values in `SKILL.md`, examples, logs, or user-facing messages. Do not expose raw signatures to normal users unless the user is explicitly doing technical integration work.

It is safe to show user-facing business information when returned:

- airline and flight number
- route, city, airport, and terminal
- departure and arrival time
- duration and stop count
- cabin
- price and currency
- baggage
- refund and change rules
- order number
- payment status
- ticketing status
- itinerary file type

## User-Facing Output

For normal consumers, respond in Simplified Chinese by default.

- Use natural consumer-facing language.
- For passenger information collection, follow `simplifly-flight-booking` formatting. Do not use raw form templates, fenced code blocks, or generic blank forms unless the workflow skill explicitly asks for them.
- Do not expose tool names, MCP field names, or raw JSON unless the user explicitly asks for technical details.
- Summarize tool results. Do not paste raw API responses.
- If baggage, refund, change, ticketing, or policy details are missing from a tool result, say the information was not returned. Do not invent it.
- Keep API field names, tool names, and code identifiers in English only when discussing implementation with a technical user.

## Personal Information Rules

Collect personal information only when required by the current workflow.

- Do not collect passport, ID card, birthday, phone, email, or passenger document details during flight search.
- Collect passenger and document information only after the user chooses a flight, price is verified, and the user wants to continue booking.
- Do not guess passenger names, birthdays, genders, document numbers, phone numbers, emails, or document expiry dates.
- If information is missing or ambiguous, ask only for the missing fields.

## Write Operation Confirmation

Before `flight_create_order`, repeat:

- flight and route
- departure and arrival time
- passenger names
- contact default or contact override
- final price
- important baggage, refund, change, or ticketing notes returned by tools

Ask for explicit confirmation before creating the order.

Before `flight_pay_order`, repeat:

- order number
- payment amount
- payment method
- current order status if known

Ask for explicit confirmation before payment.

Before `flight_cancel_order`, repeat:

- order number
- passenger or route summary
- current order status
- cancellation action and consequence

Ask for explicit confirmation before cancellation.

Before `flight_refund_request` or `flight_refund_confirm`, repeat:

- passengers and segments to refund
- refund reason
- estimated refund amount and fee, if returned
- missing fee or policy data, if not returned

Ask for explicit confirmation before submitting or confirming refund.

Before `flight_change_request`, repeat:

- old flight
- new flight
- passengers to change
- fees or notes if returned
- change reason

Ask for explicit confirmation before submitting the change request.

## Error Handling

- If a read tool fails, explain simply and suggest the next useful action.
- If a write tool fails, do not retry blindly. Check current status when useful before retrying.
- If authentication, signature, network, invalid JSON, or service configuration errors occur, say the service is temporarily unavailable or misconfigured. Do not expose internal stack traces, tokens, signatures, or raw error payloads to normal users.
- Do not ask users to repeatedly submit personal information when the failure is a service or configuration problem.

## Safety Checklist

Before using any Simplifly MCP tool, check:

- Is the user asking for a search, booking, payment, refund, change, cancellation, or order task?
- Does a workflow skill apply?
- Is the tool read-only or state-changing?
- If it is state-changing, has the user explicitly confirmed the exact action?
- Are hidden fields kept internal?
- Is the response in natural Simplified Chinese for normal users?
- Are missing tool fields reported as missing instead of invented?
- Is personal information being collected only at the correct workflow stage?
