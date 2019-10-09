
procedure _dds_p(nospr:boolean);
var d,shh:integer;
    inv:byte;
  spr:PTUSprite;
begin
   for d:=1 to MaxDoodads do
    with map_dds[d] do
     if(t>0)then
     begin
        if(vid_mmredraw)then
         if(mmr>0)then
          case t of
          DID_Liquid : ellipseColor(vid_minimap,mmx,mmy,mmr,(mmr div 4)*3,mmc);
          else
           circleColor(vid_minimap,mmx,mmy,mmr,mmc)
          end
         else pixelColor(vid_minimap,mmx,mmy,mmc);

        if(nospr=false)then
        begin
           shh:=0;
           inv:=255;
           case t of
            DID_tree   : begin
                            spr:=@spr_decs[a];
                            shh:=spr^.surf^.h-4;
                         end;
            DID_liquid : spr:=@spr_liquid[((G_Step div vid_hfps) mod 4)+1 ];
            DID_rock   : spr:=@spr_decs[a];
            DID_Brock  : spr:=@spr_decs[a];
            DID_cleft  : begin
                            inv:=127;
                            case a of
                               0: spr:=@spr_decs[6];
                               1: spr:=@spr_db_h0;
                               else
                                  spr:=@spr_db_h1;
                            end;
                         end;
           else
            spr:=@spr_dum;
           end;

            if (t=DID_tree)then
             if _fog_ch(fx,fy,r)=false then continue;

            if ((vid_vx+vid_panel-spr^.hw)<x)and(x<(vid_vx+vid_mw+spr^.hw))and
               ((vid_vy-spr^.hh)<y)and(y<(vid_vy+vid_mh+spr^.hh)) then
             _sprb_add(spr^.surf, x-spr^.hw, y-spr^.hh,dpth,shh,0,0,#0,inv,false,0,0,0);
        end;
     end;
end;

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
        dpth:=y;

        fx:=x div fog_cw;
        fy:=y div fog_cw;

        mmc:=c_gray;

        case t of
         DID_tree   : begin
                         r:=18;
                         a:=d mod 4;
                      end;
         DID_liquid : begin
                         r:=liquid_r;
                         mmc:=map_mm_liqc;
                         dpth:=-5;
                      end;
         DID_cleft  : begin
                         r:=0;
                         dpth:=-6;
                         a:=d mod 3;
                      end;
         DID_rock   : begin
                         r:=60;
                         a:=4+((d mod 4) div 2);
                         if(map_trt in [0,17])then inc(a,4);
                      end;
         DID_Brock  : begin
                         if(map_trt in [0,17])
                         then a:=10
                         else a:=7;
                         r:=105;
                      end;
        end;

        mmx:=trunc(x*map_mmcx);
        mmy:=trunc(y*map_mmcx);
        mmr:=trunc(r*map_mmcx);

        break;
     end;
end;

procedure _drawStarts;
var i:byte;
begin
   for i:=1 to MaxPlayers do
   begin
      characterColor(vid_minimap,trunc(map_psx[i]*map_mmcx),trunc(map_psy[i]*map_mmcx),start_char,c_white);
      if(g_mode=gm_ct)then
       with g_pt[i]do
        CircleColor(vid_minimap,mx,my,mmap_pr,c_yellow);
   end;
end;

procedure CalcMapVars;
begin
   if(map_mw<3000)or(map_mw>6000)then map_mw:=3000;
   map_mmcx    := (vid_panel-2)/map_mw;
   map_mmvw    := trunc((vid_mw-vid_panel)*map_mmcx);
   map_mmvh    := trunc( vid_mh*map_mmcx);
   map_b1      := map_mw-build_b;
   fog_cw      := trunc(map_mw/fog_cs)+2;
   if((fog_cw mod 2)=0)then inc(fog_cw,1);
   fog_chw     := fog_cw div 2;
   fog_cr      := trunc(fog_chw*1.45);
   fog_vcnw    := ((vid_mw-vid_panel) div fog_cw)+1;
   fog_vcnh    := (vid_mh div fog_cw)+1;
   radar_fr    := radar_sr div fog_cw;
   map_ffly    := (map_obs>2)and(map_liq);
   mmap_pr     := trunc(point_r*map_mmcx);
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
         if(iy>MaxPlayers)then iy:=1;
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
var i,ix,iy,lqs,rks,ddc,cY:integer;
begin
   boxColor(spr_m_back,90,128,233,271,c_black);
   sdl_FillRect(vid_minimap,nil,0);
   FillChar(map_dds,sizeof(map_dds),0);

   ix:=map_seed;
   iy:=0;
   for i:=1 to MaxADecs do
    with terdcs[i] do
    begin
       ix:=ai_rc(ix+iy-(ix mod 123),123);
       iy:=ai_rc(ix+iy,123);
       x:=ix mod vid_mw;
       y:=iy mod vid_mh;
    end;

   cY:=1235;

   vid_mmredraw:=true;

   ix:=map_seed;
   iy:=0;

   ddc:=MaxDoodads;

   if(_mmode<>mm_camp)then
   begin
      rks:=(sqr(map_mw div 100) div 60)*map_obs;

      if(map_liq)
      then lqs:=rks-(rks div 3)
      else lqs:=0;

      _drawStarts;
   end
   else
   begin
      rks:=map_mw div 230;

      if(map_liq)
      then lqs:=(map_mw div 230)+(map_mw div 4500)*10
      else lqs:=0;

      case map_trt of
      7,8: rks:=200;
       0: begin lqs:=200; rks:=0; end;
      end;

      case _mcmp_sm of
      16:begin
            lqs:=150;
            rks:=75;
          end;
      10:begin
            lqs:=5;
            rks:=0;
         end;
      11:begin
            lqs:=0;
            rks:=50;
         end;
      18:begin
            lqs:=100;
            rks:=70;
         end;
      22:begin
            lqs:=40;
            rks:=40;
         end;
      end;

   end;

   for i:=1 to MaxDoodads do      //2867232315
   begin
      repeat
        ix:=ai_rc(ix+iy-(ix mod 123),cY);
        iy:=ai_rc(ix+iy,cY);
      until (_spch(ix,iy)=false)and(ix>=0)and(iy>=0)and(ix<=map_mw)and(iy<=map_mw);

      if(lqs>0)then
      begin
         _dds_a(ix,iy,DID_liquid);
         dec(lqs,1);
      end
      else
        if(rks>0)then
        begin
           if(i mod 2)=0
           then _dds_a(ix,iy,DID_rock)
           else _dds_a(ix,iy,DID_brock);
           dec(rks,1);
        end else
          if(map_trt=0)or((map_trt in [10,17])and(map_liq)and(map_lqt=3))
          then _dds_a(ix,iy,DID_cleft)
          else _dds_a(ix,iy,DID_tree);

      dec(ddc,1);
      if(ddc=0)then break;
   end;

   _dds_p(true);

   _draw_surf(spr_m_back,91,129,vid_minimap);
end;

procedure g_lqttrt;
begin
   map_trt :=1+map_seed mod 17;
   if(map_trt=7)
   then map_lqt:=map_seed mod 3
   else map_lqt:=map_seed mod 4;
end;

procedure g_premap;
begin
   CalcMapVars;
   SkirmishStarts;
   g_lqttrt;
   MakeTerrain;
   MakeLiquid;
   g_MakeMap;
end;

procedure g_randomseed;
begin
   map_seed:=random($FFFFFFFF);
   g_lqttrt;
end;

procedure g_randommap;
begin
   g_randomseed;

   map_pos:=random(2);
   map_mw:=((random(3500) div 500)*500)+3000;
   map_liq:=random(2)=0;
   map_obs:=random(4)+1;
end;

