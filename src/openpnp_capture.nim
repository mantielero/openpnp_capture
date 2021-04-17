# Generated @ 2021-04-15T22:12:22+02:00
# Command line:
#   /home/jose/.nimble/pkgs/nimterop-0.6.13/nimterop/toast -pnrk -f:ast2 openpnp-capture.h

# const 'DLLPUBLIC' has unsupported value 'SO_IMPORT'
import bitops,strformat

{.push hint[ConvFromXtoItselfNotNeeded]: off.}

when defined(linux):
  const
    libName* = "/usr/local/lib/libopenpnp-capture.so"
elif defined(windows):
  const
    libName* = "libopenpnp-capture.dll" # TBC
else:
  const
    libName* = "libopenpnp-capture.dylib" # TBC


#{.pragma: impopenpnpcaptureHdr,
#  dynlib: "/usr/local/lib/libopenpnp-capture.so".}
{.pragma: impopenpnpcaptureHdr,
  header: "/usr/local/include/openpnp-capture.h".}

{.experimental: "codeReordering".}


const
  CAPPROPID_EXPOSURE* = 1
  CAPPROPID_FOCUS* = 2
  CAPPROPID_ZOOM* = 3
  CAPPROPID_WHITEBALANCE* = 4
  CAPPROPID_GAIN* = 5
  CAPPROPID_BRIGHTNESS* = 6
  CAPPROPID_CONTRAST* = 7
  CAPPROPID_SATURATION* = 8
  CAPPROPID_GAMMA* = 9
  CAPPROPID_HUE* = 10
  CAPPROPID_SHARPNESS* = 11
  CAPPROPID_BACKLIGHTCOMP* = 12
  CAPPROPID_POWERLINEFREQ* = 13
  CAPPROPID_LAST* = 14

  CAPRESULT_OK* = 0
  CAPRESULT_ERR* = 1
  CAPRESULT_DEVICENOTFOUND* = 2
  CAPRESULT_FORMATNOTSUPPORTED* = 3
  CAPRESULT_PROPERTYNOTSUPPORTED* = 4
type
  CapContext* {.importc, impopenpnpcaptureHdr.} = pointer ## ```
                                                          ##   /< an opaque pointer to the internal Context*
                                                          ## ```
  CapStream* {.importc, impopenpnpcaptureHdr.} = int32 ## ```
                                                       ##   /< a stream identifier (normally >=0, <0 for error)
                                                       ## ```
  CapResult* {.importc, impopenpnpcaptureHdr.} = uint32 ## ```
                                                        ##   /< result defined by CAPRESULT_xxx
                                                        ## ```
  CapDeviceID* {.importc, impopenpnpcaptureHdr.} = uint32 ## ```
                                                          ##   /< unique device ID
                                                          ## ```
  CapFormatID* {.importc, impopenpnpcaptureHdr.} = uint32 ## ```
                                                          ##   /< format identifier 0 .. numFormats
                                                          ##      supported properties:
                                                          ## ```
  CapPropertyID* {.importc, impopenpnpcaptureHdr.} = uint32 ## ```
                                                            ##   /< property ID (exposure, zoom, focus etc.)
                                                            ## ```
  CapFormatInfo* {.bycopy, importc, impopenpnpcaptureHdr.} = object
    width*: uint32           ## ```
                             ##   /< width in pixels
                             ## ```
    height*: uint32          ## ```
                             ##   /< height in pixels
                             ## ```
    fourcc*: uint32          ## ```
                             ##   /< fourcc code (platform dependent)
                             ## ```
    fps*: uint32             ## ```
                             ##   /< frames per second
                             ## ```
    bpp*: uint32             ## ```
                             ##   /< bits per pixel
                             ## ```
  
  CapCustomLogFunc* {.importc, impopenpnpcaptureHdr.} = proc (level: uint32;
      string: cstring) {.cdecl.}

