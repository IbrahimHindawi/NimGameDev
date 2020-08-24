import Entity
import GameSys
import sdl2/sdl
#[                                ]
______COLLISION____________________
[                                ]#  


proc checkBorders*(entity:Entity) =
  if entity.rect.x < 0:
    entity.velo.x *= -1
  if entity.rect.x > float(SCR_WIDTH)-entity.rect.w:
    entity.velo.x *= -1
  if entity.rect.y < 0:
    entity.velo.y *= -1
    
proc collisionDetect*(entityA: Entity, entityB: Entity) :bool=
  if entityA.rect.x < entityB.rect.x + entityB.rect.w and
    entityA.rect.x + entityA.rect.w > entityB.rect.x and
    entityA.rect.y < entityB.rect.y + entityB.rect.h and
    entityA.rect.y + entityA.rect.h > entityB.rect.y:
    return true

proc collisionDetectTop*(entityA: Entity, entityB: Entity): bool =
  if entityB.rect.y + entityB.rect.h > entityA.rect.y and
    entityB.rect.x + entityB.rect.w > entityA.rect.x and
    entityB.rect.x < entityA.rect.x + entityA.rect.w and
    entityB.rect.y < entityA.rect.y + 1 :
    echo "TOP"
    return true


proc collisionDetectLeft*(entityA: Entity, entityB: Entity): bool =
  if entityB.rect.x + entityB.rect.w > entityA.rect.x and
    entityB.rect.x < entityA.rect.x + 1 and
    entityB.rect.y < entityA.rect.y + entityA.rect.h - 1 and
    entityB.rect.y + entityB.rect.h  > entityA.rect.y + 1 :
    echo "Left"
    return true

proc collisionDetectRight*(entityA: Entity, entityB: Entity): bool =
  if entityB.rect.x + entityB.rect.w > entityA.rect.x + entityA.rect.w - 1 and
    entityB.rect.x < entityA.rect.x + entityA.rect.w and
    entityB.rect.y < entityA.rect.y + entityA.rect.h and
    entityB.rect.y + entityB.rect.h  > entityA.rect.y + 1:
    echo "Right"
    return true

proc collisionDetectBottom*(entityA: Entity, entityB: Entity): bool =
  if entityB.rect.x + entityB.rect.w > entityA.rect.x and
    entityB.rect.x < entityA.rect.x + entityA.rect.w and
    entityB.rect.y + entityB.rect.h > entityA.rect.y + entityA.rect.h - 1 and
    entityB.rect.y < entityA.rect.y + entityA.rect.h:
    echo "Bot"
    return true

proc resolvePaddleBallCollision*(paddle: Entity, ball: Entity) =
  if collisionDetectTop(paddle, ball):
    ball.velo.y *= -1
  if collisionDetectLeft(paddle, ball):
    ball.velo.x *= -1
    ball.velo.y *= -1
  if collisionDetectRight(paddle, ball):
    ball.velo.x *= -1
    ball.velo.y *= -1

proc resolveBlockBallCollision*(blck: Entity, ball: Entity) =
  if collisionDetectTop(blck, ball):
    ball.velo.y *= -1
    blck.rect.x = 0
    blck.rect.y = 0
    blck.rect.w = 0
    blck.rect.h = 0
  if collisionDetectLeft(blck, ball):
    ball.velo.x *= -1
    blck.rect.x = 0
    blck.rect.y = 0
    blck.rect.w = 0
    blck.rect.h = 0
  if collisionDetectRight(blck, ball):
    ball.velo.x *= -1
    blck.rect.x = 0
    blck.rect.y = 0
    blck.rect.w = 0
    blck.rect.h = 0
  if collisionDetectBottom(blck, ball):
    ball.velo.y *= -1
    blck.rect.x = 0
    blck.rect.y = 0
    blck.rect.w = 0
    blck.rect.h = 0

