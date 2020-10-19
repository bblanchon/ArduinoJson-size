#!/bin/bash

set -eu

cd "$(dirname "$0")"

PATH="$PATH:/c/Program Files (x86)/Arduino/"
BOARD=${1:-arduino:avr:uno}
REPOSITORY="$(pwd)/libraries/ArduinoJson"
SKETCHBOOK="$(pwd)"
EXAMPLES="$REPOSITORY/examples"

compile() {(
  cd "$(dirname "$1")"
  arduino --verify --board "$BOARD" --pref "sketchbook.path=$SKETCHBOOK" "$(basename "$1")"
)}

measure_code() {(
  compile "$1" 2>/dev/null | grep -e 'Sketch uses' | sed -E 's/.*uses ([0-9]*),?([0-9]+).*/\1\2/'
)}

get_constant() {(
  compile "$1" 2>&1 | sed -n -E 's/.*SHOW_IN_ERRORS<(.*)>.*/\1/p' | head -n1
)}

echo -n "$(git -C "$REPOSITORY" describe),"
echo -n "$(git -C "$REPOSITORY" log -1 --date=short --pretty=format:%cd),"
echo -n "$(measure_code "$EXAMPLES/JsonParserExample/JsonParserExample.ino"),"
echo -n "$(measure_code "$EXAMPLES/JsonGeneratorExample/JsonGeneratorExample.ino"),"
echo -n "$(measure_code "$EXAMPLES/MsgPackParser/MsgPackParser.ino"),"
get_constant "ReferenceObjectSize.ino"
