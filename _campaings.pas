


procedure InitCMP;
begin
   cmp_loc[1 ] := spr_c_phobos;
   cmp_loc[2 ] := spr_c_phobos;
   cmp_loc[3 ] := spr_c_phobos;
   cmp_loc[4 ] := spr_c_deimos;
   cmp_loc[5 ] := spr_c_deimos;
   cmp_loc[6 ] := spr_c_deimos;
   cmp_loc[7 ] := spr_c_mars;
   cmp_loc[8 ] := spr_c_mars;
   cmp_loc[9 ] := spr_c_earth;
   cmp_loc[10] := spr_c_earth;
   cmp_loc[11] := spr_c_earth;
   cmp_loc[12] := spr_c_phobos;
   cmp_loc[13] := spr_c_phobos;
   cmp_loc[14] := spr_c_phobos;
   cmp_loc[15] := spr_c_deimos;
   cmp_loc[16] := spr_c_deimos;
   cmp_loc[17] := spr_c_deimos;
   cmp_loc[18] := spr_c_hell;
   cmp_loc[19] := spr_c_hell;
   cmp_loc[20] := spr_c_hell;
   cmp_loc[21] := spr_c_mars;
   cmp_loc[22] := spr_c_mars;
end;


procedure cmp_hellspawn(m,p:byte);
var x,y:integer;
begin
   if(random(2)=0)then
   begin
      x:=random(map_mw);
      if(random(2)=0)
      then y:=0
      else y:=map_mw;
   end else
   begin
      y:=random(map_mw);
      if(random(2)=0)
      then x:=0
      else x:=map_mw;
   end;
   _unit_add(x,y,rut2u[r_hell,m],p);
end;


procedure cmp_makearmy;
var sx,sy:integer;
begin

   with _players[PlayerHuman] do
    if(G_Step<1000)and((G_Step mod 10)=0)then
    begin
      sx:=map_psx[0];
      if(map_psy[0]>1500)
      then sy:=map_psy[0]-random(200)
      else sy:=map_psy[0]+random(200);


      if(eu[false,6]<3)
      then _unit_add(sx,sy,rut2u[race,6],PlayerHuman)
      else
        if(eu[false,5]<3)
        then _unit_add(sx,sy,rut2u[race,5],PlayerHuman)
        else
          if(eu[false,4]<25)
          then _unit_add(sx,sy,rut2u[race,4],PlayerHuman)
          else
            if(eu[false,3]<25)
            then _unit_add(sx,sy,rut2u[race,3],PlayerHuman)
            else
              if(eu[false,2]<20)
              then _unit_add(sx,sy,rut2u[race,2],PlayerHuman)
              else
                if(eu[false,1]<15)
                then _unit_add(sx,sy,rut2u[race,1],PlayerHuman)
                else
                  if(eu[false,0]<10)
                  then _unit_add(sx,sy,rut2u[race,0],PlayerHuman);

      if(_lau>0)then
       with _units[_lau] do
       begin
          mx:=x-250*sign(x-1500);
          my:=y-250*sign(y-1500);
       end;
    end;
end;

procedure cmp_code;
begin
   case _mcmp_sm of
   1  : cmp_portal:=vid_hfps+(_players[PlayerHuman].army div 20)*vid_hfps;
   4  : cmp_portal:=vid_hfps+(_players[PlayerHuman].army div 12)*vid_hfps;
   7  :
        if(g_Step=cmp_inhelltime)then
        begin
           PlaySNDM(snd_teleport);

           _unit_remove(101);

      _unit_add(map_psx[0]+100,map_psy[0]-100,UID_HellPool,1); with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
      _unit_add(map_psx[0]+100,map_psy[0]-280,UID_Cyberdemon,1); with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
      _unit_add(map_psx[0]-100,map_psy[0]-100,UID_HellTeleport,1); with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
      _unit_add(map_psx[0],map_psy[0],UID_HellGate,1);  with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
      _unit_add(map_psx[0]+75,map_psy[0]+100,UID_HellGate,1);  with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
      _unit_add(map_psx[0]-75,map_psy[0]+100,UID_HellGate,1); with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
      _unit_add(map_psx[0]-100,map_psy[0],UID_HellSymbol,1);  with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
      _unit_add(map_psx[0]+100,map_psy[0],UID_HellSymbol,1);  with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
      _unit_add(map_psx[0],map_psy[0]-100,UID_HellSymbol,1);  with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
      _unit_add(map_psx[0],map_psy[0]+150,UID_HellTower,1);  with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
      _unit_add(map_psx[0]-150,map_psy[0]+50,UID_HellTower,1); with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
      _unit_add(map_psx[0]+150,map_psy[0]+50,UID_HellTower,1); with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
      _unit_add(map_psx[0],map_psy[0]-160,UID_HellTower,1);   with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);

      _unit_add(map_psx[0],map_psy[0]-300,UID_LostSoul,1);
      _unit_add(map_psx[0],map_psy[0]-300,UID_LostSoul,1);
      _unit_add(map_psx[0],map_psy[0]-300,UID_LostSoul,1);
      with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);

      _unit_add(map_psx[0]-200,map_psy[0]-200,UID_LostSoul,1);
      _unit_add(map_psx[0]-200,map_psy[0]-200,UID_LostSoul,1);
      _unit_add(map_psx[0]-200,map_psy[0]-200,UID_LostSoul,1);
      with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);

      _unit_add(map_psx[0]-200,map_psy[0]+200,UID_LostSoul,1);
      _unit_add(map_psx[0]-200,map_psy[0]+200,UID_LostSoul,1);
      _unit_add(map_psx[0]-200,map_psy[0]+200,UID_LostSoul,1);
      with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
        end;
   9  : if(g_Step=cmp_inhelltime)then
        begin
           PlaySNDM(snd_teleport);

           _unit_remove(101);

           _unit_add(map_psx[0],map_psy[0],UID_HellFortess,1);with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
           _unit_add(map_psx[0]-165,map_psy[0],UID_HellAltar,1);with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
           _unit_add(map_psx[0]+165,map_psy[0],UID_HellAltar,1);with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
           _unit_add(map_psx[0],map_psy[0]-165,UID_HellAltar,1);with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
           _unit_add(map_psx[0],map_psy[0]+165,UID_HellAltar,1);with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);

           _unit_add(map_psx[0]+125,map_psy[0]+125,UID_Cyberdemon,1);with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
           _unit_add(map_psx[0]-125,map_psy[0]-125,UID_Cyberdemon,1);with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
           _unit_add(map_psx[0]-125,map_psy[0]+125,UID_Mastermind,1);with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
           _unit_add(map_psx[0]+125,map_psy[0]-125,UID_Mastermind,1);with _units[_lau] do _effect_add(x,y,9999,eid_Teleport);
        end;
10,11 : cmp_makearmy;
12    : if(_regen=0)then
        begin
           _players[1].ai_partpush:=(7000-_units[1].hits) div 200;
           _players[2].ai_partpush:=_players[1].ai_partpush;
           _players[3].ai_partpush:=_players[1].ai_partpush;
           if(_units[1].hits>3500)then _players[0].upgr[2]:=1;
        end;
14    : if(G_Step=72000)then cmp_portal:=30;
15    : cmp_portal:=vid_hfps+(_players[PlayerHuman].army div 12)*vid_hfps;
18    : if(G_Step mod 140)=0 then
       begin
          cmp_portal:=vid_hfps+(_players[PlayerHuman].army div 10)*vid_hfps;
          cmp_hellspawn(0,0);
          cmp_hellspawn(random(5),2);
          cmp_hellspawn(0,1);
          cmp_hellspawn(random(5),3);
       end;
19,20    : begin
       if(G_Step mod 160)=0 then
       begin
          cmp_hellspawn(random(5),0);
          cmp_hellspawn(random(4),1);
          cmp_hellspawn(random(3),3);
       end;
       cmp_makearmy;
        end;
   else
   end;
end;

procedure cmp_hellworld(p:byte);
var ix,iy:integer;
begin
   ix:=0;
   iy:=map_seed;

  with _players[p] do
   while (army<MaxPlayerUnits) do
   begin
      repeat
          ix:=ai_rc(ix+iy,666);
          iy:=ai_rc(ix+iy,0);
      until (_spch(ix,iy)=false)and(ix>=0)and(iy>=0)and(ix<=map_mw)and(iy<=map_mw);

      if(race=r_hell)
      then _unit_add(ix,iy,rut2b[race,4],p)
      else
        begin
           if((army mod 3)=0)
           then _unit_add(ix,iy,rut2b[race,2],p)
           else _unit_add(ix,iy,rut2b[race,4],p);
           if(army>80)then break;
        end;
   end;
end;

procedure cmp_base3(x,y:integer;p,i:byte);
begin
   with _players[p] do
   begin
      _unit_add(x,y,rut2b[race,2],p);
      _unit_add(x-80,y,rut2b[race,4],p);
      _unit_add(x+80,y,rut2b[race,4],p);
      if(i>0)then
      begin
         _unit_add(x,y+80,rut2b[race,4],p);
         _unit_add(x,y-80,rut2b[race,4],p);
      end;
   end;
end;

procedure cmp_base2(x,y,l:integer;p:byte);
var i,ix,iy:integer;
begin
   for i:=0 to 15 do
   begin
      ix:=x+trunc(cos(i*22*pi/180)*l);
      iy:=y+trunc(sin(i*22*pi/180)*l);
      if((i mod 2)=0)
      then if(_players[p].race=r_uac)
           then _unit_add(ix,iy,UID_UACBase2,p)
           else _unit_add(ix,iy,UID_HellAltar,p)
      else if(_players[p].race=r_uac)
           then _unit_add(ix,iy,UID_UACTurret,p)
           else _unit_add(ix,iy,UID_HellTower,p);
   end;
end;

procedure cmp_defbase(x,y:integer;pl,rr:byte;bu5:TSob);
var bx:array[1..18]of integer = (-176,-89,93,178,-93,83,-259,261,282,348,167,-10,-188,-291,-379,-175,14,197);
    by:array[1..18]of integer = (6,158,154,-4,-157,-158,156,-161,157,12,-312,-318,-313,-157,0,323,331,324);
    bt:array[1..18]of integer;
    ix,iy,i:integer;
begin
   bt[1 ]:=1;
   bt[2 ]:=1;
   bt[3 ]:=1;
   bt[4 ]:=1;
   bt[5 ]:=1;
   bt[6 ]:=1;
   bt[7 ]:=2;
   bt[8 ]:=2;
   bt[9 ]:=2;
   bt[10]:=2;
   bt[11]:=4;
   bt[12]:=4;
   bt[13]:=3;
   bt[14]:=5;
   bt[15]:=4;
   bt[16]:=4;
   bt[17]:=4;
   bt[18]:=4;

   for ix:=1 to 18 do
    if((ix+pl+x+y) mod 3)=0 then
    for iy:=1 to 18 do
     if(ix<>iy)then
     begin
        if(bt[ix] in bu5) then
         if(bt[ix]<>4)and(not(4 in bu5))
         then bt[ix]:=4
         else bt[ix]:=0;
        i:=bt[ix];bt[ix]:=bt[iy];bt[iy]:=i;
     end;

   with _players[pl] do
   begin
      if not(0 in bu5)then _unit_add(x,y,rut2b[race,0],pl);
      for ix:=1 to 18 do if ((ix mod rr)=0)and(bt[ix]>0) then
      begin
         _unit_add(x+bx[ix],y+by[ix],rut2b[race,bt[ix]],pl);
         i:=(ix+pl+x+y) mod 5;
         if(i in alw_u)then _unit_add(x+bx[ix]+75,y+by[ix]+75,rut2u[race,i],pl);
      end;
   end;
end;

