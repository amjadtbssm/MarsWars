
function InitVideo:boolean;
begin
   InitVideo:=false;

   if SDL_Init(SDL_INIT_VIDEO)<>0 then begin WriteError; exit; end;

   SDL_putenv('SDL_VIDEO_WINDOW_POS');
   SDL_putenv('SDL_VIDEO_CENTERED=1');

   _MakeScreen;
   if (vid_screen=nil) then  begin WriteError; exit; end;

   vid_dsurf:=sdl_createRGBSurface(0,1,1,vid_bpp,0,0,0,0);
   if (vid_dsurf=nil) then  begin WriteError; exit; end;

   vid_minimap:=sdl_createRGBSurface(0,vid_panel-2,vid_panel-2,vid_bpp,0,0,0,0);
   if (vid_minimap=nil) then  begin WriteError; exit; end;

   vid_spanel:=sdl_createRGBSurface(0,vid_panel+1,vid_mh,vid_bpp,0,0,0,0);
   if (vid_spanel=nil) then  begin WriteError; exit; end;

   vid_terrain:=sdl_createRGBSurface(0,1, 1, vid_bpp,0,0,0,0);
   if (vid_terrain=nil) then  begin WriteError; exit; end;

   vid_menu:=sdl_createRGBSurface(0,vid_mw, vid_mh, vid_bpp,0,0,0,0);
   if (vid_menu=nil) then begin WriteError; exit; end;

   InitVideo:=true;
end;

procedure InitFogR;
var r,x:byte;
begin
   for r:=0 to MFogM do
    for x:=0 to r do
     _fcx[r,x]:=trunc(sqrt(sqr(r)-sqr(x)));
end;

procedure StartParams;
var t:byte;
    s:string;
begin
   t:=ParamCount;
   if t>0 then
   begin
      s:=ParamStr(1);

      if(s='k@k')then _testmode:=true;
      if(s='connect')then
      begin
         startcon:=true;
         startcons:=ParamStr(2);
      end;
   end;
end;

procedure IntGame;
begin
   _CYCLE:=false;

   StartParams;

   lng_eng;
   cfg_read;

   if not(InitVideo) then exit;
   if not(initNET)   then exit;
   if not(InitSound) then exit;

   SDL_ShowCursor(0);
   SDL_WM_SetCaption(@str_wcaption[1], nil );
   SDL_enableUNICODE(1);

   NEW(_event);
   NEW(_rect);

   m_sxs:=-1;

   c_red     :=rgba2c(255,  0,  0,255);
   c_ared    :=rgba2c(255,  0,  0,32 );
   c_orange  :=rgba2c(255,128,  0,255);
   c_dorange :=rgba2c(230, 96,  0,255);
   c_brown   :=rgba2c(200,120, 10,255);
   c_yellow  :=rgba2c(255,255,  0,255);
   c_dyellow :=rgba2c(220,220,  0,255);
   c_lime    :=rgba2c(  0,255,  0,255);
   c_aqua    :=rgba2c(  0,255,255,255);
   c_purple  :=rgba2c(255,0  ,255,255);
   c_green   :=rgba2c(  0,192,  0,255);
   c_dblue   :=rgba2c(100,100,192,255);
   c_blue    :=rgba2c( 50,50 ,255,255);
   c_ablue   :=rgba2c( 50,50 ,255,24 );
   c_white   :=rgba2c(255,255,255,255);
   c_gray    :=rgba2c(120,120,120,255);
   c_agray   :=rgba2c(80 , 80, 80,128);
   c_black   :=rgba2c(0  ,  0,  0,255);
   c_ablack  :=rgba2c(0  ,  0,  0,128);

   rad_rld_ic[false]:=c_aqua;
   rad_rld_ic[true ]:=c_yellow;

   randomize;

   LoadingScreen;
   LoadGraphics;
   g_randommap;
   DefGameObjects;
   InitFogR;
   InitCMP;

   vid_mredraw:=true;

   if(startcon)then
   begin
      net_cl_svstr:=startcons;
      net_cl_con:=true;
      if(_initSocket)
      then net_m_error:=str_connecting
      else
        begin
           net_cl_con:=false;
           _disposeNet;
        end;
   end;

   _CYCLE:=true;
end;


procedure QuitGame;
begin
   cfg_write;

   _disposeNet;
   sdl_quit;
end;


