CON
 
  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000
  b1     =       255   'Brightness of main LED and neighbours
  b2     =       75
  delay  =       90
  
  bdelay =       200   'Factor to delay shift of brightness        
  
 
VAR
  byte i,j
 

OBJ
 ' serial        : "Parallax Serial Terminal.spin"
  led           : "jm_led8.spin"
 
PUB Start
  'serial.Start(115200)
  led.start(8, 16)
  Toggle

PUB Toggle | TimeBase, OneMS
  repeat
    repeat i from 0 to 8
      repeat j from 0 to b1
        led.set(i,j)                          ' Illuminate i          
        waitcnt(clkfreq/(bdelay*delay) + cnt) ' Slow the brightness change down a little
      repeat j from b1 to 0
        led.set(i-3,j)
        waitcnt(clkfreq/(bdelay*delay) + cnt)
     waitcnt(clkfreq/delay + cnt)
    repeat i from 8 to 0
      'outa[i]~~
      'outa[i+3]~
      'led.set(i,b1)
      'led.set(i+2,b2)
      'led.set(i+3,0)
      repeat j from 0 to b1
        led.set(i, j)
        waitcnt(clkfreq/(bdelay*delay) + cnt)
      repeat j from b1 to 0
        led.set(i+3,j)
        waitcnt(clkfreq/(bdelay*delay) + cnt)
      if i == 0
        repeat j from b1 to 0
          led.set(i+2,j)
          waitcnt(clkfreq/(bdelay*delay) + cnt)
        repeat j from b1 to 0
          led.set(i,j)
          waitcnt(clkfreq/(bdelay*delay) + cnt)
      waitcnt(clkfreq/delay + cnt)