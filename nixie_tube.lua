require "cairo"
require "nixie_tube_state"

NixieTube = { id = "", cc = nil, digits = nil, images = nil, x = 0, y = 0, state = NixieTubeState:new() }

function NixieTube:new(id, cairo_context, digits, images, x, y, o)
    if id == nil then error("NixieTube:new - parameter id is required") end
    if cairo_context == nil then error("NixieTube:new - parameter cairo_context is required") end
    if digits == nil then error("NixieTube:new - parameter digits is required") end
    if images == nil then error("NixieTube:new - parameter images is required") end
    x = x or 0
    y = y or 0
    o = o or { id = id, cc = cairo_context, digits = digits, images = images, x = x, y = y, state = NixieTubeState:new() }
    setmetatable(o, self)
    self.__index = self
    return o
end

function NixieTube:get_value()
    return self.state.value
end

function NixieTube:get_display_queue_size()
    return self.state.display_queue.size
end

function NixieTube:has_display_queue()
    return self:get_display_queue_size() > 0
end

function NixieTube:draw_digit(value)
    -- print("NixieTube:draw_digit - Drawing nixie tube [" .. self.id .. "] with digit " .. value .. " at (" .. self.x .. ", " .. self.y .. ")")

    cairo_set_source_surface(self.cc, self.images[value], self.x, self.y)
    cairo_paint(self.cc)
    self.state.value = value
end

function NixieTube:draw()
    if self:has_display_queue() then
        self:draw_digit(self.state.display_queue:pop())
    else
        self:draw_digit(self.state.value)
    end
end

function NixieTube:add_to_display_queue(queue_values)
    for i, queue_value in ipairs(queue_values) do
        self.state.display_queue:push(queue_value)
    end
end

function NixieTube:add_value_to_display_queue(value, times)
    times = times or 1
    for i = 1, times do
        self.state.display_queue:push(value)
    end
end

function NixieTube:clear_display_queue()
    return self.state.display_queue:clear()
end
