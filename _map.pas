

procedure _dds_a(dx,dy,dt:integer);
var d:integer;
begin
   for d:=1 to MaxDoodads do
    with map_dds[d] do
     if(t=0)then
     begin
        x:=dx;
        y:=dy;
        t:=dt;

        case t of
         DID_tree   : r:=18;
         DID_liquid : r:=liquid_r;
         DID_cleft  : r:=0;
         DID_rock   : r:=60;
         DID_Brock  : r:=105;
        else
         r:=0;
        end;

        break;
     end;
end;

procedure CalcMapVars;
begin
   if(map_mw<3000)or(map_mw>6000)then map_mw:=3000;
   map_b1      := map_mw-build_b;
   fog_cw      := trunc(map_mw/fog_cs)+2;
   map_ffly    := (map_obs>2)and(map_liq);
end;


procedure SkirmishStarts;
var ix,iy,i:integer;
begin
   map_psx[0]:=-5000;
   map_psy[0]:=-5000;

   if(g_mode=gm_2fort)then
   begin
       if(map_pos<>0)then //+
       begin
          if(map_seed mod 2)=0 then
          begin
             ix:=map_mw div 2;
             iy:=map_mw div 6;
             map_psx[1]:=ix+225;
             map_psy[1]:=iy;
             map_psx[2]:=ix-225;
             map_psy[2]:=iy;
          end else
          begin
             ix:=map_mw div 6;
             iy:=map_mw div 2;
             map_psx[1]:=ix;
             map_psy[1]:=iy+225;
             map_psx[2]:=ix;
             map_psy[2]:=iy-225;
          end;
          map_psx[3]:=map_mw-map_psx[1];
          map_psy[3]:=map_mw-map_psy[1];
          map_psx[4]:=map_mw-map_psx[2];
          map_psy[4]:=map_mw-map_psy[2];
       end else
       begin
          ix:=map_mw div 5;
          iy:=ix;
          if(map_seed mod 2)=0 then
          begin
             ix:=map_mw-ix;
             map_psx[1]:=ix-250;
             map_psy[1]:=iy;
             map_psx[2]:=ix;
             map_psy[2]:=iy+250;
          end
          else
          begin
             map_psx[1]:=ix+250;
             map_psy[1]:=iy;
             map_psx[2]:=ix;
             map_psy[2]:=iy+250;
          end;
          map_psx[3]:=map_mw-map_psx[1];
          map_psy[3]:=map_mw-map_psy[1];
          map_psx[4]:=map_mw-map_psx[2];
          map_psy[4]:=map_mw-map_psy[2];
       end;
   end
   else
   begin
      if(g_mode=gm_inv)then
      begin
         map_psx[0]:=map_mw div 2;
         map_psy[0]:=map_psx[0];
      end;
      if(map_pos<>0)then //+
      begin
         ix:=map_mw div 2;
         iy:=map_mw-(map_mw div 6);
         map_psx[1]:=ix;
         map_psy[1]:=iy;
         map_psx[2]:=iy;
         map_psy[2]:=ix;
         map_psx[3]:=ix;
         map_psy[3]:=map_mw-iy;
         map_psx[4]:=map_psy[3];
         map_psy[4]:=ix;
      end
      else  //x
      begin
         ix:=map_mw-((map_mw div 5)+100);
         iy:=map_mw-ix;
         map_psx[1]:=ix;
         map_psy[1]:=ix;
         map_psx[2]:=ix;
         map_psy[2]:=iy;
         map_psx[3]:=iy;
         map_psy[3]:=iy;
         map_psx[4]:=iy;
         map_psy[4]:=ix;
      end;

      ix:=map_mw shr 1;
      for i:=1 to MaxPlayers do
      begin
         iy:=i+1;
         if(iy>4)then iy:=1;
         with g_pt[i] do
         begin
            x :=(map_psx[i]+map_psx[iy]) div 2;
            y :=(map_psy[i]+map_psy[iy]) div 2;
            if(map_pos<>0)then
            begin
               inc(x,x-ix);
               inc(y,y-ix);
            end;
            mx:=trunc(x*map_mmcx);
            my:=trunc(y*map_mmcx);
         end;
      end;

      for ix:=1 to MaxPlayers do
       for iy:=1 to MaxPlayers do
        if(ix<>iy)then
         if(random(2)=1) then
         begin
            i:=map_psx[ix];
            map_psx[ix]:=map_psx[iy];
            map_psx[iy]:=i;

            i:=map_psy[ix];
            map_psy[ix]:=map_psy[iy];
            map_psy[iy]:=i;
         end;
   end;
end;  


function _spch(x,y:integer):boolean;
var p:byte;
    e:integer;
begin
   _spch:=false;
   e:=base_r+liquid_r;
   for p:=0 to MaxPlayers do _spch:=_spch or (dist2(x,y,map_psx[p],map_psy[p])<e);
end;

procedure g_MakeMap;
var i,ix,iy,lqs,rks,ddc:integer;
begin

   FillChar(map_dds,sizeof(map_dds),0);


   ix:=map_seed;
   iy:=0;

   ddc:=MaxDoodads;

      rks:=(sqr(map_mw div 100) div 60)*map_obs;

      if(map_liq)
      then lqs:=rks-(rks div 3)
      else lqs:=0;


   for i:=1 to MaxDoodads do      //2867232315
   begin
      repeat
        ix:=ai_rc(ix+iy-(ix mod 123));
        iy:=ai_rc(ix+iy);
      until (_spch(ix,iy)=false)and(ix>=0)and(iy>=0)and(ix<=map_mw)and(iy<=map_mw);

      if(lqs>0)then
      begin
         _dds_a(ix,iy,DID_liquid);
         dec(lqs,1);
      end else
        if(rks>0)then
        begin
           if(i mod 2)=0
           then _dds_a(ix,iy,DID_rock)
           else _dds_a(ix,iy,DID_brock);
           dec(rks,1);
        end else
          if(map_trt=11)or((map_trt=10)and(map_liq)and(map_lqt=3))
          then _dds_a(ix,iy,DID_cleft)
          else _dds_a(ix,iy,DID_tree);

      dec(ddc,1);
      if(ddc=0)then break;
   end;
end;

procedure g_lqttrt;
begin
   map_trt :=map_seed mod 11;
   if(map_trt=7)
   then map_lqt:=map_seed mod 3
   else map_lqt:=map_seed mod 4;
end;

procedure g_premap;
begin
   CalcMapVars;
   SkirmishStarts;
   g_lqttrt;
   g_MakeMap;
end;

procedure g_randommap;
begin
   map_seed:=random($FFFFFFFF);
   map_pos:=random(2);
   map_mw:=((random(3500) div 500)*500)+3000;
   map_liq:=random(2)=0;
   map_obs:=random(4)+1;

   g_lqttrt;
end;


