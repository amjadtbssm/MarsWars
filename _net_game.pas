
function NewP(sip:cardinal;sp:word):byte;
var i:byte;
begin
   NewP:=0;
   for i:=1 to MaxPlayers do
    if(i<>HPlayer)then
     with _Players[i] do
      if(state=PS_None)then
      begin
         nip   := sip;
         nport := sp;
         NewP  := i;
         state := PS_Play;
         ttl   := 0;
         break;
      end;
end;

function A2P(sip:cardinal;sp:word;crtn:boolean):byte;
var i:byte;
begin
   A2P:=0;
   for i:=1 to MaxPlayers do
    if(i<>HPlayer)then
     with _Players[i] do
      if(state=PS_Play)and(nip=sip)and(nport=sp)then
      begin A2P:=i; ttl:=0; break;end;

   if(A2P=0)and(G_Started=false)and(crtn)then A2P:=NewP(sip,sp);
end;

procedure net_write_unit(u:integer;i,pteam:byte);
begin
   with _units[u] do
   begin
      net_writeint(hits);
      if(hits>dead_hits)then
      begin
         net_writebyte(uid);
         net_writebyte(buff2byte(u));
         if(hits>0)then
         begin
            if(uid in whocanattack)then net_writeint(tar1);
            if(uid in whoapc)then net_writebyte(apcc);
            if(uid in whocaninapc)then net_writeint(inapc);
            if(inapc>0)then exit;
            net_writeint(vx);
            net_writeint(vy);
            if(isbuild)then
            begin
               net_writebool(bld);
               if(bld)then
               begin
                  if(uid=UID_URadar)then
                   if(_players[player].team=pteam)then
                   begin
                      net_writeint(rld);
                      if(rld>=radar_time)then
                      begin
                         net_writeint(uo_x);
                         net_writeint(uo_y);
                      end;
                   end;
                  if(uid=UID_URocketL)then
                  begin
                     net_writeint(rld);
                     if(rld>0)then
                     begin
                        net_writeint(uo_x);
                        net_writeint(uo_y);
                     end;
                  end;
               end;
            end;
            if(player=i)then
            begin
               net_writebyte(order);
               net_writebool(sel);
               if(isbuild)then
               begin
                  if(bld)then
                  begin
                     if(uid in [UID_HGate,UID_HPools,UID_UMilitaryUnit,UID_HMilitaryUnit,UID_UWeaponFactory,UID_UVehicleFactory])then net_writeint(rld);
                     if(uid in [UID_HGate,UID_HPools,UID_UMilitaryUnit,UID_HMilitaryUnit,UID_UWeaponFactory,UID_HMonastery])then net_writebyte(utrain);
                  end;
                  if(uid in whocanmp)then
                  begin
                     net_writeint(uo_x);
                     net_writeint(uo_y);
                  end;
               end;
            end;
         end
         else
         begin
            if(hits>-100)then
            begin
               net_writeint(vx);
               net_writeint(vy);
            end;
         end;
      end;
   end;
end;



procedure net_GServer;
var mid,pid,i,n,o:byte;
    gstp:cardinal;
