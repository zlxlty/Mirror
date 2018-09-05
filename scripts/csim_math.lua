--[[
    CSIM 2018
    Lecture 4

    -- Math Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

csim_math = {}

function csim_math.distance(v1, v2)
    return math.sqrt((v2.x - v1.x)^2 + (v2.y - v1.y)^2)
end

function csim_math.checkBoxCollision(min_a, max_a, min_b, max_b)
    -- TODO: Implement AABB vs AABB collision detection
    if((max_a.x < min_b.x) or (max_b.x < min_a.x)) then
        return false
    end

    if(max_a.y < min_b.y or max_b.y < min_a.y) then
        return false
    end

    return true
end

function csim_math.clamp(n, min, max)
    if(n < min) then n = min end
    if(n > max) then n = max end
    return n
end

return csim_math
