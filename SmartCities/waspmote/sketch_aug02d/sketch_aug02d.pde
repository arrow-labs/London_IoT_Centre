/*
    -------  [SCP_v30_05] - Temperature, humidity and pressure sensor  ---------

    Explanation: This is the basic code to manage and read the temperature,
    humidity and pressure sensor.  Cycle time: 3 minutes

    Copyright (C) 2017 Libelium Comunicaciones Distribuidas S.L.
    http://www.libelium.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Version:           3.1
    Design:            David Gascón
    Implementation:    Alejandro Gállego
*/

#include <WaspSensorCities_PRO.h>
#include <TSL2561.h>

uint16_t range;

/*
   Waspmote OEM. Possibilities for this sensor:
    - SOCKET_2
    - SOCKET_4
   P&S! Possibilities for this sensor:
    - SOCKET_A
    - SOCKET_B
    - SOCKET_C
    - SOCKET_E
    - SOCKET_F
*/
float temperature;  // Stores the temperature in ºC
float humidity;   // Stores the realitve humidity in %RH
float pressure;   // Stores the pressure in Pa

void setup()
{
  USB.ON(); 
  USB.println(F("Temperature, humidity and pressure sensor example"));
  USB.println(F("The sensor is placed in socket B"));
  noise.configure(); 

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





  // And print the values via USB
  
  USB.println(F("***************************************"));
  USB.print(F("Temperature: "));
  USB.printFloat(temperature, 2);
  USB.println(F(" Celsius degrees"));
  USB.print(F("RH: "));
  USB.printFloat(humidity, 2);
  USB.println(F(" %"));
  USB.print(F("Pressure: "));
  USB.printFloat(pressure, 2);
  USB.println(F(" Pa"));
  USB.print(F("Luminosity: "));
  USB.printFloat(TSL.lux, 2);
  USB.println(F(" Lu"));


  ///////////////////////////////////////////
  // 3. Sleep
  ///////////////////////////////////////////

  // Go to deepsleep
  // After 3 minutes, Waspmote wakes up thanks to the RTC Alarm
  USB.println(F("Go to deep sleep mode..."));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);
  USB.println(F("Wake up!!\r\n"));

}

