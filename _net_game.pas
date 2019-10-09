

function NewP(sip:cardinal;sp:word):byte;
var i:byte;
begin
   NewP:=0;
   for i:=1 to MaxPlayers do
    if(i<>PlayerHuman)then
     with _Players[i] do
      if (state=PS_None) then
      begin
         nip  :=sip;
         nport:=sp;
         NewP :=i;
         state:=PS_Play;
         ttl  :=0;
         break;
      end;
end;

function A2P(sip:cardinal;sp:word):byte;
var i:byte;
begin
   A2P:=0;
   for i:=1 to MaxPlayers do
    if(i<>PlayerHuman)then
     with _Players[i] do
      if (state=PS_Play)and(nip=sip)and(nport=sp) then
      begin A2P:=i; ttl:=0; break;end;

   if (A2P=0)and(G_Started=false) then A2P:=NewP(sip,sp);
end;

procedure net_write_unit(u:integer;i,team:byte);
begin
   with _Units[u] do
   begin
      net_writeint(hits);
      if(hits>0) then
      begin
         net_writebyte(ucl);
         if(ucl=UID_FAPC)then net_writebyte(apcc);
         if(ucl in whocaninapc)then
         begin
            net_writeint(inapc);
            if(inapc>0)then exit;
         end;
         net_writeint (vx);
         net_writeint (vy);
         net_writeint (tar);
         if(isbuild)then
         begin
            net_writebool(bld);
            if(bld)and(radar)then
             if(_players[player].team=team)then
             begin
                net_writeint(rld);
                net_writeint(mx);
                net_writeint(my);
             end;
         end;
         if(player=i)then
         begin
            net_writebyte(order);
            net_writebool(sel);
            if(isbuild)then
            begin
               if(bld)then
                if(utp in [ut_1,ut_3])then
                begin
                   net_writeint(rld);
                   net_writebyte(utrain);
                end;
               if(utp=ut_1)or(ucl=UID_HellTeleport)or(ucl=UID_HellBarracks)then
               begin
                  net_writeint(mx);
                  net_writeint(my);
               end;
            end;
         end;
      end;
   end;
end;




procedure _netserver;
var mid,pid,i,o:byte;
        p:cardinal;
