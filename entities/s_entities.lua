local entities = {
  entityMap = {},
}

function entities:add(key, entity)
  print('adding to map with key ', key)
  self.entityMap[key] = entity
  print('val at key is now ', self.entityMap[key])
end

function entities:add_many(entities)
  for k, e in pairs(entities) do
    self:add(k, e)
  end
end

function entities:get_entity(id)
  return self.entityMap[id]
end

function entities:clear()
  self.entityMap = {}
end

function entities:draw()
  for k, e in pairs(self.entityMap) do
    e:draw(k)
  end
end

function entities:update(ent_id, x, y, dt)
  print('updating with ent_id = ', ent_id)
  print('self.entityMap[ent_id] = ', self.entityMap[ent_id])
  self.entityMap[ent_id]:update(x, y, dt)
end

function entities:send_at_info()
  for _, e in pairs(self.entityMap) do
    e:send_at_info()
  end
end

return entities
