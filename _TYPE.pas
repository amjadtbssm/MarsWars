
type

TBa = array[0..0] of byte;
TWa = array[0..0] of word;
TCa = array[0..0] of cardinal;

TSoc = set of char;
TSob = set of byte;

TUSprite = record
   surf:pSDL_Surface;
   hw,hh:integer;
end;
PTUSprite = ^TUSprite;

TADec = record
   x,y:integer;
end;

TDoodad = record
   x,y,dpth,r,t,a,mmx,mmy,mmr,fx,fy:integer;
   mmc:cardinal;
end;
PTDoodad = ^TDoodad;

TUnit = record
   mmx,mmy,mmr,
   fx,fy,fr,
   vx,vy,
   x,y,
   anim,r,sr,anims,
   speed,dir,rld,trt,
   mhits,rld_a,rld_r,
   bld_s,
   hits    : integer;

   foot,mdmg,
   generg,uf,
   _uclord,
   vstp,order,
   player,utrain,
   uid,max,shadow,
   ucl     : byte;

   alrm_i  : boolean;
   alrm_b  : boolean;
   alrm_x,
   alrm_y,
   alrm_r,
   tar1,
   dtar,
   uo_tar,
   uo_x,
   uo_y    : integer;
   uo_id   : byte;

   inapc   : integer;
   painc,
   pains,
   apcc,
   apcm,
   apcs    : byte;

   ai_basex,
   ai_basey: integer;

   buff : array[0.._ubuffs] of byte;

   isbuild,
   mech,bld,solid,
   wanim,melee,
   sel     : boolean;
end;
PTUnit = ^TUnit;

upgrar = array[0.._uts] of byte;
Pupgrar = ^upgrar;

TPlayer = record
   name    : string;

   cenerg,
   menerg,
   army,team,
   race,state,
   bld_r
           : byte;
   wbhero,
   ready   : boolean;

   o_id    : byte;
o_x0,o_y0,
o_x1,o_y1  :integer;

   u_e     : array[false..true,0.._uts] of byte;
   u_s     : array[false..true,0.._uts] of byte;
   u_c     : array[false..true] of byte;
   ubx     : array[0.._uts] of integer;

   ai_pushpart,
   ai_maxarmy,
   ai_attack,
   ai_skill: byte;

   cpupgr,
   a_upgr,
   a_build,
   a_units : cardinal;

   upgr    : upgrar;

   nchs,wb,bldrs,
   PNU     : byte;
   effect,
   n_u,
   ttl     : integer;
   nip     : cardinal;
   nport   : word;
end;

TPList = array[0..MaxPlayers] of TPLayer;

string6 = string[6];

TVisSpr = record
   s     : PSDL_Surface;
   x,y,ro,
   d,sh  : integer;
   rc,msk: cardinal;
   inv   : byte;
   bar   : single;
   clu   : integer;
   cll,
   crl   : byte;
   cru   : string6;
   rct   : boolean;
end;

TMissile = record
   x,y,vx,vy,dam,vst,tar,sr,fx,fy,dir,mtars:integer;
   player,mid,mf:byte;
end;

TEff = record
   x,y,t,t2,tm,d:integer;
   e:byte;
end;

TCTPoint = record
   px,py,mpx,mpy,ct:integer;
   pl:integer;
end;

TAlarm = record
   x,y,t:integer;
   b:boolean;
end;




