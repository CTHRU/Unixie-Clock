require "queue"

NixieTubeState = { value = nil, display_queue = Queue:new() }

function NixieTubeState:new(o)
    o = o or { value = nil, display_queue = Queue:new() }
    setmetatable(o, self)
    self.__index = self
    return o
end
