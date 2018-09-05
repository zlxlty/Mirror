<?xml version="1.0" encoding="UTF-8"?>
<tileset name="lec6-2" tilewidth="64" tileheight="64" tilecount="128" columns="8">
 <image source="lec6-2.png" trans="ff00ff" width="512" height="1024"/>
 <tile id="1">
  <properties>
   <property name="c_d" type="float" value="0.1"/>
   <property name="isWater" type="bool" value="true"/>
   <property name="trigger" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="19">
  <properties>
   <property name="h" type="float" value="64"/>
   <property name="isFire" type="bool" value="true"/>
   <property name="sprite" value="sprites/lec6-fire.png"/>
   <property name="w" type="float" value="64"/>
   <property name="x" type="float" value="0"/>
   <property name="y" type="float" value="0"/>
  </properties>
  <objectgroup draworder="index">
   <object id="1" x="1" y="0" width="61" height="61"/>
  </objectgroup>
 </tile>
 <tile id="24">
  <properties>
   <property name="collide" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="41">
  <properties>
   <property name="h" type="float" value="30"/>
   <property name="isWin" type="bool" value="true"/>
   <property name="sprite" value="sprites/lec6-win.png"/>
   <property name="w" type="float" value="64"/>
   <property name="x" type="float" value="0"/>
   <property name="y" type="float" value="34"/>
  </properties>
  <objectgroup draworder="index">
   <object id="1" x="-1" y="34" width="66" height="30"/>
  </objectgroup>
 </tile>
 <tile id="56">
  <properties>
   <property name="collide" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="58">
  <properties>
   <property name="h" type="float" value="35"/>
   <property name="isMushroom" type="bool" value="true"/>
   <property name="sprite" value="sprites/lec6-mushroom.png"/>
   <property name="w" type="float" value="35"/>
   <property name="x" type="float" value="15"/>
   <property name="y" type="float" value="30"/>
  </properties>
  <objectgroup draworder="index">
   <object id="1" x="14" y="31" width="34" height="31"/>
  </objectgroup>
 </tile>
 <tile id="72">
  <properties>
   <property name="collide" type="bool" value="true"/>
  </properties>
  <objectgroup draworder="index">
   <object id="9" x="0.5" y="1" width="63" height="62.5"/>
  </objectgroup>
 </tile>
 <tile id="81">
  <properties>
   <property name="h" type="float" value="54"/>
   <property name="isFinal" type="bool" value="true"/>
   <property name="sprite" value="sprites/lec6-final.png"/>
   <property name="w" type="float" value="64"/>
   <property name="x" type="float" value="0"/>
   <property name="y" type="float" value="10"/>
  </properties>
 </tile>
 <tile id="82">
  <properties>
   <property name="h" type="float" value="64"/>
   <property name="isLock" type="bool" value="true"/>
   <property name="sprite" value="sprites/lec6-lock.png"/>
   <property name="w" type="float" value="64"/>
   <property name="x" type="float" value="0"/>
   <property name="y" type="float" value="0"/>
  </properties>
 </tile>
 <tile id="121">
  <properties>
   <property name="h" type="float" value="32"/>
   <property name="isTrap" type="bool" value="true"/>
   <property name="sprite" value="sprites/lec6-trap.png"/>
   <property name="w" type="float" value="64"/>
   <property name="x" type="float" value="0"/>
   <property name="y" type="float" value="32"/>
  </properties>
  <objectgroup draworder="index">
   <object id="1" x="1" y="32" width="61" height="30"/>
  </objectgroup>
 </tile>
</tileset>
