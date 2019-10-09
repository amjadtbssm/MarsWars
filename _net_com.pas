

procedure net_clearbuffer;
begin
   net_buf^.len:=0;
end;



function _initSocket:boolean;
begin
   _initSocket:=false;

   net_buf:=SDLNet_AllocPacket(MaxNetBuffer);
   if (net_buf=nil) then
   begin
      WriteError;
      exit;
   end;

   if(net_cl_con)then net_socket:=SDLNet_UDP_Open(0) else
    if(net_sv_up)then net_socket:=SDLNet_UDP_Open(net_sv_port);
   if (net_socket=nil) then
   begin
      WriteError;
      exit;
   end;

   _initSocket:=true;
end;

function initNET:boolean;
begin
   initNET:=(SDLNet_Init=0);
   if(initNet=false)then WriteError;
end;

////////////////////////////////////////////////////////////////////////////////

procedure net_send(ip:cardinal; port:word);
begin
   net_buf^.address.host:=ip;
   net_buf^.address.port:=port;
   SDLNet_UDP_Send(net_socket,-1,net_buf)
end;


function net_receive:integer;
begin
   net_clearbuffer;
   net_receive:=SDLNet_UDP_Recv(net_Socket,net_buf);
   net_buf^.len:=0;
end;

// READ

function net_readbyte:byte;
begin
   net_readbyte:=0;
   if (net_buf^.len<=MaxNetBuffer) then
   begin
      net_readbyte:=(net_buf^.data+net_buf^.len)^;
      inc(net_buf^.len,1);
   end
end;

function net_readchar:char;
begin
   net_readchar:=chr(net_readbyte);
end;

function net_readbool:boolean;
begin
   net_readbool:=(net_readbyte>0);
end;

function net_readint:integer;
begin
   net_readint:=0;
   if (net_buf^.len<MaxNetBuffer) then
   begin
      move((net_buf^.data+net_buf^.len)^, (@net_readint)^, 2);
      inc(net_buf^.len,2);
   end
end;


function net_readcard:cardinal;
begin
   net_readcard:=0;
   if (net_buf^.len<(MaxNetBuffer-2)) then
   begin
      move((net_buf^.data+net_buf^.len)^, (@net_readcard)^, 4);
      inc(net_buf^.len,4);
   end
end;

function net_readstring:string;
var sl:integer;
begin
   net_readstring:='';
   sl:=net_readbyte;
   if ((net_buf^.len+sl)>MaxNetBuffer) then sl:=MaxNetBuffer-net_buf^.len;
   while (sl>0) do
   begin
      net_readstring:=net_readstring+net_readchar;
      Dec(sl,1);
   end;
end;

// WRITE       /////////////////////////////////////////////////////////////////

procedure net_writebyte(b:byte);
begin
   if (net_buf^.len<=MaxNetBuffer) then
   begin
      (net_buf^.data+net_buf^.len)^:=b;
      Inc(net_buf^.len,1);
   end;
end;

procedure net_writechar(b:char);
begin
   net_writebyte(ord(b));
end;

procedure net_writebool(b:boolean);
begin
   if b
   then net_writebyte(1)
   else net_writebyte(0);
end;

procedure net_writeint(b:integer);
begin
   if (net_buf^.len<MaxNetBuffer) then
   begin
      move( (@b)^, (net_buf^.data+net_buf^.len  )^,2 );
      Inc(net_buf^.len,2);
   end;
end;

procedure net_writecard(b:cardinal);
begin
   if (net_buf^.len<(MaxNetBuffer-2)) then
   begin
      move( (@b)^, (net_buf^.data+net_buf^.len  )^,4 );
      Inc(net_buf^.len,4);
   end;
end;

procedure net_writestring(s:string);
var sl,x:byte;
begin
   sl:=length(s);
   x:=1;

   net_writebyte(sl);

   while (net_buf^.len<=MaxNetBuffer)and(x<=sl) do
   begin
      net_writechar(s[x]);
      Inc(x,1);
   end;
end;

////////////////

procedure _net_writeupgrs(p:byte);
begin
   with _players[p] do
    net_writebyte(upgr[0] + (upgr[1] shl 1) + (upgr[2] shl 2) + (upgr[3] shl 3) + (upgr[4] shl 4) + (upgr[5] shl 5) + (upgr[6] shl 6) + (upgr[7] shl 7) );
end;

