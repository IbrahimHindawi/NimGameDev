import sdl2/sdl
import GameSys

type
  Vector2* = object
    x*: int
    y*: int

  Entity* = ref object
    rect:sdl.Rect
    
proc newEntity(x, y, w, h:int):Entity=
  Entity(rect: sdl.Rect(sdl.Rect(x:x, y:y, w:w, h:h)))

proc setup():Entity=
  var entity:Entity = newEntity(32, 32, 32, 32)
  entity

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

proc update(entity: var Entity): void =
  entity.rect.x += 1
  entity.rect.y += 1


proc old_render(renderer:sdl.Renderer): void =
  discard renderer.setRenderDrawColor(1,1,1,0xFF)
  discard renderer.renderClear();
  discard renderer.setRenderDrawColor(64,64,64,0xFF)
  var ball=sdl.Rect(x:150, y:150, w:32, h:32)
  discard sdl.renderFillRect(renderer, addr(ball))
  renderer.renderPresent();

proc render_background(renderer:sdl.Renderer):void = 
  discard renderer.setRenderDrawColor(0,64,0,0xFF)
  discard renderer.renderClear();

proc render_entity(renderer:sdl.Renderer, entity:var Entity):void =
  discard renderer.setRenderDrawColor(64,0,64,0xFF)
  discard sdl.renderFillRect(renderer, addr(entity.rect))

proc render (renderer:sdl.Renderer, entity:var Entity): void =
  render_background(renderer)
  render_entity(renderer, entity)
  renderer.renderPresent()

proc main():void =
  var app:App = App(window: nil, renderer: nil)
  GameSys.initialize_system()
  app.window = GameSys.initialize_window()
  app.renderer = GameSys.initialize_renderer(app.window)
  app.renderer.renderPresent()

  var entity = setup()

  app.game_is_running = true
  while app.game_is_running:
    process_input(app.game_is_running)
    update(entity)
    #echo entity.rect.x
    render(app.renderer, entity)
  
  GameSys.destroy_system(app.window, app.renderer)


when isMainModule:
  main()