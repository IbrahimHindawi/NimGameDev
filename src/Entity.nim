import sdl2/sdl
import GameSys

type
  Vector2* = object
    x*: float
    y*: float

  Direction* = enum
    None, Left, Right

  Entity* = ref object
    rect*:sdl.Rect
    velo*:Vector2
    dire*:Direction
    speed*:float

proc newEntity*(posx, posy, w, h, speed:float, velo:Vector2):Entity =
  Entity(rect: sdl.Rect(x:int(posx), y:int(posy), w:int(w), h:int(h)),
        dire:None,
        speed:speed,
        velo:velo)

proc updateEntity*(entity:Entity, x, y:float) =
  entity.velo.x = x
  entity.velo.y = y

  entity.rect.x += int(entity.velo.x)
  entity.rect.y += int(entity.velo.y)

  if entity.rect.x > SCR_WIDTH-entity.rect.w:
    entity.rect.x = SCR_WIDTH-entity.rect.w
  if entity.rect.x < 0:
    entity.rect.x = 0

proc bounceBorder*(entity:Entity, x, y:float) =
  entity.rect.x += int(x)
  entity.rect.y += int(y)

proc checkBorders*(entity:Entity) =
  if entity.rect.x < 0:
    entity.velo.x *= -1
  if entity.rect.x > SCR_WIDTH-entity.rect.w:
    entity.velo.x *= -1
  if entity.rect.y < 0:
    entity.velo.y *= -1


#[                                ]
______COLLISION____________________
[                                ]#  
proc collisionDetect*(entityA: Entity, entityB: Entity) :bool=
  if entityA.rect.x < entityB.rect.x + entityB.rect.w and
    entityA.rect.x + entityA.rect.w > entityB.rect.x and
    entityA.rect.y < entityB.rect.y + entityB.rect.h and
    entityA.rect.y + entityA.rect.h > entityB.rect.y:
      return true

proc collisionDetectTop*(entityA: Entity, entityB: Entity): bool =
  if entityB.rect.y + entityB.rect.h > entityA.rect.y and
    entityB.rect.x + entityB.rect.w > entityA.rect.x + 1 and
    entityB.rect.x < entityA.rect.x + entityA.rect.w - 1 and
    entityB.rect.y < entityA.rect.y + 2 :
      echo "TOP"
      return true


proc collisionDetectLeft*(entityA: Entity, entityB: Entity): bool =
  if entityB.rect.x + entityB.rect.w > entityA.rect.x and
    entityB.rect.x < entityA.rect.x + 1 and
    entityB.rect.y < entityA.rect.y + entityA.rect.h and
    entityB.rect.y + entityB.rect.h  > entityA.rect.y:
      echo "Left"
      return true

proc collisionDetectRight*(entityA: Entity, entityB: Entity): bool =
  if entityB.rect.x + entityB.rect.w > entityA.rect.x + entityA.rect.w - 1 and
    entityB.rect.x < entityA.rect.x + entityA.rect.w and
    entityB.rect.y < entityA.rect.y + entityA.rect.h and
    entityB.rect.y + entityB.rect.h  > entityA.rect.y:
      echo "Right"
      return true

proc collisionDetectBottom*(entityA: Entity, entityB: Entity): bool =
  if entityB.rect.x + entityB.rect.w > entityA.rect.x + 1 and
    entityB.rect.x < entityA.rect.x + entityA.rect.w - 1 and
    entityB.rect.y < entityA.rect.y + entityA.rect.h and
    entityB.rect.y + entityB.rect.h > entityA.rect.y + entityA.rect.h - 1:
      echo "Bot"
      return true

proc resolvePaddleBallCollision*(paddle: Entity, ball: Entity) =
  if collisionDetectTop(paddle, ball):
    ball.velo.y *= -1
  if collisionDetectLeft(paddle, ball):
    ball.velo.x *= -1
  if collisionDetectRight(paddle, ball):
    ball.velo.x *= -1

proc resolveBlockBallCollision*(blck: Entity, ball: Entity) =
  if collisionDetectTop(blck, ball):
    ball.velo.y *= -1
    blck.rect.w = 0
    blck.rect.h = 0
  if collisionDetectLeft(blck, ball):
    ball.velo.x *= -1
    blck.rect.w = 0
    blck.rect.h = 0
  if collisionDetectRight(blck, ball):
    ball.velo.x *= -1
    blck.rect.w = 0
    blck.rect.h = 0
  if collisionDetectBottom(blck, ball):
    ball.velo.y *= -1
    blck.rect.w = 0
    blck.rect.h = 0
