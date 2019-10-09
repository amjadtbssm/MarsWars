
const
Ver                    : byte = 39;

degtorad               = pi/180;


vid_BW                 = 48;  // button width

vid_fps                = 60;
vid_hfps               = vid_fps div 2;
vid_mpt                = trunc(1000/vid_fps); // 1 step time

font_w                 = 8;
font_iw                = font_w-1;

chat_lm_t              = vid_fps*4;
ClientTTL              = vid_fps*2;
MaxNetBuffer           = 4096;

mmsndvlmx              = 80/129;

start_char             = '+';

_uts                   = 7; //+1

nmid_clord             = 2;
nmid_players           = 3;
nmid_connect           = 4;
nmid_rshap             = 5;
nmid_shap              = 6;
nmid_pause             = 7;
nmid_nbegin            = 8;
nmid_chat              = 9;
nmid_sfull             = 10;
nmid_sver              = 11;
nmid_sgst              = 12;
nmid_swapp             = 13;

rpl_none               = 0;
rpl_whead              = 1;
rpl_wunits             = 2;
rpl_rhead              = 3;
rpl_runits             = 4;
rpl_rend               = 5;

rpl_size               = 1048;
svld_size              = 69808;

_rpls_pnumax           = 100;

fog_add                = 2;
fog_cs                 = 90;
MFogM                  = 25;

net_lg_cs              = 13;

ta_left                = 0;
ta_middle              = 1;
ta_right               = 2;

MaxMissiles            = 200;
MaxSprBuffer           = 400;

MaxPlayers             = 4; //+1
MaxPlayerUnits         = 100;
MaxUnits               = (MaxPlayers*MaxPlayerUnits)+MaxPlayerUnits; // 500;

MaxDoodads             = 300;

MaxADecs               = 25;

MaxADecSpr             = 18;

MaxMissions            = 22;
MINSCR                 = 14;

SVLDINSCR              = 9;
MSVLDINSCR             = SVLDINSCR+1;

RPLSINSCR              = 10;
MRPLSINSCR             = RPLSINSCR+1;


uf_ground              = 0;
uf_soaring             = 1;
uf_fly                 = 2;

uv_novis               = 0;
uv_nofog               = 1;
uv_inscr               = 2;

r_random               = 0;
r_hell                 = 1;
r_uac                  = 2;

gs_game                = 0;
gs_lose                = 1;
gs_win                 = 2;

gm_scir                = 0;
gm_2fort               = 1;
gm_inv                 = 2;
gm_ct                  = 3;


uo_action              = 1;  //orders
uo_delete              = 2;
uo_ctraining           = 3;
uo_build               = 4;
uo_training            = 5;
uo_upgrade             = 7;
uo_upcancle            = 9;
uo_cancle              = 8;
uo_select              = 10;
uo_aselect             = 11;
uo_dblselect           = 12;
uo_adblselect          = 13;
uo_setorder            = 14;
uo_selorder            = 15;
uo_selall              = 16;
uo_selu5               = 17;
uo_stop                = 18;
uo_ioinu5              = 19;

ps_none                = 0;
ps_play                = 1;
ps_comp                = 2;

mm_camp                = 0;
mm_mult                = 1;
mm_chat                = 2;

mm_sett                = 0;
mm_svld                = 1;
mm_rpls                = 2;

b2pm                   : array[false..true] of char = ('-','+');

NameLen                = 12;
ChatLen                = 37;
SvRpLen                = 15;

dblclk_tl              = 15;

AUDIO_FREQUENCY        : INTEGER = MIX_DEFAULT_FREQUENCY; //22050;
AUDIO_FORMAT           : WORD    = AUDIO_S16;
AUDIO_CHANNELS         : INTEGER = 1;
AUDIO_CHUNKSIZE        : INTEGER = 1024;                  //4096;

outlogfn               : string[7] = 'out.txt';
cfgfn                  : string[5] = 'cfg';

