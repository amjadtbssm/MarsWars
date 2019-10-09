

function _plst(p:integer):char;
begin
   with _players[p] do
   begin
      _plst:=str_ps_c[state];
      if(state=ps_play)then
      begin
         if(g_started=false)
         then _plst:=b2pm[ready]
         else _plst:=str_ps_c[ps_play];
         if(ttl>=ClientTTL)then _plst:=str_ps_t;
         if(net_cl_svpl=p)then
         begin
            _plst:=str_ps_sv;
            if(net_cl_svttl>=ClientTTL)then _plst:=str_ps_t;
         end;
      end;
      if(p=PlayerHuman)then _plst:=str_ps_h;
   end;
end;

function mic(enbl,sel:boolean):cardinal;
begin
   mic:=c_white;
   if(enbl=false)then mic:=c_gray
   else if(sel) then mic:=c_yellow;
end;

procedure Draw_M_set;
var t,i:integer;
begin
   _draw_text(vid_menu, 128, 332, str_settings, ta_middle, 255,mic(true,_mmode2=mm_sett));
   _draw_text(vid_menu, 230, 332, str_saveload, ta_middle, 255,mic(not (net_cl_con or net_sv_up or (not onlySVCode)),_mmode2=mm_svld));
   _draw_text(vid_menu, 332, 332, str_replays , ta_middle, 255,mic(not (net_cl_con or net_sv_up),_mmode2=mm_rpls));


   if(_mmode2=mm_sett)then
   begin
      //  SOUND
      _draw_text(vid_menu, 88, 357, str_sound, ta_left,255, c_white);

      _draw_text(vid_menu, 92, 379, str_soundvol, ta_left,255, mic(snd_svolume>0,false));
      boxColor(vid_menu,142,378,142+trunc(mmsndvlmx*snd_svolume),386,c_lime);

      _draw_text(vid_menu, 239, 379, str_musicvol, ta_left,255, mic(snd_mvolume>0,false));
      boxColor(vid_menu,289,378,289+trunc(mmsndvlmx*snd_mvolume),386,c_lime);

      // GAME
      _draw_text(vid_menu, 88, 403, str_game, ta_left,255, c_white);

      _draw_text(vid_menu,143, 425, str_maction, ta_middle,255,c_white);
      if(_ma_inv)
      then _draw_text(vid_menu,202, 425, str_maction2[_ma_inv], ta_left,255,c_lime)
      else _draw_text(vid_menu,202, 425, str_maction2[_ma_inv], ta_left,255,c_yellow);

      _draw_text(vid_menu, 143, 449, str_scrollspd, ta_middle,255, mic(true,false));
      boxColor(vid_menu,198,448,198+vid_vms,456,c_lime);

      _draw_text(vid_menu, 94 , 473, str_mousescrl+b2pm[vid_vmm], ta_left,255, mic(true,false));
      _draw_text(vid_menu, 232, 473, str_fullscreen+b2pm[not _fscr], ta_left,255, mic(true,false));

      _draw_text(vid_menu, 143 , 497, str_plname, ta_middle,255, mic(not (net_cl_con or net_sv_up or G_Started),_m_sel=15));
      _draw_text(vid_menu, 202 , 497, PlayerName, ta_left,255, mic(not (net_cl_con or net_sv_up or G_Started),_m_sel=15));

      _draw_text(vid_menu, 345 , 497, str_lng[_lng], ta_middle,255, c_white);
   end;

   if(_mmode2=mm_svld)then
   begin
      _draw_surf(vid_menu,72,344,spr_m_sl);

      _draw_text(vid_menu,126, 512, str_save  , ta_middle,255, mic(G_Started and (_svld_str<>''),false));
      _draw_text(vid_menu,228, 512, str_load  , ta_middle,255, mic((_svld_sm<_svld_lsts) ,false));
      _draw_text(vid_menu,332, 512, str_delete, ta_middle,255, mic((_svld_sm<_svld_lsts) ,false));

      for t:=0 to SVLDINSCR do
      begin
         i:=t+_svld_srl;
         if(i<_svld_lsts)then _draw_text(vid_menu,80,352+t*14,b2s(i+1)+'.'+_svld_lst[i],ta_left,255,mic(true,i=_svld_sm));
      end;

      _draw_text(vid_menu,234, 352,_svld_stat  ,ta_left,18,c_white);

      vlineColor(vid_menu,231,348,504,c_white);

      hlineColor(vid_menu,76,231,492,c_white);
      _draw_text(vid_menu,80,494,_svld_str,ta_left,255,mic(true,_m_sel=41) );
   end;

   if(_mmode2=mm_rpls)then
   begin
      _draw_surf(vid_menu,72,344,spr_m_sl);

      _draw_text(vid_menu,228, 512, str_play  , ta_middle,255, mic(not G_Started and (_rpls_sm<_rpls_lsts),false));
      _draw_text(vid_menu,332, 512, str_delete, ta_middle,255, mic(not G_Started and (_rpls_sm<_rpls_lsts) ,false));

      for t:=0 to RPLSINSCR do
      begin
         i:=t+_rpls_srl;
         if(i<_rpls_lsts)then _draw_text(vid_menu,80,352+t*14,b2s(i+1)+'.'+_rpls_lst[i],ta_left,255,mic(true,i=_rpls_sm));
      end;

      _draw_text(vid_menu,234, 352,_rpls_stat  ,ta_left,18,c_white);

      vlineColor(vid_menu,231,348,504,c_white);
   end;