procedure map_psDef;
var i:integer;
begin
   for i:=0 to MaxPlayers do
   begin
      map_psx[i]:=-5000;
      map_psy[i]:=-5000;
      with _players[i] do ai_skill:=((_mcmp_sm mod 12) div 2)+1;
   end;
end;

procedure _CMPMap;
var i:byte;
begin
   map_psDef;
   map_obs:=1;
   cmp_hellagr:=false;
///////////////////////////////////////////////////////////////////     HELL
///////////////////////////////////    PHOBOS
   case _mcmp_sm of
1: begin
      map_trt     := 3;
      map_lqt     := 0;
      map_mw      := 4000;
      cmp_portal  := 100;
      map_liq     := true;
      PlayerHuman := 1;
      map_seed    := 661;
      CalcMapVars;

      with _players[1]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=0;upgr[5]:=1;upgr[6]:=1;upgr[7]:=1;
         team   := 1;
         race   := r_hell;
         state  := PS_Play;
         alw_u  := [1,2];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
    ai_partpush := 0;
      end;

      with _players[3]do
      begin
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;

         alw_u  := [0,1,2,3];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
    ai_partpush := 0;
      end;
      with _players[4]do
      begin
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;

         alw_u  := [0,1,2,3];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
    ai_partpush := 0;
      end;

      map_psx[0]:=map_mw div 2;
      map_psy[0]:=map_psx[0];
      map_psx[1]:=map_mw div 4;
      map_psy[1]:=map_mw div 5;
      map_psx[2]:=map_mw-map_psy[1];
      map_psy[2]:=map_mw-map_psx[1];
      map_psx[3]:=map_psx[1];
      map_psy[3]:=map_psy[2];
      map_psx[4]:=map_psx[2];
      map_psy[4]:=map_psy[1];

      _unit_add(map_psx[0],map_psy[0],UID_UACPortal,1);

      cmp_base2(map_psx[0],map_psy[0],400,3);
      cmp_defbase(map_psx[1],map_psy[1],3,2,[]);
      cmp_defbase(map_psx[2]+1,map_psy[2],4,2,[]);
      cmp_defbase(map_psx[3],map_psy[3]+1,3,2,[]);
      cmp_defbase(map_psx[4],map_psy[4]+1,4,2,[]);

      cmp_base3(map_psx[0]-base_rr,map_psy[0],3,1);
      cmp_base3(map_psx[0]+base_rr+30,map_psy[0]-90,3,1);
      cmp_base3(map_psx[0]+60,map_psy[0]+base_rr,4,1);
      cmp_base3(map_psx[0],map_psy[0]-base_rr,4,1);
   end;
2: begin
      map_trt     := 3;
      map_lqt     := 0;
      map_mw      := 5000;
      cmp_portal  := 0;
      map_liq     := true;
      PlayerHuman := 1;
      map_seed    := 66;
      CalcMapVars;

      with _players[1]do
      begin
         team   := 1;
         race   := r_hell;
         state  := PS_Play;
         alw_u  := [1,2];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [0,1,2,4,5,6];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 0;
      end;

      with _players[2]do
      begin
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;
         alw_u  := [0,1,2];
         alw_b  := [2];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 50;
    ai_partpush := 1;
    ai_maxarmy  := 50;
      end;p_colors[2]:=c_aqua;
      with _players[3]do
      begin
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;

         alw_u  := [0,1,2];
         alw_b  := [1,2,3,4,5];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 100;
    ai_partpush := 0;
    ai_maxarmy  := 50;
      end;
      {with _players[4]do
      begin
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;

         alw_u  := [0,1,2];
         alw_b  := [1,2,3,5];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 40;
    ai_partpush := 10;
    ai_maxarmy  := 50;
      end;  }

      map_psx[0]:=map_mw div 4;
      map_psy[0]:=map_mw div 6;

      map_psx[1]:=map_mw-map_mw div 3;
      map_psy[1]:=map_mw-map_mw div 3;
      map_psx[2]:=map_psx[0];
      map_psy[2]:=map_mw-map_psy[0];
      map_psx[3]:=map_mw-map_psx[0];
      map_psy[3]:=map_psy[0];

      cmp_defbase(map_psx[0],map_psy[0],1,2,[4,5]);

      cmp_defbase(map_psx[1],map_psy[1],3,2,[0]); _unit_add(map_psx[1],map_psy[1],UID_UACBase3,3);
      cmp_defbase(map_psx[2],map_psy[2],2,4,[]);
      cmp_defbase(map_psx[3],map_psy[3],2,4,[]);
   end;
3: begin
      map_trt     := 4;
      map_lqt     := 0;
      map_mw      := 5000;
      cmp_portal  := 0;
      map_liq     := true;
      PlayerHuman := 1;
      map_seed    := 1000;
      CalcMapVars;

      with _players[1]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;
         team   := 1;
         race   := r_hell;
         state  := PS_Play;
         alw_u  := [1,2];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [4,5,6];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 0;
    ai_skill    := 5;
      end;
      with _players[2]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;
         team   := 1;
         race   := r_hell;
         state  := PS_Comp;
         alw_u  := [1,2];
         alw_b  := [0,1,2,3,4];
         alw_up := [3,4,5,6];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 0;
    ai_skill    := 5;
      end;p_colors[2]:=c_orange;

      with _players[3]do
      begin upgr[3]:=1;upgr[6]:=1;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;

         alw_u  := [0];
         alw_b  := [1,2,3,4,5];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 50;
    ai_partpush := 10;
    ai_maxarmy  := 70;
      end;
      with _players[4]do
      begin upgr[6]:=1;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;

         alw_u  := [0,1,2,3,4,7];
         alw_b  := [1,2,3,4,5];
         alw_up := [0,1,2];
    ai_defense  := true;
    ai_minpush  := 100;
    ai_partpush := 35;
    ai_maxarmy  := 100;
    ai_skill    := 5;
      end;
      with _players[0]do
      begin upgr[6]:=1;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;

         alw_u  := [];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 100;
    ai_partpush := 35;
    ai_maxarmy  := 100;
    ai_skill    := 5;
      end;

      map_psx[0]:=map_mw-(map_mw div 3);
      map_psy[0]:=map_mw-(map_mw div 6);
      map_psx[1]:=map_psx[0]+base_rr;
      map_psy[1]:=map_psy[0]-base_rr;

      map_psx[2]:=map_mw-map_psx[0]+base_r;
      map_psy[2]:=map_mw-map_psy[0]+base_rr;
      map_psx[3]:=map_psx[2]-base_rr+100;
      map_psy[3]:=map_psy[2]+base_rr-100;
      map_psx[4]:=map_psx[2]+base_rr-100;
      map_psy[4]:=map_psy[2]-base_rr+100;

      cmp_defbase(map_psx[0],map_psy[0],1,2,[4,5]);
      cmp_defbase(map_psx[1],map_psy[1],2,2,[4,5]); _unit_add(map_psx[1]+120,map_psy[1]+150,UID_HellBarracks,2);

      _unit_add(map_psx[2],map_psy[2],UID_UACBase0,4);
      cmp_defbase(map_psx[3],map_psy[3],3,6,[]);
      cmp_defbase(map_psx[4],map_psy[4],3,6,[]);

      cmp_base3(3300 ,2600,0,1);
      cmp_base3(1100 ,4000,0,1);
      cmp_base3(4500 ,2000,0,1);
   end;
////////////////////////////////////////////////////////////////////////////////

4: begin     /////////////////////////        DEIMOS
      map_trt     := 2;
      map_lqt     := 1;
      map_mw      := 6000;
      cmp_portal  := 40;
      map_liq     := true;
      PlayerHuman := 1;
      map_seed    := 9999;
      CalcMapVars;

      with _players[1]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=1;upgr[5]:=1;upgr[6]:=1;upgr[7]:=1;
         team   := 1;
         race   := r_hell;
         state  := PS_Play;
         alw_u  := [0,1,2,3,4];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
    ai_partpush := 2;
      end;

      with _players[3]do
      begin
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;

         alw_u  := [0,1,2,3,4,5];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
    ai_partpush := 0;
      end;p_colors[3]:=c_aqua;
      with _players[4]do
      begin
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;

         alw_u  := [0,1,2,3,4,5];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
    ai_partpush := 0;
      end;p_colors[4]:=c_aqua;

      map_psx[0]:=map_mw div 2;
      map_psy[0]:=map_psx[0];
      map_psx[1]:=map_mw div 4;
      map_psy[1]:=map_mw div 5;
      map_psx[2]:=map_mw-map_psy[1];
      map_psy[2]:=map_mw-map_psx[1];
      map_psx[3]:=map_psx[1];
      map_psy[3]:=map_psy[2];
      map_psx[4]:=map_psx[2];
      map_psy[4]:=map_psy[1];

      _unit_add(map_psx[0],map_psy[0],UID_UACPortal,1);
      _unit_add(map_psx[0],map_psy[0],UID_Cyberdemon,1);
      with _units[_lau] do _uclord:=1;

      cmp_base2(map_psx[0],map_psy[0],400,4);
      cmp_defbase(map_psx[1],map_psy[1],4,1,[]);
      cmp_defbase(map_psx[2],map_psy[2],3,1,[5]);
      cmp_defbase(map_psx[3],map_psy[3],4,1,[5]);
      cmp_defbase(map_psx[4],map_psy[4],3,1,[]);

      cmp_base3(2300 ,2200,4,1);
      cmp_base3(3100 ,1500,3,1);
      cmp_base3(4100 ,3100,3,1);
      cmp_base3(3100 ,3900,4,1);
      cmp_base3(1000 ,3000,4,1);


      PlaySNDM(snd_hell);
   end;

5: begin
      map_trt     := 2;
      map_lqt     := 1;
      map_mw      := 5000;
      cmp_portal  := 0;
      map_liq     := true;
      PlayerHuman := 1;
      map_seed    := 9991;
      CalcMapVars;

      with _players[1]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=1;upgr[6]:=1;
         team   := 1;
         race   := r_hell;
         state  := PS_Play;
         alw_u  := [0,1,2,3,4];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [5,7];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 2;
      end;

      with _players[2]do
      begin  upgr[7]:=1;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;
         alw_u  := [0,1,2,3,5];
         alw_b  := [1,2,3,5];
         alw_up := [0,1,2];
    ai_defense  := true;
    ai_minpush  := 64;
    ai_partpush := 10;
    ai_maxarmy  := 65;
      end;p_colors[2]:=c_aqua;
      with _players[3]do
      begin    upgr[7]:=1;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;

         alw_u  := [0,1,2];
         alw_b  := [1,2,3,5];
         alw_up := [0,1,2];
    ai_defense  := true;
    ai_minpush  := 64;
    ai_partpush := 10;
    ai_maxarmy  := 65;
      end;
      with _players[4]do
      begin    upgr[7]:=1;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;

         alw_u  := [0,1,2,3,4,5];
         alw_b  := [1,2,3,4,5];
         alw_up := [0,1,2];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 20;
      end;

      map_psx[0]:=map_mw-(map_mw div 4);
      map_psy[0]:=map_mw div 6;

      map_psx[1]:=(map_mw div 3)-80;
      map_psy[1]:=map_mw-map_mw div 3;
      map_psx[2]:=map_psx[0];
      map_psy[2]:=map_mw-map_psy[0];
      map_psx[3]:=map_mw-map_psx[0]+80;
      map_psy[3]:=map_psy[0];

      _unit_add(map_psx[0]+100,map_psy[0]+80,UID_Cyberdemon,1);
      with _units[_lau] do _uclord:=1;
      cmp_defbase(map_psx[0],map_psy[0],1,1,[]);

      cmp_defbase(map_psx[1],map_psy[1],4,1,[0]);
      _unit_add(map_psx[1],map_psy[1],UID_UACBase1,4);
      cmp_base2(map_psx[1],map_psy[1],500,4);

      cmp_defbase(map_psx[2],map_psy[2],3,1,[]);
      cmp_defbase(map_psx[3],map_psy[3],2,1,[]);

      cmp_base3(3100 ,3200,2,1);
      cmp_base3(3300 ,2200,2,1);
      cmp_base3(2300 ,600 ,3,1);
      cmp_base3(2300 ,1400,2,1);
      cmp_base3(1200 ,1800,3,1);
      cmp_base3(4400 ,2600,3,1);
      cmp_base3(2700 ,4600,3,1);
      cmp_base3(2200 ,2300,2,1);
      cmp_base3(4400 ,3600,3,1);
   end;
