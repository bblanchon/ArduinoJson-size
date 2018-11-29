#!/bin/bash

set -eu

BOARD=${1:-arduino:avr:uno}
OUTPUT="${BOARD//:/_}.csv"
REPOSITORY="$(pwd)/libraries/ArduinoJson"

[ -e "$OUTPUT" ] || "Commit,Date,JsonParserExample,JsonGeneratorExample,ReferenceObjectSize" | tee "$OUTPUT"

./measure-head.sh | tee -a "$OUTPUT"
while git -C "$REPOSITORY" checkout -q HEAD~1
do
	./measure-head.sh | tee -a "$OUTPUT"
done
