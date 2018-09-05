<?xml version="1.0" encoding="UTF-8"?>
<tileset name="lec6-3" tilewidth="64" tileheight="64" tilecount="128" columns="8">
 <image source="lec6-3.png" trans="ff00ff" width="512" height="1024"/>
 <tile id="8">
  <properties>
   <property name="h" type="float" value="32"/>
   <property name="sprite" value="sprites/lec6-worm.png"/>
   <property name="w" type="float" value="64"/>
   <property name="x" type="float" value="0"/>
   <property name="y" type="float" value="32"/>
  </properties>
  <objectgroup draworder="index">
   <object id="1" x="0" y="32" width="63" height="32">
    <properties>
     <property name="h" type="float" value="32"/>
     <property name="w" type="float" value="64"/>
     <property name="x" type="float" value="0"/>
     <property name="y" type="float" value="32"/>
    </properties>
   </object>
  </objectgroup>
 </tile>
 <tile id="59">
  <properties>
   <property name="h" type="float" value="64"/>
   <property name="isBee" type="bool" value="true"/>
   <property name="sprite" value="sprites/lec6-bee.png"/>
   <property name="w" type="float" value="64"/>
   <property name="x" type="float" value="0"/>
   <property name="y" type="float" value="0"/>
  </properties>
  <objectgroup draworder="index">
   <object id="1" x="1" y="1" width="62" height="62"/>
  </objectgroup>
 </tile>
</tileset>
