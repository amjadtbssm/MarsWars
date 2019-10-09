
procedure rpl_writeunits(u:integer);
begin
   with _units[u] do
   begin
      BlockWrite(_rpls_file,hits,sizeof(hits));
      if(hits>0) then
      begin
         BlockWrite(_rpls_file,ucl,sizeof(ucl));
         if(ucl in whocaninapc)then
         begin
            BlockWrite(_rpls_file,inapc,sizeof(inapc));
            if(inapc>0)then exit;
         end;
         BlockWrite(_rpls_file,vx ,sizeof(vy));
         BlockWrite(_rpls_file,vy ,sizeof(vx));
         if(not isbuild)or((isbuild)and(utp=ut_4))then BlockWrite(_rpls_file,tar,sizeof(tar));
         if(isbuild)then BlockWrite(_rpls_file,bld,sizeof(bld));
         if(bld)and(ucl=UID_UACRadar)then
         begin
            BlockWrite(_rpls_file,rld,sizeof(rld));
            if(rld>radar_time)then
            begin
               BlockWrite(_rpls_file,mx,sizeof(mx));
               BlockWrite(_rpls_file,my,sizeof(my));
            end;
         end;
      end;
   end;
end;

procedure rpl_readunits(u:integer);
begin
   {$I-}
   _Units[0]:=_Units[u];
   with _units[u] do
   begin
      BlockRead(_rpls_file,hits,sizeof(hits));
      if(hits>0) then
      begin
         player:=(u-1)div MaxPlayerUnits;
         BlockRead(_rpls_file,ucl,sizeof(ucl)); _unit_sclass(u);
         if(ucl in whocaninapc)then
         begin
            BlockRead(_rpls_file,inapc,sizeof(inapc));
            if(inapc>0)then
            begin
               _netSetUcl(u);
               exit;
            end;
         end;
         BlockRead(_rpls_file,x ,sizeof(vy));
         BlockRead(_rpls_file,y ,sizeof(vx));
         if(not isbuild)or((isbuild)and(utp=ut_4))then BlockRead(_rpls_file,tar,sizeof(tar));
         if(isbuild)then BlockRead(_rpls_file,bld,sizeof(bld));
         if(bld)and(ucl=UID_UACRadar)then
         begin
            BlockRead(_rpls_file,rld,sizeof(rld));
            if(rld>radar_time)then
            begin
               BlockRead(_rpls_file,mx,sizeof(mx));
               BlockRead(_rpls_file,my,sizeof(my));
            end;
         end;
      end;
      if(_rpls_step>2)then
      begin
         vx:=x;
         vy:=y;
      end;
   end;
   _netSetUcl(u);
   {$I+}
end;

procedure _rpls_code;
var i,p:byte;
   fs:cardinal;
   fn:string;
begin
 if(G_Started=false)or(_rpls_rst=rpl_none)then
 begin
    if(_rpls_fileo)then
    begin
       close(_rpls_file);
       _rpls_rst  :=rpl_none;
       _rpls_fileo:=false;
    end;
 end
 else
  if(g_paused=0)then
   case _rpls_rst of
