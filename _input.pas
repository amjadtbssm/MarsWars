
procedure escape_key;
begin
   if(_igchat)then
   begin
      _igchat:=false;
      net_chat_str:='';
   end
   else ToggleMenu;
end;

procedure return_key;
begin
   if(_menu=false)and(not _igchat)and(net_nstat<>ns_none)
   then _igchat:=true
   else
    if(_m_sel=100)or(_igchat)then
    begin
       if(length(net_chat_str)>0)then
        if(net_nstat=ns_clnt)
        then net_chatm
        else net_chat_add(chr(HPlayer)+net_chat_str);
       net_chat_str:='';
       _igchat:=false;
    end;
end;

procedure TogglePause;
begin
   if(net_nstat=ns_clnt)
   then net_pause
   else
     if(net_nstat=ns_srvr)then
       if(G_paused=0)
       then G_paused:=HPlayer
       else G_paused:=0;
end;

procedure _player_s_o(ox0,oy0,ox1,oy1:integer;oid,pl:byte);
var su,i:integer;
  cmsnd:boolean;
begin
   if(G_Paused=0)and(_rpls_rst<rpl_rhead)then
   begin
      if(net_nstat=ns_clnt)then
      begin
         net_clearbuffer;
         net_writebyte(nmid_order);
         net_writeint(ox0);
         net_writeint(oy0);
         net_writeint(ox1);
         net_writeint(oy1);
         net_writebyte(oid);
         net_send(net_cl_svip,net_cl_svport);
      end
      else
        with _players[pl] do
        begin
           o_x0:=ox0;
           o_y0:=oy0;
           o_x1:=ox1;
           o_y1:=oy1;
           o_id:=oid;
        end;

      with _players[HPlayer] do
      begin
         su:=0;
         cmsnd:=false;
         for i:=0 to _uts do inc(su,u_s[false,i]);
         if(su>0)then cmsnd:=true;
         if(upgr[upgr_mainm]>0)then inc(su,u_s[true,0]);
         inc(su,u_s[true,1]+u_s[true,5]+u_s[true,4]+u_s[true,7]);
         if(race=r_uac )then
         begin
            if(upgr[upgr_blizz]>0)then inc(su,u_s[true,8]);
            inc(su,u_s[true,6]);
            inc(su,u_s[true,0]);
         end;
         if(race=r_hell)then
         begin
            if(upgr[upgr_6bld]>0)then inc(su,u_s[true,6]);
            if(upgr[upgr_b478tel]>0)then
            begin
               inc(su,u_s[true,2]);
               inc(su,u_s[true,8]);
            end;
         end;
         for i:=_uts downto 0 do if(u_s[false,i]>0)then break;
      end;

      if(oid=uo_move)and(su>0)then
      begin
         if(cmsnd)then _unit_comssnd(i,_players[HPlayer].race);
         if(oy1>0)then
         begin
            ui_umark_u:=oy1;
            ui_umark_t:=vid_hfps;
            if(ox1>0)then
            begin
               if(_players[_units[oy1].player].team<>_players[HPlayer].team)
               then _click_eff(ox0,oy0,vid_hhfps,c_red)
               else _click_eff(ox0,oy0,vid_hhfps,c_aqua);
            end
            else
            begin
               if(_players[_units[oy1].player].team<>_players[HPlayer].team)
               then _click_eff(ox0,oy0,vid_hhfps,c_orange)
               else _click_eff(ox0,oy0,vid_hhfps,c_blue);
            end;
         end
         else
          if(ox1>0)
          then _click_eff(ox0,oy0,vid_hhfps,c_yellow)
          else _click_eff(ox0,oy0,vid_hhfps,c_lime);
      end;
   end;
end;

