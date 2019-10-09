
function SDL_GETpixel(srf:PSDL_SURFACE;x,y:word):cardinal;
var bpp,r,g,b:byte;
begin
   SDL_GETpixel:=0;

   bpp:=srf^.format^.BytesPerPixel;

   case bpp of
      1:SDL_GETpixel:=TBa(srf^.pixels^)[(y*srf^.pitch)+x];
      2:SDL_GETpixel:=TWa(srf^.pixels^)[(y*srf^.pitch)+x];
      3:begin
           if(SDL_byteorder = SDL_big_endian)then
           begin
              r:=TBa(srf^.pixels^)[(y*srf^.pitch)+(x*bpp)];
              g:=TBa(srf^.pixels^)[(y*srf^.pitch)+(x*bpp)+1];
              b:=TBa(srf^.pixels^)[(y*srf^.pitch)+(x*bpp)+2];
           end
           else
           begin
              b:=TBa(srf^.pixels^)[(y*srf^.pitch)+(x*bpp)];
              g:=TBa(srf^.pixels^)[(y*srf^.pitch)+(x*bpp)+1];
              r:=TBa(srf^.pixels^)[(y*srf^.pitch)+(x*bpp)+2];
           end;
           SDL_GETpixel:=(r shl 16)+(g shl 8)+b;
        end;
      4:SDL_GETpixel:=TCa(srf^.pixels^)[y*srf^.w+x];
   else
   end;
end;

function _loadsrf(fn:string):pSDL_SURFACE;
var tmp:pSDL_SURFACE;
begin
   _loadsrf:=_dsurf;
   if(not FileExists(fn))then exit;

   fn:=fn+#0;

   tmp:=img_load(@fn[1]);
   if(tmp<>nil)then
   begin
      _loadsrf:=sdl_displayformat(tmp);
      sdl_freesurface(tmp);
   end;
end;

function loadIMG(fn:string;trns:boolean):pSDL_SURFACE;
begin
   loadIMG:=_loadsrf(str_folder_gr+fn+'.png');

   if(loadIMG=_dsurf)then loadIMG:=_loadsrf(str_folder_gr+fn+'.jpg');
   if(loadIMG=_dsurf)then loadIMG:=_loadsrf(str_folder_gr+fn+'.bmp');
   if(loadIMG=_dsurf)then WriteLog(str_folder_gr+fn);

   if(trns)and(loadIMG<>_dsurf)then SDL_SetColorKey(loadIMG,SDL_SRCCOLORKEY+SDL_RLEACCEL,sdl_getpixel(loadIMG,0,0));
end;

procedure _FreeSF(sf:PSDL_Surface);
begin
   if(sf<>nil)and(sf<>_dsurf)then
   begin
      sdl_FreeSurface(sf);
      sf:=nil;
   end;
end;

