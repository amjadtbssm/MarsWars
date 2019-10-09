
function b2s (i:byte    ):string;begin str(i,b2s);end;
function w2s (i:word    ):string;begin str(i,w2s);end;
function c2s (i:cardinal):string;begin str(i,c2s);end;
function i2s (i:integer ):string;begin str(i,i2s);end;
function si2s(i:single  ):string;begin str(i,si2s);end;
function s2b (str:string):byte;var t:integer;begin val(str,s2b,t);end;
function s2w (str:string):word;var t:integer;begin val(str,s2w,t);end;
function s2i (str:string):integer;var t:integer;begin val(str,s2i,t);end;
function s2c (str:string):cardinal;var t:integer;begin val(str,s2c,t);end;

procedure _bc_s(gs:pcardinal;g:byte);
begin
   if(g<=_uts)then
    gs^:=gs^ or cardinal(1 shl g);
end;

procedure _bc_us(gs:pcardinal;g:byte);
begin
   if(g<=_uts)then
    gs^:=gs^ xor cardinal(1 shl g);
end;

procedure _bc_ss(gs:pcardinal;g:TSob);
var i:byte;
begin
   gs^:=0;
   for i:=0 to _uts do
    if(i in g)then
     gs^:=gs^ or cardinal(1 shl i);
end;

procedure _bc_sa(gs:pcardinal;g:TSob);
var i:byte;
begin
   for i:=0 to _uts do
    if(i in g)then
     gs^:=gs^ or cardinal(1 shl i);
end;

function _bc_g(gs:cardinal;g:byte):boolean;
begin
    _bc_g:=false;
   if(g<=_uts)then _bc_g:=(gs and cardinal(1 shl g))>0;
end;

procedure _upgr_ss(upgr:Pupgrar;g:TSob;race,lvl:byte);
var i:byte;
begin
   FillChar(upgr^,SizeOf(upgrar),0);
   for i:=0 to _uts do
    if(i in g)then
     if(lvl>upgrade_cnt[race,i])
     then upgr^[i]:=upgrade_cnt[race,i]
     else upgr^[i]:=lvl;
end;

function FileExists(FName:string):Boolean;
var F:File;
begin
{$I-}Assign(F,FName);
     Reset(F,1);
   if IoResult=0 then
   begin FileExists:=True; Close(F);end
   else  FileExists:=false;{$I+}
end;

function sign(x:integer):shortint;
begin
   sign:=0;
   if (x>0) then sign:=1;
   if (x<0) then sign:=-1;
end;

function dist2(dx,dy,dx1,dy1:integer):integer;
begin
   dx := abs(dx1-dx);
   dy := abs(dy1-dy);
   if (dx<dy)
   then dist2:=(123*dy+51*dx) shr 7
   else dist2:=(123*dx+51*dy) shr 7;
end;

function dist(dx,dy,dx1,dy1:integer):integer;
begin
   dx:=abs(dx-dx1);
   dy:=abs(dy-dy1);
   dist:=trunc(sqrt(sqr(dx)+sqr(dy)));
end;

function p_dir(x0,y0,x1,y1:integer):integer;
var vx,vy,avx,avy:integer;
    res:single;
begin
   p_dir:=270;
   vx:=x1-x0;
   vy:=y1-y0;

   if(vx=0)and(vy=0)then exit;

   avx:=abs(vx);
   avy:=abs(vy);

   if(avx>avy)
   then res:=trunc((vy/vx)*45)
   else res:=90-trunc((vx/vy)*45);

   if(vy<0)then
   begin
      if(res<0)then res:=res+360 else
      if(res>0)then res:=res+180;
   end
   else
     if(res<0)then res:=res+180;

   if(vx<0)and(res=0)then res:=180;

   p_dir:=trunc(360-res);
end;

function dir_diff(dir1,dir2:integer):integer;
begin
   dir_diff:=((( (dir1-dir2) mod 360) + 540) mod 360) - 180;
end;

function dir_turn(d1,d2,spd:integer):integer;
var d:integer;
begin
   d:=dir_diff(d2,d1);

   if abs(d)<=spd
   then dir_turn:=d2
   else dir_turn:=(360+d1+(spd*sign(d))) mod 360;
end;

