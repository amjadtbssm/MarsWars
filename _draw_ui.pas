
procedure D_Alarms;
var i,r:byte;
begin
   for i:=0 to vid_uialrm_n do
    with ui_alrms[i] do
     if(t>0)then
     begin
        r:=(t*2) mod vid_uialrm_ti;
        if(b)
        then RectangleColor(_minimap,x-r,y-r,x+r,y+r, c_white)
        else CircleColor   (_minimap,x  ,y  ,r,c_white);
        dec(t,1);
     end;
end;

procedure D_Minimap;
begin
   rectangleColor(_minimap,vid_mmvx,vid_mmvy,vid_mmvx+map_mmvw,vid_mmvy+map_mmvh, c_white);

   D_Alarms;

   _draw_surf(spr_panel,1,1,_minimap);
   _draw_surf(_minimap,0,0,_bminimap);
end;

procedure D_BuildUI;
var spr:PTUSprite;
      u:PTUnit;
      i:byte;
     sy:integer;
begin
   with _players[HPlayer]do
    if(m_sbuild<=_uts)then
    begin
       sy:=cl2uid[race,true,m_sbuild];
       u:=@_ulst[sy];
       spr:=_unit_spr(u);
       circleColor(_screen,m_vx,m_vy,u^.r,m_sbuildc);

       case sy of
       UID_URadar : sy:=15;
       else sy:=0;
       end;

       SDL_SetAlpha(spr^.surf,SDL_SRCALPHA or SDL_RLEACCEL,128);
       _draw_surf(_screen,m_vx-spr^.hw,m_vy-spr^.hh-sy,spr^.surf);
       SDL_SetAlpha(spr^.surf,SDL_SRCALPHA or SDL_RLEACCEL,255);

       if(m_sbuild in [4,7])then circleColor(_screen,m_vx,m_vy,towers_sr[upgr[upgr_towers]>0],c_gray);
       if(m_sbuild=8)then
        case race of
        r_hell : circleColor(_screen,m_vx,m_vy,u^.sr,c_gray);
        end;

       for i:=0 to _uts do
        if(ui_bldrs_x[i]<>0)then circleColor(_screen,ui_bldrs_x[i]-vid_vx,ui_bldrs_y[i]-vid_vy,ui_bldrs_r[i],c_white);

       if(g_mode=gm_ct)then
        for i:=1 to MaxPlayers do
         with g_ct_pl[i] do circleColor(_screen,px-vid_vx,py-vid_vy,base_r,c_blue);

       rectangleColor(_screen,build_b-vid_vx,build_b-vid_vy,map_b1-vid_vx,map_b1-vid_vy,c_white);
    end;
end;

