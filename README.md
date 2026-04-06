# netfilter-rules

[![License](https://img.shields.io/badge/License-Apache-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)

Easy way to configure iptables and ip6tables ...

# Requirements

* `ip{,6}tables{,-nft}`
* [just](https://github.com/casey/just) a command runner (only for installation and upgrade)

## Installation

```shell
git clone https://github.com/3ntr0piE/netfilter-rules.git
cd netfilter-rules
just install
```

## Usage

Update the files (/etc/netfiler-rules/ipv{4,6}.conf) according to your needs and run the commands.

```shell
netfilter-rules ipv(4|6) apply [--dry-run] [--verbose]
netfilter-rules ipv(4|6) flush [--dry-run] [--verbose]
netfilter-rules ipv(4|6) status
```

### Example

Apply the rules defined in the configuration files :

```shell
netfilter-rules ipv6 apply --dry-run
```

```shell
[dry-run] /usr/bin/ip6tables -P INPUT ACCEPT
[dry-run] /usr/bin/ip6tables -P OUTPUT ACCEPT
[dry-run] /usr/bin/ip6tables -P FORWARD ACCEPT
[dry-run] /usr/bin/ip6tables -F INPUT
[dry-run] /usr/bin/ip6tables -F OUTPUT
[dry-run] /usr/bin/ip6tables -F FORWARD
[dry-run] /usr/bin/ip6tables -F PREROUTING -t nat
[dry-run] /usr/bin/ip6tables -F PREROUTING -t mangle
[dry-run] /usr/bin/ip6tables -F POSTROUTING -t nat
[dry-run] /usr/bin/ip6tables -F POSTROUTING -t mangle
[dry-run] /usr/bin/ip6tables -F LOGDENY -t filter
[dry-run] /usr/bin/ip6tables -X LOGDENY -t filter
[dry-run] /usr/bin/ip6tables -t filter -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
[dry-run] /usr/bin/ip6tables -A INPUT -p ipv6-icmp -i net0 -j ACCEPT
[dry-run] /usr/bin/ip6tables -t filter -A INPUT -i lo -j ACCEPT
[dry-run] /usr/bin/ip6tables -t filter -A INPUT -i net0 -p TCP --dport 22 -j ACCEPT
[dry-run] /usr/bin/ip6tables -A INPUT -p TCP -j REJECT --reject-with tcp-reset
[dry-run] /usr/bin/ip6tables -A INPUT -p UDP -j REJECT --reject-with icmp6-port-unreachable
[dry-run] /usr/bin/ip6tables -A INPUT -p ipv6-icmp -j REJECT --reject-with icmp6-adm-prohibited
[dry-run] /usr/bin/ip6tables -A INPUT -j REJECT
```

```shell
netfilter-rules ipv6 apply
```

Flush the rules applied :

```shell
netfilter-rules ipv6 flush
```

## Upgrade

```shell
just upgrade
```

Maintainer: babykart
