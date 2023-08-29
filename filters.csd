<CsoundSynthesizer>
<CsOptions>
-o./nlin.wav  -W
</CsOptions>
<CsInstruments>

0dbfs = 1
sr=44100
;;channels



opcode Svar3,aaaa,akk
 setksmps 1
 as1,as2 init 0,0
 as,kK,kQ xin
 kdiv = 1+kK/kQ+kK*kK
 ahp = (as - (1/kQ+kK)*as1 - as2)/kdiv
 au = ahp*kK
 abp = au + as1
 as1 = au + abp
 au = abp*kK
 alp = au + as2
 as2 = au + alp
 xout ahp,abp,alp,ahp+alp
endop


opcode Svarn,aaaa,akkk
 setksmps 1
 as1,as2 init 0,0
 as,kK,kQ,ksc xin
 ksci = 1/ksc
 kdiv = 1+kK/kQ+kK*kK
 ahp = (as - (1/kQ+kK)*as1 - as2)/kdiv
 au = tanh(ahp*ksc)*kK*ksci
 abp = au + as1
 as1 = au + abp
 au = tanh(abp*ksc)*kK*ksci
 alp = au + as2
 as2 = au + alp
 xout ahp,abp,alp,ahp+alp
endop


opcode Svar4,aaaa,akk
 setksmps 1
 as1,as2 init 0,0
 as,k1,k2 xin
 kdiv = 1+k1/k2+k1*k1
 ahp = (as - (1/k2)*as1 - as2)
 au = ahp*k1
 ay = au + as1
 abp = au + ay
 as1 = ay
 au = abp*k1
 ay = au + as2
 alp = au + ay
 as2 = ay
 xout ahp,abp,alp,ahp+alp
endop

opcode Svar2,aaaa,akk
 setksmps 1
 abp,alp init 0,0
 as,k1,k2 xin
 alp = abp*k1 + alp 
 ahp = as - alp - k2*abp
 abp = ahp*k1 + abp
  xout ahp,abp,alp,alp+ahp
endop


opcode Svar,aaaa,akk
 setksmps 1
 abp,alp init 0,0
 as,k1,k2 xin
 abr = as - k2*abp 
 ahp = abr - alp
 abp integ ahp*k1
 alp integ abp*k1
     xout ahp,abp,alp,abr
endop

opcode Lp1,a,akk
 as,kcf,kq   xin
 kf = 2*sin($M_PI*kcf/sr)
 ahp,abp,alp,abr Svar as,kf,1/kq
   xout alp
endop

opcode Lp2,a,akk
 as,kcf,kq   xin
 kf = 2*sin($M_PI*kcf/sr)
 ahp,abp,alp,abr Svar2 as,kf,1/kq
   xout alp
endop

opcode Lp3,a,akk
 as,kcf,kq   xin
 kf = tan($M_PI*kcf/sr)
 ahp,abp,alp,abr Svar3 as,kf,kq
   xout alp
endop


opcode Lpn,a,akkk
 as,kcf,kq,kscl   xin
 kf = tan($M_PI*kcf/sr)
 ahp,abp,alp,abr Svarn as,kf,kq,kscl
   xout alp
endop


opcode Prol,a,akk
 setksmps 1
 abp,alp init 0,0
 as,k1,k2 xin
 ahp = alp + abp*k2
 abp integ -ahp*k1
 alp integ (abp + as)*k1
     xout -abp
endop

opcode Prol2,a,akk
 setksmps 1
 alp init 0
 as,k1,k2 xin
 abp integ -(as + alp)*k1
 alp integ -(alp*k2 - abp)*k1
 ; hp = (alp + as)
 ; lp = -alp
 ; bp = -abp
     xout alp
endop

opcode Prol3,a,akk
 setksmps 1
 as1,as2 init 0,0
 as,kK,kD xin
 kQ = 1/kD
 kdiv = 1+kK/kQ+kK*kK
 ahp = (-(1/kQ+kK)*as1 - as2)/kdiv
 au = ahp*kK
 abp = au + as1
 as1 = au + abp
 au = (abp + as)*kK 
 alp = au + as2
 as2 = au + alp
 xout abp
endop

