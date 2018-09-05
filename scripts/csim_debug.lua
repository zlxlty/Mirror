--[[
    CSIM 2018
    Lecture 4

    -- Debug Library --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

local csim_debug = {}

function csim_debug.init(screen_width, screen_height, console_height, font_size)
    csim_debug.width = screen_width
    csim_debug.height = console_height
    csim_debug.x = 0
    csim_debug.y = screen_height - console_height
    csim_debug.messages = {}
    csim_debug.rects = {}
    csim_debug.show_console = false
    csim_debug.states = {0, 1, 2}
    csim_debug.state = csim_debug.states[1]
    csim_debug.font = love.graphics.newFont('fonts/font.ttf', font_size)
end

function csim_debug.showConsole()
    csim_debug.show_console = true
    csim_debug.state = 0
end

function csim_debug.hideConsole()
    csim_debug.show_console = false
    csim_debug.state = 0
end

function csim_debug.nextState()
    csim_debug.state = (csim_debug.state + 1) % #csim_debug.states
end

function csim_debug.isShowing()
    return csim_debug.show_console
end

function csim_debug.text(message)
    if csim_debug.messages[message] == nil then
        csim_debug.messages[message] = 1
    else
        csim_debug.messages[message] = csim_debug.messages[message] + 1
    end
end

function csim_debug.rect(x, y, w, h)
    local rect = {x = x, y = y, w = w, h = h}
    local key = "x"..x.."y"..y
    if csim_debug.rects[key] == nil then
        csim_debug.rects[key] = rect
    end
end

function csim_debug.draw()
    if (csim_debug.show_console == false) then return end

    -- Save graphics state
    r,g,b,a = love.graphics.getColor()
    prev_font = love.graphics.getFont()

    -- Draw grey console
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", csim_debug.x, csim_debug.y, csim_debug.width, csim_debug.height)

    -- Draw console label
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(csim_debug.font)
    love.graphics.printf("console", csim_debug.x + 2, csim_debug.y + 2, csim_debug.width)

    -- Draw debug messages
    local i = 1
    for message,count in pairs(csim_debug.messages) do
        -- Draw message
        love.graphics.printf(message, csim_debug.x + 2, csim_debug.y + i * csim_debug.font:getHeight(), csim_debug.width)

        -- Draw message count
        love.graphics.printf(count, csim_debug.width - csim_debug.font:getWidth(count) - 2, csim_debug.y + i * csim_debug.font:getHeight(), csim_debug.width)
        i = i + 1
    end

    -- Draw debug rects
    for rect_pos,rect in pairs(csim_debug.rects) do
        love.graphics.rectangle("line", rect.x - csim_camera.x, rect.y - csim_camera.y, rect.w, rect.h)
    end

    -- Draw debug mode
    local mode = ""
    if (csim_debug.state == 0) then
        mode = ""
    elseif (csim_debug.state == 1) then
        mode = "single step"
    elseif (csim_debug.state == 2) then
        mode = "slow motion"
    end

    love.graphics.printf(mode, csim_debug.width - csim_debug.font:getWidth(mode), csim_debug.y, csim_debug.width)

    -- Draw game stats
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 2, 2)
    local mem = string.format("MEM: %.2f MB", love.graphics.getStats().texturememory / 1024 / 1024)
    love.graphics.print(mem, 2, csim_debug.font:getHeight() + 4)

    -- Reset rects table
    csim_debug.rects = {}

    -- Reset graphics state
    love.graphics.setColor(r,g,b,a)
    love.graphics.setFont(prev_font)
end

return csim_debug