{.push importc, cdecl, dynlib: libName .}
proc Cap_createContext*(): CapContext 
  ## ```
                                                                              ##   ******************************************************************************* 
                                                                              ##        CONTEXT CREATION AND DEVICE ENUMERATION
                                                                              ##  *******************************************************************************
                                                                              ##      Initialize the capture library
                                                                              ##       @return The context ID.
                                                                              ## ```
proc Cap_releaseContext*(ctx: CapContext): CapResult
  ## ```
                          ##   Un-initialize the capture library context
                          ##       @param ctx The ID of the context to destroy.
                          ##       @return The context ID.
                          ## ```
proc Cap_getDeviceCount*(ctx: CapContext): uint32 
  ## ```
                          ##   Get the number of capture devices on the system.
                          ##       note: this can change dynamically due to the
                          ##       pluggin and unplugging of USB devices.
                          ##       @param ctx The ID of the context.
                          ##       @return The number of capture devices found.
                          ## ```
proc Cap_getDeviceName*(ctx: CapContext; index: CapDeviceID): cstring 
  ## ```
                                 ##   Get the name of a capture device.
                                 ##       This name is meant to be displayed in GUI applications,
                                 ##       i.e. its human readable.
                                 ##   
                                 ##       if a device with the given index does not exist,
                                 ##       NULL is returned.
                                 ##       @param ctx The ID of the context.
                                 ##       @param index The device index of the capture device.
                                 ##       @return a pointer to an UTF-8 string containting the name of the capture device.
                                 ## ```
proc Cap_getDeviceUniqueID*(ctx: CapContext; index: CapDeviceID): cstring 
  ## ```
                                          ##   Get the unique name of a capture device.
                                          ##       The string contains a unique concatenation
                                          ##       of the device name and other parameters.
                                          ##       These parameters are platform dependent.
                                          ##   
                                          ##       Note: when a USB camera does not expose a serial number,
                                          ##             platforms might have trouble uniquely identifying 
                                          ##             a camera. In such cases, the USB port location can
                                          ##             be used to add a unique feature to the string.
                                          ##             This, however, has the down side that the ID of
                                          ##             the camera changes when the USB port location 
                                          ##             changes. Unfortunately, there isn't much to
                                          ##             do about this.
                                          ##   
                                          ##       if a device with the given index does not exist,
                                          ##       NULL is returned.
                                          ##       @param ctx The ID of the context.
                                          ##       @param index The device index of the capture device.
                                          ##       @return a pointer to an UTF-8 string containting the unique ID of the capture device.
                                          ## ```
proc Cap_getNumFormats*(ctx: CapContext; index: CapDeviceID): int32 
  ## ```
                                 ##   Returns the number of formats supported by a certain device.
                                 ##       returns -1 if device does not exist.
                                 ##   
                                 ##       @param ctx The ID of the context.
                                 ##       @param index The device index of the capture device.
                                 ##       @return The number of formats supported or -1 if the device does not exist.
                                 ## ```
proc Cap_getFormatInfo*(ctx: CapContext; index: CapDeviceID; id: CapFormatID;
                        info: ptr CapFormatInfo): CapResult 
  ## ```
                          ##   Get the format information from a device. 
                          ##       @param ctx The ID of the context.
                          ##       @param index The device index of the capture device.
                          ##       @param id The index/ID of the frame buffer format (0 .. number returned by Cap_getNumFormats() minus 1 ).
                          ##       @param info pointer to a CapFormatInfo structure to be filled with data.
                          ##       @return The CapResult.
                          ## ```
proc Cap_openStream*(ctx: CapContext; index: CapDeviceID; formatID: CapFormatID): CapStream 
  ## ```
                                          ##   ******************************************************************************* 
                                          ##        STREAM MANAGEMENT
                                          ##  *******************************************************************************
                                          ##      Open a capture stream to a device with specific format requirements 
                                          ##   
                                          ##       Although the (internal) frame buffer format is set via the fourCC ID,
                                          ##       the frames returned by Cap_captureFrame are always 24-bit RGB.
                                          ##   
                                          ##       @param ctx The ID of the context.
                                          ##       @param index The device index of the capture device.
                                          ##       @param formatID The index/ID of the frame buffer format (0 .. number returned by Cap_getNumFormats() minus 1 ).
                                          ##       @return The stream ID or -1 if the device does not exist or the stream format ID is incorrect.
                                          ## ```
