
procedure ai_trybuild(x,y,r:integer;bp:byte);
const
  Com = 0;
  Bar = 1;
  Gen = 2;
  Smt = 3;
  Tw1 = 4;
  Adv = 6;
  Tw2 = 7;
  X8  = 8;

var d:single;
    l:integer;
   bt:byte;
ai_menrg:byte;

procedure set_bld(ucl,cnt:byte);
begin
   if(ucl=Gen)then
    with _players[bp] do
    begin
       if(race=r_hell)and(upgr[upgr_hsymbol]>0)then cnt:=(cnt div 2);
       if(race=r_uac)then cnt:=(cnt div 2);
       if(menerg>=ai_menrg)then exit;
    end;
   if(_bldCndt(bp,ucl)=false)then
    if(_players[bp].u_e[true,ucl]<cnt)then bt:=ucl;
end;

begin
   bt:=random(9);

   if(g_mode<>gm_coop)or(bp<>0)then
   with _players[bp] do
   begin
      case ai_skill of
      0 : ai_menrg:=2;
      1 : ai_menrg:=5;
      2 : ai_menrg:=8;
      3 : ai_menrg:=10;
      4 : ai_menrg:=13;
      5,
      6 : ai_menrg:=14;
      else ai_menrg:=12;
      end;

      l:=u_e[true,Tw1]+u_e[true,Tw2];
      if(ai_skill>1)then
      begin
         if(ai_skill>3)then
         begin
            set_bld(Tw1,2);
            set_bld(Bar,6);
            if(race=r_hell)
            then set_bld(Gen,7)
            else set_bld(Gen,6);
            if(G_onebase)then
            begin
               set_bld(Adv,1);
               set_bld(Smt,1);
               set_bld(Gen,5);
            end
            else set_bld(Com,2);
            set_bld(Gen,4);
            if(ai_skill>4)then set_bld(Tw1,2);
         end;
         set_bld(Bar,2);
         set_bld(Gen,2);
         set_bld(Bar,1);
         set_bld(Gen,1);
         if(race=r_uac)and(ai_skill>3)then set_bld(Bar,1);
      end;
      set_bld(Gen,1);

      case bt of
      Com : case race of
            r_hell : if(u_e[true,Com]>3)or(menerg>=ai_menrg)then exit;
            r_uac  : if(upgr[upgr_mainm]>0)then
                     begin
                        if(u_e[true,Com]>4)then exit;
                     end
                     else
                       if(u_e[true,Com]>3)or(menerg>=ai_menrg)then exit;
            end;
      Bar : if(u_e[true,Bar]>=ai_menrg)or(u_e[true,Bar]>=menerg)then exit;
      Gen : if(menerg>=ai_menrg)then exit;
      Smt : case menerg of
            0..14 : if(u_e[true,Smt]>1)then exit;
            else
               if(u_e[true,Smt]>2)then exit;
            end;
      Tw1,
      Tw2 : if(l>=18)then exit;
      X8  : if(race=r_hell)and(u_e[true,X8]>ai_skill)then exit;
      end;
   end;

   d:=random(360)*degtorad;
   l:=100+random(r-100);
   x:=x+trunc(l*cos(d));
   y:=y-trunc(l*sin(d));

   _unit_startb(x,y,bt,bp);
end;

procedure ai_utr(u,m:integer);
begin
   with _units[u] do
   with _players[player] do
   if(u_c[false]<ai_maxarmy)then
   begin
      case m of
0:    if(ubx[1]=u)
      then ai_utr(u,1)   // choose
      else
        if(map_ffly)and(g_mode<>gm_inv)
        then ai_utr(u,2)
        else ai_utr(u,3);
