procedure _unit_mmcoords(u:integer);
begin
   with _units[u] do
   begin
      mmx:=trunc(x*map_mmcx);
      mmy:=trunc(y*map_mmcx);
   end;
end;

procedure _unit_correctcoords(u:integer);
begin;
   with _units[u] do
   begin
      if(x<1)then x:=1;
      if(y<1)then y:=1;
      if(x>map_mw)then x:=map_mw;
      if(y>map_mw)then y:=map_mw;
   end;
end;

procedure _unit_minimap(u:integer);
begin
  if(vid_rtui=0)and(_menu=false)and(_draw)and(_ded=false)then
   with _units[u]do
    with _players[player]do
     if(isbuild)
     then filledCircleColor(_minimap,mmx,mmy,mmr,plcolor[player])
     else pixelColor(_minimap,mmx,mmy,plcolor[player]);
end;

procedure _unit_createsound(uid:integer);
begin
   case uid of
UID_LostSoul   : PlaySND(snd_d0,0);
UID_Imp        : if(random(2)=0)
                 then PlaySND(snd_impc1,0)
                 else PlaySND(snd_impc2,0);
UID_Demon      : PlaySND(snd_demonc,0);
UID_Cacodemon  : PlaySND(snd_cacoc,0);
UID_Baron      : if(G_Addon)
                 then PlaySND(snd_knight,0)
                 else PlaySND(snd_baronc,0);
UID_Cyberdemon : PlaySND(snd_cyberc,0);
UID_Mastermind : PlaySND(snd_mindc,0);
UID_Pain       : PlaySND(snd_pain_c,0);
UID_Revenant   : PlaySND(snd_rev_c,0);
UID_Mancubus   : PlaySND(snd_man_c,0);
UID_Arachnotron: PlaySND(snd_ar_c,0);
UID_ArchVile   : PlaySND(snd_arch_c,0);
UID_Engineer,
UID_Medic,
UID_Sergant,
UID_Commando,
UID_Bomber,
UID_Major,
UID_BFG,
UID_FAPC,
UID_APC,
UID_Terminator,
UID_Tank,
UID_UTransport,
UID_Flyer  : case random(3) of
             0 : PlaySND(snd_uac_u0,0);
             1 : PlaySND(snd_uac_u1,0);
             2 : PlaySND(snd_uac_u2,0);
             end;
UID_ZFormer,
UID_ZSergant,
UID_ZCommando,
UID_ZBomber,
UID_ZMajor,
UID_ZBFG
            : case random(3) of
              0 : PlaySND(snd_z_s1,0);
              1 : PlaySND(snd_z_s2,0);
              2 : PlaySND(snd_z_s3,0);
              end;
UID_Dron      : PlaySND(snd_l_dron_a,0);
UID_Octobrain : PlaySND(snd_l_octo_c,0);
UID_Cyclope   : PlaySND(snd_l_cy_c,0);
   end;
end;

procedure _unit_comssnd(ucl,race:integer);
begin
  case race of
r_hell : case ucl of
         0,2,3,
         4,5,
         6,7  : PlaySND(snd_demon1,0);
         1    : PlaySND(snd_imp,0);
         10   : PlaySND(snd_ar_act,0);
         11   : PlaySND(snd_arch_a,0);
         12,
         9    : PlaySND(snd_zomb,0);
         8    : PlaySND(snd_rev_ac,0);
         end;
r_uac  : case random(3) of
         0 : PlaySND(snd_uac_u0,0);
         1 : PlaySND(snd_uac_u1,0);
         2 : PlaySND(snd_uac_u2,0);
         end;
  end;
end;

function _udpth(u:integer):integer;
begin
   _udpth:=0;
   with _units[u] do
    case uid of
UID_Portal   : _udpth:=-5;
UID_HTeleport: _udpth:=-4;
UID_HAltar   : _udpth:=-3;
UID_Mine     : _udpth:=-2;
    else
      if(hits>0)
      then _udpth:=map_flydpth[uf]+vy
      else _udpth:=vy;
    end;
end;

procedure _unit_uradar(u:integer);
begin
   with _units[u] do
    if(bld)then
     with _players[player] do
      if(rld=0)then
      begin
         rld:=radar_rld+(upgr[upgr_5bld]*radar_rld2);
         if(onlySVCode)and(team=_players[HPlayer].team)then PlaySND(snd_radar,0);
      end;
end;

procedure _unit_URocketL(u:integer);
begin
   with _units[u] do
    if(bld)then
     with _players[player] do
      if(rld=0)and(race=r_uac)then
       if(upgr[upgr_blizz]>0)then
       begin
          rld:=vid_2fps;
          upgr[upgr_blizz]:=0;
       end;
end;

procedure _sf(tx,ty:integer);
begin
   if(0<=tx)and(0<=ty)and(tx<=fog_cs)and(ty<=fog_cs)then fog_c[tx,ty]:=fog_add;
end;

procedure _fog_ix(x,y,r,tx:integer);
var ix,iy:integer;
begin
   ix:=abs(tx-x);
   if(ix<=r)then
    for iy:=0 to _fcx[r,ix] do
    begin
       _sf(tx,y-iy);
       _sf(tx,y+iy);
    end;
end;

procedure _fog_iy(x,y,r,ty:integer);
var ix,iy:integer;
begin
   iy:=abs(ty-y);
   if(iy<=r)then
    for ix:=0 to _fcx[r,iy] do
    begin
       _sf(x-ix,ty);
       _sf(x+ix,ty);
    end;
end;

procedure _fog_r(x,y,r:byte);
begin
   _fog_ix(x,y,r,fog_ix);
   _fog_ix(x,y,r,(fog_ix+fog_chs) mod fog_cs);
   _fog_iy(x,y,r,fog_iy);
   _fog_iy(x,y,r,(fog_iy+fog_chs) mod fog_cs);
end;

procedure _unit_sfog(u:integer);
begin
   with _units[u] do
   begin
      fx:=x div fog_cw;
      fy:=y div fog_cw;
      if(_rpls_rst>rpl_rhead)and(x=0)and(y=0)then exit;
      if(_players[player].team=_players[HPlayer].team)then _sf(fx,fy);
   end;
end;

function _unit_grbcol(tx,ty,tr:integer;pl:byte;doodc:boolean):byte;
var u:integer;
   bl:boolean;
begin
   if(pl<255)
   then bl:=false
   else bl:=true;
   _unit_grbcol:=0;

   for u:=1 to MaxUnits do
    with _units[u] do
     if(hits>0)and(speed=0)and(uf=uf_ground)and(inapc=0)then
      if(dist(x,y,tx,ty)<(tr+r))then
      begin
         _unit_grbcol:=1;
         break;
      end
      else
       if(bl=false)then
        if(isbuild)and(bld)and(ucl=0)and(player=pl)then
         if(dist(x,y,tx,ty)<sr)then bl:=true;

   if(_unit_grbcol=0)then
   begin
      if(bl=false)and(pl<255)then
      begin
         _unit_grbcol:=2;
         exit;
      end;

      if(g_mode=gm_ct)then
       for u:=1 to MaxPlayers do
        with g_ct_pl[u] do
         if(dist(tx,ty,px,py)<base_r)then
         begin
            _unit_grbcol:=2;
            exit;
         end;

      if(doodc=false)then exit;

      dec(tr,bld_dec_mr);
      for u:=1 to MaxDoodads do
       with map_dds[u] do
        if(r>0)and(t>0)then
         if(dist(x,y,tx,ty)<(tr+r))then //,t=DID_Liquid
         begin
            _unit_grbcol:=1;
            break;
         end;
   end;
end;

procedure _unit_def(u:integer);
begin
   with _units[u] do
   begin
      inapc   := 0;
      anim    := 0;
      uo_id   := ua_amove;
      uo_tar  := 0;
      rld     := 0;
      pains   := 0;
      dir     := 270;
      order   := 0;
      wanim   := false;
      utrain  := 0;
      tar1    := 0;
      dtar    := 32000;
      alrm_x  := 0;
      alrm_y  := 0;
      alrm_r  := 32000;
      alrm_b  := false;
      alrm_i  := false;

      _unit_mmcoords(u);
      _unit_sfog(u);
   end;
end;

procedure _unit_add(ux,uy:integer;uc,pl:byte;ubld:boolean);
var m,i:integer;
begin
   with _players[pl] do
   begin
      _lcu :=0;
      _lcup:=@_units[_lcu];
      if(uc=0)then exit;
      i:=MaxPlayerUnits*pl+1;
      m:=i+MaxPlayerUnits;
      while(i<m)do
      begin
         with _units[i] do
          if(hits<=dead_hits)then
          begin
             _lcu :=i;
             _lcup:=@_units[i];
             break;
          end;
         inc(i,1);
      end;
      if(_lcu>0)then
       with _lcup^ do
       begin
          _uclord:=_lcu mod vid_hfps;

          x       := ux;
          y       := uy;
          uid     := uc;
          player  := pl;
          vx      := x;
          vy      := y;
          uo_x    := x;
          uo_y    := y;
          sel     := false;
          apcc    := 0;
          fillChar(buff,sizeof(buff),0);

          ai_basex:= x;
          ai_basey:= y;

          _unit_def(_lcu);
          _unit_sclass(_lcup);

          inc(army,1);
          inc(u_e[isbuild,ucl],1);
          inc(u_c[isbuild],1);

          if(ubld)then
          begin
             bld := true;
             if(isbuild)then
             begin
                if(ubx[ucl]=0)then ubx[ucl]:=_lcu;
                if(ucl=0)then inc(bldrs,1);
             end;
             inc(menerg,generg);
          end
          else
          begin
             bld := false;
             hits:= 50;
          end;
       end;
   end;
end;

procedure _unit_startb(bx,by:integer;bt,bp:byte);
begin
   with _players[bp] do
     if(_bldCndt(bp,bt)=false)then
      if(build_b<bx)and(bx<map_b1)and(build_b<by)and(by<map_b1)then
       if(_unit_grbcol(bx,by,_ulst[cl2uid[race,true,bt]].r,bp,true)=0)then
       begin
          bld_r:=vid_fps+u_c[true];
          _unit_add(bx,by,cl2uid[race,true,bt],bp,false);
          if(_lcu>0)then
          begin
             inc(cenerg,_pne_b[race,bt]);
             if(bp=HPlayer)then PlaySND(snd_build[race],0);
          end;
       end;
end;

procedure _unit_straining(u,ut:integer);
begin
   with _units[u] do
    if(rld=0)and(bld)and(ucl=1)and(isbuild)then
     with _players[player] do
      if(_untCndt(player,ut)=false)then
      begin
         if(_ulst[cl2uid[race,false,ut]].max=1)then wbhero:=true;

         utrain:=ut;
         if(race=r_hell)and(ut in [12..17])then
          if(uid<>UID_HMilitaryUnit)
          then exit
          else
            if(state<>ps_comp)then
            begin
               if not(rld_a in [12..17])then rld_a:=12;
               utrain:=rld_a;
            end;

         inc(wb,1);
         inc(cenerg,_pne_u[race,ut]);
         rld:=_ulst[cl2uid[race,false,utrain]].trt;
      end;
end;
procedure _unit_ctraining(u:integer);
begin
  with _units[u] do
   if(rld>0)and(bld)and(ucl=1)and(isbuild)then
    with _players[player] do
    begin
       if(_ulst[cl2uid[race,false,utrain]].max=1)then wbhero:=false;

       dec(wb,1);
       dec(cenerg,_pne_u[race,utrain]);
       rld:=0;
    end;
end;

procedure _unit_supgrade(u,up:integer);
begin
   with _units[u] do
    if(rld=0)and(bld)and(ucl=3)and(isbuild)then
     if(up>=0)and(up<=_uts)then
      with _players[player] do
       if(upgrade_time[race,up]>0)then
        if(upgr[up]<upgrade_cnt[race,up])and(_bc_g(a_upgr,up))and(_bc_g(cpupgr,up)=false)then
         if((menerg-cenerg)>=_pne_r[race,up])then
         begin
            if(up>upgr_2tier)and((upgr[upgr_2tier]=0)or(ubx[6]=0))then exit;
            if((G_addon=false)and(up>=upgr_2tier))then exit;

            _bc_s(@cpupgr,up);
            inc(cenerg,_pne_r[race,up]);
            rld:=upgrade_time[race,up];
            utrain:=up;
         end;
end;
procedure _unit_cupgrade(u:integer);
begin
   with _units[u] do
    if(rld>0)and(bld)and(ucl=3)and(isbuild)then
     with _players[player] do
     begin
        dec(cenerg,_pne_r[race,utrain]);
        _bc_us(@cpupgr,utrain);
        rld:=0;
      end;
end;

function _unit_chktar(u,t,utd:integer):boolean;
var uu,tu:PTUnit;
 teams:boolean;
begin
   uu:=@_units[u];
   tu:=@_units[t];

   _unit_chktar:=false;

   if(uu^.uo_id<>ua_amove)
   then exit
   else
     if(uu^.uo_tar>0)then
      if(_players[uu^.player].team<>_players[_units[uu^.uo_tar].player].team)then
       if(uu^.uo_tar<>t)then exit;

   if(tu^.buff[ub_notarget]>0)then exit;

   if(utd>=uu^.sr)or(tu^.inapc>0)then exit;

   teams:=(_players[tu^.player].team=_players[uu^.player].team);

   if(teams=false)then
    if(tu^.buff[ub_vis]=0)and(tu^.buff[ub_invis]>0)then exit;

   if(tu^.hits<=0)then
   begin
      if(tu^.hits<=dead_hits)then exit;
      if(tu^.buff[ub_stopafa]>0)then exit;
      case uu^.uid of
      UID_ArchVile :if(uu^.buff[ub_advanced]=0)or(tu^.buff[ub_resur]>0)or not(tu^.uid in arch_res)or(teams=false)then exit;
      UID_LostSoul :if(uu^.buff[ub_advanced]=0)or(tu^.buff[ub_resur]>0)or not(tu^.uid in marines )then exit;
      else
        exit;
      end;
   end;

   if(uu^.uid=UID_Sergant)then
    with _players[uu^.player] do
     if(state=ps_comp)and(ai_skill>2)then
      if(utd>100)and(uu^.buff[ub_vis]=0)and(uu^.buff[ub_invis]>0)then exit;

   if(tu^.uf=uf_fly)then
   begin
      if(uu^.uid=UID_Demon )then exit;
      if(uu^.uid=UID_Mine  )then exit;
   end;

   if(tu^.uid in [UID_Mancubus,UID_Arachnotron])and(tu^.uid=uu^.uid)then exit;

   if not(tu^.uid in [UID_UCommandCenter,UID_Octobrain,UID_Dron])then
   begin
      if(uu^.uid in [UID_Bomber,UID_ZBomber,UID_Tank])then
       if(utd<=rocket_sr)or(tu^.uf>uf_ground)then exit;

       if(uu^.uid=UID_UCommandCenter)and(tu^.uf=uf_fly)then exit;
   end;

   if(uu^.uid=UID_Medic)and(tu^.uid=UID_Medic)and(u<>t)then exit;

   if(teams)and(tu^.hits>0)then
   begin
      if(uu^.uid in [UID_Medic,UID_Engineer])then
      begin
         if(uu^.inapc>0)then exit;
         if(tu^.buff[ub_pain]>0)or(tu^.hits>=tu^.mhits)then exit;
         case uu^.uid of
           UID_Medic    : if(tu^.mech)then exit;
           UID_Engineer : if(tu^.mech=false)or(tu^.bld=false)then exit;
         end;
      end
      else exit;
   end;

   _unit_chktar:=true;
end;

procedure _unit_swmelee(u:integer);
var tu:PTUnit;
   dtr:integer;
begin
   with _units[u] do
   begin
      melee:=false;

      if(uid in [UID_Demon,UID_LostSoul,UID_Dron])then melee:=true;
      if(tar1>0)then
      begin
         tu:=@_units[tar1];
         if(uid in [UID_Imp,UID_Cacodemon,UID_Baron,UID_Revenant])then
         begin
            if(uid=tu^.uid)then melee:=true;
            dtr:=dtar;
            dec(dtr,r+tu^.r);
            if(dtr<=melee_r)and(abs(uf-tu^.uf)<2)then melee:=true;
         end;
         if(uid in [UID_Medic,UID_Engineer,UID_ArchVile])then
          if(_players[tu^.player].team=_players[player].team)then melee:=true;
      end;
   end;
