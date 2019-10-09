
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

          if(player>0)then
           if(army=0)and(state>ps_none)then _lg_c_add(chr(player)+name+str_player_def);

          if(isbuild)then
          begin
             if(bld=false)then dec(cenerg,1)
             else
             begin
                if(rld>0)then
                begin
                   if(utp=ut_1)then _unit_canclet(u);
                   if(utp=ut_3)then dec(cenerg,1);
                end;
                dec(menerg,generg);
             end;

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

procedure _unit_kill(u:integer;gvn:boolean);
begin
   with _units[u] do
   if(hits>0)then
   begin
      _unit_remove(u);
      if(gvn)then hits:=-100;
   end;
end;

procedure _unit_damage(u,dam:integer;p:byte);
var arm:integer;
begin
   with _units[u] do
   begin
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

      if((player=PlayerHuman)and(_invuln))or(invuln)then exit;

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
             end;
          end;
      end;
   end;
end;


{$Include _missiles.pas}
{$Include _units_cl.pas}



procedure _defUnit(u:integer);
begin
   with _units[u] do
   begin

      order   := 0;
      dir     := 0;
      rld     := 0;
      utrain  := 0;
      paint   := 0;
      pains   := 0;
      tar     := 0;
      dtar    := 32000;
      ma      := 0;
      vist    := 0;
      shield  := 0;
      alx     := 0;
      aly     := 0;
      alt     := 0;
      ald     := 0;   
      inapc   := 0;
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
        end;
   end;
end;

procedure _unit_supgrade(u,up:integer);
begin
   with _units[u] do
    if(rld=0)and(bld)and(utp=ut_3)and(isbuild)then
     with _players[player] do
     if(upgr[up]=0)and(up in alw_up)then
      if(menerg>cenerg)and(up in [0..7])then
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


procedure _unit_radar(u:integer);
begin
   with _units[u] do
    if(bld)then
    begin
       if(rld=0)then rld:=radar_rld;
       mx:= mx div fog_cw;
       my:= my div fog_cw;
    end;
end;

procedure _unit_movevis(u:integer);
begin
   with (_units[u]) do
   begin
      if (vx<>x)or(vy<>y) then
        if(isbuild)or(inapc>0)then 
        begin
           vst:=0;
           vx:=x;
           vy:=y;
        end
        else
        begin
           if (vst=0) then vst:=UnitStepNum;
           Inc(vx,(x-vx) div vst);
           Inc(vy,(y-vy) div vst);
           dec(vst,1);
        end;
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
         //ud:=abs(ud);

         t:=dist2(x,y,tu^.x,tu^.y)+1;
         ix:=trunc(ud*(tu^.x-x)/t)+1-random(2);
         iy:=trunc(ud*(tu^.y-y)/t)+1-random(2);

         inc(x,ix);
         inc(y,iy);

         vst:=UnitStepNum;

         _unit_correctcoords(u);

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
   end
   else
   if (speed>0)and(rld=0)and(paint=0)and(canw)then
   begin 
       tx:=mx;
       ty:=my;

       if (tar>0)and(apcm=0) then  
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
                 rld:=urld[r_hell,utp];

                  if(upgr[upgr_zomb]>0)and(tu^.shield=0)then  
                  begin
                     if(tu^.ucl in marines)then
                     begin
                        _unit_remove(tar);
                        inc(army,1);
                        _unit_remove(u);
                        dec(army,1);
                        hits:=-1000;
                        tu^.hits:=-1000;
                        case tu^.ucl of
                    UID_Medic,
                    UID_Engineer  : _unit_add(tu^.vx,tu^.vy,UID_ZFormer ,player);
                    UID_Sergant   : _unit_add(tu^.vx,tu^.vy,UID_ZSergant,player);
                    UID_Commando  : _unit_add(tu^.vx,tu^.vy,UID_ZCommando,player);
                    UID_Bomber    : _unit_add(tu^.vx,tu^.vy,UID_ZBomber,player);
                    UID_Major     : _unit_add(tu^.vx,tu^.vy,UID_ZFPlasma,player);
                    UID_BFG       : _unit_add(tu^.vx,tu^.vy,UID_ZBFG,player);
                        else
                        end;  
                     end
                     else
                       if(tu^.ucl = UID_UACBarracks)and(tu^.bld)and(tu^.hits<1000)and(menerg>0)then
                       begin
                          tmp:=tu^.hits;
                          _unit_remove(tar);
                          inc(army,1);
                          _unit_remove(u);
                          dec(army,1);
                          tu^.hits:=-1000;
                          hits:=-1000;
                          _unit_add(tu^.vx,tu^.vy,UID_HellBarracks,player);
                          with _units[_lau] do hits:=tmp;
                       end
                       else _unit_damage(tar,md_lost+damup,1);
                  end
                  else _unit_damage(tar,md_lost+damup,1);

              end;
