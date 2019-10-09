
procedure _playersCycle;
var p:byte;
    ea,aa:integer;
begin
   ea:=0;
   aa:=0;
   for p:=0 to MaxPlayers do
   begin
      with _players[p] do
       if (state<>PS_None) then
       begin
          if (state=PS_Play)and(p<>PlayerHuman)and(net_sv_up) then
          begin
             if (ttl<ClientTTL)then
             begin
                Inc(ttl,1);
                if(ttl=ClientTTL)then vid_mredraw:=true;
             end
             else
               if(G_Started=false)then
               begin
                  state:=PS_None;
                  _playerSetState(p);
                  vid_mredraw:=true;
               end;
          end;

          if(G_Started)and(_rpls_rst<rpl_rhead)then
          begin
             if(G_Paused=0)then
             begin
                _u_ord(p);

                if(g_mode<>gm_inv)then
                 if(state=PS_Comp)and(_mmode<>mm_camp)then
                  if(army>20)and(ai_minpush<60)then ai_minpush:=60+random(ai_maxarmy-60);

                if(bld_r>0)then dec(bld_r,1);

                if(onlySVCode)then
                if(race=r_hell)then
                begin
                   if not(3 in alw_b)
                   then hptm:=0
                   else
                     if(hptm>0)then
                     begin
                        dec(hptm,1);
                        if(hptm=0)then upgr[upgr_hpower]:=0;
                     end
                     else
                       if(upgr[upgr_hpower]>0)then upgr[upgr_hpower]:=0;
                end;
             end;

             if(prdc_units=0)and(g_status=gs_game)then
             begin
                if(team=_players[PlayerHuman].team)
                then inc(aa,army)
                else inc(ea,army);
             end;
          end;
       end;
   end;

   if(g_step>vid_fps)and(prdc_units=0)and(g_status=gs_game)and(_rpls_rst<rpl_rhead)then
   begin
      if(_mmode=mm_camp)then
       with _players[PlayerHuman]do
        case _mcmp_sm of
      1  : if(eu[true,7]=0)then aa:=0;

      2  : begin
              if(_players[3].eu[true,0]=0)then ea:=0;
           end;
      3  : begin
              if(_players[4].eu[true,0]=0)then ea:=0;
           end;

      4  : if(eu[true,7]=0)or(eu[false,5]=0)then aa:=0;
      5  : begin
              if(eu[false,5]=0)then
              begin
                 aa:=0;
                 ea:=1;
              end
              else
                if(_players[4].eu[true,0]=0) then ea:=0;
           end;
      6  : begin
              if(eu[false,5]=0)then aa:=0;
              if(_players[2].eu[true,0]=0) then ea:=0;
           end;
      9  : begin
              if(G_Step>cmp_inhelltime)and(eu[true,0]=0)then aa:=0;
           end;

      10 : begin
              if(_players[4].eu[true,0]+_players[2].eu[true,0]+_players[3].eu[true,0])=0 then ea:=0;
           end;
      11 : begin
              if(_players[2].army+_players[3].army)=0 then ea:=0;
           end;

      12 : begin
              if(_players[0].eu[true,0]=0)or(eu[false,0]=0)then aa:=0;
              if(_units[1].hits=_units[1].mhits)then ea:=0;
           end;
      13 : begin
              if(_players[3].eu[true,2]<5)then aa:=0;
              if (_units[301].hits=1500)and(_units[302].hits=1500)and(_units[303].hits=1500)and(_units[304].hits=1500)and(_units[305].hits=1500)then ea:=0;
           end;
      14 : begin
              if(_players[1].army+_players[2].army+_players[3].army)=1 then ea:=0;
           end;
      15 : begin
              if(eu[true,7]=0)then aa:=0;
           end;
      16 : begin
              if(eu[true,0]=0)then aa:=0;
           end;
      17 : begin
              if(_players[3].eu[true,0]=0)then ea:=0;
           end;


      18 : begin
              if(eu[true,7]=0)then aa:=0;
              if( (_players[1].eu[true,6]+_players[2].eu[true,6]+_players[3].eu[true,6]) =0)then ea:=0;
           end;
      19 : begin
              if(army<=1)then aa:=0;
              if (_units[401].dsbl=false) then ea:=0;
           end;
      20 : if(_players[3].eu[false,6]=0)then ea:=0;
        else
        end;

      if(ea=0)and(aa>0)then
       if(g_mode=gm_inv)then
       begin
          if(g_inv_w>=inv_wvs)then
           if(_players[0].army=0)then g_status:=gs_win;
       end
       else g_status:=gs_win;
      if(ea>0)and(aa=0)then
      begin
         g_status:=gs_lose;
         if(_mmode<>mm_camp)then _fog:=false;
      end;
   end;

   if (_mmode=mm_camp)then
    if(g_status<>gs_game)then G_Paused:=PlayerHuman;
end;

procedure fog_prc;
var i:integer;
begin
   inc(fog_ix,1);
   fog_ix:=fog_ix mod fog_cs;
   inc(fog_iy,1);
   fog_iy:=fog_iy mod fog_cs;

   if(_fog=false)then
   begin
      if(fog_c[0,0]=0)then FillChar(fog_c,SizeOf(fog_c),fog_add)
   end
   else
     for i:=0 to fog_cs do
     begin
        fog_c[fog_ix,i]:=fog_c[fog_ix,i] shr 1;
        fog_c[i,fog_iy]:=fog_c[i,fog_iy] shr 1;
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
           _effect_add(tx,ty,9999,eid_Teleport);
           with _units[_lau] do
           begin
              painc :=10*g_inv_w;
              order :=1;
           end;
        end;
      PlaySNDM(snd_teleport);
   end;
end;

procedure CGame;
begin
   if(ui_alarm>0)then dec(ui_alarm,1);
   inc(prdc_units,1);prdc_units:=prdc_units mod _units_period;
   vid_mmredraw:=(prdc_units mod 10)=0;

   if(net_cl_con)then _netClient;

   _rpls_code;

   if(prdc_units=0)then _MusicCheck;
   _playersCycle;

   if(G_Started)and(G_paused=0)then
   begin
      _regen:=(G_Step mod regen_period);
      fog_prc;
      FillChar(ui_ur ,SizeOf(ui_ur ),0);
      FillChar(ui_urc,SizeOf(ui_urc),0);
      FillChar(ui_apc,SizeOf(ui_apc),0);
      _dds_p(false);
      _unitsCycle;
      _missile_cycle;
      _effects_cycle;
      if(onlySVCode)then
      begin
         inc(G_Step,1);
         if(_mmode=mm_camp)then cmp_code;
         if(_rpls_rst<rpl_rhead)and(onlySVCode)then
          if(g_mode=gm_inv)then g_inv_spawn;
      end;
   end;

   if(net_sv_up)then _netServer;
end;



