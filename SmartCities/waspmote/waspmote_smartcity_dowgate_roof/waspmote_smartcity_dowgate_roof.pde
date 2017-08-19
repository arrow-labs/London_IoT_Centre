/*
 *  -------- Waspmote - Plug & Sense! - Code Generator ------------ 
 *
 *  Code generated with Waspmote Plug & Sense! Code Generator. 
 *  This code is intended to be used only with Waspmote Plug & Sense!
 *  series (encapsulated line) and is not valid for Waspmote. Use only
 *  with Waspmote Plug & Sense! IDE (do not confuse with Waspmote IDE).
 *
 *  Copyright (C) 2012 Libelium Comunicaciones Distribuidas S.L.
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
 *  Version:    0.1
 *  Generated:    02/08/2017
 *
 */

// Step 1. Includes of the Sensor Board and Communications modules used

#include <WaspSensorCities.h>



#include <WaspXBee802.h>

// Step 2. Variables declaration

char  CONNECTOR_A[3] = "CA";      
char  CONNECTOR_B[3] = "CB";       
char  CONNECTOR_C[3] = "CC";
char  CONNECTOR_D[3] = "CD";
char  CONNECTOR_E[3] = "CE";
char  CONNECTOR_F[3] = "CF";

long  sequenceNumber = 0;        
                                               
char  nodeID[10] = "DGateRoof";     

const char* sleepTime = "00:00:00:05";  

char data[100];             

float connectorAFloatValue;       
float connectorBFloatValue;      
float connectorCFloatValue;          
float connectorDFloatValue;      
float connectorEFloatValue;
float connectorFFloatValue;

int connectorAIntValue;
int connectorBIntValue;
int connectorCIntValue;
int connectorDIntValue;
int connectorEIntValue;
int connectorFIntValue;

char  connectorAString[10];       
char  connectorBString[10];      
char  connectorCString[10];
char  connectorDString[10];
char  connectorEString[10];
char  connectorFString[10];

int   batteryLevel;
char  batteryLevelString[10];
char  BATTERY[4] = "BAT";

char  TIME_STAMP[3] = "TS";

const char* macAddress="41678B62";

packetXBee* packet;


void setup() 
{

// Step 3. Communication module initialization

// Step 4. Communication module to ON

    xbee802.ON();

// Step 5. Initial message composition

    // Memory allocation
    packet=(packetXBee*) calloc(1,sizeof(packetXBee));
    // Choose transmission mode: UNICAST or BROADCAST
    packet->mode=UNICAST;
    // Set destination XBee parameters to packet
    xbee802.setDestinationParams( packet, macAddress, "Hello, this is Waspmote Plug & Sense!\r\n", MAC_TYPE);

// Step 6. Initial message transmission

    xbee802.sendXBee(packet);
    // Free variables
    free(packet);
    packet=NULL;

// Step 7. Communication module to OFF

    xbee802.OFF();
    delay(100);


}

void loop()
{
// Step 8. Turn on the Sensor Board

    //Turn on the sensor board
    SensorCities.ON();
    //Turn on the RTC
    RTC.ON();
    //supply stabilization delay
    delay(100);

// Step 9. Turn on the sensors

    //En el caso de la placa de eventos no aplica

    SensorCities.setSensorMode(SENS_ON, SENS_CITIES_TEMPERATURE);
    delay(100);

    SensorCities.setSensorMode(SENS_ON, SENS_CITIES_LDR);
    delay(100);

// Step 10. Read the sensors

    

    // First dummy reading for analog-to-digital converter channel selection
    PWR.getBatteryLevel();
    // Getting Battery Level
    batteryLevel = PWR.getBatteryLevel();
    // Conversion into a string
    itoa(batteryLevel, batteryLevelString, 10);

    //First dummy reading for analog-to-digital channel selection
    SensorCities.readValue(SENS_CITIES_TEMPERATURE);
    //Sensor temperature reading
    connectorAFloatValue = SensorCities.readValue(SENS_CITIES_TEMPERATURE);
    //Conversion into a string
    Utils.float2String(connectorAFloatValue, connectorAString, 2);

    //First dummy reading for analog-to-digital converter channel selection
    SensorCities.readValue(SENS_CITIES_LDR);
    //Sensor temperature reading
    connectorCFloatValue = SensorCities.readValue(SENS_CITIES_LDR);
    //Conversion into a string
    Utils.float2String(connectorCFloatValue, connectorCString, 2);

// Step 11. Turn off the sensors

    //En el caso de la placa de eventos no aplica

    SensorCities.setSensorMode(SENS_OFF, SENS_CITIES_TEMPERATURE);

    SensorCities.setSensorMode(SENS_OFF, SENS_CITIES_LDR);

// Step 12. Message composition

    //Data payload composition
    sprintf(data,"I:%s#N:%li#%s:%s#%s:%s#%s:%s#%s:%s\r\n",
  nodeID ,
  sequenceNumber,
  BATTERY, batteryLevelString,
  TIME_STAMP, RTC.getTimestamp(),
  CONNECTOR_A , connectorAString,
  CONNECTOR_C , connectorCString);

    // Memory allocation
    packet=(packetXBee*) calloc(1,sizeof(packetXBee));
    // Choose transmission mode: UNICAST or BROADCAST
    packet->mode=UNICAST;
    // Set destination XBee parameters to packet
    xbee802.setDestinationParams( packet, macAddress, data, MAC_TYPE);

// Step 13. Communication module to ON

    xbee802.ON();

// Step 14. Message transmission

    xbee802.sendXBee(packet);
    // Free variables
    free(packet);
    packet=NULL;

// Step 15. Communication module to OFF

    xbee802.OFF();
    delay(100);

// Step 16. Entering Sleep Mode

    PWR.deepSleep(sleepTime,RTC_OFFSET,RTC_ALM1_MODE1,ALL_OFF);
    //Increase the sequence number after wake up
    sequenceNumber++;


}