procedure _hotkeys(k:integer);
var ko:cardinal;
begin
   if(k=sdlk_pause)
   then TogglePause
   else
     if(G_Paused=0)then
      case k of
      sdlk_tab: begin
                   inc(ui_tab,1);
                   ui_tab:=ui_tab mod 3;
                   if(_rpls_rst< rpl_rhead)and(ui_tab=2)then ui_tab:=0;
                end;
      sdlk_F1 : ui_tab:=0;
      sdlk_F2 : ui_tab:=1;
      sdlk_F3 : if(_rpls_rst>=rpl_rhead)then ui_tab:=2;
       1:begin end;
      else
        if(_testmode)and(net_nstat=0)then
         case k of
            sdlk_end       : _fsttime:=not _fsttime;
            sdlk_home      : _warpten:=not _warpten;
            sdlk_pageup    : if(net_nstat<>ns_clnt) then with _players[HPlayer] do if(state=PS_Play)then state:=PS_Comp else state:=PS_Play;
            sdlk_pagedown  : with _players[HPlayer] do if(upgr[upgr_invuln]=0)then upgr[upgr_invuln]:=1 else upgr[upgr_invuln]:=0;
            sdlk_backspace : _fog:=not _fog;
            SDLK_F5         : begin HPlayer:=0;exit end;
            SDLK_F6         : begin HPlayer:=1;exit end;
            SDLK_F7         : begin HPlayer:=2;exit end;
            SDLK_F8         : begin HPlayer:=3;exit end;
            SDLK_F9         : begin HPlayer:=4;exit end;
            sdlk_insert    : _draw:= not _draw;
         end;

        case k of
          sdlk_0..sdlk_9 :  begin
                               ko:=_event^.key.keysym.sym-sdlk_0;
                               if (k_ctrl>1)
                               then _player_s_o(ko,0,0,0,uo_setorder,HPlayer)
                               else
                                 if(k_dbl>300)and(ordx[ko]>0)
                                 then _moveHumView(ordx[ko] , ordy[ko])
                                 else _player_s_o(ko,k_shift,0,0,uo_selorder,HPlayer);
                            end;
          sdlk_delete    :  _player_s_o(k_ctrl,0,0,0,uo_delete,HPlayer);
          sdlk_space     :  _player_s_o(k_ctrl,0,0,0,uo_action,HPlayer);
        else
          if(k_ctrl>1)and(k=sdlk_A)then
          begin
             _player_s_o(0,0,0,0,uo_specsel ,HPlayer);
             exit;
          end;

          case ui_tab of
          0 : case k of
            sdlk_Q      : m_sbuild:=0;
            sdlk_W      : m_sbuild:=1;
            sdlk_E      : m_sbuild:=2;
            sdlk_A      : m_sbuild:=3;
            sdlk_S      : m_sbuild:=4;
            sdlk_D      : m_sbuild:=5;
            sdlk_Z      : m_sbuild:=6;
            sdlk_X      : m_sbuild:=7;
            sdlk_C      : m_sbuild:=8;
            sdlk_R      : _player_s_o(-4,0 ,0,0, uo_action  ,HPlayer);
            sdlk_T      : _player_s_o(-4,1 ,0,0, uo_action  ,HPlayer);
            sdlk_Y      : _player_s_o(-4,2 ,0,0, uo_action  ,HPlayer);
            sdlk_F      : _player_s_o(-4,3 ,0,0, uo_action  ,HPlayer);
            sdlk_G      : _player_s_o(-4,4 ,0,0, uo_action  ,HPlayer);
            sdlk_H      : _player_s_o(-4,5 ,0,0, uo_action  ,HPlayer);
            sdlk_V      : _player_s_o(-4,6 ,0,0, uo_action  ,HPlayer);
            sdlk_B      : _player_s_o(-4,7 ,0,0, uo_action  ,HPlayer);
            sdlk_N      : _player_s_o(-4,8 ,0,0, uo_action  ,HPlayer);
            sdlk_U      : _player_s_o(-4,9 ,0,0, uo_action  ,HPlayer);
            sdlk_I      : _player_s_o(-4,10,0,0, uo_action  ,HPlayer);
            sdlk_O      : _player_s_o(-4,11,0,0, uo_action  ,HPlayer);
            sdlk_M      : _player_s_o(-4,12,0,0, uo_action  ,HPlayer);
              end;
          1 : case k of
            sdlk_Q      : _player_s_o(-2,0 ,0,0, uo_action  ,HPlayer);
            sdlk_W      : _player_s_o(-2,1 ,0,0, uo_action  ,HPlayer);
            sdlk_E      : _player_s_o(-2,2 ,0,0, uo_action  ,HPlayer);
            sdlk_A      : _player_s_o(-2,3 ,0,0, uo_action  ,HPlayer);
            sdlk_S      : _player_s_o(-2,4 ,0,0, uo_action  ,HPlayer);
            sdlk_D      : _player_s_o(-2,5 ,0,0, uo_action  ,HPlayer);
            sdlk_Z      : _player_s_o(-2,6 ,0,0, uo_action  ,HPlayer);
            sdlk_X      : _player_s_o(-2,7 ,0,0, uo_action  ,HPlayer);
            sdlk_C      : _player_s_o(-2,8 ,0,0, uo_action  ,HPlayer);
            sdlk_R      : _player_s_o(-2,9 ,0,0, uo_action  ,HPlayer);
            sdlk_T      : _player_s_o(-2,10,0,0, uo_action  ,HPlayer);
            sdlk_Y      : _player_s_o(-2,11,0,0, uo_action  ,HPlayer);
            sdlk_F      : _player_s_o(-2,12,0,0, uo_action  ,HPlayer);
            sdlk_G      : _player_s_o(-2,13,0,0, uo_action  ,HPlayer);
            sdlk_H      : _player_s_o(-2,14,0,0, uo_action  ,HPlayer);
            sdlk_V      : _player_s_o(-2,15,0,0, uo_action  ,HPlayer);
            sdlk_B      : _player_s_o(-2,16,0,0, uo_action  ,HPlayer);
            sdlk_N      : _player_s_o(-2,17,0,0, uo_action  ,HPlayer);
            sdlk_U      : _player_s_o(-2,18,0,0, uo_action  ,HPlayer);
            sdlk_I      : _player_s_o(-2,19,0,0, uo_action  ,HPlayer);
            sdlk_O      : _player_s_o(-2,20,0,0, uo_action  ,HPlayer);
            sdlk_J      : _player_s_o(-2,21,0,0, uo_action  ,HPlayer);
            sdlk_K      : _player_s_o(-2,22,0,0, uo_action  ,HPlayer);
            sdlk_M      : _player_s_o(-4,12,0,0, uo_action  ,HPlayer);
            end;
          2 : case k of
            sdlk_Q      : _fsttime:=not _fsttime;
            sdlk_W      : if(k_ctrl=0)
                          then _rpls_step:=vid_hfps*2
                          else _rpls_step:=vid_hfps*10;
            sdlk_E      : _rpls_log:=not _rpls_log;
            sdlk_A      : _fog:=not _fog;
            sdlk_Z      : HPlayer:=0;
            sdlk_X      : HPlayer:=1;
            sdlk_C      : HPlayer:=2;
            sdlk_R      : HPlayer:=3;
            sdlk_T      : HPlayer:=4;
              end;
          end;
        end;
      end;
   k_dbl:=500;