UID_Demon:    begin
                 _unit_damage(tar,md_demon+damup,1);
                 rld:=urld[r_hell,utp];
              end;
UID_Imp:      begin
                 _unit_damage(tar,md_imp+damup,1);
                 rld:=urld[r_hell,utp];
              end;
UID_Cacodemon:begin
                 _unit_damage(tar,md_caco+damup,1);
                 rld:=urld[r_hell,utp];
              end;
UID_Baron:    begin
                 _unit_damage(tar,md_baron+damup,1);
                 rld:=urld[r_hell,utp];
              end;

UID_Medic  : begin
                 if(tu^.paint=0)then
                 begin
                    inc(tu^.hits,repair[tu^.bio]);
                    if(tu^.hits>tu^.mhits)then tu^.hits:=tu^.mhits;
                    tu^.paint:=pain_state_time; 
                 end;
                 rld:=urld[r_uac,utp];
              end; 
UID_Engineer: begin
                 if(tu^.paint=0)then
                 begin
                    inc(tu^.hits,repair[tu^.bio]);
                    if(tu^.hits>tu^.mhits)then tu^.hits:=tu^.mhits;
                 end;
                 rld:=urld[r_uac,utp];
              end; 
UID_Mine:     begin
                 if(melee)then
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
               end;
UID_Cacodemon: begin
                  _missile_add(tu^.x,tu^.y,x,y,tar,mid_caco,player,tu^.uf);
                  rld:=urld[r_hell,utp];
               end;
UID_Baron:     begin
                  _missile_add(tu^.x,tu^.y,x,y,tar,mid_baron,player,tu^.uf);
                  rld:=urld[r_hell,utp];
               end;
UID_Cyberdemon:begin
                  _missile_add(tu^.x,tu^.y,x,y,0,mid_rocket,player,tu^.uf);
                  rld:=urld[r_hell,utp];
               end;
UID_Mastermind:begin
                  _missile_add(tu^.x,tu^.y,x,y,tar,mid_MBullet,player,tu^.uf);
                  rld:=urld[r_hell,utp];
               end;
UID_ZFormer:   begin
                  _missile_add(tu^.x,tu^.y,x,y,tar,mid_bullet,player,tu^.uf);
                  rld:=urld[r_hell,utp];
               end;
UID_ZSergant:  begin
                  _missile_add(tu^.x,tu^.y,x,y,0,mid_Sbullet,player,tu^.uf);
                  rld:=urld[r_hell,utp];
               end;
UID_HellTower: begin
                  if(tu^.ucl=UID_Cacodemon)
                  then _missile_add(tu^.x,tu^.y,x,y-15,tar,mid_imp,player,tu^.uf)
                  else _missile_add(tu^.x,tu^.y,x,y-15,tar,mid_caco,player,tu^.uf);

                  rld:=hellt_rld;
               end;

UID_Engineer,
UID_Medic:     begin
                  with _players[player] do
                   if(ucl=UID_Medic)and(upgr[upgr_toxin]>0)
                   then _missile_add(tu^.x,tu^.y,x,y,tar,mid_toxbullet,player,tu^.uf)
                   else _missile_add(tu^.x,tu^.y,x,y,tar,mid_bullet,player,tu^.uf);
                  rld:=urld[r_uac,utp];
               end;
UID_Sergant:   begin
                  _missile_add(tu^.x,tu^.y,x,y,0,mid_Sbullet,player,tu^.uf);
                  rld:=urld[r_uac,utp];
               end;
UID_ZCommando: begin
                  _missile_add(tu^.x,tu^.y,x,y,tar,mid_bullet,player,tu^.uf);
                  rld:=urld[r_uac,ut_3]+2;
               end;
UID_Commando:  begin
                  _missile_add(tu^.x,tu^.y,x,y,tar,mid_bullet,player,tu^.uf);
                  rld:=urld[r_uac,ut_3];
               end;
UID_ZBomber,
UID_Bomber:    if(dist2(x,y,tu^.x,tu^.y)>bomber_minr)then
               begin
                  _missile_add(tu^.x,tu^.y,x,y,0,mid_granade,player,uf_ground);
                  rld:=urld[r_uac,ut_4];
               end;
UID_ZFPlasma,
UID_Major:     begin
                  _missile_add(tu^.x,tu^.y,x,y,tar,mid_plasma,player,tu^.uf);
                  rld:=urld[r_uac,ut_5];
               end;
