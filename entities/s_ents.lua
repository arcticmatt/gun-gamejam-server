local json = require("libs.json.json")

local ents = {
  entMap = {},
}

function ents:add(key, ent)
  print('adding to map with key ', key)
  self.entMap[key] = ent
  print('val at key is now ', self.entMap[key])
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

function ents:update(ent_id, x, y, dt)
  print('updating with ent_id = ', ent_id)
  print('self.entMap[ent_id] = ', self.entMap[ent_id])
  self.entMap[ent_id]:update(x, y, dt)
end

function ents:send_move_info()
  for _, e in pairs(self.entMap) do
    e:send_move_info()
  end
end

function ents:serialize_updates()
  local ret = {cmd="update", ents={}}
  for id, e in pairs(self.entMap) do
    ret.ents[id] = {x=e.x, y=e.y}
  end

  return json.encode(ret)
end

return ents