str_loading            : string[11] = 'LOADING...'+#0;
str_v                  : string[5]  = 'v39';
str_wcaption           : string[20] = 'MarsWars v39'+#0;
str_cprt               : string[45] = '[ T3DStudio & ASTS TEAM (c) 2016-2017 ]';
str_screenshot         : string[5] = 'MWScr';
str_ps_none            : string[2] = '--';
str_ps_comp            : string[2] = 'AI';

str_svld_dir           : string[6] = 'save/';
str_svld_ext           : string[4] = '.mws';
str_rpls_dir           : string[9] = 'replays/';
str_rpls_ext           : string[4] = '.mwr';
str_grp_fold           : string[10] = 'graphics/';
str_snd_fold           : string[10] = 'sounds/';
str_msc_fold           : string[10] = 'musics/';
grp_extn               = 3;
grp_exts               : array[1..grp_extn] of string = ('.png','.jpg','.bmp');

str_lng                : array[false..true] of string[3] = ('ENG','RUS');

str_ps_c               : array[0..2] of char = ('-','P','C');
str_ps_h               : char = '<';
str_ps_t               : char = '?';
str_ps_sv              : char = '@';

mid_imp                = 110;
mid_caco               = 120;
mid_baron              = 130;
mid_rocket             = 140;
mid_mexplode           = 141;
mid_granade            = 142;
mid_bullet             = 150;
mid_Mbullet            = 151;
mid_Sbullet            = 152;
mid_toxbullet          = 155;
mid_plasma             = 160;
mid_bfg                = 170;
_midrockets            = [mid_rocket,mid_granade,mid_mexplode];

eid_BExplode           = 201;
eid_BBExplode          = 202;
eid_Teleport           = 203;
eid_Explode            = 204;
eid_bfgef              = 207;
eid_db_h0              = 208;
eid_db_h1              = 209;
eid_db_u0              = 210;
eid_db_u1              = 211;
eid_gavno              = 212;
eid_hbar               = 214;
eid_blood              = 215;

upgr_attack            = 0;
upgr_armor             = 1;
upgr_build             = 2;
upgr_vision            = 3;
upgr_invis             = 4;
//hell
upgr_regen             = 5;
upgr_hpower            = 6;
upgr_zomb              = 7;
//uac
upgr_mspeed            = 5;
upgr_mine              = 6;
upgr_toxin             = 7;



UID_LostSoul           = 1;
UID_Imp                = 2;
UID_Demon              = 3;
UID_Cacodemon          = 4;
UID_Baron              = 5;
UID_Cyberdemon         = 6;
UID_Mastermind         = 7;

demons                 = [UID_LostSoul,UID_Imp,UID_Demon,UID_Cacodemon,UID_Baron,UID_Cyberdemon,UID_Mastermind];

UID_ZFormer            = 8;
UID_ZSergant           = 9;
UID_ZCommando          = 40;
UID_ZBomber            = 41;
UID_ZFPlasma           = 42;
UID_ZBFG               = 43;
zimba                  : array[0..5] of byte = (UID_ZFormer,UID_ZSergant,UID_ZCommando,UID_ZBomber,UID_ZFPlasma,UID_ZBFG);

UID_HellKeep           = 10;
UID_HellGate           = 11;
UID_HellSymbol         = 12;
UID_HellPool           = 13;
UID_HellTower          = 14;
UID_HellTeleport       = 15;

UID_Engineer           = 16;
UID_Medic              = 17;
UID_Sergant            = 18;
UID_Commando           = 19;
UID_Bomber             = 20;
UID_Major              = 21;
UID_BFG                = 22;
UID_Mine               = 23;

UID_FAPC               = 130;

marines                = [UID_Medic,UID_Engineer,UID_Sergant,UID_Commando,UID_Bomber,UID_Major,UID_BFG];
bdx2cl                 = marines+[UID_ZFormer,UID_ZSergant,UID_ZCommando,UID_ZBomber,UID_ZFPlasma,UID_ZBFG,UID_Imp,UID_LostSoul];
gvndth                 = [UID_Medic,UID_Engineer,UID_Sergant,UID_Commando,UID_Bomber,UID_BFG,UID_ZFormer,UID_ZSergant,UID_ZCommando,UID_ZBomber,UID_ZBFG,UID_Imp];

