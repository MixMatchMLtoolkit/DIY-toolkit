/**
   --------------------------------------------------------------------------------------------------------------------
   Example sketch/program showing how to read data from more than one PICC to serial.
   --------------------------------------------------------------------------------------------------------------------
   This is a MFRC522 library example; for further details and other examples see: https://github.com/miguelbalboa/rfid

   Example sketch/program showing how to read data from more than one PICC (that is: a RFID Tag or Card) using a
   MFRC522 based RFID Reader on the Arduino SPI interface.

   Warning: This may not work! Multiple devices at one SPI are difficult and cause many trouble!! Engineering skill
            and knowledge are required!

   @license Released into the public domain.

   Typical pin layout used:
   -----------------------------------------------------------------------------------------
               MFRC522      Arduino       Arduino   Arduino    Arduino          Arduino
               Reader/PCD   Uno/101       Mega      Nano v3    Leonardo/Micro   Pro Micro
   Signal      Pin          Pin           Pin       Pin        Pin              Pin
   -----------------------------------------------------------------------------------------
   RST/Reset   RST          9             5         D9         RESET/ICSP-5     RST
   SPI SS 1    SDA(SS)      ** custom, take a unused pin, only HIGH/LOW required *
   SPI SS 2    SDA(SS)      ** custom, take a unused pin, only HIGH/LOW required *
   SPI MOSI    MOSI         11 / ICSP-4   51        D11        ICSP-4           16
   SPI MISO    MISO         12 / ICSP-1   50        D12        ICSP-1           14
   SPI SCK     SCK          13 / ICSP-3   52        D13        ICSP-3           15

   More pin layouts for other boards can be found here: https://github.com/miguelbalboa/rfid#pin-layout

    Video: https://www.youtube.com/watch?v=oCMOYS71NIU
    Based on Neil Kolban example for IDF: https://github.com/nkolban/esp32-snippets/blob/master/cpp_utils/tests/BLE%20Tests/SampleNotify.cpp
    Ported to Arduino ESP32 by Evandro Copercini
    updated by chegewara

   Create a BLE server that, once we receive a connection, will send periodic notifications.
   The service advertises itself as: 4fafc201-1fb5-459e-8fcc-c5c9c331914b
   And has a characteristic of: beb5483e-36e1-4688-b7f5-ea07361b26a8

   The design of creating the BLE server is:
   1. Create a BLE Server
   2. Create a BLE Service
   3. Create a BLE Characteristic on the Service
   4. Create a BLE Descriptor on the characteristic
   5. Start the service.
   6. Start advertising.

   A connect hander associated with the server starts a background task that performs notification
   every couple of seconds.


  Deep Sleep with External Wake Up
  =====================================
  This code displays how to use deep sleep with
  an external trigger as a wake up source and how
  to store data in RTC memory to use it over reboots

  This code is under Public Domain License.

  Hardware Connections
  ======================
  Push Button to GPIO 33 pulled down with a 10K Ohm
  resistor

  NOTE:
  ======
  Only RTC IO can be used as a source for external wake
  source. They are pins: 0,2,4,12-15,25-27,32-39.

  Author:
  Pranav Cherukupalli <cherukupallip@gmail.com>

*/
//Setup for RFID readers
#include <SPI.h>
#include <MFRC522.h>

#define RST_PIN         34          // Configurable, see typical pin layout above
#define SS_1_PIN        21         // the SS pins should be an SDA or SCO pin on the ESP wrover, these are pins 21,5,15
#define SS_2_PIN        15


#define NR_OF_READERS   2

String deviceName= "Mix Match ML toolkit";

byte ssPins[] = {SS_1_PIN, SS_2_PIN};

RTC_DATA_ATTR int bootCount = 0;

int button = GPIO_NUM_32; //button to turn esp in deepsleep
int onoff;
int hallSensor=4;
int hallValue;
int mode=0; //0 normal, 1 compare

// Init array that will store new NUID from all three readers
int reader1[4];
int reader2[4];


int combinedReader[2]; // combine all readings, take either only one value or increase to 12 to use all values
bool checkEmpty[3] = {false, false};
byte result = 0;


byte ID;
byte id;
#define READ_RATE 5
long timer = micros(); //timer

MFRC522 mfrc522[NR_OF_READERS];   // Create MFRC522 instance.

//Setup BLE
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;
uint32_t value = 0;
String identifier;
// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID        "e098a7b1-9074-4e8f-bb89-2a8e84a1a271"
#define CHARACTERISTIC_UUID "4be50649-c0d7-43e0-a70c-fbf31945b95f"

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
    }
};

