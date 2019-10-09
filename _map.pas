
procedure _dds_p;
var d,shh,ro:integer;
    inv  :byte;
    spr  :PTUSprite;
begin
   if(_ded)then exit;

   for d:=1 to MaxDoodads do
    with map_dds[d] do
     if(t>0)then
     begin
        ro:=0;
        if(m_sbuild<=_uts)then ro:=r-bld_dec_mr;
        shh:=0;
        inv:=255;
        case t of
            DID_tree   : begin
                            spr:=@spr_sdecs[a];
                            shh:=1;
                         end;
            DID_liquid : begin
                            inc(a,1);
                            a:=a mod vid_2fps;
                            spr:=@spr_liquid[(a div vid_hfps)+1];
                         end;
            DID_rock   : spr:=@spr_sdecs[a];
            DID_brock  : spr:=@spr_sdecs[a];
            DID_cleft  : begin
                            //inv:=127;
                            case a of
                               0: spr:=@spr_sdecs[19];
                               1: spr:=@spr_db_h0;
                            else spr:=@spr_db_h1;
                            end;
                         end;
        else
           spr:=@_dsurf;
        end;

        if((vid_vx+vid_panel-spr^.hw)<x)and(x<(vid_vx+vid_mw+spr^.hw))and
          ((vid_vy-spr^.hh)<y)and(y<(vid_vy+vid_mh+spr^.hh))then
           _sl_add(x-spr^.hw, y-spr^.hh,dpth,shh,0,0,false,spr^.surf,inv,0,0,0,0,'',ro);
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

        case t of
         DID_tree   : begin
                         a    := d mod 13;
                         mmc  := c_gray;
                         if(a>4)
                         then r := 25
                         else r := 18;
                      end;
         DID_liquid : begin
                         a    := 0;
                         r    := liquid_r[map_liq];
                         mmc  := map_mm_liqc;
                         dpth := -5;
                      end;
         DID_cleft  : begin
                         r    := 0;
                         dpth := -6;
                         a    := d mod 3;
                         mmc  := c_black;
                      end;
         DID_rock   : begin
                         r    := 60;
                         a    := 13+((d mod 8) div 2);
                         dpth := 0;
                         mmc  := c_dgray;
                      end;
         DID_Brock  : begin
                         r    := 105;
                         a    := 17+((d mod 4) div 2);
                         dpth := 0;
                         mmc  := c_dgray;
                      end;
        end;

        mmx:=round(x*map_mmcx);
        mmy:=round(y*map_mmcx);
        if(r<20)
        then mmr:=1
        else mmr:=round(r*map_mmcx);

        break;
     end;
end;


procedure map_vars;
begin
   if(menu_s2<>ms2_camp)then
   begin
      if(map_mw<MinSMapW)then map_mw:=MinSMapW;
      if(map_mw>MaxSMapW)then map_mw:=MaxSMapW;
   end;
   map_flydpth[uf_ground ] := 0;
   map_flydpth[uf_soaring] := map_mw;
   map_flydpth[uf_fly    ] := map_mw*2;
   map_mmcx    := (vid_panel-2)/map_mw;
   map_mmvw    := trunc((vid_mw-vid_panel)*map_mmcx);
   map_mmvh    := trunc( vid_mh*map_mmcx);
   map_b1      := map_mw-build_b;
   fog_cw      := trunc(map_mw/fog_cs)+2;
   if((fog_cw mod 2)=0)then inc(fog_cw,1);
   fog_chw     := fog_cw div 2;
   fog_cr      := round(fog_chw*1.45);
   fog_vcnw    := ((vid_mw-vid_panel) div fog_cw)+1;
   fog_vcnh    := (vid_mh div fog_cw)+1;
   map_prmm    := round(g_ct_pr*map_mmcx);
   map_seed2   := map_seed;
   if(g_mode=gm_inv)or(map_liq=0)
   then map_ffly := false
   else map_ffly := (map_liq>=2)and(map_obs>=3);

   initUnits;
