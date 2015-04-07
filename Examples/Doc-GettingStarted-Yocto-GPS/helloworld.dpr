program helloworld;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  Windows,
  yocto_api,
  yocto_gps;

Procedure  Usage();
  var
    exe : string;
  begin
    exe:= ExtractFileName(paramstr(0));
    WriteLn(exe+' <serial_number>');
    WriteLn(exe+' <logical_name>');
    WriteLn(exe+' any');
    halt;
  End;

var
  gps : TYGps;
  errmsg : string;
  done   : boolean;

begin

  if (paramcount<1) then usage();

  // Setup the API to use local USB devices
  if yRegisterHub('usb', errmsg)<>YAPI_SUCCESS then
  begin
    Write('RegisterHub error: '+errmsg);
    exit;
  end;

  if paramstr(1)='any' then
    begin
      // try to find  the first temperature gps available
      gps := yFirstGps();
      if gps=nil then
         begin
           writeln('No module connected (check USB cable)');
           halt;
         end
       end
   else  // or use the one specified on the commande line
    gps:= YFindGps(paramstr(1)+'.temperature');

  // let's poll
  done := false;
  repeat
    if (gps.isOnline()) then
     begin
       if (gps.get_isFixed()<>Y_ISFIXED_TRUE) then
         Writeln('fixing')
       else
         writeln(gps.get_latitude()+'  '+gps.get_longitude());

       Writeln('   (press Ctrl-C to exit)');
       Sleep(1000);
     end
    else
     begin
       Writeln('Module not connected (check identification and USB cable)');
       done := true;
     end;
  until done;

end.