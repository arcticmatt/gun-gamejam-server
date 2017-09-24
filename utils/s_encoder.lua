-- TODO: make a separate library, so client and server don't repeat
local json = require("libs.json.json")

local encoder = {}

-- Note: all data is encoded into a table with the following shape:
-- {
--   ent_id: ...,
--   cmd: ...,
--   params: ...,
-- }
-- We don't really need to send the ent_id back to the client (except maybe
-- for assertions), but we do it for consistency.

-- ===== Module functions =====
-- input: an ent
-- output: ent's spawn info
function encoder:encode_spawn(ent)
  return encode_position(ent, "spawn")
end

-- input: an ent
-- output: ent's move info
function encoder:encode_move(ent)
  return encode_position(ent, "move")
end

-- ===== Helper functions =====
function encode_position(ent, cmd)
  return json.encode({ent_id = ent.id, cmd = cmd, params = {x = ent.x, y = ent.y}})
end

return encoder
