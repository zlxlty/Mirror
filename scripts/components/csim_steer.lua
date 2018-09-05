--[[
    CSIM 2018
    Lecture 9

    -- Animator Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"
local csim_debug = require "scripts.csim_debug"

local csim_steer = {}

function csim_steer:new(spriteSheet, width, height)
    local comp = {}
    comp.name = "steer"
    comp.parent = nil

    setmetatable(comp, self)
    self.__index = self
    return comp
end

function csim_steer:seek(target)

  --target velocity
  target_pos = target
  csim_debug.text("hahahahae:"..target_pos.x)
  target_pos:sub(self.parent.pos)

  target_pos:mul(0.8)

  target_pos:sub(self.parent:getComponent('rigidbody').vel)

  target_pos:norm()

  self.parent:getComponent('rigidbody'):applyForce(target_pos)
end

function csim_steer:flee(target)
end

return csim_steer