end;

procedure _keyp(i:pcardinal);
begin
   if (i^>1)and(i^<30000) then inc(i^,k_msst); //
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
   if(k_dbl>k_msst)
   then dec(k_dbl,k_msst)
   else k_dbl:=0;

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

                                                      if(_m_sel=30)then _scrollV(@_cmp_sm,1,0,MaxMissions-vid_camp_m);
                                                      if(_m_sel=40)then _scrollV(@_svld_sm,1,0,_svld_ln-vid_svld_m-1);
                                                      if(_m_sel=45)then _scrollV(@_rpls_sm,1,0,_rpls_ln-vid_rpls_m-1);
                                                   end;
                            SDL_BUTTON_WHEELUP   : if(_menu)then
                                                   begin
                                                      vid_mredraw:=true;

                                                      if(_m_sel=30)then _scrollV(@_cmp_sm,-1,0,MaxMissions-vid_camp_m);
                                                      if(_m_sel=40)then _scrollV(@_svld_sm,-1,0,_svld_ln-vid_svld_m-1);
                                                      if(_m_sel=45)then _scrollV(@_rpls_sm,-1,0,_rpls_ln-vid_rpls_m-1);
                                                   end;
                              else
                              end;
                           end;
      SDL_QUITEV         : begin _CYCLE:=false; end;
      SDL_KEYUP          : begin
                              k_chrt:=1;
                              case (_event^.key.keysym.sym) of
                                sdlk_up    : k_u    :=1;
                                sdlk_down  : k_d    :=1;
                                sdlk_left  : k_l    :=1;
                                sdlk_right : k_r    :=1;
                                sdlk_rshift: k_shift:=1;
                                sdlk_lshift: k_shift:=1;
                                sdlk_lctrl : k_ctrl :=1;
                                sdlk_rctrl : k_ctrl :=1;
                                sdlk_lalt  : k_alt  :=1;
                                sdlk_ralt  : k_alt  :=1;
                              else
                              end;
                           end;
      SDL_KEYDOWN        : begin
                              k_chrt:=2;
                              k_chr :=Widechar(_event^.key.keysym.unicode);

                              case (_event^.key.keysym.sym) of
                                sdlk_up     : if (k_u    =0) then k_u    :=2;
                                sdlk_down   : if (k_d    =0) then k_d    :=2;
                                sdlk_left   : if (k_l    =0) then k_l    :=2;
                                sdlk_right  : if (k_r    =0) then k_r    :=2;
                                sdlk_rshift : if (k_shift=0) then k_shift:=2;
                                sdlk_lshift : if (k_shift=0) then k_shift:=2;
                                sdlk_rctrl  : if (k_ctrl =0) then k_ctrl :=2;
                                sdlk_lctrl  : if (k_ctrl =0) then k_ctrl :=2;
                                sdlk_ralt   : if (k_alt  =0) then k_alt  :=2;
                                sdlk_lalt   : if (k_alt  =0) then k_alt  :=2;
                                SDLK_PRINT  : _screenshot;
                                sdlk_escape : escape_key;
                                sdlk_return : return_key;
                              else
                                if(_menu=false)and(G_Started)and(_igchat=false)then _hotkeys(_event^.key.keysym.sym);
                              end;
                           end;
    else
    end;