begin
   net_clearbuffer;

   while (net_Receive>0) do
   begin
      mid:=net_readbyte;

      if(mid=66)then
      begin
         net_clearbuffer;
         net_writebyte(66);
         net_writebool(g_started);
         net_writebyte(G_Mode);
         for i:=1 to MaxPlayers do
          with _players[i] do
          begin
             net_writestring(name);
             net_writebyte(race);
             net_writebyte(team);
          end;
         net_send(net_lastinip,net_lastinport);
         continue;
      end;

      pid:=A2P(net_lastinip,net_lastinport);
      if(pid=0) then
      begin
         net_clearbuffer;
         if(g_started)
         then net_writebyte(nmid_sgst)
         else net_writebyte(nmid_sfull);
         net_send(net_lastinip,net_lastinport);
         continue;
      end;

      if(mid=nmid_chat)then   // chat
      begin
         _lg_c_add(chr(pid)+net_readstring);
      end;

      if (mid=nmid_connect) then // player info
      begin
         i:=net_readbyte;
         if(i<>ver)then
         begin
            net_clearbuffer;
            net_writebyte(nmid_sver);
            net_send(net_lastinip,net_lastinport);
            _Players[pid].state:=PS_none;
            continue;
         end;

         if (G_Started=false) then
         begin
            with _Players[pid] do
            begin
               name :=net_readstring;
               if(g_mode in [gm_2fort,gm_inv])
               then net_readbyte
               else team :=net_readbyte;
               race :=net_readbyte;
               ready:=net_readbool;
               p:=net_readcard;
               if(lg_c<=p)and(p<=net_lg_ci)then lg_c:=p;
               nnu:=net_readbyte;
               if(nnu<PNU_min)then nnu:=PNU_min;
               nur:=net_readbyte;
               if(nur<2)then nur:=2;
               if(nur>4)then nur:=4;
               vid_mredraw:=true;
            end;

            net_clearbuffer;
            net_writebyte(nmid_players);
            for i:=1 to MaxPlayers do
             with _Players[i] do
             begin
                net_writestring(name);
                net_writebyte(team);
                net_writebyte(race);
                net_writebyte(state);
                net_writebool(ready);
                net_writeint (ttl);
             end;

             net_writebyte(pid);
             net_writebyte(PlayerHuman);

             net_writeint (map_mw);
             net_writebyte(map_pos);
             net_writebool(map_liq);
             net_writebyte(map_obs);
             net_writecard(map_seed);
             net_writebyte(g_mode);
         end else
         begin
            net_clearbuffer;
            net_writebyte(nmid_rshap);

            for i:=1 to MaxPlayers do
             with _Players[i] do
             begin
                net_writestring(name);
                net_writebyte(team);
                net_writebyte(race);
                net_writebyte(state);
             end;

            net_writebyte(pid);
            net_writebyte(PlayerHuman);

            net_writeint (map_mw);
            net_writebyte(map_pos);
            net_writebool(map_liq);
            net_writebyte(map_obs);
            net_writecard(map_seed);
            net_writebyte(g_mode);
         end;

         with _Players[pid] do net_send(nip,nport);
      end;

      if(g_Started=true)then
      begin
         if(mid=nmid_clord)then
         begin
            with _Players[pid]do
            begin
               o_x0:=net_readInt;
               o_y0:=net_readInt;
               o_x1:=net_readInt;
               o_y1:=net_readInt;
               o_id:=net_readbyte;
            end;
         end;

         if (mid=nmid_rshap) then
          with _Players[pid] do
          begin
             nnu:=net_readbyte;
             if(nnu<PNU_min)then nnu:=PNU_min;

             nur:=net_readbyte;
             if(nur<2)then nur:=2;
             if(nur>4)then nur:=4;

             p:=net_readcard;
             if(lg_c<=p)and(p<=net_lg_ci)then lg_c:=p;
          end;

         if (mid=nmid_pause)then
         begin
            if(G_Paused=pid)
             then G_Paused:=0
             else if(G_Paused<>PlayerHuman)then G_Paused:=pid;
         end;

      end else
      begin
         if (mid=nmid_swapp) then
         begin
            i:=net_readbyte;
            _swapPlayers(i,pid);
         end;

         if (mid=nmid_rshap) then
         begin
            net_clearbuffer;
            net_writebyte(nmid_nbegin);
            net_send(net_lastinip,net_lastinport);
         end;
      end;
   end;


   for i:=1 to MaxPlayers do
    if(i<>PlayerHuman)then
     with _Players[i] do
      if (state=PS_Play)and(ttl<ClientTTL) then
      begin
         if(G_Started)and((prdc_units mod nur)=0)then
         begin
            net_clearbuffer;
            net_writebyte(nmid_shap);

            net_writebyte(G_Paused);
            if(G_Paused=0)then
            begin
               net_writebyte(nur);
               net_writecard(G_Step);
               if(G_step mod 15)=0 then
               begin
                  for o:=1 to MaxPlayers do  _net_writeupgrs(o);  /////////////

                  net_writebyte(bld_r);
                  net_writebyte(menerg);
                  net_writebyte(cenerg);
                  net_writebyte(wb);
                  net_writebool(hcmp);
                  net_writeint(u0);
                  net_writeint(u1);
                  net_writeint(u3);
                  net_writeint(u5);
                  net_writeint(hptm);

                  if(g_mode=gm_inv)then
                  begin
                     net_writebyte(g_inv_w);
                     net_writeint(g_inv_t);
                  end;
                  if(g_mode=gm_ct)then
                   for o:=1 to MaxPlayers do
                    net_writebyte(g_pt[o].p);
               end;

               if(n_u<101)then n_u:=101;

               net_writebyte(nnu);
               net_writeint(n_u);
               for o:=1 to nnu do
               begin
                  inc(n_u,1);
                  if(n_u>MaxUnits) then n_u:=101;

                  net_write_unit(n_u,i,team);

                  if(n_u=101)then
                   if(g_mode=gm_inv)then
                    for mid:=1 to inv_mon do net_write_unit(mid,i,team);
               end;
            end;
            net_send(nip,nport);
         end;

         if(prdc_units=0)then
          if(lg_c<net_lg_ci)then
          begin
             net_clearbuffer;
             net_writebyte(nmid_chat);

             if(net_lg_ci>lg_c)
             then p:=net_lg_ci-lg_c
             else p:=0;

             if(p>net_lg_cs)then p:=net_lg_cs;

             if(p>0)then
             begin
                net_writecard(net_lg_ci);
                net_writebyte(p);

                for o:=1 to p do net_writestring(net_lg_c [p-o]);
                net_send(nip,nport);
             end;
          end;
      end;
