

procedure _draw_minimap;
var i:byte;
begin
   rectangleColor(vid_minimap,vid_mmvx,vid_mmvy,vid_mmvx+map_mmvw,vid_mmvy+map_mmvh, c_white);

   if(ui_alarm>0)then
   begin
      if(ui_isb)
      then RectangleColor(vid_minimap, ui_ax-7,ui_ay-7,ui_ax+7,ui_ay+7, ui_cl)
      else CircleColor(vid_minimap,ui_ax,ui_ay,ui_alarm mod 20,ui_cl);
   end;

   if(g_mode=gm_ct)then
    for i:=1 to MaxPlayers do
     with g_pt[i] do
      CircleColor(vid_minimap,mx,my,mmap_pr,p_colors[p]);

   if(G_Paused=0)then _draw_surf(spr_panel,1,1,vid_minimap);
   SDL_FillRect(vid_minimap,nil,0);
end;

procedure _draw_timer(x,y:integer;time:cardinal;ta:byte;str:string);
var m,s,h:cardinal;
begin
   s:=time div vid_fps;
   m:=s div 60;
   s:=s mod 60;
   h:=m div 60;
   m:=m mod 60;
   if(h=0)
   then _draw_text(vid_spanel,x,y,str+c2s(m)+':'+c2s(s),ta,255,c_white)
   else _draw_text(vid_spanel,x,y,str+c2s(h)+':'+c2s(m)+':'+c2s(s),ta,255,c_white);
end;

function _sbtnc(b:boolean):cardinal;
begin
   if(b)
   then _sbtnc:=c_agray
   else _sbtnc:=c_ablack;
end;

