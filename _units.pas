
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
  if(vid_mmredraw)and(_menu=false)then
   with _units[u]do
    with _players[player]do
     if(isbuild)
     then filledCircleColor(vid_minimap,mmx,mmy,mmr,p_colors[player])
     else pixelColor(vid_minimap,mmx,mmy,p_colors[player]);
end;

procedure _unit_mmcoords(u:integer);
begin
   with _units[u] do
   begin
      mmx:=trunc(x*map_mmcx);
      mmy:=trunc(y*map_mmcx);
   end;
end;

procedure _unit_canclet(u:integer);
begin
   with _units[u] do
    if(rld>0)and(bld)and(utp=ut_1)and(isbuild)then
     with _players[player] do
     begin
        if(race=r_hell)and(utrain>4)then hcmp:=false;

        dec(wb,1);
        dec(cenerg,1);
        rld:=0;
     end;
end;

procedure _u_chk_ord(ux,uy,ur:integer;mt:byte);
var i:integer;
begin
   for i:=1 to MaxUnits do
    with _units[i] do
     with _players[player] do
      if(hits>0)and(team<>mt)then
       if(ma=1)and(dist2(mx,my,ux,uy)<=ur)then
       begin
          ma:=0;
          mx:=x;
          my:=y;
       end;
end;



procedure _unit_remove(u:integer);
var i:integer;
begin
   with _units[u] do
    with _players[player] do
    begin
       _u_chk_ord(x,y,r,team);
       if(hits>0)then
       begin
          if(apcc>0)then
           for i:=1 to MaxUnits do
            if(_units[i].hits>0)and(_units[i].inapc=u)then _unit_remove(i);

          dec(army,1);
          dec(eu[isbuild,utp],1);
          if(sel)then dec(su[isbuild,utp],1);

          if(player<>0)or(g_mode<>gm_inv)then
           if(army=0)and(_mmode<>mm_camp)and(state>ps_none)then _lg_c_add(chr(player)+name+str_player_def);

          if(isbuild)then
           if(bld=false)
           then dec(cenerg,1)
           else
           begin
              if(rld>0)then
              begin
                 if(utp=ut_1)then _unit_canclet(u);
                 if(utp=ut_3)then dec(cenerg,1);
              end;
              dec(menerg,generg);
              if(utp=ut_0)and(u0=u)then u0:=0;
              if(utp=ut_1)and(u1=u)then u1:=0;
              if(utp=ut_3)and(u3=u)then u3:=0;
              if(utp=ut_5)and(u5=u)then u5:=0;
           end;
       end;
       hits:=0;
       sel:=false;
    end;
end;

procedure _unit_deadeff(u:integer;gvn:boolean);
begin
   with _units[u] do
   if(hits>-1000)then
   begin
     //if(vis=uv_inscr)then
      if(isbuild)then
      begin
         if(ucl=UID_Mine)then
         begin
            if(gvn)
            then _effect_add(vx,vy,vy+1,eid_BExplode)
            else _effect_add(vx,vy,vy+1,eid_Explode);
            if(_nhp(x,y))then PlaySND(snd_explode,0);
         end else
         begin
            if(r<41) then
            begin
               if(_players[player].race=r_hell)
               then _effect_add(x,y+5,-10,eid_db_h1)
               else _effect_add(x,y+5,-10,eid_db_u1);
               if(_players[player].race=r_uac)or(bld)then
               begin
                  _effect_add(x,y,y,eid_BExplode);
                  PlaySND(snd_explode2,u);
               end;
            end
            else
            begin
               if(_players[player].race=r_hell)
               then _effect_add(x,y+10,-10,eid_db_h0)
               else _effect_add(x,y+10,-10,eid_db_u0);
               if(_players[player].race=r_uac)or(bld)then
               begin
                  _effect_add(x,y,y,eid_BBExplode);
                  PlaySND(snd_explode2,u);
               end;
            end;
         end;
      end else
      begin
         if(ucl in gvndth)and(gvn) then
         begin
            _effect_add(vx,vy,vy+map_mw*uf,eid_gavno);
            PlaySND(snd_gv,u);
         end else
         begin
            case ucl of
uid_zformer   : PlaySND(snd_zd,u);
uid_zsergant  : PlaySND(snd_zd,u);
uid_lostsoul  : PlaySND(snd_plasmaexp,u);
uid_imp       : PlaySND(snd_impd,u);
uid_demon     : PlaySND(snd_demond,u);
uid_cacodemon : PlaySND(snd_cacod,u);
uid_baron     : PlaySND(snd_barond,u);
uid_cyberdemon: PlaySND(snd_cyberd,u);
uid_mastermind: PlaySND(snd_mindd,u);
uid_medic,
UID_Engineer,
UID_Sergant   : PlaySND(snd_ud1,u);
UID_Commando,
UID_Bomber,
UID_BFG       : PlaySND(snd_ud2,u);
UID_FAPC,
UID_ZFPlasma,
UID_Major     : PlaySND(snd_explode,u);
            end;

            case ucl of
  UID_FAPC  : _effect_add(vx,vy,vy+1,eid_BExplode);
  UID_ZFPlasma,
  UID_Major : _effect_add(vx,vy,vy+map_mw*uf+1,eid_Explode);
            else
            _effect_add(vx,vy,vy+map_mw*uf,ucl);
            end;
         end;
      end;

   end;
end;


procedure _unit_kill(u:integer;gvn:boolean);
begin
   with _units[u] do
   if(hits>0)then
   begin
      _unit_deadeff(u,gvn);
      _unit_remove(u);
      if(gvn)then hits:=-100;
   end;
end;

procedure _unit_damage(u,dam:integer;p:byte);
var arm:integer;
begin
  if(onlySVCode)then
   with _units[u] do
   begin
      if((player=PlayerHuman)and(_invuln))or(invuln)then exit;

      arm:=0;

      with _players[player] do
      begin
       if(isbuild)and(bld) then
        if(upgr[upgr_build]>0)
        then arm:=15
        else arm:=8
       else
        if(upgr[upgr_armor]=0)then
          case ucl of
          UID_FAPC    : arm:=2;
          UID_Demon   : arm:=1;
          else
            arm:=0;
          end
        else
          case ucl of
          UID_Baron,
          UID_Demon   : arm:=4;
          else
            inc(arm,3);
          end;

        if(race=r_hell)and(upgr[upgr_hpower]>0)then inc(arm,2);

        if(isbuild)and(race=r_uac)then inc(arm,4);

        if(g_mode=gm_inv)then
         if(player=0)then
         begin
            inc(arm,2);
            dam:=dam div 3;
         end;
      end;

      if(shield>0)then inc(arm,shield_aa[isbuild]);

      dec(dam,arm);
      if(dam<mindmg)then dam:=mindmg;

      if(hits<=dam)then
      begin
         _unit_kill(u,(hits-dam)<gavno_dth_h);
      end
      else
      begin
         dec(hits,dam);
         if(isbuild)then paint:=build_rld
         else
          if(painc>0)and(paint=0)then
          begin
             if(p>pains)
             then pains:=0
             else dec(pains,p);

             if(pains=0)then
             begin
                pains:=painc;
                paint:=pain_state_time;

                if(ucl in [uid_imp,uid_zformer,uid_zsergant,UID_ZCommando,UID_ZBomber,UID_ZFPlasma,UID_ZBFG])
                then PlaySND(snd_zp,u)
                else PlaySND(snd_dpain,u);
             end;
          end;
      end;
   end;
end;


procedure _sf(tx,ty:integer);
begin
  if(0<=tx)and(0<=ty)and(tx<=fog_cs)and(ty<=fog_cs)then
  fog_c[tx,ty]:=fog_add;
end;

procedure _fog_r(x,y,r:byte);
var ix,iy:integer;
begin
   ix:=abs(fog_ix-x);
   if(ix<=r)then
    for iy:=0 to _fcx[r,ix] do
    begin
       _sf(fog_ix,y-iy);
       _sf(fog_ix,y+iy);
    end;

   iy:=abs(fog_iy-y);
   if(iy<=r)then
    for ix:=0 to _fcx[r,iy] do
    begin
       _sf(x-ix,fog_iy);
       _sf(x+ix,fog_iy);
    end;
end;

procedure _unit_sfog(u:integer);
begin
   with _units[u] do
   begin
      fx:=x div fog_cw;
      fy:=y div fog_cw;
      if(_players[player].team=_players[PlayerHuman].team)then _sf(fx,fy);
   end;
end;

{$Include _missiles.pas}
{$Include _unit_spr.pas}
{$Include _units_cl.pas}

procedure _unit_commandsound(r,ut:byte);
begin
   case r of
r_uac          : case ut of
              0..7    : case random(3)of
                        0 : PlaySND(snd_uac_u0,0);
                        1 : PlaySND(snd_uac_u1,0);
                        2 : PlaySND(snd_uac_u2,0);
                        end;
                 else
                 end;
r_hell         : case ut of
          0,2,3,4,5,6   : PlaySND(snd_demon1,0);
          1             : PlaySND(snd_imp,0);
          7             : PlaySND(snd_zomb,0);
                 else
                 end;
   end;
end;


procedure _unit_createsound(ucl:byte);
begin
   case ucl of
