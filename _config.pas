

procedure cfg_setval(vr,vl:string);
var vlb:word;
begin
   vlb:=s2w(vl);

   if (vr='name' )then PlayerName  := vl;
   if (vr='sndv' )then snd_svolume := vlb;
   if (vr='mscv' )then snd_mvolume := vlb;
   if (vr='vspd' )then vid_vms     := vlb;
   if (vr='fscr' )then _fscr       := (vl=b2pm[false]);
   if (vr='vmm'  )then vid_vmm     := (vl=b2pm[true]);
   if (vr='sport')then net_sv_pstr := vl;
   if (vr='saddr')then net_cl_svstr:= vl;
   if (vr='pnu'  )then PlayerNUnits:= vlb;
   if (vr='lng'  )then _lng        := (vl=b2pm[true]);
   if (vr='mai'  )then _ma_inv     := (vl=b2pm[true]);

   //if (vr='wide' )then vid_wide    := (vl=b2pm[true]);
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

      if(PlayerNUnits<PNU_min)then PlayerNUnits:= PNU_min;
   end;
   swLNG;

   net_cl_saddr;
   net_sv_sport;
end;

procedure cfg_write;
var f:text;
begin
   assign(f,cfgfn);
   {$I-}rewrite(f);{$I+} if (ioresult<>0) then exit;

   writeln(f,'sndv' ,'=',snd_svolume);
   writeln(f,'mscv' ,'=',snd_mvolume);
   writeln(f,'name' ,'=',PlayerName);
   writeln(f,'fscr' ,'=',b2pm[_fscr]);
   writeln(f,'vspd' ,'=',vid_vms);
   writeln(f,'vmm'  ,'=',b2pm[vid_vmm]);
   writeln(f,'sport','=',net_sv_pstr);
   writeln(f,'saddr','=',net_cl_svstr);
   writeln(f,'pnu'  ,'=',PlayerNUnits);
   writeln(f,'lng'  ,'=',b2pm[_lng]);
   writeln(f,'mai'  ,'=',b2pm[_ma_inv]);

   //writeln(f,'wide' ,'=',b2pm[vid_wide]);

   close(f);
end;