void print_wakeup_reason() {
  esp_sleep_wakeup_cause_t wakeup_reason;

  wakeup_reason = esp_sleep_get_wakeup_cause();

  switch (wakeup_reason)
  {
    case ESP_SLEEP_WAKEUP_EXT0 : Serial.println("Wakeup caused by external signal using RTC_IO"); break;
    case ESP_SLEEP_WAKEUP_EXT1 : Serial.println("Wakeup caused by external signal using RTC_CNTL"); break;
    case ESP_SLEEP_WAKEUP_TIMER : Serial.println("Wakeup caused by timer"); break;
    case ESP_SLEEP_WAKEUP_TOUCHPAD : Serial.println("Wakeup caused by touchpad"); break;
    case ESP_SLEEP_WAKEUP_ULP : Serial.println("Wakeup caused by ULP program"); break;
    default : Serial.printf("Wakeup was not caused by deep sleep: %d\n", wakeup_reason); break;
  }
}


/**
   Initialize.
*/
void setup() {

  Serial.begin(9600); // Initialize serial communications with the PC
  pinMode(button, INPUT);
  pinMode(hallSensor, INPUT); 

  //Increment boot number and print it every reboot
  ++bootCount;
  Serial.println("Boot number: " + String(bootCount));

  //Print the wakeup reason for ESP32
  print_wakeup_reason();
  esp_sleep_enable_ext0_wakeup(GPIO_NUM_32, 1); //1 = High, 0 = Low
  while (!Serial);    // Do nothing if no serial port is opened (added for Arduinos based on ATMEGA32U4)

  SPI.begin();        // Init SPI bus
  delay(400);
  for (uint8_t reader = 0; reader < NR_OF_READERS; reader++) {
    mfrc522[reader].PCD_Init(ssPins[reader], RST_PIN); // Init each MFRC522 card
    delay(100);
    Serial.print(F("Reader "));
    Serial.print(reader);
    Serial.print(F(": "));
    mfrc522[reader].PCD_DumpVersionToSerial();
  }

  //BLE setup
  Serial.println("Starting BLE work!");

  // Create the BLE Device & set name!
  BLEDevice::init("Sensor board 1");

  // Create the BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Create a BLE Characteristic
  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ   |
                      BLECharacteristic::PROPERTY_WRITE  |
                      BLECharacteristic::PROPERTY_NOTIFY |
                      BLECharacteristic::PROPERTY_INDICATE
                    );

  // https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.descriptor.gatt.client_characteristic_configuration.xml
  // Create a BLE Descriptor
  pCharacteristic->addDescriptor(new BLE2902());

  // Start the service
  pService->start();

  // Start advertising
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x0);  // set value to 0x00 to not advertise this parameter
  BLEDevice::startAdvertising();
  Serial.println("Waiting a client connection to notify...");
}

/**
   Main loop.
*/
void loop() {
  onoff = digitalRead(button);
  //   Serial.println(onoff);
  delay(50);
  if (onoff == 0) {
    //Go to sleep now
    //    BLEDevice::SoftPowerDown();
    sendIdentifier(254);//send 254 to tell the website to break the connection
    delay(10);
    Serial.println("Going to sleep now");
    esp_deep_sleep_start();
    Serial.println("This will never be printed");
  }
  RFIDreaders();
  hallValue= analogRead(hallSensor);
 // Serial.println(hallValue);
  if(hallValue>2300){
    //compare mode
   // sendIdentifier(3);
    sendValues(67);
  } else if(hallValue<2300){
    //normal mode: with white side facing up or no magnet detecetd 
    //sendIdentifier(3);
    sendValues(78);
  }
}

void RFIDreaders() {

  if (micros() - timer >= (1000000 / READ_RATE) ) { //Timer reduce number of reading per second
    timer = micros();
    //Loop over all readers
    for (uint16_t reader = 0; reader < NR_OF_READERS; reader++) {

      if (mfrc522[reader].PICC_IsNewCardPresent()) {
        if (mfrc522[reader].PICC_ReadCardSerial()) {
          checkEmpty[reader] = false;
          combinedReader[reader]=readID(reader);
          //combinedReader[reader] = mfrc522[reader].uid.uidByte[1]; //save the second byte from the UID in the array (location 0=reader0);
          // Halt PICC --> don't want this, continuous readings needed
          //mfrc522[reader].PICC_HaltA();
          // Stop encryption on PCD
          mfrc522[reader].PCD_StopCrypto1();
        }
      }//Card is not new for one reading, prevent this behaviour by checking if it was -1 (if yes it is really empty) and prevent getting stuck in loop, use boolean to only allow 1 false empty reading
      else if (!mfrc522[reader].PICC_IsNewCardPresent() && combinedReader[reader] != -1 && !checkEmpty[reader]) {
        combinedReader[reader] = -1;
        checkEmpty[reader] = true;
      }
      for (int i = 0; i < 2; i++) {
        sendIdentifier(i);
        sendValues(combinedReader[i]);
        Serial.print(combinedReader[i]);
        Serial.print(',');
      }
     Serial.println();

    }

  }
}

