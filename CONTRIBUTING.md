# Contributing

Thanks for helping improve this project.

## Before Opening an Issue

- Search existing issues first.
- Use the issue template.
- Include reproduction steps for bugs.
- Include expected and actual behavior.
- Include version, operating system, logs, and screenshots when relevant.

## Pull Requests

Small, focused pull requests are much easier to review.

Please include:

- A clear summary.
- A linked issue when possible.
- Tests for behavior changes.
- Screenshots or recordings for UI changes.
- Notes about risk, migrations, or breaking changes.

## High-Risk Changes

Changes touching these areas require maintainer review:

- `.github/workflows/**`
- release or publish scripts
- authentication or authorization
- dependency install scripts
- package manager lockfiles
- generated/minified/binary/vendor files
- security-sensitive code

## External Pull Requests

External pull requests are treated as untrusted until reviewed. CI may run with
read-only permissions and without secrets.
