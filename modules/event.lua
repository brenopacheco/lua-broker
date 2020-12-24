-- File:   event.lua
-- Author: breno
-- Email:  breno@Manjaro
-- Date:   Thu 24 Dec 2020 09:05:33 AM WET
-- vim:    set ft=lua
local inspect = require('utils.inspect')

local Event = {}

Event.new = function (name, description)
    assert(type(name) == "string", "Name must be string" )
    assert(type(description) == "string", "Description must be string" )
    local event = { name = name, description = description}
    setmetatable(event, Event.metatable)
    return event
end

Event.prototype = {}
Event.metatable = {
    __tostring = function (self) return inspect(self) end,
    __index     = Event.prototype,
    __metatable = "Event is not modifiable",
}

return Event


