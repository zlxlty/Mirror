--[[
    CSIM 2018
    Lecture 4

    -- Rigid Body Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

local csim_rigidbody = {}
local GRAVITY = 9.8
local MAX_SPEED = 10

function csim_rigidbody:new(mass, speed_x, speed_y)
    local comp = {}
    comp.speed = csim_vector:new(speed_x, speed_y)
    comp.vel = csim_vector:new(0,0)
    comp.acc = csim_vector:new(0,0)
    comp.mass = mass
    comp.name = "rigidbody"
    comp.parent = nil
    setmetatable(comp, self)
    self.__index = self
    return comp
end

function csim_rigidbody:applyForce(f)
    -- TODO: sum vector f (f.x, f.y) to self.acc (self.acc.x, self.acc.y)
    -- f = m * a
    -- a = f/m
    f:div(self.mass)
    self.acc:add(f)
end

function csim_rigidbody:applyFriction(u)
    -- TODO: Implement friction with the ground
    -- Hint: F = -1 * u * v:norm()
    if(math.abs(self.vel.x) > 0) then
        local f = csim_vector:new(self.vel.x, self.vel.y)
        f:norm()
        f:mul(-1 * u)
        self:applyForce(f)
    end
end

function csim_rigidbody:applyResistance(c_d)
    -- TODO: Implement friction with the ground
    -- Hint: F = v:mag()^2 * c_d * v:norm()
end

function csim_rigidbody:update(dt)
    -- TODO: create a vector g (0,9.8) representing gravity
    -- using csim_vector:new()
    local g = csim_vector:new(0, GRAVITY*0.05*self.mass)
    self:applyForce(g)

    -- TODO: Sum acc to self.vel
    self.vel:add(self.acc)

    local collider = self.parent:getComponent("collider")
    if(collider) then
        -- TODO: Check for horizontal collision
        collider:updateVertical()

        -- TODO: Check for vertical collision
        collider:udpateHorizontal()
    end

    -- TODO: Set vel to zero if it less than a short trashold
    if(math.abs(self.vel.x) < 0.1) then self.vel.x = 0 end
    if(math.abs(self.vel.y) < 0.1) then self.vel.y = 0 end

    self.vel.x = csim_math.clamp(self.vel.x, -MAX_SPEED, MAX_SPEED)

    -- TODO: Sum self.vel to self.parent.pos
    self.parent.pos:add(self.vel)

    -- TODO: set set self.acc to (0,0)
    self.acc = csim_vector:new(0, 0)
end

return csim_rigidbody
