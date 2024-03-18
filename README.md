# Jeti LUA App
This is a collection of some example apps originally from Jeti, but also some extra app which I created.

## List of Applications
### Artificial Horizon
Original Jeti, unchanged. This is a copy of the original Jeti app. Untouched.

### Automatic Trainer Switch
Original Jeti. This is a copy of the original Jeti App. It is an app, which allows to automatically switch
back to trainermode, if the trainer is moving the sticks. You assign a momentary switch to the 
application and the output software switch from the application ("T/S") as scholar/teacher 
switch to your remote control. The application stores the stick position when giving control 
to the scholar. When now moving the sticks, the application gives back control to the teacher.

### Demos
Original Jeti, unchanged. This is a copy of the demo applications to learn LUA.

### KanalMonSwitch
Self-written application. It is intended for Gyro heading hold usage. The application takes a standard
switch as configuration and provides a software swtich as output. IF the main switch is turned on and
the sticks are not moved, the output is on. If the sticks are moved the output is turned off as long
as the sticks are moved. When leaving the stick to neutral position, the output is turned on again as 
longs as the main switch is on. The user can configure the channeles P1-P4 to be used for movement detection.

This is intended to use "heading hold" mode. When moving the switches, the mode is turned "off" and
the model is acting better on rudder control. When stopping stearing, "heading hold" is re-enabled.
The main switch allows to turn the overall "heading hold" mode "on" or "off".

### Src Dumper
Original Jeti, unchanged. Application so that the remoe can compile the application and makes loading time faster
as well as reduce memory usage.