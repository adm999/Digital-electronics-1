# Lab 9-13: Code lock with 4x3 matrix keypad, time limit for entering the correct code and signaling an incorrect attempt

#### Objectives

The purpose of this application is to create code in VHDL that will allow security of access to the building, safe or anything else to unauthorized persons. If the pin is entered correctly (PIN:1234), the code lock is unlocked and the person is allowed to enter. If the pin is entered incorrectly or if the time limit of 10 s for entering the correct pin is not observed, the code lock remains locked. 

## Hardware description

#### Connection of external peripherals:

<img src="https://user-images.githubusercontent.com/58397657/80632226-3ee1e180-8a57-11ea-9299-09694d731ef4.png" width="400">

The individual columns and rows are read by setting one of the columns to 0V and then all rows are checked in an ongoing read state.
LEDs LD0 (for correctly entered PIN) and LD1 (for incorrectly entered PIN) on the Coolrunner II board would be used to signal a correct or incorrect attempt. For synchronous reset would be used BTN0.

## Code description

The top layer consists of five blocks named: clock_enable, timer_10s, keypad_FSM, key_pressed_detector and code_FSM.

<img src="https://user-images.githubusercontent.com/58397657/80631044-7485cb00-8a55-11ea-882d-b429d86291c0.png" width="500">

<img src="https://user-images.githubusercontent.com/58397657/80631095-88c9c800-8a55-11ea-9f9d-f60d560d3b4e.png" width="600">

#### Main blocks of top:
For describe the code lock function there are two finite state machines:

keypad_FSM:

<img src="https://user-images.githubusercontent.com/58397657/80634307-8d44af80-8a5a-11ea-9d73-ba89909f6476.png" width="500">

The Finite State Machine "keypad_FSM" consists of 6 states named: s_cols_1 to 3 and r_rows_1 to 3 ("s" means "set" and "r" means "read"). The default state is s_cols_1, as shown in the image.
The individual columns and rows are read by checking 1 column and then all rows. Then go to the next column and check all the rows again, etc. Depending on which row and column is the key, the number on the keyboard is pressed.

code_FSM:
<img src="https://user-images.githubusercontent.com/58397657/80631353-de9e7000-8a55-11ea-9042-fabf98f73070.png" width="800">

Finite state machine code_FSM consists of 9 states. The states for entering the correct PIN number are called corrX and the states for entering the wrong PIN number are called errX. In addition, there are three other states: "start", which indicates a system-wide reset, "fail", which indicates that the specified combination was incorrect, and finally, "unlock", which indicates that the specified combination was correct and unlocks the device.
Preset PIN: 1234
Then there are 2 outputs that signal either a correct or incorrect combination of numbers: "unlock_o" and "error_led_o". If the combination entered by the user on the keyboard was correct and the user did not exceed the time limit for entering the correct PIN, the output "unlock_o" will go to the active level (unlock_o = '1'). Otherwise, the output will have an "error_led_o" output (error_led_o = '1').
If the correct combination has been entered but the time limit set to 10s has been exceeded, the system automatically enters the "fail" state.

#### Secondary blocks of top:

clock_enable:
Generate clock enable signal instead of creating another clock domain. 

timer_10s:
Timer_10s serves as a timer. The time for which the user must enter the correct PIN is set to 10s.

key_pressed_detector:
The key_pressed_detector module serves as a button press indicator. 

## Simulations

Correct combination:

![správna kombinácia](https://user-images.githubusercontent.com/58397657/80631560-30df9100-8a56-11ea-9730-def6d788310e.png)

The case when the entered PIN was correct, but the time limit for entering it was exceeded:

![spravna_kombinacia+cas_limit(visio)](https://user-images.githubusercontent.com/58397657/80631603-43f26100-8a56-11ea-8d57-cb26e4c7a61e.png)

If you enter the wrong PIN:

![nespravna_kombinacia(visio)](https://user-images.githubusercontent.com/58397657/80631643-54a2d700-8a56-11ea-9063-020dede8d61a.png)

System reset after pressing the "#" key:

![krizik_restart_visio](https://user-images.githubusercontent.com/58397657/80631678-65ebe380-8a56-11ea-93ca-6a0a34111108.png)

Note: The output "debug_key_code" is output only in order to clearly see which key is being simulated.

## Implementation on board

For the whole project the * .ucf file was modified for implementation into the CoolRunner II board. Subsequently, the project was tested using Generate Programming in ISE.

<img src="https://user-images.githubusercontent.com/58397657/80631763-874ccf80-8a56-11ea-9483-82f564ae4add.png" width="500">

## References

https://www.youtube.com/watch?v=b-DL3LiJrOk

https://github.com/tomas-fryza/Digital-electronics-1/blob/master/Docs/coolrunner-ii_sch.pdf

https://forums.xilinx.com/t5/Simulation-and-Verification/VHDL-Test-Bench-loop/m-p/508221/highlight/true?fbclid=IwAR1gy5-TRBEVZSyOMnwsuVHCBxWFrH3eTEx8SI9YA7HHrR_JUDlWzU8Itu8#M10757

https://github.com/tomas-fryza/Digital-electronics-1/wiki/How-to-Simulate-Your-Design-in-ISE

