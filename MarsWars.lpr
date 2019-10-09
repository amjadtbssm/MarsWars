program MarsWars_ded;

{$APPTYPE CONSOLE}

{$R *.res}

uses {crt,} SysUtils, sdl,  sdl_net;

{$Include _const.pas}
{$Include _TYPE.pas}
{$Include _VAR.pas}

{$Include _common.pas}
{$Include _net_com.pas}
{$Include _units.pas}
{$Include _objects.pas}
{$Include _net_game.pas}
{$Include _game.pas}

{$Include _init.pas}

begin
   IntGame;

   while (_CYCLE=true) do
   begin
       fps_s:=SDL_GetTicks;

       CGame;

       fps_p:=SDL_GetTicks-fps_s+1;

       if (fps_p>=vid_mpt)or(_fsttime)
       then fps_p:=1
       else fps_p:=vid_mpt-fps_p;

//       clrscr;
//       writeln(fps_p,' ',_fsttime);
//       writeln(net_ct,' ',net_ct div 1024,' ',net_ct div 1048576);
//       writeln(net_cs,' ',net_cs div 1024,' ',net_cs div 1048576);

       sdl_delay(fps_p);
   end;

   QuitGame;
end.



