choiceview-webapi-voxeo-demo
============================

A ChoiceView Demo Application for the Voxeo Platform

Overview
--------
ChoiceView is a Communications-as-a-Service (CAAS) platform that allows visual information to be 
shared between contact center agents or IVR systems and mobile users equipped with the ChoiceView 
app.

Description
-----------
The [ChoiceView REST API] (http://www.radishsystems.com/for-developers/for-ivr-developers/) is a 
REST-based service that enables visual capabilities on new and existing IVR systems. A 
ChoiceView-equipped IVR provides visual menus and visual responses to callers. If live assistance is 
needed, it can transfer the call to a contact center agent with payload delivery and continued 
visual sharing

This repository contains source code for a ChoiceView implementation on the Voxeo Experience Portal 
platform. 

VoxeoRadishDemo- A CCXML based application that implements the ChoiceView API. The application 
	consists of two parts. The CCXML/jsp code drive the voice interface and handle events from the 
	ChoiceView API. The other part consists of Java servlet that spawns a new Thread for every 
	ChoiceView session. This Thread polls the ChoiceView session looking for status changes. If a 
	change is detected, then API calls are made to tell the ChoiceView session to send a message to 
	the CCXML application. This design takes into consideration the security restrictions that may 
	exist in a distrubuted Environment. The API messages are being sent from the Application/Web 
	Server to the basichttp processor. All transactions should occur inside the firewall of the 
	runtime environment.
				
See the following files for the Servlet code:
choiceview-webapi-voxeo-demo\VoxeoRadishDemo\WEB-INF\src\com\radish\choiceview\ChoiceViewServlet.java
choiceview-webapi-voxeo-demo\VoxeoRadishDemo\WEB-INF\src\com\radish\choiceview\ChoiceViewPollingThread.java


Dependencies
------------
All dependencies to compile and run the application exist within the WEB-INF/lib directory of the 
application.

	* WEB-INF/lib/choiceview-webapi-java-1.1-voxeo-alpha1.jar
	* WEB-INF/lib/httpclient-4.2.1.jar
	* WEB-INF/lib/httpcore-4.2.1.jar
	* WEB-INF/lib/jackson-core-asl-1.9.9.jar
	* WEB-INF/lib/jackson-mapper-asl-1.9.9.jar
	* WEB-INF/lib/scert-06.00.11.03.jar

LICENSE
-------
[MIT License](https://github.com/radishsystems/choiceview-webapi-java/blob/master/LICENSE)

Building the Application
--------------------
The file should build in Orchestration Designer "as-is" assuming that the Voxeo runtime support file 
has been exported to your local development environment. You may need to adjust your Java build path 
to include the files in the "Dependencies" Section.

Running the Application
---------------
To use the VoxeoRadishDemo application, you must have a mobile device with the latest ChoiceView client 
installed.  You should know the phone number of the mobile device, or the phone number that the 
ChoiceView client is configured to use.  The client must be configured to use the ChoiceView 
development server.  On iOS devices, press Settings, then Advanced, then change the server field to 
cvnet2.radishsystems.com. On Android devices, press the menu button, then Settings, then scroll down 
to the server field and change it to cvnet2.radishsystems.com.

Once connected to the application running on the Voxeo Experience Portal, you will be prompted to 
press the "Start" button on your mobile device client. If configured correctly, you should see 
"ChoiceView Agent Connected" and you will be presented with the Main Menu. Now, you can tap a 
selection on the mobile client as well as interact with the Voice Application.


Contact Information
-------------------
If you want more information on ChoiceView, or want access to the ChoiceView REST API, contact us.

[Radish Systems, LLC](http://www.radishsystems.com/support/contact-radish-customer-support/)

-	support@radishsystems.com
-	darryl@radishsystems.com
-	+1.720.440.7560