begin
   net_clearbuffer;

   while(net_Receive>0)do
   begin
      mid:=net_readbyte;

      if(mid=nmid_getinfo)then
      begin
         net_clearbuffer;
         net_writebyte(nmid_getinfo);
         net_writebyte(ver);
         net_writebool(g_started);
         net_writebool(g_addon);
         net_writebyte(g_mode);
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

      if(mid=nmid_connect)then
      begin
         i:=net_readbyte;
         if(i<>ver)then
         begin
            net_clearbuffer;
            net_writebyte(nmid_sver);
            net_send(net_lastinip,net_lastinport);
            continue;
         end;
         pid:=A2P(net_lastinip,net_lastinport,true);
         if(pid=0) then
         begin
            net_clearbuffer;
            if(g_started)
            then net_writebyte(nmid_sgst)
            else net_writebyte(nmid_sfull);
            net_send(net_lastinip,net_lastinport);
            continue;
         end;

         if(G_Started=false)then
          with _Players[pid] do
          begin
             name :=net_readstring;
             if(g_mode in [gm_2fort,gm_inv,gm_coop])
             then i:=net_readbyte
             else team :=net_readbyte;
             race :=net_readbyte;
             ready:=net_readbool;
             nchs :=net_readbyte;
             PNU  :=net_readbyte;
             vid_mredraw:=true;
          end;

         net_clearbuffer;
         net_writebyte(nmid_startinf);
         net_writebool(G_Started);
         for i:=1 to MaxPlayers do
          with _Players[i] do
          begin
             net_writestring(name);
             net_writebyte  (team);
             net_writebyte  (race);
             net_writebyte  (state);
             net_writebool  (ready);
             net_writeint   (ttl);
          end;

         net_writebyte(pid);
         net_writebyte(HPlayer);

         net_writeint (map_mw);
         net_writebyte(map_liq);
         net_writebyte(map_obs);
         net_writeword(map_seed);
         net_writebool(g_addon);
         net_writebyte(g_mode);
         net_writebyte(g_loss);
         net_writebyte(g_starta);
         net_writebool(g_onebase);

         net_send(net_lastinip,net_lastinport);
      end
      else   // other net mess
      begin
         pid:=A2P(net_lastinip,net_lastinport,false);
         if(pid>0)then
         begin
            if(mid=nmid_chat)then
            begin
               net_chat_add(chr(pid)+net_readstring);    // chat
               if(_ded)and(G_Started=false)then _parseCmd(net_chat[0],pid);
            end;

            if(mid=nmid_plout)then
            begin
               net_chat_add(_players[pid].name+str_plout);
               //_kill_player(pid);
               if(G_Started=false)then _players[pid].state:=ps_none;
               exit;
            end;

            if(G_Started)then
            begin
               if(mid=nmid_order)then
                with _players[pid]do
                begin
                   o_x0:=net_readint;
                   o_y0:=net_readint;
                   o_x1:=net_readint;
                   o_y1:=net_readint;
                   o_id:=net_readbyte;
                end;

               if(mid=nmid_clinf) then
                with _players[pid] do
                begin
                   PNU :=net_readbyte;
                   nchs:=net_readbyte;
                end;

               if(mid=nmid_pause)then
               begin
                  if(G_Paused=pid)
                  then G_Paused:=0
                  else
                    if(G_Paused<>HPlayer)or(G_Paused=0)then G_Paused:=pid;
                  if(_ded)then vid_mredraw:=true;
               end;
            end
            else
            begin
               if(mid=nmid_swapp)then
               begin
                  i:=net_readbyte;
                  _swapPlayers(i,pid);
               end;
            end;
         end
         else
         begin
            net_clearbuffer;
            net_writebyte(nmid_ncon);
            net_send(net_lastinip,net_lastinport);
         end;
      end;
   end;

   for i:=1 to MaxPlayers do
    if(i<>HPlayer)then
     with _players[i] do
      if(state=PS_Play)and(ttl<ClientTTL)then
      begin
         if(G_Started)and((net_period mod NetTickN)=0)then
         begin
            net_clearbuffer;
            net_writebyte(nmid_shap);
            net_writebyte(G_Paused);
            if(G_Paused=0)then
            begin
               net_writecard(G_Step);

               gstp:=G_Step shr 1;
               if((gstp mod vid_hhfps)=0)then
               begin
                  net_writebyte(bld_r);
                  net_writebyte(menerg);
                  net_writebyte(cenerg);
                  net_writebyte(wb);
                  net_writebool(wbhero);
                  net_writebyte(bldrs);
               end;
               if((gstp mod vid_hfps)=0)then
               begin
                  net_writeint(ubx[1]);
                  net_writeint(ubx[3]);
                  net_writeint(ubx[5]);
                  net_writeint(ubx[6]);
                  net_writeint(ubx[8]);

                  if(g_mode=gm_inv)then
                  begin
                     net_writebyte(g_inv_wn);
                     net_writeint(g_inv_t);
                  end;
                  if(g_mode=gm_ct)then
                   for o:=1 to MaxPlayers do
                    net_writebyte(g_ct_pl[o].pl);

                  for o:=0 to MaxPlayers do
                   for n:=0 to _uts do net_writebyte(_players[o].upgr[n]);
               end;

               if(n_u<1)then n_u:=1;

               net_writebyte(PNU);
               net_writeint(n_u);
               for o:=1 to PNU do
               begin
                  inc(n_u,1);
                  if(n_u>MaxUnits) then n_u:=1;

                  net_write_unit(n_u,i,team);
               end;
            end
            else net_writebyte(G_WTeam);
            net_send(nip,nport);
         end;

         if(net_period=i)and(nchs<>net_chat_s)then
         begin
            net_clearbuffer;
            net_writebyte(nmid_chatclupd);
            net_writebyte(net_chat_s);
            net_writechat;
            net_send(nip,nport);
         end;
      end;

   inc(net_period,1);
   net_period:=net_period mod vid_hfps;