6: begin
      map_trt     := 11;
      map_lqt     := 1;
      map_mw      := 5500;
      cmp_portal  := 0;
      map_liq     := true;
      PlayerHuman := 1;
      map_seed    := 9292;
      CalcMapVars;

      with _players[1]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=1;upgr[5]:=1;upgr[6]:=1;upgr[7]:=1;
         team   := 1;
         race   := r_hell;
         state  := PS_Play;
         alw_u  := [0,1,2,3,4];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [6];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 2;
      end;
      with _players[4]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=1;upgr[5]:=1;upgr[6]:=1;upgr[7]:=1;
         team   := 1;
         race   := r_hell;
         state  := PS_Comp;

         alw_u  := [0,1,2,3,4];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [6];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 0;
    ai_maxarmy  := 100;
      end;p_colors[4]:=c_orange;

      with _players[2]do
      begin  upgr[4]:=1; upgr[2]:=1;upgr[3]:=1;  upgr[6]:=1; upgr[0]:=1;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;
         alw_u  := [0,1,2,3,4,5,7];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 100;
    ai_partpush := 20;
    ai_maxarmy  := 100;
      end;p_colors[2]:=c_aqua;
      with _players[3]do
      begin   upgr[2]:=1;upgr[3]:=1; upgr[6]:=1; upgr[1]:=1;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;

         alw_u  := [0,1,2,3,4,5];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
    ai_partpush := 20;
    ai_maxarmy  := 100;
      end;p_colors[3]:=c_lime;

      map_psx[0]:=map_mw-(map_mw div 4);
      map_psy[0]:=map_mw div 2;
      map_psx[4]:=map_psx[0]-100;
      map_psy[4]:=map_psy[0]-base_rr;

      map_psx[1]:=map_mw div 4;
      map_psy[1]:=(map_mw div 4)+base_r;
      map_psx[2]:=map_psx[1]+base_r;
      map_psy[2]:=map_mw div 2;
      map_psx[3]:=map_psx[1]+base_rr;
      map_psy[3]:=map_mw-map_psy[1];

      _unit_add(map_psx[0]+100,map_psy[0]+80,UID_Cyberdemon,1);
      with _units[_lau] do _uclord:=1;
      cmp_defbase(map_psx[0],map_psy[0],1,1,[3]);
      cmp_defbase(map_psx[4],map_psy[4],4,1,[3]);
      _unit_add(4400,2300,UID_HellAltar,4);
      _unit_add(4350,1650,UID_HellPool,4);

      cmp_defbase(map_psx[2],map_psy[2],2,1,[0]);
      _unit_add(map_psx[2],map_psy[2],UID_UACBase5,2);
      cmp_base2(map_psx[2],map_psy[2],500,2);

      cmp_defbase(map_psx[1],map_psy[1],3,1,[]);
      cmp_defbase(map_psx[3],map_psy[3],3,1,[]);

      _unit_add(4550,2050,UID_HellBarracks,4);
      _unit_add(4600,2450,UID_HellBarracks,4);
   end;
////////////////////////////////////////////////////////////////////////////////

7: begin     /////////////////////////        MARS
      map_trt     := 8;
      map_lqt     := 2;
      map_mw      := 4000;
      cmp_portal  := 0;
      map_liq     := false;
      PlayerHuman := 1;
      map_seed    := 1166;
      CalcMapVars;

      with _players[1]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=1;upgr[5]:=1;upgr[6]:=1;upgr[7]:=1;
         team   := 1;
         race   := r_hell;
         state  := PS_Play;
         alw_u  := [0,1,2,5];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 0;
      end;

      with _players[2]do
      begin
         upgr[3]:=1;upgr[6]:=1;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;

         alw_u  := [0,1,2,3];
         alw_b  := [1,2,4,3];
         alw_up := [7];
    ai_defense  := true;
    ai_minpush  := 0;
    ai_partpush := 20;
    ai_maxarmy  := 60;
      end;   p_colors[2]:=c_aqua;
      with _players[3]do
      begin
         upgr[3]:=1;upgr[6]:=1;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;

         alw_u  := [0,1,2];
         alw_b  := [2,4,3];
         alw_up := [7];
    ai_defense  := true;
    ai_minpush  := 59;
    ai_partpush := 20;
    ai_maxarmy  := 60;
      end;
      with _players[4]do
      begin
         upgr[3]:=1;upgr[4]:=1;upgr[6]:=1;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;

         alw_u  := [0,1,2,7];
         alw_b  := [2,4];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 59;
    ai_partpush := 30;
    ai_maxarmy  := 60;
      end;

      map_psx[0]:=map_mw div 6;
      map_psy[0]:=map_mw div 6;

      map_psx[1]:=-map_mw;
      map_psy[1]:=-map_mw;
      map_psx[2]:=map_mw div 4;
      map_psy[2]:=map_mw-map_psx[2];
      map_psx[3]:=map_mw-map_psx[2];
      map_psy[3]:=map_mw-map_psy[2];
      map_psx[4]:=map_mw-(map_mw div 3);
      map_psy[4]:=map_psx[4];

      _unit_add(map_psx[0],map_psy[0],UID_Marker,1);

      _unit_add(map_psx[0]-300,map_psy[0]-200,UID_UACBarracks,2);
      _unit_add(map_psx[0]-250,map_psy[0],UID_UACBarracks,2);
      _unit_add(map_psx[0]-50,map_psy[0]-350,UID_UACBarracks,2);

      cmp_defbase(map_psx[0]+100,map_psy[0],2,4,[0,1]);

      cmp_defbase(map_psx[2],map_psy[2],4,1,[]);
      cmp_defbase(map_psx[3],map_psy[3],3,3,[]);
      cmp_defbase(map_psx[4],map_psy[4],2,2,[]);

      PlaySNDM(snd_hell);
   end;
8: begin
      map_trt     := 8;
      map_lqt     := 2;
      map_mw      := 6000;
      cmp_portal  := 0;
      map_liq     := false;
      PlayerHuman := 1;
      map_seed    := 1116;
      CalcMapVars;

      with _players[1]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=1;upgr[6]:=1;
         team   := 1;
         race   := r_hell;
         state  := PS_Play;
         alw_u  := [0,1,2,3,4,5,6];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [5,7];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 5;
      end;

      with _players[0]do
      begin
         upgr[3]:=1;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;
         alw_u  := [0,1,3,7];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [0,1,2,3,5,6,7];
    ai_defense  := true;
    ai_minpush  := 35;
    ai_partpush := 10;
    ai_maxarmy  := 60;
      end;p_colors[0]:=c_white;
      with _players[2]do
      begin
         upgr[3]:=1; upgr[6]:=1;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;
         alw_u  := [0,1,2];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [0,1,2,3,5,6];
    ai_defense  := true;
    ai_minpush  := 35;
    ai_partpush := 10;
    ai_maxarmy  := 60;
      end;p_colors[2]:=c_aqua;
      with _players[3]do
      begin
         upgr[3]:=1;upgr[4]:=1; upgr[6]:=1;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;

         alw_u  := [0,1,2,3,5,7];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [0,1,2,3];
    ai_defense  := true;
    ai_minpush  := 50;
    ai_partpush := 20;
    ai_maxarmy  := 60;
      end;
      with _players[4]do
      begin
         upgr[3]:=1;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;

         alw_u  := [0,1,2,3,4,5,6];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [0,1,2,3,6,7];
    ai_defense  := true;
    ai_minpush  := 50;
    ai_partpush := 20;
    ai_maxarmy  := 60;
    ai_skill    := 5;
      end;

      map_psx[0]:=map_mw-base_rr;
      map_psy[0]:=map_mw div 3;

      map_psx[1]:=map_mw div 5;
      map_psy[1]:=map_mw div 5;
      map_psx[2]:=map_psx[1]+base_r;
      map_psy[2]:=map_mw div 2;
      map_psx[3]:=map_mw div 4;
      map_psy[3]:=map_mw-map_psx[3];
      map_psx[4]:=map_mw-map_psx[1];
      map_psy[4]:=map_mw-map_psy[1];

      _unit_add(map_psx[0]+100,map_psy[0]+80,UID_Cyberdemon,1);
      _unit_add(map_psx[0]-100,map_psy[0]-80,UID_Mastermind,1);
      cmp_defbase(map_psx[0],map_psy[0],1,2,[3]);

      cmp_defbase(map_psx[1],map_psy[1],0,3,[0]);_unit_add(map_psx[1],map_psy[1],UID_UACBase3,0);
      cmp_defbase(map_psx[2],map_psy[2],3,3,[0]);_unit_add(map_psx[2],map_psy[2],UID_UACBase4,3);
      cmp_defbase(map_psx[3],map_psy[3],4,3,[0]);_unit_add(map_psx[3],map_psy[3],UID_UACBase0,4);
      cmp_defbase(map_psx[4],map_psy[4],2,3,[0]);_unit_add(map_psx[4],map_psy[4],UID_UACBase1,2);

      _unit_add(map_psx[0]-120,map_psy[0]-150,UID_HellBarracks,1);
   end;

