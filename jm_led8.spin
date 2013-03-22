'' =================================================================================================
''
''   File....... jm_led8.spin
''   Purpose.... LED modlation using accumulator-divider modulation
''   Author..... Jon "JonnyMac" McPhalen
''               Copyright (c) 2011 Jon McPhalen
''               -- see below for terms of use
''   E-mail..... jon@jonmcphalen.com
''   Started.... 
''   Updated.... 28 JUL 2011
''
'' =================================================================================================


var

  long  cog

  long  pincount
  long  basepin
  
  byte  brightness[8]                                           ' brightness levels
  

pub start(n, p) | ok

'' Start LED8 accumulator-rollover driver; uses one cog
'' -- n is number of pwm outputs (1 to 8)
'' -- p is the first pin to use (0 to 28-n); protects rx, tx, i2c pins

  ok := false

  if ((n => 1) and (n =< 8))                                    ' count okay?
    if ((p => 0) and (p =< (28-n)))                             ' base pin okay?
      stop                                                      ' stop previous instance                                                      
      pincount := n                                   
      basepin  := p

      ok := cog := cognew(@led8, @pincount) + 1                 ' start the pwm cog

  return ok
      

pub stop

'' Stops LED8 driver; frees a cog

  set_all(0) 

  if cog
    cogstop(cog~ - 1)
   

pub set(ch, level)

'' Sets channel to specified level

  if (ch => 0) & (ch < pincount)
    brightness[ch] := 0 #> level <# 255

  return brightness[ch]
    

pub set_all(level)

'' Set all channels to same level

  level := 0 #> level <#255                                     ' limit to byte value
  bytefill(@brightness[0], level, 8)

  return level

  
pub inc(ch)

'' Increment channel brightness

  if (ch => 0) & (ch < pincount)
    if (brightness[ch] < 255)
      ++brightness[ch]
    return brightness[ch]
    
  return -1                                                     ' bad channel                                                  
    

pub inc_all | ch

'' Increment brightness of all channels

  repeat ch from 0 to (pincount-1)
    inc(ch)


pub dec(ch)

'' Decrement channel brightness

  if (ch => 0) & (ch < pincount)
    if (brightness[ch] > 0)
      --brightness[ch]
    return brightness[ch]

  return -1                                                     ' bad channel                                                  


pub dec_all | ch

'' Decrement brightness of all channels

  repeat ch from 0 to (pincount-1)
    dec(ch)
      

pub ezlog(level)

  level := 0 #> level <#255                                     ' limit to byte value
  
  return (level * level) >> 8                                   ' level := (level^2) / 256


pub read(ch)

'' Returns channel brightness

  if (ch => 0) & (ch < pincount)
    return brightness[ch]
  else
    return -1                                                   ' bad channel                                                  


pub address

'' Returns hub address of brightness array

  return @brightness


dat

                        org     0

led8                    mov     tmp1, par                       ' start of parameters
                        rdlong  chcount, tmp1                   ' read channel count
                        add     tmp1, #4
                        rdlong  ch0pin, tmp1                    ' read pin for ch 0
                        add     tmp1, #4
                        mov     hub0, tmp1                      ' save address of brightness[0]

                        mov     outa, #0                        ' clear pins
                        mov     tmp1, #%1111_1111               ' create mask for pins
                        mov     tmp2, #8
                        sub     tmp2, chcount
                        shr     tmp1, tmp2
                        shl     tmp1, ch0pin
                        mov     dira, tmp1                      ' set outputs

ledmain                 mov     hubpntr, hub0                   ' start at hub bright[0]
                        mov     cogpntr, #chacc                 ' point to channel accumulators
                        mov     count, chcount                  ' set channel count
                        
                        mov     chmask, #1                      ' pin mask for ch0
                        shl     chmask, ch0pin

:loop                   movd    :update_acc, cogpntr            ' point to ch accumulator
                        movd    :check_acc, cogpntr
                        movd    :clear_c, cogpntr

                        rdbyte  tmp1, hubpntr                   ' get brightness
:update_acc             add     0-0, tmp1                       ' add to accumulator
:check_acc              test    0-0, C_BIT              wc      ' carry? (save)
:clear_c                and     0-0, #$FF                       ' clear old carry        
                        muxc    outa, chmask                    ' copy carry to output                          

                        add     hubpntr, #1                     ' next channel 
                        add     cogpntr, #1                     ' next accumlator
                        shl     chmask, #1                      ' next ch pin

                        djnz    count, #:loop
                        jmp     #ledmain                                                                 

' --------------------------------------------------------------------------------------------------

INC_SRC                 long    %0_0000_0001                    ' increment source field
INC_DEST                long    %0_0000_0001 << 9               ' increment destination field

C_BIT                   long    %1_0000_0000                    ' carry for 8-bit values

chacc                   long    0[8]                            ' channel accumulators

chcount                 res     1                               ' channel count
ch0pin                  res     1                               ' LSB pin of group
hub0                    res     1 

count                   res     1                               ' channels to process
chmask                  res     1                               ' mask for active channel

hubpntr                 res     1                               ' pointer for hub ram
cogpntr                 res     1                               ' pointer for cog ram

tmp1                    res     1                               ' work vars
tmp2                    res     1

                        fit                               

                        
dat

{{

  Terms of Use: MIT License

  Permission is hereby granted, free of charge, to any person obtaining a copy of this
  software and associated documentation files (the "Software"), to deal in the Software
  without restriction, including without limitation the rights to use, copy, modify,
  merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to the following
  conditions:

  The above copyright notice and this permission notice shall be included in all copies
  or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
  PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

}}  