end;

function _itcanapc(uu,tu:PTUnit):boolean;
begin
   _itcanapc:=false;
   if(tu^.uf>uf_ground)then exit;
   if((uu^.apcm-uu^.apcc)>=tu^.apcs)then
    case uu^.uid of
      UID_APC   : begin
                     if(tu^.uid in whocaninapc)and(tu^.uid in marines)then _itcanapc:=true;
                  end;
      UID_FAPC  : begin
                     if(tu^.uid in whocaninapc)then _itcanapc:=true;
                     if(_players[uu^.player].state=ps_comp)then
                     begin
                        if(tu^.alrm_r<=310)then _itcanapc:=false;
                     end;
                  end;
    end;
end;

function _move2uotar(uu,tu:PTUnit;td:integer):boolean;
begin
   _move2uotar:=true;
   if(tu^.uid=UID_HTeleport)then exit;
   _move2uotar:=(tu^.x<>tu^.uo_x)or(tu^.y<>tu^.uo_y)or(td>uu^.sr);
   dec(td,uu^.r+tu^.r);
   if(td<=-melee_r)then _move2uotar:=false;
   if(tu^.player=uu^.player)then
    if(_itcanapc(tu,uu))then
    begin
       _move2uotar:=true;
       if(tu^.uid=UID_FAPC)and(tu^.uo_tar=0)then
       begin
          tu^.uo_x:=uu^.x;
          tu^.uo_y:=uu^.y;
       end;
    end;
end;

procedure _teleport_rld(tu:PTUnit;ur:integer);
begin
   with tu^ do
    with _players[player] do
     if(upgr[upgr_5bld] in [0..3])then rld:=ur-((ur div 4)*upgr[upgr_5bld]);

end;

procedure _unit_teleport(u,tx,ty:integer);
begin
   with _units[u] do
   begin
      if(tx<0)then tx:=0;
      if(ty<0)then ty:=0;
      if(tx>map_mw)then tx:=map_mw;
      if(ty>map_mw)then ty:=map_mw;
      if(_nhp(vx,vy,r)or _nhp(tx,ty,r))then PlaySND(snd_teleport,0);
      _effect_add(vx,vy,vy+map_flydpth[uf]+1,EID_Teleport);
      _effect_add(tx,ty,ty+map_flydpth[uf]+1,EID_Teleport);
      buff[ub_pain]:=vid_hfps;
      x   :=tx;
      y   :=ty;
      vx  :=x;
      vy  :=y;
      uo_x:=x;
      uo_y:=y;
      uo_tar:=0;
      _unit_correctcoords(u);
      _unit_mmcoords(u);
      _unit_sfog(u);
   end;
end;

procedure _unit_ttar(u:integer);
var tu:PTUnit;
td,tdr:integer;
teams : boolean;
begin
   if(onlySVCode)then
    with _units[u] do
    begin
       dtar:=32000;
       if(tar1>0)then
       begin
          tu:=@_units[tar1];
          td:=dist2(x,y,tu^.x,tu^.y);
          if(_unit_chktar(u,tar1,td)=false)
          then tar1:=0
          else dtar:=td;
       end;

       if(uo_tar=u)then uo_tar:=0;
       if(uo_tar>0)and(inapc=0)then
       begin
          tu:=@_units[uo_tar];
          if(tu^.inapc>0)then
          begin
             uo_tar:=0;
             exit;
          end;

          td :=dist2(x,y,tu^.x,tu^.y);
          tdr:=td-(r+tu^.r);

          if(player=tu^.player)then
          begin
             if(uid=UID_HMonastery)and(tu^.isbuild=false)then
             begin
                if(tu^.buff[ub_advanced]=0)and(bld)and(utrain>=n_souls)and(buff[ub_advanced]>0)then
                begin
                   dec(utrain,n_souls);
                   tu^.buff[ub_advanced]:=255;
                   PlaySND(snd_hupgr,uo_tar);
                   tu^.hits:=tu^.mhits;
                   _effect_add(tu^.vx,tu^.vy,tu^.vy+map_flydpth[tu^.uf]+1,EID_HUpgr);
                end;
                uo_x:=x;
                uo_y:=y;
                uo_tar:=0;
                exit;
             end;
             if(tu^.uid=UID_HMonastery)and(isbuild=false)then
             begin
                if(buff[ub_advanced]=0)and(tu^.bld)and(tu^.utrain>=n_souls)and(tu^.buff[ub_advanced]>0)then
                begin
                   dec(tu^.utrain,n_souls);
                   buff[ub_advanced]:=255;
                   PlaySND(snd_hupgr,u);
                   hits:=mhits;
                   _effect_add(vx,vy,vy+map_flydpth[uf]+1,EID_HUpgr);
                end;
                uo_x:=x;
                uo_y:=y;
                uo_tar:=0;
                exit;
             end;
             if(tu^.uid=UID_UVehicleFactory)then
              if(tdr<=melee_r)and(tu^.rld=0)and(isbuild=false)then
              begin
                 uo_x:=x;
                 uo_y:=y;
                 uo_tar:=0;
                 if(tu^.buff[ub_advanced]>0)and(tu^.bld)and(buff[ub_advanced]=0)then
                 begin
                    buff[ub_gear]:=gear_time[mech];
                    buff[ub_advanced]:=255;
                    with _players[tu^.player] do
                     if(mech)
                     then tu^.rld:=mech_adv_rel[(g_addon=false)or(upgr[upgr_6bld2]>0)]
                     else tu^.rld:=uac_adv_rel [(g_addon=false)or(upgr[upgr_6bld2]>0)];
                    PlaySND(snd_uupgr,u);
                    uo_x  :=tu^.uo_x;
                    uo_y  :=tu^.uo_y;
                    uo_tar:=tu^.uo_tar;
                 end;
                 exit;
              end;
          end;

          teams:=_players[player].team=_players[tu^.player].team;

          if(teams=false)then
           if((td>base_r)and(tu^.speed>0))
           or((tu^.buff[ub_invis]>0)and(tu^.buff[ub_vis]=0))then
           begin
              uo_tar:=0;
              exit;
           end;
          if(_move2uotar(@_units[u],tu,td))then
          begin
             uo_x:=tu^.vx;
             uo_y:=tu^.vy;
          end;

          if(teams)then
           if(tu^.uid=UID_HTeleport)and(tu^.bld)and(isbuild=false)then
            if(td<=tu^.r)then
            begin
               if(dist2(x,y,tu^.uo_x,tu^.uo_y)>tu^.sr)and(tu^.rld=0) then
               begin
                  _unit_teleport(u,tu^.uo_x,tu^.uo_y);
                  _teleport_rld(tu,mhits);
                  exit;
               end;
            end
            else
              if(tu^.buff[ub_advanced]>0)and(td>base_r)then
               if(tu^.rld=0)then
               begin
                  _unit_teleport(u,tu^.x,tu^.y);
                  _teleport_rld(tu,mhits);
                  exit;
               end
               else
               begin
                  uo_x:=x;
                  uo_y:=y;
               end;
       end;
    end;
end;

procedure _unit_remove(u:integer);
begin
   with _units[u] do
    with _players[player] do
    begin
       dec(army,1);
       dec(u_e[isbuild,ucl],1);
       dec(u_c[isbuild],1);

       if(G_WTeam=255)then
        if(player<>0)or(g_mode<>gm_inv)then
         if(army=0)and(menu_s2<>ms2_camp)and(state>ps_none)then net_chat_add(chr(player)+name+str_player_def);
    end;
end;

procedure _unit_death(u:integer);
var spr : PTUSprite;
      i : byte;
begin
   with _units[u] do
    with _players[player] do
     if(hits>dead_hits)then
     begin
        for i:=0 to _ubuffs do
         if(buff[i]<255)then
          if(buff[i]>0)then dec(buff[i],1);

        if(buff[ub_resur]=0)then
        begin
           if(onlySVCode)or(hits>-100)then dec(hits,1);
           if(_uclord=_uclord_c)and(fr>0)then dec(fr,1);

           if(onlySVCode)then
           begin
              case uid of
              UID_Cacodemon: if(hits>-shadow)then begin inc(vy,1);inc(y,1);end;
              UID_Octobrain: if(hits>-shadow)then begin inc(vy,1);inc(y,1);end;
              end;

              if(hits<=dead_hits)then
              begin
                 _unit_remove(u);
                 exit;
              end;
           end;
        end
        else
         if(OnlySVCode)then
         begin
            if(hits<-80)then hits:=-80;
            inc(hits,1);
            case uid of
            UID_Cacodemon: if(hits>-shadow)then begin dec(vy,1);dec(y,1);end;
            UID_Octobrain: if(hits>-shadow)then begin dec(vy,1);dec(y,1);end;
            end;
            if(hits>=0)then
            begin
               uo_x:=x;
               uo_y:=y;
               dir:=270;
               hits:=mhits;
               fr:=(sr+fog_cw) div fog_cw;
               if(player=HPlayer)then _unit_createsound(uid);
               buff[ub_resur]:=0;
            end;
         end;

        if(_rpls_rst>rpl_rhead)and(x=0)and(y=0)then exit;
        if(buff[ub_stopafa]>0)then exit;  //no sprite when gavno

        if(_ded)then exit;

        if(team=_players[HPLayer].team)then _fog_r(fx,fy,fr);

        spr:=_unit_spr(@_units[u]);

        if(spr=@spr_dummy)then exit;

        if(_fog_ch(fx,fy,r))then
         if ((vid_vx+vid_panel-spr^.hw)<vx)and(vx<(vid_vx+vid_mw+spr^.hw))and
            ((vid_vy          -spr^.hh)<vy)and(vy<(vid_vy+vid_mh+spr^.hh))then
         begin
            anim:=abs(hits-dead_hits);
            if(anim>255)then anim:=255;
            _sl_add(vx-spr^.hw, vy-spr^.hh,_udpth(u),0,0,0,false,spr^.surf,anim,0,0,0,0,'',0);
         end;
     end;
end;

procedure _pain_lost(u,tx,ty:integer);
begin
  with _units[u] do
   with _players[player] do
    begin
       if((army+wb)>=MaxPlayerUnits)or((player=0)and(g_mode=gm_inv)and(army>=g_inv_mn))
       then _lcu:=0
       else
         if(OnlySVCode)
         then _unit_add(tx,ty,UID_LostSoul,player,true)
         else exit;
       if(_lcu>0)then
       begin
          _lcup^.dir   :=dir;
          _lcup^.tar1  :=tar1;
          _lcup^.dtar  :=dtar;
          _lcup^.uo_id :=uo_id;
          _lcup^.uo_tar:=uo_tar;
          if(tar1>0)then
          begin
             _lcup^.uo_x  :=_units[tar1].x;
             _lcup^.uo_y  :=_units[tar1].y;
          end
          else
           if(uo_x<>x)or(uo_y<>y)then
           begin
              _lcup^.uo_x  :=uo_x;
              _lcup^.uo_y  :=uo_y;
           end;
          _lcup^.buff[ub_advanced]:=buff[ub_advanced];
          if(_nhp(x,y,0))then _unit_createsound(UID_LostSoul);
       end
       else
       begin
          _effect_add(tx,ty,ty+map_flydpth[uf]+1,UID_LostSoul);
          PlaySND(snd_pexp,u);
       end;
    end;
end;

procedure _unit_deff(u:integer;deff:boolean);
begin
   with _units[u] do
   with _players[player] do
   begin
      buff[ub_stopafa]:=0;
      if(deff)then
      begin
         if(isbuild)then
         begin
            if(uid=UID_Mine)then
            begin
               PlaySND(snd_exp,u);
               _effect_add(vx,vy,map_flydpth[uf]+vy,EID_Exp);
            end
            else
            begin
               if(race=r_hell)and(hits<200)and(bld=false)then
               begin
                  if(r<41)
                  then _effect_add(vx,vy+5 ,-5,eid_db_h1)
                  else _effect_add(vx,vy+10,-5,eid_db_h0);
                  exit;
               end;
               PlaySND(snd_exp2,u);
               if(r>48)then
               begin
                  _effect_add(vx,vy,map_flydpth[uf]+vy,EID_BBExp);
                  if(race=r_hell)
                  then _effect_add(vx,vy+10,-10,eid_db_h0)
                  else _effect_add(vx,vy+10,-10,eid_db_u0);
               end
               else
               begin
                  _effect_add(vx,vy,map_flydpth[uf]+vy,EID_BExp);
                  if(race=r_hell)
                  then _effect_add(vx,vy+10,-10,eid_db_h1)
                  else _effect_add(vx,vy+10,-10,eid_db_u1);
               end;
            end;
         end
         else
         case uid of
           UID_LostSoul : begin
                             PlaySND(snd_pexp,u);
                             _effect_add(vx,vy,map_flydpth[uf]+vy,UID_LostSoul);
                          end;
           UID_Pain     : begin
                             PlaySND(snd_pain_d,u);
                             _effect_add(vx,vy,map_flydpth[uf]+vy,UID_Pain);
                             if(OnlySVCode)then
                              if(buff[ub_advanced]>0)then
                              begin
                                 _pain_lost(u,vx-10+random(20),vy-10+random(20));
                                 _pain_lost(u,vx-10+random(20),vy-10+random(20));
                                 _pain_lost(u,vx-10+random(20),vy-10+random(20));
                              end;
                          end;
         else
           if(uid in gavno)then
            if(uf>uf_ground)then
            begin
               PlaySND(snd_exp,u);
               _effect_add(vx,vy,map_flydpth[uf]+vy,EID_Exp);
               buff[ub_stopafa]:=vid_2fps;
            end
            else
            begin
               PlaySND(snd_meat,u);
               _effect_add(vx,vy,map_flydpth[uf]+vy,EID_Gavno);
               buff[ub_stopafa]:=vid_2fps;
            end
           else
            case uid of
        UID_APC,
        UID_FAPC   : begin
                        PlaySND(snd_exp,u);
                        _effect_add(vx,vy,map_flydpth[uf]+vy,EID_BExp);
                     end;
        UID_Dron,
        UID_Flyer,
        UID_Terminator,
        UID_Tank   : begin
                        PlaySND(snd_exp,u);
                        _effect_add(vx,vy,map_flydpth[uf]+vy,EID_Exp2);
                     end;
        UID_UTransport:
                     begin
                        PlaySND(snd_exp,u);
                        _effect_add(vx,vy,map_flydpth[uf]+vy,EID_BExp);
                     end;
            end;
         end;
      end
      else
      case uid of
    UID_LostSoul   : PlaySND(snd_pexp,u);
    UID_Imp        : if(random(2)=0)
                     then PlaySND(snd_impd1,u)
                     else PlaySND(snd_impd2,u);
    UID_Demon      : PlaySND(snd_demond,u);
    UID_Cacodemon  : PlaySND(snd_cacod,u);
    UID_Baron      : if(buff[ub_advanced]=0)
                     then PlaySND(snd_knightd,u)
                     else PlaySND(snd_barond,u);
    UID_Cyberdemon : PlaySND(snd_cyberd,u);
    UID_Mastermind : PlaySND(snd_mindd,u);
    UID_Pain       : begin
                        PlaySND(snd_pain_d,u);
                        if(OnlySVCode)then
                         if(buff[ub_advanced]>0)then
                         begin
                            _pain_lost(u,x-10+random(20),y-10+random(20));
                            _pain_lost(u,x-10+random(20),y-10+random(20));
                            _pain_lost(u,x-10+random(20),y-10+random(20));
                         end;
                     end;
    UID_Revenant   : PlaySND(snd_rev_d,u);
    UID_Mancubus   : PlaySND(snd_man_d,u);
    UID_Arachnotron: PlaySND(snd_ar_d,u);
    UID_ArchVile   : PlaySND(snd_arch_d,u);
    UID_ZFormer,
    UID_ZSergant,
    UID_ZCommando,
    UID_ZBomber,
    UID_ZMajor,
    UID_ZBFG       : case random(3) of
                     0 : PlaySND(snd_z_d1,u);
                     1 : PlaySND(snd_z_d2,u);
                     2 : PlaySND(snd_z_d3,u);
                     end;
    UID_Engineer,
    UID_Medic,
    UID_Sergant,
    UID_Commando,
    UID_Bomber,
    UID_Major,
    UID_BFG
                 : if(random(2)=1)
                   then PlaySND(snd_ud1,u)
                   else PlaySND(snd_ud2,u);
    UID_Octobrain: PlaySND(snd_l_octo_d,u);
    UID_Cyclope  : PlaySND(snd_l_cy_d,u);
      end;
   end;
