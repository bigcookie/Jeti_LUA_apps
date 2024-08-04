# Jeti LUA App
This is a collection of some example apps originally from Jeti, but also some extra app(s) which I created.

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

### Gyro-Ctrl.
Self-written application. It is intended for Gyro heading hold usage. The application takes a standard 3-way proportional switch as input and provides a software switch as output. If you dont configure more, the hardware 3-way switch is just passed through.
Usage is intended to improve model handling under "heading hold" gyro mode. For this you need to assign the software switch provided by the application (output 1/0/-1) to the gyro modes "off"/"damping"/"heading hold". The status "off"/"damping" are passed through always. For "heading hold" you can configure channel monitoring of the channels P1/P2/P3/P4 and a tolerance. When configured, "heading hold" mode is set and you move the control sticks, the gyro mode is set to "damping" while control sticks are not neutral and back to "heading hold", when neutral, automatically.
You can configure the tolerance in the application.

### Src Dumper
Original Jeti, unchanged. Application so that the remoe can compile the application and makes loading time faster
as well as reduce memory usage.