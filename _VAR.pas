
var _CYCLE       : boolean = false;
    _EVENT       : pSDL_EVENT;

    ter_s,
    _uipanel,
    _dsurf,
    _minimap,
    _bminimap,
    _SCREEN,
    _menu_surf   : pSDL_SURFACE;
    _vflags      : cardinal = SDL_SWSURFACE;

    _RECT        : pSDL_RECT;

    _ded         : boolean = false;


    _fscr        : boolean = false;
    _igchat      : boolean = false;
    _draw        : boolean = true;

    _testmode    : boolean = false;
    _fsttime     : boolean = false;
    _warpten     : boolean = false;

    _menu        : boolean = true;
    menu_s1      : byte = ms1_sett;
    menu_s2      : byte = ms2_scir;
    m_chat       : boolean = false;

    m_vrx,
    m_vry,
    mv_x,
    mv_y         : integer;

    PlayerName   : string = 'Player';
    PlayerTeam   : byte = 1;
    PlayerReady  : boolean = false;
    PlayerRace   : byte = 0;

    UnitStepNum  : byte = 8;

    vid_mw       : integer = 800;
    vid_mh       : integer = 600;
    vid_vmb_x0   : integer = 6;
    vid_vmb_y0   : integer = 6;
    vid_vmb_x1   : integer = 794;
    vid_vmb_y1   : integer = 594;
    vid_mwa      : integer = 0; //vid_mw+vid_ab;
    vid_mha      : integer = 0; //vid_mh+vid_ab*2;
    vid_uiuphx   : integer = 0;
    vid_ingamecl : byte = 0;

    vid_mredraw  : boolean = true;
    vid_terrain  : pSDL_SURFACE;
    vid_rtui     : byte = 0;

    ter_w,
    ter_h        : integer;

    font_ca      : array[char] of pSDL_SURFACE;

    G_Addon      : boolean = true;
    G_Started    : boolean = false;
    G_Paused     : byte = 0;
    G_WTeam      : byte = 255;
    G_mode       : byte = 0;
    G_loss       : byte = 0;
    G_starta     : byte = 0;
    G_onebase    : boolean = false;
    G_Step       : cardinal = 0;

    g_inv_mn     : byte = 0;
    g_inv_wn     : byte = 0;
    g_inv_t      : integer = 0;

    g_ct_pl      : array[1..MaxPlayers] of TCTPoint;

    onlySVCode   : boolean = true;

    _units       : array[0..MaxUnits  ] of TUnit;
    _players     : TPList;
    _missiles    : array[1..MaxMissiles ] of TMissile;
    _effects     : array[1..vid_mvs     ] of TEff;

    MaxSDecsS    : byte = 0;      //960 720
    _SDecs       : array of TAdec;

    _uclord_c    : integer = 0;
    _uregen_c    : integer = 0;

    _ulst        : array[byte] of TUnit;
    upgrade_time : array[1..2,0.._uts] of integer;
    upgrade_cnt  : array[1..2,0.._uts] of byte;

    _lsuc        : byte = 0;
    _lcu         : integer = 0;
    _lcup        : PTUnit;
    cl2uid       : array[1..2,false..true,0.._uts] of byte;
    _pne_b,
    _pne_u,
    _pne_r       : array[1..2,0.._uts] of byte;

    plcolor      : array[0..MaxPlayers] of cardinal;

    HPlayer      : byte = 1;

    team_army    : array[0..MaxPlayers] of integer;

    map_seed     : word = 1;
    map_seed2    : integer = 0;
    map_mw       : integer = 5000;
    map_trt      : byte=0;
    map_ptrt     : byte = 255;
    map_lqt      : byte=0;
    map_plqt     : byte = 255;
    map_mm_liqc  : cardinal = 0;
    map_obs      : byte = 1;
    map_liq      : byte = 1;
    map_pliq     : byte = 255;
    map_ffly     : boolean = false;
    map_mmcx     : single;
    map_mmvw,
    map_mmvh,
    map_prmm,
    map_b1       : integer;
    map_psx      : array[0..MaxPlayers] of integer;
    map_psy      : array[0..MaxPlayers] of integer;
    map_psr      : array[0..MaxPlayers] of integer;
    map_dds      : array[1..MaxDoodads] of TDoodad;
    map_flydpth  : array[0..2] of integer;

    cmp_skill    : byte = 3;
    cmp_mmap     : array[0..MaxMissions] of pSDL_Surface;
    cmp_ait2p    : word = 0;

    net_cl_svip  : cardinal = 0;
    net_cl_svport: word = 10666;
    net_cl_svttl : integer = 0;
    net_cl_svpl  : byte = 0;
    net_nstat    : byte = 0;
    net_m_error  : string = '';
    net_sv_pstr  : string = '10666';
    net_cl_svstr : string = '127.0.0.1:10666';
    net_sv_port  : word = 10666;
    net_socket   : PUDPSocket;
    net_buf      : PUDPpacket;
    net_period   : byte = 0;
    net_chat_s   : byte = 0;
    net_chat     : array[0..MaxNetChat] of string;
    net_chat_shlm: integer = 0;
    net_chat_str : string = '';
    net_pnui     : byte = 2;

    _svld_stat   : string = '';
    _svld_str    : string = '';
    _svld_l      : array of string;
    _svld_ln     : integer = 0;
    _svld_ls     : integer = 0;
    _svld_sm     : integer = 0;

    _rpls_file   : file;
    _rpls_fileo  : boolean = false;
    _rpls_u      : integer = 0;
    _rpls_pnui   : byte = 0;
    _rpls_pnu    : byte = 0;
    _rpls_lrname : string = 'LastReplay';
    _rpls_stat   : string = '';
    _rpls_rst    : byte = rpl_none;
    _rpls_l      : array of string;
    _rpls_ln     : integer = 0;
    _rpls_ls     : integer = 0;
    _rpls_sm     : integer = 0;
    _rpls_step   : integer = 1;
    _rpls_nwrch  : boolean = false;
    _rpls_log    : boolean = false;


    _cmp_sm      : integer = 0;
    _cmp_sel     : integer = 0;

    vid_vx       : integer = 0;
    vid_vy       : integer = 0;
    vid_vmspd    : integer = 25;
    vid_mmvx,
    vid_mmvy     : integer;
    vid_vmm      : boolean = false;

    vid_vsl      : array[1..vid_mvs] of TVisSpr;
    vid_vsls     : word = 0;
    vid_vslsp    : word = 0;

    fog_cw       : integer = 0; // map_mw/fog_cs
    fog_chw      : integer = 0; // fog_cw/2
    fog_cr       : integer = 0; // trunc(fog_chw*1.45);
    fog_vcnw     : integer = 0; // (vid_mw div fog_cw)+1;
    fog_vcnh     : integer = 0; // (vid_mh div fog_cw)+1;
    fog_c        : array[0..fog_cs] of array[0..fog_cs] of byte;
    fog_ix       : byte = 0;
    fog_iy       : byte = 0;
    _fog         : boolean = true;//false;
    _fcx         : array[0..MFogM,0..MFogM] of byte;

    _lng         : boolean = false;

    ordx,
    ordy         : array[0..255] of integer;

    _m_sel,
    m_sxs,
    m_sys,
    m_mx,
    m_my,
    m_vx,
    m_vy         : integer;
    m_ldblclk,
    m_sbuildc    : cardinal;
    m_sbuild,
    m_bx,
    m_by         : byte;
    m_vmove      : boolean = false;
    m_a_inv      : boolean = false;

    ui_mc_x,
    ui_mc_y,
    ui_mc_a      : integer;
    ui_mc_c      : cardinal;

    ui_tab       : byte = 0;
    ui_bldrs_x   : array[0.._uts] of integer;
    ui_bldrs_y   : array[0.._uts] of integer;
    ui_bldrs_r   : array[0.._uts] of integer;
    ui_muc       : array[false..true] of cardinal;
    ui_trnt      : array[0.._uts] of integer;
    ui_trntc     : array[0.._uts] of byte;
    ui_upgrc     : byte;
    ui_upgrl     : integer = 0;
    ui_upgr      : array[0.._uts] of integer;
    ui_apc       : array[0.._uts] of byte;
    ui_blds      : array[0.._uts] of byte;
    ui_alrms     : array[0..vid_uialrm_n] of TAlarm;
    ui_umark_u   : integer = 0;
    ui_umark_t   : byte = 0;

    ui_msk       : byte = 0;
    ui_msks      : shortint = 0;

    ui_rad_rld   : array[false..true] of cardinal;

    k_dbl,
    k_msst,
    k_mssp,
    k_l,
    k_r,
    k_u,
    k_d,
    k_shift,
    k_ctrl,
    k_alt,
    k_ml,
    k_mr,
    k_chrt       : cardinal;
    k_chr        : char;

    c_dred,
    c_awhite,
    c_red,
    c_ared,
    c_ablue,
    c_orange,
    c_dorange,
    c_brown,
    c_yellow,
    c_dyellow,
    c_lava,
    c_lime,
    c_green,
    c_dblue,
    c_blue,
    c_aqua,
    c_white,
    c_agray,
    c_gray,
    c_dgray,
    c_ablack,
    c_purple,
    c_black       : cardinal;

    _sbtnc        : array[false..true] of cardinal;

    //fps_dt,
    fps_cs,
    fps_ns        : cardinal;
    //_stmp:string;

    spr_liquid    : array[1..LiquidAnim] of TUSprite;
    spr_sdecs     : array[0..MaxSDecs  ] of TUSprite;
    spr_tdecs     : array[1..MaxTDecs  ] of TUSprite;
    spr_crater    : TUSprite;

    spr_dummy     : TUsprite;