end;

procedure _check_missiles(u:integer);
var i:integer;
begin
   for i:=1 to MaxMissiles do
    with _missiles[i] do
     if(vst>0)and(tar=u)then tar:=0;
end;

procedure _unit_kill(u:integer;nodead,deff:boolean);
var i :integer;
    tu:PTunit;
begin
   if(u>0)then
  with _units[u] do
  with _players[player] do
  begin
     if(nodead=false)then
     begin
        if(uid in [UID_Major,UID_ZMajor])and(uf>uf_ground)
        then deff:=true
        else
          if not(uid in gavno)
          then deff:=false;
        if(mech)or(uid in [UID_LostSoul,UID_Pain])then deff:=true;

        _unit_deff(u,deff);

        buff[ub_pain]:=vid_fps;
     end;

     if(sel)then dec(u_s[isbuild,ucl],1);
     sel:=false;

     if(isbuild)then
      if(bld=false)
      then dec(cenerg,_pne_b[race,ucl])
      else
      begin
         _unit_ctraining(u);
         _unit_cupgrade(u);

         dec(menerg,generg);
         if(ubx[ucl]=u)then ubx[ucl]:=0;
         if(ucl=0)then dec(bldrs,1);
      end;

     x     :=vx;
     y     :=vy;
     uo_x  :=x;
     uo_y  :=y;
     tar1  :=0;
     dtar  :=32000;
     rld   :=0;
     uo_tar:=0;

     for i:=1 to MaxUnits do
     if(i<>u)then
     begin
        tu:=@_units[i];
        if(tu^.hits>0)then
        begin
           if(tu^.uo_tar=u)then tu^.uo_tar:=0;
           if(apcc>0)then
            if(tu^.inapc=u)then
            begin
               if(uid in [UID_FAPC])or(inapc>0)
               then _unit_kill(i,true,false)
               else
               begin
                  tu^.inapc:=0;
                  dec(apcc,tu^.apcs);
                  tu^.x:=tu^.x-15+random(30);
                  tu^.y:=tu^.y-15+random(30);
                  tu^.uo_x:=tu^.x;
                  tu^.uo_y:=tu^.y;
                  if(tu^.hits>apc_exp_damage)then
                  begin
                     dec(tu^.hits,apc_exp_damage);
                     tu^.buff[ub_invuln]:=10;
                  end
                  else _unit_kill(i,true,false);
               end;
            end;
        end;
     end;
     _check_missiles(u);

     if(nodead)then
     begin
        hits:=ndead_hits;
        _unit_remove(u);
     end
     else
       if(deff)
       then hits:=idead_hits
       else hits:=0;
  end;
end;

{procedure _kill_player(p:byte);
var i:integer;
begin
   for i:=1 to MaxUnits do
    with _units[i] do
     if(p=player)and(hits>0)and(inapc=0)then
      with _players[player] do _unit_kill(i,false,false);
end;}

procedure _hell_bl6a(tu:PTUnit);
begin
   with tu^ do
    if(buff[ub_advanced]>0)then
     with _players[player] do
      if(utrain<hmon_max_souls[(g_addon=false)or(upgr[upgr_6bld2]>0)])then
       inc(utrain,1);
end;

procedure _unit_painsnd(u:integer);
begin
   with _units[u] do
   begin
      case uid of
       UID_LostSoul,
       UID_Demon,
       UID_Cacodemon,
       UID_Baron,
       UID_Cyberdemon,
       UID_Mastermind,
       UID_Arachnotron : PlaySND(snd_dpain,u);
       UID_ArchVile    : PlaySND(snd_arch_p,u);
       UID_Pain        : PlaySND(snd_pain_p,u);
       UID_Revenant,
       UID_Imp,
       UID_ZFormer,
       UID_ZSergant,
       UID_ZCommando,
       UID_ZBomber,
       UID_ZMajor,
       UID_ZBFG        : PlaySND(snd_z_p,u);
       UID_Mancubus    : PlaySND(snd_man_p,u);
       UID_Dron        : PlaySND(snd_l_dron_p,u);
       UID_Octobrain   : PlaySND(snd_l_octo_p,u);
       UID_Cyclope     : case random(3) of
                         0:PlaySND(snd_l_cy_p ,u);
                         1:PlaySND(snd_l_cy_a1,u);
                         2:PlaySND(snd_l_cy_a2,u);
                         end;
       end;
   end;
end;

procedure _unit_damage(u,dam:integer;p,pl:byte);
var arm:integer;
begin
  if(onlySVCode)then
   with _units[u] do
   begin
      if(buff[ub_invuln]>0)or(hits<0)then exit;

      arm:=0;

      with _players[player] do
      begin
         if(isbuild)then
         begin
            if(upgr[upgr_build]>0)then
            begin
               case upgr[upgr_build] of
                1 : inc(arm,dam div 10);
                2 : inc(arm,dam div 8);
                3 : inc(arm,dam div 6);
                4 : inc(arm,dam div 4);
               end;
               inc(arm,upgr[upgr_build]);
            end;
         end
         else
           if(mech=false)then
           begin
              if(upgr[upgr_armor]>0)then
              begin
                 case upgr[upgr_armor] of
                  1 : inc(arm,dam div 12);
                  2 : inc(arm,dam div 10);
                  3 : inc(arm,dam div 8);
                  4 : inc(arm,dam div 6);
                 end;
                 inc(arm,upgr[upgr_armor]);
              end;
           end
           else
           begin
              if(upgr[upgr_mecharm]>0)then
              begin
                 case upgr[upgr_mecharm] of
                  1 : inc(arm,dam div 12);
                  2 : inc(arm,dam div 10);
                  3 : inc(arm,dam div 8);
                  4 : inc(arm,dam div 6);
                 end;
                 inc(arm,upgr[upgr_mecharm]);
              end;
           end;

         if(buff[ub_advanced]>0)then
         begin
            case uid of
              UID_Baron : dam:=dam div 2;
            else
            end;
         end;
      end;

      dec(dam,arm);
      if(dam<mindmg)then dam:=mindmg;

      if(hits<=dam)then
      begin
         _unit_kill(u,false,(hits-dam)<gavno_dth_h);

         if(mech=false)and(player<>pl)then
          with _players[pl] do
           if(race=r_hell)then
            if(ubx[6]>0)then
             _hell_bl6a(@_units[ubx[6]]);
      end
      else
      begin
         dec(hits,dam);

         if(alrm_i=false)then
          if(dam>1)or(isbuild)then
          begin
             alrm_i:=true;
             alrm_x:=x-blizz_w+random(blizz_ww);
             alrm_y:=y-blizz_w+random(blizz_ww);
             alrm_r:=0;
          end;

         if(mech)then
         begin
            if(uid=UID_Dron)then
            begin
               if(buff[ub_pain]<vid_fps)then _unit_painsnd(u);
               dir:=random(360);
            end;
            buff[ub_pain]:=vid_2fps;
         end
         else
           if(painc>0)and(buff[ub_pain]=0)then
           begin
              if(p>pains)
              then pains:=0
              else dec(pains,p);

              if(pains=0)then
              begin
                 pains:=painc;
                 buff[ub_pain]:=pain_time;
                 buff[ub_stopafa]:=_uclord_p;

                 if(uid in [UID_Mancubus,UID_ArchVile,UID_ZBFG])then rld:=0;

                 if(uid=UID_Mancubus)and(buff[ub_advanced]>0)then inc(pains,pains);

                 with _players[player] do
                  if(race=r_hell)then
                   if(upgr[upgr_pains]>0)then inc(pains,upgr[upgr_pains]*4);

                 _unit_painsnd(u);
              end;
           end;
      end;
   end;
end;

{$Include _missiles.pas}

function _canmove(u:integer):boolean;
begin
   with(_units[u])do
   begin
   _canmove:=false;

      if(onlySVCode=false)and(speed>0)then
      begin
         _canmove:=(x<>uo_x)or(y<>uo_y);
         exit;
      end;

      if(speed=0)or(buff[ub_stopafa]>0)then exit;

      if(uo_tar=tar1)and(uo_tar>0)then
       if(melee=false)
       then exit
       else
         if(dtar<(r+_units[tar1].r+melee_r))then exit;

      case uid of
        UID_Terminator,
        UID_Tank : if(rld>0)
                   or(buff[ub_gear]>0)
                   then exit;
        UID_Flyer: if(buff[ub_gear]>0)
                   then exit
                   else
                     if(buff[ub_advanced]=0)then
                      if(rld>0)then exit;
        UID_UTransport,
        UID_Dron,
        UID_APC,
        UID_FAPC : if(buff[ub_gear]>0)then exit;
        UID_UCommandCenter : if(buff[ub_clcast]>0)then exit;
      else
        if(rld>0)
        or(buff[ub_pain ]>0)
        or(buff[ub_toxin]>0)
        or(buff[ub_gear]>0)
        then exit;
      end;

      _canmove:=true;
   end;
end;

procedure _unit_vis(u:integer);
var spr : PTUSprite;
     dp,smy,
     inv,t,ro,
     sh : integer;
     mc,
     rc : cardinal;
     sb : single;
b0,b2,b3: byte;
    b1  : string6;
    rct : boolean;
begin
  if(_ded)then exit;

   with _units[u] do
    if(hits>0)then
    with _players[player] do
     begin
        if(team=_players[HPlayer].team)
        or((HPlayer=0)and(_rpls_rst>rpl_rhead))
        or((u_e[true,0]=0)and(menu_s2<>ms2_camp))then
        begin
           if(OnlySVCode=false)and(x=0)and(y=0)then exit;
           _fog_r(fx,fy,fr);
           if(uid=UID_URadar)and(rld>radar_time)then _fog_r(uo_x div fog_cw,uo_y div fog_cw,fr);
        end;

        if(inapc>0)then exit;

        if(team<>_players[HPlayer].team)then
        begin
           if(_fog)then
            if(buff[ub_invis]>0)and(buff[ub_vis]=0)then exit;
        end;

        if(player=HPlayer)then
        begin
           if(ordx[order]=0)then
           begin
              ordx[order]:=x;
              ordy[order]:=y;
           end
           else
           begin
              ordx[order]:=(ordx[order]+x) div 2;
              ordy[order]:=(ordy[order]+y) div 2;
           end;

         if(isbuild)then
         begin
            if(bld)then
            begin
               if(ucl=0)and(m_sbuild<=_uts)and(speed=0)then
                if((vid_vx+vid_panel-sr)<vx)and(vx<(vid_vx+vid_mw+sr))and
                  ((vid_vy          -sr)<vy)and(vy<(vid_vy+vid_mh+sr))then _addUIBldrs(x,y,sr);

               if(rld>0)then
               begin
                  if(ucl=1)then
                  begin
                     inc(ui_trntc[utrain],1);
                     if(ui_trnt[utrain]=0)or(ui_trnt[utrain]>rld)then ui_trnt[utrain]:=rld;
                  end;

                  if(ucl=3)then
                  begin
                     inc(ui_upgrc,1);
                     if(ui_upgrl=0)or(ui_upgrl>rld)then ui_upgrl:=rld;
                     if(ui_upgr[utrain]=0)then ui_upgr[utrain]:=rld;
                  end;
               end;

               if(sel)then
                if(uid in whocanmp)then _sl_add(uo_x-spr_mp[race].hw, uo_y-spr_mp[race].surf^.h,uo_y-spr_mp[race].hh,0,0,0,false,spr_mp[race].surf,255,0,0,0,0,'',0);
            end
            else inc(ui_blds[ucl],1);
         end;
        end;

        if(_fog_ch(fx,fy,r))then
        begin
           _unit_minimap(u);

           if(uid=UID_HKeep)then
            if(buff[ub_clcast]>0)then exit;

           wanim:=false;
           if(_canmove(u))then
            wanim:=(x<>uo_x)or(y<>uo_y)or(x<>vx)or(y<>vy);

           spr:=_unit_spr(@_units[u]);
           sh :=0;
           smy:=vy;

           if(uid=UID_URadar)then dec(smy,15);

           if(shadow>0)then
           begin
              sh:=shadow;
              if(uid=UID_UCommandCenter)then
              begin
                 if(buff[ub_advanced]=0)
                 then dec(smy,buff[ub_clcast])
                 else inc(smy,buff[ub_clcast]);
              end;
           end;

           if ((vid_vx+vid_panel-spr^.hw)<vx )and(vx <(vid_vx+vid_mw+spr^.hw))and
              ((vid_vy-sh       -spr^.hh)<smy)and(smy<(vid_vy+vid_mh+spr^.hh)) then
           begin
              dp :=0;
              inv:=255;
              rc :=0;
              sb :=0;
              mc :=0;
              b0 :=0;
              b1 :='';
              b2 :=0;
              b3 :=0;
              rct:=false;
              rc :=plcolor[player];
              ro :=0;

              if(isbuild)then
              begin
                 if(sel)then
                 begin
                    if(ucl in [4,7])or(UID=UID_HAltar)then ro:=sr;
                    if(UID=UID_HSymbol)and(upgr[upgr_b478tel]>0)then ro:=sr;
                 end;
                 if(m_sbuild<=_uts)then ro:=r;
              end;

              if(wanim)then
              case uid of
                UID_Arachnotron :
                      begin
                         inc(foot,1);
                         foot:=foot mod 28;
                         if(foot=0)then PlaySND(snd_ar_f,u);
                      end;
                UID_Cyberdemon :
                      begin
                         inc(foot,1);
                         foot:=foot mod 30;
                         if(foot=0)then PlaySND(snd_cyberf,u);
                      end;
                UID_Mastermind :
                      begin
                         inc(foot,1);
                         foot:=foot mod 22;
                         if(foot=0)then PlaySND(snd_mindf,u);
                      end;
                UID_Cyclope:
                      begin
                         inc(foot,1);
                         foot:=foot mod 22;
                         if(foot=0)then PlaySND(snd_l_cy_f,u);
                      end;
              end;

              if((sel)and(player=HPlayer))or(k_alt>1)or((ui_umark_u=u)and(vid_rtui>6))then
              begin
                 rct:=true;
                 if(buff[ub_shield   ]>0)then b1:=b1+hp_pshield;
                 if(buff[ub_hellpower]>0)then b1:=b1+hp_char;
                 if(buff[ub_advanced ]>0)then b1:=b1+adv_char;
                 if(buff[ub_detect   ]>0)then b1:=b1+hp_detect;
                 if(player=HPlayer)then
                 begin
                    if(order>0)then b0:=order;
                    if(apcm>0)then
                    begin
                       b2:=apcm;
                       b3:=apcc;
                    end;
                 end;
              end;
              if(hits<mhits)or(rct)then sb:=hits/mhits;

              if(buff[ub_invis]>0)then
              begin
                 inv:=128;
                 if(buff[ub_vis]>0)then
                  if(team=_players[HPlayer].team)or(_fog=false)then inv:=255;  //
              end;
              if(buff[ub_hellpower]>0)then mc:=c_ared;
              if(buff[ub_shield   ]>0)then mc:=c_ablue;
              if(buff[ub_invuln   ]>0)then mc:=c_awhite;

              dp:=_udpth(u);

              if(isbuild)then
               if(bld)then
               begin
                  if(uid=UID_UTurret)then
                  begin
                     if(rld=0)then begin inc(dir,anims);dir:=dir mod 360;end;
                     t:=((dir+23) mod 360) div 45;
                     if(rld>rld_a)then t:=t+8;
                     _sl_add(vx-spr_tur [t].hw, smy-spr^.hh+3,dp,0,0,0,false,spr_tur [t].surf,inv,0,0,0,0,'',0);
                  end;
                  if(uid=UID_URTurret)then
                  begin
                     if(rld=0)then begin inc(dir,anims);dir:=dir mod 360;end;
                     t:=((dir+23) mod 360) div 45;
                     _sl_add(vx-spr_rtur[t].hw, smy-spr^.hh-5,dp,0,0,0,false,spr_rtur[t].surf,inv,0,0,0,0,'',0);
                  end;
                  if(player=HPlayer)then
                  begin
                     if(rld>0)then
                     begin
                        if(uid=UID_HMilitaryUnit)then
                        begin
                           case utrain of
                            0..11 : if(utrain=4)and(G_Addon)
                                    then _sl_add(vx-24, smy-24,dp,0,c_gray,0,true,spr_h_u4k             ,255,0,(rld div vid_fps)+1,0,0,'',0)
                                    else _sl_add(vx-24, smy-24,dp,0,c_gray,0,true,spr_b_u[r_hell,utrain],255,0,(rld div vid_fps)+1,0,0,'',0);
                            12    : _sl_add(vx-24, smy-24,dp,0,c_gray,0,true,spr_ZFormer  [23].surf,255,0,(rld div vid_fps)+1,0,0,'',0);
                            13    : _sl_add(vx-24, smy-24,dp,0,c_gray,0,true,spr_ZSergant [23].surf,255,0,(rld div vid_fps)+1,0,0,'',0);
                            14    : _sl_add(vx-24, smy-24,dp,0,c_gray,0,true,spr_ZCommando[23].surf,255,0,(rld div vid_fps)+1,0,0,'',0);
                            15    : _sl_add(vx-24, smy-24,dp,0,c_gray,0,true,spr_ZBomber  [23].surf,255,0,(rld div vid_fps)+1,0,0,'',0);
                            16    : _sl_add(vx-24, smy-24,dp,0,c_gray,0,true,spr_ZMajor   [23].surf,255,0,(rld div vid_fps)+1,0,0,'',0);
                            17    : _sl_add(vx-24, smy-24,dp,0,c_gray,0,true,spr_ZBFG     [23].surf,255,0,(rld div vid_fps)+1,0,0,'',0);
                           end;
                        end;
                        if(uid=UID_HGate)then
                        begin
                           if(utrain<12)then
                            if(utrain=4)and(G_Addon)
                            then _sl_add(vx-24, smy-24,dp,0,c_gray,0,true,spr_h_u4k             ,255,0,(rld div vid_fps)+1,0,0,'',0)
                            else _sl_add(vx-24, smy-24,dp,0,c_gray,0,true,spr_b_u[r_hell,utrain],255,0,(rld div vid_fps)+1,0,0,'',0);
                        end;
                        if(uid=UID_UMilitaryUnit)then
                         if(utrain<12)then _sl_add(vx-24,smy-24,dp,0,c_gray,0,true,spr_b_u [r_uac ,utrain],255,0,(rld div vid_fps)+1,0,0,'',0);
                        if(uid=UID_HPools        )then
                         if(utrain<=MaxUpgrs)then _sl_add(vx-24,smy-24,dp,0,c_red,0,true,spr_b_up[r_hell,utrain],255,0,(rld div vid_fps)+1,0,0,'',0);
                        if(uid=UID_UWeaponFactory)then
                         if(utrain<=MaxUpgrs)then _sl_add(vx-24,smy-24,dp,0,c_red,0,true,spr_b_up[r_uac ,utrain],255,0,(rld div vid_fps)+1,0,0,'',0);
                     end;
                  end;
               end
               else
                if(race=r_hell)then
                begin
                   inv:=trunc(255*hits/mhits);
                   if(r<41)
                   then _sl_add(vx-spr_db_h1.hw,smy-spr_db_h1.hh+5 ,-5,0,0,0,false,spr_db_h1.surf,255-inv,0,0,0,0,'',0)
                   else _sl_add(vx-spr_db_h0.hw,smy-spr_db_h0.hh+10,-5,0,0,0,false,spr_db_h0.surf,255-inv,0,0,0,0,'',0);
                   if(buff[ub_invis]>0)then inv:=inv shr 1;
                   dec(inv,inv shr 2);
                end;

               if(buff[ub_toxin]>0)then _sl_add(vx-spr_toxin.hw, smy-spr^.hh-spr_toxin.surf^.h-7,dp,0,0,0,false,spr_toxin.surf,inv,0,0,0,0,'',0);
               if(buff[ub_gear ]>0)then _sl_add(vx-spr_gear .hw, smy-spr^.hh-spr_gear .surf^.h-7,dp,0,0,0,false,spr_gear .surf,inv,0,0,0,0,'',0);

              _sl_add(vx-spr^.hw, smy-spr^.hh,dp,sh,rc,mc,rct,spr^.surf,inv,sb,b0,b2,b3,b1,ro);
           end;
        end;
     end;