procedure D_ui;
var ui,ux,uy:integer;
begin
   with _players[HPlayer] do
   begin
      D_BuildUI;

      if(race=r_uac)and(u_s[true,8]>0)then rectangleColor(_screen,m_vx-blizz_w,m_vy-blizz_w,m_vx+blizz_w,m_vy+blizz_w,c_gray);

      D_Timer(148,2,g_step,ta_left,str_time);
      if(G_WTeam=255)then
       if(g_mode=gm_inv)then
       begin
          D_Timer(148,14,g_inv_t,ta_left,str_inv_time+b2s(g_inv_wn)+', '+str_time);
          _draw_text(_screen,148,26,str_inv_ml+' '+b2s(_players[0].army),ta_left,255,c_white);
       end;

      if(vid_rtui=2)then
      begin
         if(G_Paused=0)then D_minimap;
         _draw_surf(_uipanel,0,0,spr_panel);

         _draw_surf(_uipanel,0 ,160,spr_tabs[0]);
         _draw_surf(_uipanel,48,160,spr_tabs[1]);
         _draw_surf(_uipanel,96,160,spr_tabs[2]);

         ux:=1+(vid_bw*ui_tab);
         rectangleColor(_uipanel,ux,161,ux+44,189,c_lime);

         if(_rpls_rst< rpl_rhead)then boxColor(_uipanel,97,161,141,189,c_ablack);

         if(ui_upgrl>0)then
         begin
            _draw_text(_uipanel,50,162,i2s((ui_upgrl div vid_fps)+1),ta_left,255,c_white);
            _draw_text(_uipanel,94,162,b2s(ui_upgrc),ta_right,255,c_yellow);
         end;

         _draw_text(_uipanel,24 ,584,str_menu ,ta_middle,255,c_white);

         if(net_nstat>ns_none)and(G_WTeam=255)then
          if(g_paused>0)
          then _draw_text(_uipanel,120,584,str_pause,ta_middle,255,plcolor[g_paused])
          else _draw_text(_uipanel,120,584,str_pause,ta_middle,255,c_white);

         if(_rpls_rst< rpl_rhead)then
         begin
            _draw_text(_uipanel,28 ,148,i2s(menerg-cenerg),ta_middle,255,c_aqua);
            _draw_text(_uipanel,54 ,148,b2s(menerg),ta_middle,255,c_white);
         end;
         _draw_text(_uipanel,91 ,148,b2s(u_c[true ]),ta_left,255,c_green);
         _draw_text(_uipanel,116,148,b2s(u_c[false]),ta_left,255,c_white);

         if(ui_tab=0)then
         begin
            for ui:=0 to 8 do
            begin
               if(u_e[true,ui]=0)then
               begin
                  if(_bc_g(a_build,ui)=false)then continue;
                  if((G_addon=false)and(ui>6))then break;
               end;

               ux:=2+(ui mod 3)*vid_bw;
               uy:=194+(ui div 3)*vid_bw;
               _draw_surf(_uipanel,ux,uy,spr_b_b[race,ui]);
               if(m_sbuild=ui)then rectangleColor(_uipanel,ux,uy,ux+42,uy+42,c_lime);

               if(_bldCndt(HPlayer,ui))then boxColor(_uipanel,ux-2,uy-2,ux+44,uy+44,c_ablack);

               if(u_e[true,ui]>0)then _draw_text(_uipanel,ux+44,uy+36,b2s(u_e[true,ui]),ta_right,255,ui_muc[u_e[true,ui]>=_ulst[cl2uid[race,true,ui]].max]);
               if(u_s[true,ui]>0)then _draw_text(_uipanel,ux+44,uy   ,b2s(u_s[true,ui]),ta_right,255,c_lime);
               if(ui_blds[ ui]>0)then _draw_text(_uipanel,ux   ,uy   ,b2s(ui_blds [ui]),ta_left ,255,c_dyellow);
               if(bld_r>0)then characterColor(_uipanel,ux+20,uy+18,'#',c_red);

               case ui of
               5 : if(ubx[5]>0)then
                    if(_units[ubx[5]].rld>0)then
                     if(race=r_uac)
                     then _draw_text(_uipanel,ux,uy+36,i2s((_units[ubx[5]].rld div vid_fps)+1),ta_left,255,ui_rad_rld[_units[ubx[5]].rld>radar_time])
                     else _draw_text(_uipanel,ux,uy+36,i2s((_units[ubx[5]].rld div vid_fps)+1),ta_left,255,c_aqua);
               6 : if(ubx[6]>0)then
                    if(race=r_hell)then
                    begin
                       if(_units[ubx[6]].utrain>0)then
                        _draw_text(_uipanel,ux,uy+36,b2s(_units[ubx[6]].utrain),ta_left,255,c_red);
                    end
                    else
                    begin
                       if(_units[ubx[6]].rld>0)then
                        _draw_text(_uipanel,ux,uy+36,i2s((_units[ubx[6]].rld div vid_fps)+1),ta_left,255,c_white);
                    end;
               end;
            end;

            for ui:=0 to 11 do
            begin
               if(u_e[false,ui]=0)then
               begin
                  if(_bc_g(a_units,ui)=false)then continue;
                  if((G_addon=false)and(ui>ut2[race]))then break;
               end;

               ux:=2+(ui mod 3)*vid_bw;
               uy:=338+(ui div 3)*vid_bw;

               if(G_Addon)and(ui=4)and(race=r_hell)
               then _draw_surf(_uipanel,ux,uy,spr_h_u4k)
               else _draw_surf(_uipanel,ux,uy,spr_b_u[race,ui]);

               if(_untCndt(HPlayer,ui) or (wb=(u_e[true,1]-ui_blds[1])))then boxColor(_uipanel,ux-2,uy-2,ux+44,uy+44,c_ablack);

               if(u_e[false,ui]>0)then _draw_text(_uipanel,ux+44,uy+36,b2s(u_e[false,ui]),ta_right,255,ui_muc[u_e[false,ui]>=_ulst[cl2uid[race,false,ui]].max]);
               if(u_s[false,ui]>0)then _draw_text(_uipanel,ux+44,uy   ,b2s(u_s[false,ui]),ta_right,255,c_lime);
               if(ui_apc[ui]>0)then _draw_text(_uipanel,ux,uy+36,i2s(ui_apc[ui]),ta_left,255,c_purple);
               if(ui_trnt[ui]>0) then
               begin
                  _draw_text(_uipanel,ux,uy   ,i2s((ui_trnt[ui] div vid_fps)+1),ta_left,255,c_white);
                  _draw_text(_uipanel,ux,uy+10,b2s(ui_trntc[ui]),ta_left,255,c_dyellow);
               end;
            end;

            if(_rpls_rst<rpl_rhead)then
            begin
               _draw_surf(_uipanel,5  ,532,spr_b_action);
               _draw_surf(_uipanel,50 ,529,spr_b_delete);
               _draw_surf(_uipanel,99 ,531,spr_b_cancle);
            end;

            case race of
            r_hell :
                     begin
                        _draw_surf(_uipanel,50,578,spr_ZFormer[21].surf);
                        if(u_s[false,12]>0)then _draw_text(_uipanel,94,578,b2s(u_s[false,12]),ta_right,255,c_lime);
                        if(u_e[false,12]>0)then _draw_text(_uipanel,94,590,b2s(u_e[false,12]),ta_right,255,c_orange);
                        ux:=32000;
                        uy:=0;
                        for ui:=12 to 17 do
                        begin
                           if(ui_trnt[ui]>0)and(ui_trnt[ui]<ux)then ux:=ui_trnt[ui];
                           inc(uy,ui_trntc[ui]);
                        end;
                        if(ux<32000)then
                        begin
                           _draw_text(_uipanel,50,578,i2s((ux div vid_fps)+1),ta_left,255,c_white);
                           _draw_text(_uipanel,50,590,b2s(uy),ta_left,255,c_dyellow);
                        end;
                     end;
            r_uac  :
                     begin
                        _draw_surf(_uipanel,53,581,spr_mine.surf);
                        if(u_s[true,12]>0)then _draw_text(_uipanel,94,578,b2s(u_s[true,12]),ta_right,255,c_lime);
                        if(u_e[true,12]>0)then _draw_text(_uipanel,94,590,b2s(u_e[true,12]),ta_right,255,c_orange);
                     end;
            end;
         end;

         if(ui_tab=1)then
         begin
            for ui:=0 to MaxUpgrs do
            begin
               if(_bc_g(a_upgr,ui)=false)then continue;
               if((G_addon=false)and(ui>=upgr_2tier))then break;

               ux:=2+(ui mod 3)*vid_bw;
               uy:=194+(ui div 3)*vid_bw;
               _draw_surf(_uipanel,ux,uy,spr_b_up[race,ui]);

               if(ui_upgr[ui]>0)then
               begin
                  rectangleColor(_uipanel,ux,uy,ux+42,uy+42,c_lime);
                  _draw_text(_uipanel,ux,uy,i2s((ui_upgr[ui] div vid_fps)+1),ta_left,255,c_white);
               end
               else
                 if(ui_upgrc=(u_e[true,3]-ui_blds[3]))or(ubx[3]=0)or (upgr[ui]>=upgrade_cnt[race,ui])or((menerg-cenerg)<_pne_r[race,ui])or((ui>upgr_2tier)and((upgr[upgr_2tier]=0)or(ubx[6]=0)) )then
                 begin
                    boxColor(_uipanel,ux-2,uy-2,ux+44,uy+44,_sbtnc[(upgr[ui]<upgrade_cnt[race,ui])and(ubx[3]>0)]);
                 end;
               if(upgr[ui]>0)then
                if(upgrade_cnt[race,ui]=1)
                then characterColor(_uipanel,ux+36,uy,'+',c_lime)
                else _draw_text(_uipanel,ux+44,uy,b2s(upgr[ui]),ta_right,255,c_lime);
            end;
         end;

         if(ui_tab=2)then
         begin
            _draw_surf(_uipanel,2 ,194,spr_b_rfast);
            if(_fsttime)then rectangleColor(_uipanel,2,194,44,236,c_lime);

            _draw_surf(_uipanel,50,194,spr_b_rskip);

            _draw_surf(_uipanel,98,194,spr_b_rlog);
            if(_rpls_log)then rectangleColor(_uipanel,98,194,140,236,c_lime);

            _draw_surf(_uipanel,2 ,242,spr_b_rfog);
            if(_fog)then rectangleColor(_uipanel,2,242,44,284,c_lime);


            for ui:=0 to 4 do
            begin
               ux:=2+(ui mod 3)*vid_bw;
               uy:=290+(ui div 3)*vid_bw;

               if(ui=0)
               then _draw_text(_uipanel,ux+2,uy+2,'all',ta_left,255,c_white)
               else _draw_text(_uipanel,ux+2,uy+2,_players[ui].name,ta_left,5,plcolor[ui]);

               if(ui=HPlayer)then rectangleColor(_uipanel,ux,uy,ux+42,uy+42,c_lime);
            end;
         end;
      end;
   end;
   _draw_surf(_screen,0,0,_uipanel);
