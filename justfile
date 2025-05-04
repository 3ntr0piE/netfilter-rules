#!/usr/bin/env -S just --justfile

git_bin := require("git")
git_cliff_bin := require("git-cliff")

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

# Generate the next release with tag
gen-rel tag:
    {{ git_cliff_bin }} --unreleased --tag {{ tag }} -o
    {{ git_bin }} commit -a -s -S -m "chore(release): prepare for {{ tag }}"
    {{ git_bin }} tag -s {{ tag }} -m "{{ tag }}"