1:    if(u_c[false]<10)or(ai_skill<2) // u1
      then ai_utr(u,3)
      else
        case race of
         r_hell :  begin
                      if(u_e[false,5]<1 )then _unit_straining(u,5);//cyb
                      if(u_e[false,6]<1 )then _unit_straining(u,6);//mind
                      if(u_e[false,8]<10)then _unit_straining(u,8);//rev
                      if(rld=0)then
                       if(map_ffly)
                       then ai_utr(u,2)
                       else ai_utr(u,3);
                   end;

         r_uac  :  begin
                      if(u_e[false,0]<5)then _unit_straining(u,0);
                      if(u_e[false,7]<map_ffly_fapc[map_ffly])then _unit_straining(u,7);
                      if(ai_skill>2)then
                       case g_addon of
                        false: if(u_e[false,8]<7 )then _unit_straining(u,8);
                        true : if(u_e[false,8]<4 )then _unit_straining(u,8);
                       end;
                      if(rld=0)then
                       if(map_ffly)
                       then ai_utr(u,2)
                       else ai_utr(u,3);
                   end;
        end;
2: // fly
        case race of
         r_hell : if(u_c[false]<20)
                  then ai_utr(u,3)
                  else
                    case random(3) of
                    0 : _unit_straining(u,0);
                    1 : _unit_straining(u,3);
                    2 : if(u_e[false,7]<7)
                        then _unit_straining(u,7)
                        else _unit_straining(u,0);
                    end;
         r_uac  :  ai_utr(u,3);
        end;

3:   if(u_c[false]<10)               // default
     then _unit_straining(u,random(3))
     else
       case race of
       r_hell : begin
                   m:=random(21);
                   if(alrm_r<base_r)
                   then m:=random(2)
                   else
                     if(u_e[false,8]<5)then _unit_straining(u,8);
                   case m of
                    7 : if(u_e[false,7]<6)
                        then _unit_straining(u,7)
                        else ai_utr(u,3);
                   else
                    _unit_straining(u,m);
                   end;
                end;
       r_uac  : if(alrm_r<base_r)
                then _unit_straining(u,random(4))
                else
                begin
                   if(g_addon=false)then
                   begin
                      if(u_c[false]>20)then
                       if(u_e[false,5]<10)then _unit_straining(u,5);
                      _unit_straining(u,random(7));
                   end
                   else
                     if(random(2)=0)
                     then _unit_straining(u,random(7))
                     else _unit_straining(u,9+random(3));
                end;
       end;

      end;
   end;
end;

procedure ai_useteleport(u:integer);
var tu:PTUnit;
    ust,
    u2t:integer;
begin
   with _units[u] do
    with _players[player] do
     if(ubx[5]>0)then
     begin
        tu:=@_units[ubx[5]];

        u2t:=dist2(x,y,tu^.x,tu^.y)+1;

        if(tu^.buff[ub_advanced]>0)and(tu^.rld=0)and(u2t>base_r)and(alrm_r<32000)and(alrm_r>base_rr)then
         if(tu^.alrm_r<base_rr)then
         begin
            _unit_teleport(u,tu^.x,tu^.y);
            _teleport_rld(tu,mhits);
            exit;
         end;

        if(alrm_r<base_rr)then exit;

        if(u2t<base_ir)then
         if(order=2)or(alrm_b)then
         begin
            ust:=alrm_r;

            inc(ust,upgr[upgr_5bld]*150);

            if(map_ffly=false)then ust:=ust div 2;
            if(uf>uf_ground)then ust:=ust div 3;
            if(g_mode=gm_ct)then ust:=ust*3;
            if(ucl<3)
            then ust:=60
            else ust:=ust div 280;

            if(_uclord>ust)then exit;

            uo_x:=tu^.x;
            uo_y:=tu^.y;
            if(u2t<tu^.r)and(tu^.rld=0)then
            begin
               if(alrm_x>0)
               then _unit_teleport(u,alrm_x-base_r+random(base_rr),alrm_y-base_r+random(base_rr))
               else _unit_teleport(u,tu^.uo_x,tu^.uo_y);
               _teleport_rld(tu,mhits);
            end;
         end;
     end;
end;

