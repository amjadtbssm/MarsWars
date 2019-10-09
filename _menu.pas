

procedure ToggleMenu;
begin
   if(G_Started)then
   begin
      _menu:=not _menu;
      vid_mredraw:=_menu;
      _m_sel:=0;
       if not(net_sv_up or net_cl_con)then
          if(_menu)then
          begin
             if((g_status<>gs_game)and(_mmode=mm_camp))or(_rpls_rst=rpl_rend)then
             begin
                G_Started:=false;
                DefGameObjects;
             end else g_paused:=1;
          end
          else g_paused:=0;
   end;
end;


function menu_sf(s:string;charset:TSoc;ms:byte):string;
var sl:byte;
     c:char;
begin
   if (k_chrt=2)or(k_chrt>k_chrtt) then
   begin
      sl:=length(s);
      c:=k_chr;
      if not(c in charset) then c:=#0;
      if (k_chr=#8)
      then delete(s,sl,1)
      else if (sl<ms)and(c<>#0) then s:=s+c;
   end;
   vid_mredraw:=true;
   menu_sf:=s;
end;

procedure c_m_sel;
begin
   _m_sel:=0;

   if(544<m_vy)and(m_vy<571)then
   begin
      if(32 <m_vx)and(m_vx<107)then _m_sel:=1;   //exit
      if(not net_cl_con)then
       if(692<m_vx)and(m_vx<767)then _m_sel:=5;  // start
   end;

   if(m_vy<65)and(m_vx>175)and(m_vx<625)then
    if(G_Started=false)and(net_sv_up=false)and(net_cl_con=false)and(_mmode<>mm_camp)and(g_mode=gm_scir)and(_mmode=mm_mult)then _m_sel:=250;

   if(300<m_vy)and(m_vy<318)then
   begin
      if not(net_sv_up or net_cl_con)then
       if(not G_Started)then
        if(418<m_vx)and(m_vx<519)then _m_sel:=2;   // camps

      if not(G_Started and(_mmode<>mm_mult))or(net_sv_up or net_cl_con)then
       if(518<m_vx)and(m_vx<621)then _m_sel:=3;   // multi

      if(net_sv_up or net_cl_con)then
       if(620<m_vx)and(m_vx<724)then _m_sel:=4;  // chat
   end;

   if(327<m_vy)and(m_vy<343)then
   begin
      if not(net_sv_up or net_cl_con)then
       if(280<m_vx)and(m_vx<380)then _m_sel:=8;  // replays

      if not(net_sv_up or net_cl_con)then
       if(onlySVCode)then
        if(180<=m_vx)and(m_vx<280)then _m_sel:=7;  // save load

      if(78< m_vx)and(m_vx<177)then _m_sel:=6;  // settings
   end;

   if(_mmode2=mm_sett)then
   begin
      if(198<m_vx)and(m_vx<325)and(444<m_vy)and(m_vy<460)then _m_sel:=12;   //scrl

      if(374<m_vy)and(m_vy<390)then
      begin
         if(90 <m_vx)and(m_vx<222)then _m_sel:=10;   //snd
         if(237<m_vx)and(m_vx<369)then _m_sel:=11;   //msc
      end;

      if(90 <m_vx)and(m_vx<325)and(420<m_vy)and(m_vy<436)then _m_sel:=188;  //mouse action invert

      if(468<m_vy)and(m_vy<484)then
      begin
         if(90 <m_vx)and(m_vx<210)then _m_sel:=13;   //vid mmv
         if(228<m_vx)and(m_vx<326)then _m_sel:=14;   //fscr
      end;

      if(492<m_vy)and(m_vy<508)then
      begin
         if not (net_cl_con or net_sv_up or G_Started) then
          if(90<m_vx)and(m_vx<305)then _m_sel:=15;   //pname

         if(320<m_vx)and(m_vx<369)then _m_sel:=187;  //lng
      end;
   end;

  { if(_mmode2=mm_sett)then
   begin
      if(m_vx<325)then
      begin
         if(90<m_vx)then
         begin
            if(374<m_vy)and(m_vy<390)then _m_sel:=10;   //snd
            if(398<m_vy)and(m_vy<414)then _m_sel:=11;   //msc

         end;
         if(198<m_vx)then
         begin
            if(444<m_vy)and(m_vy<460)then _m_sel:=12;   //scrl
         end;
      end;

      if(468<m_vy)and(m_vy<484)then
      begin
         if(90 <m_vx)and(m_vx<210)then _m_sel:=13;   //vid mmv
         if(228<m_vx)and(m_vx<326)then _m_sel:=14;   //fscr
         if(344<m_vx)and(m_vx<365)then _m_sel:=188;  //mouse action invert
      end;

      if(492<m_vy)and(m_vy<508)then
      begin
         if not (net_cl_con or net_sv_up or G_Started) then
          if(90<m_vx)and(m_vx<305)then _m_sel:=15;   //pname

         if(320<m_vx)and(m_vx<369)then _m_sel:=187;  //lng
      end;
   end;}

   if(_mmode2=mm_svld)then
   begin
      if(_svld_lsts>0)then
       if(76<m_vx)and(m_vx<231)and(351<m_vy)and(m_vy<489)then _m_sel:=40; // save load

      if(76<m_vx)and(m_vx<381)then
      begin
         if(G_Started)then
          if(492<m_vy)and(m_vy<504)then _m_sel:=41;
         if(504<m_vy)and(m_vy<526)then
         begin
            _m_sel:=42+((m_vx-76) div 102);
            if( ((not G_Started)or(_svld_str=''))and(_m_sel=42))or((_svld_sm>=_svld_lsts)and(_m_sel>42))then _m_sel:=0;
         end;
      end;
   end;

   if(_mmode2=mm_rpls)and(g_started=false) then
   begin
      if(76<m_vx)and(m_vx<231)and(351<m_vy)and(m_vy<503)then _m_sel:=83; // replays      4489
      if(76<m_vx)and(m_vx<381)then
      begin
         if(_rpls_sm<_rpls_lsts)then
         if(504<m_vy)and(m_vy<526)then
         begin
            _m_sel:=84+((m_vx-76) div 102);
         end;
      end;
   end;

   if (G_Started=false)then
   begin
      if(432<m_vx)and(m_vx<535)then
      begin
         if(129<m_vy)and(m_vy<149)then _m_sel:=201;  //name
         if(163<m_vy)and(m_vy<183)then _m_sel:=202;
         if(197<m_vy)and(m_vy<217)then _m_sel:=203;
         if(231<m_vy)and(m_vy<251)then _m_sel:=204;
      end;

      if(net_cl_con=false)then
      begin
         if(538<m_vx)and(m_vx<557)then
         begin
            if(129<m_vy)and(m_vy<149)then _m_sel:=211;  // < C P - ?
            if(163<m_vy)and(m_vy<183)then _m_sel:=212;
            if(197<m_vy)and(m_vy<217)then _m_sel:=213;
            if(231<m_vy)and(m_vy<251)then _m_sel:=214;
         end;

         if(576<m_vx)and(m_vx<635)then
         begin
            if(129<m_vy)and(m_vy<149)then _m_sel:=221;  // race
            if(163<m_vy)and(m_vy<183)then _m_sel:=222;
            if(197<m_vy)and(m_vy<217)then _m_sel:=223;
            if(231<m_vy)and(m_vy<251)then _m_sel:=224;
         end;

        if(g_mode in [gm_scir,gm_ct])then
         if(654<m_vx)and(m_vx<673)then
         begin
            if(129<m_vy)and(m_vy<149)then _m_sel:=231;  // team
            if(163<m_vy)and(m_vy<183)then _m_sel:=232;
            if(197<m_vy)and(m_vy<217)then _m_sel:=233;
            if(231<m_vy)and(m_vy<251)then _m_sel:=234;
         end;

         if(432<m_vx)and(m_vx<667)and(328<m_vy)and(m_vy<344)then _m_sel:=236;     // game mode

        if(not(_mmode=mm_camp))then
         if(248<m_vx)and(m_vx<368)then
         begin
            if(128<m_vy)and(m_vy<144)then _m_sel:=50;
            if(153<m_vy)and(m_vy<169)then _m_sel:=51;
            if(178<m_vy)and(m_vy<194)then _m_sel:=52;
            if(203<m_vy)and(m_vy<219)then _m_sel:=53;
            if(228<m_vy)and(m_vy<244)then _m_sel:=54;
            if(253<m_vy)and(m_vy<269)then _m_sel:=55;
         end;
      end;
   end;

   if(_mmode=mm_chat)then
    if(318<m_vy)and(m_vy<525)and(415<m_vx)and(m_vx<725)then _m_sel:=100;  // chat

   if(_mmode=mm_mult)then
   begin
      if(not net_sv_up)then
      begin
         if(not G_Started)then
         begin
            if(432<m_vx)and(m_vx<557)and(374<m_vy)and(m_vy<390)then _m_sel:=20; // udp port
            if(468<m_vy)and(m_vy<484)then
            begin
               if(432<m_vx)and(m_vx<491)then _m_sel:=23; // team
               if(509<m_vx)and(m_vx<606)then _m_sel:=24; // race
               if(620<m_vx)and(m_vx<711)then _m_sel:=25; // ready
            end;
         end;

         if(net_cl_con=true)or(G_Started=false)then
          if(432<m_vx)and(m_vx<523)and(492<m_vy)and(m_vy<508)then _m_sel:=26; // connect
      end;

      if(374<m_vy)and(m_vy<390)then         /// replays
      begin
         if(_rpls_rst<rpl_rhead )then
          if(582<m_vx)and(m_vx<641)then _m_sel:=80; // replay off/on
         if(_rpls_rst=rpl_none )then
          if(652<m_vx)and(m_vx<711)then _m_sel:=81; // replay pnu
      end;
      if(_rpls_rst=rpl_none )then
       if(398<m_vy)and(m_vy<414)and(582<m_vx)and(m_vx<707)then _m_sel:=82; // last replay name

      if(not (net_cl_con or G_Started)) then
      begin
         if(432<m_vx)and(m_vx<552)and(398<m_vy)and(m_vy<414)then _m_sel:=21; // up server
         if(432<m_vx)and(m_vx<667)and(444<m_vy)and(m_vy<460)then _m_sel:=22; // sv addr
      end;

      if(538<m_vx)and(m_vx<635)and(492<m_vy)and(m_vy<508)then _m_sel:=28;

      if(652<m_vx)and(m_vx<711)and(492<m_vy)and(m_vy<508)then _m_sel:=27; // connect
   end;

   if(_mmode=mm_camp)and(not G_Started)then
    if(424<m_vx)and(m_vx<720)and(327<m_vy)and(m_vy<518)then _m_sel:=30; // missions


end;

////////////////////////////////////////////////////////////////////////////////

procedure g_menu;
var p:integer;
begin

   if(k_ml=2)or(k_mr=2) then //right or left click
   begin
      if(_m_sel=22)then net_cl_saddr;
      if(_m_sel=15)then _players[PlayerHuman].name:=Playername;
      c_m_sel;
      vid_mredraw:=true;
   end;

   if(k_ml=2)then    // left button pressed
   begin
      if(_m_sel=187)then
      begin
         _lng:=not _lng;
         swLNG;
      end;

      if(_m_sel=250)then MakeRandomSkirmish(false);

      if(_m_sel=236)then
      begin
         inc(g_mode,1);
         g_mode:=g_mode mod 4;
         _g_set_mode;
         g_premap;
      end;

      if(_m_sel=1) then
       if G_Started
       then ToggleMenu
       else _cycle:=false;

      if(_m_sel=2) then _mmode:=mm_camp;
      if(_m_sel=3) then
      begin
         if(_mmode=mm_camp)then
         begin
            _mmode:=mm_mult;
            g_randomseed;
            g_premap;
         end
         else _mmode:=mm_mult;
      end;
      if(_m_sel=4) then begin _mmode:=mm_chat;_m_sel:=100;chat_nrlm:=false;end;

      if(_m_sel=5) then   //start
      begin
         _StartGame;
      end;

      if(_m_sel=6)then _mmode2:=mm_sett;
      if(_m_sel=7)then
      begin
         _mmode2:=mm_svld;
         _svld_make_lst;
      end;
      if(_m_sel=8)then
      begin
         _mmode2:=mm_rpls;
         _rpls_make_lst;
      end;

      if(_m_sel=10)then begin if(m_vx>=142)then snd_svolume:=trunc((m_vx-142)/mmsndvlmx) else snd_svolume:=0; end;  //snd
      if(_m_sel=11)then begin if(m_vx>=289)then snd_mvolume:=trunc((m_vx-289)/mmsndvlmx) else snd_mvolume:=0; MIX_VOLUMEMUSIC(snd_mvolume); end;
      if(_m_sel=12)then vid_vms:=m_vx-198;  //scroll

      if(_m_sel=13)then vid_vmm:=not vid_vmm;
      if(_m_sel=14)then _MakeScreen;
      if(_m_sel=188)then _ma_inv:=not _ma_inv;


      if(_m_sel=21)then
      begin
         if(net_sv_up)then
         begin
            _disposeNet;
            if(g_started)then DefGameObjects;
            g_started:=false;
            net_sv_up:=false;
         end
         else
           net_sv_up:=true;
           if(_initSocket=false)then
           begin
              _disposeNet;
              net_sv_up:=false;
           end;
         _mmode2:=mm_sett;
      end;

      if(_m_sel=23)then _scrollV(@PlayerTeam,1,1,MaxPlayers);
      if(_m_sel=24)then begin inc(PlayerRace,1); PlayerRace:=PlayerRace mod 3;end;
      if(_m_sel=25)then PlayerReady:=not PlayerReady;

      if(_m_sel=26)then
      begin
         if(net_cl_con)then
         begin
            _disposeNet;
            g_started:=false;
            DefGameObjects;
            PlayerReady:=false;
            net_cl_con:=false;
         end
         else
         begin
            net_cl_con:=true;
            if(_initSocket)
            then net_m_error:=str_connecting
            else
            begin
               _disposeNet;
               net_cl_con:=false;
            end;
         end;
         _mmode2:=mm_sett;
      end;

      if(_m_sel=27)then _scrollV(@PlayerNUnits,5,PNU_min,PNU_max);

      if(_m_sel=28)then _scrollV(@PlayerNUR,1,2,4);

      if(_m_sel=30)then
      begin
         _mcmp_sm:=_mcmp_srl+((m_vy-313)div 14);
         if(_mcmp_sm>MaxMissions)then _mcmp_sm:=MaxMissions;
      end;

      if(_m_sel=40)then
      begin
         _svld_sm :=_svld_srl+((m_vy-351)div 14);
         _svld_sel;
      end;
      if(_m_sel=42)then _svld_save;
      if(_m_sel=43)then _svld_load;
      if(_m_sel=44)then _svld_delete;

      if(_m_sel=51)then begin map_pos:=1-map_pos;g_premap;end;
      if(_m_sel=52)then begin _scrollV(@map_mw,500,3000,6000); g_premap;end;
      if(_m_sel=53)then begin map_liq:=not map_liq; g_premap;end;
      if(_m_sel=54)then begin _scrollV(@map_obs,1,1,4); g_premap;end;
      if(_m_sel=55)then begin g_randommap; g_premap;end;

      if(_m_sel=80)then
       if(_rpls_rst=rpl_none)
       then _rpls_rst:=rpl_whead
       else _rpls_rst:=rpl_none;

      if(_m_sel=81)then _scrollV(@_rpls_pnu,5,PNU_min,_rpls_pnumax);

      if(_m_sel=83)then
      begin
         _rpls_sm :=_rpls_srl+((m_vy-351)div 14);
         _rpls_sel;
      end;
      if(_m_sel=85)then
      begin
         _mmode:=mm_mult;
         _rpls_rst:=rpl_rhead;
         g_started:=true;
      end;
      if(_m_sel=86)then _rpls_delete;

      if(net_cl_con=false)then
       if(_m_sel in [201..204])then _swAI(_m_sel-200);

      if(_m_sel in [211..214])then
      begin
         p:=_m_sel-210;
         if(p<>PlayerHuman)then
          with _players[p] do
          begin
             if (State<>ps_none)
             then state:=PS_None
             else state:=PS_Comp;

             _playerSetState(p);
          end;
       end;

      if(_m_sel in [221..224])then
      begin
         p:=_m_sel-220;
         with _players[p] do
          if(state=ps_comp)or(p=PlayerHuman)then
          begin
             inc(Race,1);
             Race:=Race mod 3;
          end;
       end;

      if(_m_sel in [231..234])then
      begin
         p:=_m_sel-230;
         with _players[p] do
          if(state=ps_comp)or(p=PlayerHuman)then
           if(team<MaxPlayers)then inc(team,1);
       end;

      if(_m_sel>0)then PlaySNDM(snd_click);
   end;

   if(k_mr=2)then    // right button pressed
   begin
      if(_m_sel=250)then MakeRandomSkirmish(true);

      {if(_m_sel=14)then
      begin
         vid_wide:=not vid_wide;
         _fscr:=not _fscr;
         _MakeScreen;
         CalcMapVars;
         MakeTerrain;
      end;}

      if(_m_sel=23)then _scrollV(@PlayerTeam,-1,1,MaxPlayers);

      if(_m_sel=27)then _scrollV(@PlayerNUnits,-5,PNU_min,PNU_max);
      if(_m_sel=28)then _scrollV(@PlayerNUR,-1,2,4);

      if(_m_sel=52)then begin _scrollV(@map_mw,-500,3000,6000); g_premap;end;
      if(_m_sel=54)then begin _scrollV(@map_obs,-1,1,4); g_premap;end;

      if(_m_sel=81)then _scrollV(@_rpls_pnu,-5,PNU_min,_rpls_pnumax);

      if(_m_sel in [201..204])then
       if(net_cl_con)
       then net_swapp(_m_sel-200)
       else _swapPlayers(_m_sel-200,PlayerHuman);

      if(_m_sel in [231..234])then
      begin
         p:=_m_sel-230;
         with _players[p] do
          if(state=ps_comp)or(p=PlayerHuman)then
           if(team>1)then dec(team,1);
       end;

      if(_m_sel=50)then
      begin
         g_randomseed;
         g_premap;
      end;

      if(_m_sel>0)then PlaySNDM(snd_click);
   end;

   if((k_chrt=2)or(k_chrt>k_chrtt)) then
   begin
      if(_m_sel=15 )then PlayerName:=menu_sf(PlayerName,k_kbstr,NameLen);

      if(_m_sel=20 )then
      begin
         net_sv_pstr:=menu_sf(net_sv_pstr,k_kbdig,5);
         net_sv_sport;
      end;

      if(_m_sel=22 )then net_cl_svstr:=menu_sf(net_cl_svstr,k_kbaddr,21);

      if(_m_sel=41 )then _svld_str   :=menu_sf(_svld_str   ,k_kbstr,SvRpLen);
      if(_m_sel=82 )then _rpls_lrname:=menu_sf(_rpls_lrname,k_kbstr,SvRpLen);

      if(_m_sel=50)then
      begin
         map_seed:=s2c(menu_sf(c2s(map_seed),k_kbdig,10));
         g_premap;
      end;
   end;
end;