proc Cap_closeStream*(ctx: CapContext; stream: CapStream): CapResult 
  ## ```
                                 ##   Close a capture stream 
                                 ##       @param ctx The ID of the context.
                                 ##       @param stream The stream ID.
                                 ##       @return CapResult
                                 ## ```
proc Cap_isOpenStream*(ctx: CapContext; stream: CapStream): uint32 
  ## ```
                                 ##   Check if a stream is open, i.e. is capturing data. 
                                 ##       @param ctx The ID of the context.
                                 ##       @param stream The stream ID.
                                 ##       @return 1 if the stream is open and capturing, else 0.
                                 ## ```
proc Cap_captureFrame*(ctx: CapContext; stream: CapStream;
                       RGBbufferPtr: pointer; RGBbufferBytes: uint32): CapResult 
  ## ```
  ##   ******************************************************************************* 
  ##        FRAME CAPTURING / INFO
  ##  *******************************************************************************
  ##      this function copies the most recent RGB frame data
  ##       to the given buffer.
  ## ```
proc Cap_hasNewFrame*(ctx: CapContext; stream: CapStream): uint32 
  ## ```
                                 ##   returns 1 if a new frame has been captured, 0 otherwise
                                 ## ```
proc Cap_getStreamFrameCount*(ctx: CapContext; stream: CapStream): uint32 
  ## ```
                                          ##   returns the number of frames captured during the lifetime of the stream. 
                                          ##       For debugging purposes
                                          ## ```
proc Cap_getPropertyLimits*(ctx: CapContext; stream: CapStream;
                            propID: CapPropertyID; min: ptr int32;
                            max: ptr int32; dValue: ptr cint): CapResult 
  ## ```
                                          ##   ******************************************************************************* 
                                          ##        NEW CAMERA CONTROL API FUNCTIONS
                                          ##  *******************************************************************************
                                          ##      get the min/max limits and default value of a camera/stream property (e.g. zoom, exposure etc) 
                                          ##   
                                          ##       returns: CAPRESULT_OK if all is well.
                                          ##                CAPRESULT_PROPERTYNOTSUPPORTED if property not available.
                                          ##                CAPRESULT_ERR if context, stream are invalid.
                                          ## ```
proc Cap_setProperty*(ctx: CapContext; stream: CapStream; propID: CapPropertyID;
                      value: int32): CapResult 
  ## ```
                          ##   set the value of a camera/stream property (e.g. zoom, exposure etc) 
                          ##   
                          ##       returns: CAPRESULT_OK if all is well.
                          ##                CAPRESULT_PROPERTYNOTSUPPORTED if property not available.
                          ##                CAPRESULT_ERR if context, stream are invalid.
                          ## ```
proc Cap_setAutoProperty*(ctx: CapContext; stream: CapStream;
                          propID: CapPropertyID; bOnOff: uint32): CapResult 
  ##[
  ##   set the automatic flag of a camera/stream property (e.g. zoom, focus etc) 
  ##   
  ##       returns: CAPRESULT_OK if all is well.
  ##                CAPRESULT_PROPERTYNOTSUPPORTED if property not available.
  ##                CAPRESULT_ERR if context, stream are invalid.
  ]##
proc Cap_getProperty*(ctx: CapContext; stream: CapStream; propID: CapPropertyID;
                      outValue: ptr int32): CapResult 
  ## ```
                          ##   get the value of a camera/stream property (e.g. zoom, exposure etc) 
                          ##   
                          ##       returns: CAPRESULT_OK if all is well.
                          ##                CAPRESULT_PROPERTYNOTSUPPORTED if property not available.
                          ##                CAPRESULT_ERR if context, stream are invalid or outValue == NULL.
                          ## ```