///////////////////////////////////////////  EARTH
9: begin
      map_trt     := 5;
      map_lqt     := 0;
      map_mw      := 6000;
      cmp_portal  := 0;
      map_liq     := true;
      PlayerHuman := 1;
      map_seed    := 379;
      CalcMapVars;

      with _players[1]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=1;upgr[5]:=1;upgr[6]:=1;upgr[7]:=1;
         team   := 1;
         race   := r_hell;
         state  := PS_Play;
         alw_u  := [0,1,2,3,4,5,6];
         alw_b  := [1,2,3,4,5];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 0;
      end;

      with _players[0]do
      begin
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;
         alw_u  := [0,3,7];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [0,1,2,3,7];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 20;
    ai_maxarmy  := 100;
      end;p_colors[0]:=c_white;
      with _players[2]do
      begin
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;
         alw_u  := [0,1,2,3,4,5,6];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [0,1,2,3,5,6,7];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 20;
    ai_maxarmy  := 100;
      end;p_colors[2]:=c_aqua;
      with _players[3]do
      begin
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;
         alw_u  := [0,1,2,3,5];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [0,1,2,3,5,6,7];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 20;
    ai_maxarmy  := 100;
      end;
      with _players[4]do
      begin
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;
         alw_u  := [0,1,3,5,6];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [0,1,2,3,5,6,7];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 20;
    ai_maxarmy  := 100;
      end;

      map_psx[0]:=map_mw div 2;
      map_psy[0]:=map_psx[0];

      map_psx[1]:=map_mw div 4;
      map_psy[1]:=map_mw div 4;

      map_psx[2]:=5200;
      map_psy[2]:=2500;

      map_psx[3]:=map_mw div 3;
      map_psy[3]:=map_mw-(map_mw div 5);

      map_psx[4]:=4800;
      map_psy[4]:=4800;

      _unit_add(map_psx[0],map_psy[0],UID_Marker,1);

      cmp_defbase(map_psx[3],map_psy[3],4,1,[0]);
      _unit_add(map_psx[3],map_psy[3],UID_UACBase3,4);
      cmp_base2(map_psx[3],map_psy[3],500,4);

      cmp_defbase(map_psx[1],map_psy[1],3,2,[0]);
      _unit_add(map_psx[1],map_psy[1],UID_UACBase4,3);
      cmp_base2(map_psx[1]-70,map_psy[1],500,3);

      cmp_defbase(map_psx[2],map_psy[2],2,1,[0]);
      _unit_add(map_psx[2],map_psy[2],UID_UACBase5,2);
      cmp_base2(map_psx[2],map_psy[2],500,2);

      cmp_defbase(map_psx[4],map_psy[4],0,2,[0]);
      _unit_add(map_psx[4],map_psy[4],UID_UACBase0,0);
      cmp_base2(map_psx[4],map_psy[4],500,0);

      _unit_add(3250,650,UID_Build,2);
      _unit_add(3550,650,UID_Build,2);
      _unit_add(3850,650,UID_Build,2);
      _unit_add(4150,650,UID_Build,2);
      _unit_add(4450,650,UID_Build,2);
      _unit_add(4750,750,UID_Build,2);
      _unit_add(5050,750,UID_Build,2);
      _unit_add(4750,1050,UID_Build,2);
      _unit_add(5050,1050,UID_Build,2);
      _unit_add(4750,1350,UID_Build,2);
      _unit_add(5050,1350,UID_Build,2);

      _unit_add(3400,2500,UID_Build,0);
      _unit_add(3700,2500,UID_Build,0);
      _unit_add(4000,2500,UID_Build,0);
      _unit_add(4300,2500,UID_Build,0);
      _unit_add(4000,2800,UID_Build,0);
      _unit_add(4270,2800,UID_Build,0);

      _unit_add(4000,4900,UID_Build,0);
      _unit_add(3700,5200,UID_Build,0);
      _unit_add(3700,4900,UID_Build,0);
      _unit_add(3400,4900,UID_Build,0);
      _unit_add(3700,4600,UID_Build,0);
      _unit_add(3400,4600,UID_Build,0);

      _unit_add(2900,1300,UID_Build,0);
      _unit_add(2900,1600,UID_Build,0);
      _unit_add(2900,1900,UID_Build,0);
      _unit_add(2900,2200,UID_Build,0);

      _unit_add(2300,2400,UID_Build,2);
      _unit_add(2300,1700,UID_Build,2);

      _unit_add(4000,3200,UID_Build,2);
      _unit_add(4000,3500,UID_Build,2);
      _unit_add(4000,3700,UID_Build,2);
      _unit_add(4000,4000,UID_Build,2);
      _unit_add(4000,4300,UID_Build,2);

      _unit_add(400 ,2600,UID_Build,3);
      _unit_add(700 ,2600,UID_Build,3);

      _unit_add(1800 ,3600,UID_Build,3);
      _unit_add(1800 ,3900,UID_Build,3);
      _unit_add(2100 ,3600,UID_Build,3);
      _unit_add(2100 ,3900,UID_Build,3);
      _unit_add(2400 ,3600,UID_Build,3);
      _unit_add(2400 ,3900,UID_Build,3);
      _unit_add(2700 ,3600,UID_Build,3);
      _unit_add(2700 ,3900,UID_Build,3);

      _unit_add(1050,4900,UID_Build,4);
      _unit_add(750,4600,UID_Build,4);
      _unit_add(750,4900,UID_Build,4);
      _unit_add(450,4300,UID_Build,4);
      _unit_add(450,4600,UID_Build,4);
      _unit_add(450,4900,UID_Build,4);

      PlaySNDM(snd_hell);
   end;
10: begin
      map_trt     := 6;
      map_lqt     := 1;
      map_mw      := 5000;
      cmp_portal  := 0;
      map_liq     := true;
      PlayerHuman := 1;
      map_seed    := 324123;
      CalcMapVars;

      with _players[1]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=1;upgr[5]:=1;upgr[6]:=1;upgr[7]:=1;
         team   := 1;
         race   := r_hell;
         state  := PS_Play;
         alw_u  := [];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 0;
      end;

      with _players[2]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=1;upgr[5]:=1;upgr[6]:=1;upgr[7]:=1;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;
         alw_u  := [0,1,2,3,4,5,6];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [0,1,2,3,5,6,7];
    ai_defense  := true;
    ai_minpush  := 0;
    ai_partpush := 5;
    ai_maxarmy  := 100;
      end;p_colors[2]:=c_aqua;
      with _players[3]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=1;upgr[5]:=1;upgr[6]:=1;upgr[7]:=1;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;
         alw_u  := [0,1,2,3,4,5,6];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [0,1,2,3,5,6];
    ai_defense  := true;
    ai_minpush  := 0;
    ai_partpush := 5;
    ai_maxarmy  := 100;
      end;
      with _players[4]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=1;upgr[5]:=1;upgr[6]:=1;upgr[7]:=1;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;
         alw_u  := [0,1,2,3,4,5,6];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [0,1,2,3,5,6];
    ai_defense  := true;
    ai_minpush  := 0;
    ai_partpush := 5;
    ai_maxarmy  := 100;
      end;

      map_psx[0]:=map_mw;
      map_psy[0]:=map_psx[0];

      map_psx[1]:=-map_mw;
      map_psx[2]:=-map_mw;
      map_psx[3]:=-map_mw;
      map_psx[4]:=-map_mw;


      _unit_add(900,3500,UID_UACBase0,2);
      _unit_add(2200,1600,UID_UACBase5,2);
      _unit_add(3850,1150,UID_UACBase1,3);
      _unit_add(4100,3900,UID_UACBase5,3);
      _unit_add(1500,1000,UID_UACBase3,4);
      _unit_add(3100,3100,UID_UACBase4,4);

      _unit_add(850,300,UID_Build,4);
      _unit_add(1900,2700,UID_Build,4);
      _unit_add(1900,3000,UID_Build,4);
      _unit_add(3900,2500,UID_Build,4);
      _unit_add(2800,1100,UID_Build,4);
      _unit_add(2000,3600,UID_Build,4);

      _unit_add(map_psx[0],map_psy[0],UID_Mastermind,1);
      with _units[_lau] do begin mx:=x-400;my:=y-400;end;

      map_seed:=123;cmp_hellworld(2);
      map_seed:=322;cmp_hellworld(3);
      map_seed:=217;cmp_hellworld(4);
   end;
11: begin
      map_trt     := 7;
      map_lqt     := 0;
      map_mw      := 4000;
      cmp_portal  := 0;
      map_liq     := false;
      PlayerHuman := 1;
      map_seed    := 3123;
      CalcMapVars;

      with _players[1]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=1;upgr[5]:=1;upgr[6]:=1;upgr[7]:=1;
         team   := 1;
         race   := r_hell;
         state  := PS_Play;
         alw_u  := [];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 0;
      end;

      with _players[2]do
      begin
         upgr[0]:=1;upgr[1]:=0;upgr[2]:=0;upgr[3]:=1;upgr[4]:=0;upgr[5]:=1;upgr[6]:=1;upgr[7]:=1;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;
         alw_u  := [0,1,2,3,4,5,6,7];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [0,1,2,3,5,6];
    ai_defense  := true;
    ai_minpush  := 0;
    ai_partpush := 5;
    ai_maxarmy  := 100;
      end;p_colors[2]:=c_white;
      with _players[3]do
      begin
         upgr[0]:=1;upgr[1]:=0;upgr[2]:=0;upgr[3]:=1;upgr[4]:=1;upgr[5]:=1;upgr[6]:=1;upgr[7]:=0;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;
         alw_u  := [0,1,2,3,4,5,6,7];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [0,1,2,3,5,6];
    ai_defense  := true;
    ai_minpush  := 0;
    ai_partpush := 5;
    ai_maxarmy  := 100;
      end;p_colors[3]:=c_white;
      with _players[4]do
      begin
         upgr[0]:=1;upgr[1]:=0;upgr[2]:=0;upgr[3]:=1;upgr[4]:=0;upgr[5]:=1;upgr[6]:=1;upgr[7]:=0;
         team   := 2;
         race   := r_uac;
         state  := PS_Comp;
         alw_u  := [0,1,2,3,4,5,6,7];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [0,1,2,3,5,6];
    ai_defense  := true;
    ai_minpush  := 0;
    ai_partpush := 5;
    ai_maxarmy  := 100;
      end;p_colors[4]:=c_white;

      map_psx[0]:=map_mw;
      map_psy[0]:=map_psx[0];

      map_psx[1]:=map_mw div 2;
      map_psy[1]:=map_mw div 2;

      map_psx[2]:=map_psx[1]-base_rr;
      map_psy[2]:=map_psy[1]-base_rr;

      map_psx[3]:=map_psx[1]+base_rr;
      map_psy[3]:=map_psy[1]-base_rr;

      map_psx[4]:=map_psx[1]-base_rr;
      map_psy[4]:=map_psy[1]+base_rr;

      cmp_defbase(map_psx[1],map_psy[1],2,1,[0]); _unit_add(map_psx[1],map_psy[1],UID_UACBase0,2);
      cmp_defbase(map_psx[2],map_psy[2],3,1,[0]); _unit_add(map_psx[2],map_psy[2],UID_UACBase0,3);
      cmp_defbase(map_psx[3],map_psy[3],2,1,[0]); _unit_add(map_psx[3],map_psy[3],UID_UACBase0,2);
      cmp_defbase(map_psx[4],map_psy[4],3,1,[0]); _unit_add(map_psx[4],map_psy[4],UID_UACBase0,3);

      _unit_add(2800,3000,UID_UACSPort,4);
      _unit_add(3300,1600,UID_UACSPort,4);
      _unit_add(2000,2800,UID_UACSPort,4);
      _unit_add(2000,600,UID_UACSPort,4);
      _unit_add(750,2300,UID_UACSPort,4);
      _unit_add(1500,3500,UID_UACSPort,4);

      _unit_add(map_psx[0],map_psy[0],UID_Mastermind,1);
      with _units[_lau] do begin mx:=x-400;my:=y-400;end;
   end;
////////////////////////////////////////////////////////////////////////////////   UAC

