# Security Policy

## Reporting a Vulnerability

Please do not report security vulnerabilities in public issues.

Use GitHub private vulnerability reporting if it is enabled for this
repository.

If private vulnerability reporting is not available, open a public issue that
asks the maintainers for a private contact method. Do not include vulnerability
details, proof-of-concept steps, logs, secrets, affected-account information, or
other sensitive details in that public issue.

## Automation Policy

- Public pull requests do not receive secrets.
- External pull request code is not run on self-hosted runners.
- Automation starts in label/comment/report-only mode.
- Issue closing and pull request merging require maintainer approval unless a
  narrow policy explicitly allows it.
