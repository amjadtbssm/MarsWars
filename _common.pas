
function b2s (i:byte    ):string;begin str(i,b2s);end;
function w2s (i:word    ):string;begin str(i,w2s);end;
function s2w (str:string):word;var t:integer;begin val(str,s2w,t);end;


function sign(x:integer):integer;
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

procedure WriteError(comm:string);
var f:Text;
begin
   Assign(f,outlogfn);
   if FileExists(outlogfn) then Append(f) else Rewrite(f);
   writeln(f,comm);
   writeln(f,sdl_GetError);
   SDL_ClearError;
   Close(f);
end;


function _plsReady:boolean;
var i,c,r:byte;
begin
   c:=0;
   r:=0;
   for i:=1 to MaxPlayers do
    with _Players[i] do
     if (state=PS_Play) then
     begin
        inc(c,1);
        if (ready=true) then inc(r,1);
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


