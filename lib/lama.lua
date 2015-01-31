local robot = require "robot"
local sides = require "sides"

local lama = {}
local location, theta = {x=0, y=0, z=0}, nil

-- Location functions
function lama.setLocation(x, y, z)
  location = {x=x, y=y, z=z}
  return location
end

function lama.getLocation()
  return {location.x, location.y, location.z}
end

function lama.getPosition()
  return location.x, location.y, location.z
end

function lama.getX()
  return location.x
end

function lama.getY()
  return location.y
end

function lama.getZ()
  return location.z
end

-- Orientation functions
function lama.setOrientation(t)
  if t > 6 or t < 2 then
    return nil, "Orientation not in range"
  end
  theta = t
  return theta
end

function lama.getOrientation()
  return theta
end

function lama.turnLeft()
  theta = ({nil, 4, 5, 3, 2})[theta]
  return robot.turnLeft()
end

function lama.turnRight()
  theta = ({nil, 5, 4, 2, 3})[theta]
  return robot.turnRight()
end

function lama.turnAround()
  local res, reason = lama.turnRight()
  if res then
    return lama.turnRight()
  end
  return res, reason
end

-- Movement functions
local function funcCreator(move, swing, detect)
  return function(d, a)
    d = d or 1
    local i = 0
    while i < d do
      local res, reason = detect()
      if res then
        if not a or not swing() then
          return (i > 0 and i or nil), reason
        end
      end
      res, reason = move()
      if not res then
        return (i > 0 and i or nil), reason
      end
      i = i + 1
    end
    return i
  end
end

local function forward()
  local res, reason = robot.forward()
  if res then
    if theta == sides.negz then
      location.z = location.z - 1
    elseif theta == sides.posz then
      location.z = location.z + 1
    elseif theta == sides.negx then
      location.x = location.x - 1
    elseif theta == sides.posx then
      location.x = location.x + 1
    end
  end
  return res, reason
end

local function back()
  local res, reason = robot.back()
  if res then
    if theta == sides.negz then
      location.z = location.z + 1
    elseif theta == sides.posz then
      location.z = location.z - 1
    elseif theta == sides.negx then
      location.x = location.x + 1
    elseif theta == sides.posx then
      location.x = location.x - 1
    end
  end
  return res, reason
end

local function up()
  local res, reason = robot.up()
  if res then
    location.y = location.y + 1
  end
  return res, reason
end

local function down()
  local res, reason = robot.down()
  if res then
    location.y = location.y - 1
  end
  return res, reason
end

lama.forward = funcCreator(forward, robot.swing, robot.detect)
lama.up      = funcCreator(up, robot.swingUp, robot.detectUp)
lama.down    = funcCreator(down, robot.swingDown, robot.detectDown)
lama.back    = funcCreator(back, function() end, function() return nil end)

-- High level Movement functions
function lama.moveTo(x, y, z)
  local res, reason
  if y < 0 then
    res, reason = lama.down(math.abs(y))
  else
    res, reason = lama.up(y)
  end
  if not res then
    return res, reason
  end
  if theta == sides.negz or theta == sides.posz then
    if (z <  0 and theta == sides.negz) or 
       (z >= 0 and theta == sides.posz) then
      res, reason = lama.forward(math.abs(z))
    else
      lama.turnAround()
      res, reason = lama.forward(math.abs(z))
    end
    if not res then
      return res, reason
    end
    if (x <  0 and theta == sides.posz) or
       (x >= 0 and theta == sides.negz) then
      lama.turnRight()
    else
      lama.turnLeft()
    end
    res, reason = lama.forward(math.abs(x))
  else
    if (x <  0 and theta == sides.negx) or 
       (x >= 0 and theta == sides.posx) then
      res, reason = lama.forward(math.abs(x))
    else
      lama.turnAround()
      res, reason = lama.forward(math.abs(x))
    end
    if not res then
      return res, reason
    end
    if (z <  0 and theta == sides.posx) or
       (z >= 0 and theta == sides.negx) then
      lama.turnRight()
    else
      lama.turnLeft()
    end
    res, reason = lama.forward(math.abs(z))
  end
  return res, reason
end

return lama
