{*********************************************************************
 *
 * $Id: yocto_bluetoothlink.pas 20644 2015-06-12 16:04:33Z seb $
 *
 * Implements yFindBluetoothLink(), the high-level API for BluetoothLink functions
 *
 * - - - - - - - - - License information: - - - - - - - - - 
 *
 *  Copyright (C) 2011 and beyond by Yoctopuce Sarl, Switzerland.
 *
 *  Yoctopuce Sarl (hereafter Licensor) grants to you a perpetual
 *  non-exclusive license to use, modify, copy and integrate this
 *  file into your software for the sole purpose of interfacing
 *  with Yoctopuce products.
 *
 *  You may reproduce and distribute copies of this file in
 *  source or object form, as long as the sole purpose of this
 *  code is to interface with Yoctopuce products. You must retain
 *  this notice in the distributed source file.
 *
 *  You should refer to Yoctopuce General Terms and Conditions
 *  for additional information regarding your rights and
 *  obligations.
 *
 *  THE SOFTWARE AND DOCUMENTATION ARE PROVIDED 'AS IS' WITHOUT
 *  WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING 
 *  WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY, FITNESS
 *  FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO
 *  EVENT SHALL LICENSOR BE LIABLE FOR ANY INCIDENTAL, SPECIAL,
 *  INDIRECT OR CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA,
 *  COST OF PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR 
 *  SERVICES, ANY CLAIMS BY THIRD PARTIES (INCLUDING BUT NOT 
 *  LIMITED TO ANY DEFENSE THEREOF), ANY CLAIMS FOR INDEMNITY OR
 *  CONTRIBUTION, OR OTHER SIMILAR COSTS, WHETHER ASSERTED ON THE
 *  BASIS OF CONTRACT, TORT (INCLUDING NEGLIGENCE), BREACH OF
 *  WARRANTY, OR OTHERWISE.
 *
 *********************************************************************}


unit yocto_bluetoothlink;

interface

uses
  sysutils, classes, windows, yocto_api, yjson;

//--- (YBluetoothLink definitions)

const Y_OWNADDRESS_INVALID            = YAPI_INVALID_STRING;
const Y_PAIRINGPIN_INVALID            = YAPI_INVALID_STRING;
const Y_REMOTEADDRESS_INVALID         = YAPI_INVALID_STRING;
const Y_REMOTENAME_INVALID            = YAPI_INVALID_STRING;
const Y_MUTE_FALSE = 0;
const Y_MUTE_TRUE = 1;
const Y_MUTE_INVALID = -1;
const Y_PREAMPLIFIER_INVALID          = YAPI_INVALID_UINT;
const Y_VOLUME_INVALID                = YAPI_INVALID_UINT;
const Y_LINKSTATE_DOWN = 0;
const Y_LINKSTATE_FREE = 1;
const Y_LINKSTATE_SEARCH = 2;
const Y_LINKSTATE_EXISTS = 3;
const Y_LINKSTATE_LINKED = 4;
const Y_LINKSTATE_PLAY = 5;
const Y_LINKSTATE_INVALID = -1;
const Y_LINKQUALITY_INVALID           = YAPI_INVALID_UINT;
const Y_COMMAND_INVALID               = YAPI_INVALID_STRING;


//--- (end of YBluetoothLink definitions)

