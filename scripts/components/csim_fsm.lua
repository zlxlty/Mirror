--[[
    CSIM 2018
    Lecture 8

    -- FSM Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_fsm = {}

function csim_fsm:new(states, s_state)
    local comp = {}
    comp.c_state = s_state
    comp.states = states
    comp.name = "fsm"
    comp.parent = nil

    setmetatable(comp, self)
    self.__index = self
    return comp
end

function csim_fsm:newState(name, f_update, f_enter, f_exit)
    -- TODO: Create a new state with name, update, enter, exit and timer
    local state = {}
    state.name = name
    state.update = f_update
    state.enter = f_enter
    state.exit = f_exit
    state.timer = 0
    return state
end

function csim_fsm:load()
    -- TODO: Call the enter function for the initial state
    -- Hint: self.states["state"].enter(state, self.parent)
    self.states[self.c_state].enter(self.states[self.c_state], self.parent)
end

function csim_fsm:update(dt)
    -- TODO: Call the current state update function if it exists
    print("pos test = "..self.parent.pos.x)
    self.states[self.c_state].update(dt, self.states[self.c_state], self.parent)
end

function csim_fsm:changeState(new_state)
    -- TODO: Call the exit function if it exists
    self.states[self.c_state].exit(self.states[self.c_state], self.parent)

    -- TODO: If new state exist in the table
    -- 1. Set current state to be the new one
    self.c_state = new_state

    -- 2. Reset timer and call the
    self.states[self.c_state].timer = 0
    -- 3. Call the enter function if it exists
    self.states[self.c_state].enter(self.states[self.c_state], self.parent)
end

return csim_fsm
