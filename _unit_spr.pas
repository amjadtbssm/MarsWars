

procedure _unit_sprite(u:integer);
var td,an:byte;
begin
   with _units[u] do
   with _players[player] do
   begin

      spr:=@spr_dum;

      case ucl of
UID_UACSPort : spr:=@spr_sport[order];
UID_UACPortal: spr:=@spr_u_portal;
UID_UACBase0 : spr:=@spr_u_base[0];
UID_UACBase1 : spr:=@spr_u_base[1];
UID_UACBase2 : spr:=@spr_u_base[2];
UID_UACBase3 : spr:=@spr_u_base[3];
UID_UACBase4 : spr:=@spr_u_base[4];
UID_UACBase5 : spr:=@spr_u_base[5];
UID_HellBarracks : spr:=@spr_hbarrak;
UID_HellAltar: spr:=@spr_h_altar;
UID_HellFortess: spr:=@spr_h_fortes;
UID_Mine     : spr:=@spr_mine;
UID_Build    : spr:=@spr_build[order];
UID_InvBase  : spr:=@spr_dum;
UID_Marker   : spr:=@spr_dum;


UID_FAPC:
       begin
          td:=((dir+12) mod 360) div 23;

          an:=td;

          spr:=@spr_u_u7[an];
       end;


UID_ZFormer:
      begin
         td:=((dir+23) mod 360) div 45;
         if(paint>0)
         then an:=40+td
         else
          if(rld>urlda[r_hell,0])
          then an:=32+td
          else
            if (not wanim)
            then an:=td*4
            else
              begin
                 inc(anim,14);
                 anim:=anim mod 400;
                 an:=4*td+(anim div 100);
              end;

         spr:=@spr_h_z0[an];
      end;

UID_ZSergant:
      begin
         td:=((dir+23) mod 360) div 45;
         if(paint>0)
         then an:=40+td
         else
          if(rld>urlda[r_hell,utp])
          then an:=32+td
          else
            if (not wanim)
            then an:=td*4
            else
              begin
                 inc(anim,14);
                 anim:=anim mod 400;
                 an:=4*td+(anim div 100);
              end;

         spr:=@spr_h_z1[an];
      end;

UID_LostSoul:
      begin
         td:=((dir+23) mod 360) div 45;
         an:=0;
         if(paint>0)
         then an:=16
         else if (wanim)or(rld>urlda[r_hell,utp]) then an:=8;

         spr:=@spr_h_u0[td+an];
      end;

UID_Imp:
       begin
          td:=((dir+23) mod 360) div 45;
          if(paint>0)
          then an:=40+td
          else
           if(rld>urlda[r_hell,utp])
           then an:=32+td
           else
             if (not wanim)
             then an:=td*4
             else
               begin
                  inc(anim,11);
                  anim:=anim mod 400;
                  an:=4*td+(anim div 100);
               end;

          spr:=@spr_h_u1[an];
       end;

UID_Demon:
       begin
          td:=((dir+23) mod 360) div 45;
          if(paint>0)
          then an:=40+td
          else
           if(rld>urlda[r_hell,utp])
           then an:=32+td
           else
             if (not wanim)
             then an:=td*4
             else
               begin
                  inc(anim,15);
                  anim:=anim mod 400;
                  an:=4*td+(anim div 100);
               end;

          spr:=@spr_h_u2[an];
       end;

UID_Cacodemon:
       begin
          td:=((dir+23) mod 360) div 45;
          if(paint>0)
          then an:=16+td
          else
            if(rld>urlda[r_hell,utp])
            then an:=8+td
            else an:=td;

          spr:=@spr_h_u3[an];
       end;

UID_Baron:
       begin
          td:=((dir+23) mod 360) div 45;
          if(paint>0)
          then an:=40+td
          else
            if(rld>urlda[r_hell,utp])
            then an:=32+td
            else
              if (not wanim)
              then an:=td*4
              else
                begin
                   inc(anim,11);
                   anim:=anim mod 400;
                   an:=4*td+(anim div 100);
                end;

          spr:=@spr_h_u4[an];
       end;


UID_Mastermind:
       begin
          td:=((dir+23) mod 360) div 45;
          if(paint>0)
          then an:=64+td
          else
            if(rld>0)
            then an:=48+(td*2)+ (rld div urlda[r_hell,6])
            else
              if (not wanim)
              then an:=td*6
              else
                begin
                   inc(anim,10);
                   anim:=anim mod 600;
                   an:=6*td+(anim div 100);
                end;

          spr:=@spr_h_u6[an];
       end;

UID_Cyberdemon:
       begin
          td:=((dir+23) mod 360) div 45;
          if(paint>0)
          then an:=40+td
          else
            if(rld>urlda[r_hell,utp])
            then an:=32+td
            else
              if (not wanim)
              then an:=td*4
              else
                begin
                   inc(anim,10);
                   anim:=anim mod 400;
                   an:=4*td+(anim div 100);
                end;

          spr:=@spr_h_u5[an];
       end;


       // UAC