end;

procedure net_readunit(u:integer);
begin
   _units[0]:=_units[u];
   with _units[u] do
   begin
      player:=(u-1) div MaxPlayerUnits;
      hits:=net_readint;
      if(hits>dead_hits)then
      begin
         uid:=net_readbyte;
         _unit_sclass(@_units[u]);
         byte2buff(u,net_readbyte);
         if(hits>0)then
         begin
            if(uid in whocanattack)then tar1:=net_readint;
            if(uid in whoapc)then apcc:=net_readbyte;
            if(uid in whocaninapc)then
            begin
               inapc:=net_readint;
               if(inapc>0)then
               begin
                  _netSetUcl(u);
                  exit;
               end;
            end;
            x:=net_readint;
            y:=net_readint;
            if(isbuild)then
            begin
               bld:=net_readbool;
               if(bld)then
               begin
                  if(uid=UID_URadar)then
                   if(_players[player].team=_players[HPLayer].team)then
                   begin
                      rld:=net_readint;
                      if(rld>=radar_time)then
                      begin
                         uo_x:=net_readint;
                         uo_y:=net_readint;
                      end;
                   end;
                  if(uid=UID_URocketL)then
                  begin
                     bld_s:=net_readint;
                     if(rld=0)then rld:=bld_s;
                     if(bld_s>0)then
                     begin
                        uo_x:=net_readint;
                        uo_y:=net_readint;
                     end;
                  end;
               end;
            end;
            if(player=HPlayer)then
            begin
               order:=net_readbyte;
               sel  :=net_readbool;
               if(isbuild)then
               begin
                  if(bld)then
                  begin
                     if(uid in [UID_HGate,UID_HPools,UID_UMilitaryUnit,UID_HMilitaryUnit,UID_UWeaponFactory,UID_UVehicleFactory])then rld:=net_readint;
                     if(uid in [UID_HGate,UID_HPools,UID_UMilitaryUnit,UID_HMilitaryUnit,UID_UWeaponFactory,UID_HMonastery])then utrain:=net_readbyte;
                  end;
                  if(uid in whocanmp)then
                  begin
                     uo_x:=net_readint;
                     uo_y:=net_readint;
                  end;
               end;
            end;
         end
         else
         begin
            if(hits>-100)then
            begin
               net_writeint(vx);
               net_writeint(vy);
            end;
         end;
      end;
   end;
   _netSetUcl(u);
end;

procedure net_GClient;
var mid,i,n:byte;
    gst:boolean;
    gstp:cardinal;
