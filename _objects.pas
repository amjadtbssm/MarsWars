

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
      ai_partpush := 5;
      ai_maxarmy  := 81;
           end;
        5: begin
           alw_u  := [0,1,2,3,4,5,6,7];
           alw_b  := [0,1,2,3,4,5];
           alw_up := [0,1,2,3,4,5,6,7];
      ai_defense  := true;
      ai_minpush  := 15;
      ai_partpush := 4;
      ai_maxarmy  := MaxPlayerUnits;
           end;
        6: begin
           alw_u  := [0,1,2,3,4,5,6,7];
           alw_b  := [0,1,2,3,4,5];
           alw_up := [0,1,2,3,4,5,6,7];
      ai_defense  := true;
      ai_minpush  := 15;
      ai_partpush := 4;
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

          _unit_add(map_psx[p] , map_psy[p] , rut2b[race,0],p);

          if(state=ps_play)then ai_skill:=5;
          _setAI(p);
          if(ai_skill=6)then
          begin
             with _units[_lau] do generg:=3;
             menerg:=3;
          end;
       end;
    end;
end;

{$Include _map.pas}


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

       hptm   := 0;
       hcmp   := false;
       wb     := 0;

       ttl    :=0;
       lg_c   :=0;

       nnu    :=0;
       nur    :=2;

       nip    :=0;
       nport  :=0;
       _lsuc  :=0;
    end;

   PlayerHuman:=0;

   with _Players[PlayerHuman] do
   begin
      state:=PS_Comp;
      name:='Server';
      race:=r_hell;
      ai_skill   :=5;
      ai_partpush:=0;
      ai_minpush :=0; 
   end;
end;

procedure DefGameObjects;
begin
   randomize;

   FillChar(_units   ,SizeOf(_units)   ,0);
   FillChar(_missiles,SizeOf(_missiles),0);
   FillChar(g_pt     ,SizeOf(g_pt)     ,0); 

   DefPlayers;

   g_mode:=gm_scir;

   g_randommap;
   g_premap;

   G_Step:=0;
   G_Paused:=0;

   _warpten:=false;
   _invuln :=false;
   _fsttime:=false;

   _lg_c_clear;


    g_inv_t:=inv_perf;
    g_inv_w:=0;

//   net_ct:=0;
//   net_cs:=0;

   writeln('Reset game');
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

procedure _swapPlayers(p0,p1:integer);
var tp:TPlayer;
begin
   if(_players[p0].state=ps_play)or(p0=p1)then exit;

   tp:=_players[p0];
   _players[p0]:=_players[p1];
   _players[p1]:=tp;

   if(g_mode=gm_2fort)then _tvsB_teams;
   if(g_mode=gm_inv  )then _inv_teams;
end;

procedure ai_bcenter;
var i:byte;
begin
   for i:=0 to MaxPlayers do
   begin
      ai_bx[i]:=map_psx[i];
      ai_by[i]:=map_psy[i];
   end;
end;

procedure _StartStopGame;
begin
  if(G_Started=false)then
  begin
     if(_plsReady)then
     begin
        G_Started:=true;
        _CreateStartPositionsSkirmish;
        ai_bcenter;
        writeln('Start game');
     end;
  end else
  begin
     if(_plsOut)then
     begin
        G_Started:=false;
        DefGameObjects;
     end;
  end;
end;

procedure NewAI(r,t,a:byte);
var p:byte;
begin
   for p:=1 to MaxPlayers do
    with _Players[p] do
     if(state=ps_none)then
     begin
        if(g_mode in [gm_scir,gm_ct])then  team:=t;
        race:=r;
        state:=ps_comp;
        if(a in [1..6])
        then ai_skill:=a
        else ai_skill:=5;
        _playerSetState(p);
        break;
     end;
end;

procedure RemoveAI;
var p:byte;
begin
   for p:=1 to MaxPlayers do
    with _Players[p] do
    if(state=ps_comp)then
    begin
       state:=ps_none;
       _playerSetState(p);
    end;
end;

procedure cmp_ffa;
begin
  with _players[1] do if(state=ps_comp)then team:=1;
  with _players[2] do if(state=ps_comp)then team:=2;
  with _players[3] do if(state=ps_comp)then team:=3;
  with _players[4] do if(state=ps_comp)then team:=4;
end;

procedure _parseCmd(m:string;pl:byte);
begin
   if(m='-h')or(m='-help')then
   begin
      _lg_c_add(chr(0)+'-m - new map; -s - scirmish ');
      _lg_c_add(chr(0)+'-f - 2 fortress, -i - invasion');
      _lg_c_add(chr(0)+'-c - capturing points');
      _lg_c_add(chr(0)+'-p,-p1-6 - new AI player');
      _lg_c_add(chr(0)+'-k - remove all AI players');
   end;
   if(m='-m')then
   begin
      g_randommap;
      g_premap;
   end;
   if(m='-p' )then with _players[pl] do NewAI(race,team,5);
   if(m='-p1')then with _players[pl] do NewAI(race,team,1);
   if(m='-p2')then with _players[pl] do NewAI(race,team,2);
   if(m='-p3')then with _players[pl] do NewAI(race,team,3);
   if(m='-p4')then with _players[pl] do NewAI(race,team,4);
   if(m='-p5')then with _players[pl] do NewAI(race,team,5);
   if(m='-p6')then with _players[pl] do NewAI(race,team,6);
   if(m='-ffa')then cmp_ffa;
   if(m='-k')then RemoveAI;
   if(m='-f')then
   begin
      g_mode:=gm_2fort;
      _tvsB_teams;
      g_premap;
   end;
   if(m='-s')then
   begin
      g_mode:=gm_scir;
      cmp_ffa;
      g_premap;
   end;
   if(m='-i')then
   begin
      g_mode:=gm_inv;
      _inv_teams;
      g_premap;
   end;
   if(m='-c')then
   begin
      g_mode:=gm_ct;
      cmp_ffa;
      g_premap;
   end;
end;