procedure _net_readupgrs(p:byte);
var i:byte;
begin
   with _players[p] do
   begin
      i:=net_readbyte;
      upgr[7]:=(i shr 7) and 1;
      upgr[6]:=(i shr 6) and 1;
      upgr[5]:=(i shr 5) and 1;
      upgr[4]:=(i shr 4) and 1;
      upgr[3]:=(i shr 3) and 1;
      upgr[2]:=(i shr 2) and 1;
      upgr[1]:=(i shr 1) and 1;
      upgr[0]:=(i shr 0) and 1;
   end;
end;

/////////

function net_LastinIP:cardinal;
begin
   net_LastinIP:=net_buf^.address.host;
end;

function net_LastinPort:word;
begin
   net_LastinPort:=net_buf^.address.port;
end;

////////////////////////////////////////////////////////////////////////////////

procedure _lg_c_add(msg:string);
var i:byte;
begin
   Inc(net_lg_ci,1);
   for i:=net_lg_cs-1 downto 0 do net_lg_c[i+1]:=net_lg_c[i];
   net_lg_c[0]:=msg;
   net_lg_lmt:=chat_lm_t;
   vid_mredraw:=true;
   if(ord(msg[1])<>PlayerHuman)then
   begin
      if(net_sv_up or net_cl_con)then chat_nrlm:=(_menu)and(_mmode<>mm_chat);
      PlaySNDM(snd_chat);
   end;
end;

procedure _lg_c_clear;
var i:byte;
begin
   for i:=0 to net_lg_cs do net_lg_c[i]:='';
   net_lg_ci:=0;
end;


function ip2c(s:string):cardinal;
var i,l,r:byte;
    e:array[0..3] of byte = (0,0,0,0);
begin
   r:=0;
   l:=length(s);
   if (l>0) then
    for i:=1 to l do
     if s[i]='.'
     then begin inc(r,1); if (r>3) then break; end
     else e[r]:=s2b(b2s(e[r])+s[i]);
   ip2c:=cardinal((@e)^);
end;

function c2ip(c:cardinal):string;
begin
   c2ip:=b2s(c and $FF )+'.'+b2s((c and $FF00) shr 8)+'.'+b2s((c and $FF0000) shr 16)+'.'+b2s((c and $FF000000) shr 24);
end;

procedure net_sv_sport;
begin
   net_sv_port:=s2w(net_sv_pstr);
   net_sv_pstr:=w2s(net_sv_port);
end;

procedure net_cl_saddr;
var sp,sip:string;
    i,sl:byte;
begin
   sl:=length(net_cl_svstr);

   i:=pos(':',net_cl_svstr);
   if(i=1)then
   begin
      sip:='';
      sp :=net_cl_svstr;
      delete(sp,1,i);
   end else
    if(i=sl)or(i=0) then
    begin
       sip:=net_cl_svstr;
       if(i=sl)then delete(sip,sl,1);
       sp:='0';
    end else
     begin
        sip:=copy(net_cl_svstr,1,i-1);
        sp :=copy(net_cl_svstr,i+1,sl-i);
     end;

   net_cl_svip   :=ip2c(sip);
   net_cl_svport :=swap(s2w(sp));

   net_cl_svstr:=c2ip(net_cl_svip)+':'+w2s(swap(net_cl_svport));
end;

////////////////////////////////////////////////////////////////////////////////

procedure net_cl_pause;
begin
   if(net_cl_con)then
   begin
      net_clearbuffer;
      net_writebyte(nmid_pause);
      net_send(net_cl_svip,net_cl_svport);
   end;
end;


procedure net_chatm;
begin
   if(net_cl_con)then
   begin
      net_clearbuffer;
      net_writebyte(nmid_chat);
      net_writestring(chat_m);
      net_send(net_cl_svip,net_cl_svport);
   end;
end;

procedure net_swapp(p1:byte);
begin
   if(net_cl_con)then
   begin
      net_clearbuffer;
      net_writebyte(nmid_swapp);
      net_writebyte(p1);
      net_send(net_cl_svip,net_cl_svport);
   end;
end;

procedure _disposeNet;
begin

   if(net_buf<>nil)then
   begin
      SDLNet_FreePacket(net_buf);
      net_buf:=nil;
   end;

   if(net_socket<>nil)then
   begin
      SDLNet_UDP_Close(net_socket);
      net_socket:=nil;
   end;
end;