spr_lostsoul      : array[0..28] of TUsprite;
spr_imp           : array[0..52] of TUsprite;
spr_demon         : array[0..53] of TUsprite;
spr_cacodemon     : array[0..29] of TUsprite;
spr_baron         : array[0..52] of TUsprite;
spr_knight        : array[0..52] of TUsprite;
spr_cyberdemon    : array[0..56] of TUsprite;
spr_mastermind    : array[0..81] of TUsprite;
spr_pain          : array[0..37] of TUsprite;
spr_revenant      : array[0..76] of TUsprite;
spr_mancubus      : array[0..78] of TUsprite;
spr_arachnotron   : array[0..69] of TUsprite;
spr_archvile      : array[0..85] of TUsprite;

spr_ZFormer       : array[0..52] of TUSprite;
spr_ZSergant      : array[0..52] of TUSprite;
spr_ZSSergant     : array[0..52] of TUSprite;
spr_ZCommando     : array[0..59] of TUSprite;
spr_ZBomber       : array[0..52] of TUSprite;
spr_ZFMajor       : array[0..15] of TUSprite;
spr_ZMajor        : array[0..52] of TUSprite;
spr_ZBFG          : array[0..52] of TUSprite;

spr_engineer      : array[0..44] of TUSprite;
spr_medic         : array[0..52] of TUSprite;
spr_sergant       : array[0..44] of TUSprite;
spr_ssergant      : array[0..44] of TUSprite;
spr_commando      : array[0..52] of TUSprite;
spr_bomber        : array[0..44] of TUSprite;
spr_fmajor        : array[0..15] of TUSprite;
spr_major         : array[0..44] of TUSprite;
spr_BFG           : array[0..44] of TUSprite;
spr_FAPC          : array[0..15] of TUSprite;
spr_APC           : array[0..15] of TUSprite;
spr_Terminator    : array[0..55] of TUSprite;
spr_Tank          : array[0..23] of TUSprite;
spr_Flyer         : array[0..15] of TUSprite;

