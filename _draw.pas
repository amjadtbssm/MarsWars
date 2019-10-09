{
x,y,depth,shadow z, rectangle color, amask color, spr, alpha, bar cx,
}

procedure _sl_add(ax,ay,ad,ash:integer;arc,amsk:cardinal;arct:boolean;aspr:pSDL_surface;ainv:byte;abar:single;aclu:integer;acrl,acll:byte;acru:string6;aro:integer);
begin
   if(vid_vsls<vid_mvs)and(G_Paused=0)and(_menu=false)then
   begin
      inc(vid_vsls,1);
      with vid_vsl[vid_vsls] do
      begin
         x   := ax-vid_vx;
         y   := ay-vid_vy;
         d   := ad;
         sh  := ash;
         s   := aspr;
         rc  := arc;
         msk := amsk;
         inv := ainv;
         bar := abar;
         clu := aclu;
         cru := acru;
         crl := acrl;
         cll := acll;
         rct := arct;
         ro  := aro;
      end;
   end;
end;

procedure _sv_sort;
var i,u:word;
    dt:TVisSpr;
begin
   if(vid_vsls>1)then
    for i:=1 to vid_vsls do
     for u:=1 to (vid_vsls-1) do
      if (vid_vsl[u].d<vid_vsl[u+1].d) then
      begin
        dt:=vid_vsl[u];
        vid_vsl[u]:=vid_vsl[u+1];
        vid_vsl[u+1]:=dt;
      end;
end;

procedure D_SpriteList;
var sx,sy:integer;
begin
   _sv_sort;
   if(G_Paused>0)
   then vid_vsls:=vid_vslsp
   else vid_vslsp:=vid_vsls;
   while(vid_vsls>0)do
    with vid_vsl[vid_vsls] do
    begin
       if(sh>0)then
       begin
          sx:=(s^.w shr 1);
          sy:=s^.h-(s^.h shr 3);
          filledellipseColor(_screen,x+sx,y+sy+sh,sx,s^.h shr 2,c_ablack);
       end;
       SDL_SetAlpha(s,SDL_SRCALPHA or SDL_RLEACCEL,inv);

       if(inv>0)then _draw_surf(_screen,x,y,s);

       if(msk>0)or(ro>0)then
       begin
          sx:=s^.w shr 1;
          sy:=s^.h shr 1;
          if(msk>0)then filledellipseColor(_screen,x+sx,y+sy,sx,sy,msk);
          if(ro >0)then circleColor(_screen,x+sx,y+sy,ro,c_gray);
       end;

       sy:=y;
       sx:=s^.h;
       if(y<4)then
       begin
          sx:=s^.h+y-4;
          y:=4;
       end;

       if(sy>-s^.h)then
       begin
          if(rc>0)and(y>-s^.h)then
          begin
             if(rct)then rectangleColor(_screen,x,y-1,x+s^.w,y+sx, rc);
             if(bar>0)then
             begin
                boxColor(_screen,x,y-4,x+s^.w           ,y-1,c_black);
                boxColor(_screen,x,y-4,x+trunc(bar*s^.w),y-1,rc);
             end;
          end;

          if(clu >0 )then _draw_text(_screen,x     ,y          ,i2s(clu),ta_left ,255,c_white);
          if(cru<>'')then _draw_text(_screen,x+s^.w,y          ,cru     ,ta_right,3,c_white);
          if(cll >0 )then _draw_text(_screen,x     ,y+sx-font_w,b2s(cll),ta_left ,255,c_white);
          if(crl >0 )then _draw_text(_screen,x+s^.w,y+sx-font_w,b2s(crl),ta_right,255,c_white);
       end;

       y:=sy;

       SDL_SetAlpha(s,SDL_SRCALPHA or SDL_RLEACCEL,255);

       dec(vid_vsls,1);
    end;

   if(ui_mc_a>0)then
   begin
      sx:=ui_mc_a;
      sy:=sx shr 1;
      ellipseColor(_screen,ui_mc_x-vid_vx,ui_mc_y-vid_vy,sx,sy,ui_mc_c);

      if(G_Paused=0)then dec(ui_mc_a,1);
   end;
end;

procedure D_terrain;
var i,ix,iy,s:integer;
    vx,vy:integer;
    spr:PTUsprite;