rpl_whead   :
              begin
                 if(_mmode=mm_camp)then
                 begin
                    _rpls_rst:=rpl_none;
                    exit;
                 end;

                 assign(_rpls_file,str_rpls_dir+_rpls_lrname+str_rpls_ext);
            {$I-}rewrite(_rpls_file,1);{$I+}
                 if(ioresult<>0)then
                 begin
                    _rpls_fileo:=false;
                    _rpls_rst  :=rpl_none;
                 end else
                 begin
                    _rpls_rst  :=rpl_wunits;
                    _rpls_fileo:=true;
                    _rpls_u    :=101;

                    BlockWrite(_rpls_file,Ver        ,SizeOf(Ver));
                    BlockWrite(_rpls_file,map_seed   ,SizeOf(map_seed));
                    BlockWrite(_rpls_file,map_mw     ,SizeOf(map_mw));
                    BlockWrite(_rpls_file,map_pos    ,SizeOf(map_pos));
                    BlockWrite(_rpls_file,map_liq    ,SizeOf(map_liq));
                    BlockWrite(_rpls_file,map_obs    ,SizeOf(map_obs));
                    BlockWrite(_rpls_file,g_mode     ,SizeOf(g_mode));

                    for i:=1 to MaxPlayers do
                     with _Players[i] do
                     begin
                        BlockWrite(_rpls_file,name ,sizeof(name));
                        BlockWrite(_rpls_file,state,sizeof(state));
                        BlockWrite(_rpls_file,race ,sizeof(race));
                        BlockWrite(_rpls_file,team ,sizeof(team));
                     end;

                    BlockWrite(_rpls_file,_rpls_pnu,SizeOf(_rpls_pnu));
                 end;
              end;

rpl_wunits  : begin
                if((prdc_units mod 2)=0)then
                begin
                   BlockWrite(_rpls_file,G_Step,sizeof(G_Step));

                   if((G_Step mod vid_fps)=0)then
                   begin
                      for i:=1 to MaxPlayers do
                       with _players[i] do
                       begin
                          p:=upgr[0] + (upgr[1] shl 1) + (upgr[2] shl 2) + (upgr[3] shl 3) + (upgr[4] shl 4) + (upgr[5] shl 5) + (upgr[6] shl 6) + (upgr[7] shl 7);
                          BlockWrite(_rpls_file, p,1);
                       end;

                      if(g_mode=gm_inv)then
                      begin
                         BlockWrite(_rpls_file,g_inv_w,sizeof(g_inv_w));
                         BlockWrite(_rpls_file,g_inv_t,sizeof(g_inv_t));
                      end;
                      if(g_mode=gm_ct)then
                       for i:=1 to MaxPlayers do
                        BlockWrite(_rpls_file,g_pt[i].p,sizeof(g_pt[i].p));
                   end;

                   if(_rpls_u<101)then _rpls_u:=101;
                   if(_rpls_u>MaxUnits)then _rpls_u:=101;

                   BlockWrite(_rpls_file,_rpls_u,sizeof(_rpls_u));

                   for i:=1 to _rpls_pnu do
                   begin
                      inc(_rpls_u,1);

                      if(_rpls_u<101)then _rpls_u:=101;
                      if(_rpls_u>MaxUnits)then _rpls_u:=101;

                      rpl_writeunits(_rpls_u);

                      if(g_mode=gm_inv)then
                       if(_rpls_u=101)then
                        for p:=1 to inv_mon do rpl_writeunits(p);
                   end;
                end;
              end;

