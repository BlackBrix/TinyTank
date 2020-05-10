Fuel Level Sensor - TinyTank
============================

Many Audi type 89 or B4 enthusiasts want to replace their instrument cluster by a more modern one from an A4 (B5) or A6 (C5). Mechanically these clusters fit almost perfectly. Electronically there are some problems to deal with. One is the different characteristics of the fuel level sensors. A type 89 sensor has a logarithmic scale. Newer ones are linear scaled.  
  
[![Fuel Level Sensors](/web/20170814005557im_/http://www.alm.hk/tiny/images/fuellevelsensors_small.jpg)](downloads/FuelLevelSensors.pdf)  
  
Replacing the fuel sensor results in an imprecise gauge. Changing the lookup table inside the instruments cluster's firmware isn't feasible for everybody. So a good compromise is keeping the original sensor and adapting its signal to the needs of the instrument cluster.  
  
[![TinyTank Schematic](/web/20170814005557im_/http://www.alm.hk/tiny/images/tinytank_small.jpg)](downloads/TinyTankSchematic.pdf)  
  
Using Atmel's ATtiny15 TinyTank measures the fuel level via the ADC and produces a PWM signal to the instrument cluster. TinyTank needs only be connected to ground, ignition and the fuel level sensor. A jumper is provided to bring up a test mode. Normally this jumper should be left open. By shortening to ground and switching on ignition the fuel gauge should travel from empty to full and reverse as long as ignition stays high.  
  

Downloads
---------

**Content**

**License**

[Schematic and Demo Board](downloads/TinyTankSchematic.zip) ¹, ²

 [![Creative Commons License](https://web.archive.org/web/20170814005557im_/http://i.creativecommons.org/l/by-nc-sa/3.0/hk/88x31.png)](https://web.archive.org/web/20170814005557/http://creativecommons.org/licenses/by-nc-sa/3.0/hk/) 

[Source code](downloads/TinyTank.zip)

 [![Creative Commons License](https://web.archive.org/web/20170814005557im_/http://i.creativecommons.org/l/GPL/2.0/88x62.png)](https://web.archive.org/web/20170814005557/http://creativecommons.org/licenses/GPL/2.0/) 

[Intel HEX File](downloads/TinyTank.hex) ³

 [![Creative Commons License](https://web.archive.org/web/20170814005557im_/http://i.creativecommons.org/l/GPL/2.0/88x62.png)](https://web.archive.org/web/20170814005557/http://creativecommons.org/licenses/GPL/2.0/) 

  
¹ [Cadsoft](https://web.archive.org/web/20170814005557/http://www.cadsoftusa.com/index.htm.en) offers a demo version to open the files.  
² Users of Altium Designer may use our [contact form](/web/20170814005557/http://www.alm.hk/contact.php) to get a file.  
³ Internal oscillator calibration set to 0x78  
  
  
  
  
  

 [![Creative Commons License](https://web.archive.org/web/20170814005557im_/http://i.creativecommons.org/l/by-nc-sa/3.0/hk/88x31.png)](https://web.archive.org/web/20170814005557/http://creativecommons.org/licenses/by-nc-sa/3.0/hk/) 

Except where otherwise [noted](/web/20170814005557/http://www.alm.hk/termsofuse.php), content on this page is  
licensed under a [Creative Commons Licence 3.0](https://web.archive.org/web/20170814005557/http://creativecommons.org/licenses/by-nc-sa/3.0/hk/)
