procedure _draw_surf(tar:pSDL_Surface;x,y:integer;sur:PSDL_SURFACE);
begin
   _rect^.x:=x;
   _rect^.y:=y;
   _rect^.w:=sur^.w;
   _rect^.h:=sur^.h;
   SDL_BLITSURFACE(sur,nil,tar,_rect);
end;

procedure _draw_text(sur:pSDL_Surface;x,y:integer;s:string;al,chrs:byte;tc:cardinal);
var ss,i,o:byte;
      sl:integer;
       c:char;
begin
   ss:=length(s);
   if(ss>0)then
   begin
      if(chrs>ss)then chrs:=ss;
      sl:=chrs*font_w;
      case al of
   ta_middle : dec(x,(sl div 2));
   ta_right  : dec(x,sl+font_w);
      end;
      sl:=0;
      o :=0;
      for i:=1 to ss do
      begin
         c:=s[i];
         if(c>#13)then
         begin
            boxColor(sur,x,y,x+font_iw,y+font_iw,tc);
            _draw_surf(sur,x,y,font_ca[c]);
         end;
         inc(x ,font_w);
         inc(sl,font_w);
         inc(o,1);
         if(o>=chrs)or(c=#13)or(c=#12)then //and not(s[i+1] in [#12..#13])
         begin
            o:=0;
            dec(x,sl);
            inc(y,font_w);
            if(c=#12)
            then inc(y,txt_line_h2)
            else inc(y,txt_line_h);
            sl:=0;
         end;
      end;
   end;
end;

procedure _draw_ctext(sur:pSDL_Surface;x,y:integer;s:string);
var p:byte;
begin
   if(length(s)>0)then
   begin
      p:=ord(s[1]);
      if(p<=MaxPlayers)then _draw_text(sur,x-font_w,y,s,ta_left,255,p_colors[p]);
   end;
end;

procedure LoadingScreen;
begin
   SDL_FillRect(vid_screen,nil,0);
   stringColor(vid_screen,(vid_mw div 2)-40, vid_mh div 2,@str_loading[1],c_yellow);
   SDL_FLIP(vid_screen);
end;

{$Include _draw_menu.pas}
{$Include _draw_panel.pas}

procedure _draw_fog;
var cx,cy,sx,sy,i:byte;
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
         if(i=0)then filledcircleColor(vid_screen,rx,ry,fog_cr,c_black);
         if(i=1)then boxColor(vid_screen,rx-fog_chw,ry-fog_chw,rx+fog_chw,ry+fog_chw,c_ablack);
         inc(ry,fog_cw);
      end;
      inc(rx,fog_cw);
   end;

   if(g_mode=gm_ct)then
    for i:=1 to MaxPlayers do
     with g_pt[i] do
     begin
        rx:=x-vid_vx;
        ry:=y-vid_vy;
        circleColor(vid_screen,rx,ry,point_r,p_colors[p]);
     end;

   if(_mmode=mm_camp)then
    if(_mcmp_sm in [4,7,9])then
     if(G_Step<=cmp_inhelltime)then boxColor(vid_screen,vid_panel,0,vid_mw,vid_mh,c_white);
end;


procedure _draw_hints;
var i:byte;
begin
 if(_rpls_rst<rpl_rhead)then
  if(m_bx<3)and(m_by>3)and(m_by<12)then
   with _players[PlayerHuman] do
   begin
      i:=((m_by-4)*3)+(m_bx mod 3);
      _draw_text(vid_screen,146,580,str_hints[race,i,0],ta_left,255,c_white);
      _draw_text(vid_screen,146,590,str_hints[race,i,1],ta_left,255,c_white);
   end;
end;

procedure _draw_messages;
var i:byte;
begin
   if(_igchat)then
   begin
      for i:=0 to net_lg_cs do _draw_ctext(vid_screen,148,560-13*i,net_lg_c[i]);
      _draw_text(vid_screen,148,570,':'+chat_m , ta_left,255, p_colors[PlayerHuman]);
   end
   else
     if(net_lg_lmt>0)then
     begin
        _draw_ctext(vid_screen,148,560,net_lg_c[0]);
        dec(net_lg_lmt,1);
     end;

   case g_status of
 gs_win : _draw_text(vid_screen,472,2,str_win   ,ta_middle,255,c_lime);
 gs_lose: _draw_text(vid_screen,472,2,str_lose  ,ta_middle,255,c_red);
   end;
   if(G_paused>0)and(net_cl_con or net_sv_up)then _draw_text(vid_screen,472,12,str_pause ,ta_middle,255,p_colors[G_paused]);

   if(_rpls_rst=rpl_rend)then _draw_text(vid_screen,472,2,str_repend,ta_middle,255,c_white);

   _draw_hints;
end;


procedure _sprb_add(spr:psdl_surface;sx,sy,depth,shh:integer;rcol:cardinal;co:single;ch:char;al:byte;ra:boolean;tac:cardinal;tapcm,tapcc:byte);
begin
   if(vid_sbufs<MaxSprBuffer)and(_menu=false)and(G_Paused=0)then
   begin
      inc(vid_sbufs,1);
      with vid_sbuf[vid_sbufs] do
      begin
         s :=spr;
         d :=depth;
         c :=rcol;
         x :=sx-vid_vx;
         y :=sy-vid_vy;
         o :=co;
         h :=ch;
         sh:=shh;
         i :=al;
         r :=ra;
         ac:=tac;
         apcm:=tapcm;
         apcc:=tapcc;
      end;
   end;
end;

procedure _draw_sprb_sort;
var i,j:integer;
    p:TSprD;
begin
   if(vid_sbufs>1)then
    for i:=1 to vid_sbufs do
     for j:=1 to (vid_sbufs-1) do
      if (vid_sbuf[j].d<vid_sbuf[j+1].d)then
      begin
         p:=vid_sbuf[j];
         vid_sbuf[j]:=vid_sbuf[j+1];
         vid_sbuf[j+1]:=p;
      end;
end;

procedure _draw_sprb;
var sx,sy:integer;
begin
   _draw_sprb_sort;
   if(G_Paused=0)
   then vid_sbufsp:=vid_sbufs
   else vid_sbufs:=vid_sbufsp;

   while (vid_sbufs>0) do
    with vid_sbuf[vid_sbufs] do
    begin
       if(sh>0)then
       begin
          sx:=(s^.w shr 1);
          filledellipseColor(vid_screen,x+sx,y+sh,sx,s^.h div 4,c_ablack);
       end;
       SDL_SetAlpha(s,SDL_SRCALPHA or SDL_RLEACCEL,i);

       _draw_surf(vid_screen,x,y,s);

       if(ac>0)then
       begin
          sx:=s^.w shr 1;
          sy:=s^.h shr 1;
          filledellipseColor(vid_screen,x+sx,y+sy,sx,sy,ac);
       end;

       if(r)then rectangleColor(vid_screen,x,y,x+s^.w,y+s^.h, c);
       if(o>0)then
       begin
          boxColor(vid_screen,x,y-3,x+s^.w,y,c_black);
          boxColor(vid_screen,x,y-3,x+trunc(o*s^.w),y,c);
       end;
       if(h<>#0)then characterColor(vid_screen,x,y,h,c_white);
       if(apcm>0)then
       begin
          _draw_text(vid_screen,x+s^.w+7,y+s^.h-8,b2s(apcm),ta_right,255,c_white);
          _draw_text(vid_screen,x+1     ,y+s^.h-8,b2s(apcc),ta_left ,255,c_white);
       end;

       SDL_SetAlpha(s,SDL_SRCALPHA or SDL_RLEACCEL,255);

       dec(vid_sbufs,1);
    end;

   if(ui_mc_a>0)then
   begin
      sx:=ui_mc_a div 2;
      sy:=sx shr 1;
      ellipseColor(vid_screen,ui_mc_x-vid_vx,ui_mc_y-vid_vy,sx,sy,ui_mc_c);

      if(G_Paused=0)then dec(ui_mc_a,1);
   end;
end;


procedure _draw_selrect;
begin
   if (m_sxs>-1) then rectangleColor(vid_screen,m_sxs-vid_vx, m_sys-vid_vy, m_vx, m_vy, p_colors[PlayerHuman]);
end;

procedure _draw_dbg;
var p:byte;
x,y:integer;
begin
   y:=100;

   _draw_text(vid_screen,  150, y, 'army', ta_left,255, c_white);
   _draw_text(vid_screen,  150, y+10, 'men/cen', ta_left,255, c_white);
   _draw_text(vid_screen,  150, y+20, 'units', ta_left,255, c_white);
   _draw_text(vid_screen,  150, y+30, 'builds', ta_left,255, c_white);
   _draw_text(vid_screen,  150, y+40, 's u', ta_left,255, c_white);
   _draw_text(vid_screen,  150, y+50, 's b', ta_left,255, c_white);
   _draw_text(vid_screen,  150, y+60, 'upgr', ta_left,255, c_white);

   _draw_text(vid_screen,  150, y+80, 'u0', ta_left,255, c_white);
   _draw_text(vid_screen,  150, y+90, 'u3', ta_left,255, c_white);
   _draw_text(vid_screen,  150, y+100,'u5', ta_left,255, c_white);

   _draw_text(vid_screen,  150, y+120, 'ai push', ta_left,255, c_white);
   _draw_text(vid_screen,  150, y+130, 'ai part', ta_left,255, c_white);
   _draw_text(vid_screen,  150, y+140, 'ai skill', ta_left,255, c_white);

   _draw_text(vid_screen,  150, y+200, 'units add', ta_left,255, c_white);
   _draw_text(vid_screen,  150, y+210, 'builds add',ta_left,255, c_white);
   _draw_text(vid_screen,  150, y+220, 'units kill', ta_left,255, c_white);
   _draw_text(vid_screen,  150, y+230, 'builds dest',ta_left,255, c_white);
   _draw_text(vid_screen,  150, y+240, 'units lost', ta_left,255, c_white);
   _draw_text(vid_screen,  150, y+250, 'builds lost',ta_left,255, c_white);
   _draw_text(vid_screen,  150, y+260, 'upgr level',ta_left,255, c_white);

   for p:=0 to MaxPlayers do
    with _players[p] do
    begin
       x:=260+122*p;
       _draw_text(vid_screen,  x, y, i2s(army)+'/'+b2s(ai_maxarmy), ta_middle,255, p_colors[p]);
       _draw_text(vid_screen,  x, y+10, i2s(cenerg)+'/'+i2s(menerg), ta_middle,255, c_white);

       _draw_text(vid_screen,  x, y+20, i2s(eu[false,0])+','+i2s(eu[false,1])+','+i2s(eu[false,2])+','+i2s(eu[false,3])+','+i2s(eu[false,4])+','+i2s(eu[false,5])+','+i2s(eu[false,6]), ta_middle,255, c_white);
       _draw_text(vid_screen,  x, y+30, i2s(eu[true,0])+','+i2s(eu[true,1])+','+i2s(eu[true,2])+','+i2s(eu[true,3])+','+i2s(eu[true,4])+','+i2s(eu[true,5])+','+i2s(eu[true,6]), ta_middle,255, c_white);

       _draw_text(vid_screen,  x, y+50, i2s(su[true,0])+','+i2s(su[true,1])+','+i2s(su[true,2])+','+i2s(su[true,3])+','+i2s(su[true,4])+','+i2s(su[true,5]), ta_middle,255, c_white);

       _draw_text(vid_screen,  x, y+60, i2s(upgr[0])+i2s(upgr[1])+i2s(upgr[2])+i2s(upgr[3])+i2s(upgr[4])+i2s(upgr[5])+i2s(upgr[6])+i2s(upgr[7]), ta_middle,255, c_white);

       _draw_text(vid_screen,  x, y+80, i2s(u0), ta_middle,255, c_white);
       _draw_text(vid_screen,  x, y+90, i2s(u3), ta_middle,255, c_white);
       _draw_text(vid_screen,  x, y+100, i2s(u5), ta_middle,255, c_white);

       _draw_text(vid_screen,  x, y+120, i2s(ai_minpush), ta_middle,255, c_white);
       _draw_text(vid_screen,  x, y+130, i2s(ai_partpush), ta_middle,255, c_white);
       _draw_text(vid_screen,  x, y+140, i2s(ai_skill), ta_middle,255, c_white);

       circleColor(vid_screen,ai_bx[p]-vid_vx,ai_by[p]-vid_vy,50,p_colors[p]);
    end;
end;

procedure dubdg;
var u,ix,iy:integer;
begin
   for u:=1 to MaxUnits do
    with _units[u] do
     if(hits>0)then
     begin
        ix:=x-vid_vx;
        iy:=y-vid_vy;
        if(inapc=0) then inc(iy,10);

        //if(dist2(m_mx,m_my,x,y)>r)then continue;// else dec(hits,1);

        if(k_shift>1)then
        begin
           circleColor(vid_screen,ix,iy,sr,c_white);
           circleColor(vid_screen,ix,iy,r,c_gray);
        end;

        if(_uclord=0)then filledCircleColor(vid_screen,ix,iy,r,c_white);
        with _players[player] do if(u1=u)then filledCircleColor(vid_screen,ix,iy,r div 2,c_yellow);

       _draw_text(vid_screen,ix,iy,i2s(apcc)+' '+i2s(ma),ta_left,255,p_colors[player]);

       if(player=1)then
       lineColor(vid_screen,ix,iy,alx-vid_vx,aly-vid_vy,c_black);


       if(ucl=uid_fapc)then
        lineColor(vid_screen,ix,iy,mx-vid_vx,my-vid_vy,c_orange);

       if(radar)and(rld>0)then lineColor(vid_screen,ix,iy, (mx*fog_cw)-vid_vx,(my*fog_cw)-vid_vy,p_colors[player]);
     end;

   circleColor(vid_screen,m_vx,m_vy,45,c_yellow);
   circleColor(vid_screen,m_vx,m_vy,55,c_white);
end;

procedure _draw_terrain;
var i,ix,iy,s:integer;
begin
   _draw_surf(vid_screen,vid_panel-((vid_vx+vid_panel) mod ter_w),-vid_vy mod ter_h, vid_terrain);

   for i:=1 to MaxADecs do
    with terdcs[i] do
    begin
       ix:=x-vid_vx-vid_mw;
       iy:=y-vid_vy-vid_mh;

       if((x+y) mod 2)=0
       then s:=1+(i+(abs(iy div vid_mh))) mod MaxADecSpr
       else s:=1+(i+(abs(ix div vid_mw))) mod MaxADecSpr;

       if(map_trt in [0,17])
       then s:=13+(s mod 6)
       else s:=(s mod 14);

       if(s=0)then continue;

       spr:=@spr_adecs[s];

       ix:=ix mod vid_mw;
       iy:=iy mod vid_mh;

       if(ix<0) then ix:=vid_mw+ix;
       if(iy<0) then iy:=vid_mh+iy;

       _draw_surf(vid_screen,ix,iy-spr^.hh,spr^.surf);
    end;

   if(g_mode=gm_inv)then _draw_surf(vid_screen,map_psx[0]-spr_u_portal.hw-vid_vx, map_psy[0]-spr_u_portal.hh-vid_vy,spr_u_portal.surf);
end;

procedure DrawINGame;
begin
   _draw_terrain;

   _draw_sprb;
   _draw_fog;

   _draw_ui;
   _draw_surf(vid_screen,0,0,vid_spanel);
   _draw_messages;
   _draw_selrect;
end;

procedure DrawGame;
begin
   if(_menu)
   then DrawMenu
   else DrawINGame;

   if(_testmode)then
   begin
      if(k_ctrl>2)then dubdg;
      if(k_shift>1)then _draw_dbg;

      _draw_text(vid_screen,200,0,i2s(m_mx)+' '+i2s(m_my),ta_left,255,c_white);

      _draw_text(vid_screen,300,0,i2s(vid_sbufsp)+' '+c2s(map_seed)+' '+b2pm[vid_mredraw]+' '+c2s(net_cl_svip)+' '+w2s(net_cl_svport),ta_left,255,c_white);

      _draw_text(vid_screen,600,0,i2s(fps),ta_left,255,c_white);

   end;

   _draw_surf(vid_screen, m_vx,m_vy, spr_cursor);
   sdl_flip(vid_screen);
   vid_mredraw:=false;
end;