end;

function _spch(x,y,m:integer):boolean;
var p:byte;
begin
   _spch:=false;
   for p:=0 to MaxPlayers do
   begin
      _spch:=((dist2(x,y,map_psx[p],map_psy[p])-m)<map_psr[p]);
      if(_spch)then break;
   end;
end;

procedure MSkirmishStarts;
var ix,iy,i,u,c:integer;
begin
   for i:=0 to MaxPlayers do
   begin
      map_psr[i]:=base_rr+base_r;
      map_psx[i]:=-5000;
      map_psy[i]:=-5000;
   end;

   if(g_mode in [gm_coop,gm_inv])then
   begin
      map_psx[0]:=map_mw div 2;
      map_psy[0]:=map_psx[0];
   end;

   case g_mode of
   gm_2fort :
      begin
         ix:=map_mw div 2;
         u :=(map_mw-base_rr) div 2;
         i :=map_seed mod 360;

         map_psx[1]:=trunc(ix+cos(i*degtorad)*u);
         map_psy[1]:=trunc(ix+sin(i*degtorad)*u);
         inc(i,100);
         map_psx[2]:=map_psx[1]+trunc(cos(i*degtorad)*base_ir);
         map_psy[2]:=map_psy[1]+trunc(sin(i*degtorad)*base_ir);

         map_psx[4]:=map_mw-map_psx[1];
         map_psy[4]:=map_mw-map_psy[1];
         map_psx[3]:=map_mw-map_psx[2];
         map_psy[3]:=map_mw-map_psy[2];

         for i:=0 to MaxPlayers do map_psr[i]:=base_r+(map_obs*10)+(map_liq*40);
      end;
   gm_inv:
      begin
         u:=base_r;
         i:=map_mw div 2;
         map_psx[1]:=i+u;
         map_psy[1]:=i;
         map_psx[2]:=i-u;
         map_psy[2]:=i;
         map_psx[3]:=i;
         map_psy[3]:=i-u;
         map_psx[4]:=i;
         map_psy[4]:=i+u;
         for i:=0 to MaxPlayers do map_psr[i]:=base_r;
      end;
   else
      ix :=0;
      iy :=0;
      u  :=map_mw-base_r;

      for i:=1 to MaxPlayers do
      begin
         c:=0;
         repeat
           ix:=_gen(map_mw);
           iy:=_gen(map_mw)+50;
           inc(c,1);
         until (_spch(ix,iy,(c div 500)*5)=false)and(ix>base_r)and(iy>base_r)and(ix<u)and(iy<u);
         map_psx[i]:=ix;
         map_psy[i]:=iy;
      end;

      for i:=0 to MaxPlayers do map_psr[i]:=base_r-160+(map_obs*10)+(map_liq*40);

      if(g_mode=gm_ct)then
       for i:=1 to MaxPlayers do
        with g_ct_pl[i] do
        begin
           px:=i*102;
           py:=i*151;
           c:=0;
           repeat
             px:=_genx(px+py,map_mw,true);
             py:=_genx(py+px,map_mw,true);
             inc(c,1);
           until (_spch(px,py,(c div 500)*5)=false)and(px>base_r)and(py>base_r)and(px<u)and(py<u);

           mpx:=round(px*map_mmcx);
           mpy:=round(py*map_mmcx);
        end;
   end;
end;

procedure _bmm_draw(sd:TSob);
var d:integer;
begin
   for d:=1 to MaxDoodads do
    with map_dds[d] do
     if(t in sd)then
      if(mmr>0)
      then FilledcircleColor(_bminimap,mmx,mmy,mmr,mmc)
      else pixelColor(_bminimap,mmx,mmy,mmc);
end;

procedure map_bminimap;
begin
   sdl_FillRect(_bminimap,nil,0);
   _bmm_draw([DID_liquid]);
   _bmm_draw([DID_tree,DID_rock,DID_brock]);
