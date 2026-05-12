# Simplifly Skill

Simplifly Skill is a set of Codex skill instructions for agents that work with Simplifly flight MCP tools. The skills define consumer-facing flight shopping, booking, payment safety, order aftercare, and shared integration policy.

The project is prompt and policy content, not a standalone flight API client. It assumes a Simplifly MCP server is connected by the host agent.

## What Is Included

| Skill | Purpose |
|---|---|
| `simplifly-flight-shopping` | Search, compare, recommend, and label flight options as `F1`-`F5`. |
| `simplifly-flight-booking` | Verify selected prices, collect passenger details, create orders, and handle payment confirmation. |
| `simplifly-flight-aftercare` | Check orders, download itineraries, cancel unpaid orders, request refunds, and change flights. |
| `simplifly-agent-integration` | Shared Simplifly MCP safety, privacy, confirmation, hidden-field, and signing rules. |

## Requirements

- A Codex-compatible skills runtime.
- A Simplifly MCP server exposing the flight tools referenced by the skill files.
- For local signed Simplifly requests, `shasum` and a POSIX-compatible shell.

The skills intentionally do not include API credentials, private endpoints, or live passenger data.

## Installation

Copy or symlink the skill directories into your Codex skills directory.

```bash
: "${CODEX_HOME:?Set CODEX_HOME to your Codex configuration directory first}"
mkdir -p "$CODEX_HOME/skills"
cp -R skills/simplifly-* "$CODEX_HOME/skills/"
```

If you use the default local Codex directory, you can set `CODEX_HOME="$HOME/.codex"` first, then run the commands above.

## Usage

After installation, invoke the relevant skill from an agent task:

- Use `simplifly-flight-shopping` when the user wants to search, compare, filter, or choose flights.
- Use `simplifly-flight-booking` after the user selects an option and wants to verify price, continue booking, create an order, or pay.
- Use `simplifly-flight-aftercare` for order status, cancellation, itinerary, refund, or change workflows.
- Use `simplifly-agent-integration` for technical integration policy and global Simplifly MCP safety rules.

The workflow skills are designed to keep internal MCP fields hidden from normal users and to require explicit confirmation before every state-changing operation.

## Local Signing Helper

`skills/simplifly-agent-integration/scripts/local_sign.sh` generates a timestamp and SHA1 signature for local testing.

```bash
SIMPLIFLY_CODE="your-code" SIMPLIFLY_API_KEY="your-api-key" \
  skills/simplifly-agent-integration/scripts/local_sign.sh
```

Do not commit real `SIMPLIFLY_CODE`, `SIMPLIFLY_API_KEY`, signatures, access tokens, order payloads, passenger documents, or logs containing personal information.

## Safety Principles

- Never expose internal fields such as `solutionId`, `orderKey`, confirmation flags, raw passenger IDs, segment IDs, or raw MCP JSON to normal users.
- Never create an order, pay, cancel, refund, confirm a refund, or submit a change request without explicit user confirmation.
- Collect passport, ID card, birthday, phone, and email only at the correct booking stage.
- If baggage, refund, change, ticketing, or policy details are not returned by tools, say they were not returned instead of inventing them.
- Keep normal consumer responses in Simplified Chinese unless the user asks for another language.

## Repository Layout

```text
skills/
  simplifly-agent-integration/
    SKILL.md
    scripts/local_sign.sh
  simplifly-flight-aftercare/
    SKILL.md
  simplifly-flight-booking/
    SKILL.md
  simplifly-flight-shopping/
    SKILL.md
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request. Security-sensitive reports should follow [SECURITY.md](SECURITY.md).

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
