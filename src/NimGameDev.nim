import sdl2/sdl
import GameSys

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

  discard renderer.setRenderDrawColor(64,64,64,0xFF)
  var ball=sdl.Rect(x:150, y:150, w:32, h:32)
  discard sdl.renderFillRect(renderer, addr(ball))

  renderer.renderPresent();
  

proc main():void =
  var app:App = App(window: nil, renderer: nil)
  GameSys.initialize_system()
  app.window = GameSys.initialize_window()
  app.renderer = GameSys.initialize_renderer(app.window)
  app.renderer.renderPresent()
  app.game_is_running = true

  echo("game initialized")

  while app.game_is_running:
    process_input(app.game_is_running)
    update()
    render(app.renderer)
  #sdl.delay(2000)
  GameSys.destroy_system(app.window, app.renderer)


when isMainModule:
  main()