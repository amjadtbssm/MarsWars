program T3D_RTS;

//{$APPTYPE GUI}

uses crt, SysUtils, sdl, sdl_gfx, sdl_image, sdl_net, sdl_mixer;

{$include _const.pas}
{$include _type.pas}
{$include _var.pas}

{$include _common.pas}
{$include _sounds.pas}
{$include _net_com.pas}
{$include _lang.pas}
{$include _config.pas}
{$include _units_spr.pas}
{$include _units_cl.pas}
{$include _draw_com.pas}
{$include _draw_menu.pas}
{$include _draw_ui.pas}
{$include _draw.pas}
{$include _effects.pas}
{$include _loadgfx.pas}
{$include _map.pas}
{$include _units.pas}
{$include _campaings.pas}
{$include _game.pas}
{$Include _saveload.pas}
{$include _menu.pas}
{$include _input.pas}
{$include _init.pas}

{$R *.res}

begin
   InitGame;

   if(_ded)then
    while (_CYCLE=true) do
    begin
       InputGame;
       CodeGame;
       DrawGame;
       sdl_delay(vid_mpt);
    end
   else
   while (_CYCLE=true) do
   begin
      k_mssp:=fps_cs;
      fps_cs:=SDL_GetTicks;
      k_msst:=fps_cs-k_mssp;

      if(k_msst>0)then InputGame;

      if(fps_cs<fps_ns)then continue;

      if(_fsttime)
      then fps_ns:=fps_cs
      else fps_ns:=fps_cs+vid_mpt;
      //   clrscr;
      CodeGame;
      if(_draw)then DrawGame;

      //writeln(SDL_GetTicks-fps_cs);
   end;

   net_plout;
   cfg_write;
   DISPOSE(_RECT);
   DISPOSE(_EVENT);
   SDL_Quit;
end.


