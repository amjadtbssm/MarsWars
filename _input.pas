

procedure _chatm;
begin
   if(_menu=false)and(not _igchat)and(net_cl_con or net_sv_up) //
   then _igchat:=true
   else
    if(_m_sel=100)or(_igchat)then
    begin
       if(length(chat_m)>0)then
        if(net_cl_con)
        then net_chatm
        else _lg_c_add(chr(PlayerHuman)+chat_m);
       chat_m:='';
       _igchat:=false;
    end;
end;

procedure escape_key;
begin
   if(_igchat)then
   begin
      _igchat:=false;
      chat_m:='';
   end
   else ToggleMenu;
end;

procedure TogglePause;
begin
   if(net_cl_con)
   then net_cl_pause
   else
     if(net_sv_up)then
       if(G_paused=0)
       then G_paused:=PlayerHuman
       else G_paused:=0;
end;

procedure _hotkey(k:integer);
begin

 if(k=sdlk_pause)
 then TogglePause
 else
  if(G_Paused=0)then
   case k of
     sdlk_R      : m_sbuild:=0;
     sdlk_T      : m_sbuild:=1;
     sdlk_Y      : m_sbuild:=2;
     sdlk_F      : m_sbuild:=3;
     sdlk_G      : m_sbuild:=4;
     sdlk_H      : m_sbuild:=5;
     sdlk_C      : _player_s_o(k_ctrl,k_shift,0,0, uo_stop     ,PlayerHuman);
     sdlk_Q      : _player_s_o(0,0,0,0, uo_training ,PlayerHuman);
     sdlk_W      : _player_s_o(1,0,0,0, uo_training ,PlayerHuman);
     sdlk_E      : _player_s_o(2,0,0,0, uo_training ,PlayerHuman);
     sdlk_A      : if (k_ctrl>1)
                   then _player_s_o(0,0,0,0,uo_selall ,PlayerHuman)
                   else _player_s_o(3,0,0,0, uo_training ,PlayerHuman);
     sdlk_S      : _player_s_o(4,0,0,0, uo_training ,PlayerHuman);
     sdlk_D      : _player_s_o(5,0,0,0, uo_training ,PlayerHuman);
     sdlk_Z      : _player_s_o(6,0,0,0, uo_training ,PlayerHuman);
     sdlk_V      : _player_s_o(7,0,0,0, uo_training ,PlayerHuman);
     sdlk_X      : _player_s_o(0,0,0,0, uo_cancle   ,PlayerHuman);
     sdlk_U      : _player_s_o(0,0,0,0, uo_upgrade  ,PlayerHuman);
     sdlk_I      : _player_s_o(1,0,0,0, uo_upgrade  ,PlayerHuman);
     sdlk_O      : _player_s_o(2,0,0,0, uo_upgrade  ,PlayerHuman);
     sdlk_J      : _player_s_o(3,0,0,0, uo_upgrade  ,PlayerHuman);
     sdlk_K      : _player_s_o(4,0,0,0, uo_upgrade  ,PlayerHuman);
     sdlk_L      : _player_s_o(5,0,0,0, uo_upgrade  ,PlayerHuman);
     sdlk_M      : _player_s_o(6,0,0,0, uo_upgrade  ,PlayerHuman);
     SDLK_COMMA  : _player_s_o(7,0,0,0, uo_upgrade  ,PlayerHuman);
     SDLK_PERIOD : _player_s_o(0,0,0,0, uo_upcancle ,PlayerHuman);
  sdlk_0..sdlk_9 :  if (k_ctrl>1)
                    then _player_s_o(_event^.key.keysym.sym-48,0,0,0,uo_setorder,PlayerHuman)
                    else _player_s_o(_event^.key.keysym.sym-48,k_shift,0,0,uo_selorder,PlayerHuman);
  sdlk_delete    :  _player_s_o(0,0,0,0,uo_delete,PlayerHuman);
   else
      if(_testmode)then
        case k of
          sdlk_end       : begin
             _fsttime:=not _fsttime;
              if(net_cl_con)then
                              begin
                                 net_clearbuffer;
                                 net_writebyte(nmid_chat);
                                 net_writestring('f');
                                 net_send(net_cl_svip,net_cl_svport);
                              end;
          end;
          sdlk_home      : _warpten:=not _warpten;
          sdlk_pageup    : if (not net_cl_con) then with _players[PlayerHuman] do if(state=PS_Play)then state:=PS_Comp else state:=PS_Play;
          sdlk_pagedown  : _invuln:=not _invuln;
          sdlk_backspace : _fog:=not _fog;
          sdlk_insert    : vid_draw:=not vid_draw;
        end;
   end;
