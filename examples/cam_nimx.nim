# nim c -r --threads:on ocnimx
import openpnp_capture, os
import nimx/window
import nimx / [ animation, view, image, context, render_to_image]

type FrameView = ref object of View
    image: Image
    animation: Animation
    ctx:CapContext
    streamID:CapStream
    width:uint32
    height:uint32
    data:seq[uint8]

method init*(v: FrameView, r: Rect) =
  procCall v.View.init(r)
  v.animation = newAnimation()
  v.animation.resume()

  # Webcam code
  v.ctx = Cap_createContext()
  var deviceCount = Cap_getDeviceCount(v.ctx)
  let
    deviceID  = 0'u32
    deviceFormatID = 0'u32
  v.streamID = v.ctx.Cap_openStream( deviceID, deviceFormatID )
  var info = v.ctx.getFormatInfo(deviceID, deviceFormatID)
  #echo info
  v.width = info.width
  v.height = info.height 

  # Read every frame and update the image
  v.animation.onAnimate = proc(p: float) =
    if v.ctx.Cap_hasNewFrame(v.streamID) == 1:
      var n = (v.width * v.height * 3).uint32
      v.data = newSeq[uint8](n)      
      var err =  v.ctx.Cap_captureFrame(v.streamID, v.data[0].unsafeAddr, n)
      v.image = imageWithBitmap( v.data[0].addr, v.width.int, v.height.int, 3) #cast[ptr uint8](g[0].addr)
      echo repr v.image  

method draw(v: FrameView, r: Rect) =
  let c = currentContext()

  if not v.image.isNil:
    var imageSize = v.image.size
    var imageRect = newRect(zeroPoint, imageSize)      
    c.drawImage(v.image, imageRect)

proc startApp() =
  # Create window
  var mainWindow = newWindow(newRect(40, 40, 800, 600))

  var fv = FrameView()
  var imageRect = newRect(0,0,640,480)  
  fv.init(imageRect)
  mainWindow.addSubview(fv)  
  mainWindow.addAnimation(fv.animation)

# Run the app
runApplication:
    startApp()