procedure MakeLiquid;
var ts:psdl_surface;
x,y,l,p:integer;
fn:string;
begin
   if(map_plqt=map_lqt)and(map_plqt<255)and(map_pliq=map_liq)and(map_pliq<255)then exit;
   map_pliq:=map_liq;
   map_plqt:=map_lqt;

   map_mm_liqc:=c_gray;
   if(map_lqt=0)then map_mm_liqc:=c_dblue;
   if(map_lqt=1)then map_mm_liqc:=c_green;
   if(map_lqt=2)then map_mm_liqc:=c_brown;
   if(map_lqt=3)then map_mm_liqc:=c_dred;
   if(map_lqt=4)then map_mm_liqc:=c_lava;

   if(_ded)then exit;

   fn:='liquid_'+b2s(map_lqt);
   ts:=loadIMG(fn,false);

  for l:=1 to LiquidAnim do
   with spr_liquid[l] do
   begin
      if(surf<>nil) then
      begin
         sdl_freesurface(surf);
         surf:=nil;
      end;
      surf:=sdl_createRGBSurface(0,liquid_d[map_liq],liquid_d[map_liq],vid_bpp,0,0,0,0);

      x:=-l*(ts^.w div 4);
      while (x<liquid_d[map_liq]) do
      begin
         y:=-l*(ts^.h div 4);
         while (y<liquid_d[map_liq]) do
         begin
            _draw_surf(surf,x,y,ts);
            inc(y,ts^.h);
         end;
         inc(x,ts^.w);
      end;

      x:=0;
      y:=1200 div liquid_d[map_liq];
      while (x<360) do
      begin
         p:=5+random(liquid_r[map_liq] div 10);
         inc(x,y);
         filledcircleColor(
         surf,
         liquid_r[map_liq]+trunc(liquid_r[map_liq]*1.05*cos(x*degtorad)),
         liquid_r[map_liq]+trunc(liquid_r[map_liq]*1.05*sin(x*degtorad)),
         p,c_black);
      end;

      x:=0;
      while (x<360) do
      begin
         p:=liquid_r[map_liq]-5;
         inc(x,3);
         y:=trunc(liquid_d[map_liq]*sin(x*degtorad));
         inc(y,liquid_r[map_liq]+5);
         filledcircleColor(surf,
         liquid_r[map_liq]+trunc(liquid_d[map_liq]*cos(x*degtorad)),
         y,
         p,c_black);
      end;

      SDL_SetColorKey(surf,SDL_SRCCOLORKEY+SDL_RLEACCEL,sdl_getpixel(surf,0,0));

      hw:=liquid_r[map_liq];
      hh:=liquid_r[map_liq];
   end;

   sdl_freesurface(ts);
end;

procedure MakeCrater;
var x,y,p:integer;
    clr:cardinal;
begin
   case map_trt of
     0,17 : clr:=rgba2c(120,50 ,0  ,50);  // red
     7,
     6,15 : clr:=rgba2c(0  ,200,0  ,25);  // green
     8    : clr:=rgba2c(150,150,100,20);  // yellow gray
     9    : clr:=rgba2c(200,200,50 ,20);  // yellow
     11   : clr:=rgba2c(100,100,100,55);  // gray
     16   : clr:=rgba2c(0,0,0,100);
   else
     clr:=rgba2c(0,0,0,65);
   end;

   with spr_crater do
   begin
      if(surf<>nil) then
      begin
         sdl_freesurface(surf);
         surf:=nil;
      end;
      surf:=sdl_createRGBSurface(0,crater_d,crater_d,vid_bpp,0,0,0,0);
      _draw_surf(surf,0,0,vid_terrain);
      boxColor(surf,0,0,crater_d,crater_d,clr);

      x:=0;
      while (x<360) do
      begin
         p:=10+random(10);
         inc(x,18);
         y:=trunc(crater_r*1.05*sin(x*degtorad));
         inc(y,crater_r+5);
         filledcircleColor(surf,
         crater_r+trunc(crater_r*1.05*cos(x*degtorad)),
         y,p,c_purple);
      end;

      x:=0;
      while (x<360) do
      begin
         p:=crater_r-5;
         inc(x,3);
         y:=trunc(crater_d*sin(x*degtorad));
         inc(y,crater_r+5);
         filledcircleColor(surf,
         crater_r+trunc(crater_d*cos(x*degtorad)),
         y,
         p,c_purple);
      end;

      SDL_SetColorKey(surf,SDL_SRCCOLORKEY+SDL_RLEACCEL,sdl_getpixel(surf,0,0));

      hw:=crater_r;
      hh:=crater_r;
   end;
end;

function _lstr(fn:string):TUSprite;
begin
   with _lstr do
   begin
      surf:=LoadIMG(fn,true);
      hw:=surf^.w div 2;
      hh:=surf^.h div 2;
   end;
end;

procedure reload_decs;
var i:byte;
  clr:cardinal;
