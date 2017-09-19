local Class = require("libs.hump.class")
local json = require("libs.json.json")

local Ent = Class{}

-- Superclass of all ents
-- TODO: refactor argument passing
function Ent:init(x, y, w, h, udp, ip, port, id)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.udp = udp
  self.ip = ip
  self.port = port
  self.id = id
end

function Ent:getRect()
  return self.x, self.y, self.w, self.h
end

function Ent:draw()
  -- Do nothing by default
end

function Ent:update(x, y, dt)
  self.x = x
  self.y = y
end

function Ent:send_spawn_info()
  print("Sending spawn info to ", self.ip, self.port, self.id, self.x, self.y)
  self.udp:sendto(string.format("%d %s %d %d", self.id, 'spawn',
    self.x, self.y), self.ip, self.port)
end

function Ent:send_move_info()
  self.udp:sendto(string.format("%d %s %d %d", self.id, 'move',
    self.x, self.y), self.ip, self.port)
end

function Ent:serialize()
  json.encode({x = self.x, y = self.y})
end

-- TODO: tostring

return Ent
