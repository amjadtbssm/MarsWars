

procedure _setAI(p:byte);
begin
   with _players[p] do
        case ai_skill of
        1: begin
           alw_u  := [0,1,2];
           alw_b  := [0,1,2,3];
           alw_up := [];
      ai_defense  := true;
      ai_minpush  := 60;
      ai_partpush := 30;
      ai_maxarmy  := 61;
           end;
        2: begin
           if(race=r_hell)
           then alw_u  := [0,1,2,3,4]
           else alw_u  := [0,1,2,3,5];
           alw_b  := [0,1,2,3,5];
           alw_up := [0,1,2,3];
      ai_defense  := true;
      ai_minpush  := 60;
      ai_partpush := 20;
      ai_maxarmy  := 61;
           end;
        3: begin
           alw_u  := [0,1,2,3,4,5];
           alw_b  := [0,1,2,3,4,5];
           alw_up := [0,1,2,3,5];
      ai_defense  := true;
      ai_minpush  := 15;
      ai_partpush := 10;
      ai_maxarmy  := 81;
           end;
        4: begin
           alw_u  := [0,1,2,3,4,5,6,7];
           alw_b  := [0,1,2,3,4,5];
           alw_up := [0,1,2,3,5,6,7];
      ai_defense  := true;
      ai_minpush  := 19;
      ai_partpush := 6;
      ai_maxarmy  := 81;
           end;
        5: begin
           alw_u  := [0,1,2,3,4,5,6,7];
           alw_b  := [0,1,2,3,4,5];
           alw_up := [0,1,2,3,4,5,6,7];
      ai_defense  := true;
      ai_minpush  := 15;
      ai_partpush := 6;
      ai_maxarmy  := MaxPlayerUnits;
           end;
        6: begin
           alw_u  := [0,1,2,3,4,5,6,7];
           alw_b  := [0,1,2,3,4,5];
           alw_up := [0,1,2,3,4,5,6,7];
      ai_defense  := true;
      ai_minpush  := 15;
      ai_partpush := 6;
      ai_maxarmy  := MaxPlayerUnits;
           end;
        else
           alw_u  := [0];
           alw_b  := [];
           alw_up := [];
      ai_defense  := true;
      ai_minpush  := 0;
      ai_partpush := 100;
      ai_maxarmy  := 0;
        end;
end;

procedure _playerSetState(p:integer);
begin
   with _players[p] do
   begin
      case state of
PS_None: begin ready:=false;name :=str_ps_none; end;
PS_Comp: begin ready:=true; ttl:=0; name:=str_ps_comp+' '+b2s(ai_skill);  end;
PS_Play: begin ready:=false;name :=''; ttl:=0;end;
      end;
   end;
end;


procedure _CreateStartPositionsSkirmish;
var p:byte;
begin
   for p:=1 to MaxPlayers do
    with _players[p] do
    begin
       if(state=ps_none)then
        if(g_mode in [gm_2fort,gm_inv])then
        begin
           state:=ps_comp;
           ai_skill:=5;
           race:=r_random;
           _playerSetState(p);
        end;

       if(state<>PS_None)then
       begin
          if(race=r_random)then race:=1+random(2);

          _unit_add(map_psx[p]    , map_psy[p] , rut2b[race,0],p);

          if(state=ps_play)then ai_skill:=5;
          _setAI(p);
          if(ai_skill=6)then
          begin
             //with _units[_lau] do generg:=4;
             menerg:=4;
             upgr[0]:=1;
          end;

          if(p=PlayerHuman)then _moveHumView(map_psx[p] , map_psy[p]);
       end;
    end;
end;


procedure _swAI(p:byte);
begin
   with _players[p] do
    if(state=PS_Comp)then
     begin
        inc(ai_skill,1);
        if(ai_skill>6)then ai_skill:=1;
        name:=str_ps_comp+' '+b2s(ai_skill);
     end;
end;

{$Include _map.pas}


function _get_suforef(p:byte):byte;
begin
   with _players[p] do _get_suforef:=su[false,0]+su[false,1]+su[false,2]+su[false,3]+su[false,4]+su[false,5]+su[false,6]+su[false,7]+su[true,1]+su[true,5];
end;

function _get_suforsn(p:byte):byte;
var i:byte;
begin
   _get_suforsn:=255;
   with _players[p] do
    for i:=_uts downto 0 do
     if(su[false,i]>0)then
     begin
        _get_suforsn:=i;
        break;
     end;
end;

procedure _player_s_o(ox0,oy0,ox1,oy1:integer;oid,pl:byte);
begin
   if(G_Paused=0)and(_rpls_rst<rpl_rhead) then
   begin
      if (net_cl_con) then
      begin
         net_clearbuffer;
         net_writebyte(nmid_clord);
         net_writeInt(ox0);
         net_writeInt(oy0);
         net_writeInt(ox1);
         net_writeInt(oy1);
         net_writebyte(oid);
         net_send(net_cl_svip,net_cl_svport);
      end
      else
        with _Players[pl] do
        begin
           o_x0:=ox0;
           o_y0:=oy0;
           o_x1:=ox1;
           o_y1:=oy1;
           o_id:=oid;
        end;

      if(pl=PlayerHuman)then
       with _players[pl] do
        if(oid=uo_action)then
        begin
           if(_get_suforef(pl)>0)then
            case oy1 of
            1:_click_eff(ox0,oy0,vid_hfps,c_red );
            2:_click_eff(ox0,oy0,vid_hfps,c_aqua );
            else
              if(ox1>0)
              then _click_eff(ox0,oy0,vid_hfps,c_lime )
              else _click_eff(ox0,oy0,vid_hfps,c_yellow);
            end;
           _unit_commandsound(race,_get_suforsn(pl));
        end;
   end;