end;


procedure _keyp(i:pbyte);
begin
   if (i^>1)and(i^<255) then inc(i^,1);
   if (i^=1) then i^:=0;
end;

procedure WindowEvents;
begin
   _keyp(@k_u);
   _keyp(@k_d);
   _keyp(@k_r);
   _keyp(@k_l);
   _keyp(@k_shift);
   _keyp(@k_ctrl);
   _keyp(@k_alt);
   _keyp(@k_ml);
   _keyp(@k_mr);
   _keyp(@k_chrt);

   while (SDL_PollEvent( _event )>0) do
    CASE (_event^.type_) OF
      SDL_MOUSEMOTION    : begin
                              if(m_vmove)and(_menu=false)and(G_Started)and(G_Paused=0)then
                              begin
                                 dec(vid_vx,_event^.motion.x-m_vx);
                                 dec(vid_vy,_event^.motion.y-m_vy);
                                 _view_bounds;
                              end;
                              m_vx:=_event^.motion.x;
                              m_vy:=_event^.motion.y;
                           end;
      SDL_MOUSEBUTTONUP  : begin
                              case (_event^.button.button) of
                            SDL_BUTTON_left   : k_ml:=1;
                            SDL_BUTTON_right  : k_mr:=1;
                            SDL_BUTTON_middle : m_vmove:=false;
                              else
                              end;
                           end;
      SDL_MOUSEBUTTONDOWN: begin
                              case (_event^.button.button) of
                            SDL_BUTTON_left      : if (k_ml=0) then k_ml:=2;
                            SDL_BUTTON_right     : if (k_mr=0) then k_mr:=2;
                            SDL_BUTTON_middle    : if(_menu=false)and(G_Started)and(G_Paused=0)then m_vmove:=true;
                            SDL_BUTTON_WHEELDOWN : if(_menu)then
                                                   begin
                                                      vid_mredraw:=true;

                                                      if(_m_sel=30)then _scrollV(@_mcmp_srl,1,0,MaxMissions-MINSCR);
                                                      if(_m_sel=40)then _scrollV(@_svld_srl,1,0,_svld_lsts-MSVLDINSCR);
                                                      if(_m_sel=83)then _scrollV(@_rpls_srl,1,0,_rpls_lsts-MRPLSINSCR);
                                                   end;
                            SDL_BUTTON_WHEELUP   : if(_menu)then
                                                   begin
                                                      vid_mredraw:=true;

                                                      if(_m_sel=30)then _scrollV(@_mcmp_srl,-1,0,MaxMissions-MINSCR);
                                                      if(_m_sel=40)then _scrollV(@_svld_srl,-1,0,_svld_lsts-MSVLDINSCR);
                                                      if(_m_sel=83)then _scrollV(@_rpls_srl,-1,0,_rpls_lsts-MRPLSINSCR);
                                                   end;
                              else
                              end;
                           end;
      SDL_QUITEV         : begin _CYCLE:=false; end;
      SDL_KEYUP          : begin
                              k_chrt:=1;
                              case (_event^.key.keysym.sym) of
                                sdlk_up    : k_u:=1;
                                sdlk_down  : k_d:=1;
                                sdlk_left  : k_l:=1;
                                sdlk_right : k_r:=1;
                                sdlk_rshift: k_shift:=1;
                                sdlk_lshift: k_shift:=1;
                                sdlk_lctrl : k_ctrl:=1;
                                sdlk_rctrl : k_ctrl:=1;
                                sdlk_lalt  : k_alt :=1;
                                sdlk_ralt  : k_alt :=1;
                              else
                              end;
                           end;
      SDL_KEYDOWN        : begin
                              k_chrt:=2;
                              k_chr :=Widechar(_event^.key.keysym.unicode);

                              case (_event^.key.keysym.sym) of
                                sdlk_up    : if (k_u=0)     then k_u:=2;
                                sdlk_down  : if (k_d=0)     then k_d:=2;
                                sdlk_left  : if (k_l=0)     then k_l:=2;
                                sdlk_right : if (k_r=0)     then k_r:=2;
                                sdlk_rshift: if (k_shift=0) then k_shift:=2;
                                sdlk_lshift: if (k_shift=0) then k_shift:=2;
                                sdlk_rctrl : if (k_ctrl=0)  then k_ctrl:=2;
                                sdlk_lctrl : if (k_ctrl=0)  then k_ctrl:=2;
                                sdlk_ralt  : if (k_alt=0)   then k_alt:=2;
                                sdlk_lalt  : if (k_alt=0)   then k_alt:=2;
                                SDLK_PRINT : _screenshot;
                                sdlk_escape: escape_key;
                                sdlk_return: _chatm;
                              else
                                if(_menu=false)and(G_Started)and(_igchat=false)then _hotkey(_event^.key.keysym.sym);

                                if(_m_sel=100)or(_igchat)then chat_m:=menu_sf(chat_m,k_kbstr,ChatLen);
                              end;
                           end;
    else
    end;
