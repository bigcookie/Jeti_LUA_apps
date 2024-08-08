--[[
This application is built to provide an easy way of generating a way to get
a simple switch which acts on stick movement (it is a software based switched
which is selctable via user applications). The main intention was to  support 
the gyro cases, in which you would like to use heading hold mode when you leave 
all sticks in neutral, but switch from heading hold mode to damping mode when 
moving the sticks and back when you leave the sticks neutral to make the 
aircraft/model better reacting. 
As configuration is different per setup, you can select, which channels (P1,
P2,P3,P4) shall be monitored. 

  - Application requires proportional 3-way switch assignment to control the 
    gyro modes off/damping/heading hold
  - Application creates a software switch "C/S" (English) or "K/S" (German) 
    which passes the switch state 1 and 0 through and enables -1 if no sticks
    are being moved, but switch -1 to 0 while sticks are not neutral

Howto configure:
  - define main switch to control the gyro modes with
  - select the P1-P4 channels, which should affect the software switch. If 
    none are selected, the software switch behaves as the assigned hardware 
    switch

Ideas of usage:
Select P1,P3,P4 if P2 is the throttle control. As such, rudder/elevator/aileron
are affecting the switch. If you set the hardware switch to "heading hold"
mode of your gyro, it will be switch to damping mode when the non-motor sticks 
are being moved.

History:
 - Version 1.0 - First release
 - Version 1.1 - Fixed checkbox display on DC-16II, fixed translation
 - Version 2.0 - Moved to 3-Way-Switch support to fully support no gyro, damping 
                 mode and heading hold mode without logical switch combinations.
                 Made controls in form only visible when correct switch is assigned
 - Version 2.1 - Made control registration robust. Added destroy function.

--]]

--------------- 
local lang
local UseP1, UseP2, UseP3, UseP4, switch, tolerance
local componentIndexP1, componentIndexP2, componentIndexP3, componentIndexP4, componentIndexSW, componentInputSW
local switchstate = 1 
local errorstate = 0
local ctrlIdx 
-------------- 

--------------------------------------------------------------------
-- Configure language settings
local function setLanguage()
    local lng=system.getLocale();
    local file = io.readall("Apps/GyroCtrl/locale.jsn")
    local obj = json.decode(file)
    if(obj) then
        lang = obj[lng] or obj[obj.default]
    end
end

--------------------------------------------------------------------
-- Callback functions to set checkbox and save parameters
local function onP1Changed(value)
    UseP1 = not value
    system.pSave("GyroCtrl_UseP1",UseP1 and "true" or "false")
    form.setValue(componentIndexP1, UseP1)
end

local function onP2Changed(value)
    UseP2 = not value
    system.pSave("GyroCtrl_UseP2",UseP2 and "true" or "false")
    form.setValue(componentIndexP2, UseP2)
end

local function onP3Changed(value)
    UseP3 = not value
    system.pSave("GyroCtrl_UseP3",UseP3 and "true" or "false")
    form.setValue(componentIndexP3, UseP3)
end

local function onP4Changed(value)
    UseP4 = not value
    system.pSave("GyroCtrl_UseP4",UseP4 and "true" or "false")
    form.setValue(componentIndexP4, UseP4)
end

local function onToleranceChanged(value)
    tolerance = value
    system.pSave("GyroCtrl_Tolerance",tolerance)
    form.setValue(componentIndexTol, tolerance)
end

local function onSwitchSelected(value)
    switch = value
    local table = system.getSwitchInfo(switch)
-- Check if Switch is a proportional 3-way switch, set and save parameter
-- Improvement for future: support standard switch as well just for heading hold on/off
    if (table.mode == "P" or table.mode == "PI") then
        system.pSave("GyroCtrl_GyroSwitch", switch)
        form.setValue(componentInputSW, switch)
        error_state = 0
    else
        system.messageBox(lang.error_wrongswitch, 3)
        error_state = 1
        switchstate = 1
-- in case of error unregister switch and form control to show output
        switch = nil
        componentIndexSW = nil
    end
    form.reinit(form.getActiveForm())
end

