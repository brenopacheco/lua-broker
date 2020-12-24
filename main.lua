-- File:   main.lua
-- Author: breno
-- Email:  breno@Manjaro
-- Date:   Thu 24 Dec 2020 11:55:07 AM WET
-- vim:    set ft=lua

local inspect = require('utils.inspect')
local Broker = require('modules.broker')
local Event = require('modules.event')

function read()
    io.write("Insert something:\n")
    local something = io.read()
    Broker:publish(Broker.events["Input"])
end

function handle()
    io.write("Handling input. gotta send the content in the event")
    read()
end

Broker:register(Event.new("Start", "program start"))
Broker:register(Event.new("Input", "input was entered"))

-- print(inspect(Broker))

Broker:subscribe(Broker.events["Start"], function ()
    io.write("Program started.");
    io.write("Subscribing callbacks.");
end)

Broker:subscribe(Broker.events["Start"], function ()
    io.input(io.stdin)
    io.output(io.stdout)
end)

Broker:subscribe(Broker.events["Start"], function ()
    read()
end)

Broker:subscribe(Broker.events["Input"], function ()
    io.write("Input was entered.");
end)

Broker:subscribe(Broker.events["Input"], function ()
    handle()
end)

Broker:publish(Broker.events["Start"])

while not Broker:empty() do
    Broker:execute()
end