end;

procedure Draw_M_CMC;
var t:byte;
begin
   if(chat_nrlm=true)then rectangleColor(vid_menu,624, 302,723,317,c_yellow);

   _draw_text(vid_menu, 470, 306, str_campaigns   , ta_middle,255, mic(not(net_sv_up or net_cl_con or G_Started),_mmode=mm_camp));
   _draw_text(vid_menu, 572, 306, str_scirmish    , ta_middle,255, mic(not(G_Started and(_mmode<>mm_mult))or net_sv_up or net_cl_con,_mmode=mm_mult));
   _draw_text(vid_menu, 674, 306, str_chat        , ta_middle,255, mic((net_sv_up or net_cl_con),_mmode=mm_chat));

   if(_mmode=mm_chat)then
   begin
      boxColor(vid_menu,418,320,723,523,c_black);
      lineColor(vid_menu,418,510,723,510,c_white);

      for t:=0 to net_lg_cs do _draw_ctext(vid_menu,421,497-13*t,net_lg_c[t]);

      _draw_text(vid_menu, 421, 514, chat_m , ta_left,255, c_white);//p_colors[PlayerHuman]
   end;

   if(_mmode=mm_mult)then
   begin
      _draw_text(vid_menu,437, 333, str_gmodet+' '+str_gmode[g_mode], ta_left,255, mic(not(G_Started or net_cl_con),false));

      _draw_text(vid_menu,430, 357, str_server, ta_left,255, mic(true,net_sv_up));

      _draw_text(vid_menu,438, 379, str_udpport+net_sv_pstr,ta_left, 255,mic(not (net_sv_up or G_Started),_m_sel=20));
      _draw_text(vid_menu,493, 403, str_svup[net_sv_up], ta_middle,255, mic(not (net_cl_con or G_Started),false));

      _draw_text(vid_menu,580, 357, str_replay, ta_left,255, c_white);//mic(not G_Started,false)
      _draw_text(vid_menu,612, 379, str_rpl[_rpls_rst], ta_middle,255, mic( _rpls_rst<rpl_rhead ,_rpls_rst>0)); //str_yn[_rpls_rst>0]
      _draw_text(vid_menu,655, 379, str_pnu+b2s(_rpls_pnu), ta_left,255, mic( _rpls_rst=rpl_none ,false));
      _draw_text(vid_menu,587, 403, _rpls_lrname, ta_left,255, mic( _rpls_rst=rpl_none ,_m_sel=82));

      _draw_text(vid_menu,430, 428, str_client, ta_left,255, mic(true,net_cl_con));
      _draw_text(vid_menu,490, 428, net_m_error, ta_left,255,c_red);

      _draw_text(vid_menu,436, 449, str_ipaddr+net_cl_svstr, ta_left,255, mic(not (net_cl_con or G_Started),_m_sel=22));
      _draw_text(vid_menu,438, 473, str_team+b2s(PlayerTeam), ta_left,255, mic(not (net_sv_up or G_Started),false) );
      _draw_text(vid_menu,514, 473, str_srace+str_race[PlayerRace], ta_left,255, mic(not (net_sv_up or G_Started),false));
      _draw_text(vid_menu,625, 473, str_ready+b2pm[PlayerReady], ta_left,255, mic(not (net_sv_up or G_Started),false));
      _draw_text(vid_menu,478, 497, str_connect[net_cl_con], ta_middle,255, mic((not net_sv_up)and((net_cl_con=true)or(G_Started=false)),false));

      _draw_text(vid_menu,542, 497, str_upd+b2s(PlayerNUR-1), ta_left,255, c_white);

      _draw_text(vid_menu,655, 497, str_pnu+b2s(PlayerNUnits), ta_left,255, mic(true,_m_sel = 27));
   end;

   if(_mmode=mm_camp)then
   begin
      boxColor(vid_menu,418,320,723,523,c_black);

      for t:=1 to MINSCR do
      begin
         //t+_mcmp_srl
         _draw_text(vid_menu,424,313+t*14,str_cmp_mn[t+_mcmp_srl],ta_left,255,mic(not g_started,(t+_mcmp_srl)=_mcmp_sm));
      end;
   end;
end;