void sendIdentifier(int i) {
  if (deviceConnected) {

    //char start = 'a';
    pCharacteristic->setValue((uint8_t*)&i, 4);//std::string identifier
    //pCharacteristic->setValue((uint8_t*)&value, 4);
    pCharacteristic->notify();
    //  value++;
    delay(50); // bluetooth stack will go into congestion, if too many packets are sent, in 6 hours test i was able to go as low as 3ms
  }
  // disconnecting
  if (!deviceConnected && oldDeviceConnected) {
    delay(500); // give the bluetooth stack the chance to get things ready
    pServer->startAdvertising(); // restart advertising
    Serial.println("start advertising");
    oldDeviceConnected = deviceConnected;
  }
  // connecting
  if (deviceConnected && !oldDeviceConnected) {
    // do stuff here on connecting
    oldDeviceConnected = deviceConnected;
  }

}

void sendValues(int value) {
  if (deviceConnected) {

    pCharacteristic->setValue((uint8_t*)&value, 4);
    pCharacteristic->notify();
    //  value++;
    delay(50); // bluetooth stack will go into congestion, if too many packets are sent, in 6 hours test i was able to go as low as 3ms
  }
  // disconnecting
  if (!deviceConnected && oldDeviceConnected) {
    delay(500); // give the bluetooth stack the chance to get things ready
    pServer->startAdvertising(); // restart advertising
    Serial.println("start advertising");
    oldDeviceConnected = deviceConnected;
  }
  // connecting
  if (deviceConnected && !oldDeviceConnected) {
    // do stuff here on connecting
    oldDeviceConnected = deviceConnected;
  }

}

byte readID(int reader) {
  // Prepare key - all keys are set to FFFFFFFFFFFFh at chip delivery from the factory.
  MFRC522::MIFARE_Key key;
  for (byte i = 0; i < 6; i++) key.keyByte[i] = 0xFF;

  //some variables we need
  byte block;
  byte len;
  MFRC522::StatusCode status;
  byte buffer1[18];
  block = 4;
  len = 18;
  status = mfrc522[reader].PCD_Authenticate(MFRC522::PICC_CMD_MF_AUTH_KEY_A, 4, &key, &(mfrc522[reader].uid)); //line 834 of MFRC522.cpp file
  if (status != MFRC522::STATUS_OK) {
    Serial.print(F("Authentication failed: "));
    Serial.println(mfrc522[reader].GetStatusCodeName(status));
   // return;
  }

  status = mfrc522[reader].MIFARE_Read(block, buffer1, &len);
  if (status != MFRC522::STATUS_OK) {
    Serial.print(F("Reading failed: "));
    Serial.println(mfrc522[reader].GetStatusCodeName(status));
    if (status == 7) { // status code 7 means the crc_a didn't match --> error can occasionally occur when removing the token
      for (uint8_t r = 0; r < NR_OF_READERS; r++) {
        //mfrc522[r].PCD_Reset(ssPins[r], RST_PIN); // Init each MFRC522 card
        mfrc522[r].PCD_Init(ssPins[r], RST_PIN); // Init each MFRC522 card
      }
    }
    //return;
  }


  for (uint8_t i = 0; i < 16; i++)
  {
    if (buffer1[i] != 32)
    {
      ID=buffer1[i];
     // Serial.write(buffer1[i]);
     }
  }
 // Serial.print(" ");
  return ID;
}


/**
   Helper routine to dump a byte array as hex values to Serial.
*/
void dump_byte_array(byte *buffer, byte bufferSize) {
  for (byte i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? " 0" : " ");
    Serial.print(buffer[i], HEX);
  }
}

//void printInd(uint8_t reader) {
//
//  switch (reader) {
//    case 0:
//      Serial.print("Reader1: ");
//      combinedReader[0] = mfrc522[reader].uid.uidByte[3];
//      for (int i = 0; i < 4; i++) {
//        reader1[i] = mfrc522[reader].uid.uidByte[i];
//        Serial.print(reader1[i]);
//        Serial.print(',');
//      }
//
//      Serial.println();
//      break;
//    case 1:
//      Serial.print("Reader2: ");
//      combinedReader[1] = mfrc522[reader].uid.uidByte[3];
//      for (int i = 0; i < 4; i++) {
//        reader2[i] = mfrc522[reader].uid.uidByte[i];
//        Serial.print(reader2[i]);
//        Serial.print(',');
//      }
//
//      Serial.println();
//      break;
//    case 2:
//      Serial.print("Reader3: ");
//      combinedReader[2] = mfrc522[reader].uid.uidByte[3];
//      for (int i = 0; i < 4; i++) {
//        reader3[i] = mfrc522[reader].uid.uidByte[i];
//        Serial.print(reader3[i]);
//        Serial.print(',');
//      }
//
//      Serial.println();
//      break;
//
//  }
//}
