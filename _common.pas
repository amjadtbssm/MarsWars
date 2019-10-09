
function b2s (i:byte    ):string;begin str(i,b2s);end;
function w2s (i:word    ):string;begin str(i,w2s);end;
function i2s (i:integer ):string;begin str(i,i2s);end;
function c2s (i:cardinal):string;begin str(i,c2s);end;
function s2b (str:string):byte;var t:integer;begin val(str,s2b,t);end;
function s2w (str:string):word;var t:integer;begin val(str,s2w,t);end;
function s2c (str:string):cardinal;var t:integer;begin val(str,s2c,t);end;

function rgba2c(r,g,b,a:byte):cardinal;
begin
   rgba2c:=a+(b shl 8)+(g shl 16)+(r shl 24);
end;

function sign(x:integer):integer;
begin
   sign:=0;
   if (x>0) then sign:=1;
   if (x<0) then sign:=-1;
end;

procedure _scrollV(i:pinteger;s,min,max:integer);
begin
   inc(i^,s);
   if(i^>max)then i^:=max;
   if(i^<min)then i^:=min;
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
   _moveView:=false;
end;

function dist2(dx,dy,dx1,dy1:integer):integer;
begin
   dx := abs(dx1-dx);
   dy := abs(dy1-dy);
   if (dx<dy)
   then dist2:=(123*dy+51*dx) shr 7
   else dist2:=(123*dx+51*dy) shr 7;
end;

function dist3(dx,dy,dx1,dy1:integer;ya:boolean):integer;
begin
   dx := abs(dx1-dx);
   dy := abs(dy1-dy);
   if(ya)then inc(dy,dy div 3);
   if (dx<dy)
   then dist3:=(123*dy+51*dx) shr 7
   else dist3:=(123*dx+51*dy) shr 7;
end;

function p_dir(x0,y0,x1,y1:integer):integer;
var vx,vy,avx,avy,res:integer;
begin
   p_dir:=0;
   vx:=x1-x0;
   vy:=y1-y0;

   if (vx=0)and(vy=0) then exit;

   avx:=abs(vx);
   avy:=abs(vy);

   if avx>avy
   then res:=trunc((vy/vx)*45)
   else res:=90-trunc((vx/vy)*45);

   if vy<0 then
   begin
      if (res<0) then res:=res+360 else
      if (res>0) then res:=res+180;
   end
   else if (res<0) then res:=res+180;

   if (vx<0)and(res=0) then res:=180;

   p_dir:=360-res;
end;

function _fog_cl(x,y:integer):boolean;
begin
   _fog_cl:=false;
   if((0<=x)and(0<=y)and(x<=fog_cs)and(y<=fog_cs))then
    if(fog_c[x,y]>0)then _fog_cl:=true;
end;

function _fog_ch(x,y,r:integer):boolean;
begin
   _fog_ch:=_fog_cl(x,y);
   if(r>41) then _fog_ch:=_fog_ch or _fog_cl(x-1,y-1) or _fog_cl(x,y-1) or _fog_cl(x+1,y-1) or _fog_cl(x-1,y) or _fog_cl(x+1,y) or _fog_cl(x-1,y+1) or _fog_cl(x,y+1) or _fog_cl(x+1,y+1);
end;

function _nhp(x,y:integer):boolean;
begin
   _nhp:=((vid_vx+vid_panel)<x)and(x<(vid_vx+vid_mw))and
         ((vid_vy          )<y)and(y<(vid_vy+vid_mh))and
          (_fog_cl(x div fog_cw,y div fog_cw));
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
   sdl_saveBMP(vid_screen,@s[1]);
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

function _plsReady:boolean;
var i:byte;
begin
   _plsReady:=true;
   for i:=1 to MaxPlayers do
    if(i<>PlayerHuman)then
     with _Players[i] do
      if (state=PS_Play) then
       if (ready=false) then begin _plsReady:=false; break; end;
end;


procedure _MakeScreen;
begin
   if (vid_screen<>nil) then sdl_freesurface(vid_screen);

   if(vid_wide)
   then vid_mw:=960
   else vid_mw:=800;

   _fscr:=not _fscr;
   if (_fscr)
   then vid_screen:=SDL_SetVideoMode( vid_mw, vid_mh, vid_bpp, vid_flags+SDL_FULLSCREEN)
   else vid_screen:=SDL_SetVideoMode( vid_mw, vid_mh, vid_bpp, vid_flags);

   vid_vmb_x1   := vid_mw-vid_vmb_x0;
   vid_vmb_y1   := vid_mh-vid_vmb_y0;
   vid_menuX    := (vid_mw-800) div 2;
end;



