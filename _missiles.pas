


procedure _miss_add(mx,my,mvx,mvy,mtar:integer;msid,mpl,mft,mspd:byte);
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
        tar    := mtar;
        mid    := msid;
        player := mpl;
        mf     := mft;
        mtars  := 0;

        sr:=dist2(x,y,vx,vy);

        if(sr>500)then exit;

        if(mid<>MID_Blizzard)then
         if(sr>missile_mr)then exit;

        case mid of
MID_Imp :
begin
   if(mspd>0)
   then vst:=sr div 16
   else vst:=sr div 10;
   if(vst=0)then vst:=1;

   dam:=14;
   sr :=0;
end;
MID_Cacodemon :
begin
   if(mspd>0)
   then vst:=sr div 13
   else vst:=sr div 8;
   if(vst=0)then vst:=1;

   dam:=30;
   sr :=0;
end;
MID_Baron :
begin
   if(mspd>0)
   then vst:=sr div 16
   else vst:=sr div 11;
   if(vst=0)then vst:=1;

   sr   :=0;
   if(g_addon)
   then dam  :=50
   else dam  :=40;

   mtars:=2+_players[player].upgr[upgr_attack];
end;

MID_HRocket :
begin
   if(mspd>0)
   then vst:=1
   else vst:=sr div 15;
   if(vst=0)then vst:=1;

   dam:=95;

   sr :=rocket_sr;
   dir:=((p_dir(vx,vy,x,y)+23) mod 360) div 45;
end;
MID_URocket :
begin
   if(mspd>0)
   then vst:=1
   else vst:=sr div 13;
   if(vst=0)then vst:=1;

   dam:=55;

   sr :=rocket_sr;
   dir:=((p_dir(vx,vy,x,y)+23) mod 360) div 45;
end;
MID_Granade :
begin
   if(mspd>0)then
   begin
      vst:=1;
      dam:=70;
      sr :=rocket_sr;
   end
   else
   begin
      vst:=sr div 9;
      dam:=50;
      sr :=rocket_sr;
   end;
   if(vst=0)then vst:=1;
end;
MID_Mine :
begin
   if(mspd>0)
   then vst:=1
   else vst:=sr div 15;
   if(vst=0)then vst:=1;

   dam:=180;
   sr :=100;
end;

MID_ArchFire:
begin
   vst:=1;
   dam:=100;
   sr :=13;
end;

MID_RevenantS,
MID_Revenant :
begin
   if(mspd>0)
   then vst:=sr div 10
   else vst:=sr div 6;
   if(vst=0)then vst:=1;

   dam:=30;
   sr :=0;
   dir:=((p_dir(vx,vy,x,y)+23) mod 360) div 45;
end;
MID_Octo :
begin
   vst:=sr div 5;
   if(vst=0)then vst:=1;
   dam:=100;
   sr :=20;
end;
MID_Mancubus :
begin
   if(mspd>0)
   then vst:=sr div 13
   else vst:=sr div 7;
   if(vst=0)then vst:=1;

   dam:=45;
   sr :=0;
   dir:=((p_dir(vx,vy,x,y)+23) mod 360) div 45;
end;

MID_BPlasma :
begin
   if(mspd>0)
   then vst:=sr div 17
   else vst:=sr div 13;
   if(vst=0)then vst:=1;

   dam:=18;
   sr :=0;
   if(g_addon=false)then mtars:=2;
end;

MID_YPlasma :
begin
   if(mspd>0)
   then vst:=sr div 20
   else vst:=sr div 15;
   if(vst=0)then vst:=1;

   dam:=15;
   sr :=0;
end;

MID_BFG  :
begin
   vst:=sr div 10;
   if(vst=0)then vst:=1;
   if(mspd>0)then inc(vst,vst shr 1);

   dam:=110;
   sr :=120;
end;

MID_TBullet,
MID_Bullet :
begin
   vst:=1;
   dam:=6;
   sr :=0;
end;
MID_Bulletx2 :
begin
   vst:=1;
   dam:=12;
   sr :=0;
end;
MID_SShot:
begin
   vst:=1;
   sr :=dist2(x,y,vx,vy) div 4;
   if(sr>60)then sr:=60;
   if(sr<8 )then sr:=8;
   dam:=4+(60-sr); // [4 56]
   mtars:=5;
