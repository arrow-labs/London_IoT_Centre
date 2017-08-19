/*  
 *  ------ [802_02] - send packets -------- 
 *  
 *  Explanation: This program shows how to send packets to a gateway
 *  indicating the MAC address of the receiving XBee module 
 *  
 *  Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L. 
 *  http://www.libelium.com 
 *  
 *  This program is free software: you can redistribute it and/or modify 
 *  it under the terms of the GNU General Public License as published by 
 *  the Free Software Foundation, either version 3 of the License, or 
 *  (at your option) any later version. 
 *  
 *  This program is distributed in the hope that it will be useful, 
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of 
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
 *  GNU General Public License for more details. 
 *  
 *  You should have received a copy of the GNU General Public License 
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>. 
 *  
 *  Version:           3.0
 *  Design:            David Gascón 
 *  Implementation:    Yuri Carmona
 */
 
#include <WaspXBee802.h>
#include <WaspFrame.h>
#include <WaspSensorCities_PRO.h>
#include <TSL2561.h>
uint16_t range;


// Destination MAC address
//////////////////////////////////////////
char RX_ADDRESS[] = "0013A20041678B7D";
//////////////////////////////////////////

// Define the Waspmote ID
char WASPMOTE_ID[] = "DGateRoof";


// define variable
uint8_t error;

float temperature;  // Stores the temperature in ºC
float humidity;   // Stores the realitve humidity in %RH
float pressure;   // Stores the pressure in Pa


void setup()
{
  // init USB port
  USB.ON();
  USB.println(F("Sending packets example"));
  
  // store Waspmote identifier in EEPROM memory
  frame.setID( WASPMOTE_ID );
  
  // init XBee
  xbee802.ON();
  
}


void loop()
{
  ///////////////////////////////////////////
  // 1. Turn on the sensor
  ///////////////////////////////////////////

  // Power on the socket B
  SensorCitiesPRO.ON(SOCKET_B);
  SensorCitiesPRO.ON(SOCKET_C);
  TSL.ON();
  
  ///////////////////////////////////////////
  // 2. Read sensors
  ///////////////////////////////////////////

  // Read enviromental variables
  temperature = SensorCitiesPRO.getTemperature();
  humidity = SensorCitiesPRO.getHumidity();
  pressure = SensorCitiesPRO.getPressure();
  TSL.getLuminosity();


    // Power off the socket 4
  SensorCitiesPRO.OFF(SOCKET_B);
  SensorCitiesPRO.OFF(SOCKET_C);
  
  ///////////////////////////////////////////
  // 2. Create ASCII frame
  ///////////////////////////////////////////  

  // create new frame
  frame.createFrame(ASCII);  
  
  // add frame fields
  frame.addSensor(SENSOR_TCA, temperature);
  frame.addSensor(SENSOR_HUMA, humidity);
  frame.addSensor(SENSOR_PA, pressure);
  frame.addSensor(SENSOR_LUM, TSL.lux);
  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel()); 
  

  ///////////////////////////////////////////
  // 2. Send packet
  ///////////////////////////////////////////  

  // send XBee packet
  error = xbee802.send( RX_ADDRESS, frame.buffer, frame.length );   
  
  // check TX flag
  if( error == 0 )
  {
    USB.println(F("send ok"));
    
    // blink green LED
    Utils.blinkGreenLED();
    
  }
  else 
  {
    USB.println(F("send error"));
    
    // blink red LED
    Utils.blinkRedLED();
  }

  // wait for five seconds
  delay(5000);
}
