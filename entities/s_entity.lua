local Class = require("libs.hump.class")

local Entity = Class{}

-- Superclass of all entities
-- TODO: refactor argument passing
function Entity:init(x, y, w, h, udp, ip, port, id)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.udp = udp
  self.ip = ip
  self.port = port
  if not id then
    math.randomseed(os.time())
    self.id = math.random(99999)
  end
end

function Entity:getRect()
  return self.x, self.y, self.w, self.h
end

function Entity:draw()
  -- Do nothing by default
end

function Entity:update(x, y)
  self.x = x
  self.y = y
end

function Entity:send_info()
  udp:sendto(string.format("%d %s %d %d", self.id, 'at', v.x, v.y), self.ip, self.port)
end

-- TODO: tostring

return Entity