end;

procedure net_readunit(u:integer);
begin
   _Units[0]:=_Units[u];
   with _Units[u] do
   begin
      hits:=net_readint;
      if(hits>0)then
      begin
         player:=(u-1)div MaxPlayerUnits;
         ucl   :=net_readbyte; _unit_sclass(u);
         if(ucl=UID_FAPC)then apcc:=net_readbyte;
         if(ucl in whocaninapc)then
         begin
            inapc:=net_readint;
            if(inapc>0)then
            begin
               _netSetUcl(u);
               exit;
            end;
         end;
         x     :=net_readint;
         y     :=net_readint;
         tar   :=net_readint;
         if(isbuild)then
         begin
            bld:=net_readbool;
            if(bld)and(radar)then
             if(_players[player].team=_players[PlayerHuman].team)then
             begin
                rld:=net_readint;
                mx:=net_readint;
                my:=net_readint;
             end;
         end;
         if(player=PlayerHuman)then
         begin
            order:=net_readbyte;
            sel  :=net_readbool;
            if(isbuild)then
            begin
               if(bld)then
                if(utp in [ut_1,ut_3])then
                begin
                   rld:=net_readint;
                   utrain:=net_readbyte;
                end;
               if(utp=ut_1)or(ucl=UID_HellTeleport)or(ucl=UID_HellBarracks)then
               begin
                  mx:=net_readint;
                  my:=net_readint;
               end;
            end;
         end;
      end;
   end;
   _netSetUcl(u);
end;

procedure _netClient;
var mid,i,l:byte;
        t:cardinal;