end;

procedure map_dstarts;
var i:byte;
    x,y:integer;
    c:cardinal;
begin
   for i:=0 to MaxPlayers do
   begin
      if(g_mode=gm_inv)and(i=0)then continue;

      x:=trunc(map_psx[i]*map_mmcx);
      y:=trunc(map_psy[i]*map_mmcx);

      if(g_mode in [gm_inv,gm_2fort,gm_coop])
      then c:=plcolor[i]
      else c:=c_white;

      characterColor(_minimap,x-2,y-2,start_char,c);
      circleColor(_minimap,x+1,y+1,4,c);

      if(g_mode=gm_ct)and(i>0)then
       with g_ct_pl[i] do
        filledcircleColor(_minimap,mpx,mpy,map_prmm,c_aqua);
   end;
end;

function _dnear(ix,iy:integer):boolean;
var d:integer;
begin
   _dnear:=false;
   for d:=1 to MaxDoodads do
    with map_dds[d] do
     if(t>0)then
      if(dist2(x,y,ix,iy)<=r)then
      begin
         _dnear:=true;
         break;
      end;
end;

procedure Map_Make;
var i,ix,iy,lqs,rks,ddc,cnt:integer;
begin
   if(_ded=false)then boxColor(spr_mback,90,128,233,271,c_black);
   sdl_FillRect(_minimap,nil,0);
   Map_tdmake;
   FillChar(map_dds,SizeOf(map_dds),0);

   ddc:=trunc(MaxDoodads*((sqr(map_mw) div 1000000)/36));

   if(ddc>MaxDoodads)then ddc:=MaxDoodads;
   // 36 000 000
   //  9 000 000

   rks:=0;
   lqs:=0;

   iy :=(ddc div 5);
   ix :=(ddc div 10)+(iy*map_obs);
   if(map_liq>0)then
   begin
      lqs:=ix div (map_liq+1);
      rks:=ix-lqs;
   end
   else
   begin
      lqs:=0;
      rks:=ix;
   end;

   ix :=map_seed;
   iy :=0;

   for i:=1 to ddc do
   begin
      cnt:=0;
      repeat
        ix:=_genx(iy+(ix div 3),map_mw,false);
        iy:=_genx(ix+(iy div 5),map_mw,true);
        inc(cnt,1);
      until (_spch(ix,iy,0)=false)and(_dnear(ix,iy)=false)and(ix>=0)and(iy>=0)and(ix<=map_mw)and(iy<=map_mw)and(cnt<50);
      if(cnt=50)then continue;

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
        end
        else
          if(map_trt=0)or((map_trt in [10,17])and(map_liq>0)and(map_lqt=4))
          then _dds_a(ix,iy,DID_cleft)
          else _dds_a(ix,iy,DID_tree);
   end;

   map_bminimap;
   _draw_surf(_minimap,0,0,_bminimap);
   map_dstarts;
   if(_ded=false)then _draw_surf(spr_mback,91,129,_minimap);
   vid_mredraw:=true;
end;

procedure Map_lqttrt;
begin
   map_trt :=1+((map_seed div 100) mod 17);
   if(map_trt=7)
   then map_lqt:=map_seed mod 4
   else map_lqt:=map_seed mod 5;
   if(map_trt=17)then map_lqt :=4;
end;

procedure Map_randomseed;
begin
   map_seed :=random($FFFF);
   map_lqttrt;
end;

procedure Map_randommap;
begin
   map_randomseed;

   map_mw:=MinSMapW+round(random(MaxSMapW-MinSMapW)/500)*500;
   map_liq:=random(5);
   map_obs:=random(4)+1;
end;

procedure Map_premap;
begin
   Map_Vars;
   MSkirmishStarts;
   Map_lqttrt;
   MakeTerrain;
   MakeLiquid;
   Map_Make;
end;




