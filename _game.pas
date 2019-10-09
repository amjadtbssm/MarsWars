
function ai_name(ain:byte):string;
begin
   ai_name:=str_ps_comp+' '+chr(20-ain)+b2s(ain)+#25;
end;

procedure _playerSetState(p:integer);
begin
   with _players[p] do
   begin
      case state of
PS_None: begin ready:=false;name :=str_ps_none;end;
PS_Comp: begin ready:=true; name :=ai_name(ai_skill); ttl:=0;end;
PS_Play: begin ready:=false;name :=''; ttl:=0;end;
      end;
   end;
end;

procedure DefPlayers;
var p:byte;
begin
   FillChar(_players,SizeOf(TPList),0);
   for p:=0 to MaxPlayers do
    with _players[p] do
    begin
       ai_skill   := def_ai;
       race :=r_random;
       team :=p;
       if(net_nstat=ns_none)
       then state:=ps_comp
       else state:=ps_none;
       _playerSetState(p);
       ready:=false;

       ai_pushpart:= 2;
       ai_maxarmy := 100;

       ai_attack  := 0;
       _bc_ss(@a_build,[0..8]);
       _bc_ss(@a_units,[0..11]);
       _bc_ss(@a_upgr ,[0..MaxUpgrs]);
   end;

   with _players[0] do
   begin
      race     :=r_hell;
      state    :=ps_comp;
      a_build  :=0;
      a_units  :=0;
      a_upgr   :=0;
      ai_attack:=2;
   end;

   if(_ded)then exit;

   HPlayer:=1;
   with _players[1] do
   begin
      state:=ps_play;
      name :=PlayerName;
   end;
end;

procedure DefGameObjects;
begin
   randomize;

   G_Step   :=0;
   G_Paused :=0;
   G_WTeam  :=255;
   G_Mode   :=gm_scir;
   G_loss   :=0;
   G_starta :=0;
   G_onebase:=false;

   vid_mredraw:=true;
   onlySVCode :=true;

   Map_premap;

   vid_vx:=-vid_panel;
   vid_vy:=0;
   _view_bounds;

   vid_rtui:=0;
   vid_vsls:=0;

   ui_tab :=0;

   FillChar(_effects ,SizeOf(_effects )   ,0);
   FillChar(_missiles,SizeOf(_missiles)   ,0);

   FillChar(_units   ,SizeOf(_units  )   ,0);
   _lcu:=0;
   while(_lcu<MaxUnits)do
   begin
      inc(_lcu,1);
      _units[_lcu].hits:=dead_hits;
   end;

   FillChar(ui_alrms,SizeOf(ui_alrms  )   ,0);

   FillChar(fog_c    ,SizeOf(fog_c)    ,0);
   FillChar(g_ct_pl  ,SizeOf(g_ct_pl),  0);

   plcolor[0]:=c_white;
   plcolor[1]:=c_red;
   plcolor[2]:=c_yellow;
   plcolor[3]:=c_lime;
   plcolor[4]:=c_blue;

   fog_ix:=0;
   fog_iy:=fog_chs;

   DefPlayers;

   net_m_error:='';

   _igchat:=false;
   net_chat_str:='';
   net_chat_cl;
   net_cl_svttl:=0;
   net_cl_svpl:=0;

   if(_rpls_rst>rpl_wunit)then _rpls_rst:=rpl_none;

   m_sxs:=-1;
   m_sbuild:=255;

   _fog    :=true;
   _fsttime:=false;
   _warpten:=false;

   UnitStepNum:=8;

   _lcu :=0;
   _lcup:=@_units[0];
   _lsuc:=255;

   _svld_str:='';

   g_inv_wn     := 0;
   g_inv_t      := 0;

   ui_umark_u:=0;
   ui_umark_t:=0;

   _uclord_c :=0;

   cmp_ait2p:=0;
end;

{$include _replays.pas}