whdead                 = [eid_db_h0,eid_db_h1,eid_db_u0,eid_db_u1,eid_gavno,UID_Imp,UID_Demon,UID_Cacodemon,UID_Baron,UID_Cyberdemon,UID_Mastermind,UID_ZFormer,UID_ZSergant,UID_ZCommando,UID_ZBomber,UID_ZBFG,UID_Engineer,UID_Medic,UID_Sergant,UID_Commando,UID_Major,UID_Bomber,UID_BFG];

UID_UACComCenter       = 24;
UID_UACBarracks        = 25;
UID_UACGenerator       = 26;
UID_UACResCenter       = 27;
UID_UACTurret          = 28;
UID_UACRadar           = 29;

hzmbatc                = marines+[UID_UACBarracks];

UID_Build              = 55;

UID_UACPortal          = 100;
UID_UACBase0           = 101;   //militaty
UID_UACBase1           = 102;   //
UID_UACBase2           = 103;
UID_UACBase3           = 104;
UID_UACBase4           = 105;
UID_UACBase5           = 106;
UID_HellAltar          = 111;
UID_HellFortess        = 120;
UID_UACSPort           = 121;
UID_HellBarracks       = 122;

UID_Marker             = 150;
UID_InvBase            = 151;

whocanattack           = marines+demons+[UID_HellTower,UID_UACTurret,UID_ZFormer,UID_ZSergant,UID_ZCommando,UID_ZBomber,UID_ZFPlasma,UID_ZBFG,UID_Mine];
whocaninapc            = marines;


DID_tree               = 50;
DID_liquid             = 51;
DID_cleft              = 52;
DID_rock               = 53;
DID_Brock              = 54;

def_r                  = 260;
missile_mr             = 350;
liquid_r               = 200;
liquid_d               = liquid_r*2;
PNU_min                = 30;
PNU_max                = 255;
regen_period           = vid_fps*2;
_units_period          = 41;
fly_height             = 30;
build_hits_inc         = 22;
upgrade_time           : array[1..2,0..7] of integer = ((vid_fps*60*4,vid_fps*60*4,vid_fps*60*4,vid_fps*60*3,vid_fps*60*3,vid_fps*60*3,vid_fps*60  ,vid_fps*60 ), // 240 240 240 180 180 180 60 60
                                                        (vid_fps*60*4,vid_fps*60*4,vid_fps*60*3,vid_fps*60*3,vid_fps*60*3,vid_fps*60*2,vid_fps*60  ,vid_fps*60 ));// 240 240 180 180 180 120 60 60
radar_rld              = vid_fps*30;
radar_time             = radar_rld-vid_fps*5;
teleport_time          : array[0.._uts] of integer = (vid_hfps,vid_hfps,vid_hfps,vid_fps,vid_fps*2,vid_fps*4,vid_fps*4,1);
pain_state_time        = vid_hfps;
base_r                 = 400;
base_rr                = base_r*2;
build_b                = 100;
teleport_md            = 230;
bfg_s_tick             = 70;
UnitStepNum            = 8;
MissileStep            = 13;
radar_sr               = 300;
melee_r                = 10;
repair                 : array[false..true] of byte = (7,8);
txt_line_h             = 5;
txt_line_h2            = 25-font_w;
cmp_inhelltime         = (vid_fps*2);
gavno_dth_h            = -35;
md_lost                = 15;
md_imp                 = 20;
md_demon               = 40;
md_caco                = 40;
md_baron               = 60;
b_ai_m                 = 150;
b_ai_l                 = base_r-b_ai_m;
hellt_rld              = 40;
uact_rld               = 7;
build_rld              = vid_fps*2;
rocket_sp              = 45;
granade_sp             = 35;
LiquidAnim             = 4;
bomber_minr            = 70;
mine_r                 = 40;
hp_time                = vid_fps*30;
pain_aura              = 2;
dead_time              = vid_fps*10;
transport_c            : array[false..true] of byte = (0,1);
transport_r            = 50;