begin
   net_clearbuffer;
   while(net_Receive>0)do
   if(net_lastinip=net_cl_svip)and(net_lastinport=net_cl_svport)then
   begin
      net_cl_svttl:=0;
      mid:=net_readbyte;

      if(mid=nmid_sfull) then
      begin
         net_m_error:=str_sfull;
         vid_mredraw:=true;
      end;

      if(mid=nmid_sver) then
      begin
         net_m_error:=str_sver;
         vid_mredraw:=true;
      end;

      if(mid=nmid_sgst) then
      begin
         net_m_error:=str_sgst;
         vid_mredraw:=true;
      end;

      if(mid=nmid_ncon)then
      begin
         G_Started:=false;
         _menu:=true;
         PlayerReady:=false;
         DefGameObjects;
      end;

      if(mid=nmid_chatclupd)then
      begin
         i:=net_readbyte;
         if(net_chat_s<>i)then
         begin
            PlaySNDM(snd_chat);
            _rpls_nwrch:=true;
         end;
         net_chat_s:=i;
         net_readchat;
         net_chat_shlm:=chat_shlm_t;
      end;

      if(mid=nmid_startinf)then
      begin
         gst:=net_readbool;

         for i:=1 to MaxPlayers do
          with _Players[i] do
          begin
             name := net_readstring;
             team := net_readbyte;
             race := net_readbyte;
             state:= net_readbyte;
             ready:= net_readbool;
             ttl  := net_readint;
          end;

         HPlayer:=net_readbyte;
         net_cl_svpl:=net_readbyte;

         map_mw   := net_readint;
         map_liq  := net_readbyte;
         map_obs  := net_readbyte;
         map_seed := net_readword;
         g_addon  := net_readbool;
         g_mode   := net_readbyte;
         g_loss   := net_readbyte;
         g_starta := net_readbyte;
         g_onebase:= net_readbool;

         Map_premap;
         net_m_error:='';

         if(gst<>G_Started)then
         begin
            G_Started:=gst;
            if(G_Started)then
            begin
               _menu:=false;
               onlySVCode:=false;
               if(g_mode=gm_coop)then _make_coop;
               _moveHumView(map_psx[HPlayer] , map_psy[HPlayer]);
            end
            else
            begin
               _menu:=true;
               PlayerReady:=false;
               DefGameObjects;
            end;
         end;
      end;

      if(G_Started)then
      begin
         if(mid=nmid_shap)then
         with _players[HPlayer] do
         begin
            G_paused:=net_readbyte;

            if(G_paused=0)then
            begin
               G_Step  :=net_readcard;

               gstp:=G_Step shr 1;
               if((gstp mod vid_hhfps)=0)then
               begin
                  bld_r  := net_readbyte;
                  menerg := net_readbyte;
                  cenerg := net_readbyte;
                  wb     := net_readbyte;
                  wbhero := net_readbool;
                  bldrs  := net_readbyte;
               end;
               if((gstp mod vid_hfps)=0)then
               begin
                  ubx[1] := net_readint;
                  ubx[3] := net_readint;
                  ubx[5] := net_readint;
                  ubx[6] := net_readint;
                  ubx[8] := net_readint;

                  if(g_mode=gm_inv)then
                  begin
                     g_inv_wn:=net_readbyte;
                     g_inv_t :=net_readint;
                  end;
                  if(g_mode=gm_ct)then
                   for i:=1 to MaxPlayers do
                    g_ct_pl[i].pl:=net_readbyte;

                  for i:=0 to MaxPlayers do
                   for n:=0 to _uts do _players[i].upgr[n]:=net_readbyte;
               end;

               n_u:=net_readbyte;
               if(n_u<>PNU)then
               begin
                  PNU:=n_u;
                  if(PNU=0)then PNU:=NetTickN;
                  UnitStepNum:=trunc(MaxUnits/PNU)*NetTickN;
                  if(UnitStepNum=0)then UnitStepNum:=1;
               end;

               n_u:=net_readint;
               for i:=1 to PNU do
               begin
                  inc(n_u,1);
                  if(n_u>MaxUnits) then n_u:=1;

                  net_readunit(n_u);
               end;
            end
            else G_WTeam:=net_readbyte;
         end;
      end;
   end;

   if(net_period=0)then
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
         net_writebyte  (net_chat_s);
         net_writebyte  (_net_pnua[net_pnui]);
      end
      else
      begin
         net_writebyte(nmid_clinf);
         net_writebyte(_net_pnua[net_pnui]);
         net_writebyte(net_chat_s);
      end;
      net_send(net_cl_svip,net_cl_svport);
   end;

   inc(net_period,1);net_period:=net_period mod vid_hfps;
   if(net_cl_svttl<ClientTTL)then
   begin
      inc(net_cl_svttl,1);
      if(net_cl_svttl=vid_fps)then vid_mredraw:=true;
      if(net_cl_svttl=ClientTTL)then G_Paused:=net_cl_svpl;
   end;
end;



