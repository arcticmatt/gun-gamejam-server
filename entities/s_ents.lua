local ents = {
  entMap = {},
}

function ents:add(key, ent)
  self.entMap[key] = ent
end

function ents:add_many(ents)
  for k, e in pairs(ents) do
    self:add(k, e)
  end
end

function ents:get_ent(id)
  return self.entMap[id]
end

function ents:clear()
  self.entMap = {}
end

function ents:draw()
  for k, e in pairs(self.entMap) do
    e:draw(k)
  end
end

function ents:move(ent_id, x, y, dt)
  self.entMap[ent_id]:move(x, y, dt)
end

function ents:send_move_info()
  for _, e in pairs(self.entMap) do
    e:send_move_info()
  end
end

return ents