end;
MID_SSShot :
begin
   vst:=1;
   sr :=(dist2(x,y,vx,vy) div 3);
   if(sr>80)then sr:=80;
   if(sr<8 )then sr:=8;
   dam:=7+(80-sr); // [7 79]
   mtars:=8;
end;

MID_Blizzard:
begin
   if(mspd>0)
   then vst:=1
   else vst:=vid_fps;

   dam:=225;
   sr :=175;
   dir:=((p_dir(vx,vy,x,y)+23) mod 360) div 45;
end;

        else
          vst:=0;
          exit;
        end;

        if(mtars=0)then
         if(tar=0)or(sr>0)
         then mtars:=MaxUnits
         else mtars:=1;

        if(tar>0)and(mid<>MID_RevenantS)then
        begin
           tu:=@_units[tar];
           mx:=tu^.r shr 1;
           my:=tu^.r;
           inc(x,random(my)-mx);
           inc(y,random(my)-mx);
        end;

        with _players[player] do
         if(upgr[upgr_attack]>0)then
         case mid of
MID_BPlasma,
MID_YPlasma,
MID_Imp       : inc(dam,upgr[upgr_attack]*2);
MID_Cacodemon,
MID_Baron     : inc(dam,upgr[upgr_attack]*4);
MID_Bulletx2,
MID_Bullet,
MID_TBullet   : inc(dam,upgr[upgr_attack]);
MID_SShot,
MID_SSShot    : inc(dam,upgr[upgr_attack]);
MID_URocket,
MID_HRocket,
MID_Granade   : inc(dam,upgr[upgr_attack]*5);
MID_Mine      : inc(dam,upgr[upgr_attack]*6);
MID_RevenantS,
MID_Revenant  : inc(dam,upgr[upgr_attack]*3);
MID_Mancubus  : inc(dam,upgr[upgr_attack]*5);
MID_BFG       : inc(dam,upgr[upgr_attack]*5);
MID_Blizzard  : inc(dam,upgr[upgr_attack]*10);
         end;

        break;
     end;
end;

function _miduid(mid,uid:byte):boolean;
begin
   _miduid:=false;

   if((mid=MID_Imp      )and(uid=UID_Imp        ))then exit;
   if((mid=MID_Cacodemon)and(uid=UID_Cacodemon  ))then exit;
   if((mid=MID_Baron    )and(uid=UID_Baron      ))then exit;
   if((mid=MID_Mancubus )and(uid=UID_Mancubus   ))then exit;
   if((mid=MID_YPlasma  )and(uid=UID_Arachnotron))then exit;
   if(uid=UID_Revenant)then
    if(mid in [MID_Revenant,MID_RevenantS])then exit;
   if((mid=MID_Octo     )and(uid=UID_Octobrain  ))then exit;

   _miduid:=true;
end;

procedure _missle_damage(m:integer);
var tu: PTUnit;
teams : boolean;
d,damd: integer;
     p: byte;