UID_ZBFG,
UID_BFG:      begin
                  rld:=urld[r_uac,ut_6];
               end;
                                      

UID_UACTurret: begin
                  _missile_add(tu^.x,tu^.y,x,y,tar,mid_bullet,player,tu^.uf);
                  rld:=uact_rld;
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
                       end;
                       dec(cenerg,1);
                    end;

                  if(ucl=UID_HellBarracks)and(rld=1)and(army<MaxPlayerUnits)then
                  begin
                     _unit_add(x,y+r+7,zimba[_regen mod 3],player);
                     _units[_lau].mx:=mx;
                     _units[_lau].my:=my;
                  end;
              end;

              if(utp=ut_0)and(u0=0)then u0:=u;
              if(utp=ut_1)and(u1=0)then u1:=u;
              if(utp=ut_3)and(u3=0)then u3:=u;
              if(utp=ut_5)and(u5=0)then u5:=u;

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

      if(tar>0)then
       if(ucl in whocanattack)then
        if(_canattack(u))then
         if(melee=false)
         then _unit_dattack(u)
         else _unit_mattack(u);
   end;
end;                                     


procedure _unit_teleport(u,tx,ty:integer);
begin
   with _units[u] do
   begin
      x:=tx;
      y:=ty;
      if(uf=uf_ground)then _unit_npush(u);
      _unit_correctcoords(u);
      paint:=vid_hfps;
      mx:=x;
      my:=y;
      vx:=x;
      vy:=y;
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
       if(ud<sr)and(player=tu^.player)then
       begin
          tu^.dsbl:=false;
       end;

      with _players[player] do
      if(upgr[upgr_build]>0)then
       if(bld)and(isbuild)and(utp=0)and(ud<sr)then
        if(team=_players[tu^.player].team)then
        begin
           if(race=r_uac)then tu^.shield:=vid_fps;
        end
        else
          if(_players[player].race=r_hell)and(tu^.isbuild=false)then _unit_damage(t,pain_aura,0);

      if(tu^.invis>0)then
       if(bld)and(tu^.invis<=detect)and(tu^.vist<vid_fps)and(paint<=pain_state_time)then
        if(_players[player].team<>_players[tu^.player].team)then
        begin
           if(ud<sr)then tu^.vist:=vid_fps;
           if(radar)and(rld>radar_time)then
            if(dist2(mx*fog_cw,my*fog_cw,tu^.x,tu^.y)<=radar_sr)then
             tu^.vist:=vid_fps;
        end;

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
                      if(state=ps_comp)then
                      begin
                         tu^.order:=1;
                         tu^.ma:=0;
                         tu^.alt:=vid_fps;
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
                    alb:=tu^.isbuild and (g_mode<>gm_ct) and ai_defense and (tu^.ucl<>UID_Mine);
                 end;

               if(not isbuild)and(paint=0)and(rld=0)then
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


procedure ai_trybuild(x,y:integer;bp:byte);
var d:single;
    l:integer;
   bt:byte;
begin
   bt:=random(6);

   ai_bx[bp]:=x;
   ai_by[bp]:=y;   

   with _players[bp] do
   if(ai_skill>1)then
   begin
      if(ai_skill>4)then
      begin
         if(eu[true,4]<4)then bt:=4;
         if(eu[true,2]<4)then bt:=2;
      end;
      if(eu[true,1]<2)then bt:=1;
      if(eu[true,2]<2)then bt:=2;
   end;

   d:=random(360)*degtorad;
   l:=b_ai_m+random(b_ai_l);
   x:=x+trunc(l*cos(d));
   y:=y-trunc(l*sin(d));
   _unit_startb(x,y,bt,bp);
end;

function ai_rc(x:integer):integer;
begin
   ai_rc:=(x+1235) mod map_mw;
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
                 if(tar>0)and not( (upgr[upgr_zomb]>0)and(_units[tar].ucl in hzmbatc) ) and(eu[false,0]<10) and not(g_mode in [gm_inv,gm_ct])   
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
               or(((utp=ut_0)or(_uclord=0)or((race=r_hell)and(utp<3)))and(ai_skill>2))
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
                     if(utp=ut_0)or(_uclord=0)or(ai_minpush=0)then        //LostSoul and engineer
                     begin
                        mx:=random(map_mw);
                        my:=random(map_mw);
                     end else
                     begin
                        mx:=ai_rc(mx+my);
                        my:=ai_rc(mx+my);
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
      if(dsbl=false)then
      begin
          _unit_ttar   (u);
          _unit_move   (u);
          _unit_movevis(u);
          _unit_cycle  (u);
          _unit_c2     (u);
          _unit_AI     (u);
      end;
end;



