
type


TMissile = record
   x,y,vx,vy,dam,vst,tar,sr,fx,fy,dir:integer;
   player,mid,mf:byte;
end;


TDoodad = record
   x,y,r,t:integer;
end;

PTDoodad = ^TDoodad;

TUnit = record
   x,y,vx,vy,mx,my,sr,
   mhits,hits,dir,r,speed,rld,vst,tar,dtar,order,vist,shield:integer;

   apcc,apcm,apcs,  
   alt,
   _uclord,uf,utp,generg,
   invis,detect,
   ucl,vis,mmr,utrain,
   paint,pains,painc,
   player,foots,ma:byte;

   inapc, 
   alx,aly,ald:integer; 

   bio,  
   sel,bld,isbuild,dsbl,solid,
   melee,radar,teleport,
   wanim,shadow,canw,invuln:boolean;
end;
PTUnit = ^TUnit;

TPlayer = record
   name:string;
   ready:boolean;
   team,state,
   race,army,
   cenerg,menerg,
   o_id,nnu,wb,bld_r,_lsuc:byte;

   o_x0,o_y0,
   o_x1,o_y1,ttl,n_u,u0,u1,u3,u5,hptm:integer;

   alw_b,
   alw_u,
   alw_up:set of byte;

   eu:array[false..true,0..7] of byte;
   su:array[false..true,0..7] of byte;

   upgr:array[0..7] of byte;

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


TPoint = record
   x,y,cptt:integer;
   mx,my,p:byte;
end; 