end;

function _whoInPoint(tx,ty:integer):integer;
var i,sc:integer;
begin
   sc:=0;
   with _players[HPlayer]do
    for i:=0 to _uts do
    begin
       inc(sc,u_s[false,i]);
       inc(sc,u_s[true ,i]);
    end;
   _whoInPoint:=0;
   if(_nhp(tx,ty,0))then
    for i:=1 to MaxUnits do
     with _units[i] do
      if(hits>0)and(inapc=0)then
       if(_fog_ch(fx,fy,r))then
        if(dist2(vx,vy,tx,ty)<r)then
        begin
           if(player<>HPlayer)then
           begin
              if(buff[ub_invis]>0)and(buff[ub_vis]=0)then continue;
           end
           else
             if(sc=1)and(sel=true)then continue;
           _whoInPoint:=i;
           break;
       end;
end;

procedure _chkbld;
begin
   if(m_sbuild<=_uts) then
    with _players[HPlayer] do
    begin
       if(m_sbuild=5)and(u_e[true,5]>0)then
       begin
          _player_s_o(1,k_shift,0,0,uo_specsel ,HPlayer);
          m_sbuild:=255;
       end
       else
        if(m_sbuild=6)and(u_e[true,6]>0)and(race=r_hell)and(upgr[upgr_6bld]>0)then
        begin
           _player_s_o(3,k_shift,0,0,uo_specsel ,HPlayer);
           m_sbuild:=255;
        end
        else
         if(m_sbuild=8)and(u_e[true,8]>0)and(race=r_uac)then
         begin
            _player_s_o(2,k_shift,0,0,uo_specsel ,HPlayer);
            m_sbuild:=255;
         end
         else
           if _bldCndt(HPlayer,m_sbuild)
           then m_sbuild:=255
           else if not((build_b<m_mx)and(m_mx<map_b1)and(build_b<m_my)and(m_my<map_b1))
                then m_sbuildc:=c_blue
                else case _unit_grbcol(m_mx,m_my,_ulst[cl2uid[race,true,m_sbuild]].r,HPlayer,true) of
                     1 : m_sbuildc:=c_red;
                     2 : m_sbuildc:=c_blue;
                     else
                         m_sbuildc:=c_lime;
                     end;
    end;
end;