procedure _swAI(p:byte);
begin
   with _players[p] do
    if(state=PS_Comp)then
     begin
        inc(ai_skill,1);
        if(ai_skill>6)then ai_skill:=1;
        name:=ai_name(ai_skill);
     end;
end;

procedure _CreateStartPositionsSkirmish;
var p:byte;
begin
   GModeTeams(g_mode);
   if(g_mode=gm_coop)then _make_coop;

   for p:=1 to MaxPlayers do
    with _players[p] do
    begin
       if(state=ps_none)then
        if(g_mode in [gm_2fort,gm_inv,gm_coop])then
        begin
           state   :=ps_comp;
           ai_skill:=def_ai;
           race    :=r_random;
           _playerSetState(p);
        end;

       if(race=r_random)then race:=1+random(2);

       if(state<>PS_None)then
       begin
          case G_starta of
          0 : _unit_add(map_psx[p],map_psy[p],cl2uid[race,true,0],p,true);
          1 : begin
                 _unit_add(map_psx[p],map_psy[p],cl2uid[race,true,0],p,true);
                 _unit_add(map_psx[p]-115,map_psy[p],cl2uid[race,true,2],p,true);
              end;
          2 : begin
                 _unit_add(map_psx[p],map_psy[p],cl2uid[race,true,0],p,true);
                 _unit_add(map_psx[p]-115,map_psy[p],cl2uid[race,true,2],p,true);
                 _unit_add(map_psx[p]+115,map_psy[p],cl2uid[race,true,2],p,true);
              end;
          3 : begin
                 _unit_add(map_psx[p],map_psy[p],cl2uid[race,true,0],p,true);
                 _unit_add(map_psx[p]-115,map_psy[p],cl2uid[race,true,2],p,true);
                 _unit_add(map_psx[p]+115,map_psy[p],cl2uid[race,true,2],p,true);
                 _unit_add(map_psx[p],map_psy[p]+150,cl2uid[race,true,1],p,true);
                 _unit_add(map_psx[p],map_psy[p]-150,cl2uid[race,true,1],p,true);
              end;
          end;

          if(state=ps_play)then ai_skill:=def_ai;
          _setAI(p);
       end;
    end;

   _moveHumView(map_psx[HPlayer] , map_psy[HPlayer]);
end;

procedure _swapPlayers(p0,p1:integer);
var tp:TPlayer;
begin
   if(_players[p0].state=ps_play)or(p1=p0)then exit;

   tp:=_players[p0];
   _players[p0]:=_players[p1];
   _players[p1]:=tp;

   if(HPlayer=p1)then HPlayer:=p0
   else
     if(HPlayer=p0)then HPlayer:=p1;
end;


procedure _StartGame;
begin
   _m_sel:=0;
   if(G_Started)then
   begin
      G_Started:=false;
      DefGameObjects;
   end
   else
    if(_plsReady)then
    begin
       G_Started:=true;
       _menu    :=false;
       if(menu_s2<>ms2_camp)
       then _CreateStartPositionsSkirmish
       else _CMPMap;
       vid_rtui:=2;
       sdl_FillRect(_minimap,nil,0);
       D_ui;
    end;
end;

procedure MakeRandomSkirmish(st:boolean);
var p:byte;
begin
   Map_randommap;

   G_loss   :=random(3);
   G_starta :=random(4);
   G_onebase:=random(4)=0;

   _swapPlayers(1,HPlayer);

   for p:=2 to MaxPlayers do
    with _players[p] do
    begin
       race :=random(3);

       if(p=4)
       then team :=1+random(4)
       else team :=2+random(3);

       ai_skill:=random(3)+3;

       if(random(2)=0)and(p>2)
       then state:=ps_none
       else state:=ps_comp;
       _playerSetState(p);
    end;

   _swapPlayers(random(4)+1,HPlayer);

   Map_premap;

   if(st)then _StartGame;
end;


