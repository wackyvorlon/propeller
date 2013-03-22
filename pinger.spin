{Get range}


CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000
        ServoCh1 = 0
        PING_pin = 7

VAR
  long range
  long range2
  long stack[90]
  long stack2[90]
   
OBJ
  serial    : "Parallax Serial Terminal"
  serv      : "Servo32v7"
  ping      : "ping"
  
PUB Start

  'dira[8] := 1

  'serial.Start(115_200)
  cognew(movserv, @stack[0])
  'cognew(GrabDistance, @stack2[0])
  
  repeat
    'serial.str(String(serial#NL,"Distance: "))
    range := ping.Inches(PING_pin)
    'serial.Dec(range)
    waitcnt(clkfreq/10 + cnt)
    
  


PUB movserv

  serv.Start
  'serv.Ramp
  serv.Set(ServoCh1, 1500)

  repeat
    range2 := range
    if (range > 10)
      range2 := 10
    serv.Set(ServoCh1, (range2*200)+500)
    waitcnt(clkfreq + cnt)

PUB GrabDistance

  'dira[8] := 1
  repeat
    'range := ping.Inches(8)
    waitcnt(clkfreq/4 + cnt)
  


      
        