type
  TYBluetoothLink = class;
  //--- (YBluetoothLink class start)
  TYBluetoothLinkValueCallback = procedure(func: TYBluetoothLink; value:string);
  TYBluetoothLinkTimedReportCallback = procedure(func: TYBluetoothLink; value:TYMeasure);

  ////
  /// <summary>
  ///   TYBluetoothLink Class: BluetoothLink function interface
  /// <para>
  ///   BluetoothLink function provides control over bluetooth link
  ///   and status for devices that are bluetooth-enabled.
  /// </para>
  /// </summary>
  ///-
  TYBluetoothLink=class(TYFunction)
  //--- (end of YBluetoothLink class start)
  protected
  //--- (YBluetoothLink declaration)
    // Attributes (function value cache)
    _logicalName              : string;
    _advertisedValue          : string;
    _ownAddress               : string;
    _pairingPin               : string;
    _remoteAddress            : string;
    _remoteName               : string;
    _mute                     : Integer;
    _preAmplifier             : LongInt;
    _volume                   : LongInt;
    _linkState                : Integer;
    _linkQuality              : LongInt;
    _command                  : string;
    _valueCallbackBluetoothLink : TYBluetoothLinkValueCallback;
    // Function-specific method for reading JSON output and caching result
    function _parseAttr(member:PJSONRECORD):integer; override;

    //--- (end of YBluetoothLink declaration)

  public
    //--- (YBluetoothLink accessors declaration)
    constructor Create(func:string);

    ////
    /// <summary>
    ///   Returns the MAC-48 address of the bluetooth interface, which is unique on the bluetooth network.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a string corresponding to the MAC-48 address of the bluetooth interface, which is unique on the
    ///   bluetooth network
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_OWNADDRESS_INVALID</c>.
    /// </para>
    ///-
    function get_ownAddress():string;

    ////
    /// <summary>
    ///   Returns an opaque string if a PIN code has been configured in the device to access
    ///   the SIM card, or an empty string if none has been configured or if the code provided
    ///   was rejected by the SIM card.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a string corresponding to an opaque string if a PIN code has been configured in the device to access
    ///   the SIM card, or an empty string if none has been configured or if the code provided
    ///   was rejected by the SIM card
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_PAIRINGPIN_INVALID</c>.
    /// </para>
    ///-
    function get_pairingPin():string;

    ////
    /// <summary>
    ///   Changes the PIN code used by the module for bluetooth pairing.
    /// <para>
    ///   Remember to call the <c>saveToFlash()</c> method of the module to save the
    ///   new value in the device flash.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   a string corresponding to the PIN code used by the module for bluetooth pairing
    /// </param>
    /// <para>
    /// </para>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function set_pairingPin(newval:string):integer;

    ////
    /// <summary>
    ///   Returns the MAC-48 address of the remote device to connect to.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a string corresponding to the MAC-48 address of the remote device to connect to
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_REMOTEADDRESS_INVALID</c>.
    /// </para>
    ///-
    function get_remoteAddress():string;

    ////
    /// <summary>
    ///   Changes the MAC-48 address defining which remote device to connect to.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   a string corresponding to the MAC-48 address defining which remote device to connect to
    /// </param>
    /// <para>
    /// </para>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function set_remoteAddress(newval:string):integer;

    ////
    /// <summary>
    ///   Returns the bluetooth name the remote device, if found on the bluetooth network.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a string corresponding to the bluetooth name the remote device, if found on the bluetooth network
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_REMOTENAME_INVALID</c>.
    /// </para>
    ///-
    function get_remoteName():string;

    ////
    /// <summary>
    ///   Returns the state of the mute function.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   either <c>Y_MUTE_FALSE</c> or <c>Y_MUTE_TRUE</c>, according to the state of the mute function
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_MUTE_INVALID</c>.
    /// </para>
    ///-
    function get_mute():Integer;

    ////
    /// <summary>
    ///   Changes the state of the mute function.
    /// <para>
    ///   Remember to call the matching module
    ///   <c>saveToFlash()</c> method to save the setting permanently.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   either <c>Y_MUTE_FALSE</c> or <c>Y_MUTE_TRUE</c>, according to the state of the mute function
    /// </param>
    /// <para>
    /// </para>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function set_mute(newval:Integer):integer;

    ////
    /// <summary>
    ///   Returns the audio pre-amplifier volume, in per cents.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   an integer corresponding to the audio pre-amplifier volume, in per cents
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_PREAMPLIFIER_INVALID</c>.
    /// </para>
    ///-
    function get_preAmplifier():LongInt;

    ////
    /// <summary>
    ///   Changes the audio pre-amplifier volume, in per cents.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   an integer corresponding to the audio pre-amplifier volume, in per cents
    /// </param>
    /// <para>
    /// </para>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function set_preAmplifier(newval:LongInt):integer;

    ////
    /// <summary>
    ///   Returns the connected headset volume, in per cents.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   an integer corresponding to the connected headset volume, in per cents
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_VOLUME_INVALID</c>.
    /// </para>
    ///-
    function get_volume():LongInt;

    ////
    /// <summary>
    ///   Changes the connected headset volume, in per cents.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   an integer corresponding to the connected headset volume, in per cents
    /// </param>
    /// <para>
    /// </para>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function set_volume(newval:LongInt):integer;

    ////
    /// <summary>
    ///   Returns the bluetooth link state.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a value among <c>Y_LINKSTATE_DOWN</c>, <c>Y_LINKSTATE_FREE</c>, <c>Y_LINKSTATE_SEARCH</c>,
    ///   <c>Y_LINKSTATE_EXISTS</c>, <c>Y_LINKSTATE_LINKED</c> and <c>Y_LINKSTATE_PLAY</c> corresponding to
    ///   the bluetooth link state
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_LINKSTATE_INVALID</c>.
    /// </para>
    ///-
    function get_linkState():Integer;

    ////
    /// <summary>
    ///   Returns the bluetooth receiver signal strength, in pourcents, or 0 if no connection is established.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   an integer corresponding to the bluetooth receiver signal strength, in pourcents, or 0 if no
    ///   connection is established
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_LINKQUALITY_INVALID</c>.
    /// </para>
    ///-
    function get_linkQuality():LongInt;

    function get_command():string;

    function set_command(newval:string):integer;

    ////
    /// <summary>
    ///   Retrieves $AFUNCTION$ for a given identifier.
    /// <para>
    ///   The identifier can be specified using several formats:
    /// </para>
    /// <para>
    /// </para>
    /// <para>
    ///   - FunctionLogicalName
    /// </para>
    /// <para>
    ///   - ModuleSerialNumber.FunctionIdentifier
    /// </para>
    /// <para>
    ///   - ModuleSerialNumber.FunctionLogicalName
    /// </para>
    /// <para>
    ///   - ModuleLogicalName.FunctionIdentifier
    /// </para>
    /// <para>
    ///   - ModuleLogicalName.FunctionLogicalName
    /// </para>
    /// <para>
    /// </para>
    /// <para>
    ///   This function does not require that $THEFUNCTION$ is online at the time
    ///   it is invoked. The returned object is nevertheless valid.
    ///   Use the method <c>YBluetoothLink.isOnline()</c> to test if $THEFUNCTION$ is
    ///   indeed online at a given time. In case of ambiguity when looking for
    ///   $AFUNCTION$ by logical name, no error is notified: the first instance
    ///   found is returned. The search is performed first by hardware name,
    ///   then by logical name.
    /// </para>
    /// </summary>
    /// <param name="func">
    ///   a string that uniquely characterizes $THEFUNCTION$
    /// </param>
    /// <returns>
    ///   a <c>YBluetoothLink</c> object allowing you to drive $THEFUNCTION$.
    /// </returns>
    ///-
    class function FindBluetoothLink(func: string):TYBluetoothLink;

    ////
    /// <summary>
    ///   Registers the callback function that is invoked on every change of advertised value.
    /// <para>
    ///   The callback is invoked only during the execution of <c>ySleep</c> or <c>yHandleEvents</c>.
    ///   This provides control over the time when the callback is triggered. For good responsiveness, remember to call
    ///   one of these two functions periodically. To unregister a callback, pass a null pointer as argument.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="callback">
    ///   the callback function to call, or a null pointer. The callback function should take two
    ///   arguments: the function object of which the value has changed, and the character string describing
    ///   the new advertised value.
    /// @noreturn
    /// </param>
    ///-
    function registerValueCallback(callback: TYBluetoothLinkValueCallback):LongInt; overload;

    function _invokeValueCallback(value: string):LongInt; override;

    ////
    /// <summary>
    ///   Attempt to connect to the previously selected remote device.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> when the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function connect():LongInt; overload; virtual;

    ////
    /// <summary>
    ///   Disconnect from the previously selected remote device.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> when the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function disconnect():LongInt; overload; virtual;


    ////
    /// <summary>
    ///   Continues the enumeration of cellular interfaces started using <c>yFirstBluetoothLink()</c>.
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a pointer to a <c>YBluetoothLink</c> object, corresponding to
    ///   a cellular interface currently online, or a <c>null</c> pointer
    ///   if there are no more cellular interfaces to enumerate.
    /// </returns>
    ///-
    function nextBluetoothLink():TYBluetoothLink;
    ////
    /// <summary>
    ///   c
    /// <para>
    ///   omment from .yc definition
    /// </para>
    /// </summary>
    ///-
    class function FirstBluetoothLink():TYBluetoothLink;
  //--- (end of YBluetoothLink accessors declaration)
  end;