procedure _u_ord(pl:byte);
var u,scnt,scntm:integer;
 psel:boolean;
begin
   with _players[pl] do
   if(o_id>0)and(army>0)then
   begin
      case o_id of
uo_build   : _unit_startb(o_x0,o_y0,o_x1,pl);
      else
         scnt :=0;
         scntm:=100;
         if(o_id in [uo_select,uo_aselect])then
         begin
            if(o_x0>o_x1)then begin u:=o_x1;o_x1:=o_x0;o_x0:=u;end;
            if(o_y0>o_y1)then begin u:=o_y1;o_y1:=o_y0;o_y0:=u;end;
            if(dist2(o_x0,o_y0,o_x1,o_y1)<4)then scntm:=1;
         end;

         for u:=1 to MaxUnits do
          with _units[u] do
           if(hits>0)and(inapc=0)and(pl=player)then
           begin
              psel:=sel;
              if(o_id=uo_select)or((o_id=uo_aselect)and(not sel))then
              begin
                 sel:=((o_x0-r)<=vx)and(vx<=(o_x1+r))and((o_y0-r)<=vy)and(vy<=(o_y1+r));
                 if(speed=0)and(scntm>1)and(o_id<>uo_aselect)then sel:=false;
                 if(scnt>=scntm)then sel:=false;
              end;
              if(o_id=uo_selorder)and((o_y0=0)or(not sel))then sel:=(order=o_x0);

              if(o_id=uo_dblselect)or((o_id=uo_adblselect)and(not sel))then
               if(_lsuc=uid)then
                sel:=((o_x0-r)<=vx)and(vx<=(o_x1+r))and((o_y0-r)<=vy)and(vy<=(o_y1+r));

              if(o_id=uo_specsel)then
               case o_x0 of
                  0 : if(isbuild=false)then sel:=true else if(o_y0=0)then sel:=false;
                  1 : if(ubx[5]=u)then sel:=true else if(o_y0=0)then sel:=false;
                  2 : if(ubx[8]=u)then sel:=true else if(o_y0=0)then sel:=false;
                  3 : if(ubx[6]=u)then sel:=true else if(o_y0=0)then sel:=false;
               end;

              if(o_id=uo_action)then
               case o_x0 of
               //-2 : if(ubx[3]=u)then _unit_supgrade(u,o_y0);  // start upgr
               //-3 : if(ubx[3]=u)then _unit_cupgrade(u);       // cancle upgr

               -2 : if(rld=0)and(ucl=3)and(isbuild)and(bld)then
                     if(u_s[true,3]=0)then                      // start upgr
                     begin
                        _unit_supgrade(u,o_y0);
                        break;
                     end;
               -3 : if(rld>0)and(ucl=3)and(isbuild)and(bld)and(utrain=o_y0)then
                     if(u_s[true,3]=0)then                      // cancle upgr
                     begin
                        _unit_cupgrade(u);
                        break;
                     end;

               -4 : if(rld=0)and(ucl=1)and(isbuild)and(bld)then
                     if(u_s[true,1]=0)then                      // start training
                     begin
                        _unit_straining(u,o_y0);
                        break;
                     end;
               -5 : if(rld>0)and(ucl=1)and(isbuild)and(bld)and(utrain=o_y0)then
                     if(u_s[true,1]=0)then                      // cancle training
                     begin
                        _unit_ctraining(u);
                        break;
                     end;
               end;

              if(sel)then
              begin
                 case o_id of
               uo_select     : _lsuc:=uid;
               uo_setorder   : order:=o_x0;
               uo_delete     : _unit_kill(u,false,o_x0>0);
               uo_move       : begin
                                  uo_x :=o_x0;
                                  uo_y :=o_y0;

                                  case uid of
                                   UID_HKeep      : _unit_bteleport(u);
                                   UID_URadar     : _unit_uradar(u);
                                   UID_URocketL   : _unit_URocketL(u);
                                   UID_HMonastery : if(o_y1<>u)then uo_tar:=o_y1;
                                   UID_HGate,
                                   UID_UMilitaryUnit,
                                   UID_HMilitaryUnit,
                                   UID_HTeleport  : begin
                                                       if(o_y1<>u)then uo_tar:=o_y1;
                                                       if(o_x1>0)
                                                       then uo_id:=ua_amove
                                                       else uo_id:=ua_move;
                                                    end;
                                   UID_HSymbol,
                                   UID_HTower,
                                   UID_HTotem,
                                   UID_HAltar     : _unit_b478teleport(u);
                                   else
                                     if(o_y1<>u)then uo_tar:=o_y1;
                                     if(o_x1>0)
                                     then uo_id:=ua_amove
                                     else uo_id:=ua_move;
                                     if(_canmove(u))then dir:=p_dir(x,y,uo_x,uo_y);
                                  end;
                               end;
               uo_action     : case o_x0 of
                                  0 :
                                    if(isbuild=false)then
                                    begin
                                       uo_x:=x;
                                       uo_y:=y;
                                    end
                                    else
                                      if(bld=false)
                                      then _unit_kill(u,false,false)
                                      else
                                        if(rld>0)then
                                         case ucl of
                                         1: _unit_ctraining(u);
                                         3: _unit_cupgrade(u);
                                         end;
                             1..30000 : _unit_action(u);
                                 -2 : _unit_supgrade(u,o_y0);
                                 -3 : if(rld>0)and(ucl=3)and(isbuild)and(bld)and(utrain=o_y0)then _unit_cupgrade(u);
                                 -4 : _unit_straining(u,o_y0);
                                 -5 : if(rld>0)and(ucl=1)and(isbuild)and(bld)and(utrain=o_y0)then _unit_ctraining(u);
                               end;
                 end;

                 if(psel=false)then inc(u_s[isbuild,ucl],1);
                 inc(scnt,1);
              end
              else
              begin
                 if(psel=true)then dec(u_s[isbuild,ucl],1);
                 if(o_id=uo_setorder)and(order=o_x0)then order:=0;
              end;
           end;

         if(o_id in [uo_select,uo_aselect])then
          if(scnt=0)then _lsuc:=255;
      end;

      o_id:=0;
   end;
