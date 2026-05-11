---
name: simplifly-flight-booking
description: Use this skill when a user has selected a Simplifly flight option and wants to verify price, continue booking, provide passenger details, create an order, or pay. It covers price verification, document requirements, passenger collection, order creation, and payment safety. Always collect complete passenger information, including each passenger's phone, email, travel document type, and travel document number. For mainland China domestic flights, explicitly ask for Chinese resident ID card information when applicable, including ID card number. Contact name and contact phone are optional; if omitted, default them to the first passenger's name and phone. Do not collect contact email. For international flights, always explicitly tell the user that passport information is required and ask for complete passenger information including passport number and passport expiry date, not only passport fields or generic document number. When collecting passenger information, use natural Chinese text plus Markdown bullet lists; do not use code blocks, copyable form blocks, or generic blank forms. When showing flight details, use city/airport names plus airport codes and terminals; do not show only IATA codes. Use this skill even if Simplifly MCP prompts are not loaded.
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

If verification fails, briefly explain that the option could not be confirmed and suggest choosing another option or searching again.

## Passenger Document Rules

Do not collect document information during flight search.

After the user selects a flight and price is verified, remind the user which document is needed before collecting passenger details.

- For international flights, explicitly say: "这趟是国际航班，下单需要护照信息。请确保护照姓名拼音、护照号和有效期准确。"
- For international flights, ask for `passport` as the travel document type, passport number, and passport expiry date. Do not use vague labels like "证件号码" without saying "护照号码".
- For domestic mainland China flights, explicitly say: "这趟是国内航班，下单需要乘机人身份证信息。"
- For domestic mainland China flights, ask for `idcard` as the travel document type when the passenger uses a Chinese resident ID card, and ask for ID card number. Do not omit document type or ID card number.
- For Hong Kong, Macau, and Taiwan routes, do not assume a mainland ID card is sufficient. Ask which valid travel document the passenger will use, such as 港澳通行证, 台湾通行证, 回乡证, 台胞证, or passport.
- If the route type is unclear, ask the user which document they plan to use.

Use ordinary language:

"这趟是国际航班，后续下单需要护照信息。现在我先帮你确认实时价格，确认继续预订后再收集证件信息。"

## Passenger Collection

Collect only the missing fields. For each passenger, collect:

- surname and given names
- birthday
- gender
- passenger type: adult, child, or infant
- nationality
- travel document type
- travel document number
- document expiry date, if required or provided
- phone
- email

Use natural Chinese text and Markdown bullet lists when asking for passenger information. Do not use fenced code blocks, grey form blocks, raw templates, or generic blank forms. The prompt should look like a human service message, not a data-entry form.

Preferred style:

"这趟是国内航班，后续需要乘机人身份证信息。请把下面信息发我，我再帮你创建订单，但不会自动支付："

- 乘机人姓名
- 出生日期
- 性别
- 乘客类型：成人/儿童/婴儿
- 国籍
- 证件类型：中国居民身份证或其他
- 身份证号码
- 乘机人手机号
- 乘机人邮箱

Passenger phone and passenger email are required for each passenger. Do not omit them.
Passenger travel document type and travel document number are required for each passenger. Do not omit them.

For domestic mainland China flights, use user-facing labels like:

- 乘机人姓名
- 出生日期
- 性别
- 乘客类型
- 国籍
- 证件类型（中国居民身份证 / 其他）
- 身份证号码
- 乘机人手机号
- 乘机人邮箱

For domestic mainland China flights, do not ask only for name, birthday, gender, phone, and email. Always include ID card number or ask which valid travel document the passenger will use.

For international flights, use user-facing labels like:

- 护照英文姓 / surname
- 护照英文名 / given names
- 出生日期
- 性别
- 乘客类型
- 国籍
- 护照号码
- 护照有效期
- 乘机人手机号
- 乘机人邮箱

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
