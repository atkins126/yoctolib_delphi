program helloworld;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  Windows,
  yocto_api,
  yocto_weighscale;

Procedure  Usage();
  var
   exe : string;

  begin
    exe:= ExtractFileName(paramstr(0));
    WriteLn(exe+' <serial_number>');
    WriteLn(exe+' <logical_name>');
    WriteLn(exe+' any');
    sleep(3000);
    halt;
  End;

var
  sensor : TYWeighScale;
  errmsg : string;
  sensorUnit : string;

begin

  if (paramcount<1) then usage();

  // Setup the API to use local USB devices
  if yRegisterHub('usb', errmsg)<>YAPI_SUCCESS then
  begin
    Write('RegisterHub error: '+errmsg);
    halt;
  end;

  if paramstr(1)='any' then
    begin
      sensor := yFirstWeighScale();
      if sensor=nil then
         begin
           writeln('No module connected (check USB cable)');
           halt;
         end
      end
  else
    sensor:= yFindWeighScale(paramstr(1)+'.WeighScale');

  if sensor.isOnline() then 
    begin
      // On startup, enable excitation and tare weigh scale
      Writeln('Resetting tare weight...');
      sensor.set_excitation(Y_EXCITATION_AC);
      ySleep(3000);
      sensor.tare();
      sensorUnit := sensor.get_unit();
    end

  // Show measured weight continuously
  while sensor.isOnline() do
    begin
      Write('Weight : '+FloatToStr(sensor.get_currentValue())+sensorUnit);
      Writeln('   (press Ctrl-C to exit)');
      ySleep(1000);
    end;
  yFreeAPI();
  Writeln('Module not connected (check identification and USB cable)');
end.