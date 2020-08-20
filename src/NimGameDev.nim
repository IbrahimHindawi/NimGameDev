import sdl2/sdl
import GameSys
import math

type
  Vector2* = object
    x*: float
    y*: float

  Direction* = enum
    None, Left, Right

  Entity* = ref object
    rect*:sdl.Rect
    dire*:Direction
    speed*:float

    
proc newEntity(posx, posy, w, h, speed:float):Entity=
  Entity(rect: sdl.Rect(x:int(posx), y:int(posy), w:int(w), h:int(h)),
        dire:None,
        speed:speed)

proc updateEntity(entity:Entity, x, y:float)=
  entity.rect.x += int(x)
  entity.rect.y += int(y)
  if entity.rect.x > SCR_WIDTH-entity.rect.w:
    entity.rect.x = SCR_WIDTH-entity.rect.w
  if entity.rect.x < 0:
    entity.rect.x = 0
    
    
  

proc setup():Entity=
  var entity:Entity = newEntity(GameSys.SCR_WIDTH/2-32, GameSys.SCR_HEIGHT/1-16, 64, 16, 120)
  entity

proc process_input(game_is_running:var bool, entity:Entity) =
  var event: sdl.Event
  discard sdl.pollEvent(addr(event))
  case event.kind:
    of sdl.Quit:
      game_is_running = false
    of sdl.KEYDOWN:
      case event.key.keysym.sym:
        of sdl.K_ESCAPE:
          game_is_running = false
        of sdl.K_LEFT:
          entity.dire = Left
          discard
        of sdl.K_RIGHT:
          entity.dire = Right
          discard
        else:
          discard
    of sdl.KEYUP:
      case event.key.keysym.sym:
        of sdl.K_LEFT:
          entity.dire = None
        of sdl.K_RIGHT:
          entity.dire = None
        else:
          discard
    else:
      discard

proc update(entity: var Entity) =
  while (not sdl.ticksPassed(float(sdl.getTicks()), GameSys.last_frame_time + GameSys.FRAME_TARGET_TIME) ):
    discard
  var delta_time:float = (float(sdl.getTicks()) - GameSys.last_frame_time) / 1000.0
  GameSys.last_frame_time = float(sdl.getTicks())
  case entity.dire:
    of Left:
      updateEntity(entity, -entity.speed * delta_time, 0 )
    of Right:
      updateEntity(entity, entity.speed * delta_time, 0 )
    of None:
      updateEntity(entity, 0, 0 )


proc old_render(renderer:sdl.Renderer) =
  discard renderer.setRenderDrawColor(1,1,1,0xFF)
  discard renderer.renderClear();
  discard renderer.setRenderDrawColor(64,64,64,0xFF)
  var ball=sdl.Rect(x:150, y:150, w:32, h:32)
  discard sdl.renderFillRect(renderer, addr(ball))
  renderer.renderPresent();

proc render_background(renderer:sdl.Renderer) = 
  discard renderer.setRenderDrawColor(5,5,5,0xFF)
  discard renderer.renderClear();

proc render_entity(renderer:sdl.Renderer, entity:var Entity) =
  discard renderer.setRenderDrawColor(255,255,255,0xFF)
  discard sdl.renderFillRect(renderer, addr(entity.rect))

proc render (renderer:sdl.Renderer, entity:var Entity) =
  render_background(renderer)
  render_entity(renderer, entity)
  renderer.renderPresent()

proc main() =
#[                                ]
______INIT_________________________
[                                 ]#                                
  var app:App = App(window: nil, renderer: nil)
  GameSys.initialize_system()
  app.window = GameSys.initialize_window()
  app.renderer = GameSys.initialize_renderer(app.window)
  app.renderer.renderPresent()

#[                                ]
______SETUP________________________
[                                ]#   
  var entity:Entity = setup()

#[                                ]
______LOOP_________________________
[                                ]#   
  app.game_is_running = true
  while app.game_is_running:
    process_input(app.game_is_running, entity)
    update(entity)
    #echo entity.rect.x
    render(app.renderer, entity)
  
  GameSys.destroy_system(app.window, app.renderer)


when isMainModule:
  main()