spr_tur           : array[0..15] of TUSprite;
spr_rtur          : array[0..7 ] of TUSprite;

spr_HKeep,
spr_HGate,
spr_HSymbol,
spr_HPools,
spr_HTower,
spr_HTeleport     : array[0..3]  of TUsprite;

spr_UCommandCenter,
spr_UMilitaryUnit,
spr_UGenerator,
spr_UWeaponFactory,
spr_UTurret,
spr_URadar,
spr_UVehicleFactory,
spr_URTurret,
spr_URocketL        : array[0..3]  of TUsprite;

spr_eff_bfg         : array[0..3] of TUsprite; //ef_bfg_
spr_eff_eb          : array[0..5] of TUsprite; //ef_eb
spr_eff_ebb         : array[0..8] of TUsprite; //ef_ebb
spr_eff_tel         : array[0..5] of TUsprite; //ef_tel
spr_eff_exp         : array[0..2] of TUsprite; //ef_exp_
spr_eff_exp2        : array[0..4] of TUsprite; //exp2_
spr_eff_g           : array[0..7] of TUsprite; //g_

spr_h_p0            : array[0..3] of TUSprite;
spr_h_p1            : array[0..3] of TUSprite;
spr_h_p2            : array[0..3] of TUSprite;
spr_h_p3            : array[0..7] of TUSprite;
spr_h_p4            : array[0..10]of TUSprite;
spr_h_p5            : array[0..7] of TUSprite;
spr_h_p6            : array[0..7] of TUSprite;
spr_h_p7            : array[0..5] of TUSprite;