end;

procedure _unit_bteleport(u:integer);
begin
   with _units[u] do
    with _players[player] do
     if(bld)then
      if(upgr[upgr_mainm]>0)and(buff[ub_clcast]=0)then
       if(_unit_grbcol(uo_x,uo_y,r,255,upgr[upgr_mainonr]=0)=0)then
       begin
          dec(upgr[upgr_mainm],1);
          if(_nhp(x,y,r)or _nhp(uo_x,uo_y,r))then PlaySND(snd_cubes,0);
          _effect_add(x,y,0,EID_HKT_h);
          buff[ub_clcast]:=vid_fps;
          x :=uo_x;
          y :=uo_y;
          vx:=x;
          vy:=y;
          _effect_add(x,y,0,EID_HKT_s);
          _unit_sfog(u);
          _unit_mmcoords(u);
       end;
end;

procedure _unit_b478teleport(u:integer);
begin
   with _units[u] do
    with _players[player] do
     if(bld)then
      if(upgr[upgr_b478tel]>0)and(buff[ub_clcast]=0)then
       if(dist2(x,y,uo_x,uo_y)<sr)and(_unit_grbcol(uo_x,uo_y,r,255,true)=0)then
       begin
          dec(upgr[upgr_b478tel],1);
          _unit_teleport(u,uo_x,uo_y);
          buff[ub_clcast]:=vid_fps;
       end;
end;

procedure _unit_action(u:integer);
var tx,ty:integer;
begin
   with _units[u] do
   if(bld)then
    with _players[player] do
     case uid of
UID_UCommandCenter:
      if(buff[ub_clcast]=0)then
       if(upgr[upgr_mainm]>0)then
       begin
          if(buff[ub_advanced]=0)then
          begin
             buff[ub_advanced]:=255;
             speed            := 6;
             uf               := uf_fly;
             buff[ub_clcast]  := uaccc_fly;
             dec(y,buff[ub_clcast]);
             PlaySND(snd_ccup,u);
             uo_x:=x;
             uo_y:=y;
          end
          else
            if(_unit_grbcol(x,y+uaccc_fly,r,255,upgr[upgr_mainonr]=0)=0)then
            begin
               buff[ub_advanced]:= 0;
               speed            := 0;
               uf               := uf_ground;
               buff[ub_clcast]  := uaccc_fly;
               inc(y,buff[ub_clcast]);
               vy:=y;
               PlaySND(snd_inapc,u);
               uo_x:=x;
               uo_y:=y;
            end;
       end;
UID_Engineer : if(army<MaxPlayerUnits)and(buff[ub_advanced]>0)and(menerg>0)and(inapc=0)then _unit_add(vx,vy,UID_Mine,player,true);
UID_APC,
UID_FAPC     : if(apcc>0)then uo_id:=ua_unload;
UID_Pain     : if(_canmove(u))then
               begin
                  buff[ub_cast]:=vid_hfps;
                  rld:=((dir+23) mod 360) div 45;
                  tx:=x+dir_stepX[rld]*15;
                  ty:=y+dir_stepY[rld]*15;
                  _pain_lost(u,tx,ty);
                  rld:=rld_r;
               end;
UID_HMonastery: if(buff[ub_advanced]>0)then buff[ub_cast]:=_uclord_p;
UID_Mine      : if(g_addon=false)or(upgr[upgr_minesen]>0)then if(buff[ub_advanced]>0)then buff[ub_advanced]:=0 else buff[ub_advanced]:=255;
UID_HMilitaryUnit :
                if(bld)and(rld>1)and(utrain in [12..17])then
                begin
                   inc(utrain,1);
                   if(utrain>17)then utrain:=12;
                   rld:=_ulst[cl2uid[race,false,utrain]].trt;
                   rld_a:=utrain;
                end;
     end;
end;

procedure _unit_movevis(u:integer);
begin
   with _units[u] do
    if(vx<>x)or(vy<>y)then
     if(speed=0)or(inapc>0)then
     begin
        vstp:=0;
        vx  :=x;
        vy  :=y;
     end
     else
     begin
        if(vstp=0)then vstp:=UnitStepNum;
        Inc(vx,(x-vx) div vstp);
        Inc(vy,(y-vy) div vstp);
        dec(vstp,1);
     end;
end;

procedure _unit_push(u,i,ud:integer);
var ix,iy,t:integer;
    tu:PTUnit;
begin
   with _units[u] do
   begin
      tu:=@_units[i];

      t:=ud;
      if(tu^.speed=0)
      then dec(ud,tu^.r)
      else dec(ud,r+tu^.r);

      if(ud<0)then
      begin
         if(t<=0)then t:=1;

         ix:=trunc(ud*(tu^.x-x)/t)+1-random(2);
         iy:=trunc(ud*(tu^.y-y)/t)+1-random(2);

         inc(x,ix);
         inc(y,iy);

         vstp:=UnitStepNum;

         _unit_correctcoords(u);
         _unit_mmcoords(u);
         _unit_sfog(u);

         dir:=(360+dir-(dir_diff(dir,p_dir(vx,vy,x,y)) div 2 )) mod 360;

         if(tu^.x=tu^.uo_x)and(tu^.y=tu^.uo_y)and(uo_tar=0)then
         begin
            ud:=dist2(uo_x,uo_y,tu^.x,tu^.y)-r-tu^.r;
            if(ud<=0)then
            begin
               uo_x:=x;
               uo_y:=y;
            end;
         end;
      end;
   end;
end;

procedure _unit_dpush(u,d:integer);
var ix,iy,t,ud:integer;
    td:PTDoodad;
begin
   with _Units[u] do
   begin
      td:=@map_dds[d];

      ud:=dist2(x,y,td^.x,td^.y);
      t:=ud;
      dec(ud,r+td^.r);

      if(ud<0)then
      begin
         if(t<=0)then t:=1;
         ix:=trunc(ud*(td^.x-x)/t)+1-random(2);
         iy:=trunc(ud*(td^.y-y)/t)+1-random(2);

         inc(x,ix);
         inc(y,iy);

         vstp:=UnitStepNum;

         _unit_correctcoords(u);
         _unit_mmcoords(u);
         _unit_sfog(u);

         if(rld=0)then dir:=p_dir(vx,vy,x,y);

         t:=dist2(uo_x,uo_y,td^.x,td^.y)-r-td^.r;
         if(t<=0)then
         begin
            uo_x:=x;
            uo_y:=y;
         end;
      end;
   end;
end;

procedure _unit_npush(u:integer);
var i:integer;
begin
   for i:=1 to MaxDoodads do
    with map_dds[i] do
     if(r>0)and(t>0)then
      _unit_dpush(u,i);
end;

procedure _unit_move(u:integer);
var mdist,tx,ty,spup:integer;
    tu:PTUnit;
begin
  with(_units[u])do
   if(inapc>0)then
   begin
      tu    :=@_units[inapc];
      fx    :=tu^.fx;
      fy    :=tu^.fy;
      x     :=tu^.x;
      y     :=tu^.y;
      mmx   :=tu^.mmx;
      mmy   :=tu^.mmy;
      uo_tar:=tu^.uo_tar;
      if(tu^.uo_id<>ua_unload)then uo_id:=tu^.uo_id;
      if(player=HPlayer)then
       if(tu^.sel)then inc(ui_apc[ucl],1);
   end
   else
    if(onlySVCode)then
     if(_canmove(u))then
     begin
        tx:=uo_x;
        ty:=uo_y;

        if(tar1>0)then
         if(uid in whocanattack)and(melee)then
         begin
            tu:=@_units[tar1];
            tx:=tu^.x;
            ty:=tu^.y;
            if(dtar<(r+tu^.r+melee_r))then exit;
         end;

       if(x=vx)and(y=vy)then
        if(x<>tx)or(y<>ty)then
        begin
           mdist:=dist2(x,y,tx,ty);
           if(mdist<=speed)then
           begin
              x:=tx;
              y:=ty;
              dir:=p_dir(vx,vy,x,y);
           end
           else
           begin
              spup:=speed;

              if(uid=UID_UTransport)and(buff[ub_pain]>0)then dec(spup,2);

              with _players[player] do
              begin
                 if(race=r_uac)then
                  case mech of
                  true : if(upgr[upgr_mechspd]>0)then inc(spup,upgr[upgr_mechspd]);
                  false: if(upgr[upgr_mspeed ]>0)then inc(spup,upgr[upgr_mspeed ]);
                  end;

                 if(race=r_hell)and(buff[ub_hellpower]>0)then inc(spup,2);
              end;

              if(mdist>70)
              then mdist:=8+random(25)
              else mdist:=50;

              dir:=dir_turn(dir,p_dir(x,y,tx,ty),mdist);

              x:=x+round(spup*cos(dir*degtorad));
              y:=y-round(spup*sin(dir*degtorad));
           end;
           if(uf=uf_ground)and(solid)then _unit_npush(u);
           _unit_correctcoords(u);
           _unit_mmcoords(u);
           _unit_sfog(u);
        end;
    end;
end;

procedure _unit_attack(u:integer);
var tu1:PTUnit;
    ux,uy,mdam:integer;