procedure g_mouse;
var u:integer;
begin
   m_mx :=m_vx+vid_vx;
   m_my :=m_vy+vid_vy;
   m_bx :=m_vx div vid_BW;
   m_by :=m_vy div vid_BW;

   if(m_ldblclk>=k_msst)
   then dec(m_ldblclk,k_msst)
   else m_ldblclk:=0;

   _chkbld;

   if(k_ml=2)then                    // left button
   begin
      if(vid_panel<=m_vx)then        // map
      begin
         if(m_sbuild=255)then
         begin
            m_sxs:=m_mx;
            m_sys:=m_my;
         end
         else
           if(m_sbuildc=c_lime)then
           begin
              _player_s_o(m_mx,m_my,m_sbuild,0, uo_build  ,HPlayer);
              m_sbuild:=255;
           end;
      end
      else
        if(vid_panel>=m_vy)then    // minimap
        begin
        end
        else                         // panel
        begin
           PlaySNDM(snd_click);
           if(m_by=12)then           // buttons
            case m_bx of
             0 : ToggleMenu;
             1 : if(ui_tab<2)and(_rpls_rst<rpl_rhead)and(G_Paused=0)then _player_s_o(-4,12,0,0, uo_action  ,HPlayer);
             2 : if(net_nstat>ns_none)then TogglePause;
            else
            end
           else
            if(m_by=3)then //tabs
            begin
               if(_rpls_rst>=rpl_rhead)
               then ui_tab:=m_bx
               else
                 if(m_bx<2)then ui_tab:=m_bx;
            end
            else
               with _players[HPlayer] do
                case ui_tab of
                0 :  if(G_Paused=0)then
                     begin
                       if(3<m_by)and(m_by<7)then     //builds
                       begin
                          m_sbuild:=((m_by-4)*3)+(m_bx mod 3);
                          _chkbld;
                       end;
                       if(6<m_by)and(m_by<12)then
                       begin
                          u:=((m_by-7)*3)+(m_bx mod 3);
                          if(u<12)then _player_s_o(-4,u,0,0, uo_action  ,HPlayer);
                       end;
                       if(m_by=11)then
                       begin
                          if(m_bx=0)then _player_s_o(1,0,0,0, uo_action  ,HPlayer);
                          if(m_bx=1)then _player_s_o(0,0,0,0, uo_delete  ,HPlayer);
                          if(m_bx=2)then _player_s_o(0,0,0,0, uo_action  ,HPlayer);
                       end;
                    end;

                1 : if(G_Paused=0)then
                    begin
                       if(3<m_by)and(m_by<12)then
                       begin
                          u:=((m_by-4)*3)+(m_bx mod 3);
                          if(u<=_uts)then _player_s_o(-2,u,0,0, uo_action  ,HPlayer);
                       end;
                    end;
                2 : if(_rpls_rst>=rpl_runit)then
                    begin
                        if(m_by=4)then
                        begin
                           if(m_bx=0)then _fsttime:=not _fsttime;
                           if(m_bx=1)then _rpls_step:=vid_hfps*2;
                           if(m_bx=2)then _rpls_log:=not _rpls_log;
                        end;
                        if(m_by=5)and(m_bx=0)then _fog:=not _fog;
                        if(m_by=6)then
                        begin
                           if(m_bx=0)then HPlayer:=0;
                           if(m_bx=1)then HPlayer:=1;
                           if(m_bx=2)then HPlayer:=2;
                        end;
                       if(m_by=7)then
                       begin
                          if(m_bx=0)then HPlayer:=3;
                          if(m_bx=1)then HPlayer:=4;
                       end;
                    end;
                 end;
        end;
   end;

   if(k_ml=1)and(m_sxs>-1)then //select
   begin
      if(m_ldblclk>0)
      then
        if(k_shift<2)
        then _player_s_o(vid_vx+vid_panel,vid_vy, vid_vx+vid_mw,vid_vy+vid_mh, uo_dblselect  ,HPlayer)
        else _player_s_o(vid_vx+vid_panel,vid_vy, vid_vx+vid_mw,vid_vy+vid_mh, uo_adblselect ,HPlayer)
      else
        if(k_shift<2)
        then _player_s_o(m_sxs,m_sys,m_mx,m_my,uo_select ,HPlayer)
        else _player_s_o(m_sxs,m_sys,m_mx,m_my,uo_aselect,HPlayer);

      m_sxs:=-1;
      m_ldblclk:=dblclkt;
   end;

   if(k_ml>2)and(m_sxs=-1)and(G_Paused=0)then
    if(vid_panel>=m_vx)and(vid_panel>=m_vy)then
    begin
       vid_vx:=trunc(m_vx/map_mmcx)-((vid_mw+vid_panel) shr 1);
       vid_vy:=trunc(m_vy/map_mmcx)-( vid_mh            shr 1);
       _view_bounds;
    end;

   if(k_mr=2)then  // right button
   begin
      if(m_sbuild<255)
      then m_sbuild:=255
      else
       if(vid_panel<m_vx) then   // map
       begin
          _player_s_o(m_mx,m_my,byte((k_ctrl>0)=m_a_inv),_whoInPoint(m_mx,m_my),uo_move,HPlayer);
       end
       else
         if (vid_panel>m_vy) then  // mini-map
         begin
            _player_s_o(trunc(m_vx/map_mmcx), trunc(m_vy/map_mmcx),byte((k_ctrl>0)=m_a_inv),0,uo_move,HPlayer);
         end
         else
         begin// panel
            PlaySNDM(snd_click);
            with _players[HPlayer] do
            case ui_tab of
            0 : if(G_Paused=0)then
                begin
                   if(ubx[6]>0)then
                    with _units[ubx[6]] do if(m_by=6)and(m_bx=0)then _player_s_o(x,y,byte((k_ctrl>0)=m_a_inv),ubx[6],uo_move,HPlayer);
                   if(race=r_hell)then
                    if(ubx[5]>0)then
                     with _units[ubx[5]] do if(m_by=5)and(m_bx=2)then _player_s_o(x,y,byte((k_ctrl>0)=m_a_inv),ubx[5],uo_move,HPlayer);
                   if(6<m_by)and(m_by<12)then
                   begin
                      u:=((m_by-7)*3)+(m_bx mod 3);
                      if(u<12)then _player_s_o(-5,u,0,0, uo_action  ,HPlayer);
                   end;
                end;
            1 : if(G_Paused=0)then
                begin
                   if(3<m_by)and(m_by<12)then
                   begin
                      u:=((m_by-4)*3)+(m_bx mod 3);
                      if(u<=_uts)then _player_s_o(-3,u,0,0, uo_action  ,HPlayer);
                   end;
                end;
            2 : if(_rpls_rst>=rpl_runit)then
                begin
                   if(m_by=4)and(m_bx=1)then _rpls_step:=vid_hfps*10;
                end;
            end;
         end;
   end;
