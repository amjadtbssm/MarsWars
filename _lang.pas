
procedure _mkHStr(tb,rc,ucl:byte;NAME,DESCR,REQ:string);
var enrg,TIME:string;
begin
   if(tb=1)then
   begin
      enrg:=b2s(_pne_r[rc,ucl]);
      TIME:=i2s(upgrade_time[rc ,ucl  ] div vid_fps);
   end
   else
     if(ucl<9)then
     begin
        enrg:=b2s(_pne_b[rc,ucl]);
        with _ulst[cl2uid[rc,true,ucl]] do TIME:=i2s(mhits div bld_s div 2);
     end
     else
     begin
        enrg:=b2s(_pne_u[rc,ucl-9]);
        with _ulst[cl2uid[rc,false,ucl-9]] do TIME:=b2s(trt div vid_fps);
     end;
   str_hint[tb,rc,ucl]:= NAME+' ('+#18+hot_keys[ucl]+#25+') ['+#16+TIME+#25+'] '+'{'+#19+enrg+#25+'}';
   if(tb=1)then str_hint[tb,rc,ucl]:=str_hint[tb,rc,ucl]+' x'+#17+b2s(upgrade_cnt[rc ,ucl ])+#25;
   str_hint[tb,rc,ucl]:=str_hint[tb,rc,ucl]+#11+DESCR+#11;
   if(REQ<>'')then
    if(_lng=false)
    then str_hint[tb,rc,ucl]:=str_hint[tb,rc,ucl]+#17+'Requirements: '+#25+REQ
    else str_hint[tb,rc,ucl]:=str_hint[tb,rc,ucl]+#17+'����������: '+#25+REQ;
end;