opcode Prol4,a,akk
 setksmps 1
 as1,as2 init 0,0
 as,kK,kD xin
 kQ = 1/kD
 kdiv = 1+kK/kQ+kK*kK
 ahp = (as + as2)/kdiv
 au = ahp*kK
 abp = au + as1
 as1 = au + abp
 au = -kK*(abp + (1/kQ+kK)*as2/kdiv)
 alp = au + as2
 as2 = au + alp
 xout alp
endop

opcode PrologueVCF,a,akk
 setksmps 1
 as1,as2 init 0,0
 as,kK,kD xin
 kscl = 1/(1+kK*kD+kK*kK)
 aya = (as2 - as)*kscl
 au = aya*kK
 ayb = au + as1
 as1 = au + ayb
 au = kK*(ayb + (kD+kK)*as2*kscl)
 alp = au - as2 
 as2 = -(alp + au) 
 xout alp
endop

gifn ftgen 0,0,1024,-7,-14,154,-1.4,357,0,357,1.4,154,14
gifn1 ftgen 0,0,1024,-7,-2,1024,2

gifn2 ftgen 0,0,1024,-7,-168,154,-1.4,357,0,357,1.4,154,168
; 50% res: kRes = 1.77, kg1 = 0.2, norm, kg3=0.28 1800 Hz
; 62.5% res: kRes = 1.92 kg1 = 0.2 kg2 = 0.2, kg3=0.28 1815 Hz

opcode PrologueVCFNL,a,akki
 setksmps 1
 as1,as2 init 0,0
 as,kK,kRes,ig xin
 igi = 1/ig
 kscl = 1/(1+kK*(2-kRes)+kK*kK)
 aya = (as2 - as)*kscl
 au = tanh(aya*ig)*kK*igi
 ayb = au + as1
 as1 = au + ayb
 afdb = 2*as2- kRes*tanh(as2*ig)*igi
 au = tanh((ayb + (kK + 1)*afdb*kscl)*ig)*kK*igi        
 alp = au - as2 
 as2 = -(alp + au)
 xout alp
endop

opcode PrologueVCFNL2,a,akki
 setksmps 1
 as1,as2 init 0,0
 as,kK,kRes,ig xin
 igi = 1/ig
 kscl = 1/(1+kK*(2-kRes)+kK*kK)
 aya = (as2 - as)*kscl
 au = tanh(aya*ig)*kK*igi
 ayb = au + as1
 as1 = au + ayb
 afdb = tablei:a(as2*0.05,gifn2,1,0.5)/0.1 - kRes*tanh(as2*ig)*igi
 au = tanh((ayb + (kK + 1)*afdb*kscl)*ig)*kK*igi        
 alp = au - as2 
 as2 = -(alp + au)
 xout alp
endop


instr 1

kRes = p5
kf = p7; + chnget:k("fr")
as,ass diskin2 "saw-prologue.wav",1,0,1
ks1 = tan($M_PI*kf/sr)
asig3 PrologueVCFNL2 as,ks1,kRes,p8
kg2 = 	p6
asig3 = tanh(asig3*kg2)
    out asig3*p4
endin

instr 2
kD = p5 
kf = p7 
as,ass diskin2 "saw-prologue.wav",1,0,1
ks1 = tan($M_PI*kf/sr)
asig3 PrologueVCF as,ks1,kD
    out asig3*p4
endin

instr 3
as1 diskin2 p5,1,1/110-22/sr,1
  out as1*p4
endin

opcode Prolnl,a,akk
 setksmps 1
 alp init 0
 as,k1,k2 xin
 kg = 0.2
 kg2 = 0.2
 abp integ -tanh((as + alp)*kg)*k1/kg
 afdb = 2*alp - k2*tanh(kg2*alp)/kg2
 alp integ -tanh((afdb - abp)*kg)*k1/kg
     xout alp
endop

instr 4
kRes = p5 
kf = p7; + chnget:k("fr")
as,ass diskin2 "saw-prologue.wav",1,0,1
ks1 = 2*sin($M_PI*kf/sr)
asig3 Prolnl as,ks1,kRes
kg2 = 	p6
asig3 = tanh(asig3*kg2)
    out asig3*p4
endin


