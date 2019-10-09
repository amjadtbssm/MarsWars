

procedure _unit_sclass(u:PTUnit);
begin
   with u^ do
   begin
      ucl     := 0;
      generg  := 0;
      isbuild := false;
      apcs    := 1;
      apcm    := 0;
      mech    := false;
      mmr     := 0;
      shadow  := 0;
      painc   := 0;
      rld_a   := 0;
      rld_r   := 0;
      solid   := true;
      max     := 255;
      mhits   := 100;
      speed   := 0;
      anims   := 0;
      trt     := 0;
      bld_s   := 18;
      mdmg    := 5;

      if(uid=UID_LostSoul)then
      begin
         mhits  := 70;
         r      := 10;
         uf     := uf_soaring;
         speed  := 23;
         sr     := 300;
         ucl    := 0;
         painc  := 3;
         rld_r  := 60;
         rld_a  := 20;
         trt    := vid_fps*5;
         mdmg   := 15;
      end;
      if(uid=UID_Imp) then
      begin
         mhits  := 70;
         r      := 12;
         uf     := uf_ground;
         speed  := 8;
         sr     := 260;
         ucl    := 1;
         painc  := 3;
         rld_r  := 65;
         rld_a  := 30;
         anims  := 11;
         trt    := vid_fps*5;
         mdmg   := 20;
      end;
      if(uid=UID_Demon) then
      begin
         mhits  := 150;
         r      := 13;
         uf     := uf_ground;
         speed  := 14;
         sr     := 220;
         ucl    := 2;
         painc  := 8;
         rld_r  := 50;
         rld_a  := 25;
         anims  := 14;
         trt    := vid_fps*10;
         mdmg   := 40;
      end;
      if(uid=UID_CacoDemon)then
      begin
         mhits  := 200;
         r      := 14;
         uf     := uf_fly;
         speed  := 8;
         sr     := 260;
         ucl    := 3;
         painc  := 6;
         rld_r  := 75;
         rld_a  := 45;
         trt    := vid_fps*20;
         mdmg   := 30;
      end;
      if(uid=UID_Baron)then
      begin
         mhits  := 300;
         r      := 13;
         uf     := uf_ground;
         speed  := 8;
         sr     := 230;
         ucl    := 4;
         painc  := 4;
         rld_r  := 71;
         rld_a  := 45;
         anims  := 11;
         trt    := vid_fps*40;
         mdmg   := 45;
      end;
      if(uid=UID_Cyberdemon)then
      begin
         mhits  := 1800;
         r      := 20;
         uf     := uf_ground;
         speed  := 9;
         sr     := 260;
         ucl    := 5;
         painc  := 13;
         rld_r  := 65;
         rld_a  := 55;
         anims  := 10;
         trt    := vid_fps*120;
         max    := 1;
      end;
      if(uid=UID_Mastermind) then
      begin
         mhits  := 1800;
         r      := 35;
         uf     := uf_ground;
         speed  := 9;
         sr     := 260;
         ucl    := 6;
         painc  := 13;
         rld_r  := 9;
         rld_a  := 5;
         anims  := 10;
         trt    := vid_fps*90;
         max    := 1;
      end;
      if(uid=UID_Pain)then
      begin
         mhits  := 170;
         r      := 15;
         uf     := uf_fly;
         speed  := 8;
         sr     := 310;
         ucl    := 7;
         painc  := 3;
         rld_r  := 95;
         rld_a  := 70;
         anims  := 6;
         trt    := vid_fps*60;
      end;
      if(uid=UID_Revenant) then
      begin
         mhits  := 210;
         r      := 15;
         uf     := uf_ground;
         speed  := 11;
         sr     := 260;
         ucl    := 8;
         painc  := 7;
         rld_r  := 70;
         rld_a  := 45;
         anims  := 14;
         trt    := vid_fps*60;
         mdmg   := 35;
      end;
      if(uid=UID_Mancubus) then
      begin
         mhits  := 325;
         r      := 20;
         uf     := uf_ground;
         speed  := 5;
         sr     := 280;
         ucl    := 9;
         painc  := 6;
         rld_r  := 150;
         anims  := 9;
         trt    := vid_fps*60;
      end;
      if(uid=UID_Arachnotron) then
      begin
         mhits  := 300;
         r      := 20;
         uf     := uf_ground;
         speed  := 8;
         sr     := 280;
         ucl    := 10;
         painc  := 4;
         rld_r  := 15;
         anims  := 10;
         trt    := vid_fps*60;
      end;
      if(uid=UID_ArchVile) then
      begin
         mhits  := 300;
         r      := 15;
         uf     := uf_ground;
         speed  := 14;
         sr     := 330;
         ucl    := 11;
         painc  := 12;
         rld_r  := 140;
         rld_a  := 65;
         anims  := 15;
         trt    := vid_fps*75;
      end;

      if(uid=UID_HKeep)then
      begin
         mhits  := 3000;
         uf     := uf_ground;
         sr     := base_r;
         ucl    := 0;
         r      := 66;
         generg := 2;
         isbuild:= true;
      end;
      if(uid in [UID_HGate,UID_HMilitaryUnit]) then
      begin
         mhits  := 1500;
         uf     := uf_ground;
         sr     := 200;
         ucl    := 1;
         if(uid=UID_HMilitaryUnit)
         then r      := 70
         else r      := 60;
         generg := 0;
         isbuild:= true;
         rld_a  := 12;
         bld_s  := 20;
      end;
      if(uid=UID_HSymbol) then
      begin
         mhits  := 300;
         uf     := uf_ground;
         sr     := 200;
         ucl    := 2;
         r      := 25;
         generg := 1;
         isbuild:= true;
         bld_s  := 8;
      end;
      if(uid=UID_HPools) then
      begin
         mhits  := 1000;
         uf     := uf_ground;
         sr     := 200;
         ucl    := 3;
         r      := 55;
         generg := 0;
         isbuild:= true;
         //max    := 1;
         bld_s  := 10;
      end;
      if(uid=UID_HTower) then
      begin
         mhits  := 600;
         uf     := uf_ground;
         sr     := 260;
         ucl    := 4;
         r      := 22;
         generg := 0;
         isbuild:= true;
         rld_r  := 40;
         bld_s  := 14;
      end;
      if(uid=UID_HTeleport) then
      begin
         mhits  := 500;
         uf     := uf_ground;
         sr     := 200;
         ucl    := 5;
         r      := 30;
         generg := 0;
         isbuild:= true;
         solid  := false;
         max    := 1;
         bld_s  := 10;
      end;
      if(uid=UID_HMonastery)then
      begin
         mhits  := 1000;
         uf     := uf_ground;
         sr     := 200;
         ucl    := 6;
         r      := 65;
         isbuild:= true;
         max    := 1;
         bld_s  := 5;
      end;
      if(uid=UID_HTotem) then
      begin
         mhits  := 500;
         uf     := uf_ground;
         sr     := 260;
         ucl    := 7;
         r      := 22;
         generg := 0;
         isbuild:= true;
         bld_s  := 10;
         buff[ub_invis]:=255;
         rld_r  := 140;
         rld_a  := 65;
      end;
      if(uid=UID_HAltar) then
      begin
         mhits  := 1000;
         uf     := uf_ground;
         sr     := 350;
         ucl    := 8;
         r      := 50;
         bld_s  := 33;
         isbuild:= true;
      end;

