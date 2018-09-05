--[[
    CSIM 2018
    Lecture 8

    -- Player Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_enemy = require "scripts.objects.csim_object"
local csim_vector = require "scripts.csim_vector"

-- FUNCTION OF THE IDLE STATE
function csim_enemy.enter_idle_state(state, enemy)
    enemy:getComponent("rigidbody").vel.x = 0
end

function csim_enemy.exit_idle_state(state, enemy)
end

function csim_enemy.update_idle_state(dt, state, enemy)
    state.timer = state.timer + dt
    if(state.timer > 1) then
        enemy:getComponent("fsm"):changeState("move")
        enemy.direction_x = enemy.direction_x * -1
        state.timer = 0
    end
end

-- FUNCTION OF THE MOVE STATE
function csim_enemy.enter_move_state(state, enemy)
    if(enemy.direction_x == nil) then
        enemy.direction_x = 1
    end
end

function csim_enemy.exit_move_state(state, enemy)
end

function csim_enemy.update_move_state(dt, state, enemy)
    -- TODO: Move enemy to its current direction and flip it after 1 second
    csim_debug.text("bla bla bla")
    enemy:getComponent("rigidbody"):applyForce(csim_vector:new(0.1 * enemy.direction_x ,0))

    state.timer = state.timer + dt
    print("timer= "..state.timer)
    if(state.timer > 2) then
        enemy:getComponent("fsm"):changeState("idle")
        state.timer = 0
    end
end

return csim_enemy
