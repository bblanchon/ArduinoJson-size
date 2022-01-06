#include <ArduinoJson.h>

template <int N>
void SHOW_IN_ERRORS();

void setup() {
  SHOW_IN_ERRORS<JSON_ARRAY_SIZE(2) + JSON_OBJECT_SIZE(3)>();
}

void loop() {}
