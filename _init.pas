
procedure InitFogR;
var r,x:byte;
begin
   for r:=0 to MFogM do
    for x:=0 to r do
     _fcx[r,x]:=trunc(sqrt(sqr(r)-sqr(x)));
end;

procedure _setUPGR(rc,upcl,stime,cnt,enrg:integer);
begin
   upgrade_time[rc,upcl]:=vid_fps*stime;
   upgrade_cnt [rc,upcl]:=cnt;
   _pne_r      [rc,upcl]:=enrg;
end;

procedure ObjTbl;
begin
   FillChar(upgrade_time,SizeOf(upgrade_time),0);
   FillChar(upgrade_cnt ,SizeOf(upgrade_cnt ),1);

   _setUPGR(r_hell,upgr_attack    ,180,4 ,3);
   _setUPGR(r_hell,upgr_armor     ,180,4 ,3);
   _setUPGR(r_hell,upgr_build     ,120,4 ,3);
   _setUPGR(r_hell,upgr_melee     ,60 ,3 ,3);
   _setUPGR(r_hell,upgr_regen     ,120,2 ,3);
   _setUPGR(r_hell,upgr_paina     ,120,2 ,3);
   _setUPGR(r_hell,upgr_vision    ,120,1 ,3);
   _setUPGR(r_hell,upgr_pains     ,120,3 ,3);
   _setUPGR(r_hell,upgr_5bld      ,120,3 ,3);
   _setUPGR(r_hell,upgr_mainm     ,120,2 ,3);
   _setUPGR(r_hell,upgr_towers    ,180,1 ,3);
   _setUPGR(r_hell,upgr_6bld      ,360,1 ,3);
   _setUPGR(r_hell,upgr_2tier     ,240,1 ,3);
   _setUPGR(r_hell,upgr_mainr     ,120,1 ,3);
   _setUPGR(r_hell,upgr_revtele   ,120,1 ,3);
   _setUPGR(r_hell,upgr_revmis    ,120,1 ,3);
   _setUPGR(r_hell,upgr_hsymbol   ,180,1 ,3);
   _setUPGR(r_hell,upgr_hpower    ,180,3 ,3);
   _setUPGR(r_hell,upgr_bldrep    ,180,3 ,3);
   _setUPGR(r_hell,upgr_6bld2     ,120,1 ,3);
   _setUPGR(r_hell,upgr_mainonr   ,120,1 ,3);
   _setUPGR(r_hell,upgr_b478tel   ,30 ,10,3);
   _setUPGR(r_hell,upgr_hinvuln   ,240,1 ,3);

   _setUPGR(r_uac ,upgr_attack    ,180,4 ,3);
   _setUPGR(r_uac ,upgr_armor     ,120,4 ,3);
   _setUPGR(r_uac ,upgr_build     ,180,4 ,3);
   _setUPGR(r_uac ,upgr_melee     ,60 ,3 ,3);
   _setUPGR(r_uac ,upgr_mspeed    ,120,2 ,3);
   _setUPGR(r_uac ,upgr_shield    ,120,1 ,3);
   _setUPGR(r_uac ,upgr_vision    ,120,1 ,3);
   _setUPGR(r_uac ,upgr_invis     ,180,1 ,3);
   _setUPGR(r_uac ,upgr_5bld      ,120,3 ,3);
   _setUPGR(r_uac ,upgr_mainm     ,240,1 ,3);
   _setUPGR(r_uac ,upgr_towers    ,180,1 ,3);
   _setUPGR(r_uac ,upgr_6bld      ,240,1 ,3);
   _setUPGR(r_uac ,upgr_2tier     ,360,1 ,3);
   _setUPGR(r_uac ,upgr_mainr     ,120,1 ,3);
   _setUPGR(r_uac ,upgr_blizz     ,300,1 ,3);
   _setUPGR(r_uac ,upgr_mechspd   ,120,2 ,3);
   _setUPGR(r_uac ,upgr_mecharm   ,180,4 ,3);
   _setUPGR(r_uac ,upgr_ucomatt   ,240,1 ,3);
   _setUPGR(r_uac ,upgr_minesen   ,120,1 ,3);
   _setUPGR(r_uac ,upgr_6bld2     ,120,1 ,3);
   _setUPGR(r_uac ,upgr_mainonr   ,120,1 ,3);
   _setUPGR(r_uac ,upgr_addtur    ,60 ,1 ,3);
   _setUPGR(r_uac ,upgr_apctur    ,120,1 ,3);


   FillChar(cl2uid,SizeOf(cl2uid),0);

   cl2uid[r_hell,true ,0 ]:=UID_HKeep;
   cl2uid[r_hell,true ,1 ]:=UID_HGate;
   cl2uid[r_hell,true ,2 ]:=UID_HSymbol;
   cl2uid[r_hell,true ,3 ]:=UID_HPools;
   cl2uid[r_hell,true ,4 ]:=UID_HTower;
   cl2uid[r_hell,true ,5 ]:=UID_HTeleport;
   cl2uid[r_hell,true ,6 ]:=UID_HMonastery;
   cl2uid[r_hell,true ,7 ]:=UID_HTotem;
   cl2uid[r_hell,true ,8 ]:=UID_HAltar;
   cl2uid[r_hell,true ,9 ]:=UID_HMilitaryUnit;

   cl2uid[r_hell,false,0 ]:=UID_LostSoul;
   cl2uid[r_hell,false,1 ]:=UID_Imp;
   cl2uid[r_hell,false,2 ]:=UID_Demon;
   cl2uid[r_hell,false,3 ]:=UID_Cacodemon;
   cl2uid[r_hell,false,4 ]:=UID_Baron;
   cl2uid[r_hell,false,5 ]:=UID_Cyberdemon;
   cl2uid[r_hell,false,6 ]:=UID_Mastermind;
   cl2uid[r_hell,false,7 ]:=UID_Pain;
   cl2uid[r_hell,false,8 ]:=UID_Revenant;
   cl2uid[r_hell,false,9 ]:=UID_Mancubus;
   cl2uid[r_hell,false,10]:=UID_Arachnotron;
   cl2uid[r_hell,false,11]:=UID_Archvile;

   cl2uid[r_hell,false,12]:=UID_ZFormer;
   cl2uid[r_hell,false,13]:=UID_ZSergant;
   cl2uid[r_hell,false,14]:=UID_ZCommando;
   cl2uid[r_hell,false,15]:=UID_ZBomber;
   cl2uid[r_hell,false,16]:=UID_ZMajor;
   cl2uid[r_hell,false,17]:=UID_ZBFG;

   cl2uid[r_hell,false,18]:=UID_Dron;
   cl2uid[r_hell,false,19]:=UID_Octobrain;
   cl2uid[r_hell,false,20]:=UID_Cyclope;

   cl2uid[r_uac ,true ,0 ]:=UID_UCommandCenter;
   cl2uid[r_uac ,true ,1 ]:=UID_UMilitaryUnit;
   cl2uid[r_uac ,true ,2 ]:=UID_UGenerator;
   cl2uid[r_uac ,true ,3 ]:=UID_UWeaponFactory;
   cl2uid[r_uac ,true ,4 ]:=UID_UTurret;
   cl2uid[r_uac ,true ,5 ]:=UID_URadar;
   cl2uid[r_uac ,true ,6 ]:=UID_UVehicleFactory;
   cl2uid[r_uac ,true ,7 ]:=UID_URTurret;
   cl2uid[r_uac ,true ,8 ]:=UID_URocketL;
   cl2uid[r_uac ,true ,9 ]:=UID_UCBuild;

   cl2uid[r_uac ,false,0 ]:=UID_Engineer;
   cl2uid[r_uac ,false,1 ]:=UID_Medic;
   cl2uid[r_uac ,false,2 ]:=UID_Sergant;
   cl2uid[r_uac ,false,3 ]:=UID_Commando;
   cl2uid[r_uac ,false,4 ]:=UID_Bomber;
   cl2uid[r_uac ,false,5 ]:=UID_Major;
   cl2uid[r_uac ,false,6 ]:=UID_BFG;
   cl2uid[r_uac ,false,7 ]:=UID_FAPC;
   cl2uid[r_uac ,false,8 ]:=UID_APC;
   cl2uid[r_uac ,false,9 ]:=UID_Terminator;
   cl2uid[r_uac ,false,10]:=UID_Tank;
   cl2uid[r_uac ,false,11]:=UID_Flyer;

   cl2uid[r_uac ,false,18]:=UID_Dron;
   cl2uid[r_uac ,false,19]:=UID_Octobrain;
   cl2uid[r_uac ,false,20]:=UID_Cyclope;

   cl2uid[r_uac ,false,21]:=UID_UTransport;

   FillChar(_pne_b,SizeOf(_pne_b),0);

   _pne_b[r_hell,0 ]:= 3;
   _pne_b[r_hell,1 ]:= 2;
   _pne_b[r_hell,2 ]:= 1;
   _pne_b[r_hell,3 ]:= 3;
   _pne_b[r_hell,4 ]:= 1;
   _pne_b[r_hell,5 ]:= 3;
   _pne_b[r_hell,6 ]:= 3;
   _pne_b[r_hell,7 ]:= 1;
   _pne_b[r_hell,8 ]:= 3;

   _pne_b[r_uac ,0 ]:= 4;
   _pne_b[r_uac ,1 ]:= 2;
   _pne_b[r_uac ,2 ]:= 2;
   _pne_b[r_uac ,3 ]:= 3;
   _pne_b[r_uac ,4 ]:= 1;
   _pne_b[r_uac ,5 ]:= 3;
   _pne_b[r_uac ,6 ]:= 3;
   _pne_b[r_uac ,7 ]:= 1;
   _pne_b[r_uac ,8 ]:= 3;

   FillChar(_pne_u,SizeOf(_pne_u),0);

   _pne_u[r_hell,0 ]:= 1;
   _pne_u[r_hell,1 ]:= 1;
   _pne_u[r_hell,2 ]:= 1;
   _pne_u[r_hell,3 ]:= 2;
   _pne_u[r_hell,4 ]:= 4;
   _pne_u[r_hell,5 ]:= 8;
   _pne_u[r_hell,6 ]:= 8;
   _pne_u[r_hell,7 ]:= 3;
   _pne_u[r_hell,8 ]:= 4;
   _pne_u[r_hell,9 ]:= 4;
   _pne_u[r_hell,10]:= 4;
   _pne_u[r_hell,11]:= 5;

   _pne_u[r_uac ,0 ]:= 1;
   _pne_u[r_uac ,1 ]:= 1;
   _pne_u[r_uac ,2 ]:= 1;
   _pne_u[r_uac ,3 ]:= 2;
   _pne_u[r_uac ,4 ]:= 3;
   _pne_u[r_uac ,5 ]:= 3;
   _pne_u[r_uac ,6 ]:= 4;
   _pne_u[r_uac ,7 ]:= 2;
   _pne_u[r_uac ,8 ]:= 2;
   _pne_u[r_uac ,9 ]:= 5;
   _pne_u[r_uac ,10]:= 5;
   _pne_u[r_uac ,11]:= 5;

   InitFogR;