procedure _draw_ui;
var ui,ux,uy:integer;
begin
   with _players[PlayerHuman] do
   begin
      if(m_sbuild<255)and(u0>0)then
      begin
         circleColor(vid_screen,m_vx,m_vy,b_r[m_sbuild],m_sbuildc);
         if(m_sbuild=4)then circleColor(vid_screen,m_vx,m_vy,def_r,c_gray);
         circleColor(vid_screen,_units[u0].x-vid_vx,_units[u0].y-vid_vy,base_r,c_white);
         rectangleColor(vid_screen,build_b-vid_vx,build_b-vid_vy,map_b1-vid_vx,map_b1-vid_vy,c_white);
      end;

    if vid_mmredraw then
    begin
      _draw_minimap;
      _draw_surf(vid_spanel,0,0, spr_panel);
      _draw_timer(4,162,g_step,ta_left,str_time);

      if(g_mode=gm_inv)and(g_inv_w<=inv_wvs)then
      begin
         if(g_inv_w<inv_wvs)then
         begin
            _draw_timer(150,172,g_inv_t,ta_right,'');
            _draw_text(vid_spanel,4,172,str_wave+b2s(g_inv_w+1),ta_left,255,c_white);
         end;
         _draw_text(vid_spanel,4,182,str_monsters+b2s(_players[0].army),ta_left,255,c_white);
      end;

      _draw_text(vid_spanel,24 ,584,str_menu ,ta_middle,255,c_white);

      if(net_sv_up or net_cl_con)then
       if(g_paused>0)
       then _draw_text(vid_spanel,120,584,str_pause,ta_middle,255,p_colors[g_paused])
       else _draw_text(vid_spanel,120,584,str_pause,ta_middle,255,c_white);

      if(_rpls_rst>=rpl_rhead)then
      begin
         _draw_surf(vid_spanel,2 ,194,spr_b_rfast);
         if(_fsttime)then rectangleColor(vid_spanel,2,194,44,236,c_lime);

         _draw_surf(vid_spanel,50,194,spr_b_rskip);

         for ui:=0 to 4 do
         begin
            ux:=2;
            uy:=242+ui*48;

            if(ui=0)
            then _draw_text(vid_spanel,ux,uy,'all',ta_left,255,c_white)
            else _draw_text(vid_spanel,ux,uy,'player'+#13+b2s(ui),ta_left,255,P_colors[ui]);

            if(ui=playerhuman)then rectangleColor(vid_spanel,ux,uy,ux+42,uy+42,c_lime);
         end;


         exit;
      end;

       if(_testmode=true)then
       begin
          characterColor(vid_spanel,92,182,'T',c_white);
          if(_fog=false)then characterColor(vid_spanel,100,182,'F',c_white);
          if(_invuln=true)then characterColor(vid_spanel,108,182,'I',c_white);
          if(_warpten=true)then characterColor(vid_spanel,124,182,'W',c_white);
          if(_fsttime=true)then characterColor(vid_spanel,132,182,'S',c_white);
          if(state=PS_Comp)then characterColor(vid_spanel,140,182,'A',c_white);
       end;

      _draw_text(vid_spanel,112,148,b2s(army  ),ta_middle,255,c_white);
      _draw_text(vid_spanel,54 ,148,b2s(menerg),ta_middle,255,c_aqua);
      _draw_text(vid_spanel,28 ,148,b2s(cenerg),ta_middle,255,c_white);

      for ui:=0 to 5 do
      begin
         ux:=2+(ui mod 3)*vid_bw;
         uy:=194+(ui div 3)*vid_bw;
         _draw_surf(vid_spanel,ux,uy,spr_b_b[race,ui]);
         if(m_sbuild=ui)then rectangleColor(vid_spanel,ux,uy,ux+42,uy+42,c_lime);
         if(bld_r>0)or(u0=0)or(army>=MaxPlayerUnits)or(not(ui in alw_b))or(menerg<=cenerg)or(eu[true,ui]>=b_m[ui])then boxColor(vid_spanel,ux-2,uy-2,ux+44,uy+44,_sbtnc((ui in alw_b)and(eu[true,ui]<b_m[ui])));
         if(eu[true,ui]>0)then
           if(eu[true,ui]>=b_m[ui])
           then _draw_text(vid_spanel,ux+52,uy+36,b2s(eu[true,ui]),ta_right,255,c_gray)
           else _draw_text(vid_spanel,ux+52,uy+36,b2s(eu[true,ui]),ta_right,255,c_dorange);
         if(su[true,ui]>0)then _draw_text(vid_spanel,ux+52,uy,b2s(su[true,ui]),ta_right,255,c_lime);
         if(bld_r>0)then characterColor(vid_spanel,ux+20,uy+18,'#',c_red);
      end;
      if(u5>0)and(_units[u5].rld>0)then
       if(race=r_uac)
       then _draw_text(vid_spanel,ux,uy+36,i2s((_units[u5].rld div vid_fps)+1),ta_left,255,rad_rld_ic[_units[u5].rld>radar_time])
       else characterColor(vid_spanel,ux,uy+36,'!',c_aqua);

      for ui:=0 to 7 do
      begin
         if(ui=7)and(race=r_hell)then break;
         ux:=2+(ui mod 3)*vid_bw;
         uy:=290+(ui div 3)*vid_bw;
         _draw_surf(vid_spanel,ux,uy,spr_b_u[race,ui]);
         if(ui_ur[ui]=0)then //eu[true,ut_1]
          if(u1=0)or((ui>4)and(hcmp))or(not(ui in alw_u))or(eu[false,ui]>=u_m[race,ui])or(menerg<=cenerg)or(wb>=eu[true,ut_1])or((army+wb)>=MaxPlayerUnits)then  boxColor(vid_spanel,ux-2,uy-2,ux+44,uy+44,_sbtnc((u1=0)or(ui in alw_u)and(eu[false,ui]<u_m[race,ui])));
         if(ui_ur[ui]>0) then
         begin
            _draw_text(vid_spanel,ux,uy,i2s((ui_ur[ui] div vid_fps)+1),ta_left,255,c_white);
            _draw_text(vid_spanel,ux,uy+10,b2s(ui_urc[ui]),ta_left,255,c_dyellow);
         end;
         if(ui_apc[ui]>0)then
         begin
            _draw_text(vid_spanel,ux,uy+36,i2s(ui_apc[ui]),ta_left,255,c_purple);
         end;
         if(eu[false,ui]>0)then
          if(eu[false,ui]>=u_m[race,ui])
          then _draw_text(vid_spanel,ux+52,uy+36,b2s(eu[false,ui]),ta_right,255,c_gray)
          else _draw_text(vid_spanel,ux+52,uy+36,b2s(eu[false,ui]),ta_right,255,c_dorange);
         if(su[false,ui]>0)then _draw_text(vid_spanel,ux+52,uy,b2s(su[false,ui]),ta_right,255,c_lime);
      end;
      _draw_surf(vid_spanel,98,386,spr_cancle);

      for ui:=0 to 7 do
      begin
         ux:=2+(ui mod 3)*vid_bw;
         uy:=434+(ui div 3)*vid_bw;
         _draw_surf(vid_spanel,ux,uy,spr_b_up[race,ui]);
        with _units[u3] do
          if(rld>0)and(utrain=ui)and(u3>0)and(hits>0)then
          begin
             rectangleColor(vid_spanel,ux,uy,ux+42,uy+42,c_lime);
             _draw_text(vid_spanel,ux,uy,i2s((rld div vid_fps)+1),ta_left,255,c_white);
          end else
            if (rld>0)or(u3=0)or(upgr[ui]>0)or(cenerg>=menerg)or(not (ui in alw_up)) then
            begin
               boxColor(vid_spanel,ux-2,uy-2,ux+44,uy+44,_sbtnc((ui in alw_up)and(upgr[ui]=0)));
               if(upgr[ui]>0)then characterColor(vid_spanel,ux,uy,'+',c_lime);
            end;
      end;
      if(race=r_uac)then
      begin
         if(eu[true,6]>0)then _draw_text(vid_spanel,54,566,b2s(eu[true,6]),ta_right,255,c_dorange);
         if(su[true,6]>0)then _draw_text(vid_spanel,54,530,b2s(su[true,6]),ta_right,255,c_lime);
      end;
      if(race=r_hell)then
      begin
         if(eu[false,7]>0)then _draw_text(vid_spanel,102,566,b2s(eu[false,7]),ta_right,255,c_dorange);
         if(su[false,7]>0)then _draw_text(vid_spanel,102,530,b2s(su[false,7]),ta_right,255,c_lime);
         if(hptm>0)then _draw_text(vid_spanel,54,530,b2s((hptm div vid_fps)+1),ta_right,255,c_yellow);
      end;


      _draw_surf(vid_spanel,98,530,spr_cancle);

    end;

   end;
end;