begin
   with _units[u] do
   begin
      if(tar1=0)then exit;

      tu1:=@_units[tar1];

      if(rld=0)then
      begin
         _unit_swmelee(u);

         mdam:=mdmg;

         if(melee)then
         begin
            if(dtar>=(tu1^.r+r+melee_r))then exit;

            with _players[player] do
             if(upgr[upgr_melee]>0)then
             case race of
                r_hell : inc(mdam,upgr[upgr_melee]*5);
                r_uac  : inc(mdam,upgr[upgr_melee]*2);
             end;
         end;

         if(buff[ub_invis]>0)and(buff[ub_vis]<vid_hfps)then
          if(uid in marines)then buff[ub_vis]:=240;

         if(tar1<>u)then
          case uid of
          UID_Flyer : if(buff[ub_advanced]=0)then dir:=p_dir(x,y,tu1^.x,tu1^.y);
          UID_APC,
          UID_FAPC,
          UID_UCommandCenter :;
          else dir:=p_dir(x,y,tu1^.x,tu1^.y);
          end;

         case uid of
         UID_LostSoul :
               begin
                  if(tu1^.mech)then mdam:=mdam div 3;
                  PlaySND(snd_d0,u);
                  rld:=rld_r;
                  if(buff[ub_hellpower]>0)then dec(rld,5);

                  if(OnlySVCode)then
                  if(buff[ub_advanced]>0)then
                   if(tu1^.uid in marines)then
                   begin
                      uy:=order;
                      ux:=tar1;
                      mdam:=tu1^.hits;

                      _unit_kill(u,true,true);
                      hits:=ndead_hits;

                      case tu1^.uid of
                      UID_Medic,
                      UID_Engineer : _unit_add(tu1^.vx,tu1^.vy,UID_ZFormer  ,player,true);
                      UID_Sergant  : _unit_add(tu1^.vx,tu1^.vy,UID_ZSergant ,player,true);
                      UID_Commando : _unit_add(tu1^.vx,tu1^.vy,UID_ZCommando,player,true);
                      UID_Bomber   : _unit_add(tu1^.vx,tu1^.vy,UID_ZBomber  ,player,true);
                      UID_Major    : _unit_add(tu1^.vx,tu1^.vy,UID_ZMajor   ,player,true);
                      UID_BFG      : _unit_add(tu1^.vx,tu1^.vy,UID_ZBFG     ,player,true);
                      end;
                      if(tu1^.hits<0)then
                      begin
                         _lcup^.hits:=-100;
                         _lcup^.buff[ub_resur]:=254;
                      end
                      else
                        if(mdam>0)then _lcup^.hits:=mdam;
                      _lcup^.buff[ub_advanced]:=tu1^.buff[ub_advanced];
                      _lcup^.dir:=tu1^.dir;
                      _lcup^.order:=uy;

                      _unit_kill(ux,true,true);
                      _units[ux].hits:=ndead_hits;
                      exit;
                   end
                   else
                     if(tu1^.uid=UID_UMilitaryUnit)and(tu1^.hits<1000)and(tu1^.bld)then
                     begin
                        ux:=tar1;
                        mdam:=tu1^.hits;
                        _unit_kill(u,true,true);
                        hits:=ndead_hits;

                        _lcu:=0;
                        _unit_add(tu1^.vx,tu1^.vy,UID_HMilitaryUnit  ,player,true);
                        _effect_add(tu1^.vx,tu1^.vy,tu1^.vy+1,UID_HMilitaryUnit);
                        PlaySND(snd_hellbar,u);
                        _lcup^.hits:=mdam;

                        _unit_kill(ux,true,true);
                        _units[ux].hits:=ndead_hits;
                        exit;
                     end;

                  _unit_damage(tar1,mdam,2,player);
               end;
         UID_Imp      :
               begin
                  if(melee)then
                  begin
                     PlaySND(snd_hmelee,u);
                     _unit_damage(tar1,mdam,1,player);
                  end
                  else
                  begin
                     PlaySND(snd_hshoot,u);
                     _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_Imp,player,tu1^.uf,buff[ub_hellpower]);
                  end;
                  rld:=rld_r;
                  if(buff[ub_hellpower]>0)then dec(rld,5);
               end;
         UID_Demon    :
               begin
                  _unit_damage(tar1,mdam,1,player);
                  PlaySND(snd_demona,u);
                  rld:=rld_r;
                  if(buff[ub_hellpower]>0)then dec(rld,5);
               end;
         UID_Cacodemon:
               begin
                  if(melee)then
                  begin
                     PlaySND(snd_hmelee,u);
                     _unit_damage(tar1,mdam,1,player);
                  end
                  else
                  begin
                     PlaySND(snd_hshoot,u);
                     _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_Cacodemon,player,tu1^.uf,buff[ub_hellpower]);
                  end;
                  rld:=rld_r;
                  if(buff[ub_hellpower]>0)then dec(rld,6);
               end;
         UID_Baron:
               begin
                  if(melee)then
                  begin
                     PlaySND(snd_hmelee,u);
                     _unit_damage(tar1,mdam,1,player);
                  end
                  else
                  begin
                     PlaySND(snd_hshoot,u);
                     _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_Baron,player,tu1^.uf,buff[ub_hellpower]);
                  end;
                  rld:=rld_r;
                  if(buff[ub_hellpower]>0)then dec(rld,7);
               end;
         UID_Cyberdemon:
               begin
                  PlaySND(snd_launch,u);
                  _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_HRocket,player,tu1^.uf,0);
                  rld:=rld_r;
               end;
         UID_Mastermind:
               begin
                  PlaySND(snd_shotgun,u);
                  _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_Bulletx2,player,tu1^.uf,0);
                  rld:=rld_r;
               end;
         UID_Pain     :
               begin
                  rld:=((dir+23) mod 360) div 45;
                  ux :=x+dir_stepX[rld]*15;
                  uy :=y+dir_stepY[rld]*15;
                  rld:=rld_r;
                  if(buff[ub_hellpower]>0)then dec(rld,5);
                  _pain_lost(u,ux,uy);
               end;
         UID_Revenant:
               begin
                  if(melee)then
                  begin
                     PlaySND(snd_rev_m,u);
                     _unit_damage(tar1,mdam,1,player);
                     rld:=rld_r shr 1;
                  end
                  else
                  begin
                     PlaySND(snd_rev_a,u);

                     with _players[player] do
                      if(upgr[upgr_revmis]>0)
                      then ux:=MID_RevenantS
                      else ux:=MID_Revenant;

                     if(buff[ub_advanced]=0)
                     then _miss_add(tu1^.x,tu1^.y,vx,vy-16,tar1,ux,player,tu1^.uf,buff[ub_hellpower])
                     else
                     begin
                        _miss_add(tu1^.x,tu1^.y,vx-6,vy-16,tar1,ux,player,tu1^.uf,buff[ub_hellpower]);
                        _miss_add(tu1^.x,tu1^.y,vx+6,vy-16,tar1,ux,player,tu1^.uf,buff[ub_hellpower]);
                     end;

                     rld:=rld_r;
                     if(buff[ub_hellpower]>0)then dec(rld,5);
                  end;
               end;
         UID_Mancubus :
               begin
                  PlaySND(snd_man_a,u);
                  rld:=rld_r;
               end;
         UID_Arachnotron:
               begin
                  PlaySND(snd_plasmas,u);
                  _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_YPlasma,player,tu1^.uf,buff[ub_hellpower]);
                  if(buff[ub_advanced]>0)
                  then rld:=rld_r-3
                  else rld:=rld_r;
               end;
         UID_ArchVile :
               begin
                  if(melee)then
                  begin
                     PlaySND(snd_meat,u);
                     buff[ub_cast]:=vid_fps;
                     rld:=vid_fps;
                     if(OnlySVCode)then
                     begin
                        tu1^.buff[ub_resur]:=255;
                        tar1:=0;
                        dtar:=32000;
                     end;
                     exit;
                  end
                  else
                   if(buff[ub_cast]=0)then
                   begin
                      PlaySND(snd_arch_at,u);
                      rld:=rld_r;
                      if(_nhp(tu1^.x,tu1^.y,tu1^.r))then
                      begin
                         PlaySND(snd_arch_f,0);
                         _effect_add(tu1^.x,tu1^.y,tu1^.vy+map_flydpth[tu1^.uf]+1,EID_ArchFire);
                      end;
                   end;
               end;

         UID_Engineer:
               begin
                  if(melee)then
                  begin
                     if(tu1^.buff[ub_pain]=0)then
                     begin
                        PlaySND(snd_cast2,u);
                        rld:=rld_r;
                        if(onlySVCode)then
                        begin
                           inc(tu1^.hits,mdmg);
                           if(tu1^.hits>tu1^.mhits)then tu1^.hits:=tu1^.mhits;
                        end;
                     end;
                  end
                  else
                  begin
                     PlaySND(snd_pistol,u);
                     _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_Bullet,player,tu1^.uf,0);
                     rld:=rld_r;
                  end;
               end;
         UID_Medic :
               begin
                  if(melee)then
                  begin
                     if(tu1^.buff[ub_pain]=0)then
                     begin
                        PlaySND(snd_cast,u);
                        rld:=rld_r;
                        if(onlySVCode)then
                        begin
                           inc(tu1^.hits,mdmg);
                           if(tu1^.hits>tu1^.mhits)then tu1^.hits:=tu1^.mhits;
                           if not(tu1^.uid in marines)then tu1^.buff[ub_pain]:=vid_hfps;
                        end;
                     end;
                  end
                  else
                  begin
                     PlaySND(snd_pistol,u);
                     if(buff[ub_advanced]=0)
                     then _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_Bullet ,player,tu1^.uf,0)
                     else _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_TBullet,player,tu1^.uf,0);
                     rld:=rld_r;
                  end;
               end;
         UID_ZFormer:
               begin
                  PlaySND(snd_pistol,u);
                  _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_Bullet,player,tu1^.uf,0);
                  rld:=rld_r;
               end;

         UID_ZSergant,
         UID_Sergant:
               begin
                  if(buff[ub_advanced]>0)then
                  begin
                     PlaySND(snd_ssg,u);
                     _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_SSShot,player,tu1^.uf,0);
                     inc(rld,10);
                  end
                  else
                  begin
                     PlaySND(snd_shotgun,u);
                     _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_SShot,player,tu1^.uf,0);
                  end;
                  rld:=rld_r;
               end;
         UID_ZCommando:
               begin
                  PlaySND(snd_shotgun,u);
                  _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_Bullet,player,tu1^.uf,0);
                  if(buff[ub_advanced]=0)
                  then rld:=rld_r
                  else rld:=rld_r-2;
               end;
         UID_Commando:
               begin
                  PlaySND(snd_pistol,u);
                  _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_Bullet,player,tu1^.uf,0);
                  if(buff[ub_advanced]=0)
                  then rld:=rld_r
                  else rld:=rld_r-2;
               end;
         UID_Bomber,
         UID_ZBomber:
               begin
                  PlaySND(snd_launch,u);
                  if(buff[ub_advanced]=0)
                  then _miss_add(tu1^.x,tu1^.y,vx,vy-6,tar1,MID_Granade,player,tu1^.uf,0)
                  else _miss_add(tu1^.x,tu1^.y,vx,vy-6,tar1,MID_URocket,player,tu1^.uf,0);
                  rld:=rld_r;
               end;
         UID_Major,
         UID_ZMajor:
               begin
                  PlaySND(snd_plasmas,u);
                  _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_BPlasma,player,tu1^.uf,buff[ub_advanced]);
                  rld:=rld_r;
               end;
         UID_BFG,
         UID_ZBFG:
               begin
                  PlaySND(snd_bfgs,u);
                  rld:=rld_r;
               end;
         UID_Terminator:
               begin
                  if(buff[ub_clcast]=0)then
                  begin
                     if(buff[ub_advanced]=0)then
                     begin
                        PlaySND(snd_shotgun,u);
                        _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_SShot,player,tu1^.uf,0);
                     end
                     else
                     begin
                        PlaySND(snd_ssg,u);
                        _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_SSShot,player,tu1^.uf,0);
                     end;
                     rld:=15;
                     buff[ub_clcast]:=vid_fps;
                  end
                  else
                    if(buff[ub_advanced]>0)then
                    begin
                       PlaySND(snd_shotgun,u);
                       _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_Bulletx2,player,tu1^.uf,0);
                       rld:=rld_r;
                    end
                    else
                    begin
                       PlaySND(snd_pistol,u);
                       _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_Bullet,player,tu1^.uf,0);
                       rld:=rld_r;
                    end;
               end;
         UID_Tank:
               begin
                  PlaySND(snd_exp,u);
                  _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_Granade,player,tu1^.uf,1);
                  rld:=rld_r;
               end;
         UID_Flyer:
               begin
                  PlaySND(snd_plasmas,u);
                  _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_BPlasma,player,tu1^.uf,1);
                  rld:=rld_r;
                  buff[ub_clcast]:=rld;
               end;

         UID_Mine:
               if(buff[ub_advanced]=0)and(dtar<40)and(tu1^.uf<uf_fly)then
               begin
                  _miss_add(vx,vy,vx,vy,0,MID_Mine,player,0,1);
                  if(OnlySVCode)then _unit_kill(u,false,true);
               end;

         UID_Dron:
               begin
                  _miss_add(vx,vy,vx,vy,0,MID_Blizzard,player,1,1);
                  if(OnlySVCode)then _unit_kill(u,false,true);
               end;
         UID_Octobrain:
               begin
                  PlaySND(snd_l_octo_a,u);
                  rld:=rld_r;
               end;
         UID_Cyclope:
               begin
                  PlaySND(snd_l_cy_a,u);
                  _miss_add(tu1^.x,tu1^.y,vx-7,vy-7,tar1,MID_URocket,player,tu1^.uf,0);
                  _miss_add(tu1^.x,tu1^.y,vx+7,vy+7,tar1,MID_URocket,player,tu1^.uf,0);
                  rld:=rld_r;
               end;

         UID_HTower:
               begin
                  PlaySND(snd_hshoot,u);
                  if(tu1^.uid=UID_Cacodemon)
                  then _miss_add(tu1^.x,tu1^.y,vx,vy-15,tar1,MID_Imp,player,tu1^.uf,1)
                  else _miss_add(tu1^.x,tu1^.y,vx,vy-15,tar1,MID_Cacodemon,player,tu1^.uf,1);

                  if(buff[ub_advanced]>0)
                  then rld:=rld_r-5
                  else rld:=rld_r;
               end;
         UID_HTotem:
               begin
                  rld:=rld_r;
                  if(_nhp(tu1^.x,tu1^.y,tu1^.r))then
                  begin
                     PlaySND(snd_arch_f,0);
                     _effect_add(tu1^.x,tu1^.y,tu1^.vy+map_flydpth[tu1^.uf]+1,EID_ArchFire);
                  end;
               end;
         UID_UTurret:
               begin
                  PlaySND(snd_pistol,u);
                  _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_Bullet,player,tu1^.uf,0);
                  rld:=rld_r;
               end;
         UID_URTurret:
               begin
                  PlaySND(snd_launch,u);
                  _miss_add(tu1^.x,tu1^.y,vx,vy-20,tar1,MID_HRocket,player,tu1^.uf,0);
                  rld:=rld_r;
               end;
         end;
         if(rld>0)then
         begin
            if(_uclord_p>rld)
            then buff[ub_stopafa]:=_uclord_p
            else buff[ub_stopafa]:=rld;
         end;
         if(uid=UID_Flyer)and(buff[ub_advanced]>0)then buff[ub_stopafa]:=0;
      end;

      if(rld>0)then
       case uid of
        UID_HTotem,
        UID_ArchVile :
           if(tu1^.player<>player)then //(melee=false)and(buff[ub_cast]=0)and
           begin
              if(rld=rld_a)
              then _miss_add(tu1^.x,tu1^.y,tu1^.x,tu1^.y,0,MID_ArchFire,player,tu1^.uf,0)
              else
              begin
                 if(tu1^.buff[ub_vis]<vid_hfps)then tu1^.buff[ub_vis]:=vid_hfps;
                 if((rld mod 20)=0) then dir:=p_dir(x,y,tu1^.x,tu1^.y);
                 if((rld mod 40)=0) then
                  if(_nhp(tu1^.x,tu1^.y,tu1^.r))then
                  begin
                     PlaySND(snd_arch_f,0);
                     if(tu1^.isbuild)and(tu1^.r>20)then
                     begin
                        ux:=tu1^.r div 2;
                        _effect_add(tu1^.x-random(tu1^.r)+ux,tu1^.y-random(tu1^.r)+ux,tu1^.vy+map_flydpth[tu1^.uf]+1,EID_ArchFire)
                     end
                     else _effect_add(tu1^.x,tu1^.y,tu1^.vy+map_flydpth[tu1^.uf]+1,EID_ArchFire);
                  end;
              end;
           end;
        UID_Mancubus:
           begin
              case rld of
              110,
              70,
              30:begin
                    dir:=p_dir(x,y,tu1^.x,tu1^.y);
                    PlaySND(snd_hshoot,u);
                    _miss_add(tu1^.x,tu1^.y,vx-7,vy-7,tar1,MID_Mancubus,player,tu1^.uf,buff[ub_hellpower]);
                    _miss_add(tu1^.x,tu1^.y,vx+7,vy+7,tar1,MID_Mancubus,player,tu1^.uf,buff[ub_hellpower]);
                 end;
              end;
           end;
        UID_BFG,
        UID_ZBFG:
           if(rld=70)then
           begin
              dir:=p_dir(x,y,tu1^.x,tu1^.y);
              _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_BFG,player,uf_soaring,0);
           end;
        UID_Octobrain:
           if(rld=rld_a)then
           begin
              dir:=p_dir(x,y,tu1^.x,tu1^.y);
              _miss_add(tu1^.x,tu1^.y,vx,vy-7,tar1,MID_Octo,player,tu1^.uf,0);
           end;

       end;
   end;
end;

function _canattack(u:integer):boolean;
begin
   _canattack:=false;
   with _units[u] do
   begin
      if not(uid in whocanattack)then exit;

      if(isbuild)then
      begin
         if(bld=false) then exit;
      end
      else
        case mech of
        false: if(buff[ub_pain ]>0)
               or(buff[ub_toxin]>0)
               or(buff[ub_gear ]>0)then exit;
        true : if(buff[ub_gear ]>0)then exit;
        end;

      if(inapc>0)then
       if(_units[inapc].uid<>UID_APC)or(_units[inapc].inapc>0)then exit;

      _canattack:=true;
   end;
end;

function _TarPrio(u,ntar:PTUnit):boolean;
begin
   _TarPrio:=true;
   with u^ do
   begin
      with _players[player]do
       if(ntar^.uid=UID_Pain)and(state=ps_comp)and(ai_skill>3)and(melee=false)then exit;

      case uid of
       UID_Imp,
       UID_Cacodemon,
       UID_Baron      : if(uid<>ntar^.uid)then exit;
       UID_Bomber,
       UID_Tank,
       UID_Mancubus   : if(ntar^.isbuild)then exit;
       UID_Archvile,
       UID_HTotem     : if(ntar^.isbuild=false)then exit;
       UID_Medic,
       UID_Terminator,
       UID_Arachnotron,
       UID_Mastermind,
       UID_UTurret,
       UID_Commando   : if(ntar^.mech=false)then exit;
       UID_Revenant   : if((ntar^.mech)and(ntar^.isbuild=false))or(ntar^.uid in [UID_Cyberdemon,UID_Mastermind,UID_Arachnotron])then exit;
       UID_Mine       : if(ntar^.uf<uf_fly)then exit;
      else
       exit;
      end;
   end;
   _TarPrio:=false;
