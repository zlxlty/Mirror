--[[
    CSIM 2018
    Lecture 6

    -- Collider Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_vector = require "scripts.csim_vector"

local csim_collider = {}
local SKIN = 0.01

function csim_collider:new(map, rect)
    local comp = {}
    comp.map = map
    comp.name = "collider"
    comp.parent = nil
    comp.rect = rect
    setmetatable(comp, self)
    self.__index = self
    return comp
end

function csim_collider:udpateHorizontal()
    local parent_rigid_body = self.parent:getComponent("rigidbody")

    local horiz_side = 1
    if(parent_rigid_body.vel.x < 0) then
        horiz_side = -1
    end

    local col_pos1 = csim_vector:new(self.parent.pos.x + self.rect.x + self.rect.w,
                        self.parent.pos.y + self.rect.y + SKIN)
    local col_pos2 = csim_vector:new(self.parent.pos.x + self.rect.x + self.rect.w,
                        self.parent.pos.y + self.rect.y + self.rect.h - SKIN)

    if(horiz_side == -1) then
        col_pos1 = csim_vector:new(self.parent.pos.x + self.rect.x,
                            self.parent.pos.y + self.rect.y + SKIN)
        col_pos2 = csim_vector:new(self.parent.pos.x + self.rect.x,
                            self.parent.pos.y + self.rect.y + self.rect.h - SKIN)
    end

    col_pos1.x = col_pos1.x + parent_rigid_body.vel.x
    col_pos2.x = col_pos2.x + parent_rigid_body.vel.x

    local tile_x1, tile_y1 = self:worldToMapPos(col_pos1)
    local tile_x2, tile_y2 = self:worldToMapPos(col_pos2)

    if(self:detectHorizontalCollision(tile_x1, tile_y1, horiz_side)) then
        self:didCollideHorizontally(tile_x1, tile_y1, horiz_side)
    end

    if(self:detectHorizontalCollision(tile_x2, tile_y2, horiz_side)) then
        self:didCollideHorizontally(tile_x2, tile_y2, horiz_side)
    end
end

function csim_collider:updateVertical()
    local parent_rigid_body = self.parent:getComponent("rigidbody")

    local vert_side = 1
    if(parent_rigid_body.vel.y < 0) then
        vert_side = -1
    end

    local col_pos1 = csim_vector:new(self.parent.pos.x + self.rect.x + SKIN,
                        self.parent.pos.y + self.rect.y + self.rect.h)
    local col_pos2 = csim_vector:new(self.parent.pos.x + self.rect.x + self.rect.w - SKIN,
                        self.parent.pos.y + self.rect.y + self.rect.h)

    if(vert_side == -1) then
        col_pos1 = csim_vector:new(self.parent.pos.x + self.rect.x + SKIN,
                            self.parent.pos.y + self.rect.y)
        col_pos2 = csim_vector:new(self.parent.pos.x + self.rect.x + self.rect.w - SKIN,
                            self.parent.pos.y + self.rect.y)
    end

    col_pos1.y = col_pos1.y + parent_rigid_body.vel.y
    col_pos2.y = col_pos2.y + parent_rigid_body.vel.y

    local tile_x1, tile_y1 = self:worldToMapPos(col_pos1)
    local tile_x2, tile_y2 = self:worldToMapPos(col_pos2)

    if(self:detectVerticalCollision(tile_x1, tile_y1, vert_side)) then
        self:didCollideVertically(tile_x1, tile_y1, vert_side)
    end

    if(self:detectVerticalCollision(tile_x2, tile_y2, vert_side)) then
        self:didCollideVertically(tile_x2, tile_y2, vert_side)
    end
end

function csim_collider:worldToMapPos(pos)
    -- TODO: return the tile in which the object is right now
    -- Hint: use map:convertPixelToTile(x,y) and math.floor(n) to
    x,y = map:convertPixelToTile(pos.x, pos.y)
    return math.floor(x), math.floor(y)
end

function csim_collider:detectVerticalCollision(tile_x, tile_y, vert_side)
    -- TODO: Create a variable to store the tile which the object is trying to visit
    -- Hint: Use map.layers['Terrain']
    local map_data = map.layers["Terrain"].data
    if map_data[tile_y+1] and map_data[tile_y+1][tile_x+1] then
        local tile = map_data[tile_y+1][tile_x+1]

        if (tile) then
            if(tile.properties["trigger"]) then
                -- Callback function
                if(self.parent.onVerticalTriggerCollision) then
                    self.parent:onVerticalTriggerCollision(tile, vert_side)
                end
            end

            -- TODO: Check if the tile has property "collide", then return true
            if(tile.properties["collide"]) then
                -- Callback function
                if(self.parent.onVerticalCollision) then
                    self.parent:onVerticalCollision(tile, vert_side)
                end

                return true
            end
        end
    end

    return false
end

function csim_collider:didCollideVertically(tile_x, tile_y, vert_side)
    local parent_rigid_body = self.parent:getComponent("rigidbody")

    -- TODO: Set y component of velocity to zero
    parent_rigid_body.vel.y = 0

    -- TODO: Set rigidbody y position to be the tile y pos
    -- Hint: use map:convertTileToPixel
    screen_x, screen_y = map:convertTileToPixel(tile_x, tile_y)
    if(vert_side == -1) then
        self.parent.pos.y = screen_y + map.tileheight - self.rect.y
    elseif(vert_side == 1) then
        self.parent.pos.y = screen_y - self.rect.y - self.rect.h
    end
end

function csim_collider:detectHorizontalCollision(tile_x, tile_y, horiz_side)
    -- TODO: Create a variable to store the tile which the object is trying to visit
    -- Hint: Use map.layers['Terrain']
    local map_data = map.layers["Terrain"].data
    if map_data[tile_y+1] and map_data[tile_y+1][tile_x+1] then
        local tile = map_data[tile_y+1][tile_x+1]

        if(tile) then
            if(tile.properties["trigger"]) then
                -- Callback function
                if(self.parent.onHorizontalTriggerCollision) then
                    self.parent:onHorizontalTriggerCollision(tile, horiz_side)
                end
            end

            -- TODO: Check if the tile has property "collide", then return true
            if(tile.properties["collide"]) then
                -- Callback function
                if(self.parent.onHorizontalCollision) then
                    self.parent:onHorizontalCollision(tile, horiz_side)
                end

                return true
            end
        end
    end

    return false
end

function csim_collider:didCollideHorizontally(tile_x, tile_y, horiz_side)
    local parent_rigid_body = self.parent:getComponent("rigidbody")

    -- TODO: Set x component of velocity to zero
    parent_rigid_body.vel.x = 0

    -- TODO: Set rigidbody x position to be the tile x pos
    -- Hint: use map:convertTileToPixel
    screen_x, screen_y = map:convertTileToPixel(tile_x, tile_y)
    if(horiz_side == -1) then
        self.parent.pos.x = screen_x + map.tilewidth - self.rect.x
    elseif(horiz_side == 1) then
        self.parent.pos.x = screen_x - self.rect.x - self.rect.w
    end
end

function csim_collider:createAABB()
    local min = csim_vector:new(self.parent.pos.x + self.rect.x, self.parent.pos.y + self.rect.y)
    local max = csim_vector:new(self.parent.pos.x + self.rect.x + self.rect.w, self.parent.pos.y + self.rect.y + self.rect.h)
    return min,max
end

return csim_collider
