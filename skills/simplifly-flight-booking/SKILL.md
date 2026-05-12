---
name: simplifly-flight-booking
description: Use this skill when a user selects a Simplifly flight option and wants to verify price, continue booking, provide passenger details, create an order, or pay. It covers price verification, passenger and document collection, order creation, payment confirmation, and user-facing booking safety rules. When collecting passenger information, use compact Chinese prompts for name, birth date, gender, nationality, document type and number, phone with country/region code, and email; infer passenger type when clear instead of asking for it. Use this skill even if Simplifly MCP prompts are not loaded.
---

# Simplifly Flight Booking

Use this skill to guide a consumer from selected flight option to verified price, passenger collection, order creation, and payment through Simplifly MCP.

## Locale and Language

The primary users are mainland China domestic consumers.

- Respond in Simplified Chinese by default unless the user explicitly asks for another language.
- Use Chinese for user-facing explanations, passenger information prompts, confirmations, payment notices, errors, and next-step guidance.
- Keep tool names, API field names, code identifiers, and MCP parameters in English.
- Present prices in CNY by default.
- Present dates and times in China-friendly formats, and use local China time when clarifying relative dates.

## Required MCP Tools

This skill assumes the Simplifly MCP server is connected and exposes:

- `flight_verify_solution`
- `flight_create_order`
- `flight_pay_order`
- `flight_order_detail`

## Core Rules

- Only verify price after the user chooses a specific flight option.
- Only collect passenger details after price verification and the user wants to continue booking.
- Never create an order or pay without explicit user confirmation.
- Never expose `solutionId`, `orderKey`, `externalOrderId`, `confirm`, `confirmProduction`, `confirmOrderId`, `confirmExternalOrderId`, `confirmAmount`, or idempotency fields.
- Do not use placeholder passenger data, fake document numbers, fake birthdays, or guessed contact details.
- Do not say seats are "locked" or "held" unless the tool result explicitly says inventory has been locked or held. Price verification alone is not seat locking.
- Do not show only airport IATA codes to normal users. Include city/airport names and terminals when returned, such as "北京首都 PEK T3" and "曼谷素万那普 BKK".
- If tool results lack baggage, refund, ticketing, or rule details, say the information was not returned. Do not invent it.

## Price Verification

Call `flight_verify_solution` only after the user selects a visible option such as `F1` or `F2`.

After verification:

- Show the final price.
- Mention whether the price changed, if the tool result makes that clear.
- Summarize the flight, cabin, baggage if returned, and key timing.
- Show route points in user-friendly form: city name + airport name if known + IATA code + terminal if returned. Do not rely on IATA codes alone.
- If only IATA codes are returned, expand common airport names when confidently known. For example: PEK = 北京首都国际机场, PKX = 北京大兴国际机场, PVG = 上海浦东国际机场, SHA = 上海虹桥国际机场, BKK = 曼谷素万那普机场, DMK = 曼谷廊曼机场.
- Say "实时价格验证通过" instead of "座位已锁定" unless the tool explicitly returned a lock/hold status.
- Ask whether the user wants to continue booking.
- Do not show `orderKey`.

Preferred concise style after successful verification:

"F1 实时验价成功，价格还是 ¥1260，余票充足。

航班信息：首都航空 JD5919，2026-05-12 06:55 大兴 PKX -> 10:50 大理 DLU，直飞，经济舱。
行李：手提 1 件 7kg，无免费托运行李。
退改规则：工具未返回，暂时无法确认具体费用。"

Only say "价格还是" when the verified price is unchanged. Only mention remaining seats or "余票充足" when the tool result explicitly returns that inventory status. If the tool returns no refund/change details, say those details were not returned instead of estimating them.

If verification fails, briefly explain that the option could not be confirmed and suggest choosing another option or searching again.

## Passenger Document Rules

Do not collect document information during flight search.

After the user selects a flight and price is verified, collect the needed document details without over-explaining the route type.

- For international flights, explicitly say: "这趟是国际航班，下单需要护照信息。请确保护照姓名拼音、护照号和有效期准确。"
- For international flights, ask for `passport` as the travel document type, passport number, and passport expiry date. Do not use vague labels like "证件号码" without saying "护照号码".
- For domestic mainland China flights, do not lead with a separate sentence like "这趟是国内航班，下单需要乘机人身份证信息" unless the user needs clarification. In the collection prompt, ask for "证件类型和号码：身份证或护照等".
- For domestic mainland China flights, use `idcard` internally when the passenger provides a Chinese resident ID card. Do not omit document type or document number.
- For Hong Kong, Macau, and Taiwan routes, do not assume a mainland ID card is sufficient. Ask which valid travel document the passenger will use, such as 港澳通行证, 台湾通行证, 回乡证, 台胞证, or passport.
- If the route type is unclear, ask the user which document they plan to use.

