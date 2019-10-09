

procedure StartParams;
begin
   net_sv_port:=s2w(ParamStr(1));

   if(net_sv_port=0)then net_sv_port:=10666;
end;

procedure IntGame;
begin
   _CYCLE:=false;

   writeln('MarsWars dedicated server, v',ver);

   StartParams;

   if not(initNET) then exit;

   DefGameObjects;

   G_Started:=false;

   _CYCLE:=true;
end;


procedure QuitGame;
begin
   _disposeNet;
   sdl_quit;
end;


