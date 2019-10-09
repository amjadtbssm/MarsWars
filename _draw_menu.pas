

function mic(enbl,sel:boolean):cardinal;
begin
   mic:=c_white;
   if(enbl=false)then mic:=c_gray
   else
     if(sel)then mic:=c_yellow;
end;

procedure D_MMap;
var c:boolean;
begin
   _draw_text(_menu_surf,mv_x+ 229,mv_y+ 96, str_MMap, ta_middle,255, c_white);

   if(menu_s2<>ms2_camp)then
   begin
      c:=not((net_nstat=ns_clnt) or G_Started);

      _draw_text(_menu_surf,mv_x+ 308,mv_y+ 133, w2s(map_seed)                 , ta_middle,255, mic(c,_m_sel=50));

      _draw_text(_menu_surf,mv_x+ 252,mv_y+ 158, str_m_siz+i2s(map_mw)         , ta_left  ,255, mic(c,false));
      _draw_text(_menu_surf,mv_x+ 252,mv_y+ 183, str_m_liq+str_m_liqC[map_liq] , ta_left  ,255, mic(c,false));
      _draw_text(_menu_surf,mv_x+ 252,mv_y+ 208, str_m_obs+b2s(map_obs)        , ta_left  ,255, mic(c,false));
      _draw_text(_menu_surf,mv_x+ 308,mv_y+ 258, str_mrandom                   , ta_middle,255, mic(c,false));
      //_draw_text(_menu_surf,mv_x+ 252,mv_y+ 233, str_m_pos+str_m_posC[map_pos] , ta_left  ,255, mic(c,false));
   end
   else
   begin
      _draw_surf(_menu_surf,mv_x+ 91 ,mv_y+129,cmp_mmap[_cmp_sel]);
      _draw_text(_menu_surf,mv_x+ 252,mv_y+132,str_camp_m[_cmp_sel], ta_left,255, c_white);
   end;
end;

procedure D_MPlayers;
var y,p:integer;
      c:cardinal;
begin
   if(menu_s2<>ms2_camp)then
   begin
      _draw_text(_menu_surf,mv_x+ 571, mv_y+96, str_MPlayers, ta_middle,255, c_white);

      for p:=1 to MaxPlayers do
       with _players[p] do
       begin
          y:=mv_y+136+(p-1)*22;

          c:=c_white;
          if G_started or (net_nstat=ns_clnt)then c:=c_gray;

          characterColor(_menu_surf,mv_x+544,y,_plst(p),c);
          if(state<>ps_none)then
          begin
             _draw_text(_menu_surf,mv_x+437, y, name, ta_left, 255,c_white);
             if G_Started or (net_nstat=ns_clnt) or ((net_nstat<ns_clnt)and(state=ps_play)and(p<>HPlayer)) then c:=c_gray;
             _draw_text(_menu_surf,mv_x+606, y,str_race[race], ta_middle,255, c);
             if(g_mode in [gm_2fort,gm_inv,gm_coop])then c:=c_gray;
             case g_mode of
             gm_2fort : if(p<3)
                        then _draw_text(_menu_surf,mv_x+664, y,'1', ta_middle,255, c_gray)
                        else _draw_text(_menu_surf,mv_x+664, y,'2', ta_middle,255, c_gray);
             gm_coop,
             gm_inv   : _draw_text(_menu_surf,mv_x+664, y,'1', ta_middle,255, c_gray);
             else
               _draw_text(_menu_surf,mv_x+664, y,b2s(team), ta_middle,255, c);
             end;
             if(army=0)and(G_Started)then lineColor(_menu_surf,mv_x+435,y+4,mv_x+532,y+4,c_gray);
          end
          else
            if(g_mode in [gm_2fort,gm_inv,gm_coop])then
            begin
               _draw_text(_menu_surf,mv_x+437, y,str_ps_comp+' 4', ta_left, 255,c_gray);
               _draw_text(_menu_surf,mv_x+606, y,str_race[r_random], ta_middle,255, c_gray);
               case g_mode of
               gm_2fort : if(p<3)
                          then _draw_text(_menu_surf,mv_x+664, y,'1', ta_middle,255, c_gray)
                          else _draw_text(_menu_surf,mv_x+664, y,'2', ta_middle,255, c_gray);
               gm_coop,
               gm_inv   : _draw_text(_menu_surf,mv_x+664, y,'1', ta_middle,255, c_gray);
               end;
            end;
          boxColor(_menu_surf,mv_x+698,y,mv_x+705,y+6,plcolor[p]);
       end;
   end
   else
   begin
      _draw_text(_menu_surf,mv_x+571,mv_y+ 96, str_MObjectives, ta_middle,255, c_white);
      boxColor(_menu_surf,mv_x+418,mv_y+110,mv_x+723,mv_y+231,c_black);

      _draw_text(_menu_surf,mv_x+ 571,mv_y+ 119,str_camp_t[_cmp_sel],ta_middle,255,c_white);
      _draw_text(_menu_surf,mv_x+ 424,mv_y+ 155,str_camp_o[_cmp_sel],ta_left  ,255,c_white);
   end;
