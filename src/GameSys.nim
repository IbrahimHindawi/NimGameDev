import sdl2/sdl

let
  SCR_HEIGHT*:int = 480
  SCR_WIDTH*:int = 640
  FPS:int = 30
  FRAME_TARGET_TIME*:float = 1000/FPS

var
  last_frame_time*:float

type
  App* = object
    window*:sdl.Window
    renderer*:sdl.Renderer
    game_is_running*:bool

proc initialize_system*():void =
  if sdl.init(sdl.INIT_EVERYTHING) != 0:
    echo "Failed to initialize system!", sdl.getError()

proc initialize_window*(): sdl.Window =
  var window:sdl.Window = sdl.createWindow(
    "Ibras",
    sdl.WINDOWPOS_CENTERED,
    sdl.WINDOWPOS_CENTERED,
    SCR_WIDTH,
    SCR_HEIGHT,
    sdl.WINDOW_BORDERLESS)
  if window == nil:
    echo "Error, could not initialize window!", sdl.getError()
  return window
  
proc initialize_renderer*(window:sdl.Window): sdl.Renderer =
  var renderer:sdl.Renderer = sdl.createRenderer(
    window,
    -1,
    sdl.RENDERER_ACCELERATED or sdl.RENDERER_PRESENTVSYNC)
  if renderer == nil:
    echo "Error, could not initialize renderer!", sdl.getError()
  return renderer

proc destroy_system*(window:sdl.Window, renderer:sdl.Renderer): void =
  sdl.destroyRenderer(window)
  sdl.destroyWindow(renderer)
  sdl.quit()