//--- (BluetoothLink functions declaration)
  ////
  /// <summary>
  ///   Retrieves a cellular interface for a given identifier.
  /// <para>
  ///   The identifier can be specified using several formats:
  /// </para>
  /// <para>
  /// </para>
  /// <para>
  ///   - FunctionLogicalName
  /// </para>
  /// <para>
  ///   - ModuleSerialNumber.FunctionIdentifier
  /// </para>
  /// <para>
  ///   - ModuleSerialNumber.FunctionLogicalName
  /// </para>
  /// <para>
  ///   - ModuleLogicalName.FunctionIdentifier
  /// </para>
  /// <para>
  ///   - ModuleLogicalName.FunctionLogicalName
  /// </para>
  /// <para>
  /// </para>
  /// <para>
  ///   This function does not require that the cellular interface is online at the time
  ///   it is invoked. The returned object is nevertheless valid.
  ///   Use the method <c>YBluetoothLink.isOnline()</c> to test if the cellular interface is
  ///   indeed online at a given time. In case of ambiguity when looking for
  ///   a cellular interface by logical name, no error is notified: the first instance
  ///   found is returned. The search is performed first by hardware name,
  ///   then by logical name.
  /// </para>
  /// </summary>
  /// <param name="func">
  ///   a string that uniquely characterizes the cellular interface
  /// </param>
  /// <returns>
  ///   a <c>YBluetoothLink</c> object allowing you to drive the cellular interface.
  /// </returns>
  ///-
  function yFindBluetoothLink(func:string):TYBluetoothLink;
  ////
  /// <summary>
  ///   Starts the enumeration of cellular interfaces currently accessible.
  /// <para>
  ///   Use the method <c>YBluetoothLink.nextBluetoothLink()</c> to iterate on
  ///   next cellular interfaces.
  /// </para>
  /// </summary>
  /// <returns>
  ///   a pointer to a <c>YBluetoothLink</c> object, corresponding to
  ///   the first cellular interface currently online, or a <c>null</c> pointer
  ///   if there are none.
  /// </returns>
  ///-
  function yFirstBluetoothLink():TYBluetoothLink;

