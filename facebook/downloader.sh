#!/bin/bash

# https://www.workplace.com/resources/tech/it-configuration/domain-whitelisting
# https://www.irr.net/docs/list.html
# https://bgp.he.net/search?search%5Bsearch%5D=facebook&commit=Search

set -euo pipefail
set -x


# get from Autonomous System
get_routes() {
    whois -h riswhois.ripe.net -- "-i origin $1" | grep '^route' | awk '{ print $2; }'
    whois -h whois.radb.net -- "-i origin $1" | grep '^route' | awk '{ print $2; }'
    whois -h rr.ntt.net -- "-i origin $1" | grep '^route' | awk '{ print $2; }'
    whois -h whois.rogerstelecom.net -- "-i origin $1" | grep '^route' | awk '{ print $2; }'
    whois -h whois.bgp.net.br -- "-i origin $1" | grep '^route' | awk '{ print $2; }'
}

get_routes 'AS32934' > /tmp/facebook.txt
get_routes 'AS63293' >> /tmp/facebook.txt


# save ipv4
grep -v ':' /tmp/facebook.txt > /tmp/facebook-ipv4.txt

# save ipv6
grep ':' /tmp/facebook.txt > /tmp/facebook-ipv6.txt


# sort & uniq
sort -h /tmp/facebook-ipv4.txt | uniq > facebook/ipv4.txt
sort -h /tmp/facebook-ipv6.txt | uniq > facebook/ipv6.txt