shield_aa              : array[false..true] of byte = (4,2);
tox_time               = vid_fps*2;
tox_timem              = 255;
plasma                 = [mid_imp,mid_caco,mid_baron,mid_plasma];
bullets                = [mid_toxbullet,mid_bullet,mid_Mbullet];

mindmg                 = 1;
point_r                = 100;
point_t                : array[1..2] of byte = (2,90);
point_guard            : array[1..2] of byte = (6,4);
point_guard2           : array[1..2] of byte = (45,55);

inv_perf               = vid_fps*60*3;
inv_per                = vid_fps*60;
inv_mon                = 40;
inv_wvs                = 20;

ui_alarmt              = vid_fps*4;
alert_t                : array[false..true] of integer = (vid_fps*2,vid_fps*3);

                rut2b  : array[1..2,0.._uts] of byte = ((UID_HellKeep,UID_HellGate,UID_HellSymbol,UID_HellPool,UID_HellTower,UID_HellTeleport,UID_HellAltar,UID_HellFortess),
                                                        (UID_UACComCenter,UID_UACBarracks,UID_UACGenerator,UID_UACResCenter,UID_UACTurret,UID_UACRadar,UID_UACPortal,UID_UACBase0));
                rut2u  : array[1..2,0.._uts] of byte = ((UID_LostSoul,UID_Imp,UID_Demon,UID_Cacodemon,UID_Baron,UID_Cyberdemon,UID_Mastermind,UID_ZFormer),
                                                        (UID_Engineer,UID_Medic,UID_Sergant,UID_Commando,UID_Bomber,UID_Major,UID_BFG,UID_FAPC));

                trt    : array[1..2,0.._uts] of integer = ((vid_fps*5,vid_fps*6,vid_fps*10,vid_fps*20,vid_fps*40,vid_fps*90,vid_fps*90,0),
                                                           (vid_fps*6,vid_fps*5,vid_fps*10,vid_fps*15,vid_fps*40,vid_fps*20,vid_fps*65,vid_fps*30));

                ut_0   = 0;  // UID_HellKeep     UID_UACComCenter          UID_LostSoul     UID_Engineer
                ut_1   = 1;  // UID_HellGate     UID_UACBarracks           UID_Imp          UID_Medic
                ut_2   = 2;  // UID_HellSymbol   UID_UACGenerator/Base2    UID_Demon        UID_Sergant
                ut_3   = 3;  // UID_HellPool     UID_UACResCenter          UID_Cacodemon    UID_Commando
                ut_4   = 4;  // UID_HellTower    UID_UACTurret             UID_Baron        UID_Bomber
                ut_5   = 5;  // UID_HellTeleport UID_UACRadar              UID_Cyberdemon   UID_Major
                ut_6   = 6;  // UID_HellAltar    UID_Mine                  UID_Mastermind   UID_BFG
                ut_7   = 7;  // UID_UACPortal    UID_UACPortal             UID_ZFormer      UID_FAPC

                b_r    : array[0.._uts] of byte = (70,70,40,65,25,40,150,100);

                b_m    : array[0.._uts] of byte = (2,8,4,1,20,1,0,0);
                u_m    : array[1..2,0.._uts] of byte = ((255,255,255,255,255,1  ,1  ,255),
                                                        (255,255,255,255,255,255,255,255));


                haspdu : array[0.._uts] of byte = (20,20,15,14,15,0,0,0);

                urld   : array[1..2,0.._uts] of byte = ((60,65,50,75,75 ,65,9  ,60),
                                                        (40,50,70,7 ,130,16,150,0));

                urlda  : array[1..2,0.._uts] of byte = ((20,30,25,45,45,55,5,35),
                                                        (29,40,40,4 ,110,0 ,0,0));












