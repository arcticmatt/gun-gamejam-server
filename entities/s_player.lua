local Class  = require("libs.hump.class")
local Entity = require("entities.Entity")
vector = require("libs.hump.vector")

local Player = Class{
  __includes = Entity -- Player class inherits our Entity class
}

local directions = { up = "up", down = "down", left = "left", right = "right" }


function Player:init(x, y, w, h)
  Entity.init(self, x, y, w, h)
  self.kb = vector(0, 0)
end

function Player:update(x, y)
  -- TODO: complete
  self.x, self.y = x, y
end

function Player:draw()
  love.graphics.rectangle("fill", self:getRect())
end

return Player
