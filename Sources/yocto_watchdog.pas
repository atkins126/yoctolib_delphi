{*********************************************************************
 *
 * $Id: yocto_watchdog.pas 18320 2014-11-10 10:47:48Z seb $
 *
 * Implements yFindWatchdog(), the high-level API for Watchdog functions
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


unit yocto_watchdog;

interface

uses
  sysutils, classes, windows, yocto_api, yjson;

//--- (YWatchdog definitions)
type  TYWatchdogDelayedPulse = class(TObject)
  public
      target      : LongInt;
      ms          : LongInt;
      moving      : LongInt;
      constructor Create();
    end;

const Y_STATE_A = 0;
const Y_STATE_B = 1;
const Y_STATE_INVALID = -1;
const Y_STATEATPOWERON_UNCHANGED = 0;
const Y_STATEATPOWERON_A = 1;
const Y_STATEATPOWERON_B = 2;
const Y_STATEATPOWERON_INVALID = -1;
const Y_MAXTIMEONSTATEA_INVALID       = YAPI_INVALID_LONG;
const Y_MAXTIMEONSTATEB_INVALID       = YAPI_INVALID_LONG;
const Y_OUTPUT_OFF = 0;
const Y_OUTPUT_ON = 1;
const Y_OUTPUT_INVALID = -1;
const Y_PULSETIMER_INVALID            = YAPI_INVALID_LONG;
const Y_COUNTDOWN_INVALID             = YAPI_INVALID_LONG;
const Y_AUTOSTART_OFF = 0;
const Y_AUTOSTART_ON = 1;
const Y_AUTOSTART_INVALID = -1;
const Y_RUNNING_OFF = 0;
const Y_RUNNING_ON = 1;
const Y_RUNNING_INVALID = -1;
const Y_TRIGGERDELAY_INVALID          = YAPI_INVALID_LONG;
const Y_TRIGGERDURATION_INVALID       = YAPI_INVALID_LONG;

var Y_DELAYEDPULSETIMER_INVALID : TYWatchdogDelayedPulse;

//--- (end of YWatchdog definitions)

type
  TYWatchdog = class;
  //--- (YWatchdog class start)
  TYWatchdogValueCallback = procedure(func: TYWatchdog; value:string);
  TYWatchdogTimedReportCallback = procedure(func: TYWatchdog; value:TYMeasure);

  ////
  /// <summary>
  ///   TYWatchdog Class: Watchdog function interface
  /// <para>
  ///   The watchog function works like a relay and can cause a brief power cut
  ///   to an appliance after a preset delay to force this appliance to
  ///   reset. The Watchdog must be called from time to time to reset the
  ///   timer and prevent the appliance reset.
  ///   The watchdog can be driven direcly with <i>pulse</i> and <i>delayedpulse</i> methods to switch
  ///   off an appliance for a given duration.
  /// </para>
  /// </summary>
  ///-
  TYWatchdog=class(TYFunction)
  //--- (end of YWatchdog class start)
  protected
  //--- (YWatchdog declaration)
    // Attributes (function value cache)
    _logicalName              : string;
    _advertisedValue          : string;
    _state                    : Integer;
    _stateAtPowerOn           : Integer;
    _maxTimeOnStateA          : int64;
    _maxTimeOnStateB          : int64;
    _output                   : Integer;
    _pulseTimer               : int64;
    _delayedPulseTimer        : TYWatchdogDelayedPulse;
    _countdown                : int64;
    _autoStart                : Integer;
    _running                  : Integer;
    _triggerDelay             : int64;
    _triggerDuration          : int64;
    _valueCallbackWatchdog    : TYWatchdogValueCallback;
    // Function-specific method for reading JSON output and caching result
    function _parseAttr(member:PJSONRECORD):integer; override;

    //--- (end of YWatchdog declaration)

  public
    //--- (YWatchdog accessors declaration)
    constructor Create(func:string);

    ////
    /// <summary>
    ///   Returns the state of the watchdog (A for the idle position, B for the active position).
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   either <c>Y_STATE_A</c> or <c>Y_STATE_B</c>, according to the state of the watchdog (A for the idle
    ///   position, B for the active position)
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_STATE_INVALID</c>.
    /// </para>
    ///-
    function get_state():Integer;

    ////
    /// <summary>
    ///   Changes the state of the watchdog (A for the idle position, B for the active position).
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   either <c>Y_STATE_A</c> or <c>Y_STATE_B</c>, according to the state of the watchdog (A for the idle
    ///   position, B for the active position)
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
    function set_state(newval:Integer):integer;

    ////
    /// <summary>
    ///   Returns the state of the watchdog at device startup (A for the idle position, B for the active position, UNCHANGED for no change).
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a value among <c>Y_STATEATPOWERON_UNCHANGED</c>, <c>Y_STATEATPOWERON_A</c> and
    ///   <c>Y_STATEATPOWERON_B</c> corresponding to the state of the watchdog at device startup (A for the
    ///   idle position, B for the active position, UNCHANGED for no change)
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_STATEATPOWERON_INVALID</c>.
    /// </para>
    ///-
    function get_stateAtPowerOn():Integer;

    ////
    /// <summary>
    ///   Preset the state of the watchdog at device startup (A for the idle position,
    ///   B for the active position, UNCHANGED for no modification).
    /// <para>
    ///   Remember to call the matching module <c>saveToFlash()</c>
    ///   method, otherwise this call will have no effect.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   a value among <c>Y_STATEATPOWERON_UNCHANGED</c>, <c>Y_STATEATPOWERON_A</c> and <c>Y_STATEATPOWERON_B</c>
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
    function set_stateAtPowerOn(newval:Integer):integer;

    ////
    /// <summary>
    ///   Retourne the maximum time (ms) allowed for $THEFUNCTIONS$ to stay in state A before automatically switching back in to B state.
    /// <para>
    ///   Zero means no maximum time.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   an integer
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_MAXTIMEONSTATEA_INVALID</c>.
    /// </para>
    ///-
    function get_maxTimeOnStateA():int64;

    ////
    /// <summary>
    ///   Sets the maximum time (ms) allowed for $THEFUNCTIONS$ to stay in state A before automatically switching back in to B state.
    /// <para>
    ///   Use zero for no maximum time.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   an integer
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
    function set_maxTimeOnStateA(newval:int64):integer;

    ////
    /// <summary>
    ///   Retourne the maximum time (ms) allowed for $THEFUNCTIONS$ to stay in state B before automatically switching back in to A state.
    /// <para>
    ///   Zero means no maximum time.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   an integer
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_MAXTIMEONSTATEB_INVALID</c>.
    /// </para>
    ///-
    function get_maxTimeOnStateB():int64;

    ////
    /// <summary>
    ///   Sets the maximum time (ms) allowed for $THEFUNCTIONS$ to stay in state B before automatically switching back in to A state.
    /// <para>
    ///   Use zero for no maximum time.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   an integer
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
    function set_maxTimeOnStateB(newval:int64):integer;

    ////
    /// <summary>
    ///   Returns the output state of the watchdog, when used as a simple switch (single throw).
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   either <c>Y_OUTPUT_OFF</c> or <c>Y_OUTPUT_ON</c>, according to the output state of the watchdog,
    ///   when used as a simple switch (single throw)
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_OUTPUT_INVALID</c>.
    /// </para>
    ///-
    function get_output():Integer;

    ////
    /// <summary>
    ///   Changes the output state of the watchdog, when used as a simple switch (single throw).
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   either <c>Y_OUTPUT_OFF</c> or <c>Y_OUTPUT_ON</c>, according to the output state of the watchdog,
    ///   when used as a simple switch (single throw)
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
    function set_output(newval:Integer):integer;

    ////
    /// <summary>
    ///   Returns the number of milliseconds remaining before the watchdog is returned to idle position
    ///   (state A), during a measured pulse generation.
    /// <para>
    ///   When there is no ongoing pulse, returns zero.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   an integer corresponding to the number of milliseconds remaining before the watchdog is returned to
    ///   idle position
    ///   (state A), during a measured pulse generation
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_PULSETIMER_INVALID</c>.
    /// </para>
    ///-
    function get_pulseTimer():int64;

    function set_pulseTimer(newval:int64):integer;

    ////
    /// <summary>
    ///   Sets the relay to output B (active) for a specified duration, then brings it
    ///   automatically back to output A (idle state).
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="ms_duration">
    ///   pulse duration, in millisecondes
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
    function pulse(ms_duration: LongInt):integer;

    function get_delayedPulseTimer():TYWatchdogDelayedPulse;

    function set_delayedPulseTimer(newval:TYWatchdogDelayedPulse):integer;

    ////
    /// <summary>
    ///   Schedules a pulse.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="ms_delay">
    ///   waiting time before the pulse, in millisecondes
    /// </param>
    /// <param name="ms_duration">
    ///   pulse duration, in millisecondes
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
    function delayedPulse(ms_delay: LongInt; ms_duration: LongInt):integer;

    ////
    /// <summary>
    ///   Returns the number of milliseconds remaining before a pulse (delayedPulse() call)
    ///   When there is no scheduled pulse, returns zero.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   an integer corresponding to the number of milliseconds remaining before a pulse (delayedPulse() call)
    ///   When there is no scheduled pulse, returns zero
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_COUNTDOWN_INVALID</c>.
    /// </para>
    ///-
    function get_countdown():int64;

    ////
    /// <summary>
    ///   Returns the watchdog runing state at module power on.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   either <c>Y_AUTOSTART_OFF</c> or <c>Y_AUTOSTART_ON</c>, according to the watchdog runing state at
    ///   module power on
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_AUTOSTART_INVALID</c>.
    /// </para>
    ///-
    function get_autoStart():Integer;

    ////
    /// <summary>
    ///   Changes the watchdog runningsttae at module power on.
    /// <para>
    ///   Remember to call the
    ///   <c>saveToFlash()</c> method and then to reboot the module to apply this setting.
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   either <c>Y_AUTOSTART_OFF</c> or <c>Y_AUTOSTART_ON</c>, according to the watchdog runningsttae at
    ///   module power on
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
    function set_autoStart(newval:Integer):integer;

    ////
    /// <summary>
    ///   Returns the watchdog running state.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   either <c>Y_RUNNING_OFF</c> or <c>Y_RUNNING_ON</c>, according to the watchdog running state
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_RUNNING_INVALID</c>.
    /// </para>
    ///-
    function get_running():Integer;

    ////
    /// <summary>
    ///   Changes the running state of the watchdog.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   either <c>Y_RUNNING_OFF</c> or <c>Y_RUNNING_ON</c>, according to the running state of the watchdog
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
    function set_running(newval:Integer):integer;

    ////
    /// <summary>
    ///   Resets the watchdog.
    /// <para>
    ///   When the watchdog is running, this function
    ///   must be called on a regular basis to prevent the watchog to
    ///   trigger
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   <c>YAPI_SUCCESS</c> if the call succeeds.
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns a negative error code.
    /// </para>
    ///-
    function resetWatchdog():integer;

    ////
    /// <summary>
    ///   Returns  the waiting duration before a reset is automatically triggered by the watchdog, in milliseconds.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   an integer corresponding to  the waiting duration before a reset is automatically triggered by the
    ///   watchdog, in milliseconds
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_TRIGGERDELAY_INVALID</c>.
    /// </para>
    ///-
    function get_triggerDelay():int64;

    ////
    /// <summary>
    ///   Changes the waiting delay before a reset is triggered by the watchdog, in milliseconds.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   an integer corresponding to the waiting delay before a reset is triggered by the watchdog, in milliseconds
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
    function set_triggerDelay(newval:int64):integer;

    ////
    /// <summary>
    ///   Returns the duration of resets caused by the watchdog, in milliseconds.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   an integer corresponding to the duration of resets caused by the watchdog, in milliseconds
    /// </returns>
    /// <para>
    ///   On failure, throws an exception or returns <c>Y_TRIGGERDURATION_INVALID</c>.
    /// </para>
    ///-
    function get_triggerDuration():int64;

    ////
    /// <summary>
    ///   Changes the duration of resets caused by the watchdog, in milliseconds.
    /// <para>
    /// </para>
    /// <para>
    /// </para>
    /// </summary>
    /// <param name="newval">
    ///   an integer corresponding to the duration of resets caused by the watchdog, in milliseconds
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
    function set_triggerDuration(newval:int64):integer;

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
    ///   Use the method <c>YWatchdog.isOnline()</c> to test if $THEFUNCTION$ is
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
    ///   a <c>YWatchdog</c> object allowing you to drive $THEFUNCTION$.
    /// </returns>
    ///-
    class function FindWatchdog(func: string):TYWatchdog;

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
    function registerValueCallback(callback: TYWatchdogValueCallback):LongInt; overload;

    function _invokeValueCallback(value: string):LongInt; override;


    ////
    /// <summary>
    ///   Continues the enumeration of watchdog started using <c>yFirstWatchdog()</c>.
    /// <para>
    /// </para>
    /// </summary>
    /// <returns>
    ///   a pointer to a <c>YWatchdog</c> object, corresponding to
    ///   a watchdog currently online, or a <c>null</c> pointer
    ///   if there are no more watchdog to enumerate.
    /// </returns>
    ///-
    function nextWatchdog():TYWatchdog;
    ////
    /// <summary>
    ///   c
    /// <para>
    ///   omment from .yc definition
    /// </para>
    /// </summary>
    ///-
    class function FirstWatchdog():TYWatchdog;
  //--- (end of YWatchdog accessors declaration)
  end;

//--- (Watchdog functions declaration)
  ////
  /// <summary>
  ///   Retrieves a watchdog for a given identifier.
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
  ///   This function does not require that the watchdog is online at the time
  ///   it is invoked. The returned object is nevertheless valid.
  ///   Use the method <c>YWatchdog.isOnline()</c> to test if the watchdog is
  ///   indeed online at a given time. In case of ambiguity when looking for
  ///   a watchdog by logical name, no error is notified: the first instance
  ///   found is returned. The search is performed first by hardware name,
  ///   then by logical name.
  /// </para>
  /// </summary>
  /// <param name="func">
  ///   a string that uniquely characterizes the watchdog
  /// </param>
  /// <returns>
  ///   a <c>YWatchdog</c> object allowing you to drive the watchdog.
  /// </returns>
  ///-
  function yFindWatchdog(func:string):TYWatchdog;
  ////
  /// <summary>
  ///   Starts the enumeration of watchdog currently accessible.
  /// <para>
  ///   Use the method <c>YWatchdog.nextWatchdog()</c> to iterate on
  ///   next watchdog.
  /// </para>
  /// </summary>
  /// <returns>
  ///   a pointer to a <c>YWatchdog</c> object, corresponding to
  ///   the first watchdog currently online, or a <c>null</c> pointer
  ///   if there are none.
  /// </returns>
  ///-
  function yFirstWatchdog():TYWatchdog;

//--- (end of Watchdog functions declaration)

implementation
//--- (YWatchdog dlldef)
//--- (end of YWatchdog dlldef)

    constructor TYWatchdogDelayedPulse.Create();
    begin
      target := YAPI_INVALID_INT;
      ms := YAPI_INVALID_INT;
      moving := YAPI_INVALID_UINT;
  end;

  constructor TYWatchdog.Create(func:string);
    begin
      inherited Create(func);
      _className := 'Watchdog';
      //--- (YWatchdog accessors initialization)
      _state := Y_STATE_INVALID;
      _stateAtPowerOn := Y_STATEATPOWERON_INVALID;
      _maxTimeOnStateA := Y_MAXTIMEONSTATEA_INVALID;
      _maxTimeOnStateB := Y_MAXTIMEONSTATEB_INVALID;
      _output := Y_OUTPUT_INVALID;
      _pulseTimer := Y_PULSETIMER_INVALID;
      _delayedPulseTimer := Y_DELAYEDPULSETIMER_INVALID;
      _countdown := Y_COUNTDOWN_INVALID;
      _autoStart := Y_AUTOSTART_INVALID;
      _running := Y_RUNNING_INVALID;
      _triggerDelay := Y_TRIGGERDELAY_INVALID;
      _triggerDuration := Y_TRIGGERDURATION_INVALID;
      _valueCallbackWatchdog := nil;
      //--- (end of YWatchdog accessors initialization)
    end;


//--- (YWatchdog implementation)
{$HINTS OFF}
  function TYWatchdog._parseAttr(member:PJSONRECORD):integer;
    var
      sub : PJSONRECORD;
      i,l        : integer;
    begin
      if (member^.name = 'state') then
        begin
          _state := member^.ivalue;
         result := 1;
         exit;
         end;
      if (member^.name = 'stateAtPowerOn') then
        begin
          _stateAtPowerOn := integer(member^.ivalue);
         result := 1;
         exit;
         end;
      if (member^.name = 'maxTimeOnStateA') then
        begin
          _maxTimeOnStateA := member^.ivalue;
         result := 1;
         exit;
         end;
      if (member^.name = 'maxTimeOnStateB') then
        begin
          _maxTimeOnStateB := member^.ivalue;
         result := 1;
         exit;
         end;
      if (member^.name = 'output') then
        begin
          _output := member^.ivalue;
         result := 1;
         exit;
         end;
      if (member^.name = 'pulseTimer') then
        begin
          _pulseTimer := member^.ivalue;
         result := 1;
         exit;
         end;
      if (member^.name = 'delayedPulseTimer') then
        begin
          if member^.recordtype = JSON_STRUCT then
            begin
              for l:=0 to member^.membercount-1 do
               begin
                 sub := member^.members[l];
                 if (sub^.name = 'moving') then
                    _delayedPulseTimer.moving := sub^.ivalue else
                 if (sub^.name = 'target') then
                    _delayedPulseTimer.target := sub^.ivalue else
                 if (sub^.name = 'ms') then
                    _delayedPulseTimer.ms := sub^.ivalue;
               end;
            end;
         result := 1;
         exit;
         end;
      if (member^.name = 'countdown') then
        begin
          _countdown := member^.ivalue;
         result := 1;
         exit;
         end;
      if (member^.name = 'autoStart') then
        begin
          _autoStart := member^.ivalue;
         result := 1;
         exit;
         end;
      if (member^.name = 'running') then
        begin
          _running := member^.ivalue;
         result := 1;
         exit;
         end;
      if (member^.name = 'triggerDelay') then
        begin
          _triggerDelay := member^.ivalue;
         result := 1;
         exit;
         end;
      if (member^.name = 'triggerDuration') then
        begin
          _triggerDuration := member^.ivalue;
         result := 1;
         exit;
         end;
      result := inherited _parseAttr(member);
    end;
{$HINTS ON}

  ////
  /// <summary>
  ///   Returns the state of the watchdog (A for the idle position, B for the active position).
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   either Y_STATE_A or Y_STATE_B, according to the state of the watchdog (A for the idle position, B
  ///   for the active position)
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_STATE_INVALID.
  /// </para>
  ///-
  function TYWatchdog.get_state():Integer;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_STATE_INVALID;
              exit
            end;
        end;
      result := self._state;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the state of the watchdog (A for the idle position, B for the active position).
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   either Y_STATE_A or Y_STATE_B, according to the state of the watchdog (A for the idle position, B
  ///   for the active position)
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
  function TYWatchdog.set_state(newval:Integer):integer;
    var
      rest_val: string;
    begin
      if(newval>0) then rest_val := '1' else rest_val := '0';
      result := _setAttr('state',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the state of the watchdog at device startup (A for the idle position, B for the active position, UNCHANGED for no change).
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   a value among Y_STATEATPOWERON_UNCHANGED, Y_STATEATPOWERON_A and Y_STATEATPOWERON_B corresponding
  ///   to the state of the watchdog at device startup (A for the idle position, B for the active position,
  ///   UNCHANGED for no change)
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_STATEATPOWERON_INVALID.
  /// </para>
  ///-
  function TYWatchdog.get_stateAtPowerOn():Integer;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_STATEATPOWERON_INVALID;
              exit
            end;
        end;
      result := self._stateAtPowerOn;
      exit;
    end;


  ////
  /// <summary>
  ///   Preset the state of the watchdog at device startup (A for the idle position,
  ///   B for the active position, UNCHANGED for no modification).
  /// <para>
  ///   Remember to call the matching module saveToFlash()
  ///   method, otherwise this call will have no effect.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   a value among Y_STATEATPOWERON_UNCHANGED, Y_STATEATPOWERON_A and Y_STATEATPOWERON_B
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
  function TYWatchdog.set_stateAtPowerOn(newval:Integer):integer;
    var
      rest_val: string;
    begin
      rest_val := inttostr(newval);
      result := _setAttr('stateAtPowerOn',rest_val);
    end;

  ////
  /// <summary>
  ///   Retourne the maximum time (ms) allowed for $THEFUNCTIONS$ to stay in state A before automatically switching back in to B state.
  /// <para>
  ///   Zero means no maximum time.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   an integer
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_MAXTIMEONSTATEA_INVALID.
  /// </para>
  ///-
  function TYWatchdog.get_maxTimeOnStateA():int64;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_MAXTIMEONSTATEA_INVALID;
              exit
            end;
        end;
      result := self._maxTimeOnStateA;
      exit;
    end;


  ////
  /// <summary>
  ///   Sets the maximum time (ms) allowed for $THEFUNCTIONS$ to stay in state A before automatically switching back in to B state.
  /// <para>
  ///   Use zero for no maximum time.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   an integer
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
  function TYWatchdog.set_maxTimeOnStateA(newval:int64):integer;
    var
      rest_val: string;
    begin
      rest_val := inttostr(newval);
      result := _setAttr('maxTimeOnStateA',rest_val);
    end;

  ////
  /// <summary>
  ///   Retourne the maximum time (ms) allowed for $THEFUNCTIONS$ to stay in state B before automatically switching back in to A state.
  /// <para>
  ///   Zero means no maximum time.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   an integer
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_MAXTIMEONSTATEB_INVALID.
  /// </para>
  ///-
  function TYWatchdog.get_maxTimeOnStateB():int64;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_MAXTIMEONSTATEB_INVALID;
              exit
            end;
        end;
      result := self._maxTimeOnStateB;
      exit;
    end;


  ////
  /// <summary>
  ///   Sets the maximum time (ms) allowed for $THEFUNCTIONS$ to stay in state B before automatically switching back in to A state.
  /// <para>
  ///   Use zero for no maximum time.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   an integer
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
  function TYWatchdog.set_maxTimeOnStateB(newval:int64):integer;
    var
      rest_val: string;
    begin
      rest_val := inttostr(newval);
      result := _setAttr('maxTimeOnStateB',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the output state of the watchdog, when used as a simple switch (single throw).
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   either Y_OUTPUT_OFF or Y_OUTPUT_ON, according to the output state of the watchdog, when used as a
  ///   simple switch (single throw)
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_OUTPUT_INVALID.
  /// </para>
  ///-
  function TYWatchdog.get_output():Integer;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_OUTPUT_INVALID;
              exit
            end;
        end;
      result := self._output;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the output state of the watchdog, when used as a simple switch (single throw).
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   either Y_OUTPUT_OFF or Y_OUTPUT_ON, according to the output state of the watchdog, when used as a
  ///   simple switch (single throw)
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
  function TYWatchdog.set_output(newval:Integer):integer;
    var
      rest_val: string;
    begin
      if(newval>0) then rest_val := '1' else rest_val := '0';
      result := _setAttr('output',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the number of milliseconds remaining before the watchdog is returned to idle position
  ///   (state A), during a measured pulse generation.
  /// <para>
  ///   When there is no ongoing pulse, returns zero.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   an integer corresponding to the number of milliseconds remaining before the watchdog is returned to
  ///   idle position
  ///   (state A), during a measured pulse generation
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_PULSETIMER_INVALID.
  /// </para>
  ///-
  function TYWatchdog.get_pulseTimer():int64;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_PULSETIMER_INVALID;
              exit
            end;
        end;
      result := self._pulseTimer;
      exit;
    end;


  function TYWatchdog.set_pulseTimer(newval:int64):integer;
    var
      rest_val: string;
    begin
      rest_val := inttostr(newval);
      result := _setAttr('pulseTimer',rest_val);
    end;

  ////
  /// <summary>
  ///   Sets the relay to output B (active) for a specified duration, then brings it
  ///   automatically back to output A (idle state).
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="ms_duration">
  ///   pulse duration, in millisecondes
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
  function TYWatchdog.pulse(ms_duration: LongInt):integer;
    var
      rest_val: string;
    begin
      rest_val := inttostr(ms_duration);
      result := _setAttr('pulseTimer', rest_val);
    end;

  function TYWatchdog.get_delayedPulseTimer():TYWatchdogDelayedPulse;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_DELAYEDPULSETIMER_INVALID;
              exit
            end;
        end;
      result := self._delayedPulseTimer;
      exit;
    end;


  function TYWatchdog.set_delayedPulseTimer(newval:TYWatchdogDelayedPulse):integer;
    var
      rest_val: string;
    begin
      rest_val := inttostr(newval.target)+':'+inttostr(newval.ms);
      result := _setAttr('delayedPulseTimer',rest_val);
    end;

  ////
  /// <summary>
  ///   Schedules a pulse.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="ms_delay">
  ///   waiting time before the pulse, in millisecondes
  /// </param>
  /// <param name="ms_duration">
  ///   pulse duration, in millisecondes
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
  function TYWatchdog.delayedPulse(ms_delay: LongInt; ms_duration: LongInt):integer;
    var
      rest_val: string;
    begin
      rest_val := inttostr(ms_delay)+':'+inttostr(ms_duration);
      result := _setAttr('delayedPulseTimer', rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the number of milliseconds remaining before a pulse (delayedPulse() call)
  ///   When there is no scheduled pulse, returns zero.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   an integer corresponding to the number of milliseconds remaining before a pulse (delayedPulse() call)
  ///   When there is no scheduled pulse, returns zero
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_COUNTDOWN_INVALID.
  /// </para>
  ///-
  function TYWatchdog.get_countdown():int64;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_COUNTDOWN_INVALID;
              exit
            end;
        end;
      result := self._countdown;
      exit;
    end;


  ////
  /// <summary>
  ///   Returns the watchdog runing state at module power on.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   either Y_AUTOSTART_OFF or Y_AUTOSTART_ON, according to the watchdog runing state at module power on
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_AUTOSTART_INVALID.
  /// </para>
  ///-
  function TYWatchdog.get_autoStart():Integer;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_AUTOSTART_INVALID;
              exit
            end;
        end;
      result := self._autoStart;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the watchdog runningsttae at module power on.
  /// <para>
  ///   Remember to call the
  ///   saveToFlash() method and then to reboot the module to apply this setting.
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   either Y_AUTOSTART_OFF or Y_AUTOSTART_ON, according to the watchdog runningsttae at module power on
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
  function TYWatchdog.set_autoStart(newval:Integer):integer;
    var
      rest_val: string;
    begin
      if(newval>0) then rest_val := '1' else rest_val := '0';
      result := _setAttr('autoStart',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the watchdog running state.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   either Y_RUNNING_OFF or Y_RUNNING_ON, according to the watchdog running state
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_RUNNING_INVALID.
  /// </para>
  ///-
  function TYWatchdog.get_running():Integer;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_RUNNING_INVALID;
              exit
            end;
        end;
      result := self._running;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the running state of the watchdog.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   either Y_RUNNING_OFF or Y_RUNNING_ON, according to the running state of the watchdog
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
  function TYWatchdog.set_running(newval:Integer):integer;
    var
      rest_val: string;
    begin
      if(newval>0) then rest_val := '1' else rest_val := '0';
      result := _setAttr('running',rest_val);
    end;

  ////
  /// <summary>
  ///   Resets the watchdog.
  /// <para>
  ///   When the watchdog is running, this function
  ///   must be called on a regular basis to prevent the watchog to
  ///   trigger
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   YAPI_SUCCESS if the call succeeds.
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns a negative error code.
  /// </para>
  ///-
  function TYWatchdog.resetWatchdog():integer;
    var
      rest_val: string;
    begin
      rest_val := '1';
      result := _setAttr('running', rest_val);
    end;

  ////
  /// <summary>
  ///   Returns  the waiting duration before a reset is automatically triggered by the watchdog, in milliseconds.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   an integer corresponding to  the waiting duration before a reset is automatically triggered by the
  ///   watchdog, in milliseconds
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_TRIGGERDELAY_INVALID.
  /// </para>
  ///-
  function TYWatchdog.get_triggerDelay():int64;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_TRIGGERDELAY_INVALID;
              exit
            end;
        end;
      result := self._triggerDelay;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the waiting delay before a reset is triggered by the watchdog, in milliseconds.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   an integer corresponding to the waiting delay before a reset is triggered by the watchdog, in milliseconds
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
  function TYWatchdog.set_triggerDelay(newval:int64):integer;
    var
      rest_val: string;
    begin
      rest_val := inttostr(newval);
      result := _setAttr('triggerDelay',rest_val);
    end;

  ////
  /// <summary>
  ///   Returns the duration of resets caused by the watchdog, in milliseconds.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <returns>
  ///   an integer corresponding to the duration of resets caused by the watchdog, in milliseconds
  /// </returns>
  /// <para>
  ///   On failure, throws an exception or returns Y_TRIGGERDURATION_INVALID.
  /// </para>
  ///-
  function TYWatchdog.get_triggerDuration():int64;
    begin
      if self._cacheExpiration <= yGetTickCount then
        begin
          if self.load(YAPI_DEFAULTCACHEVALIDITY) <> YAPI_SUCCESS then
            begin
              result := Y_TRIGGERDURATION_INVALID;
              exit
            end;
        end;
      result := self._triggerDuration;
      exit;
    end;


  ////
  /// <summary>
  ///   Changes the duration of resets caused by the watchdog, in milliseconds.
  /// <para>
  /// </para>
  /// <para>
  /// </para>
  /// </summary>
  /// <param name="newval">
  ///   an integer corresponding to the duration of resets caused by the watchdog, in milliseconds
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
  function TYWatchdog.set_triggerDuration(newval:int64):integer;
    var
      rest_val: string;
    begin
      rest_val := inttostr(newval);
      result := _setAttr('triggerDuration',rest_val);
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
  ///   Use the method <c>YWatchdog.isOnline()</c> to test if $THEFUNCTION$ is
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
  ///   a <c>YWatchdog</c> object allowing you to drive $THEFUNCTION$.
  /// </returns>
  ///-
  class function TYWatchdog.FindWatchdog(func: string):TYWatchdog;
    var
      obj : TYWatchdog;
    begin
      obj := TYWatchdog(TYFunction._FindFromCache('Watchdog', func));
      if obj = nil then
        begin
          obj :=  TYWatchdog.create(func);
          TYFunction._AddToCache('Watchdog',  func, obj)
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
  function TYWatchdog.registerValueCallback(callback: TYWatchdogValueCallback):LongInt;
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
      self._valueCallbackWatchdog := callback;
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


  function TYWatchdog._invokeValueCallback(value: string):LongInt;
    begin
      if (addr(self._valueCallbackWatchdog) <> nil) then
        begin
          self._valueCallbackWatchdog(self, value)
        end
      else
        begin
          inherited _invokeValueCallback(value)
        end;
      result := 0;
      exit;
    end;


  function TYWatchdog.nextWatchdog(): TYWatchdog;
    var
      hwid: string;
    begin
      if YISERR(_nextFunction(hwid)) then
        begin
          nextWatchdog := nil;
          exit;
        end;
      if hwid = '' then
        begin
          nextWatchdog := nil;
          exit;
        end;
      nextWatchdog := TYWatchdog.FindWatchdog(hwid);
    end;

  class function TYWatchdog.FirstWatchdog(): TYWatchdog;
    var
      v_fundescr      : YFUN_DESCR;
      dev             : YDEV_DESCR;
      neededsize, err : integer;
      serial, funcId, funcName, funcVal, errmsg : string;
    begin
      err := yapiGetFunctionsByClass('Watchdog', 0, PyHandleArray(@v_fundescr), sizeof(YFUN_DESCR), neededsize, errmsg);
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
     result := TYWatchdog.FindWatchdog(serial+'.'+funcId);
    end;

//--- (end of YWatchdog implementation)

//--- (Watchdog functions)

  function yFindWatchdog(func:string): TYWatchdog;
    begin
      result := TYWatchdog.FindWatchdog(func);
    end;

  function yFirstWatchdog(): TYWatchdog;
    begin
      result := TYWatchdog.FirstWatchdog();
    end;

  procedure _WatchdogCleanup();
    begin
    end;

//--- (end of Watchdog functions)

initialization
  //--- (Watchdog initialization)
    Y_DELAYEDPULSETIMER_INVALID := TYWatchdogDelayedPulse.Create();
  //--- (end of Watchdog initialization)

finalization
  //--- (Watchdog cleanup)
  _WatchdogCleanup();
  //--- (end of Watchdog cleanup)
end.
