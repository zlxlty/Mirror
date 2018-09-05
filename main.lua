--[[
    CSIM 2018
    Lecture 7

    -- Main Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

-- Loading external libraries
local push = require "lib.push"

-- Loading CSIM libraries
csim_debug = require('scripts.csim_debug')
csim_camera = require('scripts.csim_camera')
csim_game = require('scripts.csim_game')

-- Setting values of global variables
csim_game.game_width = 1280
csim_game.game_height = 800

function love.keypressed(key, scancode, isrepeat)
	if (key == "-") then
		if (csim_debug.isShowing()) then
			csim_debug.hideConsole()
		else
			csim_debug.showConsole()
		end
	end

	if (key == "=") then
		if (csim_debug.isShowing()) then
			csim_debug.nextState()
		end
	end

	if (key == "escape") then
		love.event.quit()
	end
end

function love.load()
	-- Initialize virtual resolution
	local window_width, window_height, flags  = love.window.getMode()
	push:setupScreen(csim_game.game_width, csim_game.game_height, window_width, window_height, {highdpi=true})

	-- Load Debugger
	csim_debug.init(csim_game.game_width, csim_game.game_height, csim_game.game_height/4, 20)

	-- Load Game
	csim_game.load()

	-- bgm=love.audio.newSource("sounds/lec2-bgm.mp3", "static")
	-- bgm:setLooping(true)
	-- bgm:play()
end

function love.update(dt)
	if(csim_debug.state == 0) then
		csim_game.update(dt)
	elseif (csim_debug.state == 1) then
		if (love.keyboard.isDown("]")) then
			csim_game.update(dt)
			love.timer.sleep(0.5)
		end
	elseif (csim_debug.state == 2) then
		csim_game.update(dt)
		love.timer.sleep(0.1)
	end
end

function love.draw()
	push:start()

	-- Enable camera
	csim_camera.start()

	-- Draw game

	if (final_win==false) then
		csim_game.draw()
  end

	-- Disable camera
	csim_camera.finish()

	if (final_win) then
		csim_debug.text("win")
		csim_game.windraw()
		love.audio.play(sounds["win"])
  end


	-- Draw debugger
	csim_debug.draw()

	push:finish()
end