function _fog_cl(x,y:integer):boolean;
begin
   _fog_cl:=false;
   if(0<=x)and(0<=y)and(x<=fog_cs)and(y<=fog_cs)then _fog_cl:=fog_c[x,y]>0;
end;

function _fog_ch(x,y,r:integer):boolean;
begin
   _fog_ch:=_fog_cl(x,y);
   if(r>=fog_chw)then _fog_ch:=_fog_ch or _fog_cl(x-1,y-1) or _fog_cl(x,y-1) or _fog_cl(x+1,y-1) or _fog_cl(x-1,y) or _fog_cl(x+1,y) or _fog_cl(x-1,y+1) or _fog_cl(x,y+1) or _fog_cl(x+1,y+1);
end;

function _nhp(x,y,r:integer):boolean;
begin
   _nhp:=((vid_vx+vid_panel)<x)and(x<(vid_vx+vid_mw))and
         ((vid_vy          )<y)and(y<(vid_vy+vid_mh))and
          (_fog_ch(x div fog_cw,y div fog_cw,r));
end;

procedure _scrollV(i:pinteger;s,min,max:integer);
begin
   inc(i^,s);
   if(i^>max)then i^:=max;
   if(i^<min)then i^:=min;
end;

procedure _screenshot;
var i:integer;
    s:string;
begin
   i:=0;
   repeat
      inc(i,1);
      s:=str_screenshot+i2s(i)+'.bmp';
   until not FileExists(s);
   s:=s+#0;
   sdl_saveBMP(_screen,@s[1]);
end;

function _gen(x:integer):integer;
begin
   _gen:=map_seed2*5+167;
   map_seed2:=_gen;
   _gen:=abs(_gen mod x);
   inc(map_seed2,167);
end;

function _genx(x,m:integer;newn:boolean):integer;
begin
   _genx:=(x*5)+map_seed+map_seed2;
   _genx:=abs(_genx mod m);
   if(newn)then inc(map_seed2,67);
end;

function rgba2c(r,g,b,a:byte):cardinal;
begin
   rgba2c:=a+(b shl 8)+(g shl 16)+(r shl 24);
end;

procedure WriteError;
var f:Text;
begin
   Assign(f,outlogfn);
   if FileExists(outlogfn) then Append(f) else Rewrite(f);
   writeln(f,sdl_GetError);
   SDL_ClearError;
   Close(f);
end;

procedure WriteLog(mess:string);
var f:Text;
begin
   Assign(f,outlogfn);
   if FileExists(outlogfn) then Append(f) else Rewrite(f);
   writeln(f,mess);
   Close(f);
end;

procedure _view_bounds;
begin
   if (vid_vx<-vid_panel) then vid_vx:=-vid_panel;
   if (vid_vy<0) then vid_vy:=0;
   if ((vid_vx+vid_mw)>map_mw) then vid_vx:=map_mw-vid_mw;
   if ((vid_vy+vid_mh)>map_mw) then vid_vy:=map_mw-vid_mh;

   vid_mmvx:=trunc((vid_vx+vid_panel)*map_mmcx);
   vid_mmvy:=trunc(vid_vy*map_mmcx);
end;

procedure _moveHumView(mx,my:integer);
begin
   vid_vx:=mx-((vid_mw+vid_panel) shr 1);
   vid_vy:=my-( vid_mh            shr 1);
   fog_ix:=(vid_vx div fog_cw)-(base_r div fog_cw);
   _view_bounds;
end;

function _bldCndt(pl,bucl:byte):boolean;
begin
   with _players[pl] do
    _bldCndt:=(bld_r>0)
            or(cl2uid[race,true,bucl]=0)
            or(bldrs=0)
            or(army>=MaxPlayerUnits)
            or(_bc_g(a_build,bucl)=false)
            or((menerg-cenerg)<_pne_b[race,bucl])
            or((bucl=6)and(ubx[3]=0))
            or((bucl>6)and((upgr[upgr_2tier]=0)or(ubx[6]=0)) )
            or(u_e[true,bucl]>=_ulst[cl2uid[race,true,bucl]].max)
            or((G_addon=false)and(bucl>6));