procedure Draw_M_PLS;
var y,p:integer;
    c:cardinal;
begin
   if(_mmode<>mm_camp)then
   begin
      _draw_text(vid_menu, 571, 98, str_players, ta_middle,255, c_white);

      for p:=1 to MaxPlayers do
       with _players[p] do
       begin
          y:=136+(p-1)*34;

          c:=c_white;
          if G_started or net_cl_con then c:=c_gray;

          characterColor(vid_menu,544,y,_plst(p),c);
          if(state<>ps_none)then
          begin
             _draw_text(vid_menu,437, y, name, ta_left, 255,c_white);
             if G_Started or net_cl_con or ((not net_cl_con) and(state=ps_play)and(p<>PlayerHuman)) then c:=c_gray;
             _draw_text(vid_menu,606, y,str_race[race], ta_middle,255, c);
             if(g_mode in [gm_2fort,gm_inv])then c:=c_gray;
             _draw_text(vid_menu,664, y,b2s(team), ta_middle,255, c);
             if(army=0)and(G_Started)then lineColor(vid_menu,435,y+4,532,y+4,c_gray);
          end else
           if(g_mode in [gm_2fort,gm_inv])then
           begin
              _draw_text(vid_menu,437, y, str_ps_comp+' 5', ta_left, 255,c_gray);
              _draw_text(vid_menu,606, y,str_race[r_random], ta_middle,255, c_gray);
              _draw_text(vid_menu,664, y,b2s(team), ta_middle,255, c_gray);
           end;
          boxColor(vid_menu,698,y,705,y+6,p_colors[p]);
       end;
   end else
   begin
      _draw_text(vid_menu, 571, 98, str_objectives, ta_middle,255, c_white);
      boxColor(vid_menu,418,112,723,263,c_black);

      _draw_text(vid_menu, 571, 119,str_cmp_mn[_mcmp_sm],ta_middle,255,c_white);
      _draw_text(vid_menu, 424, 155,str_cmp_ob[_mcmp_sm],ta_left,255,c_white);
   end;
end;

procedure Draw_M_MAP;
var c:boolean;
begin
   _draw_text(vid_menu, 229, 98, str_map, ta_middle,255, c_white);

   if not(_mmode=mm_camp)then
   begin
      c:=not (net_cl_con or G_Started);

      _draw_text(vid_menu, 308,132, c2s(map_seed), ta_middle,255, mic(c,_m_sel=50));
      _draw_text(vid_menu, 252, 158, str_m_pos+str_m_posC[map_pos], ta_left,255, mic(c,false));
      _draw_text(vid_menu, 252, 183, str_m_siz+i2s(map_mw), ta_left,255, mic(c,false));
      _draw_text(vid_menu, 252, 208, str_m_liq+b2pm[map_liq], ta_left,255, mic(c,false));
      _draw_text(vid_menu, 252, 233, str_m_obs+b2s(map_obs), ta_left,255, mic(c,false));
      _draw_text(vid_menu, 308, 258, str_random, ta_middle,255, mic(c,false));
   end else
   begin
      _draw_surf(vid_menu, 91,129, cmp_loc[_mcmp_sm]);

      _draw_text(vid_menu, 252,132,str_cmp_map[_mcmp_sm], ta_left,255, c_white);
   end;
end;

procedure drwAut(x,y:integer);
begin
   boxColor(vid_menu,x-206,y,x+205,y+42,c_black);
   rectangleColor(vid_menu,x-206,y,x+205,y+42,c_yellow);
   _draw_text(vid_menu, x, y+5, str_autors , ta_middle,51, c_white);
end;

procedure DrawMenu;
begin
   if(vid_mredraw)then
   begin
      _draw_surf(vid_menu,0,0,spr_m_back);

      _draw_text(vid_menu,   0, 592, str_v   , ta_left,255, c_white);
      _draw_text(vid_menu, 400, 590, str_cprt , ta_middle,255, c_white);
      //+' '+c2ip(net_sv_outa)+':'+w2s(net_sv_outp)+'/'+w2s(swap(net_sv_outp))+'   '+c2ip(net_ms_ip)+':'+w2s(swap(net_ms_port))

      _draw_text(vid_menu, 70, 554, str_exit[G_Started] , ta_middle,255, c_white);
      _draw_text(vid_menu,730, 554, str_reset[G_Started], ta_middle,255, mic((not net_cl_con)and (G_Started or _plsReady),false));

      Draw_M_set;
      Draw_M_CMC;
      Draw_M_PLS;
      Draw_M_MAP;
   end;

   if((m_vy>585)and(240<m_vx)and(560>m_vx))or((m_vy<65)and(m_vx>175)and(m_vx<625))then drwAut(400,540);

   if(vid_menuX>0)then sdl_fillrect(vid_screen,nil,1);

   _draw_surf(vid_screen,vid_menuX,0,vid_menu);
end;



