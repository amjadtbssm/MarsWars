
procedure _svld_pre;
var f:file;
   vr:byte=0;
   mw:integer;
   ms:cardinal;
   fn:string;
  pls:array[0..MaxPlayers] of TPlayer;
begin
  ms:=0;
  mw:=0;
  vr:=0;

   _svld_stat:='';

   fn:=str_svld_dir+_svld_lst[_svld_sm]+str_svld_ext;
  if(_svld_lst[_svld_sm]<>'')then
   if(FileExists(fn))then
   begin
      assign(f,fn);
      {$I-}reset(f,1);{$I+}if(ioresult<>0)then
      begin
         _svld_stat:=str_svld_errors[2];
         exit;
      end;
      if(FileSize(f)<>svld_size)then
      begin
         close(f);
         _svld_stat:=str_svld_errors[3];
         exit;
      end;
      BlockRead(f,Vr,SizeOf(vr));
      if(vr=Ver)then
      begin
         BlockRead(f,vr,1);
         if(vr=mm_camp)then
         begin
            BlockRead(f,vr,1);
            _svld_stat:=str_cmp_mn[vr];
         end
         else
         begin
            BlockRead(f,vr,1);

            BlockRead(f,ms,4);_svld_stat:=str_map+': '+c2s(ms)+#13+' ';
            BlockRead(f,mw,2);_svld_stat:=_svld_stat+str_m_siz+i2s(mw)+#13+' ';
            BlockRead(f,vr,1);_svld_stat:=_svld_stat+str_m_pos+str_m_posC[vr]+#13+' ';
            BlockRead(f,vr,1);_svld_stat:=_svld_stat+str_m_liq+b2pm[vr>0]+#13+' ';
            BlockRead(f,vr,2);
            BlockRead(f,vr,1);_svld_stat:=_svld_stat+str_m_obs+b2s(vr)+#13+' ';
            BlockRead(f,vr,1);_svld_stat:=_svld_stat+str_gmode[vr]+#13+#13;

            BlockRead(f,pls,SizeOf(pls));

            _svld_stat:=_svld_stat+str_players+':'+#13;

            for vr:=1 to MaxPlayers do
            begin
               _svld_stat:=_svld_stat+' '+pls[vr].name;
               if(pls[vr].state<>PS_None)
               then _svld_stat:=_svld_stat+','+str_race[pls[vr].race][1]+','+b2s(pls[vr].team)+#13
               else _svld_stat:=_svld_stat+','+str_ps_none+','+str_ps_none+#13;
            end;
         end;
      end
      else _svld_stat:=str_svld_errors[4];
      close(f);
   end else _svld_stat:=str_svld_errors[1];
end;

procedure _svld_sel;
begin
  if(_svld_sm<_svld_lsts)then
  begin
     _svld_str:=_svld_lst[_svld_sm];
     _svld_pre;
  end else
  begin
     _svld_str :='';
     _svld_stat:='';
  end;
end;

procedure _svld_make_lst;
var Info : TSearchRec;
       s : string;
begin
   _svld_lsts:=0;
   setlength(_svld_lst,0);
   if FindFirst(str_svld_dir+'*'+str_svld_ext,faReadonly,info)=0 then
    repeat
       s:=info.Name;
       delete(s,length(s)-3,4);
       if(s<>'')then
       begin
          setlength(_svld_lst,_svld_lsts+1);
          _svld_lst[_svld_lsts]:=s;
          Inc(_svld_lsts,1);
       end;
    until (FindNext(info)<>0);
   FindClose(info);

   _svld_sm:=0;
   _svld_sel;
end;

{
ver
_mmode
_mcmp_sm
map_seed
map_mw
map_lqt
map_trt
map_obs
_TvsB
_players
_units
_missiles
_effects
map_dds
vid_vx
vid_vy
p_colors
G_Step
PlayerHuman
prdc_units
m_sbuild
cmp_portal
cmp_hellagr
g_inv_t
g_inv_w
g_pt
ai_bx
ai_by
}

