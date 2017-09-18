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
  self.id = id
end

function Entity:getRect()
  return self.x, self.y, self.w, self.h
end

function Entity:draw()
  -- Do nothing by default
end

function Entity:update(x, y, dt)
  self.x = x
  self.y = y
end

function Entity:send_spawn_info()
  print("Sending spawn info to ", self.ip, self.port, self.id, self.x, self.y)
  self.udp:sendto(string.format("%d %s %d %d", self.id, 'spawn',
    self.x, self.y), self.ip, self.port)
end

function Entity:send_at_info()
  self.udp:sendto(string.format("%d %s %d %d", self.id, 'at',
    self.x, self.y), self.ip, self.port)
end

-- TODO: tostring

return Entity
