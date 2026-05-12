# Security Policy

Simplifly Skill contains agent instructions for flight search, booking, payment, refund, change, and order workflows. Please treat changes as security-sensitive when they affect personal data, payment flow, hidden MCP fields, confirmation requirements, signing, or raw API output.

## Do Not Commit

Never commit:

- Real `SIMPLIFLY_CODE`, `SIMPLIFLY_API_KEY`, access tokens, private keys, signatures, cookies, or session data.
- Passenger names, birthdays, ID card numbers, passport numbers, phone numbers, emails, order payloads, ticket numbers, or itinerary files from real users.
- Raw MCP responses that contain hidden fields or personal information.
- Production logs or screenshots that contain credentials or personal data.

## Reporting a Vulnerability

If you find a vulnerability, please do not open a public issue with exploit details or live personal data.

Report privately through GitHub private vulnerability reporting if it is enabled for this repository. If it is not enabled, open a minimal public issue asking for a security contact without disclosing sensitive details. Include:

- A short summary of the issue.
- The affected skill or script path.
- Steps to reproduce using mock data only.
- The expected safe behavior.
- Any suggested fix.

## Security Expectations

Contributions should preserve these rules:

- State-changing MCP tools require explicit user confirmation before every call.
- Internal fields such as `solutionId`, `orderKey`, confirmation flags, raw passenger IDs, segment IDs, and raw MCP JSON stay hidden from normal users.
- Passenger and document data is collected only after the user chooses a flight, price is verified, and the user wants to continue booking.
- Missing tool-returned baggage, refund, change, ticketing, or policy details are reported as missing, not invented.
- Authentication, signing, network, and service configuration errors are summarized without exposing stack traces, tokens, signatures, or raw error payloads.

## Supported Versions

This project is small and currently supports only the latest version on the main development branch.