end;

function _TarPrioDT(u,ntar:PTUnit;ud:integer):boolean;
var ptar:PTUnit;
begin
   _TarPrioDT:=true;
   with u^ do
   begin
      if(tar1=0)then exit;
      ptar:=@_units[tar1];

      if(_TarPrio(u,ntar)=false)then
      begin
         if(_TarPrio(u,ptar)=false)and(ud<dtar)then exit;
      end
      else
        if(_TarPrio(u,ptar)=false)or(ud<dtar)then exit;
   end;
   _TarPrioDT:=false;
end;

function _unit_tardetect(u,t,ud:integer):boolean;
var tu:PTUnit;
 teams:boolean;
begin
   _unit_tardetect:=false;

   with _units[u] do
   begin
      tu:=@_units[t];

      teams:=_players[player].team=_players[tu^.player].team;

      if(tu^.buff[ub_invis]>0)then
       if(bld)and(buff[ub_toxin]=0)and(buff[ub_detect]>0)then
        if(teams=false)then
        begin
           if(ud<sr)then
            if(tu^.buff[ub_vis]<vid_fps)then tu^.buff[ub_vis]:=vid_fps;

           if(uid=UID_URadar)and(rld>radar_time)then
             if(dist2(uo_x,uo_y,tu^.x,tu^.y)<=sr)then
              if(tu^.buff[ub_vis]<vid_fps)then tu^.buff[ub_vis]:=vid_fps;
        end;

      if(teams=false)and(ud<sr)and(inapc=0)and(_players[player].team=_players[HPlayer].team)then
       if(tu^.buff[ub_vis]>0)or(tu^.buff[ub_invis]=0)then _unit_tardetect:=true;

      if(onlySVCode)then
      begin
         if(tu^.hits>0)and(inapc=0)then
          if(teams)then
          begin
             if(tu^.alrm_i)and(alrm_i=false)then
             begin
                if(tu^.uid<>UID_Mine)then
                 if(tu^.isbuild)then alrm_b:=true;
                if(tu^.isbuild=alrm_b)or(ud<base_r)then
                 if(ud<alrm_r)then
                 begin
                    alrm_x:=tu^.alrm_x;
                    alrm_y:=tu^.alrm_y;
                    alrm_r:=ud;
                 end;
             end;
          end
          else
          begin
             if(_players[player].ai_skill>2)and(alrm_b=false)and(ud<alrm_r)and(tu^.uid<>UID_Mine)then
              case((menu_s2=ms2_camp)or(_players[player].ai_skill>4))of
              true : if(tu^.isbuild)and((buff[ub_invis]=0)or(buff[ub_vis]>0))then
                     begin
                        alrm_x:=tu^.x;
                        alrm_y:=tu^.y;
                        alrm_r:=ud;
                     end;
              false: if(_players[tu^.player].u_e[true,0]=0)then
                     begin
                        alrm_x:=tu^.x;
                        alrm_y:=tu^.y;
                        alrm_r:=ud;
                     end;
              end;
          end;

         with _players[player] do
          if(isbuild)and(bld)then
          begin
             if(uid=UID_HKeep)then
              if(ud<sr)and(teams=false)then
               if(upgr[upgr_paina]>0)then _unit_damage(t,upgr[upgr_paina] shl 1,1,player);

             if(uid=UID_HAltar)then
             begin
                if(rld<3)then
                 if(tu^.player=player)and(tu^.mech=false)and(tu^.buff[ub_hellpower]<vid_hfps)then
                 begin
                    inc(rld,1);
                    tu^.buff[ub_hellpower]:=vid_fps+vid_fps*upgr[upgr_hpower];
                 end;
                if(upgr[upgr_bldrep]>0)and(rld_a<3)then
                 if(teams)and(tu^.isbuild)and(tu^.bld)and(tu^.hits<tu^.mhits)and(tu^.buff[ub_pain]=0)then
                 begin
                    inc(tu^.hits,upgr[upgr_bldrep]);
                    if(tu^.hits>tu^.mhits)then tu^.hits:=tu^.mhits;
                    inc(rld_a,1);
                 end;
             end;
             if(g_addon=false)then
             if(uid=UID_HMonastery)then
             begin
                if(rld<utrain)then
                 if(tu^.player=player)and(tu^.mech=false)and(tu^.buff[ub_hellpower]<vid_fps)then
                 begin
                    inc(rld,1);
                    tu^.buff[ub_hellpower]:=100;
                 end;
                if(teams)and(tu^.isbuild)and(tu^.bld)and(tu^.hits<tu^.mhits)and(tu^.buff[ub_pain]=0)then inc(tu^.hits,1);
             end;
          end;

         if(uo_id=ua_amove)then
         begin
            if(buff[ub_cast]>0)and(uid=UID_Archvile)then exit;

            if(_unit_chktar(u,t,ud))then
            begin
               if(_TarPrioDT(@_units[u],tu,ud))then
               begin
                  tar1:=t;
                  dtar:=ud;
               end;

               if(inapc=0)and(teams=false)then
               begin
                  alrm_x:=tu^.x;
                  alrm_y:=tu^.y;
                  alrm_r:=dtar;
                  alrm_i:=true;
               end;
            end;
         end;

      end;
   end;
end;

procedure _unit_sattack(u:integer);
var tu1:PTUnit;
begin
   with _units[u] do
   if(bld)then
   with _players[player] do
   begin
      case uid of
         UID_UCommandCenter :
          if(uf>uf_ground)and(buff[ub_clcast2]=0)then
          begin
             if(tar1>0)
             then tu1:=@_units[tar1]
             else exit;
             case g_addon of
               true : if(upgr[upgr_ucomatt]>0)then
                      begin
                         PlaySND(snd_pexp,u);
                         _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_BFG,player,tu1^.uf,1);
                         buff[ub_clcast2]:=250;
                      end;
               false:
                      begin
                         PlaySND(snd_launch,u);
                         _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_URocket,player,tu1^.uf,0);
                         buff[ub_clcast2]:=180;
                      end;
             end;
          end;
         UID_Engineer :
          if(inapc>0)and(onlySVCode)then
          if(buff[ub_clcast2]=0)then
          begin
             tu1:=@_units[inapc];
             if(tu1^.buff[ub_pain]=0)then
              if(tu1^.hits<tu1^.mhits)then
              begin
                 inc(tu1^.hits,upgr[upgr_melee]+1);
                 if(tu1^.hits>tu1^.mhits)then tu1^.hits:=tu1^.mhits;
                 buff[ub_clcast2]:=vid_fps;
                 PlaySND(snd_cast2,u);
              end;
          end;
         UID_UTurret:
          if(upgr[upgr_addtur]>0)then
          begin
             if(tar1>0)
             then tu1:=@_units[tar1]
             else exit;

             PlaySND(snd_plasmas,u);
             _miss_add(tu1^.x,tu1^.y,vx,vy-15,tar1,MID_BPlasma,player,tu1^.uf,0);
          end;
         //
         UID_APC,
         UID_FAPC :
          if(upgr[upgr_apctur]>0)then
          begin
             if(tar1>0)
             then tu1:=@_units[tar1]
             else exit;

             PlaySND(snd_plasmas,u);
             _miss_add(tu1^.x,tu1^.y,vx,vy,tar1,MID_BPlasma,player,tu1^.uf,0);
          end;
      end;
   end;
end;

procedure _unit_code1_n(u:integer);// inapc or OnlySVCode=false
var uc,
    ud:integer;
    tu:PTUnit;
    uialrm:boolean;
begin
   with _units[u] do
   if(_uclord=_uclord_c)then
   begin
      alrm_x:=0;
      alrm_y:=0;
      alrm_r:=32000;
      alrm_i:=false;
      uialrm:=false;

      for uc:=1 to MaxUnits do
       if(uc<>u)then
       begin
          tu:=@_units[uc];
          if(tu^.hits>0)and(tu^.inapc=0)then
          begin
             ud:=dist2(x,y,tu^.x,tu^.y);

             uialrm:=_unit_tardetect(u,uc,ud) or uialrm;
          end;
       end;

      if(uialrm)then ui_addalrm(mmx,mmy,isbuild);

      _unit_sattack(u);
   end;
end;

{$include _ai.pas}

procedure _unit_code1(u:integer);
var uc,niapc,rl_e,rl_a,
    ud,dnpt,dnb:integer;
    npt:byte;
    tu:PTUnit;
    cnmv:boolean;
    uialrm:boolean;
