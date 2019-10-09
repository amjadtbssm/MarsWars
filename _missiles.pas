procedure _missile_add(mx,my,mvx,mvy,tr:integer;msid,pl,mft:byte);
var m:integer;
    tu:PTUnit;
begin
   for m:=1 to MaxMissiles do
    with _missiles[m] do
     if(vst=0)then
     begin
        x      := mx;
        y      := my;
        vx     := mvx;
        vy     := mvy;
        mid    := msid;
        tar    := tr;
        mf     := mft;
        player := pl;

        sr:=dist2(x,y,vx,vy);

        if(sr<missile_mr)then
        begin
           vst:=(sr div MissileStep);
           if(vst=0)then vst:=1;
        end
        else
        begin
           vst:=0;
           exit;
        end;

        if(tar>0)then
        begin
           tu:=@_units[tar];
           if(tu^.hits<=0)then
           begin
              vst:=0;
              exit;
           end
           else
             begin
                mx:=tu^.r shr 1;
                my:=tu^.r;
                inc(x,random(my)-mx);
                inc(y,random(my)-mx);
             end;
        end;


        case mid of
mid_imp      : begin dam:=15; sr :=0; end;
mid_caco     : begin dam:=30; sr :=0; end;
mid_baron    : begin dam:=50; sr :=0; end;
mid_granade  : begin dam:=70; inc(vst,vst div 3); sr :=granade_sp;end;
mid_rocket   : begin dam:=100;sr :=rocket_sp; dir:=((p_dir(vx,vy,x,y)+23) mod 360) div 45; dec(vst,vst div 3); if(vst<1)then vst:=1;  end;  
mid_mexplode : begin dam:=200;sr :=100; vst:=1; end;
mid_bullet,
mid_toxbullet: begin dam:=6;  sr :=0; vst:=1; end;
mid_Mbullet  : begin dam:=15; sr :=0; vst:=1; end;
mid_Sbullet  : begin sr :=dist2(x,y,vx,vy) div 4;dam:=4 +((69-sr) div 3); vst:=1; end; //7-27  60    20+   
mid_plasma   : begin dam:=18; sr :=0; vst:=vst div 2; if(vst<1)then vst:=1; end;
mid_bfg      : begin dam:=100;sr :=150;end;
        else
          vst:=0;
          break;
        end;

        with _players[player] do
        begin
           if(upgr[upgr_attack]>0)then
           case mid of
 mid_imp      : inc(dam,3);
 mid_caco     : inc(dam,5);
 mid_baron    : inc(dam,10);
 mid_granade  : inc(dam,5);
 mid_mexplode : inc(dam,15);
 mid_bullet,
 mid_toxbullet: inc(dam,2);
 mid_Sbullet  : inc(dam,2);
 mid_plasma   : inc(dam,3);
 mid_bfg      : inc(dam,15); 
           else
           end;

           if(race=r_hell)then
            if(upgr[upgr_hpower]>0)then
             case mid of
             mid_imp,
             mid_caco,
             mid_baron   : if(vst<=5)
                           then vst:=1
                           else dec(vst,5);
             end;
        end;

        break;
     end;
end;

function _cuidmid(mid,uid:byte):boolean;
begin
   _cuidmid:=not(
                 ((uid=UID_Imp        )and(mid=mid_imp     )) or
                 ((uid=UID_Cacodemon  )and(mid=mid_caco    )) or
                 ((uid=UID_Baron      )and(mid=mid_Baron   ))
                 );
end;

procedure _missle_damage(m:integer);
var damd,d,p:integer;
       tu:PTUnit;
begin
   with _missiles[m] do
   begin
      tu:=@_units[tar];
      if(tu^.hits>0)and(_cuidmid(mid,tu^.ucl))and(tu^.inapc=0)then
       if(_players[player].team<>_players[tu^.player].team)or ((mid in _midrockets)and(tu^.isbuild=false)) then
        if(abs(mf-tu^.uf)<2)then
        begin
           d:=dist2(vx,vy,tu^.x,tu^.y)-tu^.r;
           damd:=dam;

           case mid of
             mid_Sbullet : p:=3;
           else
             p:=1;
           end;

           if(tu^.shield>0)then
           begin
              if(mid in plasma  )then dec(damd,damd div 3);
              if(mid in bullets )then inc(damd,shield_aa[tu^.isbuild]);
              if(mid=mid_Sbullet)then inc(damd,shield_aa[tu^.isbuild]);
           end;
           if(tu^.ucl in demons)then
           begin
              if(mid=mid_baron  )then damd:=damd shr 1; // /2
              if(mid=mid_imp    )then damd:=damd shl 1; // *2
           end;
           if(tu^.isbuild)then
           begin
              if(mid in [mid_caco,mid_rocket,mid_granade])then damd:=damd shl 1; // *2
           end;
           if(mid in bullets)then
            if(tu^.ucl in bdx2cl)then
             damd:=damd*3;

           if(d<=0)then //direct
           begin
              if(mid=mid_bfg)then inc(damd,damd);

              if(mid=mid_toxbullet)and(tu^.ucl in demons)then
               if(tu^.paint<tox_time)
               then tu^.paint:=tox_time+10
               else
                 if(tu^.paint<tox_timem)
                 then inc(tu^.paint,vid_fps)
                 else tu^.paint:=tox_timem;

              if(tu^.isbuild)and(mid=mid_Sbullet)then inc(damd,2);

              _unit_damage(tar,damd,p);
           end
           else          // splash
             if(sr>0)and(d<sr)and((tu^.isbuild=false)or(mid=mid_Sbullet)) then 
             begin
                if(mid in _midrockets)then
                begin
                   if(tu^.ucl=UID_Cyberdemon)or(tu^.ucl=UID_Mastermind)then exit;
                   if(_players[player].team=_players[tu^.player].team)or(tu^.ucl in bdx2cl) then damd:=damd shr 1;  // /2
                end;

                if(mid=mid_bfg)then
                begin
                   if(tu^.ucl in marines)then damd:=damd shr 1;
                   if(tu^.shield>0)then dec(damd,damd div 3);
                end;

                if(mid=mid_Sbullet)then
                begin
                   if(tu^.ucl<>UID_Mine)then  
                   _unit_damage(tar,damd,p)
                end
                else _unit_damage(tar,trunc(damd*(1-(d/sr)) ),p);
             end;
        end;
   end;
end;

procedure _missile_cycle;
var m,u:integer;
begin
   for m:=1 to MaxMissiles do
    with _missiles[m] do
     if(vst>0)then
     begin
        Inc(vx,(x-vx) div vst);
        Inc(vy,(y-vy) div vst);
        dec(vst,1);

        fx:=vx div fog_cw;
        fy:=vy div fog_cw;

        if(vst=0)then
         if(dam>0)then
          if(tar>0)
          then _missle_damage(m)
          else
            for u:=1 to MaxUnits do
            begin
               tar:=u;
               _missle_damage(m);
            end;

     end;
end;



