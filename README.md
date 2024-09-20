# Clarification of "From Scratch"

I wanted to do this in such a way that made the dependence on Arduino and Arduino boards very specific. I enjoy the atmel SAM family of microcontrollers and plan on making more boards from them in the future. 

From the variants file you can see I am using the sparkfun breakout board for the SAMD21.
This requires a very mildly tweaked version of the ArduinoCore-samd such that it compiles with the latest ASF release: https://github.com/JCohner/ArduinoCore-samd
Using ASF 3.5.2

