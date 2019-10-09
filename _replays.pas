procedure rpl_writeunits(u:integer);
begin
   with _units[u] do
   begin
      BlockWrite(_rpls_file,hits,sizeof(hits));
      if(hits>dead_hits)then
      begin
         BlockWrite(_rpls_file,uid,sizeof(uid));
         BlockWrite(_rpls_file,buff2byte(u),1);
         if(hits>0)then
         begin
            if(uid in whocanattack)then BlockWrite(_rpls_file,tar1,sizeof(tar1));
            if(uid in whocaninapc)then
            begin
               BlockWrite(_rpls_file,inapc,sizeof(inapc));
               if(inapc>0)then exit;
            end;
            BlockWrite(_rpls_file,vx ,sizeof(vy));
            BlockWrite(_rpls_file,vy ,sizeof(vx));

            if(isbuild)then
            begin
               BlockWrite(_rpls_file,bld,sizeof(bld));
               if(bld)then
               begin
                  if(uid=UID_URadar)then
                  begin
                     BlockWrite(_rpls_file,rld,sizeof(rld));
                     if(rld>=radar_time)then
                     begin
                        BlockWrite(_rpls_file,uo_x ,sizeof(uo_x));
                        BlockWrite(_rpls_file,uo_y ,sizeof(uo_y));
                     end;
                  end;
                  if(uid=UID_URocketL)then
                  begin
                     BlockWrite(_rpls_file,rld,sizeof(rld));
                     if(rld>0)then
                     begin
                        BlockWrite(_rpls_file,uo_x ,sizeof(uo_x));
                        BlockWrite(_rpls_file,uo_y ,sizeof(uo_y));
                     end;
                  end;
               end;
            end;
         end
         else
         begin
            BlockWrite(_rpls_file,vx ,sizeof(vy));
            BlockWrite(_rpls_file,vy ,sizeof(vx));
         end;
      end
   end;
end;

procedure rpl_readunits(u:integer);
var i:byte;
begin
   {$I-}
   _units[0]:=_units[u];
   with _units[u] do
   begin
      BlockRead(_rpls_file,hits,sizeof(hits));
      if(hits>dead_hits)then
      begin
         player:=(u-1)div MaxPlayerUnits;
         BlockRead(_rpls_file,uid,sizeof(uid));
         _unit_sclass(@_units[u]);
         i:=0;
         BlockRead(_rpls_file,i,1);
         byte2buff(u,i);
         if(hits>0)then
         begin
            if(uid in whocanattack)then BlockRead(_rpls_file,tar1,sizeof(tar1));
            if(uid in whocaninapc)then
            begin
               BlockRead(_rpls_file,inapc,sizeof(inapc));
               if(inapc>0)then
               begin
                  _netSetUcl(u);
                  exit;
               end;
            end;
            BlockRead(_rpls_file,x ,sizeof(x));
            BlockRead(_rpls_file,y ,sizeof(y));

            if(isbuild)then
            begin
               BlockRead(_rpls_file,bld,sizeof(bld));
               if(bld)then
               begin
                  if(uid=UID_URadar)then
                  begin
                     BlockRead(_rpls_file,rld,sizeof(rld));
                     if(rld>=radar_time)then
                     begin
                        BlockRead(_rpls_file,uo_x ,sizeof(uo_x));
                        BlockRead(_rpls_file,uo_y ,sizeof(uo_y));
                     end;
                  end;
                  if(uid=UID_URocketL)then
                  begin
                     BlockRead(_rpls_file,bld_s,sizeof(rld));
                     if(rld=0)then rld:=bld_s;
                     if(bld_s>0)then
                     begin
                        BlockRead(_rpls_file,uo_x ,sizeof(uo_x));
                        BlockRead(_rpls_file,uo_y ,sizeof(uo_y));
                     end;
                  end;
               end;
            end;
         end
         else
         begin
            BlockRead(_rpls_file,x ,sizeof(x));
            BlockRead(_rpls_file,y ,sizeof(y));
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


procedure _rpls_pre;
var   f:file;
   vr,t:byte;
     fn:string;
     mw:integer;
     wr:word;