</CsInstruments>
<CsScore>
;i1 0 4 1 0 0.28 1760 0.0001
;i1 0 4 1 1.77 0.28 1800 0.2
i2 0 4 0.25 2 0.01 1760
;i2 0 4 0.25 0.16 0.01 1760 
;i3 0 4 0.5 "prologue-Q6.wav"
;i1 0 10 0.7 1.93 0.28 1815 0.23
;i2 0 4 0.125 0.02 0.01 1760 
;i3 8 4 0.5 "prologue_QX.wav"
;i1 0 10 1 1.973 0.28 1825 0.1
;i2 0 4 0.1 0.005 0.01 1760
;i3 8 4 1 "prologue_QZ.wav";
;i4 0 4 0.7 2.2 0.28 1760 0.2
 
 
</CsScore>
</CsoundSynthesizer>
































<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>0</y>
 <width>886</width>
 <height>548</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
 <bsbObject version="2" type="BSBScope">
  <objectName/>
  <x>41</x>
  <y>54</y>
  <width>496</width>
  <height>357</height>
  <uuid>{f020a167-c250-4ec7-afa0-bc5557242ce9}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <value>-255.00000000</value>
  <type>scope</type>
  <zoomx>2.00000000</zoomx>
  <zoomy>1.00000000</zoomy>
  <dispx>1.00000000</dispx>
  <dispy>1.00000000</dispy>
  <mode>0.00000000</mode>
  <triggermode>NoTrigger</triggermode>
 </bsbObject>
 <bsbObject version="2" type="BSBKnob">
  <objectName>scl</objectName>
  <x>128</x>
  <y>467</y>
  <width>80</width>
  <height>80</height>
  <uuid>{780dd440-61f0-4e63-9755-1648d61741dd}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.10000000</minimum>
  <maximum>10.00000000</maximum>
  <value>2.20276000</value>
  <mode>lin</mode>
  <mouseControl act="">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
  <color>
   <r>245</r>
   <g>124</g>
   <b>0</b>
  </color>
  <textcolor>#512900</textcolor>
  <border>0</border>
  <borderColor>#512900</borderColor>
  <showvalue>true</showvalue>
  <flatstyle>true</flatstyle>
  <integerMode>false</integerMode>
 </bsbObject>
 <bsbObject version="2" type="BSBKnob">
  <objectName>fr</objectName>
  <x>227</x>
  <y>468</y>
  <width>80</width>
  <height>80</height>
  <uuid>{20af7f7d-5ca8-4085-8358-f53e34999834}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>110.00000000</maximum>
  <value>110.00000000</value>
  <mode>lin</mode>
  <mouseControl act="">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
  <color>
   <r>245</r>
   <g>124</g>
   <b>0</b>
  </color>
  <textcolor>#512900</textcolor>
  <border>0</border>
  <borderColor>#512900</borderColor>
  <showvalue>true</showvalue>
  <flatstyle>true</flatstyle>
  <integerMode>false</integerMode>
 </bsbObject>
 <bsbObject version="2" type="BSBKnob">
  <objectName>Q</objectName>
  <x>324</x>
  <y>467</y>
  <width>80</width>
  <height>80</height>
  <uuid>{db872ca6-95b8-46d7-aaf8-f94ca60e81d1}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>100.00000000</maximum>
  <value>2.50000000</value>
  <mode>lin</mode>
  <mouseControl act="">continuous</mouseControl>
  <resolution>0.01000000</resolution>
  <randomizable group="0">false</randomizable>
  <color>
   <r>245</r>
   <g>124</g>
   <b>0</b>
  </color>
  <textcolor>#512900</textcolor>
  <border>0</border>
  <borderColor>#512900</borderColor>
  <showvalue>true</showvalue>
  <flatstyle>true</flatstyle>
  <integerMode>false</integerMode>
 </bsbObject>
 <bsbObject version="2" type="BSBGraph">
  <objectName>gr</objectName>
  <x>536</x>
  <y>54</y>
  <width>350</width>
  <height>150</height>
  <uuid>{b9bb8567-a7e7-4fae-a1e7-09335ad6180a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <value>0</value>
  <objectName2/>
  <zoomx>1.00000000</zoomx>
  <zoomy>1.00000000</zoomy>
  <dispx>1.00000000</dispx>
  <dispy>1.00000000</dispy>
  <modex>lin</modex>
  <modey>lin</modey>
  <showSelector>true</showSelector>
  <showGrid>true</showGrid>
  <showTableInfo>true</showTableInfo>
  <showScrollbars>true</showScrollbars>
  <enableTables>true</enableTables>
  <enableDisplays>true</enableDisplays>
  <all>true</all>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
