program helloworld;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  Windows,
  yocto_api,
  yocto_power;

Procedure  Usage();
  var
    exe : string;
  begin
    exe:= ExtractFileName(paramstr(0));
    WriteLn(exe+' <serial_number>');
    WriteLn(exe+' <logical_name>');
    WriteLn(exe+' any');
    sleep(2500);
    halt;
  End;

var
  sensor : TYPower;
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
      // try to find  the first Power sensor available
      sensor := yFirstPower();
      if sensor=nil then
         begin
           writeln('No module connected (check USB cable)');
           halt;
         end
       end
   else  // or use the one specified on the commande line
    sensor:= YFindPower(paramstr(1)+'.power');

  // let's poll
  done := false;
  repeat
    if (sensor.isOnline()) then
     begin
       Write('Current Power: '+FloatToStr(sensor.get_currentValue())+' W');
       Writeln('   (press Ctrl-C to exit)');
       Sleep(1000);
     end
    else
     begin
       Writeln('Module not connected (check identification and USB cable)');
       done := true;
     end;
  until done;
  yFreeAPI();

end.