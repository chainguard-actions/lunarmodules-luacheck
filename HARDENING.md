<!-- markdownlint-disable -->

# Hardening Report: lunarmodules--luacheck/v1.2.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **lunarmodules--luacheck/v1.2.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The Docker image reference in action.yml uses a mutable version tag (`v1.2.0`) instead of a SHA digest. This means the image could be silently replaced with a different (potentially malicious) version. It should be pinned to a full SHA256 digest, e.g. `docker://ghcr.io/lunarmodules/luacheck@sha256:<64-hex-char-digest>`.

Failing reference: `image: docker://ghcr.io/lunarmodules/luacheck:v1.2.0`

Locations:

- `action.yml:7`

### script-injection (severity: high)

Sub-rule (a): The `inputs.args` expression is interpolated directly into the Docker entrypoint args as `luacheck ${{ inputs.args }}`, which is passed to `sh -c`. GitHub Actions substitutes the expression value before the shell processes it, so an attacker-controlled `args` input containing shell metacharacters (e.g. `; malicious-command`) can achieve arbitrary command execution inside the container.

Offending line: `- luacheck ${{ inputs.args }}`

Locations:

- `action.yml:12`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, script-injection

**Notes:**

1. Pinned the Docker image from `docker://ghcr.io/lunarmodules/luacheck:v1.2.0` to `docker://ghcr.io/lunarmodules/luacheck:v1.2.0@sha256:46601a794d24e86dda2a94d957cfba6a451db7c0f4f61f8abe04c4fcd5184e0f` (tag preserved inline, docker:// scheme preserved). 2. Fixed script injection by restructuring the sh -c invocation: the shell command string is now the literal `printf '%s' "$1" | xargs luacheck --no-cache`, with `--` as $0 and `${{ inputs.args }}` passed as positional parameter $1 — so the expression value is never interpolated into the command string. xargs safely splits the args string into individual arguments for luacheck, preserving multi-word args functionality without enabling shell injection.