procedure lng_eng;
var t2str:string;
begin
   str_MMap              := 'MAP';
   str_MPlayers          := 'PLAYERS';
   str_MObjectives       := 'OBJECTIVES';
   str_menu_s1[ms1_sett] := 'SETTINGS';
   str_menu_s1[ms1_svld] := 'SAVE/LOAD';
   str_menu_s1[ms1_reps] := 'REPLAYS';
   str_menu_s2[ms2_camp] := 'CAMPAIGNS';
   str_menu_s2[ms2_scir] := 'SKIRMISH';
   str_menu_s2[ms2_mult] := 'MULTIPLAYER';
   str_reset[false]      := 'START';
   str_reset[true ]      := 'RESET';
   str_exit[false]       := 'EXIT';
   str_exit[true]        := 'BACK';
   str_m_liq             := 'Lakes: ';
   str_m_siz             := 'Size: ';
   str_m_obs             := 'Obstacles: x';
   str_map               := 'Map';
   str_players           := 'Players';
   str_mrandom           := 'Random map';
   str_sound             := 'SOUND VOLUME';
   str_musicvol          := 'Music';
   str_soundvol          := 'Sound';
   str_game              := 'GAME';
   str_scrollspd         := 'Scroll speed';
   str_mousescrl         := 'Mouse scroll:';
   str_fullscreen        := 'Windowed:';
   str_plname            := 'Player name';
   str_lng[true]         := 'RUS';
   str_lng[false]        := 'ENG';
   str_maction           := 'Right click';
   str_maction2[true ]   := #18+'Move'+#25;
   str_maction2[false]   := #17+'Move'+#25+'+'+#17+'attack'+#25;
   str_race[r_random]    := 'random';
   str_race[r_hell  ]    := #16+'HELL'+#25;
   str_race[r_uac   ]    := #18+'UAC'+#25;
   str_win               := 'VICTORY!';
   str_lose              := 'DEFEAT!';
   str_pause             := 'Pause';
   str_gsaved            := 'Game saved';
   str_repend            := 'Replay ended!';
   str_save              := 'Save';
   str_load              := 'Load';
   str_delete            := 'Delete';
   str_svld_errors[1]    := 'File not'+#13+'exists!';
   str_svld_errors[2]    := 'Can`t open'+#13+'file!';
   str_svld_errors[3]    := 'Wrong file'+#13+'size!';
   str_svld_errors[4]    := 'Wrong version!';
   str_time              := 'Time: ';
   str_menu              := 'Menu';
   str_player_def        := ' was terminated!';
   str_inv_time          := 'Wave #';
   str_inv_ml            := 'Monsters: ';
   str_play              := 'Play';
   str_replay            := 'RECORD';
   str_cmpdif            := 'Difficulty: ';
   str_waitsv            := 'Awaiting server...';
   str_goptions          := 'GAME OPTIONS';
   str_server            := 'SERVER';
   str_client            := 'CLIENT';
   str_chat              := 'CHAT';
   str_gaddon            := 'Game:';
   str_randoms           := 'Random skirmish';
   str_apply             := 'apply';
   str_plout             := ' left the game';

   str_loss              := 'Loss condition:';
   str_losst[0]          := 'no army';
   str_losst[1]          := 'no builders';
   str_losst[2]          := 'no energy';

   str_starta            := 'Starting base:';
   str_startat[0]        := '1 '+#19+'builder'+#25;
   str_startat[1]        := '1 '+#19+'builder'+#25+'+ 1 '+#18+'gen.'+#25;
   str_startat[2]        := '1 '+#19+'builder'+#25+'+ 2 '+#18+'gen.'+#25;
   str_startat[3]        := '1 '+#19+'b.'+#25+'+ 2 '+#18+'gen.'+#25+'+ 2 '+#17+'b.'+#25;

   str_onebase           := 'One builder:';

   str_pnua[0]           := #19+'smallest'+#25+'/'+#15+'worst' +#25;
   str_pnua[1]           := #18+'small'   +#25+'/'+#16+'poor'  +#25;
   str_pnua[2]           := #17+'medium'  +#25+'/'+#17+'medium'+#25;
   str_pnua[3]           := #16+'large'   +#25+'/'+#18+'good'  +#25;
   str_pnua[4]           := #15+'largest' +#25+'/'+#19+'best'  +#25;

   str_npnua[0]          := #15+'lowest' +#25;
   str_npnua[1]          := #16+'low'    +#25;
   str_npnua[2]          := #17+'average'+#25;
   str_npnua[3]          := #18+'high'   +#25;
   str_npnua[4]          := #19+'highest'+#25;

   str_cmpd[0]           := #19+'I`m too young to die'+#25;
   str_cmpd[1]           := #18+'Hey, not too rough'+#25;
   str_cmpd[2]           := #17+'Hurt me plenty'+#25;
   str_cmpd[3]           := #16+'Ultra-Violence'+#25;
   str_cmpd[4]           := #15+'Nightmare!'+#25;

   str_gmodet            := 'Game mode:';
   str_gmode[0]          := 'Skirmish';
   str_gmode[1]          := 'Two bases';
   str_gmode[2]          := 'Capturing points';
   str_gmode[3]          := 'Invasion';
   str_gmode[4]          := 'Assault';
   str_addon[false]      := #16+'UDOOM'+#25;
   str_addon[true ]      := #18+'DOOM 2'+#25;

   str_team              := 'Team:';
   str_srace             := 'Race:';
   str_ready             := 'Ready: ';
   str_udpport           := 'UDP port:';
   str_svup[false]       := 'Start server';
   str_svup[true ]       := 'Stop server';
   str_connect[false]    := 'Connect';
   str_connect[true ]    := 'Disconnect';
   str_pnu               := 'File size/quality: ';
   str_npnu              := 'Units update rate: ';
   str_connecting        := 'Connecting...';
   str_sver              := 'Wrong version!';
   str_sfull             := 'Server full!';
   str_sgst              := 'Game started!';

   str_hint_t[0]         := 'Buildings and Units';
   str_hint_t[1]         := 'Researches';
   str_hint_t[2]         := 'Replays';

   str_hint_m[0]         := 'Menu ('          +#18+'Esc'+#25+')';
   str_hint_m[2]         := 'Pause ('         +#18+'Pause/Break'+#25+')';

   t2str:='Hell Monastery, "Ancient evil" research.';

   _mkHStr(0,r_hell,0 ,'Hell Keep'      ,'Builds base.','');
   _mkHStr(0,r_hell,1 ,'Hell Gate'      ,'Summons units.','');
   _mkHStr(0,r_hell,2 ,'Hell Symbol'    ,'Generates energy.','');
   _mkHStr(0,r_hell,3 ,'Hell Pools'     ,'Research upgrades.','');
   _mkHStr(0,r_hell,4 ,'Hell Tower'     ,'Defensive structure.','');
   _mkHStr(0,r_hell,5 ,'Hell Teleport'  ,'Teleports units to any place.','');
   _mkHStr(0,r_hell,6 ,'Hell Monastery' ,'Upgrades units.','Hell Pools');
   _mkHStr(0,r_hell,7 ,'Hell Totem'     ,'Advanced defensive structure.'                     ,t2str);
   _mkHStr(0,r_hell,8 ,'Hell Altar'     ,'Repairs buildings and casts "Hell power" on units.',t2str);

   _mkHStr(0,r_hell,9 ,'Lost Soul'      ,'','');
   _mkHStr(0,r_hell,10,'Imp'            ,'','');
   _mkHStr(0,r_hell,11,'Demon'          ,'','');
   _mkHStr(0,r_hell,12,'Cacodemon'      ,'','');
   _mkHStr(0,r_hell,13,'Baron of Hell / Hell Knight','','');
   _mkHStr(0,r_hell,14,'Cyberdemon'     ,'','Hell Monastery.');
   _mkHStr(0,r_hell,15,'Mastermind'     ,'','Hell Monastery.');
   _mkHStr(0,r_hell,16,'Pain Elemental' ,'',t2str);
   _mkHStr(0,r_hell,17,'Revenant'       ,'',t2str);
   _mkHStr(0,r_hell,18,'Mancubus'       ,'',t2str);
   _mkHStr(0,r_hell,19,'Arachnotron'    ,'',t2str);
   _mkHStr(0,r_hell,20,'ArchVile'       ,'',t2str);

   _mkHStr(1,r_hell,upgr_attack  ,'Range attack upgrade'       ,'Increase ranged attacks damage.','');
   _mkHStr(1,r_hell,upgr_armor   ,'Unit armor upgrade'         ,'Increase units armor.','');
   _mkHStr(1,r_hell,upgr_build   ,'Buildinds armor upgrade'    ,'Increase buildings armor.','');
   _mkHStr(1,r_hell,upgr_melee   ,'Melee attack upgrade'       ,'Increase melee attacks damage.','');
   _mkHStr(1,r_hell,upgr_regen   ,'Regeneration'               ,'Units will slowly regenerate their health.','');
   _mkHStr(1,r_hell,upgr_paina   ,'Decay aura'                 ,'Hell Keep will damage all enemies around.','');
   _mkHStr(1,r_hell,upgr_vision  ,'Hell vision'                ,'Cyberdemon, Mastermind and Hell Altar becomes detectors.','');
   _mkHStr(1,r_hell,upgr_pains   ,'Pain threshold'             ,'Decrease "pain state" chance.','');
   _mkHStr(1,r_hell,upgr_5bld    ,'Teleport upgrade'           ,'Decrease teleport cooldown.','');
   _mkHStr(1,r_hell,upgr_mainm   ,'Hell Keep teleportaion'     ,'Hell keep can teleport to any place.','');
   _mkHStr(1,r_hell,upgr_towers  ,'Tower range upgrade'        ,'Increased range of defensive structures.','');
   _mkHStr(1,r_hell,upgr_mainr   ,'Hell keep range upgrade'    ,'Increased Hell Keep view/build range.','');
   _mkHStr(1,r_hell,upgr_6bld    ,'Soul collector'             ,'Hell Monastery will be able to collect souls to upgrade units.','');
   _mkHStr(1,r_hell,upgr_2tier   ,'Ancient evil'               ,'Tier 2 buildings, units and upgrades.','');
   _mkHStr(1,r_hell,upgr_revtele ,'Reverse teleport'           ,'Units can teleport back to Hell Teleport.'         ,t2str);
   _mkHStr(1,r_hell,upgr_revmis  ,'Revenant missile upgrade'   ,'Increase attack range, missiles become homing.'    ,t2str);
   _mkHStr(1,r_hell,upgr_hpower  ,'Hell power'                 ,'Increase number of units affected by Hell altar.'  ,t2str);
   _mkHStr(1,r_hell,upgr_hsymbol ,'Hell Symbol upgrade'        ,'Increase Hell Symbol`s energy income.'             ,t2str);
   _mkHStr(1,r_hell,upgr_bldrep  ,'Building restoration'       ,'Hell altar ability.'                               ,t2str);
   _mkHStr(1,r_hell,upgr_6bld2   ,'Soul storage'               ,'Hell Monastery can store more souls.'              ,t2str);
   _mkHStr(1,r_hell,upgr_mainonr ,'Free teleportation'         ,'Hell Keep can teleport to anywhere.'               ,t2str);
   _mkHStr(1,r_hell,upgr_b478tel ,'Symbols, Towers and Altars teleport ability'
                                                               ,'Hell Symbols, Towers, Totems and Altars can teleport to short distance.'
                                                                                                                    ,t2str);
   _mkHStr(1,r_hell,upgr_hinvuln ,'Temporary Invulnerability'  ,'All hell units become invulnerable for 15 seconds.',t2str);


   t2str:='Tech Center, "High technologies" research.';

   _mkHStr(0,r_uac,0 ,'UAC Command Center'         ,'Builds base.','');
   _mkHStr(0,r_uac,1 ,'UAC Military unit'          ,'Trains units.','');
   _mkHStr(0,r_uac,2 ,'UAC Generator'              ,'Generates energy.','');
   _mkHStr(0,r_uac,3 ,'UAC Weapon Factory'         ,'Research upgrades.','');
   _mkHStr(0,r_uac,4 ,'UAC Turret'                 ,'Defensive structure.','');
   _mkHStr(0,r_uac,5 ,'UAC Radar'                  ,'Reveals map.','');
   _mkHStr(0,r_uac,6 ,'UAC Tech Center'            ,'Upgrades units.','Weapon Factory');
   _mkHStr(0,r_uac,7 ,'UAC Rocket turret'          ,'Advanced defensive structure.'                     ,t2str);
   _mkHStr(0,r_uac,8 ,'UAC Rocket Launcher Station','Provide a missile strike. Missile strike requires "Missile strike" research.',t2str);

   _mkHStr(0,r_uac,9 ,'Engineer'         ,'','');
   _mkHStr(0,r_uac,10,'Medic'            ,'','');
   _mkHStr(0,r_uac,11,'Sergant'          ,'','');
   _mkHStr(0,r_uac,12,'Commando'         ,'','');
   _mkHStr(0,r_uac,13,'Artillery soldier','','');
   _mkHStr(0,r_uac,14,'Major'            ,'','');
   _mkHStr(0,r_uac,15,'BFG Marine'       ,'','');
   _mkHStr(0,r_uac,16,'Air APC'          ,'','');
   _mkHStr(0,r_uac,17,'Ground APC'       ,'','');
   _mkHStr(0,r_uac,18,'UAC Terminator'   ,'',t2str);
   _mkHStr(0,r_uac,19,'UAC Tank'         ,'',t2str);
   _mkHStr(0,r_uac,20,'UAC Fighter'      ,'',t2str);

   _mkHStr(1,r_uac ,upgr_attack  ,'Ranged attack upgrade'  ,'Increase damage of ranged attacks.','');
   _mkHStr(1,r_uac ,upgr_armor   ,'Infantry armor upgrade' ,'Increase infantry armor.','');
   _mkHStr(1,r_uac ,upgr_build   ,'Buildings armor upgrade','Increase buildings armor.','');
   _mkHStr(1,r_uac ,upgr_melee   ,'Repair and healing'     ,'Increase the efficiency of repair/healing of Engineers and Medics.','');
   _mkHStr(1,r_uac ,upgr_mspeed  ,'Lightweight armor'      ,'Increase infantry move speed.','');
   _mkHStr(1,r_uac ,upgr_shield  ,'Plasma shields'         ,'All buildings and mechs get plasma shields.','');
   _mkHStr(1,r_uac ,upgr_vision  ,'Detector device'        ,'Radar and mines becomes detectors.','');
   _mkHStr(1,r_uac ,upgr_invis   ,'Stealth troopers'       ,'Infantry becomes invisible.','');
   _mkHStr(1,r_uac ,upgr_5bld    ,'Radar upgrade'          ,'Increase radar scouting time and radius.','');
   _mkHStr(1,r_uac ,upgr_mainm   ,'Command Center flight'  ,'Command Center gains ability to fly.','');
   _mkHStr(1,r_uac ,upgr_towers  ,'Turrets range upgrade'  ,'Increased attack range of defensive structures.','');
   _mkHStr(1,r_uac ,upgr_mainr   ,'Command Center range'   ,'Increased Command Center view/build range.','');
   _mkHStr(1,r_uac ,upgr_6bld    ,'Advanced armory'        ,'Tech Center will be able to upgrade units.','');
   _mkHStr(1,r_uac ,upgr_2tier   ,'High technologies'      ,'Tier 2 buildings, units and upgrades.','');
   _mkHStr(1,r_uac ,upgr_blizz   ,'Missile strike'         ,'Missile strike from Rocket Launcher Station.'   ,t2str);
   _mkHStr(1,r_uac ,upgr_mechspd ,'Advanced engines'       ,'Increase mechs move speed.'                     ,t2str);
   _mkHStr(1,r_uac ,upgr_mecharm ,'Mech armor upgrade'     ,'Increase mechs armor.'                          ,t2str);
   _mkHStr(1,r_uac ,upgr_ucomatt ,'BFG turret'             ,'Command Center will be able to attack.'         ,t2str);
   _mkHStr(1,r_uac ,upgr_minesen ,'Mine-sensor'            ,'Mine ability.'                                  ,t2str);
   _mkHStr(1,r_uac ,upgr_6bld2   ,'Fast rearmament'        ,'Tech Center upgrades units faster.'             ,t2str);
   _mkHStr(1,r_uac ,upgr_mainonr ,'Free placement'         ,'Command center will be able to land anywhere.'  ,t2str);
   _mkHStr(1,r_uac ,upgr_addtur  ,'Additional turret'      ,'Additional weapon for UAC Turret.'              ,t2str);
   _mkHStr(1,r_uac ,upgr_apctur  ,'Turret for transport'   ,'Turret for APC.'                                ,t2str);


   str_hint[2,r_hell,0 ] := 'Faster game speed ('+#18+'Q'+#25+')';
   str_hint[2,r_hell,1 ] := 'Left click: skip 2 seconds ('+#18+'W'+#25+')'+#11+'Right click: skip 10 seconds ('+#18+'Ctrl'+#25+'+'+#18+'W'+#25+')';
   str_hint[2,r_hell,2 ] := 'List of game messages ('+#18+'E'+#25+')';
   str_hint[2,r_hell,3 ] := 'Fog of war ('+#18+'A'+#25+')';
   str_hint[2,r_hell,6 ] := 'All players ('+#18+'Z'+#25+')';
   str_hint[2,r_hell,7 ] := 'Red player [#1] ('+#18+'X'+#25+')';
   str_hint[2,r_hell,8 ] := 'Yellow player [#2] ('+#18+'C'+#25+')';
   str_hint[2,r_hell,9 ] := 'Green player [#3] ('+#18+'R'+#25+')';
   str_hint[2,r_hell,10] := 'Blue player [#4] ('+#18+'T'+#25+')';
   str_hint[2,r_uac ,0 ] := str_hint[2,r_hell,0 ];
   str_hint[2,r_uac ,1 ] := str_hint[2,r_hell,1 ];
   str_hint[2,r_uac ,2 ] := str_hint[2,r_hell,2 ];
   str_hint[2,r_uac ,3 ] := str_hint[2,r_hell,3 ];
   str_hint[2,r_uac ,6 ] := str_hint[2,r_hell,6 ];
   str_hint[2,r_uac ,7 ] := str_hint[2,r_hell,7 ];
   str_hint[2,r_uac ,8 ] := str_hint[2,r_hell,8 ];
   str_hint[2,r_uac ,9 ] := str_hint[2,r_hell,9 ];
   str_hint[2,r_uac ,10] := str_hint[2,r_hell,10];

   str_hint[0,r_uac ,25] := 'Mines';
   str_hint[1,r_uac ,25] := str_hint[0,r_uac ,25];
   str_hint[0,r_hell,25] := 'Zombie ('+#18+'M'+#25+')';
   str_hint[1,r_hell,25] := str_hint[0,r_hell,25];

   str_hint[0,r_uac ,21] := 'Action ('        +#18+'Ctrl'+#25+'+'+#18+'Space'+#25+')';
   str_hint[0,r_uac ,22] := 'Destroy ('       +#18+'Delete'+#25+')';
   str_hint[0,r_uac ,23] := 'Cancle ('        +#18+'Space'+#25+')';
   str_hint[1,r_uac ,24] := 'Menu ('          +#18+'Esc'+#25+')';
   str_hint[0,r_hell,21] := str_hint[0,r_uac ,21];
   str_hint[0,r_hell,22] := str_hint[0,r_uac ,22];
   str_hint[0,r_hell,23] := str_hint[0,r_uac ,23];
   str_hint[0,r_hell,24] := str_hint[0,r_uac ,24];
   str_hint[1,r_hell,24] := str_hint[1,r_uac ,24];

   str_camp_t[0]         := 'Hell #1: Phobos invasion';
   str_camp_t[1]         := 'Hell #2: Military base';
   str_camp_t[2]         := 'Hell #3: Deimos invasion';
   str_camp_t[3]         := 'Hell #4: Pentagram of Death';
   str_camp_t[4]         := 'Hell #7: Quarry';
   str_camp_t[5]         := 'Hell #8: Hell on Mars';
   str_camp_t[6]         := 'Hell #5: Hell on Earth';
   str_camp_t[7]         := 'Hell #6: Cosmodrome';
   str_camp_t[8]         := '9. ';
   str_camp_t[9]         := '10. ';
   str_camp_t[10]        := '11. ';
   str_camp_t[11]        := '12. ';
   str_camp_t[12]        := '13. ';
   str_camp_t[13]        := '14. ';
   str_camp_t[14]        := '15. ';
   str_camp_t[15]        := '16. ';
   str_camp_t[16]        := '17. ';
   str_camp_t[17]        := '18. ';
   str_camp_t[18]        := '19. ';
   str_camp_t[19]        := '20. ';
   str_camp_t[20]        := '21. ';
   str_camp_t[21]        := '22. ';

   str_camp_o[0]         := '-Destroy all human bases and armies'+#13+'-Protect the Portal';
   str_camp_o[1]         := '-Destroy Military Base';
   str_camp_o[2]         := '-Destroy all human bases and armies'+#13+'-Protect the Portal';
   str_camp_o[3]         := '-Protect the altars for 20 minutes';
   str_camp_o[4]         := '-Destroy all human bases and armies';
   str_camp_o[5]         := '-Destroy all human bases and armies';
   str_camp_o[6]         := '-Destroy all human bases and armies';
   str_camp_o[7]         := '-Destroy Cosmodrome'+#13+'-No human transport should escape';

   str_camp_m[0]         := #18+'Date:'+#25+#12+'15.11.2145'+#12+#18+'Location:'+#25+#12+'PHOBOS'+#12+#18+'Area:'+#25+#12+'Anomaly Zone';
   str_camp_m[1]         := #18+'Date:'+#25+#12+'16.11.2145'+#12+#18+'Location:'+#25+#12+'PHOBOS'+#12+#18+'Area:'+#25+#12+'Hall crater';
   str_camp_m[2]         := #18+'Date:'+#25+#12+'15.11.2145'+#12+#18+'Location:'+#25+#12+'DEIMOS'+#12+#18+'Area:'+#25+#12+'Anomaly Zone';
   str_camp_m[3]         := #18+'Date:'+#25+#12+'16.11.2145'+#12+#18+'Location:'+#25+#12+'DEIMOS'+#12+#18+'Area:'+#25+#12+'Swift crater';
   str_camp_m[4]         := #18+'Date:'+#25+#12+'18.11.2145'+#12+#18+'Location:'+#25+#12+'MARS'  +#12+#18+'Area:'+#25+#12+'Hellas Area';
   str_camp_m[5]         := #18+'Date:'+#25+#12+'19.11.2145'+#12+#18+'Location:'+#25+#12+'MARS'  +#12+#18+'Area:'+#25+#12+'Hellas Area';
   str_camp_m[6]         := #18+'Date:'+#25+#12+'18.11.2145'+#12+#18+'Location:'+#25+#12+'EARTH' +#12+#18+'Area:'+#25+#12+'Unknown';
   str_camp_m[7]         := #18+'Date:'+#25+#12+'19.11.2145'+#12+#18+'Location:'+#25+#12+'EARTH' +#12+#18+'Area:'+#25+#12+'Unknown';

   {
   str_cmp_mn[1 ] := 'Hell #1: Invasion on Phobos';
   str_cmp_mn[2 ] := 'Hell #2: Toxin Refinery';
   str_cmp_mn[3 ] := 'Hell #3: Military Base';
   str_cmp_mn[4 ] := 'Hell #4: Deimos Anomaly';
   str_cmp_mn[5 ] := 'Hell #5: Nuclear Plant';
   str_cmp_mn[6 ] := 'Hell #6: Science Center';
   str_cmp_mn[7 ] := 'Hell #7: Quarry';
   str_cmp_mn[8 ] := 'Hell #8: Hell on Mars';
   str_cmp_mn[9 ] := 'Hell #9: Hell On Earth';
   str_cmp_mn[10] := 'Hell #10: Industrial Zone';
   str_cmp_mn[11] := 'Hell #11: Cosmodrome';
   str_cmp_mn[12] := 'UAC #1: Command Center';
   str_cmp_mn[13] := 'UAC #2: Super Generators';
   str_cmp_mn[14] := 'UAC #3: Phobos Anomaly';
   str_cmp_mn[15] := 'UAC #4: Deimos Anomaly 2';
   str_cmp_mn[16] := 'UAC #5: Lab';
   str_cmp_mn[17] := 'UAC #6: Fortress of Mystery';
   str_cmp_mn[18] := 'UAC #7: City of the Damned';
   str_cmp_mn[19] := 'UAC #8: Slough of Despair';
   str_cmp_mn[20] := 'UAC #9: Mt. Erebus';
   str_cmp_mn[21] := 'UAC #10: Dead Zone';
   str_cmp_mn[22] := 'UAC #11: Battle For Mars';

   str_cmp_ob[1 ] := '-Destroy all human bases and armies'+#13+'-Protect portal';
   str_cmp_ob[2 ] := '-Destroy Toxin Refinery';
   str_cmp_ob[3 ] := '-Destroy Military Base';
   str_cmp_ob[4 ] := '-Destroy all human bases and armies'+#13+'-Cyberdemon must survive'+#13+'-Protect portal';
   str_cmp_ob[5 ] := '-Destroy Nuclear Plant'+#13+'-Cyberdemon must survive';
   str_cmp_ob[6 ] := '-Destroy Science Center'+#13+'-Cyberdemon must survive';
   str_cmp_ob[7 ] := '-Destroy all human bases and armies';
   str_cmp_ob[8 ] := '-Kill all humans!';
   str_cmp_ob[9 ] := '-Protect Hell Fortess'+#13+'-Destroy all human towns and armies';
   str_cmp_ob[10] := '-Destroy all industrial buildings'+#13+'-Destroy all command centers';
   str_cmp_ob[11] := '-Destroy all military bases';
   str_cmp_ob[12] := '-Find, protect and reapir'+#13+'Command Center'+#13+'-At least one engineer must survive';
   str_cmp_ob[13] := '-Find and repair 5 Super Generators';
   str_cmp_ob[14] := '-Destroy all bases and armies of hell'+#13+'around portal until the arrival of'+#13+'enemy reinforcements(for 20 minutes)';
   str_cmp_ob[15] := '-Destroy all bases and armies of hell'+#13+'-Protect portal';
   str_cmp_ob[16] := '-Repair and protect Science Center'+#13+'-Destroy all bases and armies of hell';
   str_cmp_ob[17] := '-Destroy fortess of hell';
   str_cmp_ob[18] := '-Destroy all altars of hell'+#13+'-Protect portal';
   str_cmp_ob[19] := '-Reach the opposite side of the area';
   str_cmp_ob[20] := '-Find and kill the Spiderdemon';
   str_cmp_ob[21] := '-Cleanse the Quarry';
   str_cmp_ob[22] := '-Destroy all bases and armies of hell';

   str_cmp_map[1 ] := 'Date:'+#12+'15.11.2145'+#12+'Location:'+#12+'PHOBOS'+#12+'Area:'+#12+'Anomaly Zone';
   str_cmp_map[2 ] := 'Date:'+#12+'15.11.2145'+#12+'Location:'+#12+'PHOBOS'+#12+'Area:'+#12+'Hall crater';
   str_cmp_map[3 ] := 'Date:'+#12+'16.11.2145'+#12+'Location:'+#12+'PHOBOS'+#12+'Area:'+#12+'Drunlo crater';
   str_cmp_map[4 ] := 'Date:'+#12+'15.11.2145'+#12+'Location:'+#12+'DEIMOS'+#12+'Area:'+#12+'Anomaly Zone';
   str_cmp_map[5 ] := 'Date:'+#12+'16.11.2145'+#12+'Location:'+#12+'DEIMOS'+#12+'Area:'+#12+'Swift crater';
   str_cmp_map[6 ] := 'Date:'+#12+'16.11.2145'+#12+'Location:'+#12+'DEIMOS'+#12+'Area:'+#12+'Voltaire Area';
   str_cmp_map[7 ] := 'Date:'+#12+'16.11.2145'+#12+'Location:'+#12+'MARS'  +#12+'Area:'+#12+'Hellas Area';
   str_cmp_map[8 ] := 'Date:'+#12+'16.11.2145'+#12+'Location:'+#12+'MARS'  +#12+'Area:'+#12+'Hellas Area';
   str_cmp_map[9 ] := 'Date:'+#12+'25.11.2145'+#12+'Location:'+#12+'EARTH' +#12+'Area:'+#12+'Unknown';
   str_cmp_map[10] := 'Date:'+#12+'26.11.2145'+#12+'Location:'+#12+'EARTH' +#12+'Area:'+#12+'Unknown';
   str_cmp_map[11] := 'Date:'+#12+'27.11.2145'+#12+'Location:'+#12+'EARTH' +#12+'Area:'+#12+'Unknown';
   str_cmp_map[12] := 'Date:'+#12+'16.11.2145'+#12+'Location:'+#12+'PHOBOS'+#12+'Area:'+#12+'Todd crater';
   str_cmp_map[13] := 'Date:'+#12+'16.11.2145'+#12+'Location:'+#12+'PHOBOS'+#12+'Area:'+#12+'Roche crater';
   str_cmp_map[14] := 'Date:'+#12+'17.11.2145'+#12+'Location:'+#12+'PHOBOS'+#12+'Area:'+#12+'Anomaly Zone';
   str_cmp_map[15] := 'Date:'+#12+'17.11.2145'+#12+'Location:'+#12+'DEIMOS'+#12+'Area:'+#12+'Anomaly Zone';
   str_cmp_map[16] := 'Date:'+#12+'18.11.2145'+#12+'Location:'+#12+'DEIMOS'+#12+'Area:'+#12+'Voltaire Area';
   str_cmp_map[17] := 'Date:'+#12+'18.11.2145'+#12+'Location:'+#12+'DEIMOS'+#12+'Area:'+#12+'Voltaire Area';
   str_cmp_map[18] := 'Date:'+#12+'20.11.2145'+#12+'Location:'+#12+'HELL'  +#12+'Area:'+#12+'Unknown';
   str_cmp_map[19] := 'Date:'+#12+'21.11.2145'+#12+'Location:'+#12+'HELL'  +#12+'Area:'+#12+'Unknown';
   str_cmp_map[20] := 'Date:'+#12+'22.11.2145'+#12+'Location:'+#12+'HELL'  +#12+'Area:'+#12+'Unknown';
   str_cmp_map[21] := 'Date:'+#12+'21.11.2145'+#12+'Location:'+#12+'MARS'  +#12+'Area:'+#12+'Hellas Area';
   str_cmp_map[22] := 'Date:'+#12+'22.11.2145'+#12+'Location:'+#12+'MARS'  +#12+'Area:'+#12+'Hellas Area';

   }