spr_u_p0            : array[0..5] of TUSprite;
spr_u_p1            : array[0..3] of TUSprite;
spr_u_p2            : array[0..5] of TUSprite;
spr_u_p3            : array[0..7] of TUSprite;

spr_trans           : array[0..7] of TUSprite;
spr_sport           : array[0..1] of TUSprite;

spr_blood           : array[0..2] of TUSprite;

spr_drone           : array[0..7] of TUSprite; // l_dron_
spr_octo            : array[0..19]of TUSprite; // l_oct_
spr_cycl            : array[0..54]of TUSprite; // l_cy_

spr_o_p             : array[0..4] of TUSprite;

spr_ubase           : array[0..5] of TUSprite;

spr_cbuild          : array[0..3] of TUSprite;

    spr_mp        : array[1..2] of TUsprite;
    spr_gear,
    spr_toxin,
    spr_mine,
    spr_HFortress,
    spr_HMonastery,
    spr_HTotem,
    spr_HAltar,
    spr_HBar,
    spr_db_h0,
    spr_db_h1,
    spr_db_u0,
    spr_db_u1,
    spr_u_portal  : TUSprite;

    spr_mbackmlt,
    spr_c_mars,
    spr_c_hell,
    spr_c_earth,
    spr_c_phobos,
    spr_c_deimos ,
    spr_b_rfast,
    spr_b_rskip,
    spr_b_rfog,
    spr_b_rlog,
    spr_h_u4k,
    spr_b_action,
    spr_b_cancle,
    spr_b_delete,
    spr_panel,
    spr_msl,
    spr_mback,
  //  spr_terrain,
    spr_cursor   : pSDL_Surface;

    spr_b_b      : array[1..2,0..8 ] of pSDL_Surface;
    spr_b_u      : array[1..2,0..11] of pSDL_Surface;
    spr_b_up     : array[1..2,0..MaxUpgrs] of pSDL_Surface;

    spr_tabs     : array[0..2] of pSDL_Surface;

    /// text

    str_plout,
    str_apply,
    str_randoms,
    str_onebase,
    str_starta,
    str_loss,
    str_gaddon,
    str_chat,
    str_server,
    str_client,
    str_goptions,
    str_waitsv,
    str_cmpdif,
    str_repend,
    str_replay,
    str_play,
    str_inv_ml,
    str_inv_time,
    str_player_def,
    str_menu,
    str_time,
    str_players,
    str_map,
    str_save,
    str_load,
    str_delete,
    str_gsaved,
    str_pause,
    str_win,
    str_lose,
    str_sver,
    str_sfull,
    str_sgst,
    str_team,
    str_srace,
    str_ready,
    str_udpport,
    str_connecting,
    str_pnu,
    str_npnu,
    str_gmodet,
    str_sound,
    str_soundvol,
    str_musicvol,
    str_game,
    str_maction,
    str_scrollspd,
    str_mousescrl,
    str_fullscreen,
    str_plname,
    str_mrandom,
    str_m_liq,
    str_m_siz,
    str_m_obs,
    str_MObjectives,
    str_MMap,
    str_MPlayers
                 : string;

    str_npnua,
    str_pnua,
    str_cmpd     : array[0..4] of string;

    str_hint_t   : array[0..2] of string;
    str_hint_m   : array[0..2] of string;
    str_hint     : array[0..2,1..2,0..26] of string;

    str_losst    : array[0..2] of string;
    str_startat  : array[0..3] of string;

    str_rpl : array[0..5] of string = ('OFF','REC','REC','PLAY','PLAY','END');

    str_race     : array[0..2] of string;

    str_gmode    : array[0..4] of string;

    str_svld_errors: array[1..4] of string;

    str_camp_t   : array[0..MaxMissions] of string;
    str_camp_o   : array[0..MaxMissions] of string;
    str_camp_m   : array[0..MaxMissions] of string;

    str_addon    : array[false..true] of string;

    str_connect,
    str_svup,
    str_lng,
    str_maction2,
    str_exit,
    str_reset    : array[false..true] of string;

    str_menu_s1,
    str_menu_s2  : array[0..2] of string;

    str_m_liqC   : array[0..4] of string = ('-','R1','R2','R3','R4');

    // sounds

     snd_svolume     : byte = 64;
     snd_mvolume     : byte = 64;
     snd_ml          : array of pMIX_MUSIC;
     snd_mls         : integer = 0;
     snd_curm        : byte = 1;

     snd_build       : array[1..2] of pMIX_CHUNK;

     snd_l_cy_f,
     snd_l_cy_a,
     snd_alarm,
     snd_l_cy_p,
     snd_l_cy_c,
     snd_l_cy_d,
     snd_l_cy_a1,
     snd_l_cy_a2,
     snd_l_dron_p,
     snd_l_dron_a,
     snd_l_octo_a,
     snd_l_octo_c,
     snd_l_octo_d,
     snd_l_octo_p,
     snd_l_spawn,
     snd_uupgr,
     snd_hupgr,
     snd_cast,
     snd_cast2,
     snd_bfgs,
     snd_bfgepx,
     snd_plasmas,
     snd_ssg,
     snd_rico,
     snd_pistol,
     snd_shotgun,
     snd_launch,
     snd_cubes,
     snd_rev_c,
     snd_rev_m,
     snd_rev_d,
     snd_rev_a,
     snd_rev_ac,
     snd_hshoot,
     snd_man_a,
     snd_man_d,
     snd_man_p,
     snd_man_c,
     snd_zomb,
     snd_ud1,
     snd_ud2,
     snd_z_p,
     snd_z_d1,
     snd_z_d2,
     snd_z_d3,
     snd_z_s1,
     snd_z_s2,
     snd_z_s3,
     snd_uac_u0,
     snd_uac_u1,
     snd_uac_u2,
     snd_pain_c,
     snd_pain_p,
     snd_pain_d,
     snd_mindc,
     snd_mindd,
     snd_mindf,
     snd_cyberc,
     snd_cyberd,
     snd_cyberf,
     snd_knight,
     snd_knightd,
     snd_baronc,
     snd_barond,
     snd_cacoc,
     snd_cacod,
     snd_dpain,
     snd_demon1,
     snd_click,
     snd_chat,
     snd_inapc,
     snd_ccup,
     snd_radar,
     snd_teleport,
     snd_pexp,
     snd_exp,
     snd_exp2,
     snd_d0,
     snd_meat,
     snd_ar_act,
     snd_ar_c,
     snd_ar_d,
     snd_ar_f,
     snd_imp,
     snd_impd1,
     snd_impd2,
     snd_impc1,
     snd_impc2,
     snd_demonc,
     snd_demona,
     snd_demond,
     snd_hmelee,
     snd_arch_a,
     snd_arch_at,
     snd_arch_d,
     snd_arch_p,
     snd_arch_c,
     snd_arch_f,
     snd_hellbar,
     snd_hell

     : pMIX_CHUNK;





