
function c2ip(c:cardinal):string;
begin
   c2ip:=b2s(c and $FF )+'.'+b2s((c and $FF00) shr 8)+'.'+b2s((c and $FF0000) shr 16)+'.'+b2s((c and $FF000000) shr 24);
end;

function NewP(sip:cardinal;sp:word):byte;
var i:byte;
begin
   NewP:=0;
   for i:=1 to MaxPlayers do
    with _Players[i] do
      if (state=PS_None) then
      begin
         nip  :=sip;
         nport:=sp;
         NewP :=i;
         state:=PS_Play;
         ttl  :=0;
         writeln('New player: #',i,' ',c2ip(nip),':',swap(nport));
         break;
      end;
end;

function A2P(sip:cardinal;sp:word):byte;
var i:byte;
begin
   A2P:=0;
   for i:=1 to MaxPlayers do
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
        s:string;
begin
   net_clearbuffer;

   while (net_Receive>0) do
   begin
      mid:=net_readbyte;

      {if(mid=166)then
      begin
         _warpten:=net_readbool;
         _fsttime:=net_readbool;
      end;  }

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
         s:=net_readstring;
         _lg_c_add(chr(pid)+s);
        // if(s='f')then _fsttime:=not _fsttime;
         if(G_Started=false)then _parseCmd(s,pid);
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
            if(G_Paused>0)
             then G_Paused:=0
             else G_Paused:=pid;
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
                  for o:=1 to MaxPlayers do  _net_writeupgrs(o);

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

