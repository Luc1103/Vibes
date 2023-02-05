#include <ESP8266WiFi.h>
#include <espnow.h>
#define LED D8

//RECEIVER CODE

WiFiServer wifiServer(80);

const char* ssid = "iPhone (60)"; 
const char* password = "12345678";

void OnDataRecv(uint8_t * mac, uint8_t *incomingData, uint8_t len) {
  //idk if we wanna check to bool value here
  digitalWrite(LED, HIGH);
  delay(1000);
  digitalWrite(LED, LOW);
}

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting..");
  } 
  pinMode(D8, OUTPUT);
  Serial.print("Connected to WiFi. IP: ");
  Serial.println(WiFi.localIP());
  WiFi.mode(WIFI_STA); //sets device as wifi station
  if (esp_now_init() != 0) { //initalises esp-now, which allows callback functions
    Serial.println("Error initalising");
    return;
  }
  esp_now_set_self_role(ESP_NOW_ROLE_SLAVE);
  esp_now_register_recv_cb(OnDataRecv);
}

void loop() {

}