12: begin      ///////////////////////////////////   PHOBOS
      map_trt     := 4;
      map_lqt     := 0;
      map_mw      := 6000;
      cmp_portal  := 0;
      map_liq     := true;
      PlayerHuman := 4;
      map_seed    := 2661;
      CalcMapVars;

      with _players[1]do
      begin
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [1,2];
         alw_u        := [1,2];
         alw_up       := [0,1,5,6];
         ai_defense   := true;
         ai_minpush   := 0;
         ai_partpush  := 25;
         ai_maxarmy   := 70;
      end;
      with _players[2]do
      begin
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [0,1,2,3];
         alw_u        := [1,2];
         alw_up       := [0,1,5,6];
         ai_defense   := true;
         ai_minpush   := 0;
         ai_partpush  := 25;
         ai_maxarmy   := 70;
      end;
      with _players[3]do
      begin
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [0,1,2,3];
         alw_u        := [1,2];
         alw_up       := [0,1,5,6];
         ai_defense   := true;
         ai_minpush   := 0;
         ai_partpush  := 0;
         ai_maxarmy   := 70;
      end;p_colors[3]:=c_orange;

      with _players[4]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=0;upgr[3]:=0;upgr[4]:=0;upgr[5]:=1;upgr[6]:=0;upgr[7]:=0;
         team         := 1;
         race         := r_uac;
         state        := PS_Play;
         alw_b        := [];
         alw_u        := [];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 10;
         ai_partpush  := 0;
      end;p_colors[4]:=c_lime;
      with _players[0]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=0;upgr[3]:=0;upgr[4]:=0;upgr[5]:=1;upgr[6]:=0;upgr[7]:=0;
         team         := 1;
         race         := r_uac;
         state        := PS_Comp;
         alw_b        := [4];
         alw_u        := [1,2,3];
         alw_up       := [0];
         ai_defense   := true;
         ai_minpush   := 100;
         ai_partpush  := 0;
         ai_maxarmy   := 35;
      end;p_colors[0]:=c_aqua;

      map_psx[0]:=0;
      map_psy[0]:=0;
      map_psx[1]:=map_mw-(map_mw div 4);
      map_psy[1]:=map_mw div 3;
      map_psx[2]:=map_mw div 6;
      map_psy[2]:=map_mw-(map_mw div 3);
      map_psx[3]:=map_mw-(map_mw div 7);
      map_psy[3]:=map_mw-(map_mw div 5);
      map_psx[4]:=2200;
      map_psy[4]:=map_mw-(map_mw div 7);

      g_MakeMap;


      _unit_add(map_psx[4],map_psy[4],UID_UACComCenter,0);    with _units[_lau] do begin mhits:=7000; hits:=50; end;
      _unit_add(map_psx[4]+122,map_psy[4],UID_UACGenerator,0);with _units[_lau] do begin hits:=100+random(300); end;
      _unit_add(map_psx[4]+192,map_psy[4],UID_UACTurret,0);   with _units[_lau] do begin hits:=100+random(300); end;
      _unit_add(map_psx[4]-122,map_psy[4],UID_UACGenerator,0);with _units[_lau] do begin hits:=100+random(300); end;
      _unit_add(map_psx[4]-192,map_psy[4],UID_UACTurret,0);   with _units[_lau] do begin hits:=100+random(300); end;
      _unit_add(map_psx[4],map_psy[4]-152,UID_UACBarracks,0); with _units[_lau] do begin hits:=100+random(300); end;
      _unit_add(map_psx[4],map_psy[4]-222,UID_UACTurret,0);   with _units[_lau] do begin hits:=100+random(300); end;
      _unit_add(map_psx[4],map_psy[4],UID_Sergant,0);
      _unit_add(map_psx[4],map_psy[4],UID_Sergant,0);
      _unit_add(map_psx[4],map_psy[4],UID_Sergant,0);
      _unit_add(map_psx[4],map_psy[4],UID_Commando,0);
      _unit_add(map_psx[4],map_psy[4],UID_Commando,0);
      _unit_add(map_psx[4],map_psy[4],UID_Commando,0);
      _unit_add(map_psx[4],map_psy[4],UID_Medic,0);
      _unit_add(map_psx[4],map_psy[4],UID_Medic,0);
      _unit_add(map_psx[4],map_psy[4],UID_Medic,0);

      _unit_add(map_psx[4],map_psy[4]-1,UID_Marker,1);


      _unit_add(3060,1110,UID_HellBarracks,1);
      _unit_add(2050,1300,UID_HellBarracks,2);
      _unit_add(1250,2020,UID_HellBarracks,3);
      _unit_add(2150,3100,UID_HellBarracks,1);
      _unit_add(600 ,300 ,UID_HellBarracks,2);
      _unit_add(5200,5300,UID_HellBarracks,3);

      _unit_add(100,100,UID_Medic,4);
      _unit_add(130,100,UID_Medic,4);
      _unit_add(160,100,UID_Medic,4);
      _unit_add(190,100,UID_Engineer,4);
      _unit_add(100,130,UID_Engineer,4);
      _unit_add(130,130,UID_Engineer,4);
      _unit_add(160,130,UID_Sergant,4);
      _unit_add(190,130,UID_Sergant,4);
      _unit_add(100,160,UID_Sergant,4);
      _unit_add(130,160,UID_Sergant,4);
      _unit_add(160,160,UID_Commando,4);
      _unit_add(190,160,UID_Commando,4);
      _unit_add(100,190,UID_Commando,4);
      _unit_add(130,190,UID_Commando,4);

      cmp_defbase(map_psx[1],map_psy[1],1,1,[5]);
      cmp_defbase(map_psx[2],map_psy[2],2,1,[5]);
      cmp_defbase(map_psx[3],map_psy[3],3,1,[5]);
   end;
13: begin
      map_trt     := 3;
      map_lqt     := 0;
      map_mw      := 6000;
      cmp_portal  := 0;
      map_liq     := true;
      PlayerHuman := 4;
      map_seed    := 2161;
      CalcMapVars;

      with _players[0]do
      begin menerg:= 10;
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [2,4];
         alw_u        := [1,2];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 0;
         ai_partpush  := 0;
      end;p_colors[0]:=c_orange;
      with _players[1]do
      begin  menerg:= 10;
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [2,4];
         alw_u        := [1,2];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 0;
         ai_partpush  := 0;
      end;
      with _players[2]do
      begin  menerg:= 10;
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [2,4];
         alw_u        := [1,2];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 0;
         ai_partpush  := 0;
      end;

      with _players[3]do
      begin
         team         := 1;
         race         := r_uac;
         state        := PS_Comp;
         alw_b        := [];
         alw_u        := [1,2,3];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 14;
         ai_partpush  := 0;
         ai_maxarmy   := 15;
      end;p_colors[3]:=c_white;
      with _players[4]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=0;upgr[4]:=0;upgr[5]:=1;upgr[6]:=0;upgr[7]:=0;
         team         := 1;
         race         := r_uac;
         state        := PS_Play;
         alw_b        := [1,2,4,5];
         alw_u        := [0,1,2,3];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 50;
         ai_partpush  := 5;
      end;p_colors[4]:=c_lime;

      map_psx[0]:=map_mw;
      map_psy[0]:=0;
      map_psx[1]:=map_mw div 4;
      map_psy[1]:=map_mw div 4;
      map_psx[2]:=map_mw div 6;
      map_psy[2]:=map_mw-(map_mw div 4);
      map_psx[3]:=map_mw-(map_mw div 7);
      map_psy[3]:=map_mw-(map_mw div 5);
      map_psx[4]:=map_mw div 2;
      map_psy[4]:=map_mw-(map_mw div 3);

      g_MakeMap;

      _unit_add(1900,2500,UID_UACBase2,3);
      with _units[_lau] do begin dsbl:=true;fog_c[fx,fy]:=0;hits:=mhits div 3;end;

      _unit_add(1500,5400,UID_UACBase2,3);
      with _units[_lau] do begin dsbl:=true;fog_c[fx,fy]:=0;hits:=mhits div 3;end;

      _unit_add(3900,1400,UID_UACBase2,3);
      with _units[_lau] do begin dsbl:=true;fog_c[fx,fy]:=0;hits:=mhits div 3;end;

      _unit_add(4800,2600,UID_UACBase2,3);
      with _units[_lau] do begin dsbl:=true;fog_c[fx,fy]:=0;hits:=mhits div 3;end;

      _unit_add(3500,4900,UID_UACBase2,3);
      with _units[_lau] do begin dsbl:=true;fog_c[fx,fy]:=0;hits:=mhits div 3;end;

      _unit_add(map_mw-base_rr+150,base_rr-150,UID_UACBarracks,3);

      //cmp_defbase(map_psx[0],map_psy[0],4,3,[0,3,5]);
      _unit_add(map_mw-base_rr,base_rr,UID_UACBase1,4);
      with _units[_lau] do begin dsbl:=true;fog_c[fx,fy]:=0;hits:=mhits div 3;end;

      _unit_add(map_mw-base_rr,base_rr-1,UID_InvBase,3);
      _unit_add(map_mw-base_rr,base_rr,UID_Sergant,3);
      _unit_add(map_mw-base_rr,base_rr,UID_Commando,3);
      _unit_add(map_mw-base_rr,base_rr,UID_Sergant,3);
      _unit_add(map_mw-base_rr,base_rr,UID_Commando,3);
      _unit_add(map_mw-base_rr,base_rr,UID_Medic,3);
      _unit_add(map_mw-base_rr,base_rr,UID_Medic,3);
      _unit_add(map_mw-base_rr,base_rr,UID_Commando,3);

      _unit_add(map_mw-100,100,UID_Medic,4);
      _unit_add(map_mw-190,100,UID_Engineer,4);
      _unit_add(map_mw-160,130,UID_Sergant,4);
      _unit_add(map_mw-190,130,UID_Sergant,4);
      _unit_add(map_mw-160,160,UID_Commando,4);
      _unit_add(map_mw-190,160,UID_Commando,4);


      _unit_add(3800,1200,UID_Baron,0);  with _units[_lau] do begin mx:=map_mw-base_rr;my:=base_rr; order:=1; end;
      _unit_add(4300,1200,UID_Baron,0);  with _units[_lau] do begin mx:=map_mw-base_rr;my:=base_rr; order:=1; end;
      _unit_add(4500,1200,UID_Baron,0);  with _units[_lau] do begin mx:=map_mw-base_rr;my:=base_rr; order:=1; end;
      _unit_add(5500,1300,UID_Baron,0);  with _units[_lau] do begin mx:=map_mw-base_rr;my:=base_rr; order:=1; end;
      _unit_add(5500,1300,UID_Baron,0);  with _units[_lau] do begin mx:=map_mw-base_rr;my:=base_rr; order:=1; end;

      cmp_defbase(map_psx[1],map_psy[1]+1,1,4,[3]);_unit_add(map_psx[1],map_psy[1]-150,UID_HellBarracks,1);
      cmp_defbase(map_psx[2],map_psy[2]-1,2,4,[3]);_unit_add(map_psx[2],map_psy[2]-150,UID_HellBarracks,2);
      cmp_defbase(map_psx[3],map_psy[3]+1,1,4,[3]);
      cmp_defbase(map_psx[4],map_psy[4]+1,0,4,[3]);_unit_add(map_psx[4],map_psy[4]-150,UID_HellBarracks,0);

   end;
14: begin     //
      map_trt     := 3;
      map_lqt     := 0;
      map_mw      := 5000;
      cmp_portal  := 600;
      map_liq     := true;
      PlayerHuman := 4;
      map_seed    := 5456;
      CalcMapVars;

      with _players[1]do
      begin  upgr[4]:=1;
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [1,4];
         alw_u        := [1,2];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 90;
         ai_partpush  := 25;
         ai_maxarmy   := 100;
      end;
      with _players[2]do
      begin
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [1,4];
         alw_u        := [1,2];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 0;
         ai_partpush  := 5;
         ai_maxarmy   := 60;
      end;
      with _players[3]do
      begin
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [1,4];
         alw_u        := [1,2];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 25;
         ai_partpush  := 5;
         ai_maxarmy   := 60;
      end;p_colors[3]:=c_orange;
      with _players[0]do
      begin
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [];
         alw_u        := [4];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 0;
         ai_partpush  := 0;
         ai_maxarmy   := 100;
      end;p_colors[0]:=rgba2c(255,0,255,255);

      with _players[4]do
      begin
         upgr[0]:=0;upgr[1]:=1;upgr[2]:=0;upgr[3]:=1;upgr[4]:=0;upgr[5]:=0;upgr[6]:=0;upgr[7]:=0;
         team         := 1;
         race         := r_uac;
         state        := PS_Play;
         alw_b        := [0,1,2,3,4,5];
         alw_u        := [0,1,2,3,4,7];
         alw_up       := [0,1,2,3,5,6,7];
         ai_defense   := true;
         ai_minpush   := 90;
         ai_partpush  := 10;
      end;p_colors[4]:=c_lime;

      map_psx[0]:=map_mw div 3;
      map_psy[0]:=map_mw-base_rr;

      map_psx[1]:=map_mw-map_psx[0];
      map_psy[1]:=map_mw div 4;
      map_psx[2]:=map_psx[1];
      map_psy[2]:=map_psy[1]-base_rr;
      map_psx[3]:=map_psx[1]-base_rr-50;
      map_psy[3]:=map_psy[1];
      map_psx[4]:=map_psx[1]+base_rr;
      map_psy[4]:=map_psy[1]+base_r;

      g_MakeMap;

      cmp_defbase(map_psx[0],map_psy[0],4,1,[]);

      cmp_defbase(map_psx[1],map_psy[1],0,1,[0,1,2,3,5]);
      _unit_add(map_psx[1],map_psy[1],UID_UACPortal,0);
      with _units[_lau] do invuln:=true;

      cmp_defbase(map_psx[2],map_psy[2],2,2,[]);_unit_add(map_psx[2]+120,map_psy[2]+150,UID_HellBarracks,2);
      cmp_defbase(map_psx[3],map_psy[3],3,2,[]);_unit_add(map_psx[3]+120,map_psy[3]+150,UID_HellBarracks,3);
      cmp_defbase(map_psx[4],map_psy[4],1,2,[]);
   end;