begin
   with _missiles[m] do
   begin
      tu:=@_units[tar];

      if(tu^.hits>0)and(_miduid(mid,tu^.uid))and(tu^.inapc=0)then
        if(abs(mf-tu^.uf)<2)then
        begin
           teams:=_players[player].team=_players[tu^.player].team;

           damd:=dam;

           if(teams)then
            if(tu^.isbuild)
            then damd:=damd div 8
            else damd:=damd div 2;

           d:=dist2(vx,vy,tu^.x,tu^.y)-tu^.r;
           if(sr=0)then dec(d,10);

           case mid of
             MID_Bulletx2 : p:=2;
             MID_SShot    : begin
                               p:=3;
                               if(tu^.mech   )then damd:=damd div 2;
                               if(tu^.isbuild)then damd:=damd div 2;
                            end;
             MID_SSShot   : begin
                               p:=5;
                               if(tu^.mech   )then damd:=damd div 2;
                               if(tu^.isbuild)then damd:=damd div 2;
                            end;
           else
             p:=1;
           end;

           {if(tu^.uid in demons)then
           begin
              if(mid=MID_Baron  )then damd:=damd div 2;
              if(mid=MID_Imp    )then damd:=damd*2;
              if(mid=MID_YPlasma)then damd:=damd*3;
           end;

           if(tu^.isbuild)then
           begin
              if(mid in [MID_Cacodemon,MID_Mancubus,MID_Blizzard,
                         MID_HRocket,MID_URocket,MID_Granade])then damd:=damd*2;
              if(mid=MID_ArchFire)then damd:=damd div 2;
              if(mid in [MID_Granade,MID_URocket,MID_Blizzard])and(teams=false)and(tu^.uid in uacbase)then inc(damd,damd div 2);
           end
           else
           begin
              if(tu^.mech)then
               if(mid in [MID_BPlasma])then inc(damd,8);

              if(mid in [MID_Revenant,MID_RevenantS])then
               if(tu^.mech)or(tu^.uid in [UID_Arachnotron,UID_Cyberdemon,UID_Mastermind])then damd:=damd*2;

              if(mid in [MID_Granade,MID_URocket,MID_HRocket,MID_Blizzard,MID_Mine])then
               if(tu^.r<13)then damd:=damd div 2;
           end;

           if(tu^.buff[ub_shield]>0)then
            if(mid in [MID_Imp,
                       MID_Cacodemon,
                       MID_Baron,
                       MID_Mancubus,
                       MID_YPlasma,
                       MID_BPlasma,
                       MID_BFG       ])then dec(damd,damd div 4);

           if(mid in [MID_Bullet,MID_TBullet])then
           begin
              if(tu^.mech)
              then damd:=damd div 2
              else
                if(tu^.r<13)then damd:=damd*2;
              if(tu^.uid=UID_Octobrain)then damd:=damd*3;
           end;

           if(tu^.r<13)then
           begin
              if(mid=MID_Bulletx2)then damd:=damd*3;
              if(mid=MID_Mancubus)then damd:=damd div 2;
           end; }

           if(d<=0)then // direct
           begin
              if(mid=MID_TBullet)and(tu^.mech=false)then
              begin
                 tu^.buff[ub_toxin]:=vid_fps;
                 tu^.buff[ub_pain ]:=vid_fps;
              end;

              if(mid in [MID_SShot,MID_SSShot,MID_Bullet,MID_Bulletx2,MID_TBullet])then
              begin
                 if(tu^.mech)
                 then _effect_add(x,y,tu^.vy+map_flydpth[tu^.uf]+1,MID_Bullet)
                 else _effect_add(x,y,tu^.vy+map_flydpth[tu^.uf]+1,EID_Blood);
              end;

              dec(mtars,1);
              _unit_damage(tar,damd,p,player);
           end
           else
             if(sr>0)and(d<sr)then
             begin
                if(mid in [MID_SShot,MID_SSShot])then
                begin
                   if(teams)then exit;
                   dec(mtars,1);
                   _unit_damage(tar,damd,p,player);
                   if(tu^.mech)
                   then _effect_add(tu^.vx,tu^.vy,tu^.vy+map_flydpth[tu^.uf]+1,MID_Bullet)
                   else _effect_add(tu^.vx,tu^.vy,tu^.vy+map_flydpth[tu^.uf]+1,EID_Blood);
                   exit;
                end;

                if(mid in [MID_HRocket,MID_URocket,MID_Granade])then
                begin
                   if(tu^.uid in [UID_Cyberdemon,UID_Mastermind])then exit;
                end;

                if(mid=MID_BFG)then
                begin
                   if(teams)then exit;
                   if(tu^.uid in marines)then damd:=damd div 2;
                   _effect_add(tu^.vx,tu^.vy,tu^.vy+map_flydpth[tu^.uf]+1,EID_BFG);
                end;

                dec(mtars,1);
                damd:=trunc(damd*(1-(d/sr)) );
                _unit_damage(tar,damd,p,player);
             end;
        end;
   end;
end;

procedure _missileCycle;
var m,u,d:integer;
    spr:PTUSprite;
