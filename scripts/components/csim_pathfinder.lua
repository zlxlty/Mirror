--[[
    CSIM 2018
    Lecture 10

    -- Pathfinder Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

local csim_pathfinder = {}

function csim_pathfinder:new(map)
    local comp = {}
    comp.map = map
    comp.name = "pathfinder"
    setmetatable(comp, self)
    self.__index = self
    return comp
end

-- Node has x and y -> node.x, node.y -> node is a vector
function csim_pathfinder:adj(node)
    local neighbors = {}

    local map_data = self.map.layers["Terrain"].data

    -- UP
    local up_tile = map_data[node.y - 1][node.x]
    if(not up_tile.properties["collide"]) then
        -- I can go to my UP neighbor
        local up_vector = csim_vector:new(node.x, node.y - 1)
        table.insert(neighbors, up_vector)
    end

    -- DOWN
    local down_tile = map_data[node.y + 1][node.x]
    if(not down_tile.properties["collide"]) then
        -- I can go to my DOWN neighbor
        local down_vector = csim_vector:new(node.x, node.y + 1)
        table.insert(neighbors, down_vector)
    end

    -- LEFT
    local left_tile = map_data[node.y][node.x - 1]
    if(not left_tile.properties["collide"]) then
        -- I can go to my LEFT neighbor
        local left_vector = csim_vector:new(node.x - 1, node.y)
        table.insert(neighbors, left_vector)
    end

    -- RIGHT
    local right_tile = map_data[node.y][node.x + 1]
    if(not right_tile.properties["collide"]) then
        -- I can go to my RIGHT neighbor
        local right_vector = csim_vector:new(node.x + 1, node.y)
        table.insert(neighbors, right_vector)
    end

    return neighbors
end

function csim_pathfinder:cost(node1, node2)
end

-- start and goal are both vectors
function csim_pathfinder:plan(start, goal)
    local path = self:bfs(start, goal)

    if(path) then
        print("path = ")
        print("path size = "..#path)

        for i=1,#path do
            print(""..(path[i].x - 1).." "..(path[i].y - 1))
        end
    end
end

function csim_pathfinder:path(start, node, back_p)
    -- Set current node to be the goal
    local p_node = node
    local path = {}

    while( p_node:str() ~= start:str() ) do
        table.insert(path, p_node)
        p_node = back_p[p_node:str()]
    end

    table.insert(path, start)

    return path
end

function csim_pathfinder:bfs(start, goal)
    local queue = {}
    table.insert(queue, start)

    local back_p = {}
    back_p[start:str()] = start

    while (#queue > 0) do
        -- Pop the last element from the queue
        local c_node = table.remove(queue, 1)

        -- Check if the current node is the goal
        if(c_node:str() == goal:str()) then
            return self:path(start, c_node, back_p)
        end

        -- Process my neighbors
        local n = self:adj(c_node)
        for i=1, #n do
            -- If neighbor n[i] has not been visited yet
            if(back_p[ n[i]:str() ] == nil) then
                -- Add neighbor n[i] to queue
                table.insert(queue, n[i])

                -- Set neighbor n[i] backpointer to be the current node
                back_p[ n[i]:str() ] = c_node
            end
        end
    end

    -- I can't find the goal
    return nil
end

return csim_pathfinder