begin
   _draw_surf(_screen,vid_panel-((vid_vx+vid_panel) mod ter_w),-vid_vy mod ter_h, vid_terrain);

   vx:=vid_vx;
   vy:=vid_vy-vid_ab;

   for i:=1 to MaxSDecsS do
    with _SDecs[i-1] do
    begin
       ix:=x-vx+vid_mwa;
       iy:=y-vy+vid_mha;

       s:=i+abs(iy div vid_mha)+abs(ix div vid_mwa);

       case map_trt of
         0,17 : s:=s mod 19;
       else
         s:=s mod 14;
       end;

       if(s=0)
       then spr:=@spr_crater
       else spr:=@spr_tdecs[s];

       ix:=ix mod vid_mwa;
       iy:=iy mod vid_mha;

       if(ix<0)then ix:=vid_mwa+ix;
       if(iy<0)then iy:=vid_mha+iy;

       dec(iy,vid_ab);

       _draw_surf(_screen,ix-spr^.hw,iy-spr^.hh,spr^.surf);
    end;
end;

procedure D_fog;
var cx,cy,sx,sy,i,
    rx,ry,sry:integer;
begin
   cx:=(vid_vx+vid_panel) div fog_cw;
   cy:=vid_vy div fog_cw;
   rx:=vid_panel-((vid_vx+vid_panel) mod fog_cw)+fog_chw;
   sry:=(-vid_vy mod fog_cw)+fog_chw;
   for sx:=0 to fog_vcnw do
   begin
      ry:=sry;
      for sy:=0 to fog_vcnh do
      begin
         i:=fog_c[cx+sx,cy+sy];
         if(i=0)then filledcircleColor(_screen,rx,ry,fog_cr,c_black);
         if(i=1)then boxColor(_screen,rx-fog_chw,ry-fog_chw,rx+fog_chw,ry+fog_chw,c_ablack);
         inc(ry,fog_cw);
      end;
      inc(rx,fog_cw);
   end;

   if(g_mode=gm_ct)then
    for i:=1 to MaxPlayers do
     with g_ct_pl[i] do
     begin
        circleColor(_screen,px-vid_vx,py-vid_vy,g_ct_pr,plcolor[pl]);
        //if(_testmode)then _draw_text(_screen,px-vid_vx,py-vid_vy,i2s(ct) , ta_left,255, plcolor[pl]);

        if(vid_rtui=0)then
        begin
           if(ct>0)and((G_Step mod 20)>10)
           then circleColor(_minimap,mpx,mpy,map_prmm,c_gray)
           else circleColor(_minimap,mpx,mpy,map_prmm,plcolor[pl]);
        end;
     end;

   if(menu_s2=ms2_camp)then
   begin
      if(ui_msks>=0)then
      begin
         if(integer(ui_msk+ui_msks)>255)
         then ui_msk:=255
         else inc(ui_msk,ui_msks);
      end
      else
      begin
         if(integer(ui_msk+ui_msks)<0)
         then ui_msk:=0
         else inc(ui_msk,ui_msks);
      end;
      if(ui_msk>0)then
      begin
         boxColor(_screen,vid_panel,0,vid_mw,vid_mh,rgba2c(255,255,255,ui_msk));
         if(vid_rtui=0)then dec(ui_msks,1);
      end;
   end;
end;

