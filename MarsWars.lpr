program MarsWars;

{$APPTYPE GUI}

{$R *.res}

uses {crt,} SysUtils, sdl, sdl_gfx, sdl_image, sdl_net, sdl_mixer;

{$Include _const.pas}
{$Include _TYPE.pas}
{$Include _VAR.pas}

{$Include _common.pas}
{$Include _lang.pas}
{$Include _sounds.pas}
{$Include _net_com.pas}
{$Include _config.pas}
{$Include _draw.pas}
{$Include _load_gfx.pas}
{$Include _effects.pas}
{$Include _units.pas}
{$Include _objects.pas}
{$Include _net_game.pas}
{$Include _replays.pas}
{$Include _game.pas}

{$Include _saveload.pas}
{$Include _menu.pas}
{$Include _input.pas}
{$Include _init.pas}

begin
   IntGame;

   while (_CYCLE=true) do
   begin
       fps_s:=SDL_GetTicks;

       InputGame;
       CGame;

       if(vid_draw=false)then continue;

       DrawGame;

       fps_p:=SDL_GetTicks-fps_s+1;

       fps:=1000 div fps_p;
       if(fps>vid_fps)then fps:=vid_fps;

       if (fps_p>=vid_mpt)or(_fsttime)
       then fps_p:=1
       else fps_p:=vid_mpt-fps_p;

       sdl_delay(fps_p);
   end;

   QuitGame;
end.