begin
   for m:=1 to MaxMissiles do
    with _missiles[m] do
     if(vst>0)then
     begin
        if(mid=MID_RevenantS)then
         if(tar>0)then
         begin
            u  :=_units[tar].r;
            d  :=u*2;
            x  :=_units[tar].x-u+random(d);
            y  :=_units[tar].y-u+random(d);
            mf :=_units[tar].uf;
         end;

        Inc(vx,(x-vx) div vst);
        Inc(vy,(y-vy) div vst);
        dec(vst,1);

        case mid of
        MID_Blizzard : dec(vy,vst*2);
        MID_Granade  : dec(vy,vst div 3);
        end;

        fx:=vx div fog_cw;
        fy:=vy div fog_cw;

        if(vst=0)then
         if(dam>0)then
          if(tar>0)and(mtars=1)
          then _missle_damage(m)
          else
            for u:=1 to MaxUnits do
            begin
               tar:=u;
               _missle_damage(m);
               if(mtars<=0)then break;
            end;

        if(_ded)then continue;

        if(mid=MID_Blizzard)and(vst=0)then
        begin
           _effect_add(vx,vy+10,-10,eid_db_h0);
           _effect_add(vx,vy,map_flydpth[mf]+vy+5,EID_BBExp);
           PlaySND(snd_exp,0);
           continue;
        end;

        if(_fog_ch(fx,fy,0))then
        begin
           case mid of
        MID_Imp      : spr:=@spr_h_p0[0];
        MID_Cacodemon: spr:=@spr_h_p1[0];
        MID_Baron    : spr:=@spr_h_p2[0];
        MID_Blizzard,
        MID_HRocket  : spr:=@spr_h_p3[dir];
        MID_Granade  : spr:=@spr_h_p3[2];
        MID_URocket  : spr:=@spr_u_p3[dir];
        MID_RevenantS,
        MID_Revenant : spr:=@spr_h_p4[dir];
        MID_Mancubus : spr:=@spr_h_p5[dir];
        MID_YPlasma  : spr:=@spr_h_p7[0];
        MID_BPlasma  : spr:=@spr_u_p0[0];
        MID_BFG      : spr:=@spr_u_p2[0];
        MID_Octo     : spr:=@spr_o_p[(vst shr 1) mod 5]
           else
            spr:=@spr_dummy;
           end;

           if((vid_vx+vid_panel-spr^.hw)<vx)and(vx<(vid_vx+vid_mw+spr^.hw))and
             ((vid_vy          -spr^.hh)<vy)and(vy<(vid_vy+vid_mh+spr^.hh))then
           begin
              d:=map_flydpth[mf]+vy;

              case mid of
                MID_URocket,
                MID_RevenantS,
                MID_HRocket,
                MID_Granade  : if((vst mod 4)=0)then _effect_add(vx,vy,d-1,MID_Bullet);
                MID_Blizzard : if((vst mod 3)=0)then _effect_add(vx,vy,d-1,EID_Exp);
              end;

              _sl_add(vx-spr^.hw, vy-spr^.hh,d,0,0,0,false,spr^.surf,255,0,0,0,0,'',0);

              if(vst=0)then
              begin
                 case mid of
                 MID_ArchFire : begin PlaySND(snd_exp,0); exit; end;
                 MID_Imp,
                 MID_Cacodemon,
                 MID_Baron,
                 MID_Mancubus,
                 MID_BPlasma,
                 MID_YPlasma : PlaySND(snd_pexp,0);
                 MID_BFG     : PlaySND(snd_bfgepx,0);
                 MID_Revenant,
                 MID_Granade,
                 MID_URocket,
                 MID_HRocket : PlaySND(snd_exp,0);
                 MID_Blizzard: begin
                                  PlaySND(snd_exp2,0);
                               end;
                 MID_SShot,
                 MID_SSShot,
                 MID_Bullet,
                 MID_Bulletx2,
                 MID_TBullet : begin
                                  if(mf=uf_ground)then
                                   if(mid in [MID_SShot,MID_SSShot])then
                                    for u:=1 to mtars do _effect_add(vx-sr+random(sr shl 1),vy-sr+random(sr shl 1),d+40,mid_Bullet);
                                  if(random(4)=0)then PlaySND(snd_rico,0);
                                  continue;
                               end;
                 end;

                 _effect_add(vx,vy,d+50,mid);
              end;
           end;
        end;
     end;
end;





