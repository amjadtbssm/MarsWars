
procedure _playersCycle;
var p:byte;
begin
   for p:=1 to MaxPlayers do
   begin
      with _players[p] do
       if (state<>PS_None) then
       begin
          if (state=PS_Play) then
           if (ttl<ClientTTL)then
           begin
              Inc(ttl,1);
           end
           else
             if(G_Started=false)then
             begin
                state:=PS_None;
                _playerSetState(p);
                writeln('Player out: #',p,' ',c2ip(nip),':',w2s(swap(nport)));
             end;

          if(G_Started)and(G_paused=0)then
          begin
             _u_ord(p);

             if(g_mode<>gm_inv)then
              if(state=PS_Comp)then
               if(army>20)and(ai_minpush<60)then ai_minpush:=60+random(ai_maxarmy-60);

             if(bld_r>0)then dec(bld_r,1);

             if(hptm>0)and(race=r_hell)then
             begin
                dec(hptm,1);
                if(hptm=0)then upgr[6]:=0;
             end;
          end;
       end;
   end;
end;

procedure g_inv_spawn;
var i:byte;
tx,ty:integer;
begin
   if(g_inv_t>0)then
    if(_players[0].army=0)then dec(g_inv_t,1);
   if(g_inv_t=0)and(g_inv_w<=inv_wvs)then
   begin
      _players[0].hptm:=hp_time;
      _players[0].upgr[6]:=1;
      g_inv_t:=inv_per+(g_inv_w+1)*vid_fps*2;
      inc(g_inv_w,1);
      if(g_inv_w>0)then
       for i:=1 to inv_mon do
        if(_players[0].army<inv_mon)then
        begin
           tx:=map_psx[0]-base_r+random(base_rr);
           ty:=map_psy[0]-base_r+random(base_rr);
           case g_inv_w of
           1: _unit_add(tx,ty,zimba[i mod 6],0);
           2: if(i mod 2)=0
              then _unit_add(tx,ty,UID_Cacodemon,0)
              else _unit_add(tx,ty,UID_ZFPlasma,0);
           else
             if(i<g_inv_w)then
              if(i mod 2)=0
              then _unit_add(tx,ty,UID_CyberDemon,0)
              else _unit_add(tx,ty,UID_Mastermind,0)
             else
              if(i mod 2)=0
              then _unit_add(tx,ty,UID_ZFPlasma,0)
              else _unit_add(tx,ty,UID_Cacodemon,0);
           end;
           with _units[_lau] do
           begin
              painc :=10*g_inv_w;
              order :=1;
           end;
        end;
   end;
end; 

procedure CGame;
begin
   inc(prdc_units,1);
   prdc_units:=prdc_units mod _units_period;

   if(prdc_units=0)then _StartStopGame;

   _playersCycle;

   if(G_Started)and(G_paused=0)then
   begin
      _regen:=(G_Step mod regen_period);
      _unitsCycle;
      _missile_cycle;
      inc(G_Step,1);
      if(g_mode=gm_inv)then g_inv_spawn;
   end;

   _netServer;
end;