Use ordinary language for international flights:

"这趟是国际航班，后续下单需要护照信息。现在我先帮你确认实时价格，确认继续预订后再收集证件信息。"

## Passenger Collection

Collect only the missing fields. For each passenger, collect or infer:

- surname and given names
- birthday
- gender
- passenger type: adult, child, or infant, inferred from selected passenger counts when clear; ask only when unclear
- nationality
- travel document type
- travel document number
- document expiry date, if required or provided
- phone
- email

Use natural Chinese text and a numbered Markdown list when asking for passenger information. The important part is the field content: keep the prompt compact and ask for combined fields rather than splitting every internal API field into separate user-facing questions. Do not use bullet lists for this prompt. Do not use fenced code blocks, grey form blocks, raw templates, or generic blank forms. The prompt should look like a human service message, not a data-entry form.

Preferred user-facing collection prompt for a single adult or otherwise clear passenger type:

"要继续生成订单的话，请发我这些信息："

1. 乘机人姓名：姓、名/拼音或英文名
2. 出生日期：YYYY-MM-DD
3. 性别：男/女
4. 国籍：如中国
5. 证件类型和号码：身份证或护照等
6. 手机号和区号：如 +86 138xxxx
7. 邮箱

"收到后我会先把订单信息汇总给你确认，确认后才会创建订单。"

Do not include "乘客类型：成人" in this prompt when the selected itinerary already has one adult or the passenger type is otherwise clear. Ask passenger type only when the passenger mix is unclear, such as child or infant travelers, multiple passengers with different types, or missing shopping context.

Passenger phone and passenger email are required for each passenger. Do not omit them.
Passenger travel document type and travel document number are required for each passenger. Do not omit them.

For domestic mainland China flights, use user-facing labels like:

1. 乘机人姓名：姓、名/拼音或英文名
2. 出生日期：YYYY-MM-DD
3. 性别：男/女
4. 国籍：如中国
5. 证件类型和号码：身份证或护照等
6. 手机号和区号：如 +86 138xxxx
7. 邮箱

For domestic mainland China flights, do not ask only for name, birthday, gender, phone, and email. Always include "证件类型和号码：身份证或护照等" or an equivalent combined document field.

For international flights, use user-facing labels like:

1. 护照英文姓 / surname
2. 护照英文名 / given names
3. 出生日期：YYYY-MM-DD
4. 性别：男/女
5. 国籍：如中国
6. 护照号码和有效期
7. 手机号和区号：如 +86 138xxxx
8. 邮箱

Do not collect only passport number and passport expiry date. Passport data is required for international flights, but the booking still needs the full passenger and contact fields above.

If the user provides a Chinese name, convert it to uppercase pinyin fields when possible. If conversion is uncertain, ask the user to confirm the pinyin.

Contact details are optional:

- contact name, only if the user wants to use a different contact person
- contact phone, only if the user wants to use a different contact phone

Do not ask for contact email. If the user does not provide contact name or contact phone, default contact name to the first passenger's name and default contact phone to that passenger's phone. Mention this default briefly before creating the order.

## Create Order

Before calling `flight_create_order`, repeat in user-friendly language:

- flight and route
- departure and arrival time
- passenger names
- contact information
- final price
- any important notes returned by the tool

Ask:

"确认后我会为你创建订单，但不会自动支付。是否确认创建？"

Only call `flight_create_order` after explicit confirmation.

When calling the tool internally:

- pass the verified `orderKey`
- set confirmation fields required by the tool
- in production, set production confirmation only after the user explicitly confirms the production action

After order creation, call or use `flight_order_detail` to show the current order status when useful.

Use `flight_order_detail` in this skill only for status checks inside the create-order or payment flow. Independent order lookup, after-sales order status questions, cancellations, refunds, changes, and itinerary downloads belong to `simplifly-flight-aftercare`.

## Payment Safety

Never pay automatically.

Before calling `flight_pay_order`, repeat:

- order number
- payment amount
- payment method
- order status if known

Ask for explicit confirmation.

If the amount changed, the order status is unclear, or a previous payment may already be in progress, check `flight_order_detail` before retrying payment.

For third-party payment, do not ask normal users to understand `returnUrl`. Use the configured default when available.

After payment, check or show order status using `flight_order_detail` when useful. Explain that final ticketing status depends on the returned order status.

## Error Handling

- If price verification fails, ask the user to choose another option or search again.
- If order creation fails, explain the failure simply and ask only for the missing or corrected information.
- If payment fails, explain the failure simply and check order status before retrying.
- If authentication, signature, network, or invalid JSON errors occur, say the service is temporarily unavailable or misconfigured. Do not ask the user to repeatedly submit personal information.