begin
   for i:=0 to MaxSDecs do if(spr_sdecs[i].surf<>nil)then sdl_freesurface(spr_sdecs[i].surf);
   for i:=1 to MaxTDecs do if(spr_tdecs[i].surf<>nil)then sdl_freesurface(spr_tdecs[i].surf);

   case map_trt of
     0,17 : clr:=rgba2c(120,0  ,0  ,70);  // red
     6,15 : clr:=rgba2c(0  ,200,0  ,15);  // green
     8,9  : clr:=rgba2c(200,200,50 ,15);  // yellow
     12   : clr:=rgba2c(255,255,255,20);  // white
     11   : clr:=rgba2c(100,100,100,55);  // gray
   else
     clr:=0;
   end;

   for i:=0 to MaxSDecs do
   begin
      spr_sdecs[i]:=_lstr('dec_'+b2s(i));
      if(clr>0)then
       with spr_sdecs[i] do
       begin
          boxColor(surf,0,0,surf^.w-1,surf^.h-1,clr);
          SDL_SetColorKey(surf,SDL_SRCCOLORKEY+SDL_RLEACCEL,sdl_getpixel(surf,0,0));
       end;
   end;

   for i:=1 to MaxTDecs do
   begin
      spr_tdecs[i]:=_lstr('adt'+b2s(i));
      if(clr>0)then
       with spr_tdecs[i] do
       begin
          boxColor(surf,0,0,surf^.w-1,surf^.h-1,clr);
          SDL_SetColorKey(surf,SDL_SRCCOLORKEY+SDL_RLEACCEL,sdl_getpixel(surf,0,0));
       end;
   end;
end;

procedure MakeTerrain;
var x,y,w,h:integer;
    fn:string;
begin
   if(map_ptrt=map_trt)and(map_ptrt<255)then exit;
   if(vid_terrain<>nil) then
   begin
      sdl_freesurface(vid_terrain);
      vid_terrain:=nil;
   end;
   if(ter_s<>nil) then
   begin
      sdl_freesurface(ter_s);
      ter_s:=nil;
   end;
   map_ptrt:=map_trt;

   if(_ded)then exit;

   fn:='ter'+b2s(map_trt);
   ter_s:=loadIMG(fn,false);
   ter_w:=ter_s^.w;
   ter_h:=ter_s^.h;
   w:=vid_mw+(ter_w shl 1)-vid_panel;
   h:=vid_mh+(ter_h shl 1);
   vid_terrain:=sdl_createRGBSurface(0,w,h,vid_bpp,0,0,0,0);
   x:=0;

   while (x<w) do
   begin
      y:=0;
      while (y<w) do
      begin
         _draw_surf(vid_terrain,x,y,ter_s);
         inc(y,ter_s^.h);
      end;
      inc(x,ter_s^.w);
   end;

   reload_decs;
   MakeCrater;
end;

procedure LoadFont;
var i:byte;
    c:char;
  ccc:cardinal;
 fspr:pSDL_Surface;
begin
   ccc:=(1 shl 24)-1;
   fspr:=loadIMG('rufont',false);
   for i:=0 to 255 do
   begin
      c:=chr(i);
      font_ca[c]:=sdl_createRGBSurface(0,font_w,font_w,vid_bpp,0,0,0,0);
      SDL_FillRect(font_ca[c],nil,0);
      SDL_SetColorKey(font_ca[c],SDL_SRCCOLORKEY+SDL_RLEACCEL,ccc);

      if(192<=i)then
      begin
         _rect^.x:=ord(i-192)*font_w;
         _rect^.y:=0;
         _rect^.w:=font_w;
         _rect^.h:=font_w;
         SDL_BLITSURFACE(fspr,_rect,font_ca[c],nil);
      end
      else characterColor(font_ca[c],0,0,c,c_white);
   end;
   _FreeSF(fspr);
end;