rpl_rhead   : begin
                 fn:=str_rpls_dir+_rpls_lst[_rpls_sm]+str_rpls_ext;

                 if(not FileExists(fn))then
                 begin
                    _rpls_rst  :=rpl_none;
                    g_started  :=false;
                    _rpls_stat:=str_svld_errors[1];
                    exit;
                 end;

                 assign(_rpls_file,fn);
            {$I-}reset(_rpls_file,1);{$I+}
                 if(ioresult<>0)then
                 begin
                    _rpls_fileo:=false;
                    _rpls_rst  :=rpl_none;
                    g_started  :=false;
                    _rpls_stat:=str_svld_errors[2];
                 end else
                 begin
                    fs:=FileSize(_rpls_file);

                    if(fs<rpl_size)then
                    begin
                       _rpls_fileo:=false;
                       _rpls_rst  :=rpl_none;
                       g_started  :=false;
                       _rpls_stat:=str_svld_errors[3];
                       exit;
                    end;

                    BlockRead(_rpls_file,i,SizeOf(Ver));

                    if(i<>Ver)then
                    begin
                       _rpls_fileo:=false;
                       _rpls_rst  :=rpl_none;
                       g_started  :=false;
                       close(_rpls_file);
                       _rpls_stat:=str_svld_errors[4];
                    end
                    else
                    begin
                       DefGameObjects;

                       BlockRead(_rpls_file,map_seed ,SizeOf(map_seed));
                       BlockRead(_rpls_file,map_mw   ,SizeOf(map_mw));
                       BlockRead(_rpls_file,map_pos  ,SizeOf(map_pos));
                       BlockRead(_rpls_file,map_liq  ,SizeOf(map_liq));
                       BlockRead(_rpls_file,map_obs  ,SizeOf(map_obs));
                       BlockRead(_rpls_file,g_mode   ,SizeOf(g_mode));

                       for i:=1 to MaxPlayers do
                        with _Players[i] do
                        begin
                           BlockRead(_rpls_file,name ,sizeof(name));
                           BlockRead(_rpls_file,state,sizeof(state));
                           BlockRead(_rpls_file,race ,sizeof(race));
                           BlockRead(_rpls_file,team ,sizeof(team));
                        end;

                       BlockRead(_rpls_file,_rpls_pnu,SizeOf(_rpls_pnu));    //1048

                       UnitStepNumNet:=trunc(CLUnits/_rpls_pnu)*2;
                       PlayerHuman:=0;
                       with _Players[0] do race:=r_hell;

                       _rpls_fileo:=true;
                       _rpls_rst  :=rpl_runits;

                       g_lqttrt;
                       MakeTerrain;
                       MakeLiquid;
                       CalcMapVars;
                       SkirmishStarts;
                       g_MakeMap;
                       _view_bounds;
                       G_Started:=true;
                       _menu:=false;
                       onlySVCode:=false;

                       _moveView:=false;
                    end;
                 end;
              end;

rpl_runits  : begin
                if((prdc_units mod 2)=0)then
                begin
                   {$I-}

                   if(eof(_rpls_file)or(ioresult<>0))then
                   begin
                      _rpls_fileo:=false;
                      _rpls_rst:=rpl_rend;
                      close(_rpls_file);
                      G_Paused:=1;
                      _fsttime:=false;
                      exit;
                   end;

                   while (_rpls_step>0) do
                   begin
                   BlockRead(_rpls_file,G_Step,sizeof(G_Step));

                   if((G_Step mod vid_fps)=0)then
                   begin
                      for i:=1 to MaxPlayers do
                      begin
                         BlockRead(_rpls_file, p,1);
                         with _players[i] do
                         begin
                            upgr[7]:=(p shr 7) and 1;
                            upgr[6]:=(p shr 6) and 1;
                            upgr[5]:=(p shr 5) and 1;
                            upgr[4]:=(p shr 4) and 1;
                            upgr[3]:=(p shr 3) and 1;
                            upgr[2]:=(p shr 2) and 1;
                            upgr[1]:=(p shr 1) and 1;
                            upgr[0]:=(p shr 0) and 1;
                         end;
                      end;
                      if(g_mode=gm_inv)then
                      begin
                         BlockRead(_rpls_file,g_inv_w,sizeof(g_inv_w));
                         BlockRead(_rpls_file,g_inv_t,sizeof(g_inv_t));
                      end;
                      if(g_mode=gm_ct)then
                       for i:=1 to MaxPlayers do
                        BlockRead(_rpls_file,g_pt[i].p,sizeof(g_pt[i].p));
                   end;

                   BlockRead(_rpls_file,_rpls_u,sizeof(_rpls_u));
                   for i:=1 to _rpls_pnu do
                   begin
                      inc(_rpls_u,1);

                      if(_rpls_u<101)then _rpls_u:=101;
                      if(_rpls_u>MaxUnits)then _rpls_u:=101;

                      rpl_readunits(_rpls_u);

                      if(g_mode=gm_inv)then
                       if(_rpls_u=101)then
                        for p:=1 to inv_mon do rpl_readunits(p);
                   end;

                   dec(_rpls_step,1);

                   end;
                   _rpls_step:=1;

                   {$I+}

                end;
              end;
