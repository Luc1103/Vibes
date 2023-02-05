#include <ESP8266WiFi.h>
#include <espnow.h>

//MASTER CODE

WiFiServer wifiServer(80);

const char* ssid = "Iphone (9)"; 
const char* password = "soManyVibes";

//const char* ssid = "Pixel_9729"; 
//const char* password = "88888888";

uint8_t broadcastAddress[] = {0xBC, 0xFF, 0x4D, 0x5F, 0x8D, 0x7A};

typedef struct struct_message {
  bool switch;
}

struct_message message;

void onDataSent(uint8_t *mac_addr, uint8_t sendStatus) {
  Serial.print("Last Packet Send Status: ") {
    if (sendStatus == 0) {
      Serial.println("Delivery Success");
    }
    else {
      Serial.println("Delivery Fail");
    }
  }
}

#define LED D7

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting..");
  } 
  Serial.print("Connected to WiFi. IP: ");
  Serial.println(WiFi.localIP());
  Wifi.mode(WIFI_STA); //sets device as wifi station
  if (esp_now_init() != 0) { //initalises esp-now, which allows callback functions
    Serial.println("Error initalising");
    return;
  }
  esp_now_set_self_role(ESP_NOW_ROLE_CONTROLLER); //this accepts controller or slave
  esp_now_register_send_cb(OnDataSent);
  //add peer takes mac address, role, wifi channel, key and key length 
  esp_now_add_peer(broadcastAddress, ESP_NOW_ROLE_SLAVE, 1, NULL, 0);
  pinMode(LED, OUTPUT);
}

void loop() {
  // this is where we'd write the code that depends
  // on who's turn it is to buzz and delays accordingly. 
  message.switch = true;
  esp_now_send(broadcastAddress, (uint8_t *) &message, sizeof(message));

  // WiFiClient client = wifiServer.available();
  // if (client) {
  //   while (client.connected() ) {
  //     while (client.available() > 0) {
  //       char c = client.read();
  //       Serial.write(c);
  //     }
  //     delay(10);
  //   }
  //   client.stop();
  //   Serial.println("Client disconnected.");
  // }
  digitalWrite(LED, HIGH);
  delay(1000);
  digitalWrite(LED, LOW);
  delay(1000);
}
