#!/usr/bin/env -S just --justfile

git_bin := require("git")
git_cliff_bin := "git-cliff"

# Just list recipes
default:
    @just --list

# Run install
install:
    mkdir -p /etc/netfilter-rules
    cp ./ipv4.conf /etc/netfilter-rules
    cp ./ipv6.conf /etc/netfilter-rules
    cp ./netfilter-rules /usr/local/bin
    ln -srf /usr/local/bin/netfilter-rules /usr/local/bin/netfilter-rules-nft

# Run upgrade
upgrade:
    cp ./netfilter-rules /usr/local/bin
    chmod +x /usr/local/bin/netfilter-rules

# Run upgrade from 4.0 to 4.1
upgrade-from-40-to-41: upgrade
    mkdir -p /etc/netfilter-rules
    mv /etc/netfilter-rules.conf /etc/netfilter-rules/ipv4.conf
    mv /etc/net6filter-rules.conf /etc/netfilter-rules/ipv6.conf

# Auto generate the next release
auto-gen-rel:
    #!/usr/bin/env sh
    _TAG=$({{ git_cliff_bin }} --bumped-version)
    {{ git_cliff_bin }} --unreleased --tag ${_TAG} -o
    {{ git_bin }} commit -a -s -S -m "chore(release): prepare for ${_TAG}"
    {{ git_bin }} tag -s ${_TAG} -m "${_TAG}"

# Generate the next release with tag
gen-rel tag:
    {{ git_cliff_bin }} --unreleased --tag {{ tag }} -o
    {{ git_bin }} commit -a -s -S -m "chore(release): prepare for {{ tag }}"
    {{ git_bin }} tag -s {{ tag }} -m "{{ tag }}"

# Generate the next tag
gen-tag:
    @{{ git_cliff_bin }} --bumped-version
