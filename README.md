# Clarification of "From Scratch"

I wanted to do this in such a way that made the dependence on Arduino and Arduino boards very specific. I enjoy the atmel SAM family of microcontrollers and plan on making more boards from them in the future. 

From the variants file you can see I am using the sparkfun breakout board for the SAMD21.
This requires a very mildly tweaked version of the ArduinoCore-samd such that it compiles with the latest ASF release: https://github.com/JCohner/ArduinoCore-samd
Using ASF 3.5.2


# Utility
I want to experiment with much more bare bones motor controllers and standalone devies. This will let me do so more elegantly. I will say arduino-cli is a wonderful tool that covers most cases with respect of wanting to free oneself from the arduino IDE; this takes that a step further. 

Further utility can be seen for companies who have a great MVP in arduino and want to take this "in house".