end;

procedure PlayersCycle;
var p:byte;
begin
   for p:=0 to MaxPlayers do
    with _players[p] do
     if(state>ps_none)then
     begin
        if(state=PS_Play)and(p<>HPlayer)and(net_nstat=ns_srvr)then
        begin
           if (ttl<ClientTTL)then
           begin
              Inc(ttl,1);
              if(ttl=ClientTTL)or(ttl=vid_fps)then vid_mredraw:=true;
           end
           else
             if(G_Started=false)then
             begin
                state:=PS_None;
                _playerSetState(p);
                vid_mredraw:=true;
             end;
        end;

        if(G_Started)and(G_Paused=0)and(onlySVCode)then
        begin
           _u_ord(p);

           if(bld_r>0)then dec(bld_r,1);
           if(race=r_hell)then
            if(upgr[upgr_hinvuln]>0)and(effect=0)then effect:=invuln_time;

           if(effect>0)then
           begin
              dec(effect,1);
              if(effect=0)then upgr[upgr_hinvuln]:=0;
           end;
        end;
     end;

   if(G_Started)and(G_Paused=0)and(onlySVCode)then
   begin
      if(net_nstat>ns_none)and(G_Step<60)then exit;

      if(G_WTeam=255)then
      begin
         FillChar(team_army,SizeOf(team_army),0);
         G_WTeam:=255;
         for p:=0 to MaxPlayers do
          with _players[p] do
           if(state>ps_none)then inc(team_army[team],army);

         if(menu_s2=ms2_camp)
         then cmp_code
         else
          if(g_mode<>gm_inv)then
           for p:=0 to MaxPlayers do
            if(team_army[p]>0)then
             if(G_WTeam<255)then
             begin
                G_WTeam:=255;
                break;
             end
             else G_WTeam:=p;
      end
      else
      begin
         G_Paused:=1;
         _draw:=true;
      end;
   end;
