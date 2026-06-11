<!-- markdownlint-disable -->

# Hardening Report: lunarmodules--luacheck/v1.2.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **lunarmodules--luacheck/v1.2.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The action.yml `args:` block directly interpolates `${{ inputs.args }}` into a shell command string (`sh -c luacheck ${{ inputs.args }}`). Any value supplied by a caller for `inputs.args` is substituted into the shell command before the shell parses it, enabling command injection. An attacker controlling this input could execute arbitrary shell commands on the runner.

Locations:

- `action.yml:10`

### unpinned-uses (severity: high)

The `runs.image:` field references `docker://ghcr.io/lunarmodules/luacheck:v1.2.0`, which uses a mutable version tag (`v1.2.0`) instead of an immutable SHA digest. If the tag is moved or the registry is compromised, the action could silently execute a different (potentially malicious) image. It should be pinned to a SHA digest, e.g. `docker://ghcr.io/lunarmodules/luacheck@sha256:<64-hex-char-digest>`.

Locations:

- `action.yml:7`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, script-injection

**Notes:**

Fixed two findings in action.yml: (1) Pinned the Docker image from mutable tag `ghcr.io/lunarmodules/luacheck:v1.2.0` to immutable digest `ghcr.io/lunarmodules/luacheck@sha256:46601a794d24e86dda2a94d957cfba6a451db7c0f4f61f8abe04c4fcd5184e0f # v1.2.0`. (2) Fixed script injection by moving `${{ inputs.args }}` out of the shell command string into a `runs.env` block as `LUACHECK_ARGS`, then referencing it as `$LUACHECK_ARGS` in the shell command — this prevents attacker-controlled input from being interpreted as shell syntax.

