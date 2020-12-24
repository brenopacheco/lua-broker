-- File:   broker.lua
-- Author: breno
-- Email:  breno@Manjaro
-- Date:   Thu 24 Dec 2020 09:02:38 AM WET
-- vim:    set ft=lua
local inspect = require('utils.inspect')

local Broker = {
    events = {}, -- "{ eventA = true }", "{ eventB }", ...
    subscribers = {}, -- "eventA: { callbackfunctionA, callbackfunctionB, ... }"
    history = {}
}

for _,v in pairs(Broker) do
    setmetatable(v, {
        __tostring = function(self) return inspect(self) end,
        __metatable = "Not modifiable"
    })
end

setmetatable(Broker, {
    __tostring = function(self) return inspect(self) end,
    __metatable = "Not modifiable"
})

function Broker.register(self, event)
    assert(event.name, "Event must have a name.")
    assert(not self.events[event.name], "Event is already registered.")
    self.events[event.name] = event
    self.subscribers[event.name] = {}
    -- print("Event " .. event.name .. " successfully registered")
end

function Broker.publish(self, event)
    assert(self.events[event.name], "Event is not registered.")
    -- print("Firing callbacks from event " .. event.name)
    for i, callback in ipairs(self.subscribers[event.name]) do
        callback()
    end
end

function Broker.subscribe(self, event, callback)
    assert(self.events[event.name], "Event is not registered.")
    table.insert(self.subscribers[event.name], callback)
    -- print("Callback successfully registered to event " .. event.name .. "")
end

return Broker