end;

procedure _move_v_m;
begin
   if(m_vx<vid_vmb_x0)then dec(vid_vx,vid_vmspd);
   if(m_vy<vid_vmb_y0)then dec(vid_vy,vid_vmspd);
   if(m_vx>vid_vmb_x1)then inc(vid_vx,vid_vmspd);
   if(m_vy>vid_vmb_y1)then inc(vid_vy,vid_vmspd);
end;

procedure _view_move;
var vx,vy:integer;
begin
   vx:=vid_vx;
   vy:=vid_vy;

   if(vid_vmm)then _move_v_m;

   if (k_u>1) then dec(vid_vy,vid_vmspd);
   if (k_l>1) then dec(vid_vx,vid_vmspd);
   if (k_d>1) then inc(vid_vy,vid_vmspd);
   if (k_r>1) then inc(vid_vx,vid_vmspd);

   if(vx<>vid_vx)or(vy<>vid_vy)then _view_bounds;
end;

procedure g_keyboard;
begin
   if(fps_cs>=fps_ns)then
    if(G_Paused=0)and(m_vmove=false) then _view_move;
   if(_igchat)then net_chat_str:=menu_sf(net_chat_str,k_kbstr,ChatLen2);
end;

procedure InputGame;
begin
   if(_ded)then
   begin
      if(fps_cs<fps_ns)then exit;

      if(k_chrt>0)then dec(k_chrt,1);

      while (SDL_PollEvent( _event )>0) do
       CASE (_event^.type_) OF
       SDL_QUITEV         : begin _CYCLE:=false; end;
       {SDL_KEYDOWN        : if(k_chrt=0)then
                            begin
                               case (_event^.key.keysym.sym) of
                               SDLK_Space : begin Map_randommap;Map_premap; end;
                               end;

                               k_chrt:=vid_fps;
                            end; }
       end;
   end
   else
   begin
      WindowEvents;

      if(_menu)
      then g_menu
      else
      begin
         g_keyboard;
         g_mouse;
      end;
   end;
end;


