#include <ESP8266WiFi.h>
#include <espnow.h>

#define LED D8

//MASTER CODE

WiFiServer wifiServer(80);

const char* ssid = "iPhone (60)"; 
const char* password = "12345678";

uint8_t broadcastAddress[] = {0xBC, 0xFF, 0x4D, 0x5F, 0x8D, 0x7A};

void onDataSent(uint8_t *mac_addr, uint8_t sendStatus) {
  Serial.println("Last Packet Send Status: "); {
    if (sendStatus == 0) {
      Serial.println("Delivery Success");
    }
    else {
      Serial.println("Delivery Fail");
    }
  }
}


void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting..");
  }   
  pinMode(D8, OUTPUT);
  Serial.print("Connected to arduino: ");
  Serial.println(WiFi.macAddress());
  WiFi.mode(WIFI_STA); //sets device as wifi station
  if (esp_now_init() != 0) { //initalises esp-now, which allows callback functions
    Serial.println("Error initalising");
    return;
  }
  esp_now_set_self_role(ESP_NOW_ROLE_CONTROLLER); //this accepts controller or slave
  esp_now_register_send_cb(onDataSent);
  //add peer takes mac address, role, wifi channel, key and key length 
  if (esp_now_add_peer(broadcastAddress, ESP_NOW_ROLE_SLAVE, 1, NULL, 0) != 0) {
    Serial.println("Couldn't add peer");
    return;
  }
}

void loop() {
  String directions[8] = {"left", "right", "straight", "left", "left", "right", "right", "straight"};
  int delays[8] = {1500, 3000, 5000, 1500, 10000, 1000, 3000, 1000};
  // instead of hard coding these in, we'd get a serial signal from our flutter app
  int vibeswitch = 1;
   for (int i=0; i<9; i++) {
      if (directions[i] == "left") {
        digitalWrite(LED, HIGH);
        delay(1000);
        digitalWrite(LED, LOW);
        delay(delays[i]);
      } else if (directions[i] == "right") {
        esp_now_send(broadcastAddress, (uint8_t *) &vibeswitch , sizeof(float));
        delay(delays[i]);
      } else { //if straight
        digitalWrite(LED, HIGH);
        esp_now_send(broadcastAddress, (uint8_t *) &vibeswitch , sizeof(float));
        delay(1000);
        digitalWrite(LED, LOW);
        delay(delays[i]);
      }
      
   }
   exit(0);
}


