
procedure ToggleMenu;
begin
   if(G_Started)then
   begin
      _menu:=not _menu;
      vid_mredraw:=_menu;
      _m_sel:=0;
      if(net_nstat=ns_none)then
       if(_menu)then
       begin
          if((G_WTeam<255)and(menu_s2=ms2_camp))or(_rpls_rst=rpl_end)then
          begin
             G_Started:=false;
             DefGameObjects;
          end
          else g_paused:=1;
       end
       else G_Paused:=0;
   end;
end;

function menu_sf(s:string;charset:TSoc;ms:byte):string;
var sl:byte;
     c:char;
begin
   if (k_chrt=2)or((k_chrt>k_chrtt)and(fps_cs>=fps_ns)) then
   begin
      sl:=length(s);
      c:=k_chr;
      if not(c in charset) then c:=#0;
      if(k_chr=#8)
      then delete(s,sl,1)
      else
        if(sl<ms)and(c<>#0)then s:=s+c;
   end;
   menu_sf:=s;
end;

procedure c_m_sel;
begin
   _m_sel:=0;

   if(544<m_vy)and(m_vy<571)then
   begin
      if(32 <m_vx)and(m_vx<107)then _m_sel:=1;     // exit
      if(net_nstat<>ns_clnt)then
       if(692<m_vx)and(m_vx<767)then _m_sel:=5;    // start
   end;

   //if(m_vy<65)and(m_vx>175)and(m_vx<625)then
   // if(G_Started=false)and(net_nstat=ns_none)and(menu_s2<>ms2_camp)and(g_mode=gm_scir)then _m_sel:=250; //random skir

   if(268<m_vy)and(m_vy<283)then
   begin
      if(net_nstat=ns_none)then
       if(not G_Started)then
        if(418<m_vx)and(m_vx<519)then _m_sel:=2;     // camps

      if not(G_Started and(menu_s2=ms2_camp))then
      begin
         if(518<m_vx)and(m_vx<621)then _m_sel:=3;    // scir
         if(620<m_vx)and(m_vx<724)then _m_sel:=4;    // multiplayer
      end;
   end;

   if(325<m_vy)and(m_vy<341)then
   begin
      if(78< m_vx)and(m_vx<177)then _m_sel:=6;       // settings

      if(net_nstat=ns_none)and(_rpls_rst<rpl_rhead)then
       if(180<=m_vx)and(m_vx<280)then _m_sel:=7;     // save load

      if(net_nstat=ns_none)then
       if(280<m_vx)and(m_vx<380)then _m_sel:=8;      // replays
   end;

   if(G_Started=false)then
   begin
      if(menu_s2=ms2_camp)then
       if(424<m_vx)and(m_vx<720)then
       begin
          if(286<m_vy)and(m_vy<=300)then _m_sel:=31; // defficulty
          if(300<m_vy)and(m_vy< 518)then _m_sel:=30; // missions
       end;

      if(432<m_vx)and(m_vx<535)then
       if(129<m_vy)and(m_vy<216)then _m_sel:=201+((m_vy-129) div 22);  //name

      if(net_nstat<>ns_clnt)then
      begin
         if(menu_s2<>ms2_camp)then
         begin
            if(248<m_vx)and(m_vx<368)then
            begin
               if(128<m_vy)and(m_vy<144)then _m_sel:=50; // map seed
               if(153<m_vy)and(m_vy<169)then _m_sel:=51; // map positions
               if(178<m_vy)and(m_vy<194)then _m_sel:=52; // map size
               if(203<m_vy)and(m_vy<219)then _m_sel:=53; // map liquid
               if(228<m_vy)and(m_vy<244)then _m_sel:=54; // map obstacles
               if(253<m_vy)and(m_vy<269)then _m_sel:=55; // random
            end;
         end;

         if(129<m_vy)and(m_vy<216)then
         begin
            if(538<m_vx)and(m_vx<557)then _m_sel:=211+((m_vy-129) div 22);  // < C P - ?
            if(576<m_vx)and(m_vx<635)then _m_sel:=221+((m_vy-129) div 22);  // race
            if(g_mode in [gm_scir,gm_ct])then
             if(654<m_vx)and(m_vx<673)then _m_sel:=231+((m_vy-129) div 22); // team
         end;
      end;
   end;

   if(menu_s2=ms2_scir)then
   begin
      if(468<m_vy)and(m_vy<484)then                                             // replays
      begin
         if(_rpls_rst<rpl_rhead )then if(432<m_vx)and(m_vx<491)then _m_sel:=80; // replay off/on
         if(_rpls_rst=rpl_none  )then if(507<m_vx)and(m_vx<632)then _m_sel:=82; // last replay name
      end;
      if(_rpls_rst=rpl_none  )then
       if(492<m_vy)and(m_vy<508)and(432<m_vx)and(m_vx<713)then _m_sel:=81;      // replay pnu

      // game options
      if(418<m_vx)and(m_vx<723)then
      begin
         if(net_nstat<>ns_clnt)and(not G_Started)then
         begin
            if(315<m_vy)and(m_vy<333)then _m_sel:=237;
            if(333<m_vy)and(m_vy<352)then _m_sel:=236;
            if(352<m_vy)and(m_vy<371)then _m_sel:=238;
            if(371<m_vy)and(m_vy<390)then _m_sel:=239;
            if(390<m_vy)and(m_vy<409)then _m_sel:=240;
         end;
         if(net_nstat=0)and(not G_Started)then
          if(409<m_vy)and(m_vy<428)then _m_sel:=250;
      end;
   end;

   if(menu_s2=ms2_mult)then
   begin
      if(net_nstat<>ns_none)then
      begin
         if(418<m_vx)and(m_vx<723)then
         begin
            if(507<m_vy)and(m_vy<523)then _m_sel:=28;     // open chat
         end;
         if(m_chat)then
          if(418<m_vx)and(m_vx<723)and(286<m_vy)and(m_vy<507)then _m_sel:=100;   // chat
      end;

      if(m_chat=false)then
      begin
         if(net_nstat<>ns_clnt)then
         begin
            if(not G_Started)then
             if(432<m_vx)and(m_vx<557)and(316<m_vy)and(m_vy<332)then _m_sel:=21; // sv up
         end;

         if(net_nstat=ns_none)then
         begin
            if(572<m_vx)and(m_vx<692)and(316<m_vy)and(m_vy<332)then _m_sel:=20; // udp port
            if(531<m_vx)and(m_vx<713)and(365<m_vy)and(m_vy<381)then _m_sel:=22; // sv addr
         end;

         if(net_nstat<>ns_srvr)then
         begin
            if(432<m_vx)and(m_vx<713)and(389<m_vy)and(m_vy<405)then _m_sel:=27; // PNU

            if(net_nstat=ns_clnt)or(G_Started=false)then
             if(432<m_vx)and(m_vx<529)and(365<m_vy)and(m_vy<381)then _m_sel:=26; // connect

            if(not G_Started)then
             if(413<m_vy)and(m_vy<429)then
             begin
                if(432<m_vx)and(m_vx<491)then _m_sel:=23; // team
                if(509<m_vx)and(m_vx<606)then _m_sel:=24; // race
                if(620<m_vx)and(m_vx<711)then _m_sel:=25; // ready
             end;
         end;
      end;
   end;

   if(menu_s1=ms1_sett)then
   begin
      if(198<m_vx)and(m_vx<325)and(444<m_vy)and(m_vy<460)then _m_sel:=12;   //scrl

      if(372<m_vy)and(m_vy<388)then
      begin
         if(90 <m_vx)and(m_vx<222)then _m_sel:=10;                          //snd
         if(237<m_vx)and(m_vx<369)then _m_sel:=11;                          //msc
      end;

      if(90 <m_vx)and(m_vx<325)and(420<m_vy)and(m_vy<436)then _m_sel:=188;  //mouse action invert

      if(468<m_vy)and(m_vy<484)then
      begin
         if(90 <m_vx)and(m_vx<210)then _m_sel:=13;                          //vid mmv
         if(228<m_vx)and(m_vx<326)then _m_sel:=14;                          //fscr
      end;

      if(396<m_vy)and(m_vy<412)then
      begin
         if(154<m_vx)and(m_vx<260)then _m_sel:=190;
         if(261<m_vx)and(m_vx<369)then
          if(vid_mw<>m_vrx)or(vid_mh<>m_vry)then _m_sel:=191;
      end;

      if(492<m_vy)and(m_vy<508)then
      begin
         if(net_nstat=ns_none)and(G_Started=false)then
          if(90<m_vx)and(m_vx<305)then _m_sel:=15;                          //pname

         if(320<m_vx)and(m_vx<369)then _m_sel:=187;                         //lng
      end;
   end;

   if(menu_s1=ms1_svld)then
   begin
      if(_svld_ln>0)then
       if(76<m_vx)and(m_vx<231)and(351<m_vy)and(m_vy<489)then _m_sel:=40; // save load

      if(76<m_vx)and(m_vx<381)then
      begin
         if(G_Started)then
          if(492<m_vy)and(m_vy<504)then _m_sel:=41;
         if(504<m_vy)and(m_vy<526)then
         begin
            _m_sel:=42+((m_vx-76) div 102);
            if( ((not G_Started)or(_svld_str=''))and(_m_sel=42))or((_svld_ls>=_svld_ln)and(_m_sel>42))then _m_sel:=0;
         end;
      end;
   end;

   if(menu_s1=ms1_reps)and(G_Started=false)then
   begin
      if(_rpls_ln>0)then
       if(76<m_vx)and(m_vx<231)and(351<m_vy)and(m_vy<489)then _m_sel:=45; // replays

      if(76<m_vx)and(m_vx<381)then
       if(504<m_vy)and(m_vy<526)then
        begin
           _m_sel:=46+((m_vx-76) div 102);
           if(_rpls_ls>=_rpls_ln)and(_m_sel>=46)then _m_sel:=0;
        end;
   end;
end;


procedure g_menu;
var p:byte;
begin
   dec(m_vx,mv_x);
   dec(m_vy,mv_y);

   if(k_ml=2)or(k_mr=2) then   //right or left click
   begin
      if(_m_sel=22)then net_cl_saddr;
      if(_m_sel=15)then _players[HPlayer].name:=PlayerName;
      c_m_sel;
      if not(_m_sel in [190,191])then begin m_vrx:=vid_mw;m_vry:=vid_mh; end;
      vid_mredraw:=true;
      PlaySNDM(snd_click);
   end;

   if(k_ml=2)then              // left button pressed
   begin
      if(_m_sel=1) then
       if(G_Started)
       then ToggleMenu
       else _CYCLE:=false;

      if(_m_sel=5) then _StartGame;    // start/break game

      if(_m_sel=2)then menu_s2:=ms2_camp;
      if(_m_sel=3)then begin p:=menu_s2;menu_s2:=ms2_scir;if(p=ms2_camp)then Map_premap;end;
      if(_m_sel=4)then begin menu_s2:=ms2_mult; _m_sel:=100; end;

      if(_m_sel=6)then menu_s1:=ms1_sett;
      if(_m_sel=7)then begin menu_s1:=ms1_svld; _svld_make_lst; end;
      if(_m_sel=8)then begin menu_s1:=ms1_reps; if(G_Started=false)then _rpls_make_lst; end;

      if(_m_sel=10)then begin if(m_vx>=142)then snd_svolume:=trunc((m_vx-142)/mmsndvlmx) else snd_svolume:=0; end;  //snd
      if(_m_sel=11)then begin if(m_vx>=289)then snd_mvolume:=trunc((m_vx-289)/mmsndvlmx) else snd_mvolume:=0; MIX_VOLUMEMUSIC(snd_mvolume); end;
      if(_m_sel=12)then vid_vmspd:=m_vx-198;  // scroll

      if(_m_sel=13)then vid_vmm:=not vid_vmm;
      if(_m_sel=14)then begin _fscr:=not _fscr; _MakeScreen;end;
      if(_m_sel=188)then m_a_inv:=not m_a_inv;
      if(_m_sel=187)then begin _lng:=not _lng;swLNG;end;

      if(_m_sel=21)then
      begin
         if(net_nstat=ns_srvr)then
         begin
            net_dispose;
            DefGameObjects;
            g_started:=false;
            net_nstat:=ns_none;
         end
         else
         begin
            net_nstat:=ns_srvr;
            if(net_UpSocket=false)then
            begin
               net_dispose;
               net_nstat:=ns_none;
            end
            else DefPlayers;
         end;
         menu_s1:=ms1_sett;
      end;

      if(_m_sel=23)then _scrollV(@PlayerTeam,1,1,MaxPlayers);
      if(_m_sel=24)then begin inc(PlayerRace,1); PlayerRace:=PlayerRace mod 3;end;
      if(_m_sel=25)then PlayerReady:=not PlayerReady;

      if(_m_sel=26)then
      begin
         if(net_nstat=ns_clnt)then
         begin
            net_plout;
            net_dispose;
            DefGameObjects;
            G_started  :=false;
            PlayerReady:=false;
            net_nstat  :=ns_none;
         end
         else
         begin
            net_nstat:=ns_clnt;
            if(net_UpSocket)
            then net_m_error:=str_connecting
            else
            begin
               net_dispose;
               net_nstat:=ns_none;
            end;
         end;
         menu_s1:=ms1_sett;
      end;

      if(_m_sel=27)then _scrollV(@net_pnui,1,0,4);
      if(_m_sel=28)then
      begin
         m_chat:=not m_chat;
         if(m_chat)then _m_sel:=100;
      end;

      if(_m_sel=30)then
      begin
         _cmp_sel:=_cmp_sm+((m_vy-300)div 14);
         if(_cmp_sel>=MaxMissions)then _cmp_sel:=MaxMissions-1;
      end;
      if(_m_sel=31)then
       if(cmp_skill<4)then inc(cmp_skill,1);

      if(_m_sel=40)then
      begin
         _svld_ls :=_svld_sm+((m_vy-351)div 14);
         _svld_sel;
      end;
      if(_m_sel=42)then _svld_save;
      if(_m_sel=43)then _svld_load;
      if(_m_sel=44)then _svld_delete;

      if(_m_sel=45)then
      begin
         _rpls_ls :=_rpls_sm+((m_vy-351)div 14);
         _rpls_sel;
      end;
      if(_m_sel=46)then
      begin
         menu_s2:=ms2_scir;
         _rpls_rst:=rpl_rhead;
         g_started:=true;
      end;
      if(_m_sel=48)then _rpls_delete;

      if(_m_sel=51)then begin _scrollV(@map_mw,500,MinSMapW,MaxSMapW); Map_premap;end;
      if(_m_sel=52)then begin _scrollV(@map_liq,1,0,4); Map_premap;end;
      if(_m_sel=53)then begin _scrollV(@map_obs,1,1,4); Map_premap;end;
      if(_m_sel=55)then begin Map_randommap; Map_premap;end;

      if(_m_sel=80)then
       if(_rpls_rst=rpl_none)
       then _rpls_rst:=rpl_whead
       else _rpls_rst:=rpl_none;

      if(_m_sel=81)then _scrollV(@_rpls_pnui,1,0,4);

      if(_m_sel=190)then
      begin
         if(m_vrx=800)and(m_vry=600)then
         begin
            m_vrx:=960;
            m_vry:=720;
         end
         else
           if(m_vrx=960)and(m_vry=720)then
           begin
              m_vrx:=1024;
              m_vry:=768;
           end
           else
           begin
              m_vrx:=800;
              m_vry:=600;
           end;
      end;
      if(_m_sel=191)then
      begin
         vid_mw:=m_vrx;
         vid_mh:=m_vry;

         calcVRV;
         _MakeScreen;
         _makeScrSurf;
         map_ptrt:=255;
         MakeTerrain;
      end;

      if(net_nstat<>ns_clnt)then
       if(_m_sel in [201..204])then _swAI(_m_sel-200);

      if(_m_sel in [211..214])then
      begin
         p:=_m_sel-210;
         if(p<>HPlayer)then
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
          if(state=ps_comp)or(p=HPlayer)then
          begin
             inc(Race,1);
             Race:=Race mod 3;
          end;
       end;
      if(_m_sel in [231..234])then
      begin
         p:=_m_sel-230;
         with _players[p] do
          if(state=ps_comp)or(p=HPlayer)then
           if(team<MaxPlayers)then
           begin
              inc(team,1);
           end;
      end;

      if(_m_sel=236)then
      begin
         inc(g_mode,1);
         g_mode:=g_mode mod 5;
         Map_premap;
      end;
      if(_m_sel=237)then begin g_addon:=not g_addon; end;
      if(_m_sel=238)then
      begin
         inc(g_loss,1);
         g_loss:=g_loss mod 3;
      end;
      if(_m_sel=239)then
      begin
         inc(g_starta,1);
         g_starta:=g_starta mod 4;
      end;
      if(_m_sel=240)then G_onebase:=not G_onebase;

      if(_m_sel=250)then MakeRandomSkirmish(false);
   end;

   if(k_mr=2)then    // right button pressed
   begin
      if(_m_sel=23)then _scrollV(@PlayerTeam,-1,1,MaxPlayers);
      if(_m_sel=27)then _scrollV(@net_pnui,-1,0,4);

      if(_m_sel=31)then _scrollV(@cmp_skill,-1,0,4);

      if(_m_sel=50)then begin Map_randomseed; Map_premap;end;
      if(_m_sel=51)then begin _scrollV(@map_mw,-500,MinSMapW,MaxSMapW); Map_premap;end;
      if(_m_sel=52)then begin _scrollV(@map_liq,-1,0,4); Map_premap;end;
      if(_m_sel=53)then begin _scrollV(@map_obs,-1,1,4); Map_premap;end;

      if(_m_sel=81)then _scrollV(@_rpls_pnui,-1,0,4);

      if(_m_sel in [201..204])then
       if(net_nstat=ns_clnt)
       then net_swapp(_m_sel-200)
       else _swapPlayers(_m_sel-200,HPlayer);

      if(_m_sel in [231..234])then
      begin
         p:=_m_sel-230;
         with _players[p] do
          if(state=ps_comp)or(p=HPlayer)then
           if(team>1)then
           begin
              dec(team,1);
           end;
       end;

      if(_m_sel=250)then MakeRandomSkirmish(true);
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
         map_seed:=s2w(menu_sf(w2s(map_seed),k_kbdig,10));
         map_premap;
      end;

      if(_m_sel=100)then net_chat_str:=menu_sf(net_chat_str,k_kbstr,ChatLen);

      vid_mredraw:=true;
   end;

   inc(m_vx,mv_x);
   inc(m_vy,mv_y);
end;