end;

function InitVideo:boolean;
begin
   InitVideo:=false;

   if SDL_Init(SDL_INIT_VIDEO)<>0 then begin WriteError; exit; end;

   SDL_putenv('SDL_VIDEO_WINDOW_POS');
   SDL_putenv('SDL_VIDEO_CENTERED=1');

   calcVRV;
   SDL_WM_SetCaption(@str_wcaption[1], nil );
   _MakeScreen;

   if(_screen=nil)then begin WriteError; exit; end;

   _makeScrSurf;
   if(_menu_surf=nil)then begin WriteError; exit; end;
   if(_uipanel=nil)then begin WriteError; exit; end;

   _dsurf:=sdl_createRGBSurface(0,1,1,vid_bpp,0,0,0,0);
   if(_dsurf=nil)then begin WriteError; exit; end;

   _minimap:=sdl_createRGBSurface(0,vid_panel-2,vid_panel-2,vid_bpp,0,0,0,0);
   if(_minimap=nil)then begin WriteError; exit; end;

   _bminimap:=sdl_createRGBSurface(0,vid_panel-2,vid_panel-2,vid_bpp,0,0,0,0);
   if(_bminimap=nil)then begin WriteError; exit; end;

   InitVideo:=true;
end;

procedure StartParams;
var t,i,dw:integer;
    s:string;
