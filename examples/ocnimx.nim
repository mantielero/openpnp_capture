# nim c -r --threads:on ocnimx

import openpnp_capture, os
import nimx/window
import nimx / [ view, image, context, render_to_image]

proc startApp() =
  # Webcam code
  var ctx:CapContext = Cap_createContext()
  var deviceCount = Cap_getDeviceCount(ctx)
  let
    deviceID  = 0'u32
    deviceFormatID = 0'u32
  var streamID = ctx.Cap_openStream( deviceID, deviceFormatID )
  var info = ctx.getFormatInfo(deviceID, deviceFormatID)
  echo info
  var row = info.width
  var col = info.height 
  var n = (info.width * info.height * 3).uint32
  var g = newSeq[uint8](n) 

  # Create window
  var mainWindow = newWindow(newRect(40, 40, 800, 600))
  var currentView = View.new(newRect(0, 0, 640, 480))
  mainWindow.addSubview(currentView)

  let r = imageWithSize(newSize(640, 480))

  for i in 0..5:
    sleep(500)
    if ctx.Cap_hasNewFrame(streamID) == 1:
      var err =  ctx.Cap_captureFrame(streamID, g[0].unsafeAddr, n)
      #--------------- OK until here
      let image = imageWithBitmap(cast[ptr uint8](g[0].addr), info.width.int, info.height.int, 3)
      #let imageRect.origin = imageSize.centerInRect(v.bounds)
      #var imageSize = zeroSize
      var imageSize = image.size
      var imageRect = newRect(zeroPoint, imageSize)
      let c = currentContext()
      c.drawImage(image, imageRect) #newRect(40, 40, 800, 600))
      #echo "Captura: ", err

# Run the app
runApplication:
    startApp()