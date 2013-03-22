{Read distance and position servo}


CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

VAR
  long  dist2
   
OBJ
  servo      : "Servo32v7"
  pops       : "pinger"
  
PUB Start
  repeat
  dist2 := pops.GetVar()


PRI private_method_name


DAT
name    byte  "string_data"        
        