end;
function _untCndt(pl,bucl:byte):boolean;
begin
   with _players[pl] do
    _untCndt:=((army+wb)>=MaxPlayerUnits)
            or(cl2uid[race,false,bucl]=0)
            or(_bc_g(a_units,bucl)=false)
            or((menerg-cenerg)<_pne_u[race,bucl])
            or((bucl>ut2[race])and(bucl<12)and((upgr[upgr_2tier]=0)or(ubx[6]=0)))
            or(u_e[false,bucl]>=_ulst[cl2uid[race,false,bucl]].max)
            or(_ulst[cl2uid[race,false,bucl]].trt=0)
            or((_ulst[cl2uid[race,false,bucl]].max=1)and(wbhero))
            or(ubx[1]=0)
            or((race=r_hell)and(bucl in [5,6])and(ubx[6]=0))
            or((G_addon=false)and(bucl>ut2[race])and(bucl<12));
end;

function _cmp_untCndt(pl,bucl:byte):boolean;
begin
   with _players[pl] do
_cmp_untCndt:=((army+wb)>=MaxPlayerUnits)
            or(_bc_g(a_units,bucl)=false)
            or(u_e[false,bucl]>=_ulst[cl2uid[race,false,bucl]].max)
            or(_ulst[cl2uid[race,false,bucl]].trt=0)
            or((_ulst[cl2uid[race,false,bucl]].max=1)and(wbhero))
            or((G_addon=false)and(bucl>ut2[race]));
end;

function _plsReady:boolean;
var p,c,r:byte;
begin
   c:=0;
   r:=0;

   for p:=1 to MaxPlayers do
    with _players[p] do
     if(state=ps_play)then
     begin
        inc(c,1);
        if(ready)or(p=HPlayer)then inc(r,1);
     end;
   _plsReady:=(r=c)and(c>0);
end;

function _plsOut:boolean;
var i,c,r:byte;
begin
   c:=0;
   r:=0;
   for i:=1 to MaxPlayers do
    with _Players[i] do
     if (state=PS_Play) then
     begin
        inc(c,1);
        if (ttl=ClientTTL) then inc(r,1);
     end;
   _plsOut:=(r=c)and(c>0);
end;


procedure _addUIBldrs(tx,ty,tr:integer);
var i:byte;
begin
   for i:=0 to _uts do
    if(ui_bldrs_x[i]=0)then
    begin
       ui_bldrs_x[i]:=tx;
       ui_bldrs_y[i]:=ty;
       ui_bldrs_r[i]:=tr;
       break;
    end;
end;

procedure _setAI(p:byte);
begin
   with _players[p] do
   begin
    case ai_skill of
      1 : begin  //
             _bc_ss(@a_build,[0..3]);
             _bc_ss(@a_units,[0..3]);
             _bc_ss(@a_upgr ,[0..4,6]);

             ai_maxarmy :=30;
             ai_pushpart:=18;

             ai_attack:=0;
             if(g_mode=gm_ct)then ai_attack:=1;
          end;
      2 : begin
             _bc_ss(@a_build,[0..6]);
             if(race=r_uac)then
             begin
                _bc_ss(@a_units,[0..4,7]);
                _bc_ss(@a_upgr ,[0..6,9..11]);
             end
             else
             begin
                _bc_ss(@a_units,[0..4]);
                _bc_ss(@a_upgr ,[0..7,9..11]);
             end;

             ai_maxarmy :=45;
             ai_pushpart:=10;

             ai_attack:=0;
             if(g_mode=gm_ct)then ai_attack:=1;
          end;
      3 : begin  // HMP
             _bc_ss(@a_build,[0..6]);
             if(race=r_hell)
             then _bc_ss(@a_units,[0..5,8..10])
             else _bc_ss(@a_units,[0..5,7..10]);
             _bc_ss(@a_upgr ,[0..MaxUpgrs]);

             if(race=r_hell)or(g_mode=gm_ct)then ai_attack:=1;
          end;
      4 : begin  // UV
             _bc_ss(@a_build,[0..8]);
             _bc_ss(@a_units,[0..11]);
             _bc_ss(@a_upgr ,[0..MaxUpgrs]);

             ai_attack:=0;
             if(race=r_hell)or(g_mode=gm_ct)then ai_attack:=1;
          end;
      5 : begin  // Nightmare
             _bc_ss(@a_build,[0..8]);
             _bc_ss(@a_units,[0..11]);
             _bc_ss(@a_upgr ,[0..MaxUpgrs]);

             _upgr_ss(@upgr ,[0..4,13],race,3);

             ai_attack:=0;
             if(race=r_hell)or(g_mode=gm_ct)then ai_attack:=1;
          end;
      6 : begin  // Super Nightmare
             _bc_ss(@a_build,[0..8]);
             _bc_ss(@a_units,[0..11]);
             _bc_ss(@a_upgr ,[0..MaxUpgrs]);

             _upgr_ss(@upgr ,[0..8,28,29],race,2);

             ai_attack:=1;
          end;
    else
       a_build:=0;
       a_units:=0;
       a_upgr :=0;
       // 0
    end;

    if(race=r_hell)then
     case ai_skill of //
       2    : _bc_sa(@a_units,[12..13]);
       3    : _bc_sa(@a_units,[12..15]);
       4..6 : _bc_sa(@a_units,[12..17]);
     end;

    if(g_onebase)then _bc_us(@a_build,0);
   end;
