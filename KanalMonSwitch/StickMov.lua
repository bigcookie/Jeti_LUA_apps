--[[
This application is built to provide an easy way of generating a way to get
a simple switch which acts on stick movement (it is a software based switched
which is selctable via user applications). The main intention was to  support 
the giro case, in which you would like to use heading hold mode when you leave 
all sticks in neutral, but switch heading hold mode off when moving the sticks 
to make the aircarft/model better reacting. As configuration is different per 
setup, you can select, which channels (P1,
P2,P3,P4) shall be monitored. Additionally you can activate the function by
assigning a main switch. 

  - Application requires switch assignment to turn the function on/off - a
    logical always "max" switch can also be used, if desired
  - Application will create a software switch "C/S" (English) or "K/S" (German) 
    which reacts on stick movement

Howto configure:
  - define main switch to enable/disable the software switch
  - select the P1-P4 channels, which should affect the software switch

Ideas of usage:
Select P1,P3,P4 if P2 is the motor control. As such, rudder/elevator/aileron
are affecting the switch. If you assign the software switch to "heading hold"
mode of your giro, it will be turned off when the non-motor sticks are being 
moved.
If you want to control the Giro with an additional switch, it makes sense to
use e.g. SA and assign it to this application additionally as this allows to
enable/disable the software switch.

History:
 - Version 1.0 - First official release
 - Version 1.1 - Fixed checkbox display on DC-16II, fixed translation

--]]

--------------- 
local lang
local UseP1, UseP2, UseP3, UseP4
local componentIndexP1, componentIndexP2, componentIndexP3, componentIndexP4, componentIndexSW
local switched = 0
local ctrlIdx 
-------------- 

--------------------------------------------------------------------
-- Configure language settings
local function setLanguage()
  local lng=system.getLocale();
  local file = io.readall("Apps/StickMov/locale.jsn")
  local obj = json.decode(file)
  if(obj) then
    lang = obj[lng] or obj[obj.default]
  end
end

--------------------------------------------------------------------
-- Callback functions
local function checkClickedP1(value)
    UseP1 = not value
    system.pSave("StickMon_UseP1",UseP1 and "true" or "false")
    form.setValue(componentIndexP1, UseP1)
end

local function checkClickedP2(value)
    UseP2 = not value
    system.pSave("StickMon_UseP2",UseP2 and "true" or "false")
    form.setValue(componentIndexP2, UseP2)
end

local function checkClickedP3(value)
    UseP3 = not value
    system.pSave("StickMon_UseP3",UseP3 and "true" or "false")
    form.setValue(componentIndexP3, UseP3)
end

local function checkClickedP4(value)
    UseP4 = not value
    system.pSave("StickMon_UseP4",UseP4 and "true" or "false")
    form.setValue(componentIndexP4, UseP4)
end

--------------------------------------------------------------------
-- Handle menu
local function initForm(formID)
  form.addLabel({label=lang.fullName,font=2})
  form.addRow(2)
  form.addLabel({label=lang.switch})
  form.addInputbox(switch,true, function(value) switch=value;system.pSave("switchgyro",value); end ) 
  form.addSpacer(150,10)
  form.addLabel({label=lang.channels})
  form.addRow(3)
  form.addLabel({label=""})
  form.addLabel({label=lang.channel_p1})
  componentIndexP1 = form.addCheckbox(UseP1,checkClickedP1)
  form.addRow(3)
  form.addLabel({label=""})
  form.addLabel({label=lang.channel_p2})
  componentIndexP2 = form.addCheckbox(UseP2,checkClickedP2)
  form.addRow(3)
  form.addLabel({label=""})
  form.addLabel({label=lang.channel_p3})
  componentIndexP3 = form.addCheckbox(UseP3,checkClickedP3)
  form.addRow(3)
  form.addLabel({label=""})
  form.addLabel({label=lang.channel_p4})
  componentIndexP4 = form.addCheckbox(UseP4,checkClickedP4)  
  form.addSpacer(150,10)
  form.addRow(2)
  form.addLabel({label=lang.output_state})
  componentIndexSW = form.addLabel({label="...",alignRight=true})
  form.setFocusedRow(1)    
end  

local function keyPressed(key)
   
end  

local function printForm()

end  

--------------- 
-- Init function
local function init()
  UseP1 = system.pLoad("StickMon_UseP1", "false") == "true"
  UseP2 = system.pLoad("StickMon_UseP2", "false") == "true"
  UseP3 = system.pLoad("StickMon_UseP3", "false") == "true"
  UseP4 = system.pLoad("StickMon_UseP4", "false") == "true"
  switch = system.pLoad("switchgyro")
  system.registerForm(1,MENU_ADVANCED, lang.outputswitch_label_long, initForm,keyPressed, printForm);
  ctrlIdx = system.registerControl(2, lang.outputswitch_label_long, lang.outputswitch_label_short) 
  collectgarbage()
end
 
-------------- 
-- Loop function
local function loop() 
  local val = system.getInputsVal(switch)
  if(val and val>0) then 
    local P1,P2,P3,P4 = system.getInputs("P1","P2","P3","P4")
    if((math.abs(P1) > 0.1 and UseP1) or (math.abs(P2) > 0.1 and UseP2)
      or (math.abs(P3) > 0.1 and UseP3) or (math.abs(P4) > 0.1 and UseP4)) then
      switched = 0
      form.setProperties(componentIndexSW, {label=lang.switch_off})
    else
      switched = 1  
      form.setProperties(componentIndexSW, {label=lang.switch_on})
    end
  else
    switched = 0
    form.setProperties(componentIndexSW, {label=lang.switch_off})
  end
  
  if(ctrlIdx) then
    system.setControl(ctrlIdx, switched,0)
  end
end
 

----------------- 
setLanguage()
return { init=init, loop=loop, author="André Kuhn", version="1.10",name=lang.appName}