UID_Engineer:
              begin
                 td:=((dir+23) mod 360) div 45;

                 if(rld>urlda[r_uac,utp])
                 then an:=32+td
                 else
                   if (not wanim)or(paint>0)
                   then an:=td*4
                   else
                     begin
                        inc(anim,17);
                        anim:=anim mod 400;
                        an:=4*td+(anim div 100);
                     end;

                 spr:=@spr_u_u1[an];
              end;

UID_Medic:
       begin
          td:=((dir+23) mod 360) div 45;

          if(rld>urlda[r_uac,utp])
          then if(melee)then an:=40+td else an:=32+td
          else
            if (not wanim)or(paint>0)
            then an:=td*4
            else
              begin
                 inc(anim,17);
                 anim:=anim mod 400;
                 an:=4*td+(anim div 100);
              end;

          spr:=@spr_u_u0[an];
       end;

UID_Sergant:
       begin
          td:=((dir+23) mod 360) div 45;

          if(rld>urlda[r_uac,utp])
          then an:=32+td
          else
            if (not wanim)or(paint>0)
            then an:=td*4
            else
              begin
                 inc(anim,17);
                 anim:=anim mod 400;
                 an:=4*td+(anim div 100);
              end;

          spr:=@spr_u_u2[an];
       end;

UID_Commando:
       begin
          td:=((dir+23) mod 360) div 45;

          if(rld>0)
          then if (rld>urlda[r_uac,utp])
               then an:=32+td
               else an:=40+td
          else
            if (not wanim)or(paint>0)
            then an:=td*4
            else
              begin
                 inc(anim,14);
                 anim:=anim mod 400;
                 an:=4*td+(anim div 100);
              end;

          spr:=@spr_u_u3[an];
       end;

UID_Bomber:
       begin
          td:=((dir+23) mod 360) div 45;

          if(rld>urlda[r_uac,utp])
          then an:=32+td
          else
            if (not wanim)or(paint>0)
            then an:=td*4
            else
              begin
                 inc(anim,13);
                 anim:=anim mod 400;
                 an:=4*td+(anim div 100);
              end;

          spr:=@spr_u_u4[an];
       end;

UID_Major:
       begin
          td:=((dir+23) mod 360) div 45;

          an:=0;
          if(rld>0) then an:=8;

          spr:=@spr_u_u5[an+td];
       end;

UID_BFG:
       begin
          td:=((dir+23) mod 360) div 45;

          if(rld>bfg_s_tick)
          then an:=32+td
          else
            if (not wanim)or(paint>0)
            then an:=td*4
            else
              begin
                 inc(anim,13);
                 anim:=anim mod 400;
                 an:=4*td+(anim div 100);
              end;

          spr:=@spr_u_u6[an];
       end;

UID_ZCommando:
       begin
          td:=((dir+23) mod 360) div 45;

          if(paint>0)
          then an:=48+td
          else
            if(rld>0)
            then if (rld>urlda[r_uac,ut_3])
                 then an:=32+td
                 else an:=40+td
            else
              if(not wanim)or(paint>0)
              then an:=td*4
              else
                begin
                   inc(anim,14);
                   anim:=anim mod 400;
                   an:=4*td+(anim div 100);
                end;

          spr:=@spr_h_z2[an];
       end;

UID_ZBomber:
       begin
          td:=((dir+23) mod 360) div 45;

          if(paint>0)
          then an:=40+td
          else
            if(rld>urlda[r_uac,ut_4])
            then an:=32+td
            else
              if (not wanim)or(paint>0)
              then an:=td*4
              else
                begin
                   inc(anim,13);
                   anim:=anim mod 400;
                   an:=4*td+(anim div 100);
                end;

          spr:=@spr_h_z3[an];
       end;

UID_ZFPlasma:
       begin
          td:=((dir+23) mod 360) div 45;

          an:=0;
          if(rld>0)and(paint=0) then an:=8;

          spr:=@spr_h_z4j[an+td];
       end;
UID_ZBFG:
       begin
          td:=((dir+23) mod 360) div 45;

          if(paint>0)
          then an:=40+td
          else
            if(rld>bfg_s_tick)
            then an:=32+td
            else
              if (not wanim)or(paint>0)
              then an:=td*4
              else
                begin
                   inc(anim,13);
                   anim:=anim mod 400;
                   an:=4*td+(anim div 100);
                end;

          spr:=@spr_h_z5[an];
       end;

      else

      if(isbuild)then
       if(bld)
       then spr:=@spr_b[race,utp,3]
       else spr:=@spr_b[race,utp,(hits*3) div mhits];

      end;

   end;
end;