--------------------------------------------------------------------
-- Handle menu
local function initForm(formID)
--    form.addLabel({label=lang.fullName,font=2})
    form.addRow(2)
    form.addLabel({label=lang.switch})
    componentInputSW = form.addInputbox(switch,true, onSwitchSelected)  
-- only show rest of form, if a suitable switch was selected
    if (error_state == 0) then
        form.addSpacer(150,10)
        form.addLabel({label=lang.channels})
        form.addRow(3)
        form.addLabel({label=""})
        form.addLabel({label=lang.channel_p1})
        componentIndexP1 = form.addCheckbox(UseP1,onP1Changed)
        form.addRow(3)
        form.addLabel({label=""})
        form.addLabel({label=lang.channel_p2})
        componentIndexP2 = form.addCheckbox(UseP2,onP2Changed)
        form.addRow(3)
        form.addLabel({label=""})
        form.addLabel({label=lang.channel_p3})
        componentIndexP3 = form.addCheckbox(UseP3,onP3Changed)
        form.addRow(3)
        form.addLabel({label=""})
        form.addLabel({label=lang.channel_p4})
        componentIndexP4 = form.addCheckbox(UseP4,onP4Changed)  
        form.addSpacer(150,10)
        form.addRow(2)
        form.addLabel({label=lang.tolerance})
        componentIndexTol = form.addIntbox(tolerance,1,100,0,0,1,onToleranceChanged)  
        form.addSpacer(150,10)
        form.addRow(2)
        form.addLabel({label=lang.output_state})
        componentIndexSW = form.addLabel({label="...",alignRight=true})
        form.setFocusedRow(1)  
    end  
end

local function keyPressed(key)
   
end  

local function printForm()

end  

--------------- 
-- Init function
local function init()
-- get persistent parameters from storage
    UseP1 = system.pLoad("GyroCtrl_UseP1", "false") == "true"
    UseP2 = system.pLoad("GyroCtrl_UseP2", "false") == "true"
    UseP3 = system.pLoad("GyroCtrl_UseP3", "false") == "true"
    UseP4 = system.pLoad("GyroCtrl_UseP4", "false") == "true"  
    tolerance = tonumber(system.pLoad("GyroCtrl_Tolerance","5"))
    switch = system.pLoad("GyroCtrl_GyroSwitch", nil)
-- register configuration form
    system.registerForm(1,MENU_ADVANCED, lang.fullName, initForm, keyPressed, printForm)
-- register software control switch as provided by application
    for i = 1,11,1 do
        ctrlIdx = system.registerControl(i, lang.outputswitch_label_long, lang.outputswitch_label_short) 
        if (ctrlIdx) then
            break
        end
        if (i==11) then
            system.messageBox(lang.error_registercontrol, 3)
        end
    end
end
 
-------------- 
-- Loop function
local function loop() 
    local val = system.getInputsVal(switch)
    if(val and val < 0) then 
        local P1,P2,P3,P4 = system.getInputs("P1","P2","P3","P4")
        if((math.abs(P1) > tolerance/100 and UseP1) or (math.abs(P2) > tolerance/100 and UseP2) or (math.abs(P3) > tolerance/100 and UseP3) or (math.abs(P4) > tolerance/100 and UseP4)) then
            switchstate = 0
            if (componentIndexSW) then
                form.setProperties(componentIndexSW, {label=lang.switch_middle})
            end
        else
            switchstate = -1
            if (componentIndexSW) then
                form.setProperties(componentIndexSW, {label=lang.switch_down})
            end
        end
    elseif(val and val == 0) then 
        switchstate = 0
        if (componentIndexSW) then
            form.setProperties(componentIndexSW, {label=lang.switch_middle})
        end
    else
        switchstate = 1
        if (componentIndexSW) then
            form.setProperties(componentIndexSW, {label=lang.switch_up})
        end
    end
    if(ctrlIdx) then
        system.setControl(ctrlIdx, switchstate, 1)
    end
end

local function destroy()
    system.unregisterControl(ctrlIdx)
    system.unregisterForm(1)
    collectgarbage()
end

 

----------------- 
setLanguage()
return { init=init, loop=loop, author="André Kuhn", version="2.10",name=lang.appName}