UID_FAPC,
UID_Medic,
UID_Engineer,
UID_Sergant,
UID_Commando,
UID_Bomber,
UID_Major,
UID_BFG       : case random(3)of
                  0: PlaySND(snd_uac_u0,0);
                  1: PlaySND(snd_uac_u1,0);
                  2: PlaySND(snd_uac_u2,0);
                end;
UID_LostSoul  : PlaySND(snd_demon1,0);
UID_Imp       : PlaySND(snd_impc,0);
UID_Demon     : PlaySND(snd_demonc,0);
UID_Cacodemon : PlaySND(snd_cacoc,0);
UID_Baron     : PlaySND(snd_baronc,0);
UID_Cyberdemon: PlaySND(snd_cyberc,0);
UID_Mastermind: PlaySND(snd_mindc,0);
UID_ZFormer,
UID_ZSergant  : PlaySND(snd_zc,0);
   end;
end;

procedure _defUnit(u:integer);
begin
   with _units[u] do
   begin
      if(onlySVCode)then spr:=@spr_dum;

      order   := 0;
      dir     := 270;
      rld     := 0;
      utrain  := 0;
      paint   := 0;
      pains   := 0;
      tar     := 0;
      dtar    := 32000;
      anim    := 0;
      ma      := 0;
      vist    := 0;
      alx     := 0;
      aly     := 0;
      alt     := 0;
      ald     := 0;
      shield  := 0;
      inapc   := 0;

      _unit_sfog(u);
      _unit_mmcoords(u);
   end;
end;

procedure _unit_add(ux,uy:integer;uc,pl:byte);
var m:integer;
begin
   _lau:=0;
   with _players[pl] do
   if(army<MaxPlayerUnits)then
   begin
      _lau:=MaxPlayerUnits*pl+1;
      m:=_lau+MaxPlayerUnits;
      while (_lau<m) do
      begin
         with _units[_lau] do
          if(hits<=0)then
          begin
             _uclord := _lau mod _units_period;

             x       := ux;
             y       := uy;
             ucl     := uc;
             player  := pl;
             vx      := x;
             vy      := y;
             mx      := x;
             my      := y;
             sel     := false;
             bld     := true;
             apcc    := 0;

             _defUnit(_lau);
             _unit_sclass(_lau);

             inc(army,1);
             inc(eu[isbuild,utp],1);
             inc(menerg,generg);

             break;
          end;

         inc(_lau,1);
      end;
   end;
end;

function _unit_grbcol(tx,ty,tr:integer):boolean;
var u:integer;
begin
   _unit_grbcol:=false;
   for u:=1 to MaxUnits do
    with _units[u] do
     if(hits>0)and(isbuild)and(uf=uf_ground)and(inapc=0)then
      if(dist2(x,y,tx,ty)<=(tr+r))then
      begin
         _unit_grbcol:=true;
         break;
      end;

   if(_unit_grbcol=false)then
    for u:=1 to MaxDoodads do
     with map_dds[u] do
      if(r>0)and(t>0)then
       if(dist3(x,y,tx,ty,t=DID_Liquid)<=(tr+r))then
       begin
          _unit_grbcol:=true;
          break;
       end;
end;

procedure _unit_startb(bx,by:integer;bt,bp:byte);
begin
   with _players[bp] do
   begin
    if(bld_r=0)then
     if(bt in alw_b)then
      if(build_b<bx)and(bx<map_b1)and(build_b<by)and(by<map_b1)then
       if(eu[true,bt]<b_m[bt])and(menerg>cenerg)and(army<MaxPlayerUnits)and(eu[true,ut_0]>0)and(u0>0)then
        if(dist2(_units[u0].x,_units[u0].y,bx,by)<=base_r)and(_unit_grbcol(bx,by,b_r[bt])=false)then
        begin
           bld_r:=build_rld;
           _unit_add(bx,by,rut2b[race,bt],bp);
           inc(cenerg,1);
           with _units[_lau] do
           begin
              dec(menerg,generg);
              hits:= 50;
              bld := false;
           end;
           if(bp=PlayerHuman)then PlaySND(snd_build,0);
        end;
   end;
end;

procedure _unit_supgrade(u,up:integer);
begin
   with _units[u] do
    if(rld=0)and(bld)and(utp=ut_3)and(isbuild)then
     with _players[player] do
     if(upgr[up]=0)and(up in alw_up)then
      if(menerg>cenerg)then
      begin
         inc(cenerg,1);
         rld:=upgrade_time[race,up];
         utrain:=up;
      end;
end;
procedure _unit_cupgrade(u:integer);
begin
   with _units[u] do
    if(rld>0)and(bld)and(utp=ut_3)and(isbuild)then
     with _players[player] do
     begin
        dec(cenerg,1);
        rld:=0;
      end;
end;

procedure _unit_straining(u,ut:integer);
begin
   with _units[u] do
    if(rld=0)and(bld)and(utp=ut_1)and(isbuild)then
     with _players[player] do
     if(ut in alw_u)and(eu[false,ut]<u_m[race,ut])and((army+wb)<MaxPlayerUnits)and(menerg>cenerg)and(trt[race,ut]>0)then
     begin
        if(race=r_hell)and(ut>4)then
         if(hcmp=true)
         then exit
         else hcmp:=true;

        inc(wb,1);
        inc(cenerg,1);
        rld:=trt[race,ut];
        utrain:=ut;
     end;
end;

procedure _unit_trysetmine(u:integer);
begin
   with _units[u] do
    with _players[player] do
     if(ucl=UID_Engineer)and(army<MaxPlayerUnits)and(upgr[upgr_mine]>0)and(menerg>0)and(inapc=0)then
     begin
        _unit_add(x,y,UID_Mine,player);
        dec(x,8);
     end;
end;

procedure _unit_foots(u:integer);
begin
   with _units[u] do
   //if wanim then
   if (paint=0) then
   begin
      if(ucl=UID_Mastermind)then
      begin
         inc(foots,1);
         foots:=foots mod 27;
         if(foots=0)then PlaySND(snd_mindf,0);
      end;

      if(ucl=UID_Cyberdemon)then
      begin
         inc(foots,1);
         foots:=foots mod 26;
         if(foots=0)then PlaySND(snd_cyberf,0);
      end;
   end;
end;


procedure _unit_vis(u:integer);
var td,sh,ydpth:integer;
    oc:single;
    ch:char;
    inv:byte;
    slr:boolean;
    ac:cardinal;