begin
   t:=ParamCount;
   for i:=1 to t do
   begin
      s:=ParamStr(i);

      if(s='test')then _testmode:=true;
      if(s='ded')then
      begin
         _ded:=true;
         dw:=i+1;
      end;
   end;
   if(_ded)then
   begin
      net_sv_port:=s2w(ParamStr(dw));
      if(net_sv_port=0)then net_sv_port:=10666;
      net_sv_pstr:=w2s(net_sv_port);
   end;
end;

procedure InitGame;
begin
   _CYCLE:=false;

   fps_cs:=0;
   fps_ns:=0;

   StartParams;
   randomize;
   ObjTbl;
   initUnits;
   lng_eng;
   cfg_read;

   c_dred    :=rgba2c(190,  0,  0,255);
   c_red     :=rgba2c(255,  0,  0,255);
   c_ared    :=rgba2c(255,  0,  0,42 );
   c_orange  :=rgba2c(255,140,  0,255);
   c_dorange :=rgba2c(230, 96,  0,255);
   c_brown   :=rgba2c(140, 90, 10,255);
   c_yellow  :=rgba2c(255,255,  0,255);
   c_dyellow :=rgba2c(220,220,  0,255);
   c_lime    :=rgba2c(  0,255,  0,255);
   c_aqua    :=rgba2c(  0,255,255,255);
   c_purple  :=rgba2c(255,0  ,255,255);
   c_green   :=rgba2c(  0,150,  0,255);
   c_dblue   :=rgba2c(100,100,192,255);
   c_blue    :=rgba2c( 50,50 ,255,255);
   c_ablue   :=rgba2c( 50,50 ,255,24 );
   c_white   :=rgba2c(255,255,255,255);
   c_awhite  :=rgba2c(255,255,255,40 );
   c_gray    :=rgba2c(120,120,120,255);
   c_dgray   :=rgba2c(70 ,70 ,70 ,255);
   c_agray   :=rgba2c(80 , 80, 80,128);
   c_black   :=rgba2c(0  ,  0,  0,255);
   c_ablack  :=rgba2c(0  ,  0,  0,128);
   c_lava    :=rgba2c(222,80 ,  0,255);

   _sbtnc[false]:=c_ablack;
   _sbtnc[true ]:=c_agray;
   ui_muc[false]:=c_dorange;
   ui_muc[true ]:=c_gray;

   ui_rad_rld[false]:=c_aqua;
   ui_rad_rld[true ]:=c_yellow;

   if not(InitVideo) then exit;
   if not(InitNET)   then exit;
   if not(InitSound) then exit;
   LoadingScreen;

   SDL_ShowCursor(0);
   SDL_enableUNICODE(1);

   NEW(_event);
   NEW(_rect);

   LoadGraphics;
   Map_randommap;
   DefGameObjects;
   _cmp_initmap;

   _CYCLE:=true;

   if(_ded)then
   begin
      SDL_ShowCursor(SDL_ENABLE);
      net_nstat:=ns_srvr;
      if(net_UpSocket=false)then
      begin
         net_dispose;
         net_nstat:=ns_none;
         _CYCLE:=false;
      end
      else
      begin
         HPlayer:=0;
         DefPlayers;
      end;
   end;
end;