end;

procedure fog_prc;
var i:integer;
begin
   inc(fog_ix,1);fog_ix:=fog_ix mod fog_cs;
   inc(fog_iy,1);fog_iy:=fog_iy mod fog_cs;

   if(_fog=false)then
   begin
      for i:=0 to fog_cs do
      begin
         fog_c[fog_ix,i]:=fog_add;
         fog_c[i,fog_iy]:=fog_add;
      end;
   end
   else
     for i:=0 to fog_cs do
     begin
        fog_c[fog_ix,i]:=fog_c[fog_ix,i] shr 1;
        fog_c[i,fog_iy]:=fog_c[i,fog_iy] shr 1;
     end;
end;

procedure g_inv_spawn;
var i,tx,ty:integer;
  mon:byte;
begin
   if(G_WTeam=255)then
   if(_players[0].army=0)then
   begin
      if(g_inv_t=0)then
      begin
         if(g_inv_wn=20)
         then G_WTeam:=1
         else
         begin
            inc(g_inv_wn,1);
            case g_inv_wn of
            1       : g_inv_t:=vid_fps*120;
            2..9    : g_inv_t:=vid_fps*60;
            10      : g_inv_t:=vid_fps*120;
            11..18  : g_inv_t:=vid_fps*150;
            else
                    g_inv_t:=vid_fps*120;
            end;
            g_inv_mn:=g_inv_wn*5;
         end;
      end
      else
      begin
         dec(g_inv_t,1);
         if(g_inv_t=0)then
         begin
            PlaySND(snd_l_spawn,0);
            for i:=1 to g_inv_mn do
            begin
               if(g_inv_wn=10)
               then mon:=UID_Dron
               else
                 if((i mod 25)=0)
                 then mon:=UID_Cyclope
                 else
                   if(i mod 2)=0
                   then mon:=UID_Dron
                   else mon:=UID_Octobrain;

               repeat
                  tx:=random(map_mw);
                  ty:=random(map_mw);
               until (dist2(map_psx[0],map_psx[0],tx,ty)>2000);

               _unit_add(tx,ty,mon,0,true);
               with _lcup^ do
               begin
                  _effect_add(vx,vy,vy+map_flydpth[uf]+1,EID_Teleport);
                  if((i mod 11)=0)and(mon<>UID_Cyclope)then
                  begin
                     buff[ub_invis ]:=255;
                     buff[ub_detect]:=255;
                  end;
                  buff[ub_advanced ]:=255;
                  painc:=5*painc;
                  if(uid=UID_Cyclope)then buff[ub_detect]:=255;
                  order:=2;
               end;
            end;
         end;
      end;
   end;
end;