begin
   with _units[u] do
   with _players[player] do
   begin
      if(_uclord=_uclord_c)then
      begin
         npt := 0;
         dnpt:= 32000;
         if(g_mode=gm_ct)then
         begin
            if(isbuild=false)then
            for uc:=1 to MaxPlayers do
             with g_ct_pl[uc] do
             begin
                ud:=dist2(x,y,px,py);

                if(ud<=g_ct_pr)and(_players[pl].team<>team)then
                 if(ct<g_ct_ct[race])
                 then inc(ct,vid_hfps)
                 else
                   if(ct>=g_ct_ct[race])then
                   begin
                      pl:=player;
                      ct:=0;
                   end;

                if(_players[pl].team<>team)or(pl=0)or(ct>0)then
                begin
                   if(ud<dnpt)then
                   begin
                      dnpt:=ud;
                      npt :=uc;
                   end;
                end;
             end;

            if(npt>0)then
            begin
               alrm_x:=g_ct_pl[npt].px;
               alrm_y:=g_ct_pl[npt].py;
            end;
         end;

         if(state=ps_comp)then
          case uid of
           UID_URocketL  : if(rld=0)then
                           begin
                              uo_x:=alrm_x-base_r+random(base_rr);
                              uo_y:=alrm_y-base_r+random(base_rr);
                           end;
           UID_FAPC      : begin
                              case map_ffly of
                              false : if(alrm_r<base_r)then uo_id:=ua_unload;
                              true  : if(alrm_r<210   )then uo_id:=ua_unload;
                              end;
                              if(g_mode=gm_ct)and(dnpt<=g_ct_pr)then uo_id:=ua_unload;
                              uo_tar:=0;
                              if(order=1)then order:=0;
                           end;
           UID_Engineer   : if(tar1>0)and(melee)
                           then order:=1
                           else
                             if(order=1)then order:=0;
           UID_Medic     : if(tar1>0)and(melee)
                           then order:=1
                           else
                             if(order=1)then order:=0;
          else
             if(order=1)then order:=0;
          end;

         dtar    := 32000;
         tar1    := 0;
         cnmv    := _canmove(u);
         niapc   := 32000;
         dnb     := 32000;
         alrm_r  := 32000;
         alrm_b  := false;
         alrm_i  := false;
         uialrm  := false;

         rl_e    := 0;
         rl_a    := 0;

         if(uid=UID_HAltar)then rld_a:=0;

         for uc:=1 to MaxUnits do
          if(uc<>u)then
          begin
             tu:=@_units[uc];
             if(tu^.hits>0)then
             begin
                if(tu^.inapc>0)then // unload
                begin
                   if(tu^.inapc=u)and(uo_id=ua_unload)then
                   begin
                      if(apcc>0)then
                      begin
                         dec(apcc,tu^.apcs);
                         tu^.inapc:=0;
                         tu^.x:=tu^.x-20+random(40);
                         tu^.y:=tu^.y-20+random(40);
                         tu^.uo_x:=tu^.x;
                         tu^.uo_y:=tu^.y;
                         if(apcc=0)then PlaySND(snd_inapc,u);
                      end;
                      if(apcc=0)then uo_id:=ua_move;
                   end;
                   continue;
                end;

                ud:=dist2(x,y,tu^.x,tu^.y);

                uialrm:=_unit_tardetect(u,uc,ud) or uialrm;

                if(cnmv)then
                 if(r<=tu^.r)or(tu^.speed=0)then
                  if(tu^.solid)and(solid)and(sign(uf)=sign(tu^.uf))and(ud<sr)then _unit_push(u,uc,ud);

                dec(ud,r+tu^.r);
                if(state=ps_comp)and(bld)and(tu^.bld)then
                begin
                   if(player=tu^.player)then
                   begin
                      if(uid in [UID_APC,UID_FAPC])then
                       if(_itcanapc(@_units[u],tu))and(ud<niapc)and(tu^.order<>1)then
                       begin
                          order:=1;
                          niapc:=ud;
                          uo_x :=tu^.x;
                          uo_y :=tu^.y;
                          dir  :=p_dir(x,y,uo_x,uo_y);
                          if(ud<melee_r)then uo_tar:=uc;
                       end;

                      if(isbuild=false)and(race=r_uac)and(uid<>UID_UTransport)then
                       if(tu^.uid=UID_UVehicleFactory)and(buff[ub_advanced]=0)and(tu^.buff[ub_advanced]>0)and(tu^.rld=0)and(ud<base_rr)and(alrm_r>base_r)then
                       begin
                          order:=1;
                          uo_x :=tu^.x;
                          uo_y :=tu^.y;
                          if(ud<melee_r)then
                          begin
                             buff[ub_gear]:=gear_time[mech];
                             buff[ub_advanced]:=255;
                             if(mech)
                             then tu^.rld:=mech_adv_rel[(g_addon=false)or(upgr[upgr_6bld2]>0)]
                             else tu^.rld:=uac_adv_rel [(g_addon=false)or(upgr[upgr_6bld2]>0)];
                             PlaySND(snd_uupgr,u);
                          end;
                       end;
                   end;

                   if(uid=UID_URocketL)then
                   begin
                      if(abs(uo_x-tu^.x)<=blizz_w)and(abs(uo_y-tu^.y)<=blizz_w)and(tu^.speed<10)then
                       if(team=_players[tu^.player].team)
                       then inc(rl_a,1)
                       else inc(rl_e,1);
                   end
                   else
                    if(ud<=sr)then
                     if(team=_players[tu^.player].team)
                     then inc(rl_a,1)
                     else inc(rl_e,1);
                end;

                if(player=tu^.player)then
                begin
                   if(tu^.isbuild)and(tu^.uid<>UID_Mine)then
                   begin
                      if(ud<dnb)and(tu^.ucl<9)then
                      begin
                         dnb:=ud;
                         ai_basex:=tu^.x;
                         ai_basey:=tu^.y;
                      end;
                   end;

                   if(uid=UID_HMonastery)and(race=r_hell)and(buff[ub_cast]>0)then
                    if(buff[ub_advanced]>0)and(tu^.uid in demons)and(tu^.buff[ub_advanced]=0)and(utrain>=n_souls)and(tu^.isbuild=false)and(bld)and(tu^.bld)then
                    begin
                       if(state=ps_comp)then
                       begin
                          if(tu^.uid=UID_LostSoul)and(u_e[false,7]>0)then continue;
                          if(g_addon=false)and(utrain<20)then continue;
                       end;
                       dec(utrain,n_souls);
                       tu^.buff[ub_advanced]:=255;
                       tu^.hits:=tu^.mhits;
                       PlaySND(snd_hupgr,uc);
                       _effect_add(tu^.vx,tu^.vy,tu^.vy+map_flydpth[tu^.uf]+1,EID_HUpgr);
                    end;

                   if(ud<melee_r)then
                    if(uo_tar=uc)or(tu^.uo_tar=u)then
                     if(_itcanapc(@_units[u],tu))then
                     begin
                        if(state=ps_comp)and(order<>1)then tu^.order:=order;
                        inc(apcc,tu^.apcs);
                        tu^.inapc :=u;
                        if(uo_tar=uc)then uo_tar:=0;
                        if(tu^.uo_tar=u)then tu^.uo_tar:=0;
                        PlaySND(snd_inapc,u);
                        if(tu^.sel)then
                        begin
                           dec(u_s[tu^.isbuild,tu^.ucl],1);
                           tu^.sel:=false;
                        end;
                     end;
                end;
             end
             else
               if(tu^.hits>dead_hits)and(uid in [UID_ArchVile,UID_LostSoul])then
               begin
                  ud:=dist2(x,y,tu^.x,tu^.y);

                  _unit_tardetect(u,uc,ud);
               end;
          end;

         if(speed>0)and(uf=uf_ground)and(solid)then _unit_npush(u);

         if(uialrm)then ui_addalrm(mmx,mmy,isbuild);

         if(uid=UID_Medic)and(tar1=0)and(hits<mhits)then tar1:=u;

         _unit_sattack(u);

         if(state=ps_comp)then
         begin
            uo_id :=ua_amove;
            uo_tar:=0;

            if(isbuild)then
            begin
               if(ucl=0)and(speed=0)then ai_trybuild(x,y,sr,player);
               if(ucl=1)then ai_utr(u,0);
               if(ucl=3)then
               begin
                  if(ai_skill>2)then
                  begin
                     _unit_supgrade(u,upgr_mainm);
                     _unit_supgrade(u,upgr_vision);
                     if(ubx[3]=u)then
                     begin
                        if(u_e[true,6]>0)then
                         if(random(2)=0)
                         then _unit_supgrade(u,upgr_6bld)
                         else _unit_supgrade(u,upgr_2tier);
                     end;
                     _unit_supgrade(u,upgr_hsymbol);
                     if(race=r_hell)then _unit_supgrade(u,upgr_bldrep);
                     _unit_supgrade(u,upgr_revmis);
                  end;
                  npt:=random(23);
                  if(upgr[npt]<ai_skill)then _unit_supgrade(u,npt);
               end;

               case uid of
                 UID_HTeleport : if(g_mode=gm_inv)then
                                 begin
                                    if(alrm_r<32000)then
                                    begin
                                       uo_x:=alrm_x-base_r+random(base_rr);
                                       uo_y:=alrm_y-base_r+random(base_rr);
                                    end
                                    else
                                    begin
                                       uo_x:=ai_basex-base_r+random(base_rr);
                                       uo_y:=ai_basey-base_r+random(base_rr);
                                    end;
                                 end
                                 else
                                   if(g_mode=gm_ct)and(npt>0)then
                                   begin
                                     uo_x:=g_ct_pl[npt].px-base_r+random(base_rr);
                                     uo_y:=g_ct_pl[npt].py-base_r+random(base_rr);
                                   end
                                   else
                                     if(alrm_x<>0)and(ai_skill>1)then
                                     begin
                                        uo_x:=alrm_x-base_r+random(base_rr);
                                        uo_y:=alrm_y-base_r+random(base_rr);
                                     end
                                     else
                                     begin
                                        uo_x:=random(map_mw);
                                        uo_y:=random(map_mw);
                                     end;

                UID_URadar    : if(alrm_r<32000)then
                                begin
                                   uo_x:=alrm_x;
                                   uo_y:=alrm_y;
                                   _unit_uradar(u);
                                end;
                UID_HMonastery: if(buff[ub_advanced]>0)then buff[ub_cast]:=vid_fps;
                UID_HTower,
                UID_HTotem    : if(upgr[upgr_addtur]>0)and(alrm_x>0)and(alrm_r<base_rr)then
                                begin
                                   uo_x:=x+random(sr)*sign(alrm_x-x);
                                   uo_y:=y+random(sr)*sign(alrm_y-y);
                                   _unit_b478teleport(u);
                                end;
                UID_HSymbol,
                UID_HAltar    : if(upgr[upgr_addtur]>0)and(alrm_x>0)and(alrm_r<base_r)then
                                begin
                                   uo_x:=x-random(sr)*sign(alrm_x-x);
                                   uo_y:=y-random(sr)*sign(alrm_y-y);
                                   _unit_b478teleport(u);
                                end;
               end;

               if(ai_skill>1)then
               case uid of
               UID_HKeep:if(hits<1500)and(tar1>0)and(u_e[true,0]<3)then
                         begin
                            uo_x:=random(map_mw);
                            uo_y:=random(map_mw);
                            _unit_bteleport(u);
                         end;
               UID_UCommandCenter:
                         begin
                            if(hits<2000)or(rl_e>8)or(upgr[upgr_ucomatt]>0)or(g_addon=false)then
                             if(speed=0)and(alrm_r<=sr)then _unit_action(u);

                            if(u=ubx[0])and(u_e[true,0]>2)and((upgr[upgr_ucomatt]>0)or(g_addon=false))then
                            begin
                               if(alrm_x>0)then
                                 if(alrm_r<250)then
                                 begin
                                    uo_x:=x-(alrm_x-x);
                                    uo_y:=y-(alrm_y-y);
                                 end
                                 else
                                 begin
                                    uo_x:=alrm_x-base_r+random(base_rr);
                                    uo_y:=alrm_y-base_r+random(base_rr);
                                 end;
                               if(speed=0)then _unit_action(u);
                            end
                            else
                              if(speed>0)then
                              begin
                                 if(alrm_r<=sr)then
                                 begin
                                    uo_x:=x-(alrm_x-x);
                                    uo_y:=y-(alrm_y-y);
                                 end
                                 else
                                 begin
                                    uo_x:=uo_x-base_r+random(base_rr);
                                    uo_y:=uo_y-base_r+random(base_rr);
                                    _unit_action(u);
                                 end;
                              end;
                         end;
               UID_URocketL:
                         if(rld=0)then
                          if(rl_a<4)and(rl_e>12)then _unit_URocketL(u);
               UID_Mine    : begin
                                if(g_addon=false)or(upgr[upgr_minesen]>0)then
                                 if(alrm_r<100)
                                 then buff[ub_advanced]:=0
                                 else buff[ub_advanced]:=255;
                                if(alrm_r<500)then rld_a:=vid_fps;
                                if(rld_a>0)then dec(rld_a,1);
                                if(rld_a=0)then _unit_kill(u,false,false);
                             end;
               end;
            end
            else
            begin
               if(uid=UID_UTransport)then exit;

               if(order<>1)then
               begin
                  if(order=0)then
                  begin
                     if(ai_pushpart<100)then
                     if(army>92)or(u_c[false]>=ai_maxarmy)then
                      if(_uclord>=ai_pushpart)or(apcc>0)
                      then order:=2
                      else
                      begin
                         if(g_mode=gm_coop)then order:=2;
                         if(ai_skill>2)then
                          case race of
                          r_hell : if(ucl<=2)then order:=2;
                          r_uac  : begin
                                      if(apcm>0)then order:=2;
                                      if(uid=UID_Flyer)and(buff[ub_advanced]>0)then order:=2;
                                   end;
                         end;
                      end;
                     if(ai_attack=1)then
                      case race of
                      r_hell : if(ucl<=2)and(u_c[false]>10)then order:=2;
                      r_uac  : if(apcm>0)then order:=2;
                      end;
                     if(ai_attack=2)
                     then order:=2
                     else
                       if(race=r_hell)and(map_ffly)and(uf=uf_ground)and(uid<>UID_Cyberdemon)then order:=0;

                     if(u_c[true]=0)then order:=2;

                     if(menu_s2=ms2_camp)then
                      if(g_step<cmp_ait2p)then order:=0;

                     if(g_mode=gm_inv )and(player<>0)then order:=0;
                     if(g_mode=gm_coop)and(player=0)then
                     begin
                        order:=0;
                        if((abs(ai_basex-x)+abs(ai_basey-y))>base_ir)then
                        begin
                            tar1  :=0;
                            dtar  :=32000;
                            alrm_r:=32000;
                        end;
                     end;

                     if(order=2)then
                     begin
                        ud:=0;
                        if(ubx[2]>0)then ud:=ubx[2];
                        if(ubx[5]>0)then ud:=ubx[5];
                        if(ubx[1]>0)then ud:=ubx[1];
                        if(ubx[3]>0)then ud:=ubx[3];
                        if(ubx[0]>0)then ud:=ubx[0];

                        if(ud>0)then
                        begin
                           uo_x:=_genx(_units[ud].x,map_mw,false);
                           uo_y:=_genx(_units[ud].y,map_mw,false);
                        end;
                     end;
                  end;

                  if(alrm_r<32000)then
                  begin
                     if(alrm_r<base_r)or(order=2)or(alrm_b)then
                     begin
                        uo_x:=alrm_x;
                        uo_y:=alrm_y;
                     end
                     else
                       if(g_mode=gm_ct)and(npt>0)then
                       begin
                         uo_x:=g_ct_pl[npt].px-base_r+random(base_rr);
                         uo_y:=g_ct_pl[npt].py-base_r+random(base_rr);
                       end
                       else
                       begin
                          uo_x:=ai_basex-base_r+random(base_rr);
                          uo_y:=ai_basey-base_r+random(base_rr);
                       end;
                  end
                  else
                  begin
                     if(order=2)then
                     begin
                        if(alrm_x>0)then
                        begin
                           uo_x:=alrm_x;
                           uo_y:=alrm_y;
                        end;
                        if(dist2(x,y,uo_x,uo_y)<ai_d2alrm[uf>uf_ground])then
                        begin
                           uo_x:=_genx(uo_x+uo_y,map_mw,false);
                           uo_y:=_genx(uo_y+uo_x,map_mw,false);
                           alrm_x:=0;
                           alrm_y:=0;
                        end;
                     end
                     else
                       if(g_mode=gm_ct)and(npt>0)then
                       begin
                         uo_x:=g_ct_pl[npt].px-base_r+random(base_rr);
                         uo_y:=g_ct_pl[npt].py-base_r+random(base_rr);
                       end
                       else
                       begin
                          uo_x:=ai_basex-base_r+random(base_rr);
                          uo_y:=ai_basey-base_r+random(base_rr);
                       end;
                  end;
               end;

               if(ai_skill>2)then
               case uid of
               UID_FAPC: if(alrm_r<250)then
                         begin
                            uo_x:=x-(alrm_x-x);
                            uo_y:=y-(alrm_y-y);
                         end;
               UID_APC : if(dtar<220)then
                         begin
                            uo_x:=x-(alrm_x-x);
                            uo_y:=y-(alrm_y-y);
                         end;
               UID_Flyer: if(buff[ub_advanced]>0)and(dtar<220)then
                          begin
                            uo_x:=x-(alrm_x-x);
                            uo_y:=y-(alrm_y-y);
                          end;
               UID_Engineer,
               UID_Medic:if(melee=false)and(alrm_r<=sr)then
                         begin
                            uo_x:=x-(alrm_x-x);
                            uo_y:=y-(alrm_y-y);
                            if(uid=UID_Engineer)and(alrm_i)and(u_e[true,12]<8)then _unit_action(u);
                         end;
               UID_ArchVile:
                         if(melee=false)and(alrm_i)then
                         begin
                            uo_x:=x-(alrm_x-x);
                            uo_y:=y-(alrm_y-y);
                         end;
               UID_Pain    : if(ai_skill>3)then
                             begin
                                if(alrm_r<base_r)then _unit_action(u);
                                if(alrm_r<320)then
                                begin
                                   uo_x:=x-(alrm_x-x);
                                   uo_y:=y-(alrm_y-y);
                                end;
                             end;
               end;

               if(race=r_hell)then ai_useteleport(u);
            end;

            if(uo_x>map_mw)then uo_x:=map_mw;
            if(uo_y>map_mw)then uo_y:=map_mw;
            if(uo_x<0)then uo_x:=0;
            if(uo_y<0)then uo_y:=0;
         end;
      end;
   end;
end;

procedure _unit_upgr(u:integer);
begin
   with _units[u] do
    with _players[player] do
    begin
       if(isbuild)and(bld=false)then exit;

       if(_uclord_c=_uclord)then
       begin
          if(onlySVCode)then
          begin
             if(upgr[upgr_invuln]>0)then buff[ub_invuln]:=vid_fps;

             if(buff[ub_advanced]=0)then
              case uid of
                UID_HTeleport  : if(g_addon=false)then buff[ub_advanced]:=255;
                UID_HMonastery,
                UID_UVehicleFactory : if(upgr[upgr_6bld]>0)then buff[ub_advanced]:=255;
              end;

             if(race=r_hell)then
              if(uid=UID_HSymbol)then
               if(upgr[upgr_hsymbol]>0)then
                if(generg<2)then
                begin
                   generg:=2;
                   inc(menerg,1);
                end;
          end;

          if(isbuild=false)and(race=r_hell)then
           if(upgr[upgr_hinvuln]>0)then
            if(buff[ub_invuln]<255)then buff[ub_invuln]:=vid_fps;

          if(race=r_uac)then
          begin
             if(mech)and(hits>100)then
              if(upgr[upgr_shield]>0)then buff[ub_shield]:=vid_fps;
          end;

          if(buff[ub_invis]=0)then
           case uid of
              UID_Engineer,
              UID_Medic,
              UID_Sergant,
              UID_Commando,
              UID_Bomber,
              UID_Major,
              UID_BFG        : if(upgr[upgr_invis ]>0)then buff[ub_invis]:=255;
              UID_Demon      : if(buff[ub_advanced]>0)then buff[ub_invis]:=255;
           end;

          if(buff[ub_detect]=0)then
           if(upgr[upgr_vision]>0)then
            case uid of
            UID_HAltar,
            UID_Mastermind,
            UID_Cyberdemon,
            UID_URadar,
            UID_Mine    : buff[ub_detect]:=255;
            end;

          if(buff[ub_advanced]=0)then
          begin
             if(uid=UID_HTeleport)then
              if(upgr[upgr_revtele]>0)then buff[ub_advanced]:=255;

             if(uid in [UID_HTower,UID_HTotem,UID_UTurret,UID_URTurret])and(sr=towers_sr[false])then
              if(upgr[upgr_towers]>0)then buff[ub_advanced]:=255;

             if(isbuild)and(ucl=1)then
              if(upgr[upgr_advbar]>0)then buff[ub_advanced]:=255;
          end;
       end;
       if(_uregen_c=_uclord)then
       begin
          if(onlySVCode)then
          begin
             if(race=r_hell)and(isbuild=false)and(hits<mhits)and(upgr[upgr_regen]>0)then inc(hits,upgr[upgr_regen]);
          end;
       end;


       case uid of
         UID_UCommandCenter,
         UID_HKeep :
          if(sr=base_r)then
           if(upgr[upgr_mainr]>0)then
           begin
              sr:=base_r+75;
              fr:=(sr+fog_cw) div fog_cw;
              if(fr>MFogM)then fr:=MFogM;
           end;
         UID_Revenant :
          if(sr<290)then
           if(upgr[upgr_revmis]>0)then
           begin
              sr:=290;
              fr:=(sr+fog_cw) div fog_cw;
              if(fr>MFogM)then fr:=MFogM;
           end;
         UID_Demon :
          if(buff[ub_hellpower]>0)
          then anims:=16
          else anims:=14;
         UID_URadar : begin
                         rld_a:=200+30*upgr[upgr_5bld];
                         if(sr<rld_a)then
                          begin
                             sr:=rld_a;
                             fr:=(sr+fog_cw) div fog_cw;
                             if(fr>MFogM)then fr:=MFogM;
                          end;
                         rld_a:=0;
                      end;
       end;

       if(buff[ub_advanced]>0)then
       begin
          if(uid=UID_UCommandCenter)then
           if(buff[ub_clcast]>0)then
           begin
              uo_y:=y;
              vy  :=y;
              shadow:=uaccc_fly-buff[ub_clcast]
           end
           else shadow:=uaccc_fly;

          if(uf<uf_fly)then
           if(uid in [UID_Major,UID_ZMajor])then
           begin
              speed :=12;
              uf    :=uf_fly;
              shadow:=2+(uf*fly_height);
           end;

          if(uid=UID_Mine)then
           if(sr<300)then
           begin
              sr:=300;
              fr:=(sr+fog_cw) div fog_cw;
              if(fr>MFogM)then fr:=MFogM;
           end;

          if(uid=UID_Tank)then
           if(sr<300)then
           begin
              sr:=300;
              fr:=(sr+fog_cw) div fog_cw;
              if(fr>MFogM)then fr:=MFogM;
           end;

          if(uid=UID_Medic)then
           if(sr<260)then
           begin
              sr:=260;
              fr:=(sr+fog_cw) div fog_cw;
              if(fr>MFogM)then fr:=MFogM;
           end;

          if(uid in [UID_Cyberdemon,UID_Mastermind])then
           if(sr<300)then
           begin
              sr:=300;
              fr:=(sr+fog_cw) div fog_cw;
              if(fr>MFogM)then fr:=MFogM;
           end;

          if(uid=UID_APC)then
           if(apcm<6)then apcm:=6;

          if(uid=UID_FAPC)then
           if(apcm<14)then apcm:=14;

          if(uid in [UID_Imp,UID_Cacodemon,UID_Major,UID_Commando,UID_Bomber,UID_BFG])then
           if(sr<280)then
           begin
              sr:=280;
              fr:=(sr+fog_cw) div fog_cw;
              if(fr>MFogM)then fr:=MFogM;
           end;

          if(uid in [UID_HTower,UID_HTotem,UID_UTurret,UID_URTurret])and(sr=towers_sr[false])then
          begin
             sr:=towers_sr[true];
             fr:=(sr+fog_cw) div fog_cw;
             if(fr>MFogM)then fr:=MFogM;
          end;
       end
       else
       begin
          if(uid=UID_UCommandCenter)then shadow:=buff[ub_clcast];

          if(G_Addon=false)then
           if(uid=UID_Baron)then buff[ub_advanced]:=255;

          if(uid=UID_Mine)then
           if(sr>100)then
           begin
              sr:=100;
              fr:=(sr+fog_cw) div fog_cw;
              if(fr>MFogM)then fr:=MFogM;
           end;
       end;
    end;