end;

procedure D_hints;
var i:byte;
begin
   if(m_bx<3)and(m_by>=3)and(m_by<=12)then
   begin
      case m_by of
      3  : if(m_vy>160)then _draw_text(_screen,146,vid_mh-30,str_hint_t[m_bx],ta_left,255,c_white);
      12 : begin
              if(m_bx=2)then
               if(net_nstat=ns_none)or(G_WTeam<255)then exit;
              _draw_text(_screen,146,vid_mh-30,str_hint_m[m_bx],ta_left,255,c_white);
           end;
      else
        i:=((m_by-4)*3)+(m_bx mod 3);
        with _players[HPlayer] do
        if(i<27)then
        begin
           case ui_tab of
           0 : case i of
               0 ..8  : if(_bc_g(a_build,i)=false)
                        then exit
                        else
                          if((G_addon=false)and(i>6))then exit;
               9 ..20 : if(_bc_g(a_units,i-9)=false)
                        then exit
                        else
                          if((G_addon=false)and((i-9)>ut2[race]))then exit;
               21..23 : if(_rpls_rst>=rpl_rhead)then exit;
               end;
           1 :begin
                 if(i<23)then
                 begin
                    if(_bc_g(a_upgr,i)=false)then exit;
                    if(g_addon=false)and(i>=upgr_2tier)then exit;
                 end;
                 if(_rpls_rst>=rpl_rhead)and(i=23)then exit;
              end;
           2 :;
           end;
           _draw_text(_screen,146,vid_mh-30,str_hint[ui_tab,race,i],ta_left,255,c_white);
        end;
      end;
   end;
