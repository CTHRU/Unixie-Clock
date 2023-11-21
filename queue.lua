Queue = { list = {}, first = 0, last = -1, size = 0 }

function Queue:new(o)
    o = o or { list = {}, first = 0, last = -1, size = 0 }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Queue:push(value)
    self:push_right(value)
end

function Queue:pop()
    return self:pop_left()
end

function Queue:push_right(value)
    local last = self.last + 1
    self.last = last
    self.list[last] = value
    self.size = self.size + 1
end

function Queue:pop_left()
    local first = self.first
    if first > self.last then error("list is empty") end
    local value = self.list[first]
    self.list[first] = nil -- allow garbage collection
    self.first = first + 1
    self.size = self.size - 1
    return value
end

function Queue:clear()
    self.list = {}
    self.first = 0
    self.last = -1
    self.size = 0
end
