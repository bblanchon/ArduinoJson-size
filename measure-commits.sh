#!/bin/bash

set -eu

BOARD=${1:-arduino:avr:uno}
OUTPUT="${BOARD//:/_}.csv"
REPOSITORY="$(pwd)/libraries/ArduinoJson"

EXAMPLES=(
	JsonParserExample
	JsonGeneratorExample
	MsgPackParser
	StringExample
	ProgmemExample
)

[ -e "$OUTPUT" ] ||	(
		echo -n "Commit,Date,ReferenceObjectSize"
		for EXAMPLE in "${EXAMPLES[@]}"; do
			echo -n "$EXAMPLE,"
		done
		echo
	) | tee "$OUTPUT"
while git -C "$REPOSITORY" checkout -q HEAD~1
do
	./measure-head.sh "$BOARD" | tee -a "$OUTPUT"
done
