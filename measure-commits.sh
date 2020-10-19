#!/bin/bash

set -eu

BOARD=${1:-arduino:avr:uno}
OUTPUT="${BOARD//:/_}.csv"
REPOSITORY="$(pwd)/libraries/ArduinoJson"

[ -e "$OUTPUT" ] || echo "Commit,Date,JsonParserExample,JsonGeneratorExample,MsgPackParser,ReferenceObjectSize" | tee "$OUTPUT"

./measure-head.sh "$BOARD" | tee -a "$OUTPUT"
while git -C "$REPOSITORY" checkout -q HEAD~1
do
	./measure-head.sh "$BOARD" | tee -a "$OUTPUT"
done
