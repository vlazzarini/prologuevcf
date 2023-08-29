<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
0dbfs = 1
sr = 96000
ksmps =96

giRes = 7
gicf = 1

ctrlinit 1,gicf,84
ctrlinit 2,gicf,84
ctrlinit 3,gicf,84
ctrlinit 1,giRes,100
ctrlinit 2,giRes,100
ctrlinit 3,giRes,100

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
 afdb = tablei:a(as2*0.05,gifn,1,0.5)/0.1 - kRes*tanh(as2*ig)*igi
 au = tanh((ayb + (kK + 1)*afdb*kscl)*ig)*kK*igi        
 alp = au - as2 
 as2 = -(alp + au)
 xout alp
endop

instr 1
ich midichn
print ich
if ich == 1 then
kcps cpsmidib 2
iamp ampmidi 0dbfs/16
as1 vco2 0.5,kcps*1.002
as2 vco2 0.5,kcps*0.998
kf   midictrl gicf,1,14
krs  midictrl giRes,0.5,50
kf port kf,0.01
kenv madsr 0.001,2,0.5,0.1 
ks1 = tan($M_PI*((1+kenv)*2^kf+kcps)/sr)
amix = as1 + as2
as3 PrologueVCF amix,ks1,1/krs
aenv madsr 0.1,0.1,0.8,0.1 
    out tanh(aenv*as3*iamp)
elseif ich == 2 then
kcps cpsmidib 2
iamp ampmidi 0dbfs/8
as1 vco2 0.5,kcps*1.002
as2 vco2 0.5,kcps*0.998
kf   midictrl gicf,1,14
krs  midictrl giRes,0,1.95
kf port kf,0.01
kenv madsr 0.001,2,0.5,0.1 
ks1 = tan($M_PI*((1+kenv)*2^kf+kcps)/sr)
amix = as1 + as2
as3 PrologueVCFNL amix,ks1,krs,0.2
aenv madsr 0.1,0.1,0.8,0.25 
    out tanh(aenv*as3*iamp)*0.7
elseif ich == 3 then
kcps cpsmidib 2
iamp ampmidi 0dbfs/8
as1 vco2 0.5,kcps*1.002
as2 vco2 0.5,kcps*0.998
kf   midictrl gicf,1,13
krs  midictrl giRes,0,1.97
kf port kf,0.01
kenv madsr 0.001,2,0.5,0.1 
ks1 = tan($M_PI*((1+kenv)*2^kf+kcps)/sr)
amix = as1 + as2
kf port kf,0.01
as3 PrologueVCFNL2 amix,ks1,krs,0.2
aenv madsr 0.1,0.1,0.8,0.1 
    out tanh(aenv*as3*iamp)*0.7
endif
endin


/*
instr 11 // LINEAR
kcps cpsmidib 2
iamp ampmidi 0dbfs/16
as1 vco2 0.5,kcps*1.002
as2 vco2 0.5,kcps*0.998
kf   midictrl gicf,1,14
krs  midictrl giRes,0.5,50
kf port kf,0.01
kenv madsr 0.001,2,0.5,0.1 
ks1 = tan($M_PI*((1+kenv)*2^kf+kcps)/sr)
amix = as1 + as2
as3 PrologueVCF amix,ks1,1/krs
aenv madsr 0.1,0.1,0.8,0.1 
    out tanh(aenv*as3*iamp)
endin

instr 2 // NLINEAR1
kcps cpsmidib 2
iamp ampmidi 0dbfs/8
as1 vco2 0.5,kcps*1.002
as2 vco2 0.5,kcps*0.998
kf   midictrl gicf,1,14
krs  midictrl giRes,0,1.95
kf port kf,0.01
kenv madsr 0.001,2,0.5,0.1 
ks1 = tan($M_PI*((1+kenv)*2^kf+kcps)/sr)
amix = as1 + as2
as3 PrologueVCFNL amix,ks1,krs,0.2
aenv madsr 0.1,0.1,0.8,0.25 
    out tanh(aenv*as3*iamp)*0.7
endin

instr 3 // NLINEAR2
kcps cpsmidib 2
iamp ampmidi 0dbfs/8
as1 vco2 0.5,kcps*1.002
as2 vco2 0.5,kcps*0.998
kf   midictrl gicf,1,13
krs  midictrl giRes,0,1.97
kf port kf,0.01
kenv madsr 0.001,2,0.5,0.1 
ks1 = tan($M_PI*((1+kenv)*2^kf+kcps)/sr)
amix = as1 + as2
kf port kf,0.01
as3 PrologueVCFNL2 amix,ks1,krs,0.2
aenv madsr 0.1,0.1,0.8,0.1 
    out tanh(aenv*as3*iamp)*0.7
endin
*/

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>




<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>0</y>
 <width>248</width>
 <height>190</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="background">
  <r>240</r>
  <g>240</g>
  <b>240</b>
 </bgcolor>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>slider0</objectName>
  <x>228</x>
  <y>90</y>
  <width>20</width>
  <height>100</height>
  <uuid>{407b8ec9-adfd-402d-96eb-6fe5796fc37b}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.12000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
