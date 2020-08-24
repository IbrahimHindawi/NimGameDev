import sequtils
import sugar

import sdl2/sdl
import GameSys
import Collision
import Entity


# proc setup():Entity=
#   var entity:Entity = newEntity(GameSys.SCR_WIDTH/2-32, GameSys.SCR_HEIGHT/1-16, 64, 16, 120, Vec)
#   entity



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

  let state = getKeyboardState(nil)
  if state[SCANCODE_LEFT] > 0:
    entity.dire = Left
  if state[SCANCODE_RIGHT] > 0:
    entity.dire = Right

proc update_paddle(entity: var Entity) =
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

proc update_ball(entity: var Entity) =
  while (not sdl.ticksPassed(float(sdl.getTicks()), GameSys.last_frame_time + GameSys.FRAME_TARGET_TIME) ):
    discard
  var delta_time:float = (float(sdl.getTicks()) - GameSys.last_frame_time) / 1000.0
  GameSys.last_frame_time = float(sdl.getTicks())

  moveBall(entity, entity.velo.x * delta_time * entity.speed, entity.velo.y * delta_time * entity.speed)
  checkBorders(entity)

proc update(paddle: var Entity, ball: var Entity) =
  update_paddle(paddle)
  update_ball(ball)

proc render_background(renderer:sdl.Renderer) = 
  discard renderer.setRenderDrawColor(5,5,5,0xFF)
  discard renderer.renderClear();

proc render_entity(renderer:sdl.Renderer, entity:var Entity) =
  discard renderer.setRenderDrawColor(255,255,255,0xFF)
  discard sdl.renderFillRectF(renderer, addr(entity.rect))


proc main() =
#[                                ]
______INIT_________________________
[                                 ]#                                
  var app:App = App(window: nil, renderer: nil)
  GameSys.initialize_system()
  app.window = GameSys.initialize_window()
  app.renderer = GameSys.initialize_renderer(app.window)
  #app.renderer.renderPresent()

#[                                ]
______SETUP________________________
[                                ]#   
  var paddle:Entity = newEntity(GameSys.SCR_WIDTH/2-64/2, GameSys.SCR_HEIGHT/1-8,
                                64, 8,
                                900,
                                Vector2(x:0, y:0))

  var ball  :Entity = newEntity(GameSys.SCR_HEIGHT/2, GameSys.SCR_WIDTH/2,
                                5, 5,
                                200,
                                Vector2(x: 1, y: 1))

  var luke  :Entity = newEntity(SCR_WIDTH/2 - 16, SCR_HEIGHT/2 + 110,
                                32, 32,
                                190,
                                Vector2(x: 0, y: 0))

  var 
    startX:float = SCR_WIDTH/8
    startY:float = SCR_HEIGHT/8
    nWidth:int   = 5
    blocks:seq[Entity]
    coords:seq[(int,int)]
    
  for i in 0 .. nWidth:
    for j in 0 .. nWidth:
      coords.add( (i,j) )
      #var blck = newEntity(startX+float(i*2), startY+float(j*8),
      #[
      var blck = newEntity(i.float * 20, j.float * 20,
                      32, 16,
                      0,
                      Vector2(x:0, y:0))             
      blocks.add(blck)]#

  #echo blocks.len

  for item in 0 .. coords.len-1:
    echo coords[item][1]
    var blck = newEntity(coords[item][0].float * 20, coords[item][1].float * 20,
                      32, 16,
                      0,
                      Vector2(x:0, y:0))             
    blocks.add(blck)

  # for blck in blocks:
  #   echo  "( x = ", blck.rect.x, ", y = ", blck.rect.y, ")"
#[
  var xcords = @[0, 1, 2, 3, 4, 5]
  var coords = map(xcords, (x:int) -> (int, int) => (x*3,x*3))
  #echo ycords
  echo coords[0][0].float
  for blck in 0 .. nWidth:
    var counter = 0
    var blck = newEntity(coords[counter][0].float, coords[counter][1].float,
                32, 16,
                0,
                Vector2(x:0, y:0)) 
    blocks.add(blck)
    counter += 1
]#
#[                                ]
______LOOP_________________________
[                                ]#   
  app.game_is_running = true
  while app.game_is_running:
    process_input(app.game_is_running, paddle)


    update(paddle, ball)

    resolvePaddleBallCollision(paddle, ball)
    for i in 0 .. nWidth:
      resolveBlockBallCollision(blocks[i], ball)
    #resolveBlockBallCollision(luke, ball)

    render_background(app.renderer)
    render_entity(app.renderer, paddle)
    render_entity(app.renderer, ball)
    for i in 0 .. nWidth:
      render_entity(app.renderer, blocks[i])
    #render_entity(app.renderer, luke)
    app.renderer.renderPresent()

    # update_paddle(luke)

    # render_background(app.renderer)
    # render_entity(app.renderer, luke)
    # app.renderer.renderPresent()
   






  GameSys.destroy_system(app.window, app.renderer)


when isMainModule:
  main()