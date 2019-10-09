
var _CYCLE       : boolean = false;

    net_sv_port  : word = 10666;

    net_socket   : PUDPSocket;
    net_buf      : PUDPpacket;

   net_lg_ci     : cardinal=0;
   net_lg_c      : array[0..net_lg_cs] of string;

  // net_ct        : cardinal = 0;
   //net_cs        : integer = 0;

    _warpten     : boolean = false;
    _invuln      : boolean = false;
    _fsttime     : boolean = false;

    G_Started    : boolean = false;
    G_Step       : cardinal = 0;
    G_Paused     : byte = 0;

    g_mode       : byte = gm_scir;

    _lau         : integer = 0; // last added unit

    _missiles    : array[1..MaxMissiles] of TMissile;
    _units       : array[0..MaxUnits   ] of TUnit;
    _players     : array[0..MaxPlayers ] of TPlayer;

    _regen       : integer = 0;
    prdc_units   : byte = 0;

    fog_cw       : integer = 0; // map_mw/fog_cs

  PlayerHuman    : byte = 0;

    map_mw       : integer = 4000;
    map_b1       : integer = 0;
    map_mmcx     : single  = 0;   //mini-map coff = (vid_panel-2)/map_mw;

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


    fps_s,
    fps_p        : cardinal;

    ai_bx        : array[0..MaxPlayers] of integer;
    ai_by        : array[0..MaxPlayers] of integer;  

    g_inv_w      : byte = 0;
    g_inv_t      : integer = 0;  

    g_pt         : array[1..4] of TPoint;   

////


str_player_def : string = ' was terminated!';

