end;

procedure D_M1;
var t,i,y:integer;
begin
   _draw_text(_menu_surf,mv_x+ 128,mv_y+ 330, str_menu_s1[ms1_sett], ta_middle, 255,mic(true,menu_s1=ms1_sett));
   _draw_text(_menu_surf,mv_x+ 230,mv_y+ 330, str_menu_s1[ms1_svld], ta_middle, 255,mic((net_nstat=ns_none)and(onlySVcode),menu_s1=ms1_svld));
   _draw_text(_menu_surf,mv_x+ 332,mv_y+ 330, str_menu_s1[ms1_reps], ta_middle, 255,mic(net_nstat=ns_none,menu_s1=ms1_reps));

   case menu_s1 of
   ms1_sett : begin
                 // SOUND
                 _draw_text(_menu_surf,mv_x+ 88,mv_y+ 355, str_sound, ta_left,255, c_white);

                 _draw_text(_menu_surf,mv_x+ 92 ,mv_y+ 377, str_soundvol, ta_left,255, mic(snd_svolume>0,false));
                 boxColor(_menu_surf,mv_x+142,mv_y+376,mv_x+142+integer(trunc(mmsndvlmx*snd_svolume)),mv_y+384,c_lime);

                 _draw_text(_menu_surf,mv_x+ 239,mv_y+ 377, str_musicvol, ta_left,255, mic(snd_mvolume>0,false));
                 boxColor(_menu_surf,mv_x+289,mv_y+376,mv_x+289+integer(trunc(mmsndvlmx*snd_mvolume)),mv_y+384,c_lime);

                 // GAME
                 _draw_text(_menu_surf,mv_x+ 88,mv_y+ 401, str_game, ta_left,255, c_white);

                 _draw_text(_menu_surf,mv_x+207,mv_y+ 401, i2s(m_vrx)+'x'+i2s(m_vry), ta_middle,255,mic(true,(m_vrx=vid_mw)and(m_vry=vid_mh)));
                 _draw_text(_menu_surf,mv_x+315,mv_y+ 401, str_apply, ta_middle,255,mic((m_vrx<>vid_mw)or(m_vry<>vid_mh),_m_sel=190));

                 _draw_text(_menu_surf,mv_x+143,mv_y+ 425, str_maction, ta_middle,255,c_white);
                 _draw_text(_menu_surf,mv_x+202,mv_y+ 425, str_maction2[m_a_inv], ta_left,255,c_white);

                 _draw_text(_menu_surf,mv_x+ 143,mv_y+ 449, str_scrollspd, ta_middle,255, mic(true,false));
                 boxColor(_menu_surf,mv_x+198,mv_y+448,mv_x+198+vid_vmspd,mv_y+456,c_lime);

                 _draw_text(_menu_surf,mv_x+ 94 ,mv_y+ 473, str_mousescrl+b2pm[vid_vmm], ta_left,255, mic(true,false));
                 _draw_text(_menu_surf,mv_x+ 232,mv_y+ 473, str_fullscreen+b2pm[not _fscr], ta_left,255, mic(true,false));

                 _draw_text(_menu_surf,mv_x+ 143 ,mv_y+ 497, str_plname, ta_middle,255, mic((net_nstat=ns_none)and(G_Started=false),_m_sel=15));
                 _draw_text(_menu_surf,mv_x+ 202 ,mv_y+ 497, PlayerName, ta_left  ,255, mic((net_nstat=ns_none)and(G_Started=false),_m_sel=15));

                 _draw_text(_menu_surf,mv_x+ 345 ,mv_y+ 497, str_lng[_lng], ta_middle,255, c_white);
              end;
   ms1_svld : begin
                 _draw_surf(_menu_surf,mv_x+72,mv_y+344,spr_msl);

                 _draw_text(_menu_surf,mv_x+126,mv_y+ 512, str_save  , ta_middle,255, mic(G_Started and (_svld_str<>''),false));
                 _draw_text(_menu_surf,mv_x+228,mv_y+ 512, str_load  , ta_middle,255, mic((_svld_ls<_svld_ln) ,false));
                 _draw_text(_menu_surf,mv_x+332,mv_y+ 512, str_delete, ta_middle,255, mic((_svld_ls<_svld_ln) ,false));

                 for t:=0 to vid_svld_m do
                 begin
                    i:=t+_svld_sm;
                    if(i<_svld_ln)then
                    begin
                       y:=mv_y+352+t*14;
                       _draw_text(_menu_surf,mv_x+79,y+2,b2s(i+1)+'.'+_svld_l[i],ta_left,255,mic(true,i=_svld_ls));
                       if(i=_svld_ls)then
                       begin
                          hlineColor(_menu_surf,mv_x+76,mv_x+221,y-1,c_gray);
                          hlineColor(_menu_surf,mv_x+76,mv_x+221,y+13,c_gray);
                       end;
                    end;
                 end;

                 _draw_text(_menu_surf,mv_x+224, mv_y+352,_svld_stat  ,ta_left,19,c_white);

                 vlineColor(_menu_surf,mv_x+221,mv_y+348,mv_y+504,c_white);

                 hlineColor(_menu_surf,mv_x+76,mv_x+221,mv_y+492,c_white);
                 _draw_text(_menu_surf,mv_x+79,mv_y+494,_svld_str,ta_left,255,mic(true,_m_sel=41) );

              end;
   ms1_reps : begin
                 _draw_surf(_menu_surf,mv_x+72,mv_y+344,spr_msl);

                 _draw_text(_menu_surf,mv_x+126, mv_y+512, str_play  , ta_middle,255, mic((_rpls_ls<_rpls_ln)and(G_Started=false),false));
                 _draw_text(_menu_surf,mv_x+332, mv_y+512, str_delete, ta_middle,255, mic((_rpls_ls<_rpls_ln)and(G_Started=false),false));

                 for t:=0 to vid_rpls_m do
                 begin
                    i:=t+_rpls_sm;
                    if(i<_rpls_ln)then
                    begin
                       y:=mv_y+352+t*14;
                       _draw_text(_menu_surf,mv_x+79,y+2,b2s(i+1)+'.'+_rpls_l[i],ta_left,255,mic((G_Started=false),i=_rpls_ls));
                       if(i=_rpls_ls)then
                       begin
                          hlineColor(_menu_surf,mv_x+76,mv_x+221,y-1,c_gray);
                          hlineColor(_menu_surf,mv_x+76,mv_x+221,y+13,c_gray);
                       end;
                    end;
                 end;

                 _draw_text(_menu_surf,mv_x+224, mv_y+352,_rpls_stat  ,ta_left,19,c_white);

                 vlineColor(_menu_surf,mv_x+221,mv_y+348,mv_y+504,c_white);
              end;
   end;