end;

function _whoInPoint(tx,ty:integer;tm:byte):integer;
var i:integer;
begin
   _whoInPoint:=0;
   for i:=1 to MaxUnits do
    with _units[i] do
     if(hits>0)and(vis>uv_novis)then
      if(dist2(vx,vy,tx,ty)<r)then
        with _players[player] do
         if(team<>tm)then
         begin
            _whoInPoint:=1;//enemy
            break;
         end
         else
           if(player=playerhuman)and(apcm>0)and(apcc<apcm)then
           begin
              _whoInPoint:=2;//transport
              break;
           end;
end;

procedure _chkbld;
begin
   if(m_sbuild<255) then
    with _players[PlayerHuman] do
    begin
       if(m_sbuild=5)and(eu[true,5]>0)then
       begin
          _player_s_o(0,0,0,0,uo_selu5,PlayerHuman);
          m_sbuild:=255;
       end
       else
        if(bld_r>0)or(eu[true,ut_0]=0)or(not(m_sbuild in alw_b))or(u0=0)or(menerg<=cenerg)or(army=MaxPlayerUnits)or(eu[true,m_sbuild]>=b_m[m_sbuild])
        then m_sbuild:=255
        else if (dist2(m_mx,m_my,_units[u0].x,_units[u0].y)>base_r)or not((build_b<m_mx)and(m_mx<map_b1)and(build_b<m_my)and(m_my<map_b1))
             then m_sbuildc:=c_blue
             else if _unit_grbcol(m_mx,m_my,b_r[m_sbuild])
                  then m_sbuildc:=c_red
                  else m_sbuildc:=c_lime;
    end;
end;

