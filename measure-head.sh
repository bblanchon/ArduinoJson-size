#!/bin/bash

set -eu

cd "$(dirname "$0")"

PATH="$PATH:/c/Program Files/Arduino CLI/"
REPOSITORY="$(pwd)/libraries/ArduinoJson"
EXAMPLES_DIR="$REPOSITORY/examples"

BOARD=${1:-arduino:avr:uno}

EXAMPLES=(
	JsonParserExample
	JsonGeneratorExample
	MsgPackParser
	StringExample
	ProgmemExample
)

compile() {(
  arduino-cli compile --libraries "$REPOSITORY" -b "$BOARD" "$1"
)}

measure_code() {(
  compile "$1" 2>&1  | grep -e 'Sketch uses' | sed -E 's/.*uses ([0-9]*),?([0-9]+).*/\1\2/'
)}

get_constant() {(
  compile "$1" 2>&1 | sed -n -E 's/.*SHOW_IN_ERRORS<(.*)>.*/\1/p;s/.*_Z14SHOW_IN_ERRORSILi([0-9]+)EEvv.*/\1/p' | head -n1 | tr -d '\n'
)}

echo -n "$(git -C "$REPOSITORY" describe),"
echo -n "$(git -C "$REPOSITORY" log -1 --date=short --pretty=format:%cd),"
get_constant "$(pwd)/ReferenceObjectSize/ReferenceObjectSize.ino"
for EXAMPLE in "${EXAMPLES[@]}"; do
  echo -n ",$(measure_code "$EXAMPLES_DIR/$EXAMPLE/$EXAMPLE.ino")"
done
echo
