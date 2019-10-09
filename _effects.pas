

procedure _click_eff(cx,cy,ca:integer;cc:cardinal);
begin
   ui_mc_x:=cx;
   ui_mc_y:=cy;
   ui_mc_a:=ca;
   ui_mc_c:=cc;
end;

procedure _effect_add(ex,ey,ed:integer; ee:byte);
var e:integer;
begin
   if(_menu=false)then
    for e:=1 to MaxSprBuffer do
     with _effects[e] do
      if(t=0)and(t2=0)then
      begin
         x :=ex;
         y :=ey;
         e :=ee;
         d :=ed;
         t2:=0;

         case e of
     eid_gavno     : t :=63;
     eid_BExplode  : t :=40;
     eid_BBExplode : t :=60;
     eid_Teleport  : t :=60;
     eid_blood     : t :=18;
     eid_Explode,
     mid_Rocket,
     mid_granade,
     mid_Imp,
     mid_Caco,
     mid_Baron,
     mid_MBullet,
     mid_Bullet,
     mid_SBullet,
     mid_Plasma    : t :=21;
     mid_bfg       : t :=44;
     eid_bfgef     : t :=31;
     UID_LostSoul  : t :=47;
     UID_Imp       : t :=47;
     UID_Demon     : t :=55;
     UID_Cacodemon : t :=55;
     UID_Baron     : t :=39;
     UID_Cyberdemon: t :=80;
     UID_Mastermind: t :=179;
     UID_ZBFG,
     UID_ZBomber,
     UID_ZFormer,
     UID_ZSergant  : t :=47;
     UID_ZCommando,
     UID_Major,
     UID_Medic,
     UID_Engineer,
     UID_Sergant,
     UID_Commando,
     UID_Bomber,
     UID_BFG       : t :=39;
     eid_db_h0,
     eid_db_h1,
     eid_db_u0,
     eid_db_u1     : t :=dead_time;
     eid_hbar      : t :=120;
         else
           t:=0;
         end;

         if(e in whdead)then t2:=dead_time;

         tm:=t;

        break;
     end;
end;

procedure _effects_cycle;
var ei,alpha:integer;
  spr:PTUSprite;
begin
   spr:=@spr_dum;
   for ei:=1 to MaxSprBuffer do
    with _effects[ei] do
     if(t>0)or(t2>0)then
     begin
        alpha:=255;

        case e of
eid_gavno      : spr:=@spr_vgvn[t div 8];
eid_BExplode   : spr:=@spr_bex1[t div 7];      //5
eid_BBExplode  : spr:=@spr_bex2[t div 7];      //8
eid_Teleport   : spr:=@spr_teleport[t div 11]; //5
eid_BFGef      : spr:=@spr_bfg[t div 8];       //3
eid_Explode    : spr:=@spr_explode[t div 8];   //4
eid_blood      : begin spr:=@spr_blood[t div 7]; inc(y,1); end;   //2

mid_MBullet,
mid_Bullet,
mid_SBullet    : spr:=@spr_u_p1[3-(t div 8)];

mid_rocket,
mid_granade    : spr:=@spr_explode[t div 8];
mid_Imp        : spr:=@spr_h_p0[3-(t div 8)];
mid_Caco       : spr:=@spr_h_p1[3-(t div 8)];
mid_Baron      : spr:=@spr_h_p2[3-(t div 8)];
mid_plasma     : spr:=@spr_u_p0[5-(t div 5)];
mid_bfg        : spr:=@spr_u_p2[5-(t div 8)];

UID_LostSoul   : spr:=@spr_h_u0[28-(t div 8)];
UID_Imp        : spr:=@spr_h_u1[52-(t div 8)];
UID_Demon      : spr:=@spr_h_u2[53-(t div 8)];
UID_Cacodemon  : begin spr:=@spr_h_u3[29-(t div 8)]; if(t>20)then inc(y,2); d:=y; end;
UID_Baron      : spr:=@spr_h_u4[52-(t div 8)];
UID_Cyberdemon : spr:=@spr_h_u5[56-(t div 9)];
UID_Mastermind : spr:=@spr_h_u6[81-(t div 18)];
UID_Medic      : spr:=@spr_u_u0[52-(t div 8)];
UID_Engineer   : spr:=@spr_u_u1[44-(t div 8)];
UID_Sergant    : spr:=@spr_u_u2[44-(t div 8)];
UID_Commando   : spr:=@spr_u_u3[52-(t div 8)];
UID_Bomber     : spr:=@spr_u_u4[44-(t div 8)];
UID_Major      : spr:=@spr_u_u5[44-(t div 8)];
UID_BFG        : spr:=@spr_u_u6[44-(t div 8)];
UID_ZFormer    : spr:=@spr_h_z0[52-(t div 8)];
UID_ZSergant   : spr:=@spr_h_z1[52-(t div 8)];
UID_ZCommando  : spr:=@spr_h_z2[59-(t div 8)];
UID_ZBomber    : spr:=@spr_h_z3[52-(t div 8)];
UID_ZBFG       : spr:=@spr_h_z5[52-(t div 8)];

eid_db_h0      : spr:=@spr_db_h0;
eid_db_h1      : spr:=@spr_db_h1;
eid_db_u0      : spr:=@spr_db_u0;
eid_db_u1      : spr:=@spr_db_u1;
eid_hbar       : begin
                    spr:=@spr_b[r_uac,1,3];
                    alpha:=t shl 1;
                 end;
        else
          spr:=@spr_dum;
        end;

        if(t2<64)then
         if(e in whdead)then
          alpha:=t2 shl 2;

        if((vid_vx+vid_panel-spr^.hw)<x)and(x<(vid_vx+vid_mw+spr^.hw))and
          ((vid_vy-spr^.hh)          <y)and(y<(vid_vy+vid_mh+spr^.hh))then
          _sprb_add(spr^.surf,x-spr^.hw,y-spr^.hh,d,0,0,0,#0,alpha,false,0,0,0);

        if(t>0)
        then dec(t,1)
        else
          if(t2>0)then dec(t2,1);
     end;
end;



