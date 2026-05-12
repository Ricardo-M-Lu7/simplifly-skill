# Contributing

Thanks for improving Simplifly Skill. This repository contains Codex skill instructions, so changes should be reviewed as user-facing behavior and safety policy, not only as text edits.

## Before You Start

- Read the affected `SKILL.md` from top to bottom.
- Check whether your change belongs in a workflow skill or in `simplifly-agent-integration`.
- Use mock examples only. Do not add real user data, real orders, real credentials, or production logs.

## Skill Boundaries

- `simplifly-flight-shopping`: search, comparison, recommendation, and visible `F1`-`F5` option labels.
- `simplifly-flight-booking`: price verification, passenger collection, order creation, and payment confirmation.
- `simplifly-flight-aftercare`: order lookup, itinerary download, cancellation, refund, and change workflows.
- `simplifly-agent-integration`: global Simplifly MCP safety, privacy, hidden-field, confirmation, raw-JSON, and signing policy.

Do not duplicate detailed workflow rules across unrelated skills unless the duplication is intentional and keeps agents safe when only one skill is loaded.

## Pull Request Checklist

Before opening a pull request, verify:

- No real credentials, private keys, signatures, personal data, order data, or production logs are included.
- Normal consumer-facing output remains Simplified Chinese by default.
- Internal fields such as `solutionId`, `orderKey`, confirmation flags, raw passenger IDs, segment IDs, and raw MCP JSON remain hidden from normal users.
- State-changing tools still require explicit confirmation immediately before use.
- Passenger documents, birthdays, phone numbers, and emails are not collected during flight search.
- Missing tool-returned details are described as not returned instead of invented.
- Examples use mock data only and do not imply that price verification locks or holds seats unless the tool explicitly says so.

## Style

- Keep instructions direct and testable.
- Prefer concrete user-facing examples when a rule affects wording.
- Avoid raw JSON examples unless the change is specifically for technical integration policy.
- Keep file names, tool names, and MCP field names in English.
- Keep normal user-facing copy in Simplified Chinese.

## Testing Changes

There is no automated test suite yet. Review changes manually by checking:

- The relevant workflow from user intent to next action.
- Hidden-field handling.
- Confirmation wording before state-changing tools.
- Passenger data timing and required fields.
- Error handling for missing, failed, or incomplete tool results.