begin
   net_clearbuffer;
   while (net_Receive>0) do
   begin
      mid:=net_readbyte;

      if (mid=nmid_sfull) then
      begin
         net_m_error:=str_sfull;
         vid_mredraw:=true;
      end;

      if (mid=nmid_sver) then
      begin
         net_m_error:=str_sver;
         vid_mredraw:=true;
      end;

      if (mid=nmid_sgst) then
      begin
         net_m_error:=str_sgst;
         vid_mredraw:=true;
      end;

      if (mid=nmid_players) then // players and other info
      begin
         for i:=1 to MaxPlayers do
          with _Players[i] do
          begin
             name :=net_readstring;
             team :=net_readbyte;
             race :=net_readbyte;
             state:=net_readbyte;
             ready:=net_readbool;
             ttl  :=net_readint;
          end;

         PlayerHuman:=net_readbyte;
         net_cl_svpl:=net_readbyte;

         map_mw  :=net_readint;
         map_pos :=net_readbyte;
         map_liq :=net_readbool;
         map_obs :=net_readbyte;
         map_seed:=net_readcard;
         g_mode  :=net_readbyte;
         g_premap;

         vid_mredraw:=true;
         net_cl_svttl:=0;
         net_m_error:='';
      end;

      if(mid=nmid_chat)then // chat
      begin
         t:=net_readcard;
         if(t>net_lg_ci)then
         begin
            i:=net_readbyte;
            for l:=1 to i do _lg_c_add(net_readstring);
            net_lg_ci:=t;
            net_cl_svttl:=0;
         end;
      end;

      if (mid=nmid_shap) then // units
      with _Players[PlayerHuman] do
      begin
         net_cl_svttl:=0;

         G_paused:=net_readbyte;

         if(G_paused=0)then
         begin
            nur:=net_readbyte;
            G_Step  :=net_readcard;

            if(G_step mod 15)=0 then
            begin
               for l:=1 to MaxPlayers do _net_readupgrs(l);

               bld_r:=net_readbyte;
               menerg:=net_readbyte;
               cenerg:=net_readbyte;
               wb:=net_readbyte;
               hcmp:=net_readbool;
               u0:=net_readint;
               u1:=net_readint;
               u3:=net_readint;
               u5:=net_readint;
               n_u:=net_readint;
               if(hptm=0)and(n_u>0)then PlaySNDM(snd_hell);
               hptm:=n_u;
               if(g_mode=gm_inv)then
               begin
                  g_inv_w:=net_readbyte;
                  g_inv_t:=net_readint;
               end;
               if(g_mode=gm_ct)then
                for l:=1 to MaxPlayers do
                 g_pt[l].p:=net_readbyte;
            end;

            n_u:=net_readbyte;
            if(n_u<>nnu)then
            begin
               nnu:=n_u;
               if(nnu=0)then nnu:=1;
               UnitStepNumNet:=trunc(CLUnits/nnu)*nur;
            end;

            n_u:=net_readint;
            for i:=1 to nnu do
            begin
               inc(n_u,1);
               if(n_u>MaxUnits) then n_u:=101;

               net_readunit(n_u);

               if(n_u=101)then
                if(g_mode=gm_inv)then
                 for l:=1 to inv_mon do net_readunit(l);
            end;
         end;
      end;

      if(mid=nmid_rshap) then
      begin
         for l:=1 to MaxPlayers do
          with _Players[l] do
          begin
             name :=net_readstring;
             team :=net_readbyte;
             race :=net_readbyte;
             state:=net_readbyte;
          end;
         PlayerHuman:=net_readbyte;
         net_cl_svpl:=net_readbyte;

         map_mw  :=net_readint;
         map_pos :=net_readbyte;
         map_liq :=net_readbool;
         map_obs :=net_readbyte;
         map_seed:=net_readcard;
         g_mode  :=net_readbyte;
         g_premap;

         G_Started:=true;
         _menu:=false;
         net_cl_svttl:=0;
         onlySVCode:=false;
      end;

      if(mid=nmid_nbegin)and(G_Started=true)then
      begin
         net_cl_svttl:=0;
         G_Started:=false;
         _menu:=true;
         DefGameObjects;
      end;
   end;


   if (prdc_units=0) then
   begin
      net_clearbuffer;
      if (G_Started=false) then
      begin
         net_writebyte  (nmid_connect);
         net_writebyte  (ver);
         net_writestring(PlayerName);
         net_writebyte  (PlayerTeam);
         net_writebyte  (PlayerRace);
         net_writebool  (PlayerReady);
         net_writecard  (net_lg_ci);
         net_writebyte  (PlayerNUnits);
         net_writebyte  (PlayerNUR);
      end else
      begin
         net_writebyte(nmid_rshap);
         net_writebyte(PlayerNUnits);
         net_writebyte(PlayerNUR);
         net_writecard(net_lg_ci);
      end;
      net_send(net_cl_svip,net_cl_svport);
   end;

   if(net_cl_svttl<ClientTTL)then inc(net_cl_svttl,1);
end;