procedure LoadGraphics;
var x:integer;
begin
   spr_dummy.hh:=1;
   spr_dummy.hw:=1;
   spr_dummy.surf:=_dsurf;

   LoadFont;

   if(_ded)then exit;

   spr_mback      := loadIMG('mback'   ,false);

   mv_x:=(vid_mw-spr_mback^.w) div 2;
   mv_y:=(vid_mh-spr_mback^.h) div 2;

   spr_cursor     := loadIMG('cursor'  ,true);
   spr_msl        := loadIMG('msl'     ,false);
   spr_panel      := loadIMG('panel'   ,false);
   spr_MBackmlt   := loadIMG('mbackmlt',false);

   spr_b_action   := loadIMG('b_action'  ,true);
   spr_b_cancle   := loadIMG('b_cancle'  ,true);
   spr_b_delete   := loadIMG('b_destroy' ,true);

   spr_b_rfast    := LoadIMG('b_rfast',true);
   spr_b_rskip    := LoadIMG('b_rskip',true);
   spr_b_rfog     := LoadIMG('b_fog',false);
   spr_b_rlog     := LoadIMG('b_log',false);

   spr_c_earth    := LoadIMG('M_EARTH' ,false);
   spr_c_mars     := LoadIMG('M_MARS'  ,false);
   spr_c_hell     := LoadIMG('M_HELL'  ,false);
   spr_c_phobos   := LoadIMG('M_PHOBOS',false);
   spr_c_deimos   := LoadIMG('M_DEIMOS',false);

   for x:=0 to 2 do spr_tabs[x]:=loadIMG('tabs'+b2s(x),true);

   for x:=0 to 8 do
   begin
      spr_b_b[r_hell,x]:=loadIMG('b_h_b'+b2s(x),false);
      spr_b_b[r_uac ,x]:=loadIMG('b_u_b'+b2s(x),false);
   end;

   for x:=0 to 11 do
   begin
      spr_b_u[r_hell,x]:=loadIMG('b_h_u'+b2s(x),false);
      spr_b_u[r_uac ,x]:=loadIMG('b_u_u'+b2s(x),false);
   end;

   for x:=0 to MaxUpgrs do
   begin
      spr_b_up[r_hell,x]:=loadIMG('b_h_up'+b2s(x),false);
      spr_b_up[r_uac ,x]:=loadIMG('b_u_up'+b2s(x),false);
   end;
   spr_h_u4k      := loadIMG('b_h_u4k',false);

   spr_u_portal   := _lstr('u_portal');
   spr_db_h0      := _lstr('db_h0');
   spr_db_h1      := _lstr('db_h1');
   spr_db_u0      := _lstr('db_u0');
   spr_db_u1      := _lstr('db_u1');
   spr_HAltar     := _lstr('h_altar');
   spr_HTotem     := _lstr('h_b7');
   spr_HMonastery := _lstr('h_b6');
   spr_HFortress  := _lstr('h_fortess');
   spr_HBar       := _lstr('h_hbarrak');
   spr_mine       := _lstr('u_mine');
   spr_toxin      := _lstr('toxin');
   spr_gear       := _lstr('gear');

   spr_mp[r_hell] := _lstr('h_mp');
   spr_mp[r_uac ] := _lstr('u_mp');

   _draw_surf(_uipanel,0,0,spr_panel);

   for x:=0 to 3 do spr_eff_bfg [x]:= _lstr('ef_bfg_'+b2s(x));
   for x:=0 to 5 do spr_eff_eb  [x]:= _lstr('ef_eb'  +b2s(x));
   for x:=0 to 8 do spr_eff_ebb [x]:= _lstr('ef_ebb' +b2s(x));
   for x:=0 to 5 do spr_eff_tel [x]:= _lstr('ef_tel_'+b2s(x));
   for x:=0 to 2 do spr_eff_exp [x]:= _lstr('ef_exp_'+b2s(x));
   for x:=0 to 4 do spr_eff_exp2[x]:= _lstr('exp2_'  +b2s(x));
   for x:=0 to 7 do spr_eff_g   [x]:= _lstr('g_'     +b2s(x));

   for x:=0 to 3  do spr_h_p0[x]:= _lstr('h_p0_'+b2s(x));
   for x:=0 to 3  do spr_h_p1[x]:= _lstr('h_p1_'+b2s(x));
   for x:=0 to 3  do spr_h_p2[x]:= _lstr('h_p2_'+b2s(x));
   for x:=0 to 7  do spr_h_p3[x]:= _lstr('h_p3_'+b2s(x));
   for x:=0 to 10 do spr_h_p4[x]:= _lstr('h_p4_'+b2s(x));
   for x:=0 to 7  do spr_h_p5[x]:= _lstr('h_p5_'+b2s(x));
   for x:=0 to 7  do spr_h_p6[x]:= _lstr('h_p6_'+b2s(x));
   for x:=0 to 5  do spr_h_p7[x]:= _lstr('h_p7_'+b2s(x));

   for x:=0 to 5  do spr_u_p0[x]:= _lstr('u_p0_'+b2s(x));
   for x:=0 to 3  do spr_u_p1[x]:= _lstr('u_p1_'+b2s(x));
   for x:=0 to 5  do spr_u_p2[x]:= _lstr('u_p2_'+b2s(x));
   for x:=0 to 7  do spr_u_p3[x]:= _lstr('u_p3_'+b2s(x));

   for x:=0 to 2  do spr_blood[x]:= _lstr('blood'+b2s(x));

   for x:=0 to 28 do spr_lostsoul   [x]:=_lstr('h_u0_' +b2s(x));
   for x:=0 to 52 do spr_imp        [x]:=_lstr('h_u1_' +b2s(x));
   for x:=0 to 53 do spr_demon      [x]:=_lstr('h_u2_' +b2s(x));
   for x:=0 to 29 do spr_cacodemon  [x]:=_lstr('h_u3_' +b2s(x));
   for x:=0 to 52 do spr_baron      [x]:=_lstr('h_u4_' +b2s(x));
   for x:=0 to 52 do spr_knight     [x]:=_lstr('h_u4k_'+b2s(x));
   for x:=0 to 56 do spr_cyberdemon [x]:=_lstr('h_u5_' +b2s(x));
   for x:=0 to 81 do spr_mastermind [x]:=_lstr('h_u6_' +b2s(x));
   for x:=0 to 37 do spr_pain       [x]:=_lstr('h_u7_' +b2s(x));
   for x:=0 to 76 do spr_revenant   [x]:=_lstr('h_u8_' +b2s(x));
   for x:=0 to 78 do spr_mancubus   [x]:=_lstr('h_u9_' +b2s(x));
   for x:=0 to 69 do spr_arachnotron[x]:=_lstr('h_u10_'+b2s(x));
   for x:=0 to 85 do spr_archvile   [x]:=_lstr('h_u11_'+b2s(x));

   for x:=0 to 52 do spr_ZFormer    [x]:=_lstr('h_z0_' +b2s(x));
   for x:=0 to 52 do spr_ZSergant   [x]:=_lstr('h_z1_' +b2s(x));
   for x:=0 to 52 do spr_ZSSergant  [x]:=_lstr('h_z1s_'+b2s(x));
   for x:=0 to 59 do spr_ZCommando  [x]:=_lstr('h_z2_' +b2s(x));
   for x:=0 to 52 do spr_ZBomber    [x]:=_lstr('h_z3_' +b2s(x));
   for x:=0 to 15 do spr_ZFMajor    [x]:=_lstr('h_z4j_'+b2s(x));
   for x:=0 to 52 do spr_ZMajor     [x]:=_lstr('h_z4_' +b2s(x));
   for x:=0 to 52 do spr_ZBFG       [x]:=_lstr('h_z5_' +b2s(x));

   for x:=0 to 44 do spr_engineer   [x]:=_lstr('u_u1_' +b2s(x));
   for x:=0 to 52 do spr_medic      [x]:=_lstr('u_u0_' +b2s(x));
   for x:=0 to 44 do spr_sergant    [x]:=_lstr('u_u2_' +b2s(x));
   for x:=0 to 44 do spr_ssergant   [x]:=_lstr('u_u2s_'+b2s(x));
   for x:=0 to 52 do spr_commando   [x]:=_lstr('u_u3_' +b2s(x));
   for x:=0 to 44 do spr_bomber     [x]:=_lstr('u_u4_' +b2s(x));
   for x:=0 to 15 do spr_fmajor     [x]:=_lstr('u_u5j_'+b2s(x));
   for x:=0 to 44 do spr_major      [x]:=_lstr('u_u5_' +b2s(x));
   for x:=0 to 44 do spr_BFG        [x]:=_lstr('u_u6_' +b2s(x));
   for x:=0 to 15 do spr_FAPC       [x]:=_lstr('u_u8_' +b2s(x));
   for x:=0 to 15 do spr_APC        [x]:=_lstr('uac_tank_' +b2s(x));
   for x:=0 to 55 do spr_Terminator [x]:=_lstr('u_u9_' +b2s(x));
   for x:=0 to 23 do spr_Tank       [x]:=_lstr('u_u10_'+b2s(x));
   for x:=0 to 15 do spr_Flyer      [x]:=_lstr('u_u11_'+b2s(x));

   for x:=0 to 15 do spr_tur        [x]:=_lstr('ut_'+b2s(x));
   for x:=0 to 7  do spr_rtur       [x]:=_lstr('u_rt_'+b2s(x));

   for x:=0 to 7  do spr_trans      [x]:=_lstr('transport'+b2s(x));

   for x:=0 to 1  do spr_sport      [x]:=_lstr('sport'+b2s(x));

   for x:=0 to 7  do spr_drone      [x]:=_lstr('l_dron_'+b2s(x));
   for x:=0 to 19 do spr_octo       [x]:=_lstr('l_oct_' +b2s(x));
   for x:=0 to 54 do spr_cycl       [x]:=_lstr('l_cy_'  +b2s(x));
   for x:=0 to 4  do spr_o_p        [x]:=_lstr('l_p0_'  +b2s(x));

   for x:=0 to 3 do
   begin
      spr_HKeep           [x]:=_lstr('h_b0_' +b2s(x));
      spr_HGate           [x]:=_lstr('h_b1_' +b2s(x));
      spr_HSymbol         [x]:=_lstr('h_b2_' +b2s(x));
      spr_HPools          [x]:=_lstr('h_b3_' +b2s(x));
      spr_HTower          [x]:=_lstr('h_b4_' +b2s(x));
      spr_HTeleport       [x]:=_lstr('h_b5_' +b2s(x));

      spr_UCommandCenter  [x]:=_lstr('u_b0_' +b2s(x));
      spr_UMilitaryUnit   [x]:=_lstr('u_b1_' +b2s(x));
      spr_UGenerator      [x]:=_lstr('u_b2_' +b2s(x));
      spr_UWeaponFactory  [x]:=_lstr('u_b3_' +b2s(x));
      spr_UTurret         [x]:=_lstr('u_b4_' +b2s(x));
      spr_URadar          [x]:=_lstr('u_b5_' +b2s(x));
      spr_UVehicleFactory [x]:=_lstr('u_b6_' +b2s(x));
      spr_URTurret        [x]:=_lstr('u_b7_' +b2s(x));
      spr_URocketL        [x]:=_lstr('u_b8_' +b2s(x));

      spr_cbuild          [x]:=_lstr('build' +b2s(x));
   end;

   for x:=0 to 5 do spr_ubase[x]:=_lstr('u_base' +b2s(x));
end;
