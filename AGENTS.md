# AGENTS.md

## Overview

Single Bash script (`netfilter-rules`) that flushes and applies iptables/ip6tables rules from sourced config files. No build system, no test suite, no CI. [`just`](https://github.com/casey/just) is the task runner.

- `netfilter-rules` — the whole program (Bash, `set -o errexit`)
- `ipv4.conf`, `ipv6.conf` — example configs, Bash-sourced (plain variables, `extra_rules` array)
- `justfile` — install/upgrade/release recipes
- `cliff.toml` — git-cliff changelog config

## Running / verification

There is no test suite. The only verification is `--dry-run`, which still requires all of:

- root — the user check runs before flag parsing
- `iptables` (or `iptables-nft`) in `PATH` — under `errexit` the script exits if `command -v` fails, so it cannot run on hosts without iptables (e.g. macOS)
- config present at `/etc/netfilter-rules/<ipv4|ipv6>.conf`

```shell
sudo ./netfilter-rules ipv4 apply --dry-run
sudo ./netfilter-rules ipv6 apply --verbose
sudo ./netfilter-rules ipv4 status
```

The script sources its config from `/etc/netfilter-rules/`, never from the repo files. After editing `ipv4.conf`/`ipv6.conf`, run `just install` (root) or copy them manually before testing. `just upgrade` copies only the script, not the configs.

The installed `netfilter-rules-nft` symlink (created by `just install`) makes the script use `iptables-nft`/`ip6tables-nft` instead of legacy binaries; the backend is chosen at runtime from `basename $0`.

## Config syntax

- `tcpint`/`udpint` entries are `interface+port[+port...]`; space-separated for multiple interfaces: `tcpint="net0+22 net1+80+443"`
- `extra_rules` is a Bash array of raw iptables argument strings
- `gateway="True"` enables NAT/FORWARD; for IPv4 it always adds MASQUERADE, for IPv6 only when `masquerade="True"` (variable exists only in `ipv6.conf`)

## Releases

Conventional Commits are required (git-cliff parses them). Scope is the touched area, e.g. `feat(main): [netfilter-rules] add --dry-run flag`.

```shell
just gen-tag          # print next bumped version
just gen-rel 4.3.0    # regenerate CHANGELOG, signed commit (-s -S), signed annotated tag
```

`gen-rel` creates signed commits and signed tags — requires working commit signing and `git-cliff`.

Justfile: `require("git")` / `require("git-cliff")` are called inline at command positions in the release recipes only, and return the binary path (used as the command). Do not move them to top-level assignments — justfile assignments are evaluated at load time, which would make every recipe (even `just install`) fail on hosts without git.
