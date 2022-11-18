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

*/


//------------------ RFID readers ----------------------------------------
#include <SPI.h>
#include <MFRC522.h>

#define RST_PIN         9          // Configurable, see typical pin layout above
#define SS_1_PIN        10         // Configurable (not for ESP-wrover), take a unused pin, only HIGH/LOW required, must be different to SS 2
#define SS_2_PIN        8          // Configurable (not for ESP-wrover), take a unused pin, only HIGH/LOW required, must be different to SS 1
#define LED             7          // Do NOT use A0/D14 from an Arduino Nano 33 IOT --> will result in problems connecting with the readers

#define NR_OF_READERS   2

byte ssPins[] = {SS_1_PIN, SS_2_PIN};


// Init array that will store new NUID from all three readers
int reader1[4];
int reader2[4];

int combinedReader[2]; // combine all readings, take either only one value or increase to 12 to use all values
bool checkEmpty[2] = {false, false};
byte result = 0;

byte ID;
byte id;
#define READ_RATE 5
long timer = micros(); //timer

MFRC522 mfrc522[NR_OF_READERS];   // Create MFRC522 instance.

//------------------------------- BLE ----------------------------------------

#include <ArduinoBLE.h>
BLEService readerService("e098a7b1-9074-4e8f-bb89-2a8e84a1a271");

//create reader characteristic and allow remote device to get notifactions
BLEByteCharacteristic readerCharacteristic("e098a7b1-9074-4e8f-bb89-2a8e84a1a271", BLERead | BLENotify);


/**
   Initialize.
*/
void setup() {
  pinMode(LED, OUTPUT);

  Serial.begin(9600); // Initialize serial communications with the PC
  //  while (!Serial);    // Do nothing if no serial port is opened (added for Arduinos based on ATMEGA32U4)

  //-------------------------- Setup BLE ------------------------------------------------------------
  if (!BLE.begin()) {
    Serial.println("starting BLE failed!");

    while (1);
  }
  BLE.setLocalName("Sensor board 2");
  BLE.setAdvertisedService(readerService); // add the service UUID
  readerService.addCharacteristic(readerCharacteristic); // add the reader characteristic
  BLE.addService(readerService); // Add the reader service
  readerCharacteristic.writeValue(97); // set initial value for this characteristic

  /* Start advertising BLE.  It will start continuously transmitting BLE
     advertising packets and will be visible to remote BLE central devices
     until it receives a new connection */

  // start advertising
  BLE.advertise();

  Serial.println("Bluetooth device active, waiting for connections...");

  //----------------------- Setup for RFID readers ---------------------------------------------------

  SPI.begin();        // Init SPI bus
//  delay(400);
  for (uint8_t reader = 0; reader < NR_OF_READERS; reader++) {
    mfrc522[reader].PCD_Init(ssPins[reader], RST_PIN); // Init each MFRC522 card
    delay(100);
    Serial.print(F("Reader "));
    Serial.print(reader);
    Serial.print(F(": "));
    mfrc522[reader].PCD_DumpVersionToSerial();
  }
}

/**
   Main loop.
*/
void loop() {
  digitalWrite(LED, HIGH);
  // wait for a BLE central
  BLEDevice central = BLE.central();

  // if a central is connected to the peripheral:
  if (central) {
    Serial.print("Connected to central: ");
    // print the central's BT address:
    Serial.println(central.address());


    while (central.connected()) {
      RFIDreaders();
      delay(50);

    }
    //readerCharacteristic.writeValue(254);
    Serial.print("Disconnected from central: ");
    Serial.println(central.address());

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
          combinedReader[reader] = readID(reader);
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
 // if (deviceConnected) {
    readerCharacteristic.writeValue(i);
    delay(50); // bluetooth stack will go into congestion, if too many packets are sent, in 6 hours test i was able to go as low as 3ms
//  }
  // disconnecting
  //  if (!deviceConnected && oldDeviceConnected) {
  //    delay(500); // give the bluetooth stack the chance to get things ready
  //    pServer->startAdvertising(); // restart advertising
  //    Serial.println("start advertising");
  //    oldDeviceConnected = deviceConnected;
  //  }
  //  // connecting
  //  if (deviceConnected && !oldDeviceConnected) {
  //    // do stuff here on connecting
  //    oldDeviceConnected = deviceConnected;
  //  }

}

void sendValues(int val) {
  //if (deviceConnected) {
    readerCharacteristic.writeValue(val);
    delay(50); // bluetooth stack will go into congestion, if too many packets are sent, in 6 hours test i was able to go as low as 3ms
 // }
  //  // disconnecting
  //  if (!deviceConnected && oldDeviceConnected) {
  //    delay(500); // give the bluetooth stack the chance to get things ready
  //    pServer->startAdvertising(); // restart advertising
  //    Serial.println("start advertising");
  //    oldDeviceConnected = deviceConnected;
  //  }
  //  // connecting
  //  if (deviceConnected && !oldDeviceConnected) {
  //    // do stuff here on connecting
  //    oldDeviceConnected = deviceConnected;
  //  }

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
      ID = buffer1[i];
      // Serial.write(buffer1[i]);
    }
  }
  // Serial.print(" ");
  return ID;
}

/**
   Helper routine to dump a byte array as hex values to Serial.
*/
void dump_byte_array(byte * buffer, byte bufferSize) {
  for (byte i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? " 0" : " ");
    Serial.print(buffer[i], HEX);
  }
}
