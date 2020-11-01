# Design and implementation of an embedded system for remote presence control
## Prerequisiments
- **Arduino IDE** ([Arduino IDE](https://www.arduino.cc/en/software))
- **Flutter**([Flutter](https://flutter.dev/?gclid=Cj0KCQjwufn8BRCwARIsAKzP696dC_kxSmCd7_eIa0LpRRA0riUA3UmGtYvjM_HUOCycvgLL7McXzpMaAkvaEALw_wcB&gclsrc=aw.ds))
- **Edge Engine**([EdgeEngine](https://github.com/measurify/edge))

## Overview
The purpose of this thesis work is to illustrate the design of a system to monitor a room and notify any new presences in the room itself.
The project will therefore consist of:
- A **fixed module**, a device that is installed in the room to be monitored
- A **mobile module**, which serves to notify the user of any presence detected
The two modules will communicate with each other thanks to the Measurify API which will manage the server side, thus making sure that the fixed module communicates with the mobile one whenever someone or something enters the room.
In practice, the presence detections collected by the device installed in the room are sent to the Measurify API, through which a smartphone, appropriately associated with it, is notified of the new presence in the room via a specially designed app

## Hardware
The main components are:
- **PIR sensor**([PIR sensor](https://www.amazon.it/Yizhet-Pyroelectricity-infrarosso-Movimento-Raspberry/dp/B08B3L19QF/ref=sr_1_1_sspa?adgrpid=55345593071&dchild=1&gclid=Cj0KCQjwufn8BRCwARIsAKzP696JiH1hridGSx5dD2tddE9YdTFCRL5ypv6zLpAIvNV_Hh0asjpckaYaAmNbEALw_wcB&hvadid=255224413892&hvdev=c&hvlocphy=1008800&hvnetw=g&hvqmt=e&hvrand=6820867537556796359&hvtargid=kwd-316121540108&hydadcr=28875_1803268&keywords=sensore+pir&qid=1604246676&sr=8-1-spons&tag=slhyin-21&psc=1&spLa=ZW5jcnlwdGVkUXVhbGlmaWVyPUFVWkowUjc0M0taUFAmZW5jcnlwdGVkSWQ9QTA0OTAzMTMzN05STk9TTzBWWFZYJmVuY3J5cHRlZEFkSWQ9QTAxMzA0MTUxVzlURkg0MjZFR0tIJndpZGdldE5hbWU9c3BfYXRmJmFjdGlvbj1jbGlja1JlZGlyZWN0JmRvTm90TG9nQ2xpY2s9dHJ1ZQ==))
- **WI-FI ESP32** ([Wi-Fi ESP32](https://www.amazon.it/AZDelivery-ESP32-NodeMCU-Parent/dp/B07Z837RCM))
![Electronic Components used](images/hw.jpg?raw=true "Electronic Components used")

## Application
With the tool Flutter, we have designed an application, which has the scope to display all the Measurify's funtionalities. It is composeded by two levels:
-**Login**: with your username and password, you access to Measurify
-**Home** and **Setting**: show your reserved area, which are active all the rooms, the devices, ecc.
![Login level](images/Login.jpg=500x20px?raw=true "Login level")
![Home Level](images/Home.jpg?raw=true "Home level")
![Setting Level](images/Setting.jpg?raw=true "Setting level")
## Quick start
After the microcontroller and the sensor have been connected together as the picture below, connect the Wi-Fi ESP32 to a USB port of your computer

![Fixed Module](images/ModuloFisso.jpg?raw=true "Fixed Module")

## Set username and password in *ESP32sourceCode.ino*
In order to access Measurify with your credentials, you need to set them in *ESP32sourceCode.ino*
- opts.username = "your-username";
  opts.password =  "your-password";

## Set internet connection
In order to connect you system to Internet, so you can communicate with Measurify, you need to set the connection with your Wi-Fi credentials
- const char* ssidWifi = "Wi-Fi Name";
  const char* passWifi = "Wi-Fi Password";
## Upload the program
After that, you have all the requirements to upload the program on the ESP32. While the program is loaded, you need to push the BOOT bottom on the ESP32. After the program is loaded you need to push the RESET bottom. 
If the PIR sensor detects a presence, a notification will arrive on the smartphone where the application is installed and where the push notifications are activated

## Make a subscription for push notifications
One funtionality of Measurify is the subscriptions: you can notify Measurify that a certain smartphone need to active push notifications. You need **Firebase Cloud Messagging**([Firebase Cloud Messagging](https://firebase.google.com/products/cloud-messaging?gclid=Cj0KCQjwufn8BRCwARIsAKzP694CrmG3e1KdNZyNQnCs4NUkDelmKidD4CMfLXNMA2YKQLsKqjvwKYcaApjOEALw_wcB)), which gives you a token. 
You read the token on the console of Flutter. With Postman([Postman](https://www.postman.com/)), you make a HTTP request with the following body:
{
	token of Firebase Cloud Messagging,
	your username,
	your password
}

Enjoy your embedded system for remote presence control