procedure _svld_save;
var f:file;
begin
   assign(f,str_svld_dir+_svld_str+str_svld_ext);
   {$I-}rewrite(f,1);{$I+} if (ioresult<>0) then exit;

   BlockWrite(f,Ver,SizeOf(ver));

   BlockWrite(f,_mmode     ,SizeOf(_mmode));
   BlockWrite(f,_mcmp_sm   ,SizeOf(_mcmp_sm));
   BlockWrite(f,map_seed   ,SizeOf(map_seed));
   BlockWrite(f,map_mw     ,SizeOf(map_mw));
   BlockWrite(f,map_pos    ,SizeOf(map_pos));
   BlockWrite(f,map_liq    ,SizeOf(map_liq));
   BlockWrite(f,map_lqt    ,SizeOf(map_lqt));
   BlockWrite(f,map_trt    ,SizeOf(map_trt));
   BlockWrite(f,map_obs    ,SizeOf(map_obs));
   BlockWrite(f,g_mode     ,SizeOf(g_mode));
   BlockWrite(f,_players   ,SizeOf(_players));
   BlockWrite(f,_units     ,SizeOf(_units));
   BlockWrite(f,_missiles  ,SizeOf(_missiles));
   BlockWrite(f,_effects   ,SizeOf(_effects));
   BlockWrite(f,map_dds    ,SizeOf(map_dds));
   BlockWrite(f,vid_vx     ,SizeOf(vid_vx)); ;
   BlockWrite(f,vid_vy     ,SizeOf(vid_vy));
   BlockWrite(f,p_colors   ,SizeOf(p_colors));
   BlockWrite(f,G_Step     ,SizeOf(G_Step));
   BlockWrite(f,PlayerHuman,SizeOf(PlayerHuman));
   BlockWrite(f,prdc_units ,SizeOf(prdc_units));
   BlockWrite(f,m_sbuild   ,SizeOf(m_sbuild));
   BlockWrite(f,cmp_portal ,SizeOf(cmp_portal));
   BlockWrite(f,cmp_hellagr,SizeOf(cmp_hellagr));
   BlockWrite(f,g_inv_t    ,SizeOf(g_inv_t));
   BlockWrite(f,g_inv_w    ,SizeOf(g_inv_w));
   BlockWrite(f,g_pt       ,SizeOf(g_pt));
   BlockWrite(f,ai_bx      ,SizeOf(ai_bx));
   BlockWrite(f,ai_by      ,SizeOf(ai_by));

   close(f);
   _menu:=false;
   g_paused:=0;
   _svld_make_lst;

   net_lg_c[0]:=chr(PlayerHuman)+str_gsaved;
   net_lg_lmt:=vid_fps*3;
end;

procedure _svld_load;
var f:file;
   fn:string;
   vr:byte=0;
begin
   fn:=str_svld_dir+_svld_lst[_svld_sm]+str_svld_ext;
  if(_svld_lst[_svld_sm]<>'')then
   if(FileExists(fn))then
   begin
      assign(f,fn);
      {$I-}reset(f,1);{$I+} if (ioresult<>0) then exit;
      if(FileSize(f)<>svld_size)then begin close(f); exit; end;
      BlockRead(f,Vr,SizeOf(vr));
      if(vr=Ver)then
      begin
         DefGameObjects;

         BlockRead(f,_mmode     ,SizeOf(_mmode));
         BlockRead(f,_mcmp_sm   ,SizeOf(_mcmp_sm));
         BlockRead(f,map_seed   ,SizeOf(map_seed));
         BlockRead(f,map_mw     ,SizeOf(map_mw));
         BlockRead(f,map_pos    ,SizeOf(map_pos));
         BlockRead(f,map_liq    ,SizeOf(map_liq));
         BlockRead(f,map_lqt    ,SizeOf(map_lqt));
         BlockRead(f,map_trt    ,SizeOf(map_trt));
         BlockRead(f,map_obs    ,SizeOf(map_obs));
         BlockRead(f,g_mode     ,SizeOf(g_mode));
         BlockRead(f,_players   ,SizeOf(_players));
         BlockRead(f,_units     ,SizeOf(_units));
         BlockRead(f,_missiles  ,SizeOf(_missiles));
         BlockRead(f,_effects   ,SizeOf(_effects));
         BlockRead(f,map_dds    ,SizeOf(map_dds));
         BlockRead(f,vid_vx     ,SizeOf(vid_vx)); ;
         BlockRead(f,vid_vy     ,SizeOf(vid_vy));
         BlockRead(f,p_colors   ,SizeOf(p_colors));
         BlockRead(f,G_Step     ,SizeOf(G_Step));
         BlockRead(f,PlayerHuman,SizeOf(PlayerHuman));
         BlockRead(f,prdc_units ,SizeOf(prdc_units));
         BlockRead(f,m_sbuild   ,SizeOf(m_sbuild));
         BlockRead(f,cmp_portal ,SizeOf(cmp_portal));
         BlockRead(f,cmp_hellagr,SizeOf(cmp_hellagr));
         BlockRead(f,g_inv_t    ,SizeOf(g_inv_t));
         BlockRead(f,g_inv_w    ,SizeOf(g_inv_w));
         BlockRead(f,g_pt       ,SizeOf(g_pt));
         BlockRead(f,ai_bx      ,SizeOf(ai_bx));
         BlockRead(f,ai_by      ,SizeOf(ai_by));

         CalcMapVars;
         SkirmishStarts;
         MakeTerrain;
         MakeLiquid;

         boxColor(spr_m_back,90,128,233,271,c_black);
         sdl_FillRect(vid_minimap,nil,0);
         _dds_p(true);
         _drawStarts;
         _draw_surf(spr_m_back,91,129,vid_minimap);

         _view_bounds;
         G_Started:=true;
         _menu:=false;

      end;
      close(f);
   end;
end;

procedure _svld_delete;
var fn:string;
begin
   fn:=str_svld_dir+_svld_lst[_svld_sm]+str_svld_ext;
   if(FileExists(fn))then
   begin
      DeleteFile(fn);
      _svld_make_lst;
   end;
end;