end;

procedure D_M2;
var t,i,y:integer;
begin                                                                                                                 //)or (net_nstat>ns_none)
   _draw_text(_menu_surf,mv_x+ 470,mv_y+ 272, str_menu_s2[ms2_camp], ta_middle,255, mic((net_nstat=ns_none)and(G_Started=false),menu_s2=ms2_camp));
   _draw_text(_menu_surf,mv_x+ 572,mv_y+ 272, str_menu_s2[ms2_scir], ta_middle,255, mic(not(G_Started and(menu_s2=ms2_camp)),menu_s2=ms2_scir));
   _draw_text(_menu_surf,mv_x+ 674,mv_y+ 272, str_menu_s2[ms2_mult], ta_middle,255, mic(not(G_Started and(menu_s2=ms2_camp)),menu_s2=ms2_mult));

   case menu_s2 of
   ms2_camp : begin
                 boxColor(_menu_surf,mv_x+418,mv_y+286,mv_x+723,mv_y+523,c_black);

                 _draw_text(_menu_surf,mv_x+424,mv_y+290,str_cmpdif+str_cmpd[cmp_skill],ta_left,255,mic(not g_started,31=_cmp_sel));

                 for t:=1 to vid_camp_m do
                 begin
                    i:=t+_cmp_sm-1;
                    y:=mv_y+287+t*14;
                    if(i=_cmp_sel)then
                    begin
                       hlineColor(_menu_surf,mv_x+418,mv_x+723,y-1,c_gray);
                       hlineColor(_menu_surf,mv_x+418,mv_x+723,y+13,c_gray);
                    end;
                    _draw_text(_menu_surf,mv_x+424,y+3,str_camp_t[i],ta_left,255,mic(not g_started,i=_cmp_sel));
                 end;

                 hlineColor(_menu_surf,mv_x+418,mv_x+723,mv_y+300,c_white);
              end;
   ms2_scir : begin
                 _draw_text(_menu_surf,mv_x+430, mv_y+297, str_goptions, ta_left,255, c_white);

                 _draw_text(_menu_surf,mv_x+425, mv_y+321, str_gaddon        , ta_left  ,255, mic((G_Started=false)and(net_nstat<>ns_clnt),false));
                 _draw_text(_menu_surf,mv_x+716, mv_y+321, str_addon[g_addon], ta_right ,255, c_white);

                 _draw_text(_menu_surf,mv_x+425, mv_y+340, str_gmodet        , ta_left  ,255, mic((G_Started=false)and(net_nstat<>ns_clnt),false));
                 _draw_text(_menu_surf,mv_x+716, mv_y+340, str_gmode[g_mode] , ta_right ,255, c_white);

                 _draw_text(_menu_surf,mv_x+425, mv_y+359, str_loss          , ta_left  ,255, mic((G_Started=false)and(net_nstat<>ns_clnt),false));
                 _draw_text(_menu_surf,mv_x+716, mv_y+359, str_losst[g_loss] , ta_right ,255 ,c_white);

                 _draw_text(_menu_surf,mv_x+425, mv_y+378, str_starta        , ta_left  ,255, mic((G_Started=false)and(net_nstat<>ns_clnt),false));
                 _draw_text(_menu_surf,mv_x+716, mv_y+378, str_startat[g_starta], ta_right ,255,c_white);

                 _draw_text(_menu_surf,mv_x+425, mv_y+397, str_onebase       , ta_left  ,255, mic((G_Started=false)and(net_nstat<>ns_clnt),false));
                 _draw_text(_menu_surf,mv_x+716, mv_y+397, b2pm[g_onebase]   , ta_right ,255 ,c_white);

                 _draw_text(_menu_surf,mv_x+570, mv_y+416, str_randoms       , ta_middle,255, mic((G_Started=false)and(net_nstat=0),false));

                 //_draw_text(_menu_surf,434, 318, +' '+, ta_left  ,255, mic((G_Started=false)and(net_nstat<>ns_clnt),false));

                 _draw_text(_menu_surf,mv_x+430, mv_y+449, str_replay, ta_left,255, c_white);
                 _draw_text(_menu_surf,mv_x+461, mv_y+473, str_rpl[_rpls_rst], ta_middle,255, mic( _rpls_rst<rpl_rhead ,_rpls_rst>0));
                 _draw_text(_menu_surf,mv_x+510, mv_y+473, _rpls_lrname, ta_left,255, mic( _rpls_rst=rpl_none ,_m_sel=82));
                 _draw_text(_menu_surf,mv_x+436, mv_y+497, str_pnu+str_pnua[_rpls_pnui], ta_left,255, mic( _rpls_rst=rpl_none ,false));
              end;
   ms2_mult : begin
                 _draw_surf(_menu_surf,mv_x+418, mv_y+286,spr_MBackmlt);

                 _draw_text(_menu_surf,mv_x+570, mv_y+512, str_chat, ta_middle,255, mic((net_nstat<>ns_none),m_chat));

                 if(m_chat)then
                 begin
                    boxColor (_menu_surf,mv_x+418,mv_y+286,mv_x+723,mv_y+504,c_black);
                    lineColor(_menu_surf,mv_x+418,mv_y+491,mv_x+723,mv_y+491,c_white);

                    for t:=0 to MaxNetChat do _draw_text(_menu_surf,mv_x+419,mv_y+480-10*t,net_chat[t],ta_left,255,c_white);

                    _draw_text(_menu_surf, mv_x+419, mv_y+494, net_chat_str , ta_left,255, c_white);
                 end
                 else
                 begin
                    _draw_text(_menu_surf,mv_x+430, mv_y+297, str_server, ta_left,255, c_white);
                    _draw_text(_menu_surf,mv_x+575, mv_y+ 321, str_udpport+net_sv_pstr         , ta_left  ,255 ,mic((net_nstat=ns_none),_m_sel=20));
                    _draw_text(_menu_surf,mv_x+494, mv_y+ 321, str_svup[net_nstat=ns_srvr]     , ta_middle,255, mic((net_nstat<>ns_clnt)and(G_Started=false),false));

                    _draw_text(_menu_surf,mv_x+430, mv_y+345, str_client, ta_left,255, c_white);
                    _draw_text(_menu_surf,mv_x+709, mv_y+345, net_m_error, ta_right,255,c_red);

                    _draw_text(_menu_surf,mv_x+480, mv_y+370, str_connect[net_nstat=ns_clnt]  , ta_middle,255, mic((net_nstat<>ns_srvr)and((net_nstat=ns_clnt)or(G_Started=false)),false));
                    _draw_text(_menu_surf,mv_x+534, mv_y+370, net_cl_svstr                    , ta_left  ,255, mic((net_nstat=ns_none),_m_sel=22));
                    _draw_text(_menu_surf,mv_x+436, mv_y+394, str_npnu+str_npnua[net_pnui]    , ta_left  ,255, mic((net_nstat<>ns_srvr),false));

                    _draw_text(_menu_surf,mv_x+438, mv_y+418, str_team+b2s(PlayerTeam)        , ta_left  ,255, mic((net_nstat<>ns_srvr)and(G_Started=false),false));
                    _draw_text(_menu_surf,mv_x+514, mv_y+418, str_srace+str_race[PlayerRace]  , ta_left  ,255, mic((net_nstat<>ns_srvr)and(G_Started=false),false));
                    _draw_text(_menu_surf,mv_x+627, mv_y+418, str_ready+b2pm[PlayerReady]     , ta_left  ,255, mic((net_nstat<>ns_srvr)and(G_Started=false),false));
                 end;
              end;
   end;
end;

procedure D_Menu;
begin
   if(vid_mredraw)then
   begin
      _draw_surf(_menu_surf,mv_x,mv_y,spr_mback);
      _draw_text(_menu_surf,mv_x+800,mv_y+600-font_w,str_ver,ta_right,255,c_white);

      _draw_text(_menu_surf,mv_x+400,mv_y+600-font_w, str_cprt , ta_middle,255, c_white);

      _draw_text(_menu_surf,mv_x+ 70,mv_y+554, str_exit [G_Started], ta_middle,255, c_white);
      _draw_text(_menu_surf,mv_x+730,mv_y+554, str_reset[G_Started], ta_middle,255, mic((net_nstat<>ns_clnt)and (G_Started or _plsReady),false));

      D_MMap;
      D_MPlayers;
      D_M1;
      D_M2;

      vid_mredraw:=false;
   end;

   _draw_surf(_screen,0,0,_menu_surf);
end;


