
var _CYCLE       : boolean = false;
    _EVENT       : pSDL_EVENT;

    _testmode    : boolean = false;

    startcon     : boolean = false;
    startcons    : string = '';

    vid_flags    : cardinal = SDL_SWSURFACE;

    vid_draw     : boolean = true;

    vid_dsurf,
    vid_minimap,
    vid_terrain,
    vid_menu,
    vid_spanel,
    vid_screen   : pSDL_SURFACE;

    vid_mw       : integer = 800;
    vid_mh       : integer = 600;
    vid_bpp      : integer = 32;
    vid_panel    : integer = 144;

    vid_vmb_x0   : integer = 5;
    vid_vmb_y0   : integer = 5;
    vid_vmb_x1   : integer = 0;
    vid_vmb_y1   : integer = 0;

    vid_menuX    : integer = 0;

    vid_wide     : boolean = false;

    vid_mredraw  : boolean = false;
    vid_mmredraw : boolean = false;

    _RECT        : pSDL_RECT;

    ter_w        : integer = 1;
    ter_h        : integer = 1;
    ter_s        : pSDL_Surface;

    terdcs       : array[1..MaxADecs] of TAdec;

    onlySVCode   : boolean = false;

    CLUnits      : integer = 400;

    font_ca      : array[#0..#255] of pSDL_Surface;

    net_cl_svstr : string = '127.0.0.1:10666';
    net_cl_svip  : cardinal = 0;
    net_cl_svport: word = 10666;
    net_cl_con   : boolean = false;
    net_cl_svpl  : byte = 0;
    net_cl_svttl : integer = 0;
    net_sv_pstr  : string = '10666';
    net_sv_port  : word = 10666;
    net_sv_up    : boolean = false;

    net_socket   : PUDPSocket;
    net_buf      : PUDPpacket;

   net_lg_ci     : cardinal=0;
   net_lg_c      : array[0..net_lg_cs] of string;
   net_lg_lmt    : integer = 0;

   net_m_error   : string = '';

   _svld_lst     : array of string;//[0..MaxSVLD]
   _svld_lsts    : byte = 0;
   _svld_srl     : integer = 0;
   _svld_sm      : integer = 0;
   _svld_str     : string = '';
   _svld_stat    : string = '';

   _rpls_lst     : array of string;//[0..MaxSVLD]
   _rpls_lsts    : byte = 0;
   _rpls_rst     : byte = rpl_none;
   _rpls_pnu     : byte = 30;
   _rpls_u       : integer = 0;
   _rpls_file    : file;
   _rpls_fileo   : boolean = false;
   _rpls_lrname  : string = 'LastReplay';
   _rpls_srl     : integer = 0;
   _rpls_sm      : integer = 0;
   _rpls_stat    : string = '';
   _rpls_step    : integer = 1;

    _fscr        : boolean = true;
    _igchat      : boolean = false;
    _menu        : boolean = true;
    _m_sel       : byte = 0;  // menu item select
    _mmode       : byte = mm_mult;
    _mmode2      : byte = mm_sett;
    _mcmp_sm     : byte = 1;
    _mcmp_srl    : byte = 0;

    _warpten     : boolean = false;
    _invuln      : boolean = false;
    _fsttime     : boolean = false;

    PlayerHuman  : byte = 1;
    PlayerName   : string = 'Player';
    PlayerTeam   : byte = 1;
    PlayerRace   : byte = r_random;
    PlayerReady  : boolean = false;
    PlayerNUnits : byte = 100;
    PlayerNUR    : byte = 2;

    G_Started    : boolean = false;
    G_Step       : cardinal = 0;
    G_Paused     : byte = 0;
    G_Status     : byte = gs_game; //gs_game, gs_lose, gs_win

    G_Mode       : byte = gm_scir;

    _lau         : integer = 0; // last added unit

    rad_rld_ic   : array[false..true] of cardinal;

    p_colors     : array[0..MaxPlayers] of cardinal;

    _missiles    : array[1..MaxMissiles] of TMissile;
    _units       : array[0..MaxUnits   ] of TUnit;
    _players     : array[0..MaxPlayers ] of TPlayer;
    _effects     : array[1..MaxSprBuffer] of TEff;

    _regen       : integer = 0;
    prdc_units   : byte = 0;
  UnitStepNumNet : integer = UnitStepNum;

    fog_cw       : integer = 0; // map_mw/fog_cs
    fog_chw      : integer = 0; // fog_cw/2
    fog_cr       : integer = 0; // trunc(fog_chw*1.45);
    fog_vcnw     : integer = 0; // (vid_mw div fog_cw)+1;
    fog_vcnh     : integer = 0; // (vid_mh div fog_cw)+1;
    fog_c        : array[0..fog_cs] of array[0..fog_cs] of byte;
    fog_ix       : byte = 0;
    fog_iy       : byte = 0;
    radar_fr     : byte = 0;
    _fog         : boolean = true;//false;
    _fcx         : array[0..MFogM,0..MFogM] of byte;

    map_mw       : integer = 4000;
    map_b1       : integer = 0;
    map_mmcx     : single  = 0;   //mini-map coff = (vid_panel-2)/map_mw;
    map_mmvw     : integer = 0;   //mini-map vid w = trunc((vid_mw-vid_panel)*map_mmcx);
    map_mmvh     : integer = 0;   //mini-map vid h = trunc( vid_mh*map_mmcx);
    map_mm_liqc  : cardinal = 0;
    map_lqt      : byte = 0;
    map_trt      : byte = 0;
    map_seed     : cardinal = 0;
    map_pos      : byte = 0;
    map_obs      : byte = 1;
    map_liq      : boolean = false;
    map_psx      : array[0..MaxPlayers] of integer;
    map_psy      : array[0..MaxPlayers] of integer;
    map_dds      : array[1..MaxDoodads] of TDoodad;
    map_ffly     : boolean = false;

    map_plqt     : byte = 255;
    map_ptrt     : byte = 255;

    mmap_pr      : byte = 1;

    vid_vx       : integer = 0;     // vid pos
    vid_vy       : integer = 0;
    vid_mmvx     : integer = 0;     // mini-map vid pos
    vid_mmvy     : integer = 0;
    vid_vms      : byte = 25;       // vid move speed
    vid_vmm      : boolean = false; // vid move with mouse

    _ma_inv      : boolean = false;

    cmp_portal   : integer = 0;
    cmp_hellagr  : boolean = false;

    _moveView    : boolean = false;

    vid_sbuf     : array[1..MaxSprBuffer] of TSprD;
    vid_sbufs    : integer = 0;
    vid_sbufsp   : integer = 0;

    chat_m       : string = '';
    chat_nrlm    : boolean = false;

    k_chr        : char;            // keyboard
    k_chrt       : byte = 0;
    k_chrtt      : byte = 25;
    k_kbstr      : TSoc = [#192..#255,'A'..'Z','a'..'z','0'..'9','"','[',']','{','}',' ','_',',','.','(',')','<','>','-','+','`','@','#','%','?',':','$'];
    k_kbdig      : TSoc = ['0'..'9'];
    k_kbaddr     : TSoc = ['0'..'9','.',':'];

    k_l,
    k_r,
    k_u,
    k_d,
    k_shift,
    k_ctrl,
    k_alt,
    k_ml,
    k_mr         : byte;

    c_red,
    c_ared,
    c_ablue,
    c_orange,
    c_dorange,
    c_brown,
    c_yellow,
    c_dyellow,
    c_lime,
    c_green,
    c_dblue,
    c_blue,
    c_aqua,
    c_white,
    c_agray,
    c_gray,
    c_ablack,
    c_purple,
    c_black      : cardinal;

    m_vx,        // mouse
    m_vy,
    m_mx,
    m_my,
    m_sxs,
    m_sys        : integer;
    m_bx,
    m_by         : byte;
    m_vmove      : boolean = false;
    m_ldblclk    : byte = 0;
    m_sbuild     : byte = 255;
    m_sbuildc    : cardinal = 0;

    ui_urc       : array[0.._uts] of byte;
    ui_ur        : array[0.._uts] of integer;
    ui_apc       : array[0.._uts] of integer;
    ui_alarm     : integer = 0;
    ui_cl        : cardinal;
    ui_ax,
    ui_ay        : integer;
    ui_isb       : boolean = false;

    ui_mc_x,
    ui_mc_y,
    ui_mc_a      : integer;
    ui_mc_c      : cardinal;

    g_inv_w      : byte = 0;
    g_inv_t      : integer = 0;

    g_pt         : array[1..MaxPlayers] of TPoint;

    fps_s,
    fps_p        : cardinal;
    fps          : integer = 0;

    ai_bx        : array[0..MaxPlayers] of integer;
    ai_by        : array[0..MaxPlayers] of integer;

   _lng          : boolean = false; // false=eng, true = rus

// text

str_exit  :  array[false..true] of string;


str_upd,
str_player_def,
str_gsaved,
str_menu,
str_autors,
str_repend,
str_sver,
str_sfull,
str_play,
str_settings,
str_campaigns,
str_objectives,
str_chat,
str_players,
str_map,
str_saveload,
str_replays,
str_replay,
str_scirmish,
str_server,
str_udpport,
str_time,
str_client,
str_ipaddr,
str_team,
str_srace,
str_ready,
str_sound,
str_musicvol,
str_soundvol,
str_game,
str_scrollspd,
str_mousescrl,
str_fullscreen,
str_plname,
str_save,
str_load,
str_delete,
str_pause,
str_pnu,
str_win,
str_lose,
str_sgst,
str_connecting,
str_random,
str_gmodet,
str_wave,
str_monsters,
str_m_obs,
str_m_pos,
str_m_liq,
str_m_siz        : string;


str_gmode        : array[0..3] of string = ('Scirmish','Two fortress','Invasion','Domination');

str_rpl : array[0..5] of string = ('---','REC','REC','PLAY','PLAY','END');

str_svld_errors: array[1..4] of string;

str_svup,
str_connect,
str_yn,
str_reset        : array[false..true] of string;

str_race         : array[0..2]of string;

str_hints        : array[1..2] of array[0..23] of array[0..1] of string;

str_m_posC       : array[0..1] of char = ('x','+');

str_cmp_mn,
str_cmp_ob,
str_cmp_map      : array[1..MaxMissions] of string;

str_maction      : string;
str_maction2     : array[false..true] of string;

////

cmp_loc          : array[1..MaxMissions] of pSDL_Surface;

// sounds

 snd_svolume     : byte = 64;
 snd_mvolume     : byte = 64;

 snd_gv          : pMIX_CHUNK = NIL;
 snd_explode     : pMIX_CHUNK = NIL;
 snd_bfgs        : pMIX_CHUNK = NIL;
 snd_bfgepx      : pMIX_CHUNK = NIL;
 snd_plasmas     : pMIX_CHUNK = NIL;
 snd_plasmaexp   : pMIX_CHUNK = NIL;
 snd_hshoot      : pMIX_CHUNK = NIL;
 snd_hmelee      : pMIX_CHUNK = NIL;
 snd_build       : pMIX_CHUNK = NIL;
 snd_demon1      : pMIX_CHUNK = NIL;
 snd_dpain       : pMIX_CHUNK = NIL;
 snd_losts       : pMIX_CHUNK = NIL;
 snd_impd        : pMIX_CHUNK = NIL;
 snd_impc        : pMIX_CHUNK = NIL;
 snd_demonc      : pMIX_CHUNK = NIL;
 snd_demona      : pMIX_CHUNK = NIL;
 snd_demond      : pMIX_CHUNK = NIL;
 snd_cacoc       : pMIX_CHUNK = NIL;
 snd_cacod       : pMIX_CHUNK = NIL;
 snd_baronc      : pMIX_CHUNK = NIL;
 snd_barond      : pMIX_CHUNK = NIL;
 snd_cyberc      : pMIX_CHUNK = NIL;
 snd_cyberd      : pMIX_CHUNK = NIL;
 snd_cyberf      : pMIX_CHUNK = NIL;
 snd_mindc       : pMIX_CHUNK = NIL;
 snd_mindd       : pMIX_CHUNK = NIL;
 snd_mindf       : pMIX_CHUNK = NIL;
 snd_zc          : pMIX_CHUNK = NIL;
 snd_zd          : pMIX_CHUNK = NIL;
 snd_zp          : pMIX_CHUNK = NIL;
 snd_explode2    : pMIX_CHUNK = NIL;
 snd_ud1         : pMIX_CHUNK = NIL;
 snd_ud2         : pMIX_CHUNK = NIL;
 snd_pistol      : pMIX_CHUNK = NIL;
 snd_cast        : pMIX_CHUNK = NIL;
 snd_shotgun     : pMIX_CHUNK = NIL;
 snd_launch      : pMIX_CHUNK = NIL;
 snd_radar       : pMIX_CHUNK = NIL;
 snd_teleport    : pMIX_CHUNK = NIL;
 snd_uac_u0      : pMIX_CHUNK = NIL;
 snd_uac_u1      : pMIX_CHUNK = NIL;
 snd_uac_u2      : pMIX_CHUNK = NIL;
 snd_alarm       : pMIX_CHUNK = NIL;
 snd_rico        : pMIX_CHUNK = NIL;
 snd_chat        : pMIX_CHUNK = NIL;
 snd_hell        : pMIX_CHUNK = NIL;
 snd_al          : pMIX_CHUNK = NIL;
 snd_click       : pMIX_CHUNK = NIL;
 snd_hellbar     : pMIX_CHUNK = NIL;
 snd_imp         : pMIX_CHUNK = NIL;
 snd_zomb        : pMIX_CHUNK = NIL;
 snd_cast2       : pMIX_CHUNK = NIL;
 snd_inapc       : pMIX_CHUNK = NIL;

 snd_ml          : array of pMIX_MUSIC;
 snd_mls         : integer = 0;
 snd_curm        : byte = 1;

// sprites

 spr_mouse_in,
 spr_b_rfast,
 spr_b_rskip,
 spr_toxin,
 spr_hg_eff,
 spr_cancle,
 spr_panel,
 spr_cursor,
 spr_m_back,
 spr_m_sl,
 spr_c_mars,
 spr_c_hell,
 spr_c_earth,
 spr_c_phobos,
 spr_c_deimos    : pSDL_Surface;

 spr_sport       : array[0..1] of TUSprite;

 spr_u_base      : array[0..5] of TUSprite;

 spr_build       : array[0..3] of TUSprite;

 spr_b_b         : array[1..2,0..5] of pSDL_Surface;
 spr_b_u         : array[1..2,0..7] of pSDL_Surface;
 spr_b_up        : array[1..2,0..7] of pSDL_Surface;

 spr_mp          : array[1..2] of pSDL_Surface;

 spr_ut          : array[0..15]of TUSprite;

 spr_bex1        : array[0..5] of TUSprite;
 spr_bex2        : array[0..8] of TUSprite;

 spr_explode     : array[0..2] of TUSprite;
 spr_teleport    : array[0..5] of TUSprite;
 spr_bfg         : array[0..3] of TUSprite;

 spr_h_p0        : array[0..3] of TUSprite;
 spr_h_p1        : array[0..3] of TUSprite;
 spr_h_p2        : array[0..3] of TUSprite;
 spr_h_p3        : array[0..7] of TUSprite;

 spr_decs        : array[0..10] of TUSprite;

 spr_b           : array[1..2,0..5,0..3] of TUSprite;

 spr_u_p0        : array[0..5] of TUSprite;
 spr_u_p1        : array[0..3] of TUSprite;
 spr_u_p2        : array[0..5] of TUSprite;

 spr_h_u0        : array[0..28] of TUSprite;
 spr_h_u1        : array[0..52] of TUSprite;
 spr_h_u2        : array[0..53] of TUSprite;
 spr_h_u3        : array[0..29] of TUSprite;
 spr_h_u4        : array[0..52] of TUSprite;
 spr_h_u5        : array[0..56] of TUSprite;
 spr_h_u6        : array[0..81] of TUSprite;

 spr_h_z0        : array[0..52] of TUSprite;
 spr_h_z1        : array[0..52] of TUSprite;
 spr_h_z2        : array[0..59] of TUSprite; //h_z2_
 spr_h_z3        : array[0..52] of TUSprite; //h_z3_
 spr_h_z4j       : array[0..15] of TUSprite; //h_z4j_
 spr_h_z5        : array[0..52] of TUSprite; //h_z5_

 spr_u_u0        : array[0..52] of TUSprite;
 spr_u_u1        : array[0..44] of TUSprite;
 spr_u_u2        : array[0..44] of TUSprite;
 spr_u_u3        : array[0..52] of TUSprite;
 spr_u_u4        : array[0..44] of TUSprite;
 spr_u_u5        : array[0..15] of TUSprite;
 spr_u_u6        : array[0..44] of TUSprite;
 spr_u_u7        : array[0..15] of TUSprite;

 spr_vgvn        : array[0..7] of TUSprite;

 spr_liquid      : array[1..LiquidAnim] of TUSprite;

 spr_hbarrak,
 spr_dum,
 spr_mine,
 spr_u_portal,
 spr_h_altar,
 spr_h_fortes,
 spr_db_h0,
 spr_db_h1,
 spr_db_u0,
 spr_db_u1       :  TUSprite;

 spr_adecs       : array[1..MaxADecSpr] of TUSprite;
 spr_blood       : array[0..2] of TUSprite;















