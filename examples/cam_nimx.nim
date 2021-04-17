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
  v.animation.loopDuration = 10.0
  v.animation.resume()


  # Webcam code
  v.ctx = Cap_createContext()
  var deviceCount = Cap_getDeviceCount(v.ctx)
  let
    deviceID  = 0'u32
    deviceFormatID = 0'u32
  v.streamID = v.ctx.Cap_openStream( deviceID, deviceFormatID )
  var info = v.ctx.getFormatInfo(deviceID, deviceFormatID)
  echo info
  v.width = info.width
  v.height = info.height 


  v.animation.onAnimate = proc(p: float) =
    if v.ctx.Cap_hasNewFrame(v.streamID) == 1:
      var n = (v.width * v.height * 3).uint32
      v.data = newSeq[uint8](n)      
      var err =  v.ctx.Cap_captureFrame(v.streamID, v.data[0].unsafeAddr, n)
      v.image = imageWithBitmap( v.data[0].addr, v.width.int, v.height.int, 3) #cast[ptr uint8](g[0].addr)
      echo repr v.image  
    #v.rotation = p * PI * 2
    #loadImageFromURL("http://gravatar.com/avatar/71b7b08fbc2f989a8246913ac608cca9") do(i: Image):
    #    v.httpImage = i
    #    v.setNeedsDisplay()

    #sharedAssetManager().getAssetAtPath("cat.jpg") do(i: Image, err: string):
    #    v.image = i
    #    v.setNeedsDisplay()


proc renderToImage(): Image =
    let r = imageWithSize(newSize(200, 80))
    #[
    r.draw:
        let c = currentContext()
        c.fillColor = newColor(0.5, 0.5, 1)
        c.strokeColor = newColor(1, 0, 0)
        c.strokeWidth = 3
        c.drawRoundedRect(newRect(0, 0, 200, 80), 20)
        c.fillColor = blackColor()
        let font = systemFontOfSize(32)
        c.drawText(font, newPoint(10, 25), "Runtime image")
    ]#
    result = r

method draw(v: FrameView, r: Rect) =
  let c = currentContext()
  #echo imageRect # (origin: (x: 0.0, y: 0.0), size: (width: 640.0, height: 480.0))
  #c.drawImage(v.image, imageRect)
  #[
  if not v.image.isNil:

    #imageRect.origin = imageSize.centerInRect(v.bounds)
    #let c = currentContext()
    echo imageRect # (origin: (x: 0.0, y: 0.0), size: (width: 640.0, height: 480.0))
    #for i in 0..100:

   ]#

  if not v.image.isNil:
    var imageSize = v.image.size
    var imageRect = newRect(zeroPoint, imageSize)      
    c.drawImage(v.image, imageRect)

proc startApp() =


  # Create window
  var mainWindow = newWindow(newRect(40, 40, 800, 600))
  #var currentView = View.new(newRect(0, 0, 640, 480))

  var fv = FrameView()#FrameView()
  var imageRect = newRect(0,0,640,480)  
  fv.init(imageRect)
  mainWindow.addSubview(fv)  
  #fv.frame.init


  for i in 0..5:
    sleep(500)
    #var imageSize = fv.image.size

    fv.draw(imageRect)
      #var imageSize = zeroSize

  mainWindow.addAnimation(fv.animation)
# Run the app
runApplication:
    startApp()