proc Cap_getAutoProperty*(ctx: CapContext; stream: CapStream;
                          propID: CapPropertyID; outValue: ptr uint32): CapResult 
  ##[
  ##   get the automatic flag of a camera/stream property (e.g. zoom, focus etc) 
  ##   
  ##       returns: CAPRESULT_OK if all is well.
  ##                CAPRESULT_PROPERTYNOTSUPPORTED if property not available.
  ##                CAPRESULT_ERR if context, stream are invalid.
  ]##
proc Cap_setLogLevel*(level: uint32) 
  ## ```
                                                                             ##   ******************************************************************************* 
                                                                             ##        DEBUGGING
                                                                             ##  *******************************************************************************
                                                                             ##     
                                                                             ##       Set the logging level.
                                                                             ##   
                                                                             ##       LOG LEVEL ID  | LEVEL 
                                                                             ##       ------------- | -------------
                                                                             ##       LOG_EMERG     | 0
                                                                             ##       LOG_ALERT     | 1
                                                                             ##       LOG_CRIT      | 2
                                                                             ##       LOG_ERR       | 3
                                                                             ##       LOG_WARNING   | 4
                                                                             ##       LOG_NOTICE    | 5
                                                                             ##       LOG_INFO      | 6    
                                                                             ##       LOG_DEBUG     | 7
                                                                             ##       LOG_VERBOSE   | 8
                                                                             ## ```
proc Cap_installCustomLogFunction*(logFunc: CapCustomLogFunc) 
  ## ```
                          ##   install a custom callback for a logging function.
                          ##   
                          ##       the callback function must have the following 
                          ##       structure:
                          ##   
                          ##           void func(uint32_t level, const charstring);
                          ## ```
proc Cap_getLibraryVersion*(): cstring 
{.pop.}
{.pop.}

#----------- Pour some sugar on me!!
type
  CapError* = enum
    ceOk = 0, 
    ceErr = 1, 
    ceDeviceNotFound = 2, 
    ceFormatNotSupported = 3, 
    cePropertyNotSuported = 4

proc setAutoProperty*( ctx: CapContext; stream: CapStream;
                       propID: CapPropertyID; bOnOff: uint32):CapError = 
  ##[
  ##   set the automatic flag of a camera/stream property (e.g. zoom, focus etc) 
  ##   
  ##       returns: CAPRESULT_OK if all is well.
  ##                CAPRESULT_PROPERTYNOTSUPPORTED if property not available.
  ##                CAPRESULT_ERR if context, stream are invalid.
  ]##
  var err = Cap_setAutoProperty( ctx, stream, propID, bOnOff)
  return err.CapError

proc fourCCToString*(fourcc:uint32):string =
    var tmp:uint32 = fourcc
    var v:string
    for i in 0..<4:
        v &= (bitand(tmp, 0xFF)).char
        tmp = tmp shr 8
    return v

proc `$`*(obj:CapFormatInfo):string =
  let
    w = obj.width
    h = obj.height
    fps = obj.fps 
    bpp = obj.bpp
    fourcc = obj.fourcc
    fourccStr = fourCCToString(fourcc)
  &"{w} x {h} - fps: {fps} - bpp: {bpp} - fourcc: {fourccStr}"


proc getFormatInfo*(ctx: CapContext; index: CapDeviceID; id: CapFormatID):CapFormatInfo =
  var finfo:CapFormatInfo
  var err = ctx.Cap_getFormatInfo(index, id, addr finfo).CapError
  if err != ceOk:
    #quiet(QuitFailure, "Error: " & err)
    raise newException(ValueError, &"getFormatInfo > ctx.Cap_getFormatInfo: returned {err}" )
  return finfo

#proc Cap_getFormatInfo*(ctx: CapContext; index: CapDeviceID; id: CapFormatID;
#                        info: ptr CapFormatInfo): CapResult 