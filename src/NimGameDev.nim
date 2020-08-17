# ex101_init.nim
# ==============
# BASICS / Initialization and shutdown
# ------------------------------------


import sdl2/sdl

type
  App* = object
    window:sdl.Window
    renderer:sdl.Renderer
    game_is_running:bool

proc initialize_system():void =
  if sdl.init(sdl.INIT_EVERYTHING) != 0:
    echo "Failed to initialize system!", sdl.getError()

proc initialize_window(): sdl.Window =
  var window:sdl.Window = sdl.createWindow(
    "Ibras",
    sdl.WINDOWPOS_CENTERED,
    sdl.WINDOWPOS_CENTERED,
    640,
    480,
    sdl.WINDOW_BORDERLESS)
  if window == nil:
    echo "Error, could not initialize window!", sdl.getError()
  return window
  
proc initialize_renderer(window:sdl.Window): sdl.Renderer =
  var renderer:sdl.Renderer = sdl.createRenderer(
    window,
    -1,
    sdl.RENDERER_ACCELERATED or sdl.RENDERER_PRESENTVSYNC)
  if renderer == nil:
    echo "Error, could not initialize renderer!", sdl.getError()
  return renderer

proc destroy_system(window:sdl.Window, renderer:sdl.Renderer): void =
  sdl.destroyRenderer(window)
  sdl.destroyWindow(renderer)
  sdl.quit()

proc process_input(game_is_running:var bool): void =
  var event: sdl.Event
  discard sdl.pollEvent(addr(event))
  case event.kind:
    of sdl.Quit:
      game_is_running = false
    of sdl.KEYDOWN:
      case event.key.keysym.sym:
        of sdl.K_ESCAPE:
          game_is_running = false
        else:
          discard
    else:
      discard

proc update(): void =
  #echo("Update")
  discard

proc render(renderer:sdl.Renderer): void =
  discard renderer.setRenderDrawColor(1,1,1,0xFF)
  discard renderer.renderClear();

  discard renderer.setRenderDrawColor(32,32,32,0xFF)
  var ball=sdl.Rect(x:0, y:0, w:32, h:32)
  discard sdl.renderFillRect(renderer, addr(ball))

  renderer.renderPresent();
  

proc main():void =
  var app:App = App(window: nil, renderer: nil)
  initialize_system()
  app.window = initialize_window()
  app.renderer = initialize_renderer(app.window)
  app.renderer.renderPresent()
  app.game_is_running = true

  echo("game initialized")

  while app.game_is_running:
    process_input(app.game_is_running)
    update()
    render(app.renderer)
  #sdl.delay(2000)
  destroy_system(app.window, app.renderer)


when isMainModule:
  main()