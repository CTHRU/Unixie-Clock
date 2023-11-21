require "cairo"
require "nixie_tube"


local DIGIT_OFF = "OFF"


NixieTubeClock = {
    id = "",
    cc = nil,
    x = 0,
    y = 0,
    scale = 1,
    tubes = {},
    base = nil,
    state = {
        transition = true
    }
}


function NixieTubeClock:new(id, cairo_context, digits, images, base, x, y, scale, o)
    if id == nil then error("NixieTubeClock:new - parameter id is required") end
    if cairo_context == nil then error("NixieTubeClock:new - parameter cairo_context is required") end
    if digits == nil then error("NixieTubeClock:new - parameter digits is required") end
    if images == nil then error("NixieTubeClock:new - parameter images is required") end
    x = x or 0
    y = y or 0
    scale = scale or 1
    o = o or {
        id = id,
        cc = cairo_context,
        x = x,
        y = y,
        scale = scale,
        tubes = {
            NixieTube:new(id .. " HOUR 1", cairo_context, digits, images, x + (60 * scale), y),
            NixieTube:new(id .. " HOUR 2", cairo_context, digits, images, x + (200 * scale), y),
            NixieTube:new(id .. " MINUTE 1", cairo_context, digits, images, x + ((140 * 2) + (60 * 2)) * scale, y),
            NixieTube:new(id .. " MINUTE 2", cairo_context, digits, images, x + ((140 * 3) + (60 * 2)) * scale, y),
            NixieTube:new(id .. " SECOND 1", cairo_context, digits, images, x + ((140 * 4) + (60 * 3)) * scale, y),
            NixieTube:new(id .. " SECOND 2", cairo_context, digits, images, x + ((140 * 5) + (60 * 3)) * scale, y)
        },
        base = base,
        state = {
            transition = true
        }
    }

    DIGIT_OFF = DIGIT_OFF or digits[10]

    setmetatable(o, self)
    self.__index = self
    return o
end

function NixieTubeClock:set_transition(true_or_false)
    self.state.transition = true_or_false
end

function NixieTubeClock:draw()
    -- print("NixieTubeClock:draw - Drawing clock " .. self.id)
    local time_digits = self:get_time_digits()

    if self.state.transition then
        local exclude_digits = {}
        local transition_digits
        local draw_transition = false
        local tubes = self.tubes
        local tube

        -- Calculate the transition digits to exclude.
        for i = 0, #tubes - 1 do
            -- Start from the seconds digit
            local reverse_index = #tubes - i
            tube = tubes[reverse_index]
            if not tube:has_display_queue() then
                -- Exclude the visible digits of the tubes not in transition
                table.insert(exclude_digits, tube:get_value())
                -- Digit changed and tube not in transition?
                if tube:get_value() ~= time_digits[reverse_index] then
                    -- Exclude the new digit value
                    table.insert(exclude_digits, time_digits[reverse_index])
                    draw_transition = true
                else
                    break
                end
            end
        end

        -- Draw the clock base (if any)
        if self.base ~= nil then
            cairo_set_source_surface(self.cc, self.base, self.x, self.y + (240 * self.scale))
            cairo_paint(self.cc)              
        end

        if draw_transition then
            -- Calculate the transition digits
            transition_digits = self:get_transition_digits(exclude_digits)

            -- Draw the clock with the transitions
            for i, tube in ipairs(self.tubes) do
                if not tube:has_display_queue() and tube:get_value() ~= time_digits[i] then
                    -- Add new transition.
                    tube:add_to_display_queue(transition_digits)
                    tube:add_to_display_queue({ time_digits[i] })
                end
                tube:draw()
            end
        else
            -- No digit transitions, draw the plain clock.
            for i, tube in ipairs(self.tubes) do
                tube:draw()
            end
        end
    else
        -- No digit transitions, draw the plain clock.
        for i, tube in ipairs(self.tubes) do
            tube:draw_digit(time_digits[i])
        end
    end
end

function NixieTubeClock:get_time_digits()
    local time = os.date("%H%M%S")
    local time_digits = {}
    for i = 1, #time do
        table.insert(time_digits, tonumber(time:sub(i, i)))
    end
    return time_digits
end

function NixieTubeClock:get_transition_digits(exclude_digits)
    local transition_digits = {}
    local digit

    for i = 1, 3 do
        repeat
            digit = math.random(0, 9)
            local exclude_string = table.concat(exclude_digits)
        until (not self:contains(exclude_digits, digit))
        table.insert(transition_digits, digit)
        table.insert(exclude_digits, digit)
    end

    return transition_digits
end

function NixieTubeClock:contains(list, value)
    for _, v in ipairs(list) do
        if v == value then return true end
    end
    return false
end
