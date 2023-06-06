local wrequire     = require("backend.helpers").wrequire
local setmetatable = setmetatable

local widget = { _NAME = "backend.widget" }

return setmetatable(widget, { __index = wrequire })
