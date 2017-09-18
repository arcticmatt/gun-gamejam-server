local Class  = require("libs.hump.class")
local Entity = require("entities.s_entity")
vector = require("libs.hump.vector")

local Player = Class{
  __includes = Entity -- Player class inherits our Entity class
}

local directions = { up = "up", down = "down", left = "left", right = "right" }


function Player:init(x, y, w, h, udp, ip, port, id)
  Entity.init(self, x, y, w, h, udp, ip, port, id)
  self.kb = vector(0, 0)
  self.baseVelocity = 300
end

function Player:update(x, y, dt)
  self.kb = vector(x, y)
  self.kb = self.kb * self.baseVelocity * dt
  self.kb:trimInplace(self.baseVelocity * dt)

  -- TODO: no boundaries
  self.x, self.y = self.x + self.kb.x, self.y + self.kb.y
end

function Player:draw()
  love.graphics.rectangle("fill", self:getRect())
end

return Player