15: begin     /////////////////////////        DEIMOS
      map_trt     := 11;
      map_lqt     := 1;
      map_mw      := 5000;
      cmp_portal  := 60;
      map_liq     := true;
      PlayerHuman := 4;
      map_seed    := 96564;
      CalcMapVars;

      with _players[1]do
      begin  upgr[4]:=1;
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [1,2,4];
         alw_u        := [0,1,2,3,4];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 50;
         ai_partpush  := 0;
         ai_maxarmy   := 100;
      end;
      with _players[2]do
      begin  upgr[4]:=1;
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [1,2,4];
         alw_u        := [0,1,2,3,4];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 0;
         ai_partpush  := 0;
         ai_maxarmy   := 100;
      end;

      {with _players[3]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=0;upgr[5]:=1;upgr[6]:=1;upgr[7]:=1;
         team         := 1;
         race         := r_uac;
         state        := PS_Comp;
         alw_b        := [];
         alw_u        := [0,1,2,3,4,5];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 0;
         ai_partpush  := 0;
      end;p_colors[3]:=c_aqua;  }
      with _players[4]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=0;upgr[5]:=1;upgr[6]:=0;upgr[7]:=1;
         team         := 1;
         race         := r_uac;
         state        := PS_Play;
         alw_b        := [];
         alw_u        := [0,1,2,3,4,5];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 0;
         ai_partpush  := 0;
      end;p_colors[4]:=c_lime;

      map_psx[0]:=map_mw div 2;
      map_psy[0]:=map_psx[0];

      map_psx[1]:=map_mw div 2;
      map_psy[1]:=map_mw div 6;
      map_psx[2]:=map_mw-map_psy[1];
      map_psy[2]:=map_mw-map_psx[1];
      map_psx[3]:=map_psy[1];
      map_psy[3]:=map_psx[1];
      map_psx[4]:=map_psy[2];
      map_psy[4]:=map_psx[2];

      _unit_add(map_psx[0],map_psy[0],UID_UACPortal,4);

      cmp_base2(map_psx[0],map_psy[0],500 ,2);
      cmp_base2(map_psx[0],map_psy[0],1000,1);
      cmp_base2(map_psx[0],map_psy[0],1500,2);
      cmp_defbase(map_psx[1],map_psy[1],1,2,[]);
      cmp_defbase(map_psx[2],map_psy[2],2,2,[]);
      cmp_defbase(map_psx[3],map_psy[3],1,2,[]);
      cmp_defbase(map_psx[4],map_psy[4],2,2,[]);

      _unit_add(4100,3700,UID_HellBarracks,2);
      _unit_add(4100,1150,UID_HellBarracks,2);
      _unit_add(300,2000,UID_HellBarracks,1);

      map_seed:=5;
      cmp_hellworld(1);
   end;
16: begin
      map_trt     := 2;
      map_lqt     := 1;
      map_mw      := 4000;
      cmp_portal  := 0;
      map_liq     := true;
      PlayerHuman := 4;
      map_seed    := 63666;
      CalcMapVars;

      with _players[1]do
      begin upgr[2]:=1; upgr[7]:=0;
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [1,2,4];
         alw_u        := [0];
         alw_up       := [0,1];
         ai_defense   := true;
         ai_minpush   := 90;
         ai_partpush  := 0;
         ai_maxarmy   := 100;
         ai_skill     := 2;
      end;
      with _players[2]do
      begin upgr[2]:=0;  upgr[7]:=0;
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [1,2];
         alw_u        := [0,3];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 0;
         ai_partpush  := 0;
         ai_maxarmy   := 50;
      end;
      with _players[3]do
      begin upgr[2]:=0;  upgr[7]:=0;
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [1,2];
         alw_u        := [0,3];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 19;
         ai_partpush  := 0;
         ai_maxarmy   := 20;
      end;p_colors[3]:=c_orange;
      with _players[0]do
      begin
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [1,2];
         alw_u        := [0];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 0;
         ai_partpush  := 0;
         ai_maxarmy   := 100;
      end;p_colors[0]:=rgba2c(255,0,255,255);

      with _players[4]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=0;upgr[5]:=0;upgr[6]:=0;upgr[7]:=0;
         team         := 1;
         race         := r_uac;
         state        := PS_Play;
         alw_b        := [1,2,3,4,5];
         alw_u        := [0,1,2,3,4,5,7];
         alw_up       := [5,6,7];
         ai_defense   := true;
         ai_minpush   := 90;
         ai_partpush  := 5;
      end;p_colors[4]:=c_lime;

      map_psx[0]:=(map_mw div 6)-300;
      map_psy[0]:=map_mw-(map_mw div 6);

      map_psx[1]:=map_mw-(map_mw div 4);
      map_psy[1]:=map_mw div 5;
      map_psx[2]:=map_mw div 2;
      map_psy[2]:=map_mw div 3;
      map_psx[3]:=map_mw-(map_mw div 5);
      map_psy[3]:=map_mw-(map_mw div 5);
      map_psx[4]:=map_mw div 4;
      map_psy[4]:=map_psx[4];

      _unit_add(map_psx[0],map_psy[0],UID_UACBase5,4);
      with _units[_lau] do hits:=mhits div 3;
      _unit_add(map_psx[0]-120,map_psy[0]+120,UID_UACBase2,4);
      with _units[_lau] do hits:=mhits div 2;
      _unit_add(map_psx[0]+100,map_psy[0],UID_Engineer,4);
      _unit_add(map_psx[0]-100,map_psy[0],UID_Engineer,4);
      _unit_add(map_psx[0],map_psy[0]-100,UID_Medic,4);
      _unit_add(map_psx[0],map_psy[0]+100,UID_Medic,4);
      _unit_add(map_psx[0]-100,map_psy[0]-100,UID_Commando,4);
      _unit_add(map_psx[0]-100,map_psy[0]+100,UID_Major,4);
      _unit_add(map_psx[0]+100,map_psy[0]+100,UID_Commando,4);
      _unit_add(map_psx[0]+100,map_psy[0]-100,UID_Commando,4);

      _unit_add(map_psx[1],map_psy[1],UID_HellKeep,1);
      _unit_add(map_psx[1]-100,map_psy[1],UID_HellTower,1);
      _unit_add(map_psx[1]+100,map_psy[1],UID_HellTower,1);
      _unit_add(map_psx[2],map_psy[2],UID_HellKeep,2);
      _unit_add(map_psx[2]-100,map_psy[2],UID_HellTower,2);
      _unit_add(map_psx[2]+100,map_psy[2],UID_HellTower,2);
      _unit_add(map_psx[3],map_psy[3],UID_HellKeep,3);
      _unit_add(map_psx[3]-100,map_psy[3],UID_HellTower,3);
      _unit_add(map_psx[3]+100,map_psy[3],UID_HellTower,3);
      //cmp_defbase(map_psx[1],map_psy[1],1,6,[3]);
      //cmp_defbase(map_psx[2],map_psy[2],2,6,[3]);
      //cmp_defbase(map_psx[3],map_psy[3],3,6,[3]);
      cmp_defbase(map_psx[4],map_psy[4],0,1,[3]);

      cmp_hellworld(0);
   end;
17: begin
      cmp_hellagr:=true;
      map_trt     := 1;
      map_lqt     := 1;
      map_mw      := 6000;
      cmp_portal  := 0;
      map_liq     := true;
      PlayerHuman := 4;
      map_seed    := 60760;
      CalcMapVars;

      {with _players[0]do
      begin upgr[2]:=0;upgr[4]:=1; upgr[7]:=1;
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [1,2];
         alw_u        := [0,2];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 0;
         ai_partpush  := 0;
         ai_maxarmy   := 50;
      end;p_colors[0]:=rgba2c(255,0,255,255);}

      with _players[1]do
      begin upgr[2]:=1;upgr[4]:=1; upgr[7]:=1;
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [1,2,4];
         alw_u        := [0,1,2];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 0;
         ai_partpush  := 0;
         ai_maxarmy   := 100;
      end;
      with _players[2]do
      begin upgr[2]:=1;  upgr[7]:=1;
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [1,2,4,5];
         alw_u        := [0,1,2];
         alw_up       := [];
         ai_defense   := true;
         ai_minpush   := 0;
         ai_partpush  := 0;
         ai_maxarmy   := 100;
      end;
      with _players[3]do
      begin upgr[0]:=1; upgr[1]:=1; upgr[2]:=1;  upgr[7]:=1;
         team         := 2;
         race         := r_hell;
         state        := PS_Comp;
         alw_b        := [1,2,3,4,5];
         alw_u        := [0,1,2,3,4,5];
         alw_up       := [6,5];
         ai_defense   := true;
         ai_minpush   := 90;
         ai_partpush  := 20;
         ai_maxarmy   := 100;
      end;p_colors[3]:=c_orange;

      with _players[4]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=0;upgr[5]:=0;upgr[6]:=0;upgr[7]:=0;
         team         := 1;
         race         := r_uac;
         state        := PS_Play;
         alw_b        := [1,2,3,4,5];
         alw_u        := [0,1,2,3,4,5,7];
         alw_up       := [5,6,7];
         ai_defense   := true;
         ai_minpush   := 90;
         ai_partpush  := 5;
      end;p_colors[4]:=c_lime;
      with _players[0]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=0;upgr[5]:=0;upgr[6]:=0;upgr[7]:=0;
         team         := 1;
         race         := r_uac;
         state        := PS_Comp;
         alw_b        := [1,2,3,4,5];
         alw_u        := [0,1,2,3,5,7];
         alw_up       := [6,7];
         ai_defense   := true;
         ai_minpush   := 90;
         ai_partpush  := 15;
         ai_maxarmy   := 100;
      end;p_colors[0]:=c_blue;

      map_psx[0]:=(map_mw div 4)+200;
      map_psy[0]:=map_mw-(map_mw div 4);

      map_psx[1]:=map_mw div 5;
      map_psy[1]:=map_mw div 4;
      map_psx[2]:=map_mw-(map_mw div 4);
      map_psy[2]:=map_mw div 4;
      map_psx[3]:=map_mw div 2;
      map_psy[3]:=map_mw div 2;
      map_psx[4]:=map_mw-map_psx[1];
      map_psy[4]:=map_mw-map_psx[1];

      _unit_add(map_psx[0],map_psy[0],UID_UACBase0,4);
      _unit_add(map_psx[0]+165,map_psy[0],UID_UACBase2,4);
      _unit_add(map_psx[0]-105,map_psy[0],UID_Engineer,4);
      _unit_add(map_psx[0]-105,map_psy[0],UID_Major,4);
      _unit_add(map_psx[0]-105,map_psy[0],UID_Major,4);
      _unit_add(map_psx[0],map_psy[0]+105,UID_Medic,4);
      _unit_add(map_psx[0],map_psy[0]+105,UID_Sergant,4);
      _unit_add(map_psx[0],map_psy[0]+105,UID_Sergant,4);
      _unit_add(map_psx[0],map_psy[0]+105,UID_Sergant,4);
      _unit_add(map_psx[0]+105,map_psy[0],UID_Engineer,4);
      _unit_add(map_psx[0]+105,map_psy[0],UID_Major,4);
      _unit_add(map_psx[0]+105,map_psy[0],UID_Major,4);
      _unit_add(map_psx[0]+105,map_psy[0],UID_Major,4);
      _unit_add(map_psx[0],map_psy[0]-105,UID_Medic,4);
      _unit_add(map_psx[0],map_psy[0]-105,UID_Sergant,4);
      _unit_add(map_psx[0],map_psy[0]-105,UID_Sergant,4);
      _unit_add(map_psx[0],map_psy[0]-105,UID_Sergant,4);

      _unit_add(map_psx[0]+105,map_psy[0]-base_r,UID_Engineer,0);
      _unit_add(map_psx[0]+105,map_psy[0]-base_r,UID_Major,0);
      _unit_add(map_psx[0]+105,map_psy[0]-base_r,UID_Major,0);
      _unit_add(map_psx[0]+105,map_psy[0]-base_r,UID_Major,0);
      _unit_add(map_psx[0],map_psy[0]-105-base_r,UID_Medic,0);
      _unit_add(map_psx[0],map_psy[0]-105-base_r,UID_Sergant,0);
      _unit_add(map_psx[0],map_psy[0]-105-base_r,UID_Sergant,0);
      _unit_add(map_psx[0],map_psy[0]-105-base_r,UID_Sergant,0);
      _unit_add(map_psx[0]-165-(base_r div 2)-200,map_psy[0]-base_r,UID_UACBase2,0);
      _unit_add(map_psx[0]-165-(base_r div 2)-100,map_psy[0]-base_r+100,UID_UACBase2,0);
      cmp_defbase(map_psx[0]-(base_r div 2)-201,map_psy[0]-base_r,0,3,[]);

      cmp_defbase(map_psx[2],map_psy[2],3,1,[0]);
      cmp_base2(map_psx[2],map_psy[2],490,3);
      _unit_add(map_psx[2],map_psy[2],UID_HellFortess,3);
      _unit_add(map_psx[2],map_psy[2],UID_Cyberdemon,3);

      cmp_defbase(map_psx[3],map_psy[3],2,3,[]);

      cmp_defbase(map_psx[1],map_psy[1],1,5,[]);
      cmp_defbase(map_psx[4],map_psy[4],1,5,[]);

      _unit_add(map_psx[1]+150,map_psy[1]-150,UID_HellBarracks,1);
      _unit_add(map_psx[1]+300,map_psy[1]-300,UID_HellBarracks,1);
      _unit_add(map_psx[4]+150,map_psy[4]-150,UID_HellBarracks,1);
      _unit_add(map_psx[4]+300,map_psy[4]-300,UID_HellBarracks,1);
      _unit_add(map_psx[3]-300,map_psy[3]-150,UID_HellBarracks,2);
      _unit_add(map_psx[3]-300,map_psy[3]+150,UID_HellBarracks,2);
      _unit_add(4890,1375,UID_HellBarracks,3);
   end;