procedure _draw_dbg;
var u,ix,iy:integer;
begin
   {_draw_text(_screen,750,0,i2s(m_mx)+' '+i2s(m_my) , ta_right,255, c_white);

   if(k_shift>2) then
   for u:=0 to MaxPlayers do
    with _players[u] do
    begin
       ix:=180+120*u;

       _draw_text(_screen,ix,90,b2s(army)+' '+b2s(u_c[false]) , ta_middle,255, plcolor[u]);

       _draw_text(_screen,ix,100,b2s(ai_skill)+' '+b2s(ai_maxarmy)+' '+b2s(ai_attack) , ta_middle,255, plcolor[u]);
       _draw_text(_screen,ix,110,b2s(cenerg)+' '+b2s(menerg) , ta_middle,255, plcolor[u]);

       for iy:=0 to 8  do _draw_text(_screen,ix,120+iy*10,b2s(u_e[true ,iy])+' '+b2s(u_s[true ,iy])+' '+i2s(ubx[iy]), ta_left,255, plcolor[u]);
       for iy:=0 to 11 do _draw_text(_screen,ix,220+iy*10,b2s(u_e[false,iy])+' '+b2s(u_s[false,iy]), ta_left,255, plcolor[u]);
    end; }

   if(k_ctrl>2)then
   for u:=1 to MaxUnits do
    with _units[u] do
     if(hits>dead_hits)and(player=HPlayer)then
     begin
        ix:=x-vid_vx;
        iy:=y-vid_vy;

        circleColor(_screen,ix,iy,r,c_gray);
        circleColor(_screen,ix,iy,sr,c_gray);

        if(inapc>0)then continue;

        if(hits>0)and(uid=UID_URocketL)then
        begin
           if(alrm_x>0)then lineColor(_screen,ix,iy,alrm_x-vid_vx,alrm_y-vid_vy,plcolor[player]);
           //if(tar1>0)then lineColor(_screen,ix,iy,_units[tar1].x-vid_vx,_units[tar1].y-vid_vy,c_white);
            lineColor(_screen,ix+10,iy+10,uo_x-vid_vx,uo_y-vid_vy,c_white);
        end;

         _draw_text(_screen,ix,iy,i2s(hits), ta_left,255, plcolor[player]);

        {if(hits>0)then
         if(k_shift>2)
         then lineColor(_screen,ix,iy,uo_x-vid_vx,uo_y-vid_vy,c_black)
         else
           if(alrm_x<>0)then
            lineColor(_screen,ix,iy,alrm_x-vid_vx,alrm_y-vid_vy,plcolor[player]);

        _draw_text(_screen,ix,iy,i2s(u)+' '+i2s(rld_a), ta_left,255, plcolor[player]);// }

        //if(sel)then  circleColor(_screen,ix,iy,r+5,plcolor[player]);
     end;

   {for u:=0 to 255 do
    if(ordx[u]>0)then
    begin
       ix:=ordx[u]-vid_vx;
       iy:=ordy[u]-vid_vy;

       _draw_text(_screen,ix,iy,i2s(u), ta_left,255, c_white);
    end; }
end;

procedure D_Game;
begin
   D_terrain;
   D_SpriteList;
   D_fog;
   D_ui;
   D_UIText;
   if(m_sxs>-1)then rectangleColor(_screen,m_sxs-vid_vx, m_sys-vid_vy, m_vx, m_vy, plcolor[HPlayer]);

   if(_testmode)and(net_nstat=0)then _draw_dbg;
end;

procedure DrawDedScr;
var p,y:integer;
begin
   if(vid_mredraw)then
   begin
      SDL_FillRect(_screen,nil,0);
      _draw_surf(_screen,0,0,_minimap);

      if(G_WTeam<255)
      then _draw_text(_screen,344,0,'Team #'+b2s(G_WTeam)+' win!',ta_right,255,c_white)
      else
        if(g_paused>0)then _draw_text(_screen,344,13,str_pause,ta_right,255,plcolor[g_paused]);

      _draw_text(_screen,148  ,3  , w2s(map_seed)                 , ta_left  ,255, c_white);
      _draw_text(_screen,148  ,15 , str_m_siz+i2s(map_mw)         , ta_left  ,255, c_white);
      _draw_text(_screen,148  ,27 , str_m_liq+str_m_liqC[map_liq] , ta_left  ,255, c_white);
      _draw_text(_screen,148  ,39 , str_m_obs+b2s(map_obs)        , ta_left  ,255, c_white);

      _draw_text(_screen,344  ,23 , b2pm[g_started], ta_right,255, c_white);
      _draw_text(_screen,344  ,3  , net_sv_pstr    , ta_right,255, c_white);


      _draw_text(_screen,148  ,51 , str_addon[g_addon], ta_left,255, c_white);
      _draw_text(_screen,148  ,63 , str_gmode[g_mode ], ta_left,255, c_white);

      for p:=1 to MaxPlayers do
       with _players[p] do
       begin
          y:=87+(p-1)*12;
          if(state=ps_none)
          then _draw_text(_screen,148,y  , '---', ta_left  ,255, c_white)
          else
          begin
             _draw_text(_screen,148 ,y  , name, ta_left  ,255, c_white);
             characterColor(_screen,252,y,_plst(p),plcolor[p]);
             _draw_text(_screen,270 ,y  , str_race[race], ta_left  ,255, c_white);
             _draw_text(_screen,330 ,y  , b2s(team), ta_left  ,255, c_white);
          end;
       end;

      vid_mredraw:=false;
   end;
end;

procedure DrawGame;
begin
   if(_ded=false)then
   begin
      SDL_FillRect(_screen,nil,0);

      if(_menu)
      then D_Menu
      else D_Game;

      _draw_surf(_screen,m_vx,m_vy,spr_cursor);
   end
   else DrawDedScr;

   sdl_flip(_screen);
end;



