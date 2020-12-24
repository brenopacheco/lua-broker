-- File:   test/broker.lua
-- Author: breno
-- Email:  breno@Manjaro
-- Date:   Thu 24 Dec 2020 10:31:48 AM WET
-- vim:    set ft=lua
local M = {}
Broker = require('modules.broker')
Event = require('modules.event')

M.test = function()

    local eventA = Event.new("eventA", "test event")
    local eventB = Event.new("eventB", "test event")
    Broker:register(eventA)
    Broker:register(eventB)
    Broker:subscribe(eventA, function() print("running callback function 1") end)
    Broker:subscribe(eventA, function() print("running callback function 2") end)
    Broker:subscribe(eventB, function() print("running callback function 3") end)
    Broker:publish(eventA)
    Broker:publish(eventB)
    print(Broker.queue)
    while not Broker:empty() do Broker:execute() end

end

M.test()

return M

