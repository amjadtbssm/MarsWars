

procedure cfg_setval(vr,vl:string);
var vlb:word;
begin
   vlb:=s2w(vl);

   if (vr='name' )then PlayerName  := vl;
   if (vr='sndv' )then snd_svolume := vlb;
   if (vr='mscv' )then snd_mvolume := vlb;
   if (vr='vspd' )then vid_vmspd   := vlb;
   if (vr='fscr' )then _fscr       :=(vl=b2pm[true,2]);
   if (vr='vmm'  )then vid_vmm     :=(vl=b2pm[true,2]);
   if (vr='saddr')then net_cl_svstr:= vl;
   if (vr='lng'  )then _lng        :=(vl=b2pm[true,2]);
   if (vr='mai'  )then m_a_inv     :=(vl=b2pm[true,2]);
   if (vr='vidmw')then vid_mw      :=vlb;
   if (vr='vidmh')then vid_mh      :=vlb;
end;

procedure cfg_parse_str(s:string);
var vr,vl:string;
    i:byte;
begin
   vr:='';
   vl:='';
   i :=pos('=',s);
   vr:=copy(s,1,i-1);
   delete(s,1,i);
   vl:=s;
   cfg_setval(vr,vl);
end;

procedure cfg_read;
var f:text;
    s:string;
begin
   if(_ded)then exit;

   if FileExists(cfgfn) then
   begin
      assign(f,cfgfn);
      {$I-}reset(f);{$I+} if (ioresult<>0) then exit;
      while not eof(f) do
      begin
         readln(f,s);
         cfg_parse_str(s);
      end;
      close(f);

      if(snd_svolume>127) then snd_svolume:=127;
      if(snd_mvolume>127) then snd_mvolume:=127;

      if(length(PlayerName)>NameLen)then SetLength(PlayerName,NameLen);

      if(vid_mw<800 )then vid_mw:=800;
      if(vid_mh<600 )then vid_mh:=600;
      if(vid_mw>1024)then vid_mw:=1024;
      if(vid_mh>768 )then vid_mh:=768;
   end;
   swLNG;
   m_vrx:=vid_mw;
   m_vry:=vid_mh;
   net_cl_saddr;
end;

procedure cfg_write;
var f:text;
begin
   if(_ded)then exit;

   assign(f,cfgfn);
   {$I-}rewrite(f);{$I+} if (ioresult<>0) then exit;

   writeln(f,'sndv' ,'=',snd_svolume);
   writeln(f,'mscv' ,'=',snd_mvolume);
   writeln(f,'name' ,'=',PlayerName);
   writeln(f,'fscr' ,'=',b2pm[_fscr,2]);
   writeln(f,'vspd' ,'=',vid_vmspd);
   writeln(f,'vmm'  ,'=',b2pm[vid_vmm,2]);
   writeln(f,'saddr','=',net_cl_svstr);
   writeln(f,'lng'  ,'=',b2pm[_lng,2]);
   writeln(f,'mai'  ,'=',b2pm[m_a_inv,2]);
   writeln(f,'vidmw','=',vid_mw);
   writeln(f,'vidmh','=',vid_mh);

   close(f);
end;



