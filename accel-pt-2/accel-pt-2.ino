#include <Wire.h>
#include <Adafruit_LIS3DH.h>
#include <Adafruit_Sensor.h>

// For I2C connection
Adafruit_LIS3DH lis = Adafruit_LIS3DH();

void setup() {
  Serial.begin(115200);
  while (!Serial) delay(10);
  
  Serial.println("LIS3DH test!");
  
  if (! lis.begin(0x18)) {   // Try address 0x18 first
    Serial.println("Trying alternate address...");
    if (! lis.begin(0x19)) { // Then try 0x19
      Serial.println("Could not find a valid LIS3DH sensor, check wiring!");
      while (1) delay(10);
    }
  }
  
  Serial.println("LIS3DH found!");
}

void loop() {
  lis.read();
  
  Serial.print("X: "); Serial.print(lis.x);
  Serial.print(" Y: "); Serial.print(lis.y);
  Serial.print(" Z: "); Serial.print(lis.z);
  
  sensors_event_t event; 
  lis.getEvent(&event);
  
  Serial.print(" - X: "); Serial.print(event.acceleration.x);
  Serial.print(" Y: "); Serial.print(event.acceleration.y);
  Serial.print(" Z: "); Serial.print(event.acceleration.z);
  Serial.println(" m/s^2");
  
  delay(200);
}