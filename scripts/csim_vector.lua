--[[
    CSIM 2018
    Lecture 4

    -- Vector Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = {}

function csim_vector:new (x, y)
    local v = {}
    v.x = x
    v.y = y
    setmetatable(v, self)
    self.__index = self
    return v
end

function csim_vector:add(v)
    self.x = self.x + v.x
    self.y = self.y + v.y
end

function csim_vector:sub(v)
    self.x = self.x - v.x
    self.y = self.y - v.y
end

function csim_vector:mul(s)
    self.x = self.x * s
    self.y = self.y * s
end

function csim_vector:div(s)
    self.x = self.x / s
    self.y = self.y / s
end

function csim_vector:mag()
    -- TODO: use self.x and self.y to calculate the magnitude of the vector "self"
    -- HINT: use math.sqrt()
    return math.sqrt(self.x*self.x + self.y*self.y)
end

function csim_vector:norm()
    -- TODO: Use your magnitude fucntion to calculate magnitude
    -- and Divide self.x, self.y by it.
    local mag = self:mag()
    self:div(mag)
end

return csim_vector
