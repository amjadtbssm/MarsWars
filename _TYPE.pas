
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
   spr:PTUsprite;
end;

TEff = record
   x,y,t,t2,tm,d:integer;
   e:byte;
end;

TMissile = record
   x,y,vx,vy,dam,vst,tar,sr,fx,fy,dir:integer;
   player,mid,mf:byte;
end;


TDoodad = record
   x,y,dpth,r,t,a,mmx,mmy,mmr,fx,fy:integer;
   mmc:cardinal;
end;

PTDoodad = ^TDoodad;

TUnit = record
   x,y,vx,vy,mx,my,mmx,mmy,fx,fy,fr,sr,
   mhits,hits,dir,r,speed,rld,vst,tar,dtar,vist,order,anim,shield:integer;

   apcc,apcm,apcs,
   alt,
   _uclord,uf,utp,generg,
   invis,detect,
   ucl,vis,mmr,utrain,
   paint,pains,painc,
   player,foots,ma:byte;

   bio,
   sel,bld,isbuild,dsbl,solid,
   melee,radar,teleport,
   wanim,shadow,canw,invuln:boolean;

   inapc,
   alx,aly,ald:integer;

   spr:PTUSprite;
end;

PTUnit = ^TUnit;

TPlayer = record
   name:string;
   ready:boolean;
   team,state,
   race,army,
   cenerg,menerg,_lsuc,
   o_id,nnu,wb,bld_r:byte;

   o_x0,o_y0,
   o_x1,o_y1,ttl,n_u,u0,u1,u3,u5,hptm:integer;

   alw_b,
   alw_u,
   alw_up:set of byte;

   eu:array[false..true,0.._uts] of byte;
   su:array[false..true,0.._uts] of byte;

   upgr:array[0.._uts] of byte;

   ai_defense:boolean;
   ai_skill,
   ai_minpush,
   ai_maxarmy,
   ai_partpush:byte;

   hcmp:boolean;

   nur:byte;
   nip,lg_c:cardinal;
   nport:word;
end;


TSprD = record
   d,x,y,sh:integer;
   s :psdl_Surface;
   c,ac :cardinal;
   o :single;
   h :char;
   i :byte;
   r :boolean;
   apcm,
   apcc:byte;
end;

TPoint = record
   x,y,cptt:integer;
   mx,my,p:byte;
end;