begin
   _rpls_stat:='';

   fn:=str_rpls_dir+_rpls_l[_rpls_ls]+str_rpls_ext;
  if(_rpls_l[_rpls_ls]<>'')then
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
      vr:=0;
      BlockRead(f,vr,SizeOf(Ver));
      if(vr=Ver)then
      begin
         vr:=0;
         mw:=0;
         wr:=0;
         BlockRead(f,wr,sizeof(map_seed ));_rpls_stat:=str_map+': '+w2s(wr)+#13+' '; wr:=0;
         BlockRead(f,mw,SizeOf(map_mw   ));_rpls_stat:=_rpls_stat+str_m_siz+i2s(mw)+#13+' ';mw:=0;
         BlockRead(f,vr,sizeof(map_liq  ));_rpls_stat:=_rpls_stat+str_m_liq+str_m_liqC[vr]+#13+' ';vr:=0;
         BlockRead(f,vr,sizeof(map_obs  ));_rpls_stat:=_rpls_stat+str_m_obs+b2s(vr)+#13+' ';vr:=0;
         BlockRead(f,vr,sizeof(g_addon  ));_rpls_stat:=_rpls_stat+str_addon[vr>0]+#13+' ';vr:=0;
         BlockRead(f,vr,sizeof(g_mode   ));_rpls_stat:=_rpls_stat+str_gmode[vr]+#13+' ';vr:=0;
         BlockRead(f,vr,sizeof(g_loss   ));_rpls_stat:=_rpls_stat+str_losst[vr]+#13;vr:=0;
         BlockRead(f,vr,sizeof(g_starta ));vr:=0;
         BlockRead(f,vr,sizeof(g_onebase));vr:=0;

         _rpls_stat:=_rpls_stat+str_players+':'+#13;

         for vr:=1 to MaxPlayers do
         begin
            BlockRead(f,fn ,sizeof(fn));
            _rpls_stat:=_rpls_stat+chr(vr)+#9+#25+fn;
            t:=0;
            BlockRead(f,t,1);
            if(t=PS_none)then
            begin
               _rpls_stat:=_rpls_stat+#13;
               BlockRead(f,mw,2);
            end
            else
            begin
               BlockRead(f,t ,1); _rpls_stat:=_rpls_stat+','+str_race[t][2];
               BlockRead(f,t ,1); _rpls_stat:=_rpls_stat+','+b2s(t)+#13;
            end;
         end;
      end
      else _rpls_stat:=str_svld_errors[4];
      close(f);
   end else _rpls_stat:=str_svld_errors[1];
end;

