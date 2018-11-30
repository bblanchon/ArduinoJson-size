#!/bin/bash

set -eu

BOARD=${1:-arduino:avr:uno}
OUTPUT="${BOARD//:/_}.csv"
REPOSITORY="$(pwd)/libraries/ArduinoJson"

[ -e "$OUTPUT" ] || echo "Commit,Date,JsonParserExample,JsonGeneratorExample,ReferenceObjectSize" | tee "$OUTPUT"

git -C "$REPOSITORY" tag | sort --version-sort --reverse | while read -r TAG
do
	git -C "$REPOSITORY" checkout -q "$TAG"
	./measure-head.sh "$BOARD" | tee -a "$OUTPUT"
done