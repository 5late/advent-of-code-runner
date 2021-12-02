#!/usr/bin/env bash
set -uo pipefail
D=$(dirname $(realpath $0))

SOLUTION=$1
IO_FILES=$2

COMPILETIME=$($D/rust_build.sh $SOLUTION)
START=$($D/util/start.sh)

while read INPUT OUTPUT; do
    CURRENT=$($D/util/start.sh)

    cat $INPUT | timeout --signal=SIGKILL 20s $SOLUTION/target/release/out $INPUT | diff --strip-trailing-cr $OUTPUT - >/dev/null
    if [ $? -ne 0 ]; then
        $D/util/error.sh "Rust" "$SOLUTION/Cargo.toml" "$INPUT" "$($D/util/stop.sh $CURRENT)" "$COMPILETIME"
        exit
    fi

    TIMES+=($($D/util/stop.sh $CURRENT))
done < <(echo $IO_FILES | xargs -n2)

TOTAL=$($D/util/stop.sh $START)

$D/util/success.sh "Rust" "$TOTAL" "$SOLUTION/Cargo.toml" "$TIMES" "$COMPILETIME"