end;

procedure DefPlayers;
var p:integer;
begin
   for p:=0 to MaxPlayers do
    with _players[p] do
    begin
       state  :=PS_none;
       name   :=str_ps_none;
       race   :=r_random;

       team   :=p;

       cenerg :=0;
       menerg :=0;
       army   :=0;

       o_id   :=0;
       o_x0   :=0;
       o_y0   :=0;
       o_x1   :=0;
       o_y1   :=0;

       bld_r  := 0;

       FillChar(eu,SizeOf(eu),0);
       FillChar(su,SizeOf(su),0);
       FillChar(upgr,SizeOf(upgr),0);

       u0     :=0;
       u1     :=0;
       u3     :=0;
       u5     :=0;

       alw_u  := [0,1,2,3,4,5,6,7];
       alw_b  := [0,1,2,3,4,5];
       alw_up := [0,1,2,3,4,5,6,7];
  ai_defense  := true;
  ai_minpush  := 15;
  ai_partpush := 3;
  ai_maxarmy  := MaxPlayerUnits;
  ai_skill    := 1;

       hcmp   := false;
       wb     := 0;
       hptm   := 0;

       ttl    :=0;
       lg_c   :=0;

       nnu    :=0;

       nur    :=2;
       nip    :=0;
       nport  :=0;
       _lsuc  :=0;
    end;

   PlayerHuman:=1;

   with _Players[PlayerHuman] do
   begin
      state:=PS_play;
      name :=PlayerName;
   end;

   with _Players[0] do
   begin
      state:=PS_Comp;
      name:='HELL';
      race:=r_hell;
      ai_skill   :=5;
      ai_partpush:=0;
      ai_minpush :=0;
   end;
end;

procedure DefGameObjects;
begin
   randomize;

   p_colors[0]:=c_white;
   p_colors[1]:=c_red;
   p_colors[2]:=c_yellow;
   p_colors[3]:=c_lime;
   p_colors[4]:=c_blue;

   m_sbuild:=255;
   FillChar(_units   ,SizeOf(_units)   ,0);
   FillChar(_effects ,SizeOf(_effects) ,0);
   FillChar(_missiles,SizeOf(_missiles),0);
   FillChar(fog_c    ,SizeOf(fog_c)    ,0);
   FillChar(g_pt     ,SizeOf(g_pt)     ,0);

   DefPlayers;

   vid_sbufs:=0;

   fog_ix:=0;
   fog_iy:=0;

   g_mode:= gm_scir;

   //g_randomseed;
   g_premap;

   vid_vx:=-vid_panel;
   vid_vy:=0;
   _view_bounds;

   _igchat:=false;
   chat_m:='';

   cmp_hellagr:=true;

   g_status:=gs_game;
   G_Step:=0;
   G_Paused:=0;
   vid_mredraw:=true;
   net_cl_svttl:=0;
   net_cl_svpl:=0;
   chat_nrlm:=false;
   _moveView:=true;

   _warpten:=false;
   _fog:=true;
   _invuln:=false;
   _fsttime:=false;

   onlySVCode:=true;
   _rpls_rst:=rpl_none;
   net_m_error:='';
   _svld_str:='';

   g_inv_t:=inv_perf;
   g_inv_w:=0;

   _lg_c_clear;
end;

procedure _tvsB_teams;
begin
   _players[1].team:=1;
   _players[2].team:=1;
   _players[3].team:=2;
   _players[4].team:=2;
end;

procedure _inv_teams;
begin
   _players[0].team:=0;
   _players[1].team:=1;
   _players[2].team:=1;
   _players[3].team:=1;
   _players[4].team:=1;
end;

procedure _scr_teams;
begin
   _players[0].team:=0;
   _players[1].team:=1;
   _players[2].team:=2;
   _players[3].team:=3;
   _players[4].team:=4;
end;

procedure _swapPlayers(p0,p1:integer);
var tp:TPlayer;
begin
   if(_players[p0].state=ps_play)or(p1=p0)then exit;

   tp:=_players[p0];
   _players[p0]:=_players[p1];
   _players[p1]:=tp;

   if(PlayerHuman=p1)then PlayerHuman:=p0
   else if(PlayerHuman=p0) then PlayerHuman:=p1;

   if(g_mode=gm_2fort)then _tvsB_teams;
   if(g_mode=gm_inv  )then _inv_teams;
end;

procedure _g_set_mode;
begin
   case g_mode of
   gm_2fort: _tvsB_teams;
   gm_inv  : _inv_teams;
   else
      _scr_teams;
   end;

end;

{$Include _campaings.pas}

procedure _StartGame;
begin
   _m_sel:=0;
   if(G_Started)then
   begin
      G_Started:=false;
      DefGameObjects;
   end else
    if(_plsReady)then
    begin
       G_Started:=true;
       _menu    :=false;
       if(_mmode<>mm_camp)
       then _CreateStartPositionsSkirmish
       else _CMPMap;
       ai_bcenter;
    end;
end;

procedure MakeRandomSkirmish(st:boolean);
var p:byte;
begin
   g_randommap;

   _swapPlayers(1,PlayerHuman);

   for p:=2 to MaxPlayers do
    with _players[p] do
    begin
       race :=random(3);
       team :=p;

       ai_skill:=random(4)+3;

       if(random(2)=0)and(p>2)
       then state:=ps_none
       else state:=ps_comp;
       _playerSetState(p);
    end;

   _swapPlayers(random(4)+1,PlayerHuman);

   g_premap;

   if(st)then _StartGame;
end;