end;

procedure GModeTeams(gm:byte);
begin
   case gm of
     gm_2fort : begin
                   _players[0].team:=0;
                   _players[1].team:=1;
                   _players[2].team:=1;
                   _players[3].team:=2;
                   _players[4].team:=2;
                end;
     gm_coop,
     gm_inv   : begin
                   _players[0].team:=0;
                   _players[1].team:=1;
                   _players[2].team:=1;
                   _players[3].team:=1;
                   _players[4].team:=1;
                end;
   else
   end;
end;

procedure Map_tdmake;
var i,ix,iy:integer;
begin
   ix:=map_seed;
   iy:=0;
   for i:=1 to MaxSDecsS do
   with _SDecs[i-1] do
   begin
      ix:=_genx(ix+(iy div 3)+127,vid_mwa,false);
      iy:=_genx(iy+(ix div 7)+17,vid_mha,false);
      x :=ix;
      y :=iy;
   end;
end;

procedure calcVRV;
begin
   vid_vmb_x1   := vid_mw-vid_vmb_x0;
   vid_vmb_y1   := vid_mh-vid_vmb_y0;
   vid_mwa      := vid_mw+vid_ab;
   vid_mha      := vid_mh+vid_ab*2;
   vid_uiuphx   := vid_panel+((vid_mw-vid_panel) div 2);
   if(spr_mback<>nil)then
   begin
      mv_x:=(vid_mw-spr_mback^.w) div 2;
      mv_y:=(vid_mh-spr_mback^.h) div 2;
   end;
   if(fog_cw>0)then
   begin
      fog_vcnw    := ((vid_mw-vid_panel) div fog_cw)+1;
      fog_vcnh    := (vid_mh div fog_cw)+1;
   end;
   map_mmvw    := trunc((vid_mw-vid_panel)*map_mmcx);
   map_mmvh    := trunc( vid_mh*map_mmcx);
   _view_bounds;

   MaxSDecsS:=(vid_mw*vid_mh) div 13000;
   setlength(_SDecs,MaxSDecsS);
   Map_tdmake;
end;

procedure _makeScrSurf;
begin
   if(_menu_surf<>nil)then sdl_freesurface(_menu_surf);
   _menu_surf:=sdl_createRGBSurface(0,vid_mw,vid_mh,vid_bpp,0,0,0,0);

   if(_uipanel<>nil)then sdl_freesurface(_uipanel);
   _uipanel:=sdl_createRGBSurface(0,vid_panel+1,vid_mh,vid_bpp,0,0,0,0);
end;

procedure _MakeScreen;
begin
   if (_screen<>nil) then sdl_freesurface(_screen);

   if(_ded)
   then _screen:=SDL_SetVideoMode( 344, 144, vid_bpp, _vflags)
   else
   begin
      if(_fscr)
      then _screen:=SDL_SetVideoMode( vid_mw, vid_mh, vid_bpp, _vflags + SDL_FULLSCREEN)
      else _screen:=SDL_SetVideoMode( vid_mw, vid_mh, vid_bpp, _vflags);
      vid_ingamecl:=(vid_mw-vid_panel-font_w) div font_w;
   end;
end;


