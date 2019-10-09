
const
Ver                    : byte = 39;

degtorad               = pi/180;

vid_fps                = 60;
vid_hfps               = vid_fps div 2;
vid_mpt                = trunc(1000/vid_fps); // 1 step time

ClientTTL              = vid_fps*10;
MaxNetBuffer           = 4096;

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

net_lg_cs              = 13;

MaxPlayers             = 4; //+1
MaxPlayerUnits         = 100;
MaxUnits               = (MaxPlayers*MaxPlayerUnits)+MaxPlayerUnits; // 500;

MaxMissiles            = 200;

MaxDoodads             = 300;

uf_ground              = 0;
uf_soaring             = 1;
uf_fly                 = 2;


r_random               = 0;
r_hell                 = 1;
r_uac                  = 2;

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

outlogfn               : string[7] = 'out.txt';

str_ps_none            : string[2] = '--';
str_ps_comp            : string[2] = 'AI';

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
UID_ZFormer            = 8;
UID_ZSergant           = 9;


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
marines                = [UID_Medic,UID_Engineer,UID_Sergant,UID_Commando,UID_Bomber,UID_Major,UID_BFG];

UID_FAPC               = 130;   

UID_UACComCenter       = 24;
UID_UACBarracks        = 25;
UID_UACGenerator       = 26;
UID_UACResCenter       = 27;
UID_UACTurret          = 28;
UID_UACRadar           = 29;

hzmbatc                = marines+[UID_UACBarracks];

demons                 = [UID_LostSoul,UID_Imp,UID_Demon,UID_Cacodemon,UID_Baron,UID_Cyberdemon,UID_Mastermind];

UID_ZCommando          = 40;
UID_ZBomber            = 41;
UID_ZFPlasma           = 42;
UID_ZBFG               = 43;
zimba                  : array[0..5] of byte = (UID_ZFormer,UID_ZSergant,UID_ZCommando,UID_ZBomber,UID_ZFPlasma,UID_ZBFG);  

bdx2cl                 = marines+[UID_ZFormer,UID_ZSergant,UID_ZCommando,UID_ZBomber,UID_ZFPlasma,UID_ZBFG,UID_Imp,UID_LostSoul];

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

PNU_min                = 30;

regen_period           = vid_fps*2;
_units_period          = 41;

build_hits_inc         = 22;
upgrade_time           : array[1..2,0..7] of integer = ((vid_fps*60*4,vid_fps*60*4,vid_fps*60*4,vid_fps*60*3,vid_fps*60*3,vid_fps*60*3,vid_fps*60  ,vid_fps*60 ), // 240 240 180 180 180 180 60 60
                                                        (vid_fps*60*4,vid_fps*60*4,vid_fps*60*3,vid_fps*60*3,vid_fps*60*3,vid_fps*60*2,vid_fps*60  ,vid_fps*60 ));// 240 240 240 180 180 120 60 60
radar_rld              = vid_fps*30;
radar_time             = radar_rld-vid_fps*5;
teleport_time          : array[0..7] of integer = (vid_hfps,vid_hfps,vid_hfps,vid_fps,vid_fps*2,vid_fps*4,vid_fps*4,1);
pain_state_time        = vid_hfps;
base_r                 = 400;
base_rr                = base_r*2;
build_b                = 100;
teleport_md            = 230;
bfg_s_tick             = 70;
UnitStepNum            = 8;
MissileStep            = 13;
melee_r                = 10;
repair                 : array[false..true] of byte = (7,8);  
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
radar_sr               = 300;
bomber_minr            = 70;
fog_cs                 = 90;
mine_r                 = 40;
hp_time                = vid_fps*30;
pain_aura              = 2;

shield_aa              : array[false..true] of byte = (4,2);
tox_time               = vid_fps*2;
tox_timem              = 255;
plasma                 = [mid_imp,mid_caco,mid_baron,mid_plasma];
bullets                = [mid_toxbullet,mid_bullet,mid_Mbullet];

transport_c            : array[false..true] of byte = (0,1);   
transport_r            = 50;

inv_perf               = vid_fps*60*3;
inv_per                = vid_fps*60;
inv_mon                = 40;
inv_wvs                = 20;

point_r                = 100;
point_t                : array[1..2] of byte = (2,90);
point_guard            : array[1..2] of byte = (6,4);
point_guard2           : array[1..2] of byte = (45,55);

alert_t                : array[false..true] of integer = (vid_fps*2,vid_fps*3);

mindmg                 = 1;

                rut2b  : array[1..2,0..7] of byte = ((UID_HellKeep,UID_HellGate,UID_HellSymbol,UID_HellPool,UID_HellTower,UID_HellTeleport,UID_HellAltar,UID_UACBase1),
                                                     (UID_UACComCenter,UID_UACBarracks,UID_UACGenerator,UID_UACResCenter,UID_UACTurret,UID_UACRadar,UID_UACPortal,UID_UACBase0));
                rut2u  : array[1..2,0..7] of byte = ((UID_LostSoul,UID_Imp,UID_Demon,UID_Cacodemon,UID_Baron,UID_Cyberdemon,UID_Mastermind,UID_ZFormer),
                                                     (UID_Engineer,UID_Medic,UID_Sergant,UID_Commando,UID_Bomber,UID_Major,UID_BFG,UID_FAPC));

                trt    : array[1..2,0..7] of integer = ((vid_fps*5,vid_fps*6,vid_fps*10,vid_fps*20,vid_fps*40,vid_fps*90,vid_fps*90,0),
                                                        (vid_fps*6,vid_fps*5,vid_fps*10,vid_fps*15,vid_fps*40,vid_fps*20,vid_fps*65,vid_fps*30));

                ut_0   = 0;  // UID_HellKeep     UID_UACComCenter          UID_LostSoul     UID_Engineer
                ut_1   = 1;  // UID_HellGate     UID_UACBarracks           UID_Imp          UID_Medic
                ut_2   = 2;  // UID_HellSymbol   UID_UACGenerator/Base2    UID_Demon        UID_Sergant
                ut_3   = 3;  // UID_HellPool     UID_UACResCenter          UID_Cacodemon    UID_Commando
                ut_4   = 4;  // UID_HellTower    UID_UACTurret             UID_Baron        UID_Bomber
                ut_5   = 5;  // UID_HellTeleport UID_UACRadar              UID_Cyberdemon   UID_Major
                ut_6   = 6;  // UID_HellAltar    UID_Mine                  UID_Mastermind   UID_BFG
                ut_7   = 7;  // UID_UACPortal    UID_UACPortal             UID_UID_ZFormer  UID_FAPC 

                b_r    : array[0..7] of byte = (70,70,40,65,25,40,150,100);

                b_m    : array[0..7] of byte = (2,8,4,1,20,1,0,0);
                u_m    : array[1..2,0..7] of byte = ((255,255,255,255,255,1,1,255),
                                                     (255,255,255,255,255,255,255,255));


                haspdu : array[0..7] of byte = (20,20,15,15,15,0,0,0);

                urld   : array[1..2,0..7] of byte = ((60,65,50,75,75 ,65,9  ,60),
                                                        (40,50,70,7 ,130,16,150,0)); 