18: begin     /////////////////////////       HELL
      map_trt     := 10;
      map_lqt     := 3;
      map_mw      := 6000;
      cmp_portal  := 120;
      map_liq     := true;
      PlayerHuman := 4;
      map_seed    := 6555;
      CalcMapVars;

      with _players[0]do
      begin
         upgr[3]:=1;upgr[4]:=1;upgr[7]:=1;
         team   := 2;
         race   := r_hell;
         state  := PS_Comp;

         alw_u  := [0,3];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
      end; p_colors[0]:=rgba2c(255,0,255,255);
      with _players[1]do
      begin
         upgr[3]:=1;upgr[4]:=1;upgr[7]:=1;
         team   := 2;
         race   := r_hell;
         state  := PS_Comp;

         alw_u  := [0,1,2];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
      end;
      with _players[2]do
      begin
         upgr[3]:=1;upgr[4]:=1;upgr[7]:=1;
         team   := 2;
         race   := r_hell;
         state  := PS_Comp;

         alw_u  := [0,1,2,3];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
      end;
      with _players[3]do
      begin
         upgr[3]:=1;upgr[4]:=1;upgr[7]:=1;
         team   := 2;
         race   := r_hell;
         state  := PS_Comp;

         alw_u  := [0,1,2,3,4];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
      end;  p_colors[3]:=c_orange;

      with _players[4]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[5]:=1;upgr[6]:=1;upgr[7]:=1;
         team   := 1;
         race   := r_uac;
         state  := PS_Play;
         alw_u  := [0,1,2,3,4,5,6];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
    ai_partpush := 0;
      end;  p_colors[4]:=c_lime;

      map_psx[0]:=map_mw div 2;
      map_psy[0]:=map_mw div 2;

      map_psx[1]:=map_mw div 5;
      map_psy[1]:=map_mw div 4;
      map_psx[2]:=map_mw-map_psx[1];
      map_psy[2]:=map_mw-map_psy[1];
      map_psx[3]:=map_psy[1];
      map_psy[3]:=map_psx[2];
      map_psx[4]:=map_psy[2];
      map_psy[4]:=map_psx[1];

      _unit_add(map_psx[0],map_psy[0],UID_UACPortal,4);

      cmp_base2(map_psx[1],map_psy[1],400,1);
      cmp_base3(map_psx[1],map_psy[1],1,1);

      cmp_base2(map_psx[2],map_psy[2],300,2);
      cmp_base3(map_psx[2],map_psy[2],2,1);

      cmp_base2(map_psx[3],map_psy[3],400,3);
      cmp_base3(map_psx[3],map_psy[3],3,1);

      cmp_base2(map_psx[4],map_psy[4],400,2);
      cmp_base3(map_psx[4],map_psy[4],2,1);

      cmp_base2(map_psx[0],map_psy[0],600,2);
      cmp_base2(3100,4900,330,1);
      cmp_base2(680,3700,330,1);

      cmp_base3(3100,4900,2,1);
      cmp_base3(680,3700,1,1);

      cmp_base3(4500,3200,3,1);
      cmp_base3(5400,2800,3,1);
      cmp_base3(4000,2000,2,1);
      cmp_base3(3100,1300,2,1);
      cmp_base3(1800,2050,1,1);
   end;
19: begin
      map_trt     := 0;
      map_lqt     := 3;
      map_mw      := 6000;
      cmp_portal  := 150;
      map_liq     := true;
      PlayerHuman := 4;
      map_seed    := 666661;
      CalcMapVars;

      with _players[0]do
      begin
         upgr[3]:=1;upgr[4]:=1;upgr[7]:=1;
         team   := 2;
         race   := r_hell;
         state  := PS_Comp;

         alw_u  := [0,1,2,3,4];
         alw_b  := [4];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
      end; p_colors[0]:=rgba2c(255,0,255,255);
      with _players[1]do
      begin
         upgr[3]:=1;upgr[4]:=1;upgr[7]:=1;
         team   := 2;
         race   := r_hell;
         state  := PS_Comp;

         alw_u  := [0,1,2,3,4];
         alw_b  := [4];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
      end;
      with _players[2]do
      begin
         upgr[3]:=1;upgr[4]:=1;upgr[7]:=1;
         team   := 2;
         race   := r_hell;
         state  := PS_Comp;

         alw_u  := [0,1,2,3,4];
         alw_b  := [1,2,3,4];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
      end;
      with _players[3]do
      begin
         upgr[3]:=1;upgr[4]:=1;upgr[7]:=1;
         team   := 2;
         race   := r_hell;
         state  := PS_Comp;

         alw_u  := [0,1,2,3,4];
         alw_b  := [1,2,3,4];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
      end;  p_colors[3]:=c_orange;

      with _players[4]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[5]:=1;upgr[6]:=1;upgr[7]:=1;
         team   := 1;
         race   := r_uac;
         state  := PS_Play;
         alw_u  := [];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 0;
      end;  p_colors[4]:=c_lime;

      map_psx[0]:=map_mw;
      map_psy[0]:=0;

      map_psx[1]:=0;
      map_psy[1]:=map_mw;

      map_psx[2]:=map_mw div 2;
      map_psy[2]:=map_psx[2];

      _unit_add(map_psx[1],map_psy[1],UID_Marker,PlayerHuman);
      with _units[401] do dsbl:=true;

      _unit_add(map_psx[0],map_psy[0],UID_BFG,PlayerHuman);
      with _units[402] do
      begin
         mx:=x-250;
         my:=250;
      end;

      cmp_defbase(map_psx[2],map_psy[2],2,1,[1,2,3,4,5]);
      cmp_base2(map_psx[2],map_psy[2],500,2);
      _unit_add(map_psx[2]-100,map_psy[2],UID_HellSymbol,0);
      _unit_add(map_psx[2]+100,map_psy[2],UID_HellSymbol,1);
      _unit_add(map_psx[2],map_psy[2]+100,UID_HellSymbol,2);
      _unit_add(map_psx[2],map_psy[2]-100,UID_HellSymbol,3);

      map_seed:=312;cmp_hellworld(0);
      map_seed:=321;cmp_hellworld(1);
      map_seed:=123;cmp_hellworld(2);
      map_seed:=213;cmp_hellworld(3);
    end;
20: begin
      map_trt     := 0;
      map_lqt     := 3;
      map_mw      := 5500;
      cmp_portal  := 0;
      map_liq     := true;
      PlayerHuman := 4;
      map_seed    := 166641;
      CalcMapVars;

      with _players[0]do
      begin
         upgr[3]:=1;upgr[4]:=1;upgr[7]:=1;
         team   := 2;
         race   := r_hell;
         state  := PS_Comp;

         alw_u  := [0,1,2,3,4];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
    menerg:=1;
      end; p_colors[0]:=rgba2c(255,0,255,255);
      with _players[1]do
      begin
         upgr[3]:=1;upgr[4]:=1;upgr[7]:=1;
         team   := 2;
         race   := r_hell;
         state  := PS_Comp;

         alw_u  := [0,1,2,3,4];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
    menerg:=1;
      end;
      with _players[2]do
      begin
         upgr[3]:=1;upgr[4]:=1;upgr[7]:=1;
         team   := 2;
         race   := r_hell;
         state  := PS_Comp;

         alw_u  := [0,1,2,3,4];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
    menerg:=1;
      end;
      with _players[3]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=1;upgr[5]:=1;upgr[6]:=1;upgr[7]:=1;
         team   := 2;
         race   := r_hell;
         state  := PS_Comp;

         alw_u  := [];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 101;
      end;  p_colors[3]:=c_orange;

      with _players[4]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[5]:=1;upgr[6]:=1;upgr[7]:=1;
         team   := 1;
         race   := r_uac;
         state  := PS_Play;
         alw_u  := [];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 0;
      end;  p_colors[4]:=c_lime;

      map_psx[0]:=0;
      map_psy[0]:=map_mw div 2;

      map_psx[1]:=4900;
      map_psy[1]:=3500;

      //cmp_mhaih(map_psx[0]+100,map_psy[0]-50,4);

      _unit_add(map_psx[0],map_psy[0],UID_Bomber,PlayerHuman);
      with _units[_lau] do
      begin
         mx:=x+250;
         my:=y-250;
      end;

      _unit_add(map_psx[1],map_psy[1],UID_MasterMind,3);
      with _units[_lau] do
      begin
         painc:=0;
         mhits:=3000;
         hits :=3000;
      end;
      _unit_add(map_psx[1],map_psy[1],UID_HellFortess,3);
      _unit_add(map_psx[1],map_psy[1],UID_Cyberdemon,3);
      _unit_add(map_psx[1],map_psy[1],UID_Baron,3);
      _unit_add(map_psx[1],map_psy[1],UID_Cacodemon,3);

      map_seed:=0;cmp_hellworld(0);
      map_seed:=1;cmp_hellworld(1);
      map_seed:=2;cmp_hellworld(2);
      map_seed:=3;cmp_hellworld(3);
   end;