rpl_rend    : begin G_Paused:=1; end;

   end;
end;


procedure _rpls_pre;
var f:file;
   vr,t:byte;
   mw:integer;
   ms:cardinal;
   fn:string;
begin
   ms:=0;
   mw:=0;
   vr:=0;
   t:=0;
   _rpls_stat:='';

   fn:=str_rpls_dir+_rpls_lst[_rpls_sm]+str_rpls_ext;
  if(_rpls_lst[_rpls_sm]<>'')then
   if(FileExists(fn))then
   begin
      assign(f,fn);
      {$I-}reset(f,1);{$I+}if(ioresult<>0)then
      begin
         _rpls_stat:=str_svld_errors[2];
         exit;
      end;
      if(FileSize(f)<rpl_size)then
      begin
         close(f);
         _rpls_stat:=str_svld_errors[3];
         exit;
      end;
      BlockRead(f,Vr,SizeOf(vr));
      if(vr=Ver)then
      begin
         BlockRead(f,ms,4); _rpls_stat:=str_map+': '+c2s(ms)+#13+' ';
         BlockRead(f,mw,SizeOf(map_mw)); _rpls_stat:=_rpls_stat+str_m_siz+i2s(mw)+#13+' ';
         BlockRead(f,vr,1);_rpls_stat:=_rpls_stat+str_m_pos+str_m_posC[vr]+#13+' ';
         BlockRead(f,vr,1);_rpls_stat:=_rpls_stat+str_m_liq+b2pm[vr>0]+#13+' ';
         BlockRead(f,vr,1);_rpls_stat:=_rpls_stat+str_m_obs+b2s(vr)+#13+' ';
         BlockRead(f,vr,1);_rpls_stat:=_rpls_stat+str_gmode[vr]+#13+#13;

         _rpls_stat:=_rpls_stat+str_players+':'+#13;

         for vr:=1 to MaxPlayers do
         begin
            BlockRead(f,fn ,sizeof(fn));
            _rpls_stat:=_rpls_stat+' '+fn;
            BlockRead(f,t,1);
            if(t=PS_none)then
            begin
               _rpls_stat:=_rpls_stat+','+str_ps_none+','+str_ps_none+#13;
               BlockRead(f,mw,2);
            end
            else
            begin
               BlockRead(f,t ,1); _rpls_stat:=_rpls_stat+','+str_race[t][1];
               BlockRead(f,t ,1); _rpls_stat:=_rpls_stat+','+b2s(t)+#13;
            end;
         end;
      end
      else _rpls_stat:=str_svld_errors[4];
      close(f);
   end else _rpls_stat:=str_svld_errors[1];
end;


procedure _rpls_sel;
begin
  if(_rpls_sm>=_rpls_lsts)
  then _rpls_stat:=''
  else if(g_started=false)then _rpls_pre;
end;

procedure _rpls_make_lst;
var Info : TSearchRec;
       s : string;
begin
   _rpls_lsts:=0;
   setlength(_rpls_lst,0);
   if(FindFirst(str_rpls_dir+'*'+str_rpls_ext,faReadonly,info)=0)then
    repeat
       s:=info.Name;
       delete(s,length(s)-3,4);
       if(s<>'')then
       begin
          setlength(_rpls_lst,_rpls_lsts+1);
          _rpls_lst[_rpls_lsts]:=s;
          Inc(_rpls_lsts,1);
       end;
    until (FindNext(info)<>0);
   FindClose(info);

   _rpls_sm:=0;
   _rpls_sel;
end;


procedure _rpls_delete;
var fn:string;
begin
   fn:=str_rpls_dir+_rpls_lst[_rpls_sm]+str_rpls_ext;
   if(FileExists(fn))then
   begin
      DeleteFile(fn);
      _rpls_make_lst;
   end;
end;