//--- (end of BluetoothLink functions declaration)

implementation
//--- (YBluetoothLink dlldef)
//--- (end of YBluetoothLink dlldef)

  constructor TYBluetoothLink.Create(func:string);
    begin
      inherited Create(func);
      _className := 'BluetoothLink';
      //--- (YBluetoothLink accessors initialization)
      _ownAddress := Y_OWNADDRESS_INVALID;
      _pairingPin := Y_PAIRINGPIN_INVALID;
      _remoteAddress := Y_REMOTEADDRESS_INVALID;
      _remoteName := Y_REMOTENAME_INVALID;
      _mute := Y_MUTE_INVALID;
      _preAmplifier := Y_PREAMPLIFIER_INVALID;
      _volume := Y_VOLUME_INVALID;
      _linkState := Y_LINKSTATE_INVALID;
      _linkQuality := Y_LINKQUALITY_INVALID;
      _command := Y_COMMAND_INVALID;
      _valueCallbackBluetoothLink := nil;
      //--- (end of YBluetoothLink accessors initialization)
    end;


//--- (YBluetoothLink implementation)
{$HINTS OFF}
  function TYBluetoothLink._parseAttr(member:PJSONRECORD):integer;
    var
      sub : PJSONRECORD;
      i,l        : integer;
    begin
      if (member^.name = 'ownAddress') then
        begin
          _ownAddress := string(member^.svalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'pairingPin') then
        begin
          _pairingPin := string(member^.svalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'remoteAddress') then
        begin
          _remoteAddress := string(member^.svalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'remoteName') then
        begin
          _remoteName := string(member^.svalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'mute') then
        begin
          _mute := member^.ivalue;
         result := 1;
         exit;
         end;
      if (member^.name = 'preAmplifier') then
        begin
          _preAmplifier := integer(member^.ivalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'volume') then
        begin
          _volume := integer(member^.ivalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'linkState') then
        begin
          _linkState := integer(member^.ivalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'linkQuality') then
        begin
          _linkQuality := integer(member^.ivalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'command') then
        begin
          _command := string(member^.svalue);
         result := 1;
         exit;
         end;
      result := inherited _parseAttr(member);
    end;
{$HINTS ON}

  ////
  /// <summary>
  ///   Returns the MAC-48 address of the bluetooth interface, which is unique on the bluetooth network.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a string corresponding to the MAC-48 address of the bluetooth interface, which is unique on the
  ///   bluetooth network
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_OWNADDRESS_INVALID.
  /// </para>
  ///-
  function TYBluetoothLink.get_ownAddress():string;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_OWNADDRESS_INVALID;
              exit
            end;
        end;
      result := self._ownAddress;
      exit;
    end;


  ////
  /// <summary>
  ///   Returns an opaque string if a PIN code has been configured in the device to access
  ///   the SIM card, or an empty string if none has been configured or if the code provided
  ///   was rejected by the SIM card.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a string corresponding to an opaque string if a PIN code has been configured in the device to access
  ///   the SIM card, or an empty string if none has been configured or if the code provided
  ///   was rejected by the SIM card
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_PAIRINGPIN_INVALID.
  /// </para>
  ///-
  function TYBluetoothLink.get_pairingPin():string;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_PAIRINGPIN_INVALID;
              exit
            end;
        end;
      result := self._pairingPin;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the PIN code used by the module for bluetooth pairing.
  /// <para>
  ///   Remember to call the saveToFlash() method of the module to save the
  ///   new value in the device flash.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   a string corresponding to the PIN code used by the module for bluetooth pairing
  /// </param>
  /// <para>
  /// </para>
  /// <returns>
  ///   YAPI_SUCCESS if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYBluetoothLink.set_pairingPin(newval:string):integer;
    var
      rest_val: string;
    begin
      rest_val := newval;
      result := _setAttr('pairingPin',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the MAC-48 address of the remote device to connect to.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a string corresponding to the MAC-48 address of the remote device to connect to
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_REMOTEADDRESS_INVALID.
  /// </para>
  ///-
  function TYBluetoothLink.get_remoteAddress():string;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_REMOTEADDRESS_INVALID;
              exit
            end;
        end;
      result := self._remoteAddress;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the MAC-48 address defining which remote device to connect to.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   a string corresponding to the MAC-48 address defining which remote device to connect to
  /// </param>
  /// <para>
  /// </para>
  /// <returns>
  ///   YAPI_SUCCESS if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYBluetoothLink.set_remoteAddress(newval:string):integer;
    var
      rest_val: string;
    begin
      rest_val := newval;
      result := _setAttr('remoteAddress',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the bluetooth name the remote device, if found on the bluetooth network.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a string corresponding to the bluetooth name the remote device, if found on the bluetooth network
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_REMOTENAME_INVALID.
  /// </para>
  ///-
  function TYBluetoothLink.get_remoteName():string;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_REMOTENAME_INVALID;
              exit
            end;
        end;
      result := self._remoteName;
      exit;
    end;


  ////
  /// <summary>
  ///   Returns the state of the mute function.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   either Y_MUTE_FALSE or Y_MUTE_TRUE, according to the state of the mute function
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_MUTE_INVALID.
  /// </para>
  ///-
  function TYBluetoothLink.get_mute():Integer;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_MUTE_INVALID;
              exit
            end;
        end;
      result := self._mute;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the state of the mute function.
  /// <para>
  ///   Remember to call the matching module
  ///   saveToFlash() method to save the setting permanently.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   either Y_MUTE_FALSE or Y_MUTE_TRUE, according to the state of the mute function
  /// </param>
  /// <para>
  /// </para>
  /// <returns>
  ///   YAPI_SUCCESS if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYBluetoothLink.set_mute(newval:Integer):integer;
    var
      rest_val: string;
    begin
      if(newval>0) then rest_val := '1' else rest_val := '0';
      result := _setAttr('mute',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the audio pre-amplifier volume, in per cents.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   an integer corresponding to the audio pre-amplifier volume, in per cents
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_PREAMPLIFIER_INVALID.
  /// </para>
  ///-
  function TYBluetoothLink.get_preAmplifier():LongInt;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_PREAMPLIFIER_INVALID;
              exit
            end;
        end;
      result := self._preAmplifier;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the audio pre-amplifier volume, in per cents.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   an integer corresponding to the audio pre-amplifier volume, in per cents
  /// </param>
  /// <para>
  /// </para>
  /// <returns>
  ///   YAPI_SUCCESS if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYBluetoothLink.set_preAmplifier(newval:LongInt):integer;
    var
      rest_val: string;
    begin
      rest_val := inttostr(newval);
      result := _setAttr('preAmplifier',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the connected headset volume, in per cents.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   an integer corresponding to the connected headset volume, in per cents
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_VOLUME_INVALID.
  /// </para>
  ///-
  function TYBluetoothLink.get_volume():LongInt;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_VOLUME_INVALID;
              exit
            end;
        end;
      result := self._volume;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the connected headset volume, in per cents.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   an integer corresponding to the connected headset volume, in per cents
  /// </param>
  /// <para>
  /// </para>
  /// <returns>
  ///   YAPI_SUCCESS if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYBluetoothLink.set_volume(newval:LongInt):integer;
    var
      rest_val: string;
    begin
      rest_val := inttostr(newval);
      result := _setAttr('volume',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the bluetooth link state.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a value among Y_LINKSTATE_DOWN, Y_LINKSTATE_FREE, Y_LINKSTATE_SEARCH, Y_LINKSTATE_EXISTS,
  ///   Y_LINKSTATE_LINKED and Y_LINKSTATE_PLAY corresponding to the bluetooth link state
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_LINKSTATE_INVALID.
  /// </para>
  ///-
  function TYBluetoothLink.get_linkState():Integer;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_LINKSTATE_INVALID;
              exit
            end;
        end;
      result := self._linkState;
      exit;
    end;


  ////
  /// <summary>
  ///   Returns the bluetooth receiver signal strength, in pourcents, or 0 if no connection is established.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   an integer corresponding to the bluetooth receiver signal strength, in pourcents, or 0 if no
  ///   connection is established
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_LINKQUALITY_INVALID.
  /// </para>
  ///-
  function TYBluetoothLink.get_linkQuality():LongInt;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_LINKQUALITY_INVALID;
              exit
            end;
        end;
      result := self._linkQuality;
      exit;
    end;


  function TYBluetoothLink.get_command():string;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_COMMAND_INVALID;
              exit
            end;
        end;
      result := self._command;
      exit;
    end;


  function TYBluetoothLink.set_command(newval:string):integer;
    var
      rest_val: string;
    begin
      rest_val := newval;
      result := _setAttr('command',rest_val);
    end;

  ////
  /// <summary>
  ///   Retrieves $AFUNCTION$ for a given identifier.
  /// <para>
  ///   The identifier can be specified using several formats:
  /// </para>
  /// <para>
  /// </para>
  /// <para>
  ///   - FunctionLogicalName
  /// </para>
  /// <para>
  ///   - ModuleSerialNumber.FunctionIdentifier
  /// </para>
  /// <para>
  ///   - ModuleSerialNumber.FunctionLogicalName
  /// </para>
  /// <para>
  ///   - ModuleLogicalName.FunctionIdentifier
  /// </para>
  /// <para>
  ///   - ModuleLogicalName.FunctionLogicalName
  /// </para>
  /// <para>
  /// </para>
  /// <para>
  ///   This function does not require that $THEFUNCTION$ is online at the time
  ///   it is invoked. The returned object is nevertheless valid.
  ///   Use the method <c>YBluetoothLink.isOnline()</c> to test if $THEFUNCTION$ is
  ///   indeed online at a given time. In case of ambiguity when looking for
  ///   $AFUNCTION$ by logical name, no error is notified: the first instance
  ///   found is returned. The search is performed first by hardware name,
  ///   then by logical name.
  /// </para>
  /// </summary>
  /// <param name="func">
  ///   a string that uniquely characterizes $THEFUNCTION$
  /// </param>
  /// <returns>
  ///   a <c>YBluetoothLink</c> object allowing you to drive $THEFUNCTION$.
  /// </returns>
  ///-
  class function TYBluetoothLink.FindBluetoothLink(func: string):TYBluetoothLink;
    var
      obj : TYBluetoothLink;
    begin
      obj := TYBluetoothLink(TYFunction._FindFromCache('BluetoothLink', func));
      if obj = nil then
        begin
          obj :=  TYBluetoothLink.create(func);
          TYFunction._AddToCache('BluetoothLink',  func, obj)
        end;
      result := obj;
      exit;
    end;


  ////
  /// <summary>
  ///   Registers the callback function that is invoked on every change of advertised value.
  /// <para>
  ///   The callback is invoked only during the execution of <c>ySleep</c> or <c>yHandleEvents</c>.
  ///   This provides control over the time when the callback is triggered. For good responsiveness, remember to call
  ///   one of these two functions periodically. To unregister a callback, pass a null pointer as argument.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="callback">
  ///   the callback function to call, or a null pointer. The callback function should take two
  ///   arguments: the function object of which the value has changed, and the character string describing
  ///   the new advertised value.
  /// @noreturn
  /// </param>
  ///-
  function TYBluetoothLink.registerValueCallback(callback: TYBluetoothLinkValueCallback):LongInt;
    var
      val : string;
    begin
      if (addr(callback) <> nil) then
        begin
          TYFunction._UpdateValueCallbackList(self, true)
        end
      else
        begin
          TYFunction._UpdateValueCallbackList(self, false)
        end;
      self._valueCallbackBluetoothLink := callback;
      // Immediately invoke value callback with current value
      if (addr(callback) <> nil) and self.isOnline then
        begin
          val := self._advertisedValue;
          if not((val = '')) then
            begin
              self._invokeValueCallback(val)
            end;
        end;
      result := 0;
      exit;
    end;


  function TYBluetoothLink._invokeValueCallback(value: string):LongInt;
    begin
      if (addr(self._valueCallbackBluetoothLink) <> nil) then
        begin
          self._valueCallbackBluetoothLink(self, value)
        end
      else
        begin
          inherited _invokeValueCallback(value)
        end;
      result := 0;
      exit;
    end;


  ////
  /// <summary>
  ///   Attempt to connect to the previously selected remote device.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> when the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYBluetoothLink.connect():LongInt;
    begin
      result := self.set_command('C');
      exit;
    end;


  ////
  /// <summary>
  ///   Disconnect from the previously selected remote device.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   <c>YAPI_SUCCESS</c> when the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYBluetoothLink.disconnect():LongInt;
    begin
      result := self.set_command('D');
      exit;
    end;


  function TYBluetoothLink.nextBluetoothLink(): TYBluetoothLink;
    var
      hwid: string;
    begin
      if YISERR(_nextFunction(hwid)) then
        begin
          nextBluetoothLink := nil;
          exit;
        end;
      if hwid = '' then
        begin
          nextBluetoothLink := nil;
          exit;
        end;
      nextBluetoothLink := TYBluetoothLink.FindBluetoothLink(hwid);
    end;

  class function TYBluetoothLink.FirstBluetoothLink(): TYBluetoothLink;
    var
      v_fundescr      : YFUN_DESCR;
      dev             : YDEV_DESCR;
      neededsize, err : integer;
      serial, funcId, funcName, funcVal, errmsg : string;
    begin
      err := yapiGetFunctionsByClass('BluetoothLink', 0, PyHandleArray(@v_fundescr), sizeof(YFUN_DESCR), neededsize, errmsg);
      if (YISERR(err) or (neededsize = 0)) then
        begin
          result := nil;
          exit;
        end;
      if (YISERR(yapiGetFunctionInfo(v_fundescr, dev, serial, funcId, funcName, funcVal, errmsg))) then
        begin
          result := nil;
          exit;
        end;
     result := TYBluetoothLink.FindBluetoothLink(serial+'.'+funcId);
    end;

//--- (end of YBluetoothLink implementation)

//--- (BluetoothLink functions)

  function yFindBluetoothLink(func:string): TYBluetoothLink;
    begin
      result := TYBluetoothLink.FindBluetoothLink(func);
    end;

  function yFirstBluetoothLink(): TYBluetoothLink;
    begin
      result := TYBluetoothLink.FirstBluetoothLink();
    end;

  procedure _BluetoothLinkCleanup();
    begin
    end;

//--- (end of BluetoothLink functions)

initialization
  //--- (BluetoothLink initialization)
  //--- (end of BluetoothLink initialization)

finalization
  //--- (BluetoothLink cleanup)
  _BluetoothLinkCleanup();
  //--- (end of BluetoothLink cleanup)
end.