end;

function _u1_spawn(u,sx:integer):boolean;
begin
  _u1_spawn:=false;
   with _units[u] do
    with _players[player] do
    begin
       _unit_add(x+sx,y+r+_ulst[cl2uid[race,false,utrain]].r,cl2uid[race,false,utrain],player,true);
       if(_lcu>0)then
       begin
          _u1_spawn:=true;
          _lcup^.uo_x  :=uo_x;
          _lcup^.uo_y  :=uo_y;
          _lcup^.uo_id :=uo_id;
          _lcup^.uo_tar:=uo_tar;
          _lcup^.buff[ub_pain]:=vid_hfps;

          if(uid=uid_HGate)then
          begin
             PlaySND(snd_teleport,u);
             _effect_add(_lcup^.x,_lcup^.y,_lcup^.y+map_flydpth[_lcup^.uf]+1,EID_Teleport);
          end;
       end;
    end;
end;

procedure _unit_code2(u:integer);
var i:byte;
begin
   with _units[u] do
   with _players[player] do
   begin
      if(hits<=0)then exit;

      if(rld>0)then dec(rld,1);

      for i:=0 to _ubuffs do
       if(buff[i]<255)then
        if(buff[i]>0)then
        begin
           dec(buff[i],1);
           if(i=ub_stopafa)and(OnlySVCode)then
            if(bld)and(speed>0)and(tar1=0)then
             if(buff[i]=0)then dir:=p_dir(x,y,uo_x,uo_y);
        end;

      if(onlySVCode)then
      begin
         case g_loss of
          1: if(bldrs =0)then begin _unit_kill(u,false,false);exit;end;
          2: if(menerg=0)then begin _unit_kill(u,false,false);exit;end;
         end;

         if(isbuild)then
         begin
            if(menerg=0)
            then _unit_kill(u,false,false)
            else
              if(bld=false)then
              begin
                 if(menerg<cenerg)or(bldrs=0)
                 then _unit_kill(u,false,false)
                 else
                   if(buff[ub_pain]=0)then
                   begin
                      if(_warpten)
                      then hits:=mhits
                      else
                        if(_uclord_c<>_uclord)then exit;
                      inc(hits,bld_s);
                      if(upgr[upgr_advbld]>0)then inc(hits,bld_s);
                      if(hits>=mhits)then
                      begin
                         hits:=mhits;
                         bld :=true;

                         inc(menerg,generg);
                         dec(cenerg,_pne_b[race,ucl]);
                         if(ucl=0)then inc(bldrs,1);
                      end;
                   end;
              end
              else
              begin
                 if(rld>0)then
                 begin
                    if(ucl=1)then
                     if((army+wb)>MaxPlayerUnits)or(menerg<cenerg)or(u_e[false,utrain]>=_ulst[cl2uid[race,false,utrain]].max)
                     then _unit_ctraining(u)
                     else
                       if(rld=1)or(_warpten)then
                       begin
                          if(_ulst[cl2uid[race,false,utrain]].max=1)then wbhero:=false;
                          dec(wb,1);
                          rld:=0;
                          dec(cenerg,_pne_u[race,utrain]);

                          if(_u1_spawn(u,0))and(player=HPlayer)then _unit_createsound(cl2uid[race,false,utrain]);
                          if(buff[ub_advanced]>0)then _u1_spawn(u,30);
                       end;

                    if(ucl=3)then
                     if(menerg<cenerg)then
                     begin
                        rld:=0;
                        dec(cenerg,1);
                        _bc_us(@cpupgr,utrain);
                     end
                     else
                       if(rld=1)or(_warpten)then
                       begin
                          rld:=0;
                          inc(upgr[utrain],_pne_r[race,utrain]);
                          _bc_us(@cpupgr,utrain);
                          dec(cenerg,1);
                       end;
                 end;

                 if(uid=UID_Portal)and(buff[ub_advanced]>0)and(rld=0)then
                 begin
                    repeat
                       inc(utrain,1);
                       utrain:=utrain mod 32;
                       if(g_addon=false)and(utrain>6)then continue;
                    until (_cmp_untCndt(rld_a,utrain)=false)or(utrain=31);

                    if(utrain<31)then
                    begin
                       _lcu:=0;

                       case g_mode of
                         gm_coop: if(random(2)=0)
                                  then rld:=cl2uid[r_hell,false,utrain]
                                  else rld:=cl2uid[r_uac ,false,utrain];
                       else
                          rld:=cl2uid[race,false,utrain];
                       end;

                       if(rld<>UID_FAPC)then
                        if(u_e[false,utrain]<_ulst[rld].max)then _unit_add(x-60+random(120),y-60+random(120),rld,rld_a,true);

                       if(_lcu>0)then
                       begin
                          PlaySND(snd_teleport,u);
                          _effect_add(_lcup^.x,_lcup^.y,_lcup^.y+map_flydpth[_lcup^.uf]+1,EID_Teleport);
                          if(g_mode=gm_coop)and(player=0)then _lcup^.buff[ub_advanced]:=255;
                       end;
                    end;
                    rld:=rld_r;
                 end;
                 if(uid=UID_USPort)and(rld=0)then
                 begin
                    _lcu:=0;
                    _unit_add(x,y,UID_UTransport,player,true);
                    if(_lcu>0)then
                    begin
                       ui_addalrm(mmx,mmy,isbuild);

                       uo_x:=random(map_mw);
                       uo_y:=random(map_mw);

                       case random(2) of
                         0 : if(uo_x>3000)
                             then uo_x:=map_mw
                             else uo_x:=0;
                         1 : if(uo_y>3000)
                             then uo_y:=map_mw
                             else uo_y:=0;
                       end;

                       _lcup^.uo_x:= uo_x;
                       _lcup^.uo_y:= uo_y;
                    end;

                    rld:=rld_r;
                 end;

                 if(ubx[ucl]=0)then ubx[ucl]:=u;
              end;
         end;
      end;

      _unit_upgr(u);

      if(_canattack(u))then _unit_attack(u);

      if(uid=UID_URocketL)then
       if((rld mod 16)=7)then
       begin
          _miss_add(uo_x-blizz_w+_genx(uo_x+rld*11,blizz_ww,false),uo_y-blizz_w+_genx(uo_y+rld*15,blizz_ww,false),vx,vy,0,MID_Blizzard,player,uf_soaring,0);
          _effect_add(vx,vy-15,vy+10,EID_Exp2);
          if(player=HPlayer)then PlaySND(snd_exp,0);
       end;

      if(uid=UID_UTransport)then
      begin
         if(x<2)or(y<2)or(x=map_mw)or(y=map_mw)then G_WTeam:=2;
         _fog_r(fx,fy,fr);
      end;
   end;
end;

procedure _netSetUcl(u:integer);
var pu:PTUnit;
    i:byte;
begin
   pu:=@_units[0];
   with _units[u] do
    with _players[player] do
     if(pu^.hits<=dead_hits)and(hits>dead_hits)then // d to a
     begin
        _unit_def(u);
        for i:=8 to _ubuffs do buff[i]:=0;
        if(sel)then inc(u_s[isbuild,ucl],1);
        inc(u_e[isbuild,ucl],1);
        inc(army,1);

        if(inapc>0)then
        begin
           x:=_units[inapc].x;
           y:=_units[inapc].y;
           _unit_sfog(u);
           _unit_mmcoords(u);
        end;

        vx:=x;
        vy:=y;

        if(hits>0)then
        begin
           if(isbuild)then
           begin
              if(player=HPlayer)then
              begin
                 if(bld=false)then PlaySND(snd_build[race],0);
              end;
           end
           else
           begin
              if(player=HPlayer)then _unit_createsound(uid);
              if(race=r_hell)and(buff[ub_pain]>0)then
              begin
                 _effect_add(vx,vy,vy+map_flydpth[uf]+1,EID_Teleport);
                 PlaySND(snd_teleport,u);
              end;
              bld:=true;
           end;
        end;
     end
     else
       if(pu^.hits>dead_hits)and(hits<=dead_hits)then // a to d
       begin
          vx:=x;
          vy:=y;
          if(pu^.sel)then dec(u_s[pu^.isbuild,pu^.ucl],1);
          dec(u_e[pu^.isbuild,pu^.ucl],1);
          dec(army,1);

          _unit_upgr(u);

          if(hits>ndead_hits)and(inapc=0)then
           if(pu^.hits>0)then _unit_deff(u,false);
       end
       else
         if(pu^.hits>dead_hits)and(hits>dead_hits)then
         begin
            if(pu^.uid<>uid)then
            begin
               _unit_def(u);
               for i:=8 to _ubuffs do buff[i]:=0;
               dec(u_e[pu^.isbuild,pu^.ucl],1);
               inc(u_e[isbuild,ucl],1);

               if(pu^.sel)then dec(u_s[pu^.isbuild,pu^.ucl],1);
               if(sel)then inc(u_s[isbuild,ucl],1);

               vx:=x;
               vy:=y;
            end
            else
            begin
               if(pu^.sel=false)and(sel)then inc(u_s[isbuild,ucl],1);
               if(pu^.sel)and(sel=false)then dec(u_s[isbuild,ucl],1);
            end;

            if(pu^.inapc=0)and(inapc>0)then
             if(sel)then
             begin
                sel:=false;
                dec(u_s[isbuild,ucl],1);
             end;

            _unit_upgr(u);

            if(pu^.hits<=0)and(hits>0)then
            begin
               fr:=(sr+fog_cw) div fog_cw;
               if(player=HPlayer)then _unit_createsound(uid);
               vx:=x;
               vy:=y;
            end
            else
             if(pu^.hits>0)and(hits<=0)then
             begin
                if(sel)then
                begin
                   dec(u_s[isbuild,ucl],1);
                   sel:=false;
                end;
                _unit_deff(u,hits<=idead_hits);
             end;

            if(pu^.inapc<>inapc)and(_nhp(x,y,r))then PlaySND(snd_inapc,0);

            if(pu^.inapc=0)and(inapc>0)then
            begin
               x:=_units[inapc].x;
               y:=_units[inapc].y;
               _unit_sfog(u);
               _unit_mmcoords(u);
            end;

            if(uid=UID_URadar)then
             if(bld)and(pu^.rld=0)and(rld>0)and(team=_players[HPlayer].team)then PlaySND(snd_radar,0);

            if(uid=UID_ArchVile)then
             if(pu^.buff[ub_cast]=0)and(buff[ub_cast]>0)then PlaySND(snd_meat,u);

            if(pu^.buff[ub_gear]=0)and(buff[ub_gear]>0)then PlaySND(snd_uupgr,u);

            if(race=r_hell)and(isbuild=false)and(hits>0)then
            begin
               if(pu^.buff[ub_advanced]=0)and(buff[ub_advanced]>0)then
               begin
                  PlaySND(snd_hupgr,u);
                  _effect_add(vx,vy,vy+map_flydpth[uf]+1,EID_HUpgr);
               end;
               if(pu^.buff[ub_pain]=0)and(buff[ub_pain]>0)then _unit_painsnd(u);
            end;

            if(uid=UID_UCommandCenter)then
            begin
               if(pu^.buff[ub_advanced]=0)and(buff[ub_advanced]>0)then
               begin
                  speed:= 6;
                  uf   := uf_fly;
                  buff[ub_clcast]  := uaccc_fly;
                  PlaySND(snd_ccup,u);
               end;
               if(pu^.buff[ub_advanced]>0)and(buff[ub_advanced]=0)then
               begin
                  speed:= 0;
                  uf   := uf_ground;
                  buff[ub_clcast]  := uaccc_fly;
                  vy:=y;
                  PlaySND(snd_inapc,u);
               end;
               if(buff[ub_advanced]>0)then
               begin
                  speed:=6;
                  uf   := uf_fly;
               end;
            end;

            if(tar1>0)then dtar:=dist2(x,y,_units[tar1].x,_units[tar1].y);

            if(speed>0)then
            begin
               uo_x:=pu^.x;
               uo_y:=pu^.y;
            end;

            if(pu^.x<>x)or(pu^.y<>y)then
            begin
               _unit_sfog(u);
               _unit_mmcoords(u);

               if(uid in [UID_HSymbol,UID_HTower,UID_HTotem,UID_HAltar])then
                if(dist2(x,y,pu^.x,pu^.y)<sr)then
                begin
                   vx:=x;
                   vy:=y;
                   if(hits>0)then
                   begin
                      if(_nhp(vx,vy,r)or _nhp(pu^.vx,pu^.vy,r))then PlaySND(snd_teleport,0);
                      _effect_add(vx,vy,vy+map_flydpth[uf]+1,EID_Teleport);
                      _effect_add(pu^.vx,pu^.vy,pu^.vy+map_flydpth[uf]+1,EID_Teleport);
                   end;
                end;

               if(speed>0)then
               begin
                  vstp:=UnitStepNum;

                  dir:=p_dir(uo_x,uo_y,x,y);

                  if(buff[ub_pain]>0)then
                   if(dist2(x,y,pu^.x,pu^.y)>200)then
                   begin
                      vx:=x;
                      vy:=y;
                      if(hits>0)then
                      begin
                         if(_nhp(vx,vy,r)or _nhp(pu^.vx,pu^.vy,r))then PlaySND(snd_teleport,0);
                         _effect_add(vx,vy,vy+map_flydpth[uf]+1,EID_Teleport);
                         _effect_add(pu^.vx,pu^.vy,pu^.vy+map_flydpth[uf]+1,EID_Teleport);
                      end;
                   end;
               end
               else
               begin
                  if(uid=UID_HKeep)then
                  begin
                     if(_nhp(x,y,r)or _nhp(pu^.x,pu^.y,r))then PlaySND(snd_cubes,0);
                     _effect_add(pu^.x,pu^.y,0,EID_HKT_h);
                     _effect_add(x,y,0,EID_HKT_s);
                     buff[ub_clcast]:=vid_fps;
                  end;
               end;
            end;
         end;
end;

procedure _unitsCycle;
var u:integer;
begin
   for u:=1 to MaxUnits do
    with _units[u] do
     if(hits>dead_hits)then
      if(hits>0)then
      begin
         _unit_ttar   (u);
         _unit_move   (u);
         _unit_movevis(u);
         if(onlySVCode)and(inapc=0)
         then _unit_code1  (u)
         else _unit_code1_n(u);
         _unit_code2(u);
         _unit_vis(u);
      end
      else _unit_death(u);
end;

////////////////////////////////////////////////////////////////////////////////

procedure _make_coop;
begin
   if(onlySVCode)then
   begin
      _unit_add(map_psx[0]+75,map_psy[0]+75,UID_Portal,0,true);
      _units[1].buff[ub_advanced]:=255;
      _units[1].rld_a:=0;
      _unit_add(map_psx[0]-80 ,map_psy[0]-80,UID_HFortress,0,true);
      _unit_add(map_psx[0]+125,map_psy[0]-90,UID_HMilitaryUnit,0,true);
      _unit_add(map_psx[0]-125,map_psy[0]+90,UID_HMilitaryUnit,0,true);
   end;

   with _players[0] do
   begin
      ai_skill:=6;
      _setAI(0);
      ai_attack:=0;
      ai_pushpart:=100;
      _bc_ss(@a_units,[0..21]);
      _bc_ss(@a_build,[3,4,6,7]);
      _upgr_ss(@upgr ,[0..30],race,10);
   end;
   plcolor[0]:=c_purple;
end;




