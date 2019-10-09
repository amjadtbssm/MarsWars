

procedure net_clearbuffer;
begin
   net_buf^.len:=0;
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

function _initSocket:boolean;
begin
   _initSocket:=false;

   net_buf:=SDLNet_AllocPacket(MaxNetBuffer);
   if (net_buf=nil) then exit;

   net_socket:=SDLNet_UDP_Open(net_sv_port);
   if (net_socket=nil) then exit;

   _initSocket:=true;
end;

function initNET:boolean;
begin
   initNET:=false;

   if(SDLNet_Init<>0)then
   begin
      WriteError('initNET');
      exit;
   end;
   if(_initSocket=false)then
   begin
      WriteError('_initSocket');
      exit;
   end;

   initNET:=true;
end;

////////////////////////////////////////////////////////////////////////////////

procedure net_send(ip:cardinal; port:word);
begin
//   inc(net_ct,net_buf^.len);
//   inc(net_cs,net_buf^.len);

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
end;

procedure _lg_c_clear;
var i:byte;
begin
   for i:=0 to net_lg_cs do net_lg_c[i]:='';
   net_lg_ci:=0;
end;




