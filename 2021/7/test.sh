#!/usr/bin/env bash
set -euo pipefail

D=$(dirname $(realpath $0))

echo "-- Day 7 --"
printf "%-10s %-15s %-10s %-10s %-10s %-10s \n" "language" "author" "compile" "total" "average" "status"
#$D/../../lang/python3.sh        "$D/solutions/python/slate/d7.py"           "$D/io/*"
$D/../../lang/node.sh           "$D/solutions/node/stelar7/main.mjs"        "$D/io/*"
$D/../../lang/cargo_rust.sh     "$D/solutions/rust/mingweisamuel"           "$D/io/*"


echo ""