21: begin     /////////////////////////        MARS
      map_trt     := 8;
      map_lqt     := 2;
      map_mw      := 5000;
      cmp_portal  := 0;
      map_liq     := false;
      PlayerHuman := 4;
      map_seed    := 1156;
      CalcMapVars;

      with _players[0]do
      begin
         upgr[0]:=1;upgr[3]:=1;upgr[4]:=1;upgr[7]:=1;
         team   := 2;
         race   := r_hell;
         state  := PS_Comp;

         alw_u  := [0,1,2];
         alw_b  := [1,2,4];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
      end;p_colors[0]:=rgba2c(255,0,255,255);
      with _players[1]do
      begin
         upgr[0]:=1;upgr[3]:=1;upgr[4]:=1;upgr[7]:=1;
         team   := 2;
         race   := r_hell;
         state  := PS_Comp;

         alw_u  := [0,1,2];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
      end;
      with _players[2]do
      begin
         upgr[0]:=1;upgr[3]:=1;upgr[4]:=1;upgr[7]:=1;
         team   := 2;
         race   := r_hell;
         state  := PS_Comp;

         alw_u  := [0,1,2];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
      end;

      with _players[3]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[5]:=1;upgr[6]:=0;upgr[7]:=1;
         team   := 1;
         race   := r_uac;
         state  := PS_Comp;
         alw_u  := [0,1,2,3];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
    ai_partpush := 0;
      end;p_colors[3]:=c_aqua;
      with _players[4]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[5]:=1;upgr[6]:=0;upgr[7]:=1;
         team   := 1;
         race   := r_uac;
         state  := PS_Play;
         alw_u  := [0,1,2,3];
         alw_b  := [];
         alw_up := [];
    ai_defense  := true;
    ai_minpush  := 0;
    ai_partpush := 0;
      end;  p_colors[4]:=c_lime;

      map_psx[0]:=map_mw div 6;
      map_psy[0]:=map_mw-(map_mw div 6);

      map_psx[1]:=map_mw div 4;
      map_psy[1]:=map_mw div 3;
      map_psx[2]:=map_mw-map_psx[1];
      map_psy[2]:=map_mw-map_psy[1];
      map_psx[3]:=map_psy[1];
      map_psy[3]:=map_psx[2];
      map_psx[4]:=map_psy[2];
      map_psy[4]:=map_psx[1];

      _unit_add(map_psx[0],map_psy[0]-100,UID_UACTurret,4);
      _unit_add(map_psx[0]-100,map_psy[0],UID_UACTurret,4);
      _unit_add(map_psx[0],map_psy[0],UID_UACBase2,4);
      _unit_add(map_psx[0],map_psy[0]+150,UID_UACBarracks,4);
      _unit_add(map_psx[0],map_psy[0]+300,UID_UACBarracks,4);

      _unit_add(map_psx[0]+200,map_psy[0]-100,UID_UACTurret,3);
      _unit_add(map_psx[0]+300,map_psy[0]+100,UID_UACTurret,3);
      _unit_add(map_psx[0]+300,map_psy[0]+200,UID_UACTurret,3);
      _unit_add(map_psx[0]+300,map_psy[0],UID_UACTurret,3);
      _unit_add(map_psx[0]+200,map_psy[0],UID_UACBase2,3);
      _unit_add(map_psx[0]+200,map_psy[0]+150,UID_UACBarracks,3);
      _unit_add(map_psx[0]+200,map_psy[0]+300,UID_UACBarracks,3);

      cmp_defbase(2800,2800,0,3,[]);

      cmp_defbase(map_psx[1],map_psy[1],2,3,[0,3,5]);
      cmp_defbase(map_psx[2],map_psy[2],2,2,[0,3,5]);
      cmp_defbase(map_psx[3],map_psy[3],1,2,[0,3,5]);
      cmp_defbase(map_psx[4],map_psy[4],0,3,[3,5]);

      cmp_base2(map_psx[1],map_psy[1],450,2);
      cmp_base2(map_psx[2],map_psy[2],450,1);
      cmp_base2(map_psx[4],map_psy[4],450,0);

      _unit_add(1550,3700,UID_HellBarracks,0);
      _unit_add(700,3000,UID_HellBarracks,0);
      _unit_add(2400,1550,UID_HellBarracks,0);
      _unit_add(3750,4400,UID_HellBarracks,0);

   end;
22: begin                          // END
      cmp_hellagr:=true;
      map_trt     := 8;
      map_lqt     := 2;
      map_mw      := 5500;
      cmp_portal  := 0;
      map_liq     := true;
      PlayerHuman := 4;
      map_seed    := 77060;//1116;
      CalcMapVars;

      with _players[0]do
      begin
         upgr[3]:=1;upgr[4]:=1;
         team   := 2;
         race   := r_hell;
         state  := PS_Comp;
         alw_u  := [0,1,2];
         alw_b  := [1,2,3,5];
         alw_up := [3,4,5,7];
    ai_defense  := true;
    ai_minpush  := 50;
    ai_partpush := 25;
    ai_maxarmy  := 60;
    ai_skill    := 1;
      end;   p_colors[0]:=rgba2c(255,0,255,255);
      with _players[1]do
      begin
         team   := 2;
         race   := r_hell;
         state  := PS_Comp;
         alw_u  := [0,1,2,3,5];
         alw_b  := [1,2,3,4,5];
         alw_up := [0,1,2,3,4];
    ai_defense  := true;
    ai_minpush  := 50;
    ai_partpush := 15;
    ai_maxarmy  := 100;
    ai_skill    := 1;
      end;
      with _players[2]do
      begin
         team   := 2;
         race   := r_hell;
         state  := PS_Comp;

         alw_u  := [0,1,2,3,4,6];
         alw_b  := [1,2,3,4,5];
         alw_up := [0,1,2,6];
    ai_defense  := true;
    ai_minpush  := 0;
    ai_partpush := 10;
    ai_maxarmy  := 100;
    ai_skill    := 1;
      end;
      with _players[3]do
      begin
         team   := 2;
         race   := r_hell;
         state  := PS_Comp;

         alw_u  := [0,1,2,3,4,5,6];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [0,1,2,3,4,5,6,7];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 14;
    ai_maxarmy  := 100;
    ai_skill    := 5;
      end;p_colors[3]:=c_orange;

      with _players[4]do
      begin
         upgr[0]:=1;upgr[1]:=1;upgr[2]:=1;upgr[3]:=1;upgr[4]:=1;upgr[5]:=1;upgr[6]:=0;upgr[7]:=0;
         team   := 1;
         race   := r_uac;
         state  := PS_Play;
         alw_u  := [0,1,2,3,4,5,6,7];
         alw_b  := [0,1,2,3,4,5];
         alw_up := [6,7];
    ai_defense  := true;
    ai_minpush  := 90;
    ai_partpush := 0;
      end;   p_colors[4]:=c_lime;

      map_psx[0]:=map_mw-(map_mw div 6);
      map_psy[0]:=map_psx[0];

      map_psx[1]:=map_mw div 3;
      map_psy[1]:=map_mw div 3;
      map_psx[2]:=map_mw div 5;
      map_psy[2]:=map_mw-map_psx[2];
      map_psx[3]:=map_psy[2];
      map_psy[3]:=map_psx[2];
      map_psx[4]:=3800;
      map_psy[4]:=2800;

      _unit_add(map_psx[0],map_psy[0],UID_UACBase0,4);
      _unit_add(map_psx[0]-165,map_psy[0],UID_UACBase2,4);
      _unit_add(map_psx[0]+165,map_psy[0],UID_UACBase2,4);
      _unit_add(map_psx[0],map_psy[0]-165,UID_UACBase2,4);
      _unit_add(map_psx[0],map_psy[0]+165,UID_UACBase2,4);

      _unit_add(map_psx[0]+165,map_psy[0]+165,UID_Major,4);
      _unit_add(map_psx[0]-165,map_psy[0]+165,UID_Engineer,4);
      _unit_add(map_psx[0]-165,map_psy[0]-165,UID_Medic,4);
      _unit_add(map_psx[0]+165,map_psy[0]-165,UID_Commando,4);

      _unit_add(map_psx[0]+165,map_psy[0]+175,UID_Bomber,4);
      _unit_add(map_psx[0]-165,map_psy[0]+175,UID_Bomber,4);
      _unit_add(map_psx[0]-165,map_psy[0]-175,UID_Bomber,4);
      _unit_add(map_psx[0]+165,map_psy[0]-175,UID_Bomber,4);

      _unit_add(map_psx[0]-400+100,map_psy[0]-400+100,UID_Medic,4);
      _unit_add(map_psx[0]-400+130,map_psy[0]-400+100,UID_Medic,4);
      _unit_add(map_psx[0]-400+160,map_psy[0]-400+100,UID_Medic,4);
      _unit_add(map_psx[0]-400+160,map_psy[0]-400+130,UID_Sergant,4);
      _unit_add(map_psx[0]-400+190,map_psy[0]-400+130,UID_Sergant,4);
      _unit_add(map_psx[0]-400+100,map_psy[0]-400+160,UID_Sergant,4);
      _unit_add(map_psx[0]-400+130,map_psy[0]-400+160,UID_Sergant,4);
      _unit_add(map_psx[0]-400+160,map_psy[0]-400+160,UID_Commando,4);
      _unit_add(map_psx[0]-400+190,map_psy[0]-400+160,UID_Commando,4);
      _unit_add(map_psx[0]-400+100,map_psy[0]-400+190,UID_Commando,4);
      _unit_add(map_psx[0]-400+130,map_psy[0]-400+190,UID_Commando,4);

      cmp_defbase(map_psx[1],map_psy[1],3,3,[0]);cmp_base2(map_psx[1],map_psy[1],500,3); _unit_add(map_psx[1],map_psy[1],UID_HellFortess,3);
      cmp_defbase(map_psx[2],map_psy[2],2,2,[]);
      cmp_defbase(map_psx[3],map_psy[3],1,3,[]);
      cmp_defbase(map_psx[4],map_psy[4],0,5,[2]);

      _unit_add(map_psx[1]+190,map_psy[1],UID_HellBarracks,3);
      _unit_add(map_psx[2]+120,map_psy[2]+150,UID_HellBarracks,2);
      _unit_add(map_psx[3]+120,map_psy[3]+150,UID_HellBarracks,1);
      _unit_add(map_psx[4]+120,map_psy[4]+150,UID_HellBarracks,0);
   end;

   else
     map_trt:=1;
     map_lqt:=1;
     map_mw:=6000;
     cmp_portal:=0;
     map_liq:=true;
     PlayerHuman:=1;
     map_seed:=666;
     CalcMapVars;
     with _players[1]do begin team:=1; race:=r_hell; state:=PS_Play; end;
     with _players[2]do begin team:=2; race:=r_uac;  state:=PS_Comp; end;
     with _players[3]do begin team:=2; race:=r_uac;  state:=PS_Comp; end;
     with _players[4]do begin team:=2; race:=r_uac;  state:=PS_Comp; end;
   end;

   for i:=0 to MaxPlayers do
    with _players[i] do
     if(race=r_hell)then
      if(upgr[upgr_hpower]>0)then
      begin
         alw_up:=alw_up+[upgr_hpower];
         hptm:=hp_time;
      end;

   MakeTerrain;
   MakeLiquid;
   g_MakeMap;

   _moveHumView(map_psx[0] , map_psy[0]);
end;