////////////////////////////////////////////////////////////////////////////////

      if(uid in [UID_Engineer,UID_ZFormer])then
      begin
         mhits  := 95;
         r      := 12;
         uf     := uf_ground;
         speed  := 12;
         sr     := 260;
         ucl    := 0;
         rld_r  := 35;
         rld_a  := 25;
         anims  := 17;
         trt    := vid_fps*6;
         mdmg   := 8;
         if(uid=UID_ZFormer)then
         begin
            painc  := 3;
            ucl    := 12;
            speed  := 10;
            anims  := 14;
            rld_a  := 22;
         end;
      end;
      if(uid=UID_Medic)then
      begin
         mhits  := 95;
         r      := 12;
         uf     := uf_ground;
         speed  := 12;
         sr     := 230;
         ucl    := 1;
         rld_r  := 40;
         rld_a  := 30;
         anims  := 17;
         trt    := vid_fps*6;
         mdmg   := 8;
      end;
      if(uid in [UID_Sergant,UID_ZSergant])then
      begin
         mhits  := 95;
         r      := 12;
         uf     := uf_ground;
         speed  := 12;
         sr     := 240;
         ucl    := 2;
         rld_r  := 65;
         rld_a  := 45;
         anims  := 17;
         trt    := vid_fps*10;
         if(uid=UID_ZSergant)then
         begin
            painc  := 3;
            ucl    := 12;
            speed  := 10;
            anims  := 14;
         end;
      end;
      if(uid in [UID_Commando,UID_ZCommando])then
      begin
         mhits  := 95;
         r      := 12;
         uf     := uf_ground;
         speed  := 10;
         sr     := 260;
         ucl    := 3;
         rld_r  := 7;
         rld_a  := 3;
         anims  := 14;
         trt    := vid_fps*15;
         if(uid=UID_ZCommando)then
         begin
            painc  := 3;
            ucl    := 12;
         end;
      end;
      if(uid in [UID_Bomber,UID_ZBomber])then
      begin
         mhits  := 95;
         r      := 12;
         uf     := uf_ground;
         speed  := 9;
         sr     := 260;
         ucl    := 4;
         rld_r  := 100;
         rld_a  := 80;
         anims  := 13;
         trt    := vid_fps*35;
         if(uid=UID_ZBomber)then
         begin
            painc  := 3;
            ucl    := 12;
         end;
      end;
      if(uid in [UID_Major,UID_ZMajor])then
      begin
         mhits  := 95;
         r      := 12;
         uf     := uf_ground;
         speed  := 9;
         sr     := 260;
         ucl    := 5;
         rld_r  := 16;
         rld_a  := 0;
         anims  := 13;
         trt    := vid_fps*25;
         if(uid=UID_ZMajor)then
         begin
            painc  := 3;
            ucl    := 12;
         end;
      end;
      if(uid in [UID_BFG,UID_ZBFG])then
      begin
         mhits  := 95;
         r      := 12;
         uf     := uf_ground;
         speed  := 9;
         sr     := 260;
         ucl    := 6;
         rld_r  := 150;
         rld_a  := 40;
         anims  := 13;
         trt    := vid_fps*70;
         if(uid=UID_ZBFG)then
         begin
            painc  := 3;
            ucl    := 12;
         end;
      end;
      if(uid=UID_FAPC)then
      begin
         mhits  := 250;
         r      := 33;
         uf     := uf_fly;
         speed  := 22;
         sr     := 260;
         ucl    := 7;
         mech   := true;
         apcm   := 10;
         trt    := vid_fps*25;
         rld_r  := 110;
      end;
      if(uid=UID_APC)then
      begin
         mhits  := 350;
         r      := 25;
         uf     := uf_ground;
         if(g_addon)
         then speed := 14
         else speed := 16;
         sr     := 280;
         ucl    := 8;
         mech   := true;
         apcm   := 4;
         apcs   := 8;
         anims  := 17;
         trt    := vid_fps*25;
      end;
      if(uid=UID_Terminator)then
      begin
         mhits  := 300;
         r      := 16;
         uf     := uf_ground;
         speed  := 11;
         sr     := 260;
         ucl    := 9;
         mech   := true;
         apcs   := 3;
         rld_r  := 7;
         rld_a  := 0;
         anims  := 13;
         trt    := vid_fps*100;
      end;
      if(uid=UID_Tank)then
      begin
         mhits  := 350;
         r      := 20;
         uf     := uf_ground;
         speed  := 10;
         sr     := 260;
         ucl    := 10;
         mech   := true;
         apcs   := 7;
         rld_r  := 110;
         rld_a  := 95;
         anims  := 17;
         trt    := vid_fps*130;
      end;
      if(uid=UID_Flyer)then
      begin
         mhits  := 225;
         r      := 18;
         uf     := uf_fly;
         speed  := 17;
         sr     := 260;
         ucl    := 11;
         mech   := true;
         rld_r  := 10;
         rld_a  := 5;
         trt    := vid_fps*100;
      end;

      if(uid=UID_UCommandCenter)then
      begin
         mhits  := 4000;
         uf     := uf_ground;
         sr     := base_r;
         ucl    := 0;
         r      := 66;
         generg := 3;
         isbuild:= true;
      end;
      if(uid=UID_UMilitaryUnit)then
      begin
         mhits  := 1700;
         uf     := uf_ground;
         sr     := 200;
         ucl    := 1;
         r      := 66;
         isbuild:= true;
         bld_s  := 18;
      end;
      if(uid=UID_UGenerator) then
      begin
         mhits  := 500;
         uf     := uf_ground;
         sr     := 200;
         ucl    := 2;
         r      := 42;
         generg := 2;
         isbuild:= true;
         bld_s  := 7;
      end;
      if(uid=UID_UWeaponFactory) then
      begin
         mhits  := 1700;
         uf     := uf_ground;
         sr     := 200;
         ucl    := 3;
         r      := 62;
         isbuild:= true;
         bld_s  := 15;
      end;
      if(uid=UID_UTurret) then
      begin
         mhits  := 400;
         uf     := uf_ground;
         sr     := 260;
         ucl    := 4;
         r      := 19;
         isbuild:= true;
         rld_r  := 6;
         rld_a  := 3;
         anims  := 3;
         bld_s  := 13;
      end;
      if(uid=UID_URadar) then
      begin
         mhits  := 500;
         uf     := uf_ground;
         sr     := 200;
         ucl    := 5;
         r      := 35;
         isbuild:= true;
         max    := 1;
         bld_s  := 10;
      end;
      if(uid=UID_UVehicleFactory) then
      begin
         mhits  := 1700;
         uf     := uf_ground;
         sr     := 200;
         ucl    := 6;
         r      := 62;
         isbuild:= true;
         max    := 1;
         bld_s  := 9;
      end;
      if(uid=UID_URTurret) then
      begin
         mhits  := 600;
         uf     := uf_ground;
         sr     := 260;
         ucl    := 7;
         r      := 19;
         isbuild:= true;
         rld_r  := 85;
         anims  := 2;
         bld_s  := 13;
      end;
      if(uid=UID_URocketL) then
      begin
         mhits  := 1000;
         uf     := uf_ground;
         speed  := 0;
         sr     := 200;
         ucl    := 8;
         r      := 40;
         isbuild:= true;
         max    := 1;
      end;
      if(uid=UID_Mine) then
      begin
         mhits  := 1;
         uf     := uf_ground;
         speed  := 0;
         sr     := 100;
         ucl    := 12;
         r      := 5;
         isbuild:= true;
         solid  := false;
         buff[ub_invis]:=255;
      end;

      if(uid=UID_UTransport)then
      begin
         mhits  := 700;
         r      := 35;
         uf     := uf_fly;
         speed  := 8;
         sr     := 260;
         ucl    := 21;
         mech   := true;
         apcm   := 30;
         trt    := vid_fps*90;
      end;

      if(uid=UID_USPort) then
      begin
         mhits  := 6000;
         r      := 110;
         uf     := uf_ground;
         speed  := 0;
         sr     := 300;
         ucl    := 0;
         isbuild:= true;
         generg := 1;
         anims  := (x+y) mod 2;
         rld_r  := vid_fps*180;
      end;

      if(uid=UID_UCBuild) then
      begin
         mhits  := 5000;
         r      := 110;
         uf     := uf_ground;
         speed  := 0;
         sr     := base_r;
         ucl    := 0;
         isbuild:= true;
         generg := 1;
         anims  := x mod 4;
      end;
      if(uid in [UID_UBaseMil,UID_UBaseCom,UID_UBaseRef,UID_UBaseNuc,UID_UBaseLab,UID_HFortress])then
      begin
         mhits  := 5000;
         uf     := uf_ground;
         sr     := base_r;
         ucl    := 0;
         r      := 88;
         generg := 2;
         isbuild:= true;
      end;
      if(uid=UID_UBaseGen) then
      begin
         mhits  := 2000;
         uf     := uf_ground;
         sr     := 200;
         ucl    := 2;
         r      := 60;
         generg := 2;
         isbuild:= true;
      end;

      if(uid=UID_Dron) then
      begin
         mhits  := 500;
         uf     := uf_soaring;
         speed  := 20;
         sr     := 300;
         ucl    := 18;
         r      := 13;
         trt    := vid_fps*100;
         mech   := true;
         buff[ub_detect]:=255;
         solid  := false;
      end;
      if(uid=UID_Octobrain)then
      begin
         mhits  := 1000;
         r      := 15;
         uf     := uf_soaring;
         speed  := 15;
         sr     := 260;
         ucl    := 19;
         painc  := 10;
         rld_r  := 120;
         rld_a  := 45;
         trt    := vid_fps*100;
         mdmg   := 35;
         solid  := false;
      end;
      if(uid=UID_Cyclope)then
      begin
         mhits  := 7000;
         r      := 30;
         uf     := uf_ground;
         speed  := 13;
         sr     := 260;
         ucl    := 20;
         painc  := 40;
         rld_r  := 20;
         rld_a  := 10;
         anims  := 9;
         trt    := vid_fps*100;
         max    := 1;
         solid  := false;
         buff[ub_detect]:=255;
      end;

      if(uid=UID_Portal)then
      begin
         mhits  := 10000;
         uf     := uf_ground;
         sr     := base_r;
         ucl    := 15;
         r      := 110;
         generg := 1;
         isbuild:= true;
         solid  := false;
         rld_a  := 0;
         rld_r  := vid_fps;
      end;

      if(isbuild)then
      begin
         mmr:=round(r*map_mmcx);
         if(ucl=1)then inc(uo_y,r+12);
         mech:= true;
      end
      else shadow:=1+(uf*fly_height);

      if(fog_cw>0)then
      begin
         fr:=(sr+fog_cw) div fog_cw;
         if(fr>MFogM)then fr:=MFogM;
      end;
      if(onlySVCode)then hits:=mhits;
   end;
end;

procedure initUnits;
var i:byte;
begin
   FillChar(_ulst,sizeof(_ulst),0);
   for i:=0 to 255 do
   begin
      _ulst[i].uid:=i;
      _unit_sclass(@_ulst[i]);
   end;
end;