end;

procedure lng_rus;
var t2str:string;
begin
  str_MMap              := '�����';
  str_MPlayers          := '������';
  str_MObjectives       := '������';
  str_menu_s1[ms1_sett] := '���������';
  str_menu_s1[ms1_svld] := '����./����.';
  str_menu_s1[ms1_reps] := '������';
  str_menu_s2[ms2_camp] := '��������';
  str_menu_s2[ms2_scir] := '�������';
  str_menu_s2[ms2_mult] := '������� ����';
  str_reset[false]      := '������';
  str_reset[true ]      := '�����';
  str_exit[false]       := '�����';
  str_exit[true]        := '�����';
  str_m_liq             := '�����: ';
  str_m_siz             := '������: ';
  str_m_obs             := '��������: x';
  str_map               := '�����';
  str_players           := '������';
  str_mrandom           := '��������� �����';
  str_sound             := '��������� �����';
  str_musicvol          := '������';
  str_soundvol          := '�����';
  str_game              := '����';
  str_scrollspd         := '�������� ��.';
  str_mousescrl         := '�����. �����:';
  str_fullscreen        := '� ����:';
  str_plname            := '��� ������';
  str_maction           := '������ ����';
  str_maction2[true ]   := #18+'��������'+#25;
  str_maction2[false]   := #17+'��������'+#25+'+'+#17+'�����'+#25;
  str_race[r_random]    := '����.';
  str_pause             := '�����';
  str_win               := '������!';
  str_lose              := '���������!';
  str_gsaved            := '���� ���������';
  str_repend            := '����� ������!';
  str_save              := '���������';
  str_load              := '���������';
  str_delete            := '�������';
  str_svld_errors[1]    := '���� ��'+#13+'����������!';
  str_svld_errors[2]    := '����������'+#13+'������� ����!';
  str_svld_errors[3]    := '������������'+#13+'������ �����!';
  str_svld_errors[4]    := '������������'+#13+'������ �����!';
  str_time              := '�����: ';
  str_menu              := '����';
  str_player_def        := ' ���������!';
  str_inv_time          := '����� #';
  str_inv_ml            := '�������: ';
  str_play              := '���������';
  str_replay            := '������';
  str_cmpdif            := '���������: ';
  str_waitsv            := '�������� �������...';
  str_goptions          := '��������� ����';
  str_server            := '������';
  str_client            := '������';
  str_chat              := '���';
  str_gaddon            := '����:';
  str_randoms           := '��������� �������';
  str_apply             := '���������';
  str_plout             := ' ������� ����';

  str_loss              := '������� ���������:';
  str_losst[0]          := '��� �����';
  str_losst[1]          := '��� ����������';
  str_losst[2]          := '��� �������';

  str_starta            := '��������� ����:';
  str_startat[0]        := '1 '+#19+'���������'+#25;
  str_startat[1]        := '1 '+#19+'���������'+#25+'+ 1 '+#18+'���.'+#25;
  str_startat[2]        := '1 '+#19+'���������'+#25+'+ 2 '+#18+'���.'+#25;
  str_startat[3]        := '1 '+#19+'���.'+#25+'+ 2 '+#18+'���.'+#25+'+ 2 '+#17+'�.'+#25;

  str_onebase           := '���� ���������:';

  str_pnua[0]           := #19+'��������.'+#25+'/'+#15+'�������.'+#25;
  str_pnua[1]           := #18+' ���������'+#25+'/'+#16+'������'+#25;
  str_pnua[2]           := #17+' �������'+#25+'/'+#17+'�������'+#25;
  str_pnua[3]           := #16+' �������'+#25+'/'+#18+'�������'+#25;
  str_pnua[4]           := #15+' ����������'+#25+'/'+#19+'������'+#25;

  str_npnua[0]          := #15+'����� �����'+#25;
  str_npnua[1]          := #16+'�����'      +#25;
  str_npnua[2]          := #17+'��������'   +#25;
  str_npnua[3]          := #18+'�����'      +#25;
  str_npnua[4]          := #19+'����� �����'+#25;

  str_gmodet            := '����� ����:';
  str_gmode[0]          := '�������';
  str_gmode[1]          := '��� ��������';
  str_gmode[2]          := '������ �����';
  str_gmode[3]          := '���������';
  str_gmode[4]          := '�����';

  str_team              := '����:';
  str_srace             := '����:';
  str_ready             := '�����: ';
  str_udpport           := 'UDP ����:';
  str_svup[false]       := '���. ������';
  str_svup[true ]       := '����. ������';
  str_connect[false]    := '�����������';
  str_connect[true ]    := '����.';
  str_pnu               := '������/��������:';
  str_npnu              := '���������� ������: ';
  str_connecting        := '����������...';
  str_sver              := '������ ������!';
  str_sfull             := '��� ����!';
  str_sgst              := '���� ��������!';

  str_hint_t[0]         := '������ � �����';
  str_hint_t[1]         := '������������';
  str_hint_t[2]         := '������';

  str_hint_m[0]         := '���� ('          +#18+'Esc'+#25+')';
  str_hint_m[2]         := '����� ('         +#18+'Pause/Break'+#25+')';

  t2str:='������ ���������, ������������ "������� ���".';

  _mkHStr(0,r_hell,0 ,'������ ��������'      ,'������ ����.','');
  _mkHStr(0,r_hell,1 ,'������ �����'         ,'��������� �����.','');
  _mkHStr(0,r_hell,2 ,'������ ������'        ,'���������� �������.','');
  _mkHStr(0,r_hell,3 ,'������ �����'         ,'��������� ���������.','');
  _mkHStr(0,r_hell,4 ,'������ �����'         ,'�������� ����������.','');
  _mkHStr(0,r_hell,5 ,'������ ��������'      ,'���������� ������ � ����� ����� �����.','');
  _mkHStr(0,r_hell,6 ,'������ ���������'     ,'�������� ������.','������ �����');
  _mkHStr(0,r_hell,7 ,'������ �����'         ,'����������� �������� ����������.',t2str);
  _mkHStr(0,r_hell,8 ,'������ ������'        ,'��������������� ������ � ����������� �� ������ ������ "������ ����".',t2str);

  _mkHStr(0,r_hell,9 ,'Lost Soul'      ,'','');
  _mkHStr(0,r_hell,10,'Imp'            ,'','');
  _mkHStr(0,r_hell,11,'Demon'          ,'','');
  _mkHStr(0,r_hell,12,'Cacodemon'      ,'','');
  _mkHStr(0,r_hell,13,'Baron of Hell / Hell Knight','','');
  _mkHStr(0,r_hell,14,'Cyberdemon'     ,'','������ ���������.');
  _mkHStr(0,r_hell,15,'Mastermind'     ,'','������ ���������.');
  _mkHStr(0,r_hell,16,'Pain Elemental' ,'',t2str);
  _mkHStr(0,r_hell,17,'Revenant'       ,'',t2str);
  _mkHStr(0,r_hell,18,'Mancubus'       ,'',t2str);
  _mkHStr(0,r_hell,19,'Arachnotron'    ,'',t2str);
  _mkHStr(0,r_hell,20,'ArchVile'       ,'',t2str);

  _mkHStr(1,r_hell,upgr_attack  ,'��������� ������� �����'        ,'���������� ����� ������� �����.','');
  _mkHStr(1,r_hell,upgr_armor   ,'��������� ������ ������'        ,'���������� ������ ������.','');
  _mkHStr(1,r_hell,upgr_build   ,'��������� ������ ������'        ,'���������� ������ ������.','');
  _mkHStr(1,r_hell,upgr_melee   ,'��������� ������� �����'        ,'���������� ����� ������� �����.','');
  _mkHStr(1,r_hell,upgr_regen   ,'�����������'                    ,'����� �������� ��������������� ���� ��������.','');
  _mkHStr(1,r_hell,upgr_paina   ,'���� ����������'                ,'������ �������� ������� ���� ���� ������ ������.','');
  _mkHStr(1,r_hell,upgr_vision  ,'������ ������'                  ,'Cyberdemon, Mastermind � ������ ������� ���������� �����������.','');
  _mkHStr(1,r_hell,upgr_pains   ,'������� �����'                  ,'��������� ���� "pain state".','');
  _mkHStr(1,r_hell,upgr_5bld    ,'��������� ���������'            ,'��������� ����� ����������� ���������.','');
  _mkHStr(1,r_hell,upgr_mainm   ,'������������ ������ ��������'   ,'������ �������� ����� ������������ � ����� ��������� ����� �����.','');
  _mkHStr(1,r_hell,upgr_towers  ,'������ ����� �����'             ,'���������� ������� ����� �������� ����������.','');

  _mkHStr(1,r_hell,upgr_mainr   ,'������ ������ ������ ��������'  ,'����������� ������ ������ ������ ��������.','');
  _mkHStr(1,r_hell,upgr_6bld    ,'������� ���'                    ,'������ ��������� ����� �������� ������.','');
  _mkHStr(1,r_hell,upgr_2tier   ,'������� ���'                    ,'������ ������� ������, ������ � ���������.','');
  _mkHStr(1,r_hell,upgr_revtele ,'�������� ��������'              ,'����� ���� ������������ � ������ ��������.'                       ,t2str);
  _mkHStr(1,r_hell,upgr_revmis  ,'��������� ����� ����� Revenant' ,'���������� ��������� �����, ������� ����������� ����������������.',t2str);
  _mkHStr(1,r_hell,upgr_hpower  ,'������ ����'                    ,'��������� ����������� ������� ������.'                            ,t2str);
  _mkHStr(1,r_hell,upgr_hsymbol ,'��������� ������� �������'      ,'+1 � ������� ��� ������� ������� �������.'                        ,t2str);
  _mkHStr(1,r_hell,upgr_bldrep  ,'�������������� ������'          ,'����������� ������� ������.'                                      ,t2str);
  _mkHStr(1,r_hell,upgr_6bld2   ,'��������� ��� '                 ,'������ ��������� ����� ������� ������ ���.'                       ,t2str);
  _mkHStr(1,r_hell,upgr_mainonr ,'��������� ������������'         ,'������ �������� ����� ������������ �� �����, ����� � ��. �����������.',t2str);
  _mkHStr(1,r_hell,upgr_b478tel ,'������������ ��������, ����� � �������'
                                                                  ,'������ �������, �����, ������ � ������ ����� ����������������� �� �������� ����������.',t2str);
  _mkHStr(1,r_hell,upgr_hinvuln ,'��������� ������������'         ,'��� ����� ���������� ����������� �� 15 ������.'                   ,t2str);

  t2str:='����������� �����, ������������ "������� ����������".';

  _mkHStr(0,r_uac,0 ,'��������� �����'        ,'������ ����.','');
  _mkHStr(0,r_uac,1 ,'��������� �����'        ,'��������� ������.','');
  _mkHStr(0,r_uac,2 ,'���������'              ,'���������� �������.','');
  _mkHStr(0,r_uac,3 ,'����� ����������'       ,'��������� ���������.','');
  _mkHStr(0,r_uac,4 ,'���������� ������'      ,'�������� ����������.','');
  _mkHStr(0,r_uac,5 ,'�����'                  ,'���������� �����.','');
  _mkHStr(0,r_uac,6 ,'����������� �����'      ,'�������� ������.','����� ����������');
  _mkHStr(0,r_uac,7 ,'�������� ������'        ,'����������� �������� ����������.'                     ,t2str);
  _mkHStr(0,r_uac,8 ,'������� ��������� �����','���������� �������� ����. ��� ����� ��������� ������������ "�������� ����".',t2str);

  _mkHStr(0,r_uac,9 ,'�������'            ,'','');
  _mkHStr(0,r_uac,10,'�����'              ,'','');
  _mkHStr(0,r_uac,11,'�������'            ,'','');
  _mkHStr(0,r_uac,12,'��������'           ,'','');
  _mkHStr(0,r_uac,13,'�������������'      ,'','');
  _mkHStr(0,r_uac,14,'�����'              ,'','');
  _mkHStr(0,r_uac,15,'������ � BFG'       ,'','');
  _mkHStr(0,r_uac,16,'��������� ���������','','');
  _mkHStr(0,r_uac,17,'���'                ,'','');
  _mkHStr(0,r_uac,18,'����������'         ,'',t2str);
  _mkHStr(0,r_uac,19,'����'               ,'',t2str);
  _mkHStr(0,r_uac,20,'�����������'        ,'',t2str);

  _mkHStr(1,r_uac ,upgr_attack  ,'��������� ������� �����'  ,'���������� ����� ������� �����.','');
  _mkHStr(1,r_uac ,upgr_armor   ,'��������� ������ ������'  ,'���������� ������ ������.','');
  _mkHStr(1,r_uac ,upgr_build   ,'��������� ������ ������'  ,'���������� ������ ������.','');
  _mkHStr(1,r_uac ,upgr_melee   ,'������ � �������'         ,'���������� ������������� �������/������� ��������/������.','');
  _mkHStr(1,r_uac ,upgr_mspeed  ,'����������� �����'        ,'���������� �������� ������������ ������.','');
  _mkHStr(1,r_uac ,upgr_shield  ,'���������� ����'          ,'��� ������ � ������� �������� ���������� ����.','');
  _mkHStr(1,r_uac ,upgr_vision  ,'���������'                ,'����� � ���� ���������� �����������.','');
  _mkHStr(1,r_uac ,upgr_invis   ,'��������� ������'         ,'������ ���������� ���������.','');
  _mkHStr(1,r_uac ,upgr_5bld    ,'��������� ������'         ,'������������ ������ � ����� �������� ������.','');
  _mkHStr(1,r_uac ,upgr_mainm   ,'����� ���������� ������'  ,'��������� ����� ����� ������.','');
  _mkHStr(1,r_uac ,upgr_towers  ,'������ ����� �������'     ,'���������� ������� ����� �������� ����������.','');
  _mkHStr(1,r_uac ,upgr_mainr   ,'������ ������ ���������� ������','����������� ������ ������ ���������� ������.','');
  _mkHStr(1,r_uac ,upgr_6bld    ,'�������������� ����������','����������� ����� ����� �������� ������.','');
  _mkHStr(1,r_uac ,upgr_2tier   ,'������ ����������'        ,'������ ������� ������, ������ � ���������.','');
  _mkHStr(1,r_uac ,upgr_blizz   ,'�������� ����'            ,'������ ��� ������� ��������� �����.'                    ,t2str);
  _mkHStr(1,r_uac ,upgr_mechspd ,'����������� ���������'    ,'����������� �������� ������������ �������.'             ,t2str);
  _mkHStr(1,r_uac ,upgr_mecharm ,'��������� ������ �������' ,'���������� ������ �������.'                             ,t2str);
  _mkHStr(1,r_uac ,upgr_ucomatt ,'BFG ������'               ,'��������� ����� ����� ���������.'                       ,t2str);
  _mkHStr(1,r_uac ,upgr_minesen ,'����-������'              ,'����������� ����.'                                      ,t2str);
  _mkHStr(1,r_uac ,upgr_6bld2   ,'������� ��������������'   ,'����������� ����� ������� �������� ������.'             ,t2str);
  _mkHStr(1,r_uac ,upgr_mainonr ,'��������� �����������'    ,'��������� ����� ����� ������������ �� �����, ����� � ��. �����������.'  ,t2str);
  _mkHStr(1,r_uac ,upgr_addtur  ,'�������������� ������'    ,'�������������� ������ ��� ������.'                      ,t2str);
  _mkHStr(1,r_uac ,upgr_apctur  ,'������ ��� ����������'    ,''                                                       ,t2str);

  str_hint[2,r_hell,0 ] := '��������/��������� ���������� �������� ('+#18+'Q'+#25+')';
  str_hint[2,r_hell,1 ] := '����� ����: ���������� 2 ������� ('+#18+'W'+#25+')'+#11+'������ ����: ���������� 10 ������ ('+#18+'Ctrl'+#25+'+'+#18+'W'+#25+')';
  str_hint[2,r_hell,2 ] := '������ ������� ��������� ('+#18+'E'+#25+')';
  str_hint[2,r_hell,3 ] := '����� ����� ('+#18+'A'+#25+')';
  str_hint[2,r_hell,6 ] := '��� ������ (' +#18+'Z'+#25+')';
  str_hint[2,r_hell,7 ] := '������� ����� [#1] ('+#18+'X'+#25+')';
  str_hint[2,r_hell,8 ] := '������ ����� [#2] (' +#18+'C'+#25+')';
  str_hint[2,r_hell,9 ] := '������� ����� [#3] ('+#18+'R'+#25+')';
  str_hint[2,r_hell,10] := '����� ����� [#4] ('  +#18+'T'+#25+')';
  str_hint[2,r_uac ,0 ] := str_hint[2,r_hell,0 ];
  str_hint[2,r_uac ,1 ] := str_hint[2,r_hell,1 ];
  str_hint[2,r_uac ,2 ] := str_hint[2,r_hell,2 ];
  str_hint[2,r_uac ,3 ] := str_hint[2,r_hell,3 ];
  str_hint[2,r_uac ,6 ] := str_hint[2,r_hell,6 ];
  str_hint[2,r_uac ,7 ] := str_hint[2,r_hell,7 ];
  str_hint[2,r_uac ,8 ] := str_hint[2,r_hell,8 ];
  str_hint[2,r_uac ,9 ] := str_hint[2,r_hell,9 ];
  str_hint[2,r_uac ,10] := str_hint[2,r_hell,10];

  str_hint[0,r_uac ,25] := '����';
  str_hint[1,r_uac ,25] := str_hint[0,r_uac ,25];
  str_hint[0,r_hell,25] := '����� ('+#18+'M'+#25+')';
  str_hint[1,r_hell,25] := str_hint[0,r_hell,25];

  str_hint[0,r_hell,21] := '�������� ('      +#18+'Ctrl'+#25+'+'+#18+'Space'+#25+')';
  str_hint[0,r_hell,22] := '���������� ('    +#18+'Delete'+#25+')';
  str_hint[0,r_hell,23] := '������ ('        +#18+'Space'+#25+')';
  str_hint[1,r_hell,24] := '���� ('          +#18+'Esc'+#25+')';
  str_hint[0,r_uac ,21] := str_hint[0,r_hell,21];
  str_hint[0,r_uac ,22] := str_hint[0,r_hell,22];
  str_hint[0,r_uac ,23] := str_hint[0,r_hell,23];
  str_hint[0,r_uac ,24] := str_hint[0,r_hell,24];
  str_hint[1,r_uac ,24] := str_hint[1,r_hell,24];

  str_camp_t[0]         := 'Hell #1: ��������� �� �����';
  str_camp_t[1]         := 'Hell #2: ������� ����';
  str_camp_t[2]         := 'Hell #3: ��������� �� ������';
  str_camp_t[3]         := 'Hell #4: ����������� ������';
  str_camp_t[4]         := 'Hell #7: ������';
  str_camp_t[5]         := 'Hell #8: �� �� �����';
  str_camp_t[6]         := 'Hell #5: �� �� �����';
  str_camp_t[7]         := 'Hell #6: ���������';

  str_camp_o[0]         := '-�������� ��� ������� ���� � �����'+#13+'-������ ������';
  str_camp_o[1]         := '-�������� ������� ����';
  str_camp_o[2]         := '-�������� ��� ������� ���� � �����'+#13+'-������ ������';
  str_camp_o[3]         := '-������ ������ � ������� 20 �����';
  str_camp_o[4]         := '-�������� ��� ������� ���� � �����';
  str_camp_o[5]         := '-�������� ��� ������� ���� � �����';
  str_camp_o[6]         := '-�������� ��� ������� ���� � �����';
  str_camp_o[7]         := '-�������� ���������'+#13+'-�� ���� ������� ��������� �� ������'+#13+'����';

  str_camp_m[0]         := #18+'����:'+#25+#12+'15.11.2145'+#12+#18+'�����:'+#25+#12+'�����' +#12+#18+'�����:'+#25+#12+'��������';
  str_camp_m[1]         := #18+'����:'+#25+#12+'16.11.2145'+#12+#18+'�����:'+#25+#12+'�����' +#12+#18+'�����:'+#25+#12+'������ ����';
  str_camp_m[2]         := #18+'����:'+#25+#12+'15.11.2145'+#12+#18+'�����:'+#25+#12+'������'+#12+#18+'�����:'+#25+#12+'��������';
  str_camp_m[3]         := #18+'����:'+#25+#12+'16.11.2145'+#12+#18+'�����:'+#25+#12+'������'+#12+#18+'�����:'+#25+#12+'������ �����';
  str_camp_m[4]         := #18+'����:'+#25+#12+'18.11.2145'+#12+#18+'�����:'+#25+#12+'����'  +#12+#18+'�����:'+#25+#12+'������� ������';
  str_camp_m[5]         := #18+'����:'+#25+#12+'19.11.2145'+#12+#18+'�����:'+#25+#12+'����'  +#12+#18+'�����:'+#25+#12+'������� ������';
  str_camp_m[6]         := #18+'����:'+#25+#12+'18.11.2145'+#12+#18+'�����:'+#25+#12+'�����' +#12+#18+'�����:'+#25+#12+'����������';
  str_camp_m[7]         := #18+'����:'+#25+#12+'19.11.2145'+#12+#18+'�����:'+#25+#12+'�����' +#12+#18+'�����:'+#25+#12+'����������';
end;


procedure swLNG;
begin
  if(_lng)
  then lng_rus
  else lng_eng;
end;



