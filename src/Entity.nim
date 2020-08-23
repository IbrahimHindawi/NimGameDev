import sdl2/sdl
import GameSys

type
  Vector2* = object
    x*: float
    y*: float

  Direction* = enum
    None, Left, Right

  Entity* = ref object
    rect*:FRect
    velo*:Vector2
    dire*:Direction
    speed*:float

proc newEntity*(posx, posy, w, h, speed:float, velo:Vector2):Entity =
  Entity(rect: FRect(x:posx, y:posy, w:w, h:h),
        dire:None,
        speed:speed,
        velo:velo)

proc updateEntity*(entity:Entity, x, y:float) =
  entity.velo.x = x
  entity.velo.y = y

  entity.rect.x += entity.velo.x
  entity.rect.y += entity.velo.y

  if entity.rect.x > float(SCR_WIDTH)-entity.rect.w:
    entity.rect.x = float(SCR_WIDTH)-entity.rect.w
  if entity.rect.x < 0:
    entity.rect.x = 0

proc destroyEntity*(entity:var Entity) =
  entity = nil
  
proc moveBall*(entity:Entity, x, y:float) =
  entity.rect.x += x
  entity.rect.y += y