end;

procedure D_UIText;
var i:byte;
begin
   if(_igchat)or(_rpls_log)then
   begin
      for i:=0 to MaxNetChat do _draw_text(_screen,148,vid_mh-60-13*i,net_chat[i],ta_left,255,c_white);
      if(_rpls_log=false)then _draw_text(_screen,148,vid_mh-50,':'+net_chat_str+chat_type[vid_rtui>6], ta_left,vid_ingamecl, c_white);
   end
   else
     if(net_chat_shlm>0)then
     begin
        _draw_text(_screen,148,vid_mh-60,net_chat[0],ta_left,255,c_white);
        dec(net_chat_shlm,1);
     end;

   D_hints;

   if(_rpls_rst=rpl_end)
   then _draw_text(_screen,472,2,str_repend,ta_middle,255,c_white)
   else
    if(_rpls_rst<rpl_rhead)then
     with _players[HPlayer] do
     begin
        if(G_WTeam=255)then
        begin
           if(menu_s2<>ms2_camp)then
            if(_players[HPlayer].army=0)then _draw_text(_screen,vid_uiuphx,2,str_lose  ,ta_middle,255,c_red);
           if(G_paused>0)then
            if(net_nstat=ns_clnt)and(net_cl_svttl=ClientTTL)
            then _draw_text(_screen,vid_uiuphx,12,str_waitsv,ta_middle,255,plcolor[net_cl_svpl])
            else _draw_text(_screen,vid_uiuphx,12,str_pause ,ta_middle,255,plcolor[G_paused]);
        end
        else
          begin
             if(G_WTeam=team)
             then _draw_text(_screen,vid_uiuphx,2,str_win   ,ta_middle,255,c_lime)
             else _draw_text(_screen,vid_uiuphx,2,str_lose  ,ta_middle,255,c_red);
             exit;
          end;
     end;
end;



