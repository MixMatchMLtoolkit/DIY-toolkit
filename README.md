# DIY Mix & Match Machine Learning toolkit
This github repository contains the relevant codes, schematics and files used to create your own sensing board and tokens to be used with the Mix & Match ML web interface. The code for the web interface is provided and can be used to create versions tailored to your project. 

![alt text](https://github.com/MixMatchMLtoolkit/DIY-toolkit/blob/main/system%20overview.jpg)

## Web interface 
To visit the web interface click [here](https://mixmatchmltoolkit.github.io/) <br>
The web interface uses XML files to store all the information about all the tokens and combinations. XSLT and CSS is used to format this information and each time a token is placed or removed the site is updated using AJAX. This is done to keep the sensor board connected via BLE. 
In order to find the sensing board, the serviceUUID should be the same in the BLEconnect.js file and the Arduino code uploaded to the microcontroller.

If you want to make changes to the web interface, you can fork the repository and make changes and either run it locally or host it yourself. 

## Version 1.0 - toolkit with sensing board
This is the original version of the toolkit and uses the sensing board with sensorized tokens for interacting with the web interface. 

### Sensing board
The sensing board contains two RFID readers to read the tokens. Custom versions of the sensing board can be used, here two options will be shown: (i) using an ESP32-wrover with build in battery holder and (ii) using an Arduino Nano 33 IoT (or ESP32) with powerbank.
The necessary code and files for making the sensing board can be found in the folder [sensing board](https://github.com/MixMatchMLtoolkit/DIY-toolkit/tree/main/sensing%20board). This includes the Arduino code used, the Illustrator files for lasercutting the box (and tokens) and the schematic of the electronics.


#### Materials
<ul>
  <li>4 mm MDF or another hard material suited for lasercutting</li>
  <li>2 mm MDF or another hard material suited for lasercutting</li>
  <li>Mircontroller<li>
    <ul>
      <li>LilyGO TTGO T-Energy ESP32-WROVER</li>
      <li>Arduino Nano 33 IoT</li>
      <li>ESP 32</li>
      <li>Or any other microntroller with BLE and SPI (not tested)</li>
      </ul>
  <li>18650  battery/ powerbank/ any other powersource</li>
  <li>2x MFRC522 RFID readers (not yet tested but the RFID PN532 might be better as it has a larger reading range, let me know if you have tested it)</li>
  <li>On-off switch</li>
  <li>Optional: extension cable from male micro usb to female mirco usb</li>
</ul>

#### Assembly
Glue the box togehter: one side, and the top is made out of 2 layers 2mm MDF, glue these first together. Next attach the sides to the bottom, do not attach the the top so you can still access the electronics.
Solder all components to protoboard, soldering is prefered over using a breadboard since this works better/more reliable with the SPI communication of the RFID readers.
Take the placement of the RFID readers into account, they should be placed directly under the cut out rounded rectangle in which the tokens will be placed. Best to attach them directly underneath the top plate for a more reliable reading. 

![alt text](https://github.com/MixMatchMLtoolkit/DIY-toolkit/blob/main/creationboard.jpg)
Image made by: Hannah van Iterson
  
#### Code
Depending on the microcontroller you are using, upload the ESP or Arduino version of the code. You can change the name of the board to a custom name. <br>
Make sure that the serviceUUID in the Arduino code should be the same as in the BLEconnect.js file in order to find the sensing board via the web interface. 


### Tokens
The tokens are made of two layers (4 mm and 2mm) mdf and 3mm synthetic felt with Mifare classic 1K tags as stickers attached at the bottom. The files for lasercutting can be found [here]([https://github.com/MixMatchMLtoolkit/DIY-toolkit/tree/main/sensing%20board/Files%20for%20lasercutting](https://github.com/MixMatchMLtoolkit/DIY-toolkit/tree/main/Felt%20laser%20cut%20tokens)).

#### Materials
<ul>
  <li>4 mm MDF or another firm material suited for lasercutting</li>
  <li>2 mm MDF or another firm material suited for lasercutting</li>
  <li>3 mm synthetic felt in 5 different colours (2 tints blue, 3 tints green). Wool felt does not work well</li>
  <li>24 Mifare classic 1K stickers (as many as there are tokens) </li>
</ul>

#### Assembly
Assemble the tokens by glueing them together, with the 4mm MDF at the bottom next the 2mm MDF and as top layer the felt. 
See the image for which shapes to combine. 
![alt text](https://github.com/MixMatchMLtoolkit/DIY-toolkit/blob/main/creationtokens.jpg)
Image made by: Hannah van Iterson

#### Writing ID numbers to your tags
When creating your own version, you first need to initialize all the tokens by giving writing the correct ID numbers to them. The assigned numbers can be found [here](https://github.com/MixMatchMLtoolkit/DIY-toolkit/blob/main/Token%20id's.xlsx). To write he numbers you can use [this](https://github.com/miguelbalboa/rfid/tree/master/examples/rfid_write_personal_data) example code. 

## Version 2.0 - toolkit with mobile web application
We have updated the toolkit to make it more scalable. Instead of using the sensing board with the sensorized tokens, you can also create the tokens using one of the four options below and scan these tokens using our mobile web application. You will still use the same web interface as with version 1.0.

### Mobile web applications
The mobile web application can be accessed by scanning the QR code in the web interface or by going to https://mix-match-ml.streamlit.app/ 
To sync the mobile web application with the web interface opened on a laptop or big screen you need to enter the OOCSI channel name you see in your web interface (after having clicked on "connect by phone"). Now you can take pictures of the tokens and the web interface will react. 
Multiple people can connect with their mobile to one shared web interface. 

### Tokens
Depending on your available time, the equipment available and goal can choose which version of the tokens you make. The handwritten version is less reliable compared to the other versions and only works if you have a neat handwriting.

#### Post-it tokens
The simplest option of the four, just write the names of the tokens on post-its and start scanning them!

#### Printed tokens
One step more advanced from the post-it tokens is printing the tokens. These tokens have the same colors and shape as the original tokens. You can find the files for printing [here](https://github.com/MixMatchMLtoolkit/DIY-toolkit/tree/main/Printable%20tokens)

#### Basic MDF tokens
If tokens have to be reused frequently, laser cutting tokens out of MDF might be the best option. With the basic version, the  entire token is made out of MDF and the names are engraved. The unlabeled data tokens, the supervised and reinforcement learning tokens can all be made in one piece out of 6 mm MDF. The tokens for labeled data and unsupervised learning consist of two layers of MDF (2mm and 4mm) and these are glued together. The files for lasercutting can be found [here](https://github.com/MixMatchMLtoolkit/DIY-toolkit/tree/main/Basic%20MDF%20tokens)

#### Felt + MDF tokens
The final version of the tokens is the same as the tokens voor V1.0. However, it is not needed to attach RFID tags to the bottom of the tokens. Files for lasercutting can be found [here]([https://github.com/MixMatchMLtoolkit/DIY-toolkit/tree/main/sensing%20board/Files%20for%20lasercutting](https://github.com/MixMatchMLtoolkit/DIY-toolkit/tree/main/Felt%20laser%20cut%20tokens))

## License
<p xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/"><span property="dct:title">The Mix & Match Machine Learning toolkit</span> by <span property="cc:attributionName">Anniek Jansen and dr. Sara Colombo</span> is licensed under <a href="http://creativecommons.org/licenses/by-nc-sa/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC BY-NC-SA 4.0<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1"><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1"></a></p>


