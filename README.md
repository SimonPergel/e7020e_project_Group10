# e7020e_project
We shamelessly borrowed the footprint & symbol libraries used in the labs of E7020E

# TOTP with automatic password input

## Members

- Gabriel Axheim Gustafsson (gabaxh-2@student.ltu.se)
- Patrik Wall (walpat-1@student.ltu.se)
- Simon Pergel (isoepe-1@student.ltu.se)


## High level specification
Our TOTP fob is designed to be able to automatically input the password calculated by behaving like a keyboard when you click the button once and it's connected to the USB, holding the button down will instead make it behave like a usb memory thus allowing a user to insert a new secret onto the device. When the password has been sent the display will show a "Success" message letting the user know that it's safe to remove the device. When the device is only powered by battery the device will show the one time password on the display instead, holding down the button will instead show the secret stored on the device.
- Button
  - Click, USB powered: calculate & act as keyboard (enters password automatically)
  - Click, battery powered: calculate password and show it on the display
  - Hold, USB powered: allow insertion of secrets
  - Hold, battery powered: display secret
- Display
  - If button was clicked show password (battery)
  - If button was clicked send password (usb)
    - Show successful message when password was "sent"
  - If button was held & connected to USB
    - Restart USB connection & act as a USB memory
    - Allow a user to store new secret

NOTE: This is still not set in stone, currently talking about it and might change
### Hardware Features
- 1x Real time clock (32kHz crystal)
- 1x Button
- 1x USB connector
- 1x Display
- 1x Battery connector (5V)

### Software Features
- Allow setting & getting time
- Set shared secret
- Encrypt secret
- Deep sleep (1mA during idle)

### Additional features
- Battery powered while not connected to USB
- Allowing the TOTP to switch between different behaviour
  - Might need to terminate USB connection for this to work
  - Acting as a keyboard
  - Acting as a USB memory auto running a CLI?
- *LED displaying remaining battery

Features starting with * might be included depending on difficulty and time required to complete said feature

## Grading
- Gabriel
  - Expected contributions towards grade 4 or 5.

- Simon
  - Expected contributions towards grade 4 or 5.
 
- Patrik
   - Expected contributions towards grade 4 or 5.


### Summery of workflow and member contribution

Regarding our goal, it turned out to be very hard to achive all features due to faults in the final PCB manufactured board (as brought up on presentation meeting), which led to delays and alot of time-pressure towards the end. But overall, we are very happy that we manage to do in the time we had. Working button, working keyboard feature, working Secret-key storeage on the flash memory on the pcb and also a correct working OTP-code generator. 

- Contribution
  - When it comes to hardware, we decided to do everything as a group together, mostly because all of us wanted to learn soldering and the whole process.
  - When it comes to the software, we reused alot of code from the excercises. But we assignt our selfs to be responsible for diffrent task inside the software. Gabriel was responsable for getting the pcb to work as a keyboard and get the button up and running. Patrik took upon himself to implement the secret key store/retrieval-feature and helping Simon with the display. Simon was responsible for how the otp-code was generated and at the end tried with Patrik to get the display to work. Ofcourse there had to be alot of pair/group programing because our parts had to work together and in the "same direction". So alot of times there where open discussion where ideas was floating in the air and changes was made.

- NOTE: our code is not very well structred(due to time press), but important to know is that our working software is placed inside a file named "examples/main.rs". There are also some things added in the cargo files and in the command-parser file, but the main software is in main.rs. There may also be code that is not yet finished (display), if that is a problem let us know. 


