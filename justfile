#!/usr/bin/env -S just --justfile

# Just list recipes
default:
    @just --list

# Run install
install:
    mkdir -p /etc/netfilter-rules.d /etc/net6filter-rules.d
    cp ./netfilter-rules.conf /etc
    cp ./net6filter-rules.conf /etc
    cp ./netfilter-rules /usr/local/bin
    cp ./net6filter-rules /usr/local/bin

# Run upgrade
upgrade:
    cp ./netfilter-rules /usr/local/bin
    chmod +x /usr/local/bin/netfilter-rules
    cp ./net6filter-rules /usr/local/bin
    chmod +x /usr/local/bin/net6filter-rules