procedure _CPoints;
var i,t,e:integer;
begin
   e:=0;
   t:=0;
   for i:=1 to MaxPlayers do
    with g_ct_pl[i] do
    begin
       if(ct>0)then dec(ct,1);
       if(t=0)or(t<>_players[pl].team)then
       begin
          t:=_players[pl].team;
          e:=1;
       end
       else inc(e,1);
    end;

   if(e=4)and(G_WTeam=255)then
   begin
      G_WTeam:=t;
      for i:=1 to MaxUnits do
       with _units[i] do
        if(hits>0)and(inapc=0)then
         with _players[player] do
          if(team<>t)then _unit_kill(i,false,false);
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
   if(length(m)=0)then exit;
   if(ord(m[1])<5)then delete(m,1,1);

   if(m='-h')or(m='-help')then
   begin
      net_chat_add(chr(0)+'-m - new map; -s - skirmish');
      net_chat_add(chr(0)+'-f - 2 fortress, -i - invasion');
      net_chat_add(chr(0)+'-c - capturing points');
      net_chat_add(chr(0)+'-p,-p1-6 - new AI player');
      net_chat_add(chr(0)+'-k - remove all AI players');
      net_chat_add(chr(0)+'-ffa - set 1-2-3-4 teams to AI');
      net_chat_add(chr(0)+'-ud/-d2 - UDOOM/DOOM 2 mode');
   end;
   if(m='-m')then begin Map_randommap; Map_premap;end;
   if(m='-p' )then with _players[pl] do NewAI(race,team,4);
   if(m='-p1')then with _players[pl] do NewAI(race,team,1);
   if(m='-p2')then with _players[pl] do NewAI(race,team,2);
   if(m='-p3')then with _players[pl] do NewAI(race,team,3);
   if(m='-p4')then with _players[pl] do NewAI(race,team,4);
   if(m='-p5')then with _players[pl] do NewAI(race,team,5);
   if(m='-p6')then with _players[pl] do NewAI(race,team,6);
   if(m='-ffa')then cmp_ffa;
   if(m='-k')then RemoveAI;
   if(m='-d2')then g_addon:=true;
   if(m='-ud')then g_addon:=false;
   if(m='-f')then
   begin
      g_mode:=gm_2fort;
      Map_premap;
   end;
   if(m='-s')then
   begin
      g_mode:=gm_scir;
      cmp_ffa;
      Map_premap;
   end;
   if(m='-i')then
   begin
      g_mode:=gm_inv;
      Map_premap;
   end;
   if(m='-c')then
   begin
      g_mode:=gm_ct;
      cmp_ffa;
      Map_premap;
   end;
end;

{$include _net_game.pas}

procedure _dedCode;
begin
   if(G_Started=false)then
   begin
      if(_plsReady)then
      begin
         vid_mredraw:=true;
         G_Started:=true;
         _menu    :=false;
         _CreateStartPositionsSkirmish;
         vid_rtui:=2;
      end;
   end
   else
   begin
      if(_plsOut)then
      begin
         G_Started:=false;
         DefGameObjects;
      end;
   end;
end;

procedure CodeGame;
begin
   inc(vid_rtui,1);
   vid_rtui:=vid_rtui mod vid_rtuis;

   if(vid_rtui=0)then _MusicCheck;

   if(_ded)then _dedCode;

   if(net_nstat=ns_clnt)then net_GClient;

   _rpls_code;

   PlayersCycle;

   if(G_Started)and(G_paused=0)then
   begin
      FillChar(ui_bldrs_x,SizeOf(ui_bldrs_x),0);
      FillChar(ui_trnt   ,SizeOf(ui_trnt   ),0);
      FillChar(ui_trntc  ,SizeOf(ui_trntc  ),0);
      ui_upgrc:=0;
      ui_upgrl:=0;
      FillChar(ui_upgr   ,SizeOf(ui_upgr   ),0);
      FillChar(ui_apc    ,SizeOf(ui_apc    ),0);
      FillChar(ui_blds   ,SizeOf(ui_blds   ),0);
      FillChar(ordx      ,SizeOf(ordx      ),0);
      FillChar(ordy      ,SizeOf(ordy      ),0);
      if(ui_umark_t>0)then begin dec(ui_umark_t,1);if(ui_umark_t=0)then ui_umark_u:=0;end;
      inc(_uclord_c,1); _uclord_c:=_uclord_c mod _uclord_p;
      inc(_uregen_c,1); _uregen_c:=_uregen_c mod regen_per;

      fog_prc;
      _dds_p;
      _unitsCycle;
      _missileCycle;
      _effectsCycle(true);

      if(onlySVCode)then
      begin
         inc(G_Step,1);
         if(g_mode=gm_ct )then _CPoints;
         if(g_mode=gm_inv)then g_inv_spawn;
      end;
   end;

   if(net_nstat=ns_srvr)then net_GServer;
end;