procedure _rpls_code;
var  i:integer;
     b:byte;
     c:char;
     fn:string;
     fs,gstp:cardinal;
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
    if(G_Started)and(g_paused=0)then
     case _rpls_rst of
     rpl_whead   : begin
                      if(menu_s2=ms2_camp)then
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
                      end
                      else
                      begin
                         _rpls_rst  :=rpl_wunit;
                         _rpls_fileo:=true;
                         _rpls_u    :=101;
                         _rpls_nwrch:=true;

                         BlockWrite(_rpls_file,Ver        ,SizeOf(Ver));
                         BlockWrite(_rpls_file,map_seed   ,SizeOf(map_seed));
                         BlockWrite(_rpls_file,map_mw     ,SizeOf(map_mw));
                         BlockWrite(_rpls_file,map_liq    ,SizeOf(map_liq));
                         BlockWrite(_rpls_file,map_obs    ,SizeOf(map_obs));
                         BlockWrite(_rpls_file,g_addon    ,SizeOf(g_addon));
                         BlockWrite(_rpls_file,g_mode     ,SizeOf(g_mode));
                         BlockWrite(_rpls_file,g_loss     ,SizeOf(g_loss));
                         BlockWrite(_rpls_file,g_starta   ,SizeOf(g_starta));
                         BlockWrite(_rpls_file,g_onebase  ,SizeOf(g_onebase));

                         for i:=1 to MaxPlayers do
                          with _Players[i] do
                          begin
                             BlockWrite(_rpls_file,name ,sizeof(name));
                             BlockWrite(_rpls_file,state,sizeof(state));
                             BlockWrite(_rpls_file,race ,sizeof(race));
                             BlockWrite(_rpls_file,team ,sizeof(team));
                          end;

                         _rpls_pnu:=_rpls_pnua[_rpls_pnui];
                         BlockWrite(_rpls_file,_rpls_pnu,SizeOf(_rpls_pnu));
                      end;
                   end;
     rpl_wunit   : begin
                   if((vid_rtui mod 2)=0)then
                   begin
                      BlockWrite(_rpls_file,G_Step,sizeof(G_Step));

                      gstp:=G_Step shr 1;
                      if((gstp mod vid_fps)=0)then
                      begin
                         for i:=1 to MaxPlayers do
                          with _players[i] do BlockWrite(_rpls_file, upgr,sizeof(upgr));

                         if(g_mode=gm_inv)then
                         begin
                            BlockWrite(_rpls_file,g_inv_wn,sizeof(g_inv_wn));
                            BlockWrite(_rpls_file,g_inv_t ,sizeof(g_inv_t ));
                         end;
                         if(g_mode=gm_ct)then
                          for i:=1 to MaxPlayers do
                           BlockWrite(_rpls_file,g_ct_pl[i].pl,sizeof(g_ct_pl[i].pl));

                         BlockWrite(_rpls_file,_rpls_nwrch,sizeof(_rpls_nwrch));
                         if(_rpls_nwrch)then
                         begin
                            for i:=0 to MaxNetChat do
                            begin
                               b:=length(net_chat[i]);
                               BlockWrite(_rpls_file,b,sizeof(b));
                               while(b>0)do
                               begin
                                  c:=net_chat[i][b];
                                  BlockWrite(_rpls_file,c,sizeof(c));
                                  dec(b,1);
                               end;
                            end;
                            _rpls_nwrch:=false;
                         end;
                      end;

                      if(_rpls_u<1)then _rpls_u:=1;
                      if(_rpls_u>MaxUnits)then _rpls_u:=1;

                      BlockWrite(_rpls_file,_rpls_u,sizeof(_rpls_u));
                      for i:=1 to _rpls_pnu do
                      begin
                         inc(_rpls_u,1);

                         if(_rpls_u<1)then _rpls_u:=1;
                         if(_rpls_u>MaxUnits)then _rpls_u:=1;

                         rpl_writeunits(_rpls_u);
                      end;
                   end;
                   end;
     rpl_rhead   : begin
                      fn:=str_rpls_dir+_rpls_l[_rpls_ls]+str_rpls_ext;

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
                      end
                      else
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

                         i:=0;
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
                            BlockRead(_rpls_file,map_liq  ,SizeOf(map_liq));
                            BlockRead(_rpls_file,map_obs  ,SizeOf(map_obs));
                            BlockRead(_rpls_file,g_addon  ,SizeOf(g_addon));
                            BlockRead(_rpls_file,g_mode   ,SizeOf(g_mode));
                            BlockRead(_rpls_file,g_loss   ,SizeOf(g_loss));
                            BlockRead(_rpls_file,g_starta ,SizeOf(g_starta));
                            BlockRead(_rpls_file,g_onebase,SizeOf(g_onebase));

                            if(map_mw<3000)or(map_mw>6000)
                            or(map_liq>4)or(map_obs=0)or(map_obs>4)
                            or(g_mode>4)or(g_loss>2)or(g_starta>3)then
                            begin
                               _rpls_fileo:=false;
                               _rpls_rst  :=rpl_none;
                               g_started  :=false;
                               close(_rpls_file);
                               _rpls_stat:=str_svld_errors[4];
                               exit;
                            end;

                            for i:=1 to MaxPlayers do
                             with _Players[i] do
                             begin
                                BlockRead(_rpls_file,name ,sizeof(name));
                                BlockRead(_rpls_file,state,sizeof(state));
                                BlockRead(_rpls_file,race ,sizeof(race));
                                BlockRead(_rpls_file,team ,sizeof(team));
                             end;

                            BlockRead(_rpls_file,_rpls_pnu,SizeOf(_rpls_pnu));    //1048

                            if(_rpls_pnu=0)then _rpls_pnu:=NetTickN;
                            UnitStepNum:=trunc(MaxUnits/_rpls_pnu)*NetTickN;
                            if(UnitStepNum=0)then UnitStepNum:=1;
                            HPlayer:=0;

                            _rpls_fileo:=true;
                            _rpls_rst  :=rpl_runit;

                            Map_premap;

                            ui_tab:=2;
                            _view_bounds;
                            G_Started:=true;
                            _menu:=false;
                            onlySVCode:=false;
                         end;
                      end;
                   end;
     rpl_runit   : begin
                   if((vid_rtui mod 2)=0)then
                   begin
                        {$I-}

                        if(eof(_rpls_file)or(ioresult<>0))then
                        begin
                           _rpls_fileo:=false;
                           _rpls_rst:=rpl_end;
                           close(_rpls_file);
                           G_Paused:=1;
                           _fsttime:=false;
                           exit;
                        end;

                        if(_rpls_step=0)then _rpls_step:=1;

                        while (_rpls_step>0) do
                        begin
                        BlockRead(_rpls_file,G_Step,sizeof(G_Step));
                        gstp:=G_Step shr 1;

                        if((gstp mod vid_fps)=0)then
                        begin
                           for i:=1 to MaxPlayers do
                            with _players[i] do BlockRead(_rpls_file,upgr,sizeof(upgr));

                           if(g_mode=gm_inv)then
                           begin
                              BlockRead(_rpls_file,g_inv_wn,sizeof(g_inv_wn));
                              BlockRead(_rpls_file,g_inv_t ,sizeof(g_inv_t ));
                           end;
                           if(g_mode=gm_ct)then
                            for i:=1 to MaxPlayers do
                             BlockRead(_rpls_file,g_ct_pl[i].pl,sizeof(g_ct_pl[i].pl));

                           BlockRead(_rpls_file,_rpls_nwrch,sizeof(_rpls_nwrch));
                           if(_rpls_nwrch)then
                           begin
                              fs:=0;
                              for i:=0 to MaxNetChat do
                              begin
                                 b:=0;
                                 BlockRead(_rpls_file,b,sizeof(b));
                                 setlength(net_chat[i],b);
                                 if(b>0)then fs:=1;
                                 while(b>0)do
                                 begin
                                    c:=#1;
                                    BlockRead(_rpls_file,c,sizeof(c));
                                    net_chat[i][b]:=c;
                                    dec(b,1);
                                 end;
                              end;
                              net_chat_shlm:=chat_shlm_t;
                              vid_mredraw:=true;
                              if(fs>0)then PlaySNDM(snd_chat);
                              _rpls_nwrch:=false;
                           end;
                        end;

                        BlockRead(_rpls_file,_rpls_u,sizeof(_rpls_u));
                        for i:=1 to _rpls_pnu do
                        begin
                           inc(_rpls_u,1);

                           if(_rpls_u<1)then _rpls_u:=1;
                           if(_rpls_u>MaxUnits)then _rpls_u:=1;

                           rpl_readunits(_rpls_u);
                        end;

                        if(_rpls_step>1)then _effectsCycle(false);
                        dec(_rpls_step,1);

                        end;
                        _rpls_step:=1;

                        {$I+}

                   end;
                   end;

     rpl_end     : begin G_Paused:=1; end;
     end;

end;

procedure _rpls_sel;
begin
   if(_rpls_ls<_rpls_ln)
   then _rpls_pre
   else
     if(g_started=false)then _rpls_stat:='';
end;

procedure _rpls_make_lst;
var Info : TSearchRec;
       s : string;
begin
   _rpls_sm:=0;
   _rpls_ln:=0;
   setlength(_rpls_l,0);
   if(FindFirst(str_rpls_dir+'*'+str_rpls_ext,faReadonly,info)=0)then
    repeat
       s:=info.Name;
       delete(s,length(s)-3,4);
       if(s<>'')then
       begin
          inc(_rpls_ln,1);
          setlength(_rpls_l,_rpls_ln);
          _rpls_l[_rpls_ln-1]:=s;
       end;
    until (FindNext(info)<>0);
   FindClose(info);

   _rpls_sel;
end;

procedure _rpls_delete;
var fn:string;
begin
   fn:=str_rpls_dir+_rpls_l[_rpls_ls]+str_rpls_ext;
   if(FileExists(fn))then
   begin
      DeleteFile(fn);
      _rpls_make_lst;
   end;
end;


