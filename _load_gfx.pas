
function SDL_GETpixel(srf:PSDL_SURFACE;x,y:integer):cardinal;
var bpp,r,g,b:byte;
begin
   SDL_GETpixel:=0;

   bpp:=srf^.format^.BytesPerPixel;

   case bpp of
      1:SDL_GETpixel:=TBa(srf^.pixels^)[(y*srf^.pitch)+x];
      2:SDL_GETpixel:=TWa(srf^.pixels^)[(y*srf^.pitch)+x];
      3:begin
           if(SDL_BYTEORDER=SDL_BIG_ENDIAN)then
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

procedure _FreeSF(sf:PSDL_Surface);
begin
   if(sf<>nil)and(sf<>vid_dsurf)then
   begin
      sdl_FreeSurface(sf);
      sf:=nil;
   end;
end;

{function loadIMG(fn:string):pSDL_SURFACE;
begin
   fn:=str_grp_fold+fn+#0;
   loadIMG:=sdl_loadbmp(@fn[1]);
   if (loadIMG=nil) then
   begin
      loadIMG:=vid_dsurf;
      WriteLog(fn);
   end;
end; }

function _loadsrf(fn:string;default:pSDL_Surface=nil):pSDL_SURFACE;
var tmp:pSDL_SURFACE;
begin
   if(default=nil)then default:=vid_dsurf;

   _loadsrf:=default;
   if(not FileExists(fn))then exit;

   fn:=fn+#0;

   tmp:=img_load(@fn[1]);
   if(tmp<>nil)then
   begin
      _loadsrf:=sdl_displayformat(tmp);
      sdl_freesurface(tmp);
   end;
end;

function loadIMG(fn:string;trns:boolean=false;log:boolean=true;default:pSDL_Surface=nil):pSDL_SURFACE;
var grpe:byte;
begin
   if(default=nil)then default:=vid_dsurf;
   for grpe:=1 to grp_extn do
   begin
      loadIMG:=_loadsrf(str_grp_fold+fn+grp_exts[grpe],default);
      if(loadIMG<>default)then
      begin
         if(trns)then SDL_SetColorKey(loadIMG,SDL_SRCCOLORKEY+SDL_RLEACCEL,SDL_GETpixel(loadIMG,0,0));
         break;
      end;
   end;
   if(log)and(loadIMG=default)then WriteLog(str_grp_fold+fn);
end;


procedure MakeLiquid;
var ts:psdl_surface;
x,y,l,p:integer;
fn:string;
begin
   if(map_plqt=map_lqt)and(map_plqt<255)then exit;
   map_plqt:=map_lqt;

   map_mm_liqc:=c_gray;
   if(map_lqt=0)then map_mm_liqc:=c_dblue;
   if(map_lqt=1)then map_mm_liqc:=c_green;
   if(map_lqt=2)then map_mm_liqc:=c_brown;
   if(map_lqt=3)then map_mm_liqc:=c_red;

   fn:='liquid_'+b2s(map_lqt);
   ts:=loadIMG(fn);

  for l:=1 to LiquidAnim do
   with spr_liquid[l] do
   begin
      if(surf<>nil) then
      begin
         sdl_freesurface(surf);
         surf:=nil;
      end;
      surf:=sdl_createRGBSurface(0,liquid_d,liquid_d,vid_bpp,0,0,0,0);
      x:=-l*(ts^.w div 4);
      while (x<liquid_d) do
      begin
         y:=-l*(ts^.h div 4);
         while (y<liquid_d) do
         begin
            _draw_surf(surf,x,y,ts);
            inc(y,ts^.h);
         end;
         inc(x,ts^.w);
      end;

      x:=0;
      while (x<360) do
      begin
         p:=5+random(15);
         inc(x,3);
         y:=trunc(liquid_r*1.05*sin(x*degtorad));
         dec(y,y div 5);
         inc(y,liquid_r);
         filledcircleColor(surf,liquid_r+trunc(liquid_r*1.05*cos(x*degtorad)),y+5,p,c_black);
      end;

      x:=0;
      while (x<360) do
      begin
         p:=liquid_r-5;
         inc(x,3);
         y:=trunc(liquid_d*sin(x*degtorad));
         dec(y,y div 12);
         inc(y,liquid_r+5);
         filledcircleColor(surf,
         liquid_r+trunc(liquid_d*cos(x*degtorad)),
         y,
         p,c_black);
      end;



      SDL_SetColorKey(surf,SDL_SRCCOLORKEY+SDL_RLEACCEL,sdl_getpixel(surf,0,0));

      hw:=liquid_r;
      hh:=liquid_r;
   end;

   sdl_freesurface(ts);
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
   fn:='ter'+b2s(map_trt);
   ter_s:=loadIMG(fn);
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
end;

