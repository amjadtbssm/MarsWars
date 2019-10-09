


procedure _unit_sclass(u:integer);
begin
   with _units[u] do
   begin

      utp     := ut_0;
      generg  := 0;
      painc   := 0;
      isbuild := false;
      invis   := 0;
      detect  := 0;
      radar   := false;
      teleport:= false;
      shadow  := true;
      dsbl    := false;
      solid   := true;
      mmr     := 0;
      invuln  := false;
      apcs    := 1;
      apcm    := 0;
      bio     := true;

      ////////////// CAMPAINGS

      if(ucl=UID_Build) then
      begin
         mhits  := 5000;
         r      := 110;
         uf     := uf_ground;
         speed  := 0;
         sr     := 300;
         utp    := ut_7;
         isbuild:= true;
         generg := 1;
         shadow := false;
         order  := u mod 4;
         dsbl   := false;
      end;

      if(ucl=UID_HellBarracks) then
      begin
         mhits  := 1500;
         uf     := uf_ground;
         speed  := 0;
         sr     := 250;
         utp    := ut_7;
         r      := b_r[1];
         generg := 0;
         isbuild:=true;
         shadow :=false;
      end;

      if(ucl=UID_Marker) then
      begin
         mhits  := 32000;
         uf     := uf_ground;
         speed  := 0;
         sr     := 200;
         utp    := ut_7;
         r      := 10;
         generg := 1;
         isbuild:= true;
         shadow := false;
         solid  := false;
         invuln := true;
      end;

      if(ucl=UID_InvBase) then
      begin
         mhits  := 32000;
         uf     := uf_ground;
         speed  := 0;
         sr     := 0;
         utp    := ut_0;
         r      := 0;
         generg := 1;
         isbuild:= true;
         shadow := false;
         solid  := false;
         invuln := true;
      end;

      if(ucl in [UID_UACPortal,UID_UACSPort]) then
      begin
         mhits  := 5000;
         uf     := uf_ground;
         speed  := 0;
         sr     := 250;
         utp    := ut_7;
         r      := 150;
         generg := 1;
         isbuild:= true;
         shadow := false;
         solid  := false;
         invuln := true;
         if(ucl=UID_UACSPort) then
         begin
            order:=u mod 2;
            if(order=1)then solid:=true;
         end
         else invuln := false;
      end;
      if(ucl in [UID_UACBase0,UID_UACBase1,UID_UACBase3,UID_UACBase4,UID_UACBase5,UID_HellFortess]) then
      begin
         mhits  := 5000;
         uf     := uf_ground;
         speed  := 0;
         sr     := base_r;
         utp    := ut_0;
         r      := 90;
         generg := 2;
         isbuild:= true;
         shadow := false;
      end;
      if(ucl=UID_UACBase2) then
      begin
         mhits  := 1500;
         uf     := uf_ground;
         speed  := 0;
         sr     := 250;
         utp    := ut_2;
         r      := 60;
         generg := 2;
         isbuild:= true;
         shadow := false;
      end;

      if(ucl=UID_HellAltar) then
      begin
         mhits  := 1000;
         uf     := uf_ground;
         speed  := 0;
         sr     := 320;
         utp    := ut_6;
         r      := 60;
         isbuild:= true;
         shadow := false;
         detect := 1;
         generg := 2;
      end;

      // HELL

      if(ucl=UID_HellKeep) then
      begin
         mhits  := 3000;
         uf     := uf_ground;
         speed  := 0;
         sr     := base_r;
         utp    := ut_0;
         r      := b_r[utp];
         generg := 2;
         isbuild:=true;
         shadow :=false;
      end;

      if(ucl=UID_HellGate) then
      begin
         mhits  := 1500;
         uf     := uf_ground;
         speed  := 0;
         sr     := 250;
         utp    := ut_1;
         r      := b_r[utp];
         generg := 0;
         isbuild:=true;
         shadow :=false;
      end;

      if(ucl=UID_HellSymbol) then
      begin
         mhits  := 700;
         uf     := uf_ground;
         speed  := 0;
         sr     := 250;
         utp    := ut_2;
         r      := b_r[utp];
         generg := 1;
         isbuild:=true;
         shadow :=false;
      end;

      if(ucl=UID_HellPool) then
      begin
         mhits  := 1500;
         uf     := uf_ground;
         speed  := 0;
         sr     := 250;
         utp    := ut_3;
         r      := b_r[utp];
         generg := 0;
         isbuild:=true;
         shadow :=false;
      end;

      if(ucl=UID_HellTower) then
      begin
         mhits  := 500;
         uf     := uf_ground;
         speed  := 0;
         sr     := def_r;
         utp    := ut_4;
         r      := b_r[utp];
         generg := 0;
         isbuild:= true;
         shadow := false;
      end;

      if(ucl=UID_HellTeleport) then
      begin
         mhits   := 500;
         uf      := uf_ground;
         speed   := 0;
         sr      := teleport_md;
         utp     := ut_5;
         r       := b_r[utp];
         generg  := 0;
         isbuild := true;
         teleport:= true;
         shadow  := false;
         solid   := false;
      end;

      if(ucl=UID_LostSoul) then
      begin
         mhits  := 90;
         r      := 12;
         uf     := uf_soaring;
         speed  := 22;
         sr     := 270;
         utp    := ut_0;
         painc  := 4;
      end;

      if(ucl=UID_Imp) then
      begin
         mhits  := 70;
         r      := 12;
         uf     := uf_ground;
         speed  := 8;
         sr     := 250;
         utp    := ut_1;
         painc  := 3;
      end;

      if(ucl=UID_Demon) then
      begin
         mhits  := 150;
         r      := 13;
         uf     := uf_ground;
         speed  := 12;
         sr     := 220;
         utp    := ut_2;
         painc  := 8;
      end;

      if(ucl=UID_CacoDemon) then
      begin
         mhits  := 180;
         r      := 15;
         uf     := uf_fly;
         speed  := 8;
         sr     := 255;
         utp    := ut_3;
         painc  := 8;
      end;

      if(ucl=UID_Baron) then
      begin
         mhits  := 530;
         r      := 13;
         uf     := uf_ground;
         speed  := 8;
         sr     := 220;
         utp    := ut_4;
         painc  := 9;
      end;

      if(ucl=UID_Cyberdemon) then
       begin
          mhits  := 1700;
          r      := 20;
          uf     := uf_ground;
          speed  := 9;
          sr     := 260;
          utp    := ut_5;
          painc  := 12;
       end;

      if(ucl=UID_Mastermind) then
       begin
          mhits  := 1700;
          r      := 35;
          uf     := uf_ground;
          speed  := 9;
          sr     := 260;
          utp    := ut_6;
          painc  := 9;
          detect := 1;
       end;

      // UAC

      if(ucl=UID_UACComCenter) then
      begin
         mhits  := 3000;
         uf     := uf_ground;
         speed  := 0;
         sr     := base_r;
         utp    := ut_0;
         r      := b_r[utp];
         generg := 2;
         isbuild:= true;
         shadow := false;
      end;

      if(ucl=UID_UACBarracks) then
      begin
         mhits  := 1500;
         uf     := uf_ground;
         speed  := 0;
         sr     := 250;
         utp    := ut_1;
         r      := b_r[utp];
         generg := 0;
         isbuild:=true;
         shadow :=false;
      end;

      if(ucl=UID_UACGenerator) then
      begin
         mhits  := 700;
         uf     := uf_ground;
         speed  := 0;
         sr     := 250;
         utp    := ut_2;
         r      := b_r[utp];
         generg := 1;
         isbuild:=true;
         shadow :=false;
      end;

      if(ucl=UID_UACResCenter) then
      begin
         mhits  := 1500;
         uf     := uf_ground;
         speed  := 0;
         sr     := 250;
         utp    := ut_3;
         r      := b_r[utp];
         generg := 0;
         isbuild:=true;
         shadow :=false;
      end;

      if(ucl=UID_UACTurret) then
      begin
         mhits  := 500;
         uf     := uf_ground;
         speed  := 0;
         sr     := def_r;
         utp    := ut_4;
         r      := b_r[utp];
         generg := 0;
         isbuild:= true;
         shadow := false;
      end;

      if(ucl=UID_UACRadar) then
      begin
         mhits  := 500;
         uf     := uf_ground;
         speed  := 0;
         sr     := 250;
         utp    := ut_5;
         r      := b_r[utp];
         generg := 0;
         isbuild:= true;
         radar  := true;
         shadow := false;
         detect := 2;
      end;

      if(ucl=UID_Engineer)or(ucl=UID_ZFormer)then
      begin
         mhits  := 95;
         r      := 12;
         uf     := uf_ground;
         speed  := 12;
         sr := 265;
         utp    := ut_0;
         if(ucl=UID_ZFormer)then
         begin
            painc  := 2;
            utp    := ut_7;
            speed  := 10;
            sr     := 250;
         end;
      end;

      if(ucl=UID_Medic) then
      begin
         mhits  := 95;
         r      := 12;
         uf     := uf_ground;
         speed  := 12;
         sr     := 230;
         utp    := ut_1;
      end;

      if(ucl=UID_Sergant)or(ucl=UID_ZSergant) then
      begin
         mhits  := 95;
         r      := 12;
         uf     := uf_ground;
         speed  := 12;
         sr     := 240;
         utp    := ut_2;
         if(ucl=UID_ZSergant)then
         begin
            painc  := 2;
            utp    := ut_7;
            speed  := 10;
         end;
      end;

      if(ucl=UID_Commando)or(ucl=UID_ZCommando) then
      begin
         mhits  := 95;
         r      := 12;
         uf     := uf_ground;
         speed  := 10;
         sr     := 260;
         utp    := ut_3;
         if(ucl=UID_ZCommando)then
         begin
            painc  := 2;
            utp    := ut_7;
            sr     := 250;
         end;
      end;

      if(ucl=UID_Bomber)or(ucl=UID_ZBomber) then
      begin
         mhits  := 95;
         r      := 12;
         uf     := uf_ground;
         speed  := 9;
         sr     := 295;
         utp    := ut_4;
         if(ucl=UID_ZBomber)then
         begin
            painc  := 2;
            utp    := ut_7;
            sr     := 260;
         end;
      end;

      if(ucl=UID_Major)or(ucl=UID_ZFPlasma)then
      begin
         mhits  := 95;
         r      := 12;
         uf     := uf_fly;
         speed  := 14;
         sr     := 260;
         utp    := ut_5;
         if(ucl=UID_ZFPlasma)then
         begin
            painc  := 2;
            utp    := ut_7;
            sr     := 250;
         end;
      end;

      if(ucl=UID_BFG)or(ucl=UID_ZBFG) then
      begin
         mhits  := 95;
         r      := 12;
         uf     := uf_ground;
         speed  := 9;
         sr     := 260;
         utp    := ut_6;
         if(ucl=UID_ZBFG)then
         begin
            painc  := 2;
            utp    := ut_7;
            sr     := 250;
         end;
      end;

      if(ucl=UID_Mine) then
      begin
         mhits  := 1;
         r      := 5;
         uf     := uf_ground;
         speed  := 0;
         sr     := 100;
         utp    := ut_6;
         isbuild:= true;
         invis  := 2;
         detect := 0;
         solid  := false;
      end;

      if(ucl=UID_FAPC)then
      begin
         mhits  := 200;
         r      := 33;
         uf     := uf_fly;
         speed  := 22;
         sr     := 260;
         utp    := ut_7;
         apcm   := 10;
         bio    := false;
      end;

      if(isbuild)then
      begin
         mmr:=trunc(r*map_mmcx);
         if(utp=ut_1)then inc(my,b_r[utp]);
         bio    := false;
      end;
      pains:=painc;
      fr:=(sr+fog_cw) div fog_cw;
      if(fr>MFogM)then fr:=MFogM;
      if(onlySVCode)then hits:=mhits

     // hits:=hits div 2;
   end;
end;







