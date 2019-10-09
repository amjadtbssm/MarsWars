
const ver              : byte = 7;

      degtorad         = pi/180;

      dblclkt          = 250;

      vid_bpp          = 32;

      vid_fps          = 60;
      vid_hfps         = vid_fps div 2;
      vid_hhfps        = vid_hfps div 2;
      vid_2fps         = vid_fps*2;
      vid_mpt          = trunc(1000/vid_fps);

      vid_ab           = 100;

      vid_panel        = 144;

      vid_mvs          = 500; // max vis sprites;
      vid_rtuir        = 6;
      vid_rtuis        = vid_fps div vid_rtuir;

      vid_uialrm_t     = vid_fps div (vid_rtuir div 3);
      vid_uialrm_ti    = vid_uialrm_t div 3;

      vid_uialrm_n     = 10;
      vid_uialrm_mr    = vid_uialrm_t-(vid_uialrm_t div 3);

      vid_BW           = 48;

      vid_svld_m       = 9;
      vid_rpls_m       = 10;
      vid_camp_m       = 16;

      AUDIO_FREQUENCY  : INTEGER = MIX_DEFAULT_FREQUENCY; //22050;
      AUDIO_FORMAT     : WORD    = AUDIO_S16;
      AUDIO_CHANNELS   : INTEGER = 1;
      AUDIO_CHUNKSIZE  : INTEGER = 1024;                  //4096;

      mmsndvlmx        = 80/129;

      svld_size        = 93656;
      rpl_size         = 1049;

      rpl_none         = 0;
      rpl_whead        = 1;
      rpl_wunit        = 2;
      rpl_rhead        = 3;
      rpl_runit        = 4;
      rpl_end          = 5;

      NameLen          = 12;
      ChatLen          = 38;
      ChatLen2         = 255;
      SvRpLen          = 15;

      fog_add          = 2;
      fog_cs           = 100;
      fog_chs          = fog_cs div 2;
      MFogM            = 30;

      LiquidAnim       = 4;
      Liquid_r         : array[0..4] of integer = (55 ,100,155,210,270); //250;
      Liquid_d         : array[0..4] of integer = (110,200,310,420,540);

      Crater_r         = 110;
      Crater_d         = Crater_r*2;

      ta_left          = 0;
      ta_middle        = 1;
      ta_right         = 2;

      font_w           = 8;
      font_iw          = font_w-1;

      txt_line_h       = 5;
      txt_line_h2      = 25-font_w;

      ms1_sett         = 0;
      ms1_svld         = 1;
      ms1_reps         = 2;

      ms2_camp         = 0;
      ms2_scir         = 1;
      ms2_mult         = 2;

      ns_none          = 0;
      ns_srvr          = 1;
      ns_clnt          = 2;

      ps_none          = 0;
      ps_play          = 1;
      ps_comp          = 2;

      gm_scir          = 0;
      gm_2fort         = 1;
      gm_ct            = 2;
      gm_inv           = 3;
      gm_coop          = 4;

      r_random         = 0;
      r_hell           = 1;
      r_uac            = 2;

      uf_ground        = 0;
      uf_soaring       = 1;
      uf_fly           = 2;

      MaxPlayers       = 4;
      MaxPlayerUnits   = 100;
      MaxDoodads       = 350;
      MaxSDecs         = 19;
      MaxTDecs         = 18;
      MaxUnits         = MaxPlayers*MaxPlayerUnits+MaxPlayerUnits;
      MaxNetChat       = 19;
      MaxNetBuffer     = 4096;
      MaxSMapW         = 6000;
      MinSMapW         = 3000;
      MaxMissions      = 21;
      MaxMissiles      = 200;

      NetTickN         = 2;

      chat_shlm_t      = vid_fps*5;

      outlogfn         : string = 'out.txt';
      cfgfn            : string = 'cfg';

      str_ver          : string = 'v47.1b';
      str_screenshot   : string = 'MVSCR_';
      str_loading      : string = 'LOADING...'+#0;
      str_wcaption     : string = 'The Ultimate MarsWars v47.1b'+#0;
      str_cprt         : string = '[ T3DStudio & ASTS TEAM (c) 2016-2019 ]';

      str_folder_gr    : string = 'graphic\';
      str_msc_fold     : string = 'music\';
      str_snd_fold     : string = 'sound\';
      str_svld_dir     : string = 'save\';
      str_svld_ext     : string = '.mws';
      str_rpls_dir     : string = 'replay\';
      str_rpls_ext     : string = '.mwr';

      str_ps_c         : array[0..2] of char = ('-','P','C');
      str_ps_t         : char = '?';
      str_ps_comp      : string = 'AI';
      str_ps_h         : char = '<';
      str_ps_sv        : char = '@';
      start_char       : char = '+';
      str_ps_none      : string = '--';
      b2pm             : array[false..true] of string[3] = (#15+'-'+#25,#18+'+'+#25);
      chat_type        : array[false..true] of char = ('|',' ');
      hot_keys         : array[0..23] of char = ('Q','W','E','A','S','D','Z','X','C','R','T','Y','F','G','H','V','B','N','U','I','O','J','K','L');

      build_b          = 5;

      k_chrtt          = 416;
      k_kbstr          : set of Char = [#192..#255,'A'..'Z','a'..'z','0'..'9','"','[',']','{','}',' ','_',',','.','(',')','<','>','-','+','`','@','#','%','?',':','$'];
      k_kbdig          : set of Char = ['0'..'9'];
      k_kbaddr         : set of Char = ['0'..'9','.',':'];

      _uts             = 31;
      _ubuffs          = 15;
      MaxUpgrs         = 22;

      _rpls_pnua       : array[0..4] of byte = (35,70 ,120,160,200);
      _net_pnua        : array[0..4] of byte = (50,100,150,200,250);

      ClientTTL        = vid_fps*5;

      nmid_startinf    = 3;
      nmid_connect     = 4;
      nmid_clinf       = 5;
      nmid_chat        = 6;
      nmid_chatclupd   = 7;
      nmid_shap        = 8;
      nmid_pause       = 9;
      nmid_sfull       = 10;
      nmid_sver        = 11;
      nmid_sgst        = 12;
      nmid_ncon        = 13;
      nmid_swapp       = 14;
      nmid_order       = 15;
      nmid_plout       = 16;
      nmid_getinfo     = 66;

      uo_build         = 1;
      uo_dblselect     = 2;
      uo_adblselect    = 3;
      uo_select        = 4;
      uo_aselect       = 5;
      uo_selorder      = 6;
      uo_setorder      = 7;
      uo_move          = 8;
      uo_delete        = 9;
      uo_action        = 10;
      uo_specsel       = 11;

      ua_move          = 1;
      ua_amove         = 2;
      ua_unload        = 3;

      ub_advanced      = 0;
      ub_pain          = 1;
      ub_toxin         = 2;
      ub_gear          = 3;
      ub_hellpower     = 4;
      ub_vis           = 5;
      ub_resur         = 6;
      ub_cast          = 7;
      ub_stopafa       = 8;
      ub_clcast2       = 9;
      ub_clcast        = 10;
      ub_invis         = 11;
      ub_detect        = 12;
      ub_shield        = 13;
      ub_invuln        = 14;
      ub_notarget      = 15;

      DID_tree         = 1;
      DID_liquid       = 2;
      DID_cleft        = 3;
      DID_rock         = 4;
      DID_Brock        = 5;

upgr_attack            = 0;  // distance attack
upgr_armor             = 1;  // base armor
upgr_build             = 2;  // base b armor
upgr_melee             = 3;  // melee attack / repair/health upgr

upgr_regen             = 4;  // hell
upgr_mspeed            = 4;  // uac

upgr_paina             = 5;  // decay aura
upgr_shield            = 5;  // shields

upgr_vision            = 6;  // detectors

upgr_pains             = 7;  // pain state
upgr_invis             = 7;  // invisible infantry

upgr_5bld              = 8;  // Teleport/Radar
upgr_mainm             = 9;  // Main b move

upgr_towers            = 10; // towers sr

upgr_mainr             = 11; // main sr

upgr_6bld              = 12; // Souls / adv
upgr_2tier             = 13; // Tier 2

upgr_revtele           = 14; // revers teleport
upgr_blizz             = 14; // blizzard launch

upgr_revmis            = 15; // revenant missile
upgr_mechspd           = 15; // mech speed

upgr_hpower            = 16; // hpower
upgr_mecharm           = 16; // mech arm

upgr_hsymbol           = 17; // +1 energy
upgr_ucomatt           = 17; // CC turret

upgr_minesen           = 18; // mine-sensor
upgr_bldrep            = 18; // build repair

upgr_6bld2             = 19; // 6bld upgr

upgr_mainonr           = 20; // main on doodabs

upgr_b478tel           = 21; // teleport towers and altars
upgr_addtur            = 21; // plasma turret for turret

upgr_hinvuln           = 22; // temp invuln
upgr_apctur            = 22; // turrets for apc


upgr_advbld            = 28;
upgr_advbar            = 29;

upgr_invuln            = 31;


MID_Imp                = 101;
MID_Cacodemon          = 102;
MID_Baron              = 103;
MID_HRocket            = 104;
MID_Revenant           = 105;
MID_RevenantS          = 106;
MID_Mancubus           = 107;
MID_YPlasma            = 108;
MID_BPlasma            = 109;
MID_Bullet             = 110;
MID_Bulletx2           = 111;
MID_TBullet            = 112;
MID_SShot              = 113;
MID_SSShot             = 114;
MID_BFG                = 115;
MID_Granade            = 116;
MID_Mine               = 117;
MID_Blizzard           = 118;
MID_Octo               = 119;
MID_URocket            = 120;
MID_ArchFire           = 214;

   UID_LostSoul        = 1;
   UID_Imp             = 2;
   UID_Demon           = 3;
   UID_Cacodemon       = 4;
   UID_Baron           = 5;
   UID_Cyberdemon      = 6;
   UID_Mastermind      = 7;
   UID_Pain            = 8;
   UID_Revenant        = 9;
   UID_Mancubus        = 10;
   UID_Arachnotron     = 11;
   UID_Archvile        = 12;

   UID_ZFormer         = 15;
   UID_ZSergant        = 16;
   UID_ZCommando       = 17;
   UID_ZBomber         = 18;
   UID_ZMajor          = 19;
   UID_ZBFG            = 20;

   UID_Engineer        = 31;
   UID_Medic           = 32;
   UID_Sergant         = 33;
   UID_Commando        = 34;
   UID_Bomber          = 35;
   UID_Major           = 36;
   UID_BFG             = 37;
   UID_FAPC            = 38;
   UID_APC             = 39;
   UID_Terminator      = 40;
   UID_Tank            = 41;
   UID_Flyer           = 42;

   UID_Mine            = 43;

   UID_UTransport      = 44;

   UID_HMilitaryUnit   = 50;

   UID_HKeep           = 51;
   UID_HGate           = 52;
   UID_HSymbol         = 53;
   UID_HPools          = 54;
   UID_HTower          = 55;
   UID_HTeleport       = 56;
   UID_HMonastery      = 57;
   UID_HTotem          = 58;
   UID_HAltar          = 59;
   UID_HFortress       = 60;

   UID_UCommandCenter  = 61;
   UID_UMilitaryUnit   = 62;
   UID_UGenerator      = 63;
   UID_UWeaponFactory  = 64;
   UID_UTurret         = 65;
   UID_URadar          = 66;
   UID_UVehicleFactory = 67;
   UID_URTurret        = 68;
   UID_URocketL        = 69;

   UID_UBaseMil        = 70;
   UID_UBaseCom        = 71;
   UID_UBaseGen        = 72;
   UID_UBaseRef        = 73;
   UID_UBaseNuc        = 74;
   UID_UBaseLab        = 75;
   UID_UCBuild         = 76;
   UID_USPort          = 77;

   uacbase             = [UID_UCommandCenter..UID_USPort];

   UID_Dron            = 80;
   UID_Octobrain       = 81;
   UID_Cyclope         = 82;

   UID_Portal          = 90;

marines                = [UID_Engineer,UID_Medic,UID_Sergant,UID_Commando,UID_Bomber,UID_Major,UID_BFG];
gavno                  = marines+[UID_Imp,UID_ZFormer,UID_ZSergant,UID_ZCommando,UID_ZBomber,UID_ZMajor,UID_ZBFG];
arch_res               = [UID_Imp..UID_Baron,UID_Revenant..UID_Arachnotron,UID_ZFormer..UID_ZBFG];
demons                 = [UID_LostSoul..UID_ZBFG];
whoapc                 = [UID_APC,UID_FAPC];
whocaninapc            = marines+[UID_APC,UID_Terminator,UID_Tank];
whocanattack           = [UID_LostSoul..UID_Archvile,
                          UID_ZFormer..UID_ZBFG,
                          UID_Engineer..UID_BFG,UID_Terminator..UID_Flyer,
                          UID_Mine,UID_APC,UID_FAPC,
                          UID_HTower,UID_HTotem,UID_UCommandCenter,
                          UID_UTurret,UID_URTurret,
                          UID_Dron,UID_Octobrain,UID_Cyclope];

whocanmp               = [UID_HGate,UID_UMilitaryUnit,UID_HTeleport,UID_UVehicleFactory,UID_HMilitaryUnit];

EID_BFG                = 200;
EID_BExp               = 201;
EID_BBExp              = 202;
EID_Teleport           = 203;
EID_Exp                = 204;
EID_Exp2               = 205;
EID_Gavno              = 206;
EID_HKT_h              = 207;
EID_HKT_s              = 208;
EID_db_h0              = 209;
EID_db_h1              = 210;
EID_db_u0              = 211;
EID_db_u1              = 212;
EID_Blood              = 213;
EID_ArchFire           = 214;
EID_HUpgr              = 215;

{
0    UID_HKeep,UID_HFortress    UID_UCommandCenter     UID_LostSoul        UID_Engineer
1    UID_HGate                  UID_UMilitaryUnit      UID_Imp             UID_Medic
2    UID_HSymbol                UID_UGenerator         UID_Demon           UID_Sergant
3    UID_HPools                 UID_UWeaponFactory     UID_Cacodemon       UID_Commando
4    UID_HTower                 UID_UTurret            UID_Baron           UID_Bomber
5    UID_HTeleport              UID_URadar             UID_Cyberdemon      UID_Major
6    UID_HMonastery             UID_UVehicleFactory    UID_Mastermind      UID_BFG
7    UID_HTotem                 UID_URTurret           UID_Pain            UID_FAPC
8    UID_HAltar                 UID_URocketL           UID_Revenant        UID_APC
9                                                      UID_Mancubus        UID_Terminator
10                                                     UID_Arachnotron     UID_Tank
11                                                     UID_Archvile        UID_Flyer
12   UID_Mine                                          Zimbas
13
14
15
}

ai_d2alrm              : array[false..true] of integer = (150,15);
base_r                 = 400;
base_rr                = base_r*2;
base_ir                = base_r+(base_r div 2);
fly_height             = 30;
uaccc_fly              = 23;
apc_exp_damage         = 70;
regen_per              = vid_fps*2;
_uclord_p              = vid_hfps+1;
mindmg                 = 1;
gavno_dth_h            = -35;
dead_hits              = -10*vid_fps;
idead_hits             = dead_hits+vid_2fps;
ndead_hits             = dead_hits-1;
dead_time              = -dead_hits;
radar_time             = vid_fps*25;
radar_rld              = radar_time+vid_fps*5;
radar_rld2             = vid_fps*3;
melee_r                = 8;
hp_char                = #5;
adv_char               = #6;
hp_detect              = #7;
hp_pshield             = #8;
ut2                    : array[1..2] of byte = (6,8);
missile_mr             = 500;
n_souls                = 6;
gear_time              : array[false..true] of byte = (vid_hfps,vid_fps*2);
dir_stepX              : array[0..7] of integer = (1,1,0,-1,-1,-1,0,1);
dir_stepY              : array[0..7] of integer = (0,-1,-1,-1,0,1,1,1);
revenant_ra            : array[false..true] of integer = (45,20);
rocket_sr              = 45;
map_ffly_fapc          : array[false..true] of byte = (2,5);
towers_sr              : array[false..true] of integer = (260,285);
blizz_w                = 250;
blizz_ww               = blizz_w*2;
mech_adv_rel           : array[false..true] of integer = (vid_fps*12,vid_fps*6);
uac_adv_rel            : array[false..true] of integer = (vid_fps*2,0);
g_ct_pr                = 150;
g_ct_ct                : array[1..2] of integer = (vid_fps*10,vid_fps*5);
hmon_max_souls         : array[false..true] of byte = (12,66);
bld_dec_mr             = 10;
def_ai                 = 4;
pain_time              = vid_hfps;
invuln_time            = vid_fps*15;