function _lstr(fn:string):TUSprite;
begin
   with _lstr do
   begin
      surf:=LoadIMG(fn);
      hw:=surf^.w div 2;
      hh:=surf^.h div 2;
      SDL_SetColorKey(surf,SDL_SRCCOLORKEY+SDL_RLEACCEL,sdl_getpixel(surf,0,0));
   end;
end;

procedure LoadFont;
var i:byte;
    c:char;
    ccc:cardinal;
   fspr:pSDL_Surface;
begin
   ccc:=(1 shl 24)-1;
   fspr:=loadIMG('rufont');
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
var i:byte;
begin
   spr_panel:=LoadIMG('panel');
   SDL_SetColorKey(spr_panel,SDL_RLEACCEL,sdl_getpixel(spr_panel,1,1));

   spr_cursor:=LoadIMG('cursor');
   SDL_SetColorKey(spr_cursor,SDL_SRCCOLORKEY+SDL_RLEACCEL,sdl_getpixel(spr_cursor,0,spr_cursor^.h-1));

   spr_mouse_in:=LoadIMG('mouse');
   SDL_SetColorKey(spr_mouse_in,SDL_SRCCOLORKEY+SDL_RLEACCEL,sdl_getpixel(spr_mouse_in,spr_mouse_in^.w-1,0));

   spr_m_back :=LoadIMG('mback');
   spr_m_sl   :=LoadIMG('msl');

   spr_b_rfast  :=LoadIMG('b_rfast');
   spr_b_rskip  :=LoadIMG('b_rskip');

   spr_cancle:=LoadIMG('b_cancle');
   spr_toxin:=LoadIMG('toxin');SDL_SetColorKey(spr_toxin,SDL_SRCCOLORKEY+SDL_RLEACCEL,sdl_getpixel(spr_toxin,0,0));
   spr_hg_eff:=LoadIMG('h_b1_3_eff');SDL_SetColorKey(spr_hg_eff,SDL_SRCCOLORKEY+SDL_RLEACCEL,sdl_getpixel(spr_hg_eff,0,0));

   spr_mp[r_hell]:=LoadIMG('h_mp'); SDL_SetColorKey(spr_mp[r_hell],SDL_SRCCOLORKEY+SDL_RLEACCEL,sdl_getpixel(spr_mp[r_hell],0,0));
   spr_mp[r_uac ]:=LoadIMG('u_mp'); SDL_SetColorKey(spr_mp[r_uac ],SDL_SRCCOLORKEY+SDL_RLEACCEL,sdl_getpixel(spr_mp[r_uac ],0,0));

   spr_sport[0]:=_lstr('sport0');
   spr_sport[1]:=_lstr('sport1');

   for i:=0 to 7 do
   begin
      spr_b_u[r_hell,i]:=LoadIMG('b_h_u'+b2s(i));SDL_SetColorKey(spr_b_u[r_hell,i],SDL_SRCCOLORKEY+SDL_RLEACCEL,sdl_getpixel(spr_b_u[r_hell,i],0,0));
      spr_b_u[r_uac ,i]:=LoadIMG('b_u_u'+b2s(i));SDL_SetColorKey(spr_b_u[r_uac ,i],SDL_SRCCOLORKEY+SDL_RLEACCEL,sdl_getpixel(spr_b_u[r_uac ,i],0,0));
   end;

   spr_mine:=_lstr('u_mine');

   with spr_dum do
   begin
      surf:=vid_dsurf;
      hh:=1;
      hw:=1;
   end;

   spr_hbarrak:=_lstr('h_hbarrak');

   for i:=0 to 2 do
   begin
      spr_explode[i]:=_lstr('ef_exp_'+b2s(i));

      spr_blood[i]:=_lstr('blood'+b2s(i));
   end;

   for i:=0 to 3 do
   begin
      spr_b[2,0,i]:=_lstr('u_b0_'+b2s(i));
      spr_b[2,1,i]:=_lstr('u_b1_'+b2s(i));
      spr_b[2,2,i]:=_lstr('u_b2_'+b2s(i));
      spr_b[2,3,i]:=_lstr('u_b3_'+b2s(i));
      spr_b[2,4,i]:=_lstr('u_b4_'+b2s(i));
      spr_b[2,5,i]:=_lstr('u_b5_'+b2s(i));

      spr_b[1,0,i]:=_lstr('h_b0_'+b2s(i));
      spr_b[1,1,i]:=_lstr('h_b1_'+b2s(i));
      spr_b[1,2,i]:=_lstr('h_b2_'+b2s(i));
      spr_b[1,3,i]:=_lstr('h_b3_'+b2s(i));
      spr_b[1,4,i]:=_lstr('h_b4_'+b2s(i));
      spr_b[1,5,i]:=_lstr('h_b5_'+b2s(i));

      spr_bfg[i]:=_lstr('ef_bfg_'+b2s(i));
      spr_h_p0[i]:=_lstr('h_p0_'+b2s(i));
      spr_h_p1[i]:=_lstr('h_p1_'+b2s(i));
      spr_h_p2[i]:=_lstr('h_p2_'+b2s(i));

      spr_u_p1[i]:=_lstr('u_p1_'+b2s(i));

      spr_build[i]:=_lstr('build'+b2s(i));
   end;

   for i:=0 to 5 do
   begin
      spr_u_base[i]:=_lstr('u_base'+b2s(i));

      spr_teleport[i]:=_lstr('ef_tel_'+b2s(i));
      spr_u_p0[i]:=_lstr('u_p0_'+b2s(i));
      spr_u_p2[i]:=_lstr('u_p2_'+b2s(i));
      spr_bex1[i]:=_lstr('ef_eb'+b2s(i));

      spr_b_b[r_hell,i]:=LoadIMG('b_h_b'+b2s(i));
      spr_b_b[r_uac ,i]:=LoadIMG('b_u_b'+b2s(i));
   end;


   for i:=0 to 7 do
   begin
      spr_h_p3[i]:=_lstr('h_p3_'+b2s(i));

      spr_b_up[1,i]:=LoadIMG('b_h_up'+b2s(i));
      spr_b_up[2,i]:=LoadIMG('b_u_up'+b2s(i));

      spr_vgvn[i]:=_lstr('g_'+b2s(i));
   end;

   for i:=0 to 10 do  spr_decs[i]:=_lstr('dec_'+b2s(i));

   for i:=0 to 8 do spr_bex2[i]:=_lstr('ef_ebb'+b2s(i));

   for i:=0 to 15 do spr_ut[i]:=_lstr('ut_'+b2s(i));

   for i:=0 to 28 do spr_h_u0[i]:=_lstr('h_u0_'+b2s(i));
   for i:=0 to 52 do spr_h_u1[i]:=_lstr('h_u1_'+b2s(i));
   for i:=0 to 53 do spr_h_u2[i]:=_lstr('h_u2_'+b2s(i));
   for i:=0 to 29 do spr_h_u3[i]:=_lstr('h_u3_'+b2s(i));
   for i:=0 to 52 do spr_h_u4[i]:=_lstr('h_u4_'+b2s(i));
   for i:=0 to 56 do spr_h_u5[i]:=_lstr('h_u5_'+b2s(i));
   for i:=0 to 81 do spr_h_u6[i]:=_lstr('h_u6_'+b2s(i));

   for i:=0 to 52 do spr_h_z0[i]:=_lstr('h_z0_'+b2s(i));
   for i:=0 to 52 do spr_h_z1[i]:=_lstr('h_z1_'+b2s(i));
   for i:=0 to 59 do spr_h_z2[i]:=_lstr('h_z2_'+b2s(i));
   for i:=0 to 52 do spr_h_z3[i]:=_lstr('h_z3_'+b2s(i));
   for i:=0 to 15 do spr_h_z4j[i]:=_lstr('h_z4j_'+b2s(i));
   for i:=0 to 52 do spr_h_z5[i]:=_lstr('h_z5_'+b2s(i));

   for i:=0 to 52 do spr_u_u0[i]:=_lstr('u_u0_'+b2s(i));
   for i:=0 to 44 do spr_u_u1[i]:=_lstr('u_u1_'+b2s(i));
   for i:=0 to 44 do spr_u_u2[i]:=_lstr('u_u2_'+b2s(i));
   for i:=0 to 52 do spr_u_u3[i]:=_lstr('u_u3_'+b2s(i));
   for i:=0 to 44 do spr_u_u4[i]:=_lstr('u_u4_'+b2s(i));
   for i:=0 to 15 do spr_u_u5[i]:=_lstr('u_u5j_'+b2s(i));
   for i:=0 to 44 do spr_u_u6[i]:=_lstr('u_u6_'+b2s(i));
   for i:=0 to 15 do spr_u_u7[i]:=_lstr('u_u8_'+b2s(i));

   spr_h_altar :=_lstr('h_altar');
   spr_u_portal:=_lstr('u_portal');
   spr_h_fortes:=_lstr('h_fortess');
   spr_c_earth :=LoadIMG('M_EARTH');
   spr_c_mars  :=LoadIMG('M_MARS');
   spr_c_hell  :=LoadIMG('M_HELL');
   spr_c_phobos:=LoadIMG('M_PHOBOS');
   spr_c_deimos:=LoadIMG('M_DEIMOS');

   spr_db_h0:=_lstr('db_h0');
   spr_db_h1:=_lstr('db_h1');
   spr_db_u0:=_lstr('db_u0');
   spr_db_u1:=_lstr('db_u1');

   for i:=1 to MaxADecSpr do spr_adecs[i]:=_lstr('adt'+b2s(i));

   LoadFont;
end;