procedure g_mouse;
var u:integer;
begin
   m_mx :=m_vx+vid_vx;
   m_my :=m_vy+vid_vy;
   m_bx :=m_vx div vid_BW;
   m_by :=m_vy div vid_BW;

   //if(m_rdblclk>0)then dec(m_rdblclk,1);
   if(m_ldblclk>0)then dec(m_ldblclk,1);

   _chkbld;

   if (k_ml=2) then  // left button
   begin
      if (vid_panel<=m_vx) then
      begin
         if(m_sbuild=255)then
         begin
            m_sxs:=m_mx;
            m_sys:=m_my;
         end else
          if(m_sbuildc=c_lime)then
          begin
             _player_s_o(m_mx,m_my,m_sbuild,0, uo_build  ,PlayerHuman);
             m_sbuild:=255;
          end;
         //if(k_shift>2)then _unit_add(m_mx,m_my,UID_mine,2);
      end else
       if (vid_panel>=m_vy) then
       begin
          if(G_Paused=0) then
          begin
             vid_vx:=trunc(m_vx/map_mmcx)-((vid_mw+vid_panel) shr 1);
             vid_vy:=trunc(m_vy/map_mmcx)-( vid_mh            shr 1);
             _view_bounds;
          end;
       end else
       begin
         if(m_by=12)then
          case m_bx of
          0 : ToggleMenu;
          2 : if(net_sv_up or net_cl_con)then TogglePause;
          end
         else
         if(G_Paused=0)then
           if(_rpls_rst<rpl_rhead)then
           begin
              with _players[PlayerHuman] do
              begin
                 if (3<m_by)and(m_by<6)then
                 begin
                    m_sbuild:=((m_by-4)*3)+(m_bx mod 3);
                    _chkbld;
                 end;

                 if(eu[true,ut_1]>0)and(menerg>cenerg)and((army+wb)<MaxPlayerUnits)then           //
                 begin
                    if (5<m_by)and(m_by<9)then
                    begin
                       u:=((m_by-6)*3)+(m_bx mod 3);
                       if(u<8)then _player_s_o(u,0,0,0, uo_training  ,PlayerHuman);
                    end;
                 end;

                 if(eu[true,ut_1]>0)then
                  if(m_bx=2)and(m_by=8)then _player_s_o(0,0,0,0, uo_cancle  ,PlayerHuman);

                 if(eu[true,ut_3]>0)then
                 begin
                    if (8<m_by)and(m_by<12)and(menerg>cenerg)then
                    begin
                       u:=((m_by-9)*3)+(m_bx mod 3);
                       if(u<8)then _player_s_o(u,0,0,0, uo_upgrade  ,PlayerHuman);
                    end;
                    if(m_bx=2)and(m_by=11)then _player_s_o(0,0,0,0, uo_upcancle  ,PlayerHuman);
                 end;
              end;
              PlaySNDM(snd_click);
           end
           else
             if(_rpls_rst=rpl_runits)then
             begin
                if(m_by=4)then
                begin
                   if(m_bx=0)then _fsttime:=not _fsttime;
                   if(m_bx=1)then _rpls_step:=_rpls_pnu*2;
                end;
                if(m_bx=0)then
                begin
                if(m_by=5)then PlayerHuman:=0;
                if(m_by=6)then PlayerHuman:=1;
                if(m_by=7)then PlayerHuman:=2;
                if(m_by=8)then PlayerHuman:=3;
                if(m_by=9)then PlayerHuman:=4;
                end;
                PlaySNDM(snd_click);
             end;
       end;
   end;

   if (k_ml=1)and(m_sxs>-1) then
   begin
      if(m_ldblclk>0)
      then
        if(k_shift<2)
        then _player_s_o(vid_vx+vid_panel,vid_vy, vid_vx+vid_mw,vid_vy+vid_mh, uo_dblselect  ,PlayerHuman)
        else _player_s_o(vid_vx+vid_panel,vid_vy, vid_vx+vid_mw,vid_vy+vid_mh, uo_adblselect ,PlayerHuman)
      else
        if(k_shift<2)
        then _player_s_o(m_sxs,m_sys,m_mx,m_my,uo_select ,PlayerHuman)
        else _player_s_o(m_sxs,m_sys,m_mx,m_my,uo_aselect,PlayerHuman);

      m_sxs:=-1;
      m_ldblclk:=dblclk_tl;
   end;

   if (k_mr=2) then // right button
   begin
      u:=k_ctrl;
      if(_ma_inv)then
       if(k_ctrl>0)
       then k_ctrl:=0
       else k_ctrl:=3;

      if(m_sbuild<255)
      then m_sbuild:=255
      else
       if (vid_panel<m_vx) then
       begin
          _player_s_o(m_mx,m_my,k_ctrl,_whoInPoint(m_mx,m_my,_players[PlayerHuman].team),uo_action,PlayerHuman)   //
       end else
        if (vid_panel>m_vy) then  // mini-map
        begin
           _player_s_o(trunc(m_vx/map_mmcx), trunc(m_vy/map_mmcx),k_ctrl,0,uo_action,PlayerHuman)
        end else
           if(G_Paused=0)then
            if(_rpls_rst<rpl_rhead)then
            begin
               with _players[PlayerHuman] do
                if(race=r_hell)and(u5>0)then
                 if (m_by=5)and(m_bx=2)then _player_s_o(0,0,0,0,uo_ioinu5,PlayerHuman);

               if (5<m_by)and(m_by<9)then _player_s_o(((m_by-6)*3)+(m_bx mod 3),0,0,0, uo_ctraining  ,PlayerHuman);
            end
            else
            begin
               if(m_by=4)then
                if(m_bx=1)then _rpls_step:=_rpls_pnu*10;
            end;
      k_ctrl:=u;
   end;

  // if (k_mr=1)then m_rdblclk:=dblclk_tr;
end;

procedure _move_v_m;
begin
   if(m_vx<vid_vmb_x0)then dec(vid_vx,vid_vms);
   if(m_vy<vid_vmb_y0)then dec(vid_vy,vid_vms);
   if(m_vx>vid_vmb_x1)then inc(vid_vx,vid_vms);
   if(m_vy>vid_vmb_y1)then inc(vid_vy,vid_vms);
end;

procedure _view_move;
var vx,vy:integer;
begin
   vx:=vid_vx;
   vy:=vid_vy;

   if(vid_vmm)then _move_v_m;

   if (k_u>1) then dec(vid_vy,vid_vms);
   if (k_l>1) then dec(vid_vx,vid_vms);
   if (k_d>1) then inc(vid_vy,vid_vms);
   if (k_r>1) then inc(vid_vx,vid_vms);

   if(vx<>vid_vx)or(vy<>vid_vy)then _view_bounds;
end;


procedure g_keyboard;
begin
   if(G_Paused=0)then _view_move;
end;

procedure InputGame;
begin
   WindowEvents;

   if(k_chrt>k_chrtt)then
    if(_m_sel=100)or(_igchat)then chat_m:=menu_sf(chat_m,k_kbstr,ChatLen);

   if(_menu)then
   begin
      dec(m_vx,vid_menuX);
      g_menu;
      inc(m_vx,vid_menuX);
   end else
   begin
      g_keyboard;
      g_mouse;
   end;
end;
