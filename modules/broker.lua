-- File:   broker.lua
-- Author: breno
-- Email:  breno@Manjaro
-- Date:   Thu 24 Dec 2020 09:02:38 AM WET
-- vim:    set ft=lua
local inspect = require('utils.inspect')

-- A pub/sub Event Broker
-- Allows registering Events and callback functions
-- to be fired on publishing a defined Event
local Broker = {
    events = {}, -- "{ eventA = true }", "{ eventB }", ...
    subscribers = {}, -- "eventA: { callbackfunctionA, callbackfunctionB, ... }"
    history = {},
    queue = {}
}

for _, v in pairs(Broker) do
    setmetatable(v, {
        __tostring = function(self) return inspect(self) end,
        __metatable = "Not modifiable"
    })
end

setmetatable(Broker, {
    __tostring = function(self) return inspect(self) end,
    __metatable = "Not modifiable"
})

-- Register Event
-- Register a new Event in the Broker
-- @param event the Event to register
function Broker.register(self, event)
    assert(event.name, "Event must have a name.")
    assert(not self.events[event.name], "Event is already registered.")
    self.events[event.name] = event
    self.subscribers[event.name] = {}
    -- print("Event " .. event.name .. " successfully registered")
end

-- Publish an Event
-- Publishes an Event to trigger published callback functions
-- @param event an Event registered in the Broker
function Broker.publish(self, event)
    assert(self.events[event.name], "Event is not registered.")
    -- print("Firing callbacks from event " .. event.name)
    for _, callback in ipairs(self.subscribers[event.name]) do
        table.insert(self.queue, callback)
    end
end

-- Subscribe to event
-- Subscribe a callback function to run when an Event is fired
-- @param event the Event that needs to be published
-- @param callback the callback function to run
function Broker.subscribe(self, event, callback)
    assert(self.events[event.name], "Event is not registered.")
    table.insert(self.subscribers[event.name], callback)
    -- print("Callback successfully registered to event " .. event.name .. "")
end

-- Execute function from queue
-- Dequeus a function from queue and executes it
function Broker.execute(self)
    if not self:empty() then
        local fun = table.remove(self.queue, 1)
        fun()
    end
end

-- Tells if execution queue is empty
-- Returns true if there are no callbacks to execute
function Broker.empty(self)
    return #self.queue <= 0
end

return Broker

