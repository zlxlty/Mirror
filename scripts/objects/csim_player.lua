--[[
    CSIM 2018
    Lecture 7

    -- Player Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_player = require "scripts.objects.csim_object"
local csim_vector = require "scripts.csim_vector"

csim_player.is_on_ground = false

function csim_player:onVerticalCollision(tile, vert_side)
    -- TODO: Check if the collision is from the top and, if so, set is_on_ground to true
    if(vert_side == 1) then
        self.is_on_ground = true
    end
end

function csim_player:onVerticalTriggerCollision(tile, vert_side)
    -- TODO: If tile is water (has boolean property "isWater"), apply resitance
end

function csim_player:onHorizontalCollision(tile, horiz_side)
    -- TODO: Apply friction if is on the ground
    csim_debug.text("yay!")
end

function csim_player:onHorizontalTriggerCollision(tile, horiz_side)
    -- TODO: If tile is water (has boolean property "isWater"), apply resitance
end

function csim_player:jump(name)
    -- TODO: Apply a vertical force to player with magnitude speed_y
    k = 1.6
    if (name == 1) then
        k = 2.2
    end
    local speed_y = self:getComponent("rigidbody").speed.y
    self:getComponent("rigidbody"):applyForce(csim_vector:new(0, -speed_y*k))

    -- TODO: Set is_on_ground to false
    self.is_on_ground = false
end

function csim_player:move(dir)
    -- TODO: Apply a horizontal force to player with magnitude speed_x
    local speed_x = self:getComponent("rigidbody").speed.x
    self:getComponent("rigidbody"):applyForce(csim_vector:new(speed_x * dir, 0))
end

return csim_player