begin
   with _units[u] do
   begin
      vis:=uv_novis;

      if(inapc>0)then exit;

      if(player=PlayerHuman)then
       if(isbuild)and(bld)then
        if(utp=ut_1)and(rld>1)then
        begin
           inc(ui_urc[utrain],1);
           if(ui_ur[utrain]>rld)or(ui_ur[utrain]=0)then ui_ur[utrain]:=rld;
        end;

      if(_mmode<>mm_camp)then
       with _players[player] do
        if(eu[true,0]<1)then _unit_minimap(u);

     if((_rpls_rst<rpl_rhead)and(playerhuman>0))and(_fog)then
      if(invis>0)and(vist=0)then
       if(_players[player].team<>_players[PlayerHuman].team)then exit;

      if(sel)and(isbuild)and(player=PlayerHuman)then
       if(utp=ut_1)or(teleport)or(ucl=UID_HellBarracks)then
        with _players[player] do
         _sprb_add(spr_mp[race], mx-10, my-32,my,0,0,0,#0,255,false,0,0,0);  // barraks

      if _fog_ch(fx,fy,r) then
      begin
         vis:=uv_nofog;
         _unit_minimap(u);

         if(onlySVCode)then wanim:=((mx<>vx)or(my<>vy))and(canw)and(rld=0);

         _unit_sprite (u);

         sh:=0;
         if(shadow)then sh:=spr^.surf^.h-4+(uf*fly_height);

         if ((vid_vx+vid_panel-spr^.hw)<vx)and(vx<(vid_vx+vid_mw+spr^.hw))and
            ((vid_vy-spr^.hh-sh)<vy)and(vy<(vid_vy+vid_mh+spr^.hh)) then
         begin
            ac:=0;
            oc:=0;
            ch:=#0;
            slr:=false;
            if(sel)or(k_alt>1)then
            begin
               slr:=true;
               if(order>0)and(player=PlayerHuman)then ch:=chr(48+order);
            end;

            if(hits<mhits)or(slr)then oc:=hits/mhits;

           // if()

            case ucl of
          UID_HellTeleport: ydpth:=-4;
          UID_HellAltar   : ydpth:=-3;
          uid_UACSport,
          UID_UACPortal   : ydpth:=-2;
          UID_Mine        : ydpth:=0;
            else
          ydpth:=vy+uf*map_mw;
            end;

            if wanim then _unit_foots(u);

            if(bio)and(paint>pain_state_time)then _sprb_add(spr_toxin, vx-12, vy-30-spr^.hh,ydpth,0,0,0,#0,255,false,0,0,0);

            if(invis>0)then inv:=128 else inv:=255;
            if(rld>0)then
             if(ucl in marines)then inv:=255;

            if(isbuild)then
            begin
              if(bld)then
              begin
                 if(ucl=UID_UACTurret)then
                 begin
                    td:=((dir+23) mod 360) div 45;
                    if(rld>urlda[r_uac,3])then td:=td+8;
                    _sprb_add(spr_ut[td].surf, vx-15, vy-spr^.hh+3,ydpth,0,0,0,#0,255,false,0,0,0);
                 end;
                 if(player=PlayerHuman)then
                 begin
                    if(rld>0)then
                    begin
                       if(ucl=UID_HellGate   )then
                       begin
                          _sprb_add(spr_b_u[r_hell,utrain],vx-24,vy-24,ydpth,0,0,0,#0,200,false,0,0,0);
                          _sprb_add(spr_hg_eff, vx-34, vy-25,ydpth,0,0,0,#0,255,false,0,0,0);
                       end;
                       if(ucl=UID_UACBarracks)then
                       begin
                          _sprb_add(spr_b_u[r_uac,utrain],vx-24,vy-24,ydpth,0,0,0,#0,200,false,0,0,0);
                          _sprb_add(spr_teleport[0].surf, vx+52, vy-68,ydpth,0,0,0,#0,255,false,0,0,0);
                       end;
                       if(ucl=UID_HellPool    )then  _sprb_add(spr_h_p2[0].surf, vx-35, vy-45,ydpth,0,0,0,#0,255,false,0,0,0);
                       if(ucl=UID_UACResCenter)then  _sprb_add(spr_teleport[0].surf, vx+23, vy-60,ydpth,0,0,0,#0,255,false,0,0,0);
                    end;
                    if(_players[player].u0=u)then
                    begin
                       if(ucl=UID_HellKeep    )then _sprb_add(spr_h_p2[0].surf, vx-4, vy-47,ydpth,0,0,0,#0,255,false,0,0,0);
                       if(ucl=UID_UACComCenter)then _sprb_add(spr_teleport[0].surf, vx-53, vy-65,ydpth,0,0,0,#0,255,false,0,0,0);
                    end;
                 end;
              end else
               with _players[player] do
                if(race=r_hell)then
                begin
                  inv:=trunc(255*hits/mhits);
                   if(r<41)
                   then _sprb_add(spr_db_h1.surf,vx-spr_db_h1.hw,vy-spr_db_h1.hh+5 ,-5,0,p_colors[player],0,#0,255-inv,false,0,0,0)
                   else _sprb_add(spr_db_h0.surf,vx-spr_db_h0.hw,vy-spr_db_h0.hh+10,-5,0,p_colors[player],0,#0,255-inv,false,0,0,0);
                end;
            end
            else
             with _players[player] do
             begin
                if(race=r_hell)and(upgr[upgr_hpower]>0)then ac:=c_ared;
             end;

            if(shield>0)then ac:=c_ablue;

            if(player=PlayerHuman)
            then _sprb_add(spr^.surf,vx-spr^.hw,vy-spr^.hh,ydpth,sh,p_colors[player],oc,ch,inv,slr,ac,apcc,apcm)
            else _sprb_add(spr^.surf,vx-spr^.hw,vy-spr^.hh,ydpth,sh,p_colors[player],oc,ch,inv,slr,ac,0,0);

            vis:=uv_inscr;
          // end;
         end;
      end;
   end;
end;


procedure _unit_radar(u:integer);
begin
   with _units[u] do
    if(bld)then
    begin
       if(rld=0)then
       begin
          rld:=radar_rld;
          if(onlySVCode)and(Player=PlayerHuman)then PlaySND(snd_radar,0);
       end;
       mx:= mx div fog_cw;
       my:= my div fog_cw;
    end;
end;

procedure _unit_movevis(u:integer);
begin
   with _units[u] do
    if (vx<>x)or(vy<>y) then
     if(isbuild)or(inapc>0)then
     begin
        vst:=0;
        vx :=x;
        vy :=y;
        _unit_mmcoords(u);
     end
     else
     begin
        if (vst=0) then
        begin
           if(onlySVCode)
           then vst:=UnitStepNum
           else vst:=UnitStepNumNet;
           _unit_mmcoords(u);
        end;
        Inc(vx,(x-vx) div vst);
        Inc(vy,(y-vy) div vst);
        dec(vst,1);
     end;
end;


procedure _unit_push(u,i,ud:integer);
var ix,iy,t:integer;
    tu:PTUnit;
begin
   with _Units[u] do
   if(inapc=0)then
   begin
      tu:=@_Units[i];

      if(tu^.isbuild)
      then dec(ud,12+tu^.r)
      else dec(ud,r+tu^.r);

      if(ud<0)then
      begin
         t:=dist2(x,y,tu^.x,tu^.y)+1;
         ix:=trunc(ud*(tu^.x-x)/t)+1-random(2);
         iy:=trunc(ud*(tu^.y-y)/t)+1-random(2);

         inc(x,ix);
         inc(y,iy);

         vst:=UnitStepNum;

         _unit_correctcoords(u);
         _unit_mmcoords(u);
         _unit_sfog(u);

         dir:=p_dir(vx,vy,x,y);

         if((tu^.x=tu^.mx)and(tu^.y=tu^.my))then
         begin
            t:=dist2(mx,my,tu^.x,tu^.y)-r-tu^.r;
            if(t<=0)then
            begin
               mx:=x;
               my:=y;
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
   if(inapc=0)then
   begin
      td:=@map_dds[d];

      ud:=dist3(x,y,td^.x,td^.y,td^.t=DID_Liquid);

      dec(ud,r+td^.r);

      if(ud<0)then
      begin
         t:=dist3(x,y,td^.x,td^.y,td^.t=DID_Liquid)+1;
         ix:=trunc(ud*(td^.x-x)/t)+1-random(2);
         iy:=trunc(ud*(td^.y-y)/t)+1-random(2);

         inc(x,ix);
         inc(y,iy);

         vst:=UnitStepNum;

         _unit_correctcoords(u);
         _unit_mmcoords(u);
         _unit_sfog(u);

         if(rld=0)then dir:=p_dir(vx,vy,x,y);

         t:=dist3(mx,my,td^.x,td^.y,td^.t=DID_Liquid)-r-td^.r;
         if(t<=0)then
         begin
            mx:=x;
            my:=y;
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

function dir_diff(dir1,dir2:integer):integer;
begin
   dir_diff:=((( (dir1-dir2) mod 360) + 540) mod 360) - 180;
end;

function dir_turn(d1,d2,spd:integer):integer;
var d:integer;
begin
   d:=dir_diff(d2,d1);

   if abs(d)<=spd
   then dir_turn:=d2
   else dir_turn:=(360+d1+(spd*sign(d))) mod 360;
end;

procedure kill_player(p:byte);
var u:integer;
begin
   for u:=1 to MaxUnits do
    with _units[u] do
     if(hits>0)and(player=p)then
      _unit_kill(u,false);
end;

function _try_cp(tx,ty:integer;pp:byte):boolean;
var i:byte;
    c:boolean;
begin
   c:=false;
   _try_cp:=false;
   for i:=1 to MaxPlayers do
    with g_pt[i] do
     if(pp>0)and(pp<=MaxPlayers)then
      if(dist2(x,y,tx,ty)<point_r)then
      begin
         _try_cp:=true;
         if(cptt=0)then
         begin
            p   :=pp;
            c   :=true;
            cptt:=point_t[_players[pp].race];
         end
         else
           if(p<>pp)
           then dec(cptt,1)
           else cptt:=point_t[_players[pp].race];
      end;

   if(c)then
   begin
      pp:=0;

      for i:=2 to MaxPlayers do
       if(g_pt[1].p>0)and(g_pt[i-1].p>0)then
        if(_players[g_pt[i].p].team=_players[g_pt[i-1].p].team)then inc(pp,1);

      if(pp=3)then
       for i:=1 to MaxPlayers do
        if(_players[i].team<>_players[g_pt[1].p].team)then kill_player(i);
   end;
end;

procedure _unit_move(u:integer);
var mdist,tx,ty,spup:integer;
begin
  with(_units[u])do
   if(inapc>0)then
   begin
      x :=_units[inapc].x;
      y :=_units[inapc].y;
      mx:=x;
      my:=y;
      if(player=PlayerHuman)then
       if(_units[inapc].sel)then inc(ui_apc[utp],1);
      _unit_sfog(u);
   end
   else
  if(onlySVCode)then
   if (speed>0)and(rld=0)and(paint=0)and(canw)then
   begin
       tx:=mx;
       ty:=my;

       if(tar>0)and(apcm=0) then
       begin
          tx:=x;
          ty:=y;
          if(melee)then
          begin
             tx:=_units[tar].x;
             ty:=_units[tar].y;
             if(dist2(x,y,tx,ty)<(r+_units[tar].r+melee_r))then exit;
          end;
       end;

       if (x=vx)and(y=vy) then
        if (x<>tx)or(y<>ty) then
        begin
           mdist:=dist2(x,y,tx,ty);
           if (mdist<=speed) then
           begin
              x:=tx;
              y:=ty;
           end else
           begin
              spup:=speed;

              with _players[player] do
              begin
                 if(ucl in marines)and(upgr[upgr_mspeed]>0)then inc(spup,2);
                 if(race=r_hell)and(upgr[upgr_hpower]>0)then
                   if(ucl=uid_demon)
                   then inc(spup,5)
                   else inc(spup,1);
              end;

              if(mdist>70)
              then mdist:=15+random(25)
              else mdist:=60;

              dir:=dir_turn(dir,p_dir(x,y,tx,ty),mdist);//15+random(25)

              x:=x+trunc(spup*cos(dir*degtorad));
              y:=y-trunc(spup*sin(dir*degtorad));
           end;
           if(uf=uf_ground)then _unit_npush(u);
           _unit_correctcoords(u);
           _unit_sfog(u);
        end;
    end;
end;



procedure _unit_mattack(u:integer);
var tu:PTUnit;
 damup,tmp:integer;
begin
   with _units[u] do
   with _players[player] do
   begin
      tu:=@_units[tar];
      if(dist2(x,y,tu^.x,tu^.y)<(r+tu^.r+melee_r))or(ucl=UID_Mine)then
      begin
         damup:=upgr[upgr_attack] shl 2;

         if(rld=0)then
         begin
         case ucl of
UID_LostSoul: begin
                 PlaySND(snd_losts,u);

                 rld:=urld[r_hell,utp];

                 if(onlySVCode)then
                  if(upgr[upgr_zomb]>0)and(tu^.shield=0)then
                  begin
                     if(tu^.ucl in marines)then
                     begin
                        PlaySND(snd_zc,u);
                        _unit_remove(tar);
                        inc(army,1);
                        _unit_remove(u);
                        dec(army,1);
                        hits:=-1000;
                        tu^.hits:=-1000;
                        case tu^.ucl of
                    UID_Medic,
                    UID_Engineer  : _unit_add(tu^.vx,tu^.vy,UID_ZFormer  ,player);
                    UID_Sergant   : _unit_add(tu^.vx,tu^.vy,UID_ZSergant ,player);
                    UID_Commando  : _unit_add(tu^.vx,tu^.vy,UID_ZCommando,player);
                    UID_Bomber    : _unit_add(tu^.vx,tu^.vy,UID_ZBomber  ,player);
                    UID_Major     : _unit_add(tu^.vx,tu^.vy,UID_ZFPlasma ,player);
                    UID_BFG       : _unit_add(tu^.vx,tu^.vy,UID_ZBFG     ,player);
                        else
                        end;
                     end
                     else
                       if(tu^.ucl = UID_UACBarracks)and(tu^.bld)and(tu^.hits<1000)and(menerg>0)then//and(_mmode=mm_camp)
                       begin
                          PlaySND(snd_hellbar,u);
                          tmp:=tu^.hits;
                          _unit_remove(tar);
                          inc(army,1);
                          _unit_remove(u);
                          dec(army,1);
                          hits:=-1000;
                          tu^.hits:=-1000;
                          _unit_add(tu^.vx,tu^.vy,UID_HellBarracks,player);
                          with _units[_lau] do hits:=tmp;
                          _effect_add(tu^.vx,tu^.vy,tu^.vy+1,eid_hbar);
                       end
                       else _unit_damage(tar,md_lost+damup,1);
                  end
                  else _unit_damage(tar,md_lost+damup,1);
              end;
UID_Demon:    begin
                 _unit_damage(tar,md_demon+damup,1);
                 rld:=urld[r_hell,utp];
                 PlaySND(snd_demona,u);
              end;
UID_Imp:      begin
                 _unit_damage(tar,md_imp+damup,1);
                 rld:=urld[r_hell,utp];
                 PlaySND(snd_hmelee,u);
              end;
UID_Cacodemon:begin
                 _unit_damage(tar,md_caco+damup,1);
                 rld:=urld[r_hell,utp];
                 PlaySND(snd_hmelee,u);
              end;
UID_Baron:    begin
                 _unit_damage(tar,md_baron+damup,1);
                 rld:=urld[r_hell,utp];
                 PlaySND(snd_hmelee,u);
              end;
UID_Medic :   begin
                 if(onlySVCode)and(tu^.paint=0)then
                 begin
                    inc(tu^.hits,repair[tu^.bio]);
                    if(tu^.hits>tu^.mhits)then tu^.hits:=tu^.mhits;
                    tu^.paint:=pain_state_time;
                 end;
                 rld:=urld[r_uac,utp];
                 PlaySND(snd_cast,u);
              end;
UID_Engineer: begin
                 if(onlySVCode)and(tu^.paint=0)then
                 begin
                    inc(tu^.hits,repair[tu^.bio]);
                    if(tu^.hits>tu^.mhits)then tu^.hits:=tu^.mhits;
                 end;
                 rld:=urld[r_uac,utp];
                 PlaySND(snd_cast2,u);
              end;
UID_Mine:     begin
                 if(onlySVCode)and(melee)then
                  if(tu^.isbuild=false)then
                  begin
                     _missile_add(x,y,x,y,0,mid_mexplode,player,uf_ground);
                     _unit_damage(u,500,1);
                  end;
              end;
         end;

         if(race=r_hell)and(upgr[upgr_hpower]>0)and(rld>0)then dec(rld,haspdu[utp]);

         end;

         if(u<>tar)then dir:=p_dir(x,y,tu^.x,tu^.y);
      end;
   end;
end;

procedure _unit_dattack(u:integer);
var tu:PTUnit;
begin
   with _units[u] do
   begin
      tu:=@_units[tar];

      if(rld=0)then
      begin
      case ucl of
UID_Imp:       begin
                  _missile_add(tu^.x,tu^.y,x,y,tar,mid_imp,player,tu^.uf);
                  rld:=urld[r_hell,utp];
                  PlaySND(snd_hshoot,u);
               end;
UID_Cacodemon: begin
                  _missile_add(tu^.x,tu^.y,x,y,tar,mid_caco,player,tu^.uf);
                  rld:=urld[r_hell,utp];
                  PlaySND(snd_hshoot,u);
               end;
UID_Baron:     begin
                  _missile_add(tu^.x,tu^.y,x,y,tar,mid_baron,player,tu^.uf);
                  rld:=urld[r_hell,utp];
                  PlaySND(snd_hshoot,u);
               end;
UID_Cyberdemon:begin
                  _missile_add(tu^.x,tu^.y,x,y,0,mid_rocket,player,tu^.uf);
                  rld:=urld[r_hell,utp];
                  PlaySND(snd_launch,u);
               end;
UID_Mastermind:begin
                  _missile_add(tu^.x,tu^.y,x,y,tar,mid_MBullet,player,tu^.uf);
                  rld:=urld[r_hell,utp];
                  PlaySND(snd_shotgun,u);
               end;
UID_ZFormer:   begin
                  _missile_add(tu^.x,tu^.y,x,y,tar,mid_bullet,player,tu^.uf);
                  rld:=urld[r_hell,utp];
                  PlaySND(snd_pistol,u);
               end;
UID_ZSergant:  begin
                  _missile_add(tu^.x,tu^.y,x,y,0,mid_Sbullet,player,tu^.uf);
                  rld:=urld[r_hell,utp];
                  PlaySND(snd_shotgun,u);
               end;
UID_HellTower: begin
                  if(tu^.ucl=UID_Cacodemon)
                  then _missile_add(tu^.x,tu^.y,x,y-15,tar,mid_imp,player,tu^.uf)
                  else _missile_add(tu^.x,tu^.y,x,y-15,tar,mid_caco,player,tu^.uf);

                  rld:=hellt_rld;
                  PlaySND(snd_hshoot,u);
               end;

UID_Engineer,
UID_Medic:     begin
                  with _players[player] do
                   if(ucl=UID_Medic)and(upgr[upgr_toxin]>0)
                   then _missile_add(tu^.x,tu^.y,x,y,tar,mid_toxbullet,player,tu^.uf)
                   else _missile_add(tu^.x,tu^.y,x,y,tar,mid_bullet,player,tu^.uf);
                  rld:=urld[r_uac,utp];
                  PlaySND(snd_pistol,u);
               end;
UID_Sergant:   begin
                  _missile_add(tu^.x,tu^.y,x,y,0,mid_Sbullet,player,tu^.uf);
                  rld:=urld[r_uac,utp];
                  PlaySND(snd_shotgun,u);
               end;
UID_ZCommando: begin
                  _missile_add(tu^.x,tu^.y,x,y,tar,mid_bullet,player,tu^.uf);
                  rld:=urld[r_uac,ut_3]+2;
                  PlaySND(snd_shotgun,u);
               end;
UID_Commando:  begin
                  _missile_add(tu^.x,tu^.y,x,y,tar,mid_bullet,player,tu^.uf);
                  rld:=urld[r_uac,ut_3];
                  PlaySND(snd_pistol,u);
               end;
UID_ZBomber,
UID_Bomber:    if(dist2(x,y,tu^.x,tu^.y)>bomber_minr)then
               begin
                  _missile_add(tu^.x,tu^.y-10,x,y,0,mid_granade,player,uf_ground);
                  rld:=urld[r_uac,ut_4];
                  PlaySND(snd_launch,u);
               end;
UID_ZFPlasma,
UID_Major:     begin
                  _missile_add(tu^.x,tu^.y,x,y,tar,mid_plasma,player,tu^.uf);
                  rld:=urld[r_uac,ut_5];
                  PlaySND(snd_plasmas,u);
               end;
UID_ZBFG,
UID_BFG:      begin
                  rld:=urld[r_uac,ut_6];
                  PlaySND(snd_bfgs,u);
               end;


UID_UACTurret: begin
                  _missile_add(tu^.x,tu^.y,x,y,tar,mid_bullet,player,tu^.uf);
                  rld:=uact_rld;
                  PlaySND(snd_pistol,u);
               end;
      end;

      with _players[player] do
       if(rld>0)and(isbuild=false)then
        if(race=r_hell)and(upgr[upgr_hpower]>0)then
         dec(rld,haspdu[utp]);

      end;

      if(rld=bfg_s_tick)then
       case ucl of
        UID_ZBFG,
        UID_BFG: begin
                    _missile_add(tu^.x,tu^.y,x,y,0,mid_bfg,player,1);
                    rld:=bfg_s_tick-1;
                 end;
       else
       end;


      dir:=p_dir(x,y,tu^.x,tu^.y);
   end;
end;

procedure _unit_chkupgrds(u:integer);
begin
  with _units[u] do
   with _players[player] do
   begin
      if(isbuild)then
      begin
         if(upgr[upgr_vision]>0)then
          if(ucl=UID_HellKeep)or(utp=4)or(ucl=UID_Mine)then detect:=1;
      end else
      begin
         if(upgr[upgr_invis ]>0)then
          if(ucl=UID_demon)or(ucl in marines) then invis:=1;

         if(upgr[upgr_vision]>0)then
          case ucl of
       UID_LostSoul,
       UID_Engineer : detect:=1;
          end;
      end;
   end;
end;

procedure cmp_portalspawn(x,y:integer;t:byte);
var id,p:byte;
begin
   for p:=0 to MaxPlayers do
    with _players[p] do
    if(state>PS_none)then
     if(team=t)and(alw_u<>[])then
     begin
        repeat
           id:=random(7);
        until id in alw_u;

        _unit_add(x,y,rut2u[race,id],p);
     end;
   if(_lau>0)then
   begin
      _effect_add(x,y,y+1,eid_Teleport);
      if _nhp(x,y) then PlaySND(snd_teleport,0);
   end;
end;

function _canattack(u:integer):boolean;
begin
   _canattack:=true;
   with _units[u] do
   begin
      if(inapc>0)then
       if(_units[inapc].inapc>0)then _canattack:=false;

      if(isbuild)then
      begin
         if(bld=false)then _canattack:=false;
      end
      else
        if(paint>0)then _canattack:=false;
   end;
end;

procedure _unit_c2(u:integer);
begin
  with _units[u] do
   with _players[player] do
   begin

      if(prdc_units=_uclord)then
      begin
         _unit_chkupgrds(u);

         if(bld)and(isbuild)then
          if(upgr[upgr_build]>0)then
            if(utp=0)and(race=r_uac)then shield:=vid_fps;

         if(_rpls_rst<rpl_rhead)and(onlySVCode)then
          if(g_mode=gm_ct)then
           if _try_cp(x,y,player) then
           begin
              if(race=r_uac)then shield:=vid_fps;
              if(hits<mhits)then inc(hits,1);
           end;
      end;

      if(paint >0)then dec(paint,1);
      if(vist  >0)then dec(vist,1);
      if(rld   >0)then dec(rld,1);
      if(shield>0)then dec(shield,1);
      if(alt   >0)then dec(alt,1);

      if(ucl in marines)then
       if(rld>0)then vist:=10;

      if(onlySVCode)then
      if(isbuild)then
      begin
         if(menerg=0)
         then _unit_kill(u,false)
         else
           if(bld=false)then
           begin
              if(menerg<cenerg)or(u0=0)
              then _unit_kill(u,false)
              else
                if(paint=0)then
                   if(prdc_units=_uclord)then
                   begin
                      if(_warpten)then hits:=mhits;
                      inc(hits,build_hits_inc);
                      if(hits>=mhits)then
                      begin
                         hits:=mhits;
                         bld :=true;

                         inc(menerg,generg);
                         dec(cenerg,1);
                      end;
                   end;
           end
           else
           begin
              if(rld>0)then
              begin
                 if(utp=ut_1)then
                  if((army+wb)>MaxPlayerUnits)or(menerg<cenerg)or(eu[false,utrain]>=u_m[race,utrain])
                  then _unit_canclet(u)
                  else
                    if(rld=1)or(_warpten)then
                    begin
                       if(race=r_hell)and(utrain>4)then hcmp:=false;
                       dec(wb,1);
                       rld:=0;
                       dec(cenerg,1);
                       _unit_add(x,y+r,rut2u[race,utrain],player);
                       _units[_lau].mx:=mx;
                       _units[_lau].my:=my;
                       if(player=PlayerHuman)then _unit_createsound(rut2u[race,utrain]);
                       if(ucl=uid_HEllGate)then
                       begin
                          _effect_add(x,y+r,y+1,eid_Teleport);
                          PlaySND(snd_teleport,u);
                       end;
                    end;

                 if(utp=ut_3)then
                  if(menerg<cenerg)then
                  begin
                     rld:=0;
                     dec(cenerg,1);
                  end
                  else
                    if(rld=1)or(_warpten)then
                    begin
                       rld:=0;
                       inc(upgr[utrain],1);
                       if(race=r_hell)and(utrain=upgr_hpower)then
                       begin
                          hptm:=hp_time;
                          if(player=playerhuman)then PlaySNDM(snd_hell);
                       end;
                       dec(cenerg,1);
                    end;

                  if(ucl=UID_HellBarracks)and(rld=1)and(army<MaxPlayerUnits)then
                  begin
                     _unit_add(x,y+r+7,zimba[_regen mod 3],player);
                     _units[_lau].mx:=mx;
                     _units[_lau].my:=my;
                     if(player=PlayerHuman)then _unit_createsound(UID_ZFormer);
                  end;
              end;

              if(utp=ut_0)and(u0=0)then u0:=u;
              if(utp=ut_1)and(u1=0)then u1:=u;
              if(utp=ut_3)and(u3=0)then u3:=u;
              if(utp=ut_5)and(u5=0)then u5:=u;

              if(_mmode=mm_camp)and(ucl=UID_UACPortal)and(cmp_portal>0)and(rld=0)then
              begin
                 rld:=cmp_portal;
                 cmp_portalspawn(x,y-30,team);
              end;
              if(ucl=UID_HellBarracks)and(rld=0)then
              begin
                 rld:=601;
              end;
           end;
      end
      else
      begin
         if(_regen=_uclord)then
          if(upgr[upgr_regen]>0)and(race=r_hell)and(hits<mhits)then
          begin
             inc(hits,3);
             if(hits>mhits)then hits:=mhits;
          end;
         if(tar=0)then
         begin
            if((x<>mx)or(y<>my))then
            begin
               if(rld=1)and not(melee and (ucl in [UID_Medic, UID_Engineer]))then dir:=p_dir(x,y,mx,my);
            end
            else
              if(ucl=UID_Medic)and(hits<mhits)then
              begin
                 tar:=u;
                 melee:=true;
              end;
         end;
      end;

      if(tar>0)and(inapc=0)then
       if(ucl in whocanattack)then
        if(_canattack(u))then
         if(melee=false)
         then _unit_dattack(u)
         else _unit_mattack(u);

      if (team=_Players[PlayerHuman].team)or((_rpls_rst>=rpl_rhead)and(PlayerHuman=0))then
      begin
         _fog_r(fx,fy,fr);
         if(radar)and(rld>radar_time) then _fog_r(mx,my,radar_fr);
      end;
   end;
end;


procedure _unit_teleport(u,tx,ty:integer);
begin
   with _units[u] do
   begin
      _effect_add(x,y,map_mw*uf+y+20,eid_Teleport);
      if _nhp(x,y) then PlaySND(snd_teleport,0);
      x:=tx;
      y:=ty;
      if(uf=uf_ground)then _unit_npush(u);
      _unit_correctcoords(u);
      paint:=vid_hfps;
      mx:=x;
      my:=y;
      vx:=x;
      vy:=y;
      _unit_sfog(u);
      _unit_mmcoords(u);
      if _nhp(x,y) then PlaySND(snd_teleport,0);
      _effect_add(x,y,map_mw*uf+y+1,eid_Teleport);
   end;
end;

function _unit_chktar(u,t,utd:integer):boolean;
var uu,tu:PTUnit;
 teams:boolean;
begin
   uu:=@_units[u];
   tu:=@_units[t];

   _unit_chktar:=false;

   if(uu^.ma>1)then exit;

   if(uu^.ma=1)then
    if(dist2(uu^.mx,uu^.my,tu^.vx,tu^.vy)>tu^.r)then exit;

   if(utd>=uu^.sr)or(tu^.hits<=0)or(tu^.inapc>0)then exit;

   if(tu^.dsbl)or(tu^.invuln)then exit;

   if(uu^.ucl=UID_Sergant)then
    with _players[uu^.player] do
     if(state=ps_comp)and(ai_skill>2)then
      if(utd>100)and(uu^.vist=0)and(uu^.invis>0)then exit;

   if(tu^.uf=uf_fly)then
   begin
      if(uu^.ucl=UID_Demon )then exit;
      if(uu^.ucl=UID_Mine  )then exit;
      if(uu^.ucl=UID_Bomber)then exit;
   end;

   if(uu^.ucl=UID_Bomber)then
    if(utd<=bomber_minr)or(tu^.uf>uf_ground)then exit;

   if(uu^.ucl=UID_Medic)and(tu^.ucl=UID_Medic)and(u<>t)then exit;

   teams:=(_players[tu^.player].team=_players[uu^.player].team);

   if(teams=false)then
    if((tu^.invis>0)and(tu^.vist=0))  then exit;

   if(teams)then
   begin
      if(uu^.ucl in [UID_Medic,UID_Engineer])then
      begin
         if(tu^.paint>0)or(tu^.hits>=tu^.mhits)then exit;
         case uu^.ucl of
           UID_Medic    : if(tu^.bio=false)then exit;
           UID_Engineer : if((tu^.bio)or(tu^.bld=false))then exit;
         else
           exit;
         end;
      end
      else exit;
   end;

   _unit_chktar:=true;
end;

procedure _unit_ttar(u:integer);
var tu:PTUnit;
begin
  if(onlySVCode)then
   with _units[u] do
    if(tar>0)then
    begin
       tu:=@_units[tar];
       if(_unit_chktar(u,tar,dist2(x,y,tu^.x,tu^.y))=false)then
       begin
          tar :=0;
          dtar:=32000;
       end;
    end;
end;

procedure _unit_swmelee(u:integer);
begin
   with _units[u] do
   begin
      melee:=false;

      if(ucl=UID_Mine)then melee:=(dist2(x,y,_units[tar].x,_units[tar].y)<=mine_r);
      if(ucl=UID_Demon)or(ucl=UID_LostSoul)then melee:=true;
      if(ucl=_units[tar].ucl)and((ucl=UID_Imp)or(ucl=UID_Cacodemon)or(ucl=UID_Baron))then melee:=true;
      if(ucl=UID_Medic)or(ucl=UID_Engineer)then
        if(_players[_units[tar].player].team=_players[player].team)then melee:=true;
   end;
end;

function _tar_pri(db:boolean;cuu:byte;tu:PTUnit):boolean;
begin
   _tar_pri:=false;

   case cuu of
   UID_imp,
   UID_Cacodemon,
   UID_Baron      : if(cuu<>tu^.ucl)
                    then _tar_pri:=true
                    else _tar_pri:=db;

   UID_Commando   : if(tu^.isbuild=false)
                    then _tar_pri:=true
                    else _tar_pri:=db;

   UID_Bomber     : if(tu^.isbuild)
                    then _tar_pri:=true
                    else _tar_pri:=db;
   else
    _tar_pri:=db;
   end
end;

procedure _unit_tardetect(u,t,ud:integer);
var tu:PTUnit;
begin
   with _Units[u] do
   begin
      tu:=@_units[t];

      if(tu^.dsbl)then
       if(ud<sr)and(player=PlayerHuman)then
       begin
          tu^.dsbl:=false;
          PlaySNDM(snd_al);
       end;

      with _players[player] do
      begin
         if(upgr[upgr_build]>0)then
          if(bld)and(isbuild)and(utp=0)and(ud<sr)then
           if(team=_players[tu^.player].team)then
           begin
              if(race=r_uac)then tu^.shield:=vid_fps;
           end
           else
            if(_players[player].race=r_hell)and(tu^.isbuild=false)then _unit_damage(t,pain_aura,0);

         if(ucl=UID_HellAltar)then
          if(ud<sr)then
           if(team<>_players[tu^.player].team)then _unit_damage(t,1,0);
      end;

      if(tu^.invis>0)then
       if(bld)and(tu^.invis<=detect)and(tu^.vist<vid_fps)and(paint<=pain_state_time)then
        if(_players[player].team<>_players[tu^.player].team)then
        begin
           if(ud<sr)then tu^.vist:=vid_fps;
           if(radar)and(rld>radar_time)then
            if(dist2(mx*fog_cw,my*fog_cw,tu^.x,tu^.y)<=radar_sr)then
             tu^.vist:=vid_fps;
        end;

      if(onlySVCode)then
       if _unit_chktar(u,t,ud)then
       begin
          if _tar_pri((ud<=dtar),ucl,tu) then
          begin
             tar :=t;
             dtar:=ud;
          end;
          _unit_swmelee(u);
       end;
   end;
end;

function _ai_point(tx,ty:integer;tt:byte;k:boolean):byte;
var i:byte;
   d,d2:integer;
begin
   _ai_point:=0;
   d:=32000;
   for i:=1 to MaxPlayers do
    with g_pt[i] do
     if(p=0)or(_players[p].team<>tt)or(k)then
     begin
        d2:=dist2(x,y,tx,ty);
        if(d2<d)then
        begin
           d:=d2;
           _ai_point:=i;
        end;
     end;
end;

procedure _unit_cycle(u:integer);
var uc,ud,trd:integer;
    tu:PTUnit;
    aiapcs,
    alb:boolean;
begin
  with _Units[u] do
   with _Players[player] do
   if(prdc_units=_uclord)and(inapc=0)then
   begin
      if(ucl=UID_FAPC)then
       if(state=ps_comp)then
       begin
          ma:=0;
          if(alt>0)or(ald<base_r)then ma:=3;
          if(g_mode=gm_inv)then
           if(dist2(x,y,map_psx[0],map_psy[0])<base_r)then  ma:=3
       end;

      aiapcs:=(g_mode<gm_inv)and(dist2(x,y,ai_bx[player],ai_by[player])<base_rr)and(ai_minpush>0);

      alb :=false;
      ald :=32000;
      tar :=0;
      dtar:=32000;
      trd :=32000;

      for uc:=1 to MaxUnits do
       if (uc<>u) then
       begin
          tu:=@_Units[uc];

          if (tu^.hits>0) then
          begin
             if(tu^.inapc=u)then
             begin
                if(ma=3)then
                begin
                   if(apcc>0)then
                   begin
                      dec(apcc,tu^.apcs);
                      tu^.inapc:=0;
                      if(apcc=0)then PlaySND(snd_inapc,u);
                      if(state=ps_comp)then
                      begin
                         tu^.order:=1;
                         tu^.ma:=0;
                         alt:=vid_fps;
                      end;
                   end;
                   if(apcc=0)then ma:=0;
                end;
                continue;
             end
             else
               if(tu^.inapc>0)then continue;

             ud:=dist2(x,y,tu^.x,tu^.y);

             _unit_tardetect(u,uc,ud);

             if(tu^.dsbl=false)then
              if(ud<ald)then
               if(team<>_players[tu^.player].team)then
               begin
                  if(ud<=sr)and(tu^.invuln=false)and((tu^.vist>0)or(tu^.invis=0))then
                  begin
                     alx:=tu^.x+(tu^.x-x);
                     aly:=tu^.y+(tu^.x-x);
                     alt:=alert_t[tu^.isbuild or isbuild];
                     ald:=ud;

                     if(player=PlayerHuman)and(ui_alarm<vid_fps)then
                     begin
                        if(ui_alarm=0)then PlaySND(snd_alarm,0);
                        ui_alarm:=ui_alarmt;
                        ui_ax   :=tu^.mmx;
                        ui_ay   :=tu^.mmy;
                        ui_isb  :=isbuild;
                        ui_cl   :=p_colors[tu^.player];
                     end;
                  end;
               end
               else
                 if(tu^.alt>0)and(alt=0)then
                 begin
                    if(ud<=sr)then
                    begin
                       alx:=tu^.alx+(tu^.x-x);
                       aly:=tu^.aly+(tu^.x-x);
                    end
                    else
                    begin
                       alx:=tu^.x;
                       aly:=tu^.y;
                    end;
                    ald:=ud;
                    alb:=(tu^.isbuild) and (g_mode<>gm_ct) and ai_defense and (tu^.ucl<>UID_Mine);
                 end;

               if(onlySVCode)and(not isbuild)and(paint=0)and(rld=0)then
               begin
                  if(tu^.teleport)then
                  begin
                     if(ud<tu^.r)and(tu^.rld=0)and(tu^.bld)then
                      if(_players[player].team=_players[tu^.player].team)then
                       if(dist2(mx,my,tu^.x,tu^.y)<tu^.r)then
                        if(dist2(tu^.x,tu^.y,tu^.mx,tu^.my)>tu^.sr)then
                        begin
                           _unit_teleport(u,tu^.mx,tu^.my);
                           tu^.rld:=teleport_time[utp];
                        end;
                  end
                  else
                  begin
                     if((tu^.apcm-tu^.apcc)>=apcs)and(ucl in whocaninapc)then
                      if(ud<=transport_r)and(ma=4)then
                      begin
                         inapc:=uc;
                         inc(tu^.apcc,apcs);
                         ma:=0;
                         PlaySND(snd_inapc,u);
                         if(sel)then
                         begin
                            dec(su[isbuild,utp],1);
                            sel:=false;
                         end;
                         exit;
                      end;
                     if((r<=tu^.r)or(tu^.isbuild))and(tu^.solid)and(sign(uf)=sign(tu^.uf))then _unit_push(u,uc,ud);

                     if(state=ps_comp)and(ucl=UID_FAPC)and((apcm-apcc)>=tu^.apcs)and(tu^.ucl in whocaninapc)and(tu^.uf=uf_ground)then
                      if(tu^.player=player)and(tu^.alt=0)and(alt=0)and(ald>base_rr)and(tu^.ald>base_rr)and(hits>100)and(ud<trd)then
                      begin
                         if(g_mode=gm_inv)then
                          if(dist2(tu^.x,tu^.y,map_psx[0],map_psy[0])<base_rr)then continue;
                         if(aiapcs)then
                          if(tu^.order=1)then continue;
                         trd:=ud;
                         mx:=tu^.x+(tu^.x-x);
                         my:=tu^.y+(tu^.y-y);
                         if(ud<=transport_r)then
                         begin
                            tu^.inapc:=u;
                            inc(apcc,tu^.apcs);
                            tu^.ma:=0;
                            PlaySND(snd_inapc,u);
                            if(sel)then
                            begin
                               dec(su[isbuild,utp],1);
                               sel:=false;
                            end;
                            continue;
                         end;
                      end;
                  end;
               end;
           end;
      end;
      canw:=((tar=0)and(rld=0))or(melee)or(apcm>0);

      if(not isbuild)and(uf=uf_ground)then _unit_npush(u);

      if(onlySVCode)then
       if(state=ps_comp)then
       begin
          if(ma>2)or(apcm>apcc)then exit;

          if(ald>base_rr)then
           if(g_mode=gm_ct)and(not radar)then
           begin
              uc:=_ai_point(x,y,team,((_uclord mod point_guard[race])=0)or(utp=7)or(hits<50)or(army<point_guard2[race]));
              if(uc>0)then
              begin
                 alx:=g_pt[uc].x-50+random(point_r);
                 aly:=g_pt[uc].y-50+random(point_r);
                 ald:=31999;
              end;
           end;

          if(ald<32000)then
          begin
             if(not isbuild)then
              if(order=1)or(ald<base_rr)or(alb)then
              begin
                 mx:=alx;
                 my:=aly;
              end;
             if(teleport)then
             begin
                mx:=alx-base_r+random(base_rr);
                my:=aly-base_r+random(base_rr);
                if(mx<build_b)then mx:=build_b;
                if(my<build_b)then my:=build_b;
                if(mx>map_b1 )then mx:=map_b1;
                if(my>map_b1 )then my:=map_b1;
             end;
             if(radar)then
             begin
                mx:=alx;
                my:=aly;
                _unit_radar(u);
             end;
          end
          else
            if(teleport)then
            begin
               if(g_mode=gm_inv)then
               begin
                 mx:=map_psx[0]-base_r+random(base_rr);
                 my:=map_psy[0]-base_r+random(base_rr);
               end
               else
               begin
                  mx:=random(map_mw);
                  my:=random(map_mw);
               end;
               if(mx<build_b)then mx:=build_b;
               if(my<build_b)then my:=build_b;
               if(mx>map_b1 )then mx:=map_b1;
               if(my>map_b1 )then my:=map_b1;
            end;
       end;
   end;
end;

procedure ai_bcenter;
var i:byte;
begin
   for i:=0 to MaxPlayers do
   begin
      ai_bx[i]:=map_psx[i];
      ai_by[i]:=map_psy[i];
   end;
end;

procedure ai_trybuild(x,y:integer;bp:byte);
var d:single;
    l:integer;
   bt:byte;
begin
   bt:=random(6);//default

   ai_bx[bp]:=x;
   ai_by[bp]:=y;

   with _players[bp] do
   if(ai_skill>1)then
   begin
      if(_mmode=mm_camp)and(_mcmp_sm=17)and(bp=0)then
       if(eu[true,1]<6)then bt:=1;

      if(ai_skill>4)then
      begin
         if(eu[true,4]<4)then bt:=4;
         if(eu[true,2]<4)then bt:=2;
      end;
      if(eu[true,1]<2)then bt:=1;
      if(eu[true,2]<2)then bt:=2;
   end;

   if(_mmode=mm_camp)and(_mcmp_sm=12)and(bp=0)
   then d:=random(180)*degtorad
   else d:=random(360)*degtorad;

   l:=b_ai_m+random(b_ai_l);
   x:=x+trunc(l*cos(d));
   y:=y-trunc(l*sin(d));
   _unit_startb(x,y,bt,bp);
end;

function ai_rc(x,y:integer):integer;
begin
   ai_rc:=(x+y) mod map_mw;
end;


procedure _ai_use_teleport(u,u5:integer);  ////////////
var dum,dut,dtm:integer;
   tu:PTUnit;
begin
   tu:=@_units[u5];
   with _units[u] do
   begin
      dum:=dist2(x,y,mx,my);
      dut:=dist2(x,y,tu^.x,tu^.y)+1;
      dtm:=dist2(mx,my,tu^.x,tu^.y);
      if(dtm>base_rr)then
       if(dum div dut)>2 then
       begin
          mx:=tu^.x;
          my:=tu^.y;
       end;
   end;
end;

procedure _u1_trn(u:integer);
begin
   with _units[u] do
    with _players[player] do
    begin
       if(race=r_uac)then
       begin
          if(eu[false,0]<5)then _unit_straining(u,0);
          if(eu[false,7]<=transport_c[map_ffly])then _unit_straining(u,7);
       end;
       if(eu[false,0]<15)then _unit_straining(u,0);
       _unit_straining(u,random(7));
    end;
end;

procedure _unit_AI(u:integer);
begin
  if(onlySVCode)then
   with _units[u] do
    with _players[player] do
     if(state=ps_comp)and(bld)and(inapc=0)then
     begin
        if(prdc_units=_uclord)then
        begin
           if(isbuild)then
           begin
              if(utp=ut_0)and(u0=u)then ai_trybuild(x,y,player);

              if(utp=ut_1)then
              begin
                 if(army<ai_maxarmy)then
                  if(u1=u)
                  then _u1_trn(u)
                  else
                    if(_mmode=mm_camp)
                    then _unit_straining(u,random(7))
                    else
                      if(army<20)
                      then _unit_straining(u,random(3))
                      else
                        if(map_ffly=false)or(army<point_guard2[race])or(ai_skill<2)or((g_mode=gm_inv)and(race=r_hell))
                        then _unit_straining(u,random(7))
                        else
                          begin
                             if(race=r_hell)then _unit_straining(u,3);
                             if(race=r_uac )then _unit_straining(u,5);
                          end;
              end;

              if(utp=ut_3)and(u3=u)then
              begin
                 if(ai_skill>=4)then _unit_supgrade(u3,3);

                 _unit_supgrade(u3,random(8));
              end;

           end;
          if(ai_skill>3)then
           if(ucl=UID_LostSoul)then  ///
           begin
              ma:=0;
              if(upgr[upgr_vision]>0)then
              begin
                 if(tar>0)and not( (upgr[upgr_zomb]>0)and(_units[tar].ucl in hzmbatc ) )  and(eu[false,0]<10) and not(g_mode in [gm_inv,gm_ct])
                 then ma:=2
                 else ma:=0;
                 if(ma=2)then
                 begin
                    mx:=x-(_units[tar].x-x);
                    my:=y-(_units[tar].y-y);
                    inc(dir,180);
                    dir:=dir mod 360;
                 end;
              end;
           end;
        end;

        if(_regen=_uclord)then
        begin
           if(isbuild)then
           begin
              if(utp=ut_0)and(u0<>u)and(random(3)=0)then u0:=u;

              if(u0=0)and(utp<6)then
              begin
                 ai_bx[player]:=x;
                 ai_by[player]:=y;
              end;
           end
           else
           begin
              if(order=0)then
               if((army>ai_minpush)and ( ((_uclord>=ai_partpush)and ((map_ffly=false)or(ai_skill<2))) or ((map_ffly=true)and(uf>uf_ground)) ) )
               or(((utp=ut_0)or(_uclord=0)or((race=r_hell)and(utp<3)and(cmp_hellagr)))and(ai_skill>2))
               or(utp=ut_7)
               or(g_mode in [gm_inv,gm_ct])then
               begin
                  order:=1;
                  mx:=ai_bx[player];
                  my:=ai_by[player];
               end;

              if(ucl=UID_FAPC)then
               if((apcc<apcm)and(army<ai_maxarmy))or(hits<100)
               then order:=0
               else order:=1;

              if(ald>base_rr)then
               if(order=0)or((apcc<apcm)and(ucl=UID_FAPC))then
               begin
                  mx:=ai_bx[player]-base_r+random(base_rr);
                  my:=ai_by[player]-base_r+random(base_rr);
               end;

              if(order=1)then
              begin
                 if(g_mode=gm_inv)and(player>0)then
                 begin
                    mx:=map_psx[0]-base_r+random(base_rr);
                    my:=map_psy[0]-base_r+random(base_rr);
                 end
                 else
                  if(dist2(x,y,mx,my)<sr)then
                  begin
                     if(utp=ut_0)or(_uclord=0)or(ai_minpush=0)then
                     begin
                        mx:=random(map_mw);
                        my:=random(map_mw);
                     end else
                     begin
                        mx:=ai_rc(mx+my,1235);
                        my:=ai_rc(mx+my,1235);
                     end;
                  end;

                 if(ai_skill>1)and(ucl=UID_Engineer)then
                  if(eu[true,6]<10)and(tar>0)and(melee=false)then _unit_trysetmine(u);
              end;

              if(ucl=UID_Medic)and(hits<mhits)and(tar=0)then
              begin
                 mx:=vx;
                 my:=vy;
              end;

              if(ai_skill>2)then
               if(race=r_hell)and(u5>0)and((utp<3)or(_uclord>37)or(_uclord=0)or(g_mode=gm_inv))then _ai_use_teleport(u,u5);
           end;
        end;
     end;
end;


procedure _netSetUcl(u:integer);
var pu:PTUnit;
begin
   pu:=@_units[0];
   with _units[u] do
     with _players[player] do
      if(pu^.hits<=0)and(hits>0)then // d to a
      begin
         _defUnit(u);
         if(sel)then inc(su[isbuild,utp],1);
         inc(eu[isbuild,utp],1);
         inc(army,1);
         vx:=x;
         vy:=y;

         if(not isbuild)then
         begin
            if(Player=PlayerHuman)and(_rpls_rst<rpl_rhead)then _unit_createsound(ucl);
            bld:=true;
            if(race=r_hell)then
            begin
              // PlaySND(snd_teleport,u);
               if not(ucl in [UID_ZFormer,UID_ZSergant])then _effect_add(x,y,map_mw*uf+y+20,eid_Teleport);
            end;
         end
         else
           if(player=PlayerHuman)then
           begin
              if(_moveView)then _moveHumView(x,y);
              if(not bld)and(_rpls_rst<rpl_rhead)then PlaySND(snd_build,0);
           end;

         if(ucl=UID_HellBarracks)then
         begin
           _effect_add(x,y,y+1,eid_hbar);
           PlaySND(snd_hellbar,u);
         end;
      end
      else
        if(pu^.hits>0)and(hits<=0)then // a to d
        begin
           vx:=x;
           vy:=y;
           if(pu^.sel)then dec(su[isbuild,utp],1);
           dec(eu[isbuild,utp],1);
           dec(army,1);
           if(inapc=0)then _unit_deadeff(u,(hits<gavno_dth_h));
        end
        else
          if(hits>0)then    // a to a
          begin
             if(pu^.ucl<>ucl)then
             begin
                _defUnit(u);
                dec(eu[pu^.isbuild,pu^.utp],1);
                inc(eu[isbuild,utp],1);

                if(pu^.sel)then dec(su[pu^.isbuild,pu^.utp],1);
                if(sel)then inc(su[isbuild,utp],1);

                if(ucl=UID_HellBarracks)then
                begin
                  _effect_add(x,y,y+1,eid_hbar);
                  PlaySND(snd_hellbar,u);
                end;

                vx:=x;
                vy:=y;
             end else
             begin
                if(pu^.sel=false)and(sel)then inc(su[isbuild,utp],1);
                if(pu^.sel)and(sel=false)then dec(su[isbuild,utp],1);
             end;

             if(pu^.inapc=0)and(inapc>0)then
              if(sel)then
              begin
                 sel:=false;
                 dec(su[isbuild,utp],1);
              end;

             if(pu^.inapc<>inapc)and(_nhp(pu^.x,pu^.y))then PlaySND(snd_inapc,0);

             if(radar)then
              if(pu^.rld=0)and(rld>0)and((Player=PlayerHuman)or(_rpls_rst>=rpl_rhead))then PlaySND(snd_radar,0);

             _unit_chkupgrds(u);

             if(not isbuild)then
             begin
                if(tar>0)then
                begin
                   dtar:=dist2(x,y,_units[tar].x,_units[tar].y);
                   _unit_swmelee(u);
                end;

                wanim:=(pu^.x<>x)or(pu^.y<>y);
                if wanim then
                begin
                   _unit_sfog(u);
                   _unit_mmcoords(u);
                   vst:=UnitStepNumNet;

                   dir:=p_dir(pu^.x,pu^.y,x,y);

                  if(pu^.ucl=ucl)then
                   if(dist2(x,y,pu^.x,pu^.y)>teleport_md)then
                   begin
                      if _nhp(pu^.x,pu^.y) then PlaySND(snd_teleport,0);
                      if _nhp(x,y) then PlaySND(snd_teleport,0);
                      _effect_add(x,y,map_mw*uf+y+20,eid_Teleport);
                      _effect_add(pu^.x,pu^.y,map_mw*uf+y+20,eid_Teleport);
                      vx:=x;
                      vy:=y;
                   end;
                end;
             end;
          end;
end;



procedure _u_ord(pl:byte);
var u,mu,scnt,scntm:integer;
    psel:boolean;
begin
  with _players[pl] do
   if(o_id>0)and(army>0)then
   begin
      case o_id of
uo_build   : _unit_startb(o_x0,o_y0,o_x1,pl);
uo_upgrade : if(u3>0)then _unit_supgrade(u3,o_x0);
uo_upcancle: if(u3>0)then _unit_cupgrade(u3);

      else

        scntm:=MaxPlayerUnits;

        if(o_id=uo_select)or(o_id=uo_aselect)then
        begin
           if(o_x0>o_x1)then begin u:=o_x1;o_x1:=o_x0;o_x0:=u;end;
           if(o_y0>o_y1)then begin u:=o_y1;o_y1:=o_y0;o_y0:=u;end;
           if (dist2(o_x0,o_y0,o_x1,o_y1)<4) then scntm:=1;
        end;

        scnt:=0;
        mu:=pl*MaxPlayerUnits+MaxPlayerUnits;

        for u:=(pl*MaxPlayerUnits+1) to mu do
         with _Units[u] do
          if (hits>0)and(dsbl=false)and(inapc=0) then
          begin
             psel:=sel;

             if(o_id=uo_select)or((o_id=uo_aselect)and(not sel))then
             begin
                sel:=((o_x0-r)<=vx)and(vx<=(o_x1+r))and((o_y0-r)<=vy)and(vy<=(o_y1+r));
                if(isbuild)and(scntm>1)and(o_id<>uo_aselect)then sel:=false;
                if(scnt>=scntm)then sel:=false;
             end;

             if(o_id=uo_selorder)and((o_y0=0)or(not sel))then sel:=(order=o_x0);

             if(isbuild=false)then
             begin
                if(o_id=uo_selall)then sel:=true;
             end
             else
              if(o_id=uo_selu5)and(bld)and(utp=ut_5)then sel:=true;

             if(o_id=uo_dblselect)or((o_id=uo_adblselect)and(not sel))then
              if(_lsuc=ucl)then
               sel:=((o_x0-r)<=vx)and(vx<=(o_x1+r))and((o_y0-r)<=vy)and(vy<=(o_y1+r));

             if(su[true,ut_1]=0)and(utp=ut_1)and(bld)and(isbuild)then
             begin
                if(o_id=uo_training)and(rld=0)then begin _unit_straining(u,o_x0); break; end;
                if(o_id=uo_cancle  )and(rld>0)then begin _unit_canclet(u); break; end;
             end;

             if(o_id=uo_ctraining)then
              if(utp=ut_1)and(rld>0)and(utrain=o_x0)then begin _unit_canclet(u); break; end;

             if (sel) then
             begin
                if(o_id=uo_setorder)then order:=o_x0;

                if(o_id=uo_stop)and(not isbuild)then
                 if(o_x0<>0)
                 then _unit_trysetmine(u)
                 else
                 begin
                    mx:=x;
                    my:=y;
                    if(o_y0>0)then ma:=3;
                 end;

                if(o_id=uo_action)then
                begin
                   mx:=o_x0;
                   my:=o_y0;

                   if(isbuild=false)and(rld=0)and(ucl<>UID_FAPC)then dir:=p_dir(x,y,mx,my);

                   if(radar)then _unit_radar(u);

                   ma:=0;
                   case o_y1 of
                   1 : ma:=1;
                   2 : ma:=4;
                   else
                   if(o_x1>0)then ma:=2;
                   end;

                   if(utp=ut_0)and(bld)and(isbuild)then
                    if((vx-r)<=o_x0)and(o_x0<=(vx+r))and((vy-r)<=o_y0)and(o_y0<=(vy+r))then u0:=u;
                end;

                if(o_id=uo_ioinu5)and(u5>0)then
                begin
                   mx:=_units[u5].x;
                   my:=_units[u5].y;
                end;

                if(o_id=uo_delete  )then _unit_kill(u,false);
                if(o_id=uo_training)then _unit_straining(u,o_x0);
                if(o_id=uo_cancle  )then _unit_canclet(u);

                if(psel=false)then inc(su[isbuild,utp],1);

                if(o_id=uo_select)then  _lsuc:=ucl;

                inc(scnt,1);
             end
             else
               if(psel=true)then dec(su[isbuild,utp],1);
          end;

        if (scnt=0) then _lsuc:=0;

      end;
      o_id:=0;
   end;
end;


procedure _unitsCycle;
var u:integer;
begin
   for u:=1 to MaxUnits do
    with _units[u] do
     if(hits>0)then
     begin
        if(dsbl=false)then
        begin
          _unit_ttar   (u);
          _unit_move   (u);
          _unit_movevis(u);
          _unit_cycle  (u);
          _unit_c2     (u);
          _unit_AI     (u);
        end;
        if(hits>0)then _unit_vis(u);
     end;
end;



