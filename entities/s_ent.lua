local Class = require("libs.hump.class")
local encoder = require("utils.s_encoder")

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

function Ent:move(x, y, dt)
  print(string.format('Moving ent to x = %d, y = %d', x, y))
  self.x = x
  self.y = y
end

function Ent:send_spawn_info()
  print(string.format("Sending spawn info to ip=%s, port=%s", self.ip, self.port))
  self.udp:sendto(encoder:encode_spawn(self), self.ip, self.port)
end

function Ent:send_move_info()
  print(string.format("Sending move info to ip=%s, port=%s", self.ip, self.port))
  self.udp:sendto(encoder:encode_move(self), self.ip, self.port)
end

return Ent
