---
name: simplifly-flight-shopping
description: Use this skill whenever a user asks to search, compare, recommend, filter, or choose flights with Simplifly MCP tools. Always call flight_search for normal flight searches, show multiple options labeled F1-F5, and ask the user to reply with an option label to confirm real-time price. For Codex, web chat, Markdown-capable consoles, or local testing, format F1-F5 flight options as a Markdown comparison table with columns for option, flight, route/time, duration, price, and baggage; for QQ or plain chat channels, use compact plain text. Do not ask the user to provide a flight number after search results. Do not create orders or discuss payment in this shopping step. Use this skill even if Simplifly MCP prompts are not loaded.
---

# Simplifly Flight Shopping

Use this skill to help normal consumers search and compare flights through Simplifly MCP. Do not expose internal MCP fields or raw JSON.

## Locale and Language

The primary users are mainland China domestic consumers.

- Respond in Simplified Chinese by default unless the user explicitly asks for another language.
- Use Chinese for user-facing explanations, option labels, confirmations, errors, and next-step guidance.
- Keep tool names, API field names, code identifiers, and MCP parameters in English.
- Present prices in CNY by default.
- Present dates and times in China-friendly formats, and use local China time when clarifying relative dates.

## Required MCP Tools

This skill assumes the Simplifly MCP server is connected and exposes:

- `flight_search`
- `flight_pricing`

## Core Rules

- Ask only for information needed to search flights.
- During search, collect only route, date, passenger count, cabin class, and user preferences.
- Do not ask for passport, ID card, birthday, phone, email, or passenger document details during search.
- Do not call price verification, create orders, or request payment during search.
- Do not say "下单", "付款", or "预订哪个航班号" in the search result handoff. The next step is only choosing an option label for real-time price confirmation.
- Do not expose `solutionId`, internal IDs, raw JSON, or technical parameters to the user.
- If baggage, refund, ticketing, or comfort details are not returned by tools, say the information was not returned. Do not invent it.

## Natural-Language Intake

When the user describes a trip in ordinary language, extract:

- origin city or airport
- destination city or airport
- departure date
- return date or additional journey segments, if any
- adult, child, and infant counts
- cabin class
- preferences such as nonstop, checked baggage, airline, max price, departure time, arrival time, or maximum duration

Use defaults only when safe:

- If passenger count is omitted, assume 1 adult.
- If cabin class is omitted, assume economy.
- If the user says a city with multiple airports and the intended airport is unclear, ask a short clarification.
- If the date is relative, convert it to `YYYY-MM-DD` using the current date available to the agent.
- If the route or date is missing, ask for the missing field before searching.

## Tool Selection

Use `flight_search` for normal consumer searches.

Use `flight_pricing` only when the user already provides all of:

- flight number
- departure airport
- arrival airport
- departure date
- cabin class

## Search Output Rules

After calling `flight_search`, always show a recommendation list instead of only one option.

Default output:

- Show 5 options when available.
- If fewer than 5 valid options are returned, show all valid options.
- Label options as `F1`, `F2`, `F3`, `F4`, `F5`.
- Include airline and flight number, route, departure and arrival time, stops, cabin, price, and baggage if returned.
- Mark one option as recommended and explain why.
- Also identify the cheapest, fastest, and least troublesome options when the data supports it.
- End by telling the user they can reply with `F1`, `F2`, `F3`, etc. to confirm real-time price.

Never answer with only a single recommended flight unless the tool returned only one valid option.
Never ask the user to provide a flight number after showing search results; preserve the internal mapping from `F1`/`F2`/etc. to the hidden `solutionId`.

Choose the output format by channel:

- For QQ, SMS, WhatsApp, or other plain chat channels, avoid Markdown tables because they often render poorly. Prefer compact plain-text blocks.
- For Codex, web chat, Markdown-capable consoles, or local testing, use a Markdown comparison table by default.
- If the channel is unclear, use a Markdown comparison table unless there is a known plain-chat limitation.
- Do not output bare paragraph blocks for Markdown-capable channels.

Plain chat example:

- `F1 推荐｜川航 3U8830｜PEK → CKG → BKK`
- `时间：10:55 → 18:55｜约 9小时｜1次中转`
- `价格：¥1711｜行李：1件 23kg（如工具返回）`

Markdown-capable example:

查到了，按 **2026-05-09 北京到广州，1位成人，经济舱**，下面都是直飞：

| 选项 | 航班 | 起降 | 时长 | 价格 | 行李 |
|---|---|---|---|---:|---|
| F1 | 东方航空 MU6303 | 大兴 PKX 08:15 → 广州 CAN 11:35 | 3小时20分 | ¥870 | 手提8kg，托运20kg |
| F2 | 海南航空 HU7815 | 首都 PEK 20:30 → 广州 CAN 23:55 | 3小时25分 | ¥1120 | 手提7kg，托运20kg |

我推荐 **F1**：最便宜，早上出发中午到，托运行李也有 20kg。

你可以直接回复 `F1`、`F2` 等，我再帮你确认实时价格。

## Recommendation Style

Use ordinary consumer language. Prefer practical comparisons:

- "最便宜" for the lowest price
- "最快" for the shortest total duration
- "最少折腾" for nonstop or low-risk itineraries
- "时间更舒服" for reasonable departure and arrival times
- "行李更友好" when baggage data is returned and clearly better

Keep tradeoffs visible. For example, say when the cheapest option has a long layover, arrives late, or lacks returned baggage information.

## Handoff to Booking

When the user chooses a flight option and wants to continue booking, switch to the booking workflow.

The shopping skill should preserve the internal mapping between the visible option label, such as `F2`, and the corresponding hidden `solutionId`, but never show that mapping to the user.

Use wording like:

"我先帮你确认 F2 的实时价格。确认后如果你要继续预订，我再收集乘机人信息。"
