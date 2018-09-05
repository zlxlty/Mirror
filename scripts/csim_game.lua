--[[
    CSIM 2018
    Lecture 7

    -- Game Program --
    Author: Lucas N. Ferreira
    lferreira@ucsc.edu
]]

-- Loading external libraries
local sti = require "lib.sti"

-- Loading game objects
local csim_object = require "scripts.objects.csim_object"
local csim_player = require "scripts.objects.csim_player"
local csim_enemy = require "scripts.objects.csim_enemy"

-- Loading internal libraries
local csim_math = require "scripts.csim_math"
local csim_vector = require "scripts.csim_vector"

-- Loading components
local csim_rigidbody = require "scripts.components.csim_rigidbody"
local csim_collider = require "scripts.components.csim_collider"
local csim_fsm = require "scripts.components.csim_fsm"
local csim_steer = require "scripts.components.csim_steer"
local coin_collected = 0
win_bool = false
is_first = true
final_win = false
last_layer_state = false
player_one_only = false
player_two_only = false
winwin = false


local csim_game = {}

function csim_game.load()
	-- Load map
	map = sti("map/lec6.lua")


	if (win_bool) then
		last_layer_state = true
	end

	if (player_one_only) then
		winwin = true
	end

	win_bool = false

	player_one_only = false

	-- Load characters
	players, enemies, bees = csim_game.loadCharacters()


	-- Adding collider to enemies
	for i=1,#enemies do
		local states = {}
		states["move"] = csim_fsm:newState("move", enemies[i].update_move_state, enemies[i].enter_move_state, enemies[i].exit_move_state)
		states["idle"] = csim_fsm:newState("idle", enemies[i].update_idle_state, enemies[i].enter_idle_state, enemies[i].exit_idle_state)
		local enemy_fsm = csim_fsm:new(states, "move")
		enemies[i]:addComponent(enemy_fsm)

		local enemy_collider = csim_collider:new(map, enemies[i].rect)
		enemies[i]:addComponent(enemy_collider)

		local rigid_body = csim_rigidbody:new(1, 1, 1)
  	enemies[i]:addComponent(rigid_body)
	end

	for i=1,#bees do
		local bee_collider = csim_collider:new(map, bees[i].rect)

		bees[i]:addComponent(bee_collider)

		local rigid_body = csim_rigidbody:new(1, 1, 1)
		bees[i]:addComponent(rigid_body)

		local steer = csim_steer:new(bees[i].spr, bees[i].rect.w, bees[i].rect.h)
		bees[i]:addComponent(steer)
	end

	-- Load items
	wins, items = csim_game.loadItems()


	-- Adding collider to coins
	for i=1,#items do
		local item_collider = csim_collider:new(map, items[i].rect)
		items[i]:addComponent(item_collider)
	end

	for i=1,#wins do
		local win_collider = csim_collider:new(map, wins[i].rect)
		wins[i]:addComponent(win_collider)
	end

	-- Load Traps
	fires, locks, mushrooms, traps, finals = csim_game.loadTraps()

	for i=1,#fires do
		local fire_collider = csim_collider:new(map, fires[i].rect)
		fires[i]:addComponent(fire_collider)
	end

	for i=1,#locks do
		local lock_collider = csim_collider:new(map, locks[i].rect)
		locks[i]:addComponent(lock_collider)
	end

	for i=1,#mushrooms do
		local mushroom_collider = csim_collider:new(map, mushrooms[i].rect)
		mushrooms[i]:addComponent(mushroom_collider)
	end

	for i=1,#traps do
		local trap_collider = csim_collider:new(map, traps[i].rect)
		traps[i]:addComponent(trap_collider)
	end

	for i=1,#finals do
		local final_collider = csim_collider:new(map, finals[i].rect)
		finals[i]:addComponent(final_collider)
	end


	-- Create rigid body
	for i=1, #players do
		local player_rigid_body = csim_rigidbody:new(1, 0.1, 6)
		players[i]:addComponent(player_rigid_body)

	-- Create collider
		local player_collider = csim_collider:new(map, players[i].rect)
		players[i]:addComponent(player_collider)
		print(tostring(i))
	end


	if (last_layer_state == true) then
		csim_game.layer2()
	end

	-- Load step sound
	sounds = {}
	sounds["step"]=love.audio.newSource("sounds/lec2-step.wav", "static")
	sounds["coin"]=love.audio.newSource("sounds/lec2-coin.wav", "static")
	sounds["enemies"]=love.audio.newSource("sounds/lec2-enemies.wav", "static")
	sounds['win']=love.audio.newSource("sounds/lec2-win.wav", "static")
	sounds['tele']=love.audio.newSource("sounds/lec2-tele.wav", "static")
	sounds['deadenemy']=love.audio.newSource("sounds/lec2-deadenemy.wav", "static")


end

function csim_game.loadCharacters()
	local players = {}
	local enemies = {}
	local bees = {}

	local width = map.layers["Characters"].width
	local height = map.layers["Characters"].height
	local map_data = map.layers["Characters"].data

	for x=1,width do
		for y=1,height do
			if map_data[y] and map_data[y][x] then
				local spr = love.graphics.newImage(map_data[y][x].properties["sprite"])
				screen_x, screen_y = map:convertTileToPixel(y - 1, x - 1)

				if(map_data[y][x].properties["isPlayer"]) then
					player = csim_player:new(screen_y, screen_x, 0, spr)
					player.rect = {}
					player.rect.x = map_data[y][x].properties["x"]
					player.rect.y = map_data[y][x].properties["y"]
					player.rect.w = map_data[y][x].properties["w"]
					player.rect.h = map_data[y][x].properties["h"]

					table.insert(players, player)

				elseif(map_data[y][x].properties["isBee"]) then
					local bee = csim_object:new(screen_y, screen_x, 0, spr)

					bee.rect = {}
					bee.rect.x = map_data[y][x].properties["x"]
					bee.rect.y = map_data[y][x].properties["y"]
					bee.rect.w = map_data[y][x].properties["w"]
					bee.rect.h = map_data[y][x].properties["h"]

					table.insert(bees, bee)

				else
					local enemy = csim_object:new(screen_y, screen_x, 0, spr)

					enemy.rect = {}
					enemy.rect.x = map_data[y][x].properties["x"]
					enemy.rect.y = map_data[y][x].properties["y"]
					enemy.rect.w = map_data[y][x].properties["w"]
					enemy.rect.h = map_data[y][x].properties["h"]

					table.insert(enemies, enemy)
				end
			end
		end
	end

	map:removeLayer("Characters")
	return players, enemies, bees
end

function csim_game.loadTraps()
	local fires = {}
	local locks = {}
	local mushrooms = {}
	local traps = {}
	local finals = {}

	local width = map.layers["Traps"].width
	local height = map.layers["Traps"].height
	local map_data = map.layers["Traps"].data

	for x=1,width do
		for y=1,height do
			if map_data[y] and map_data[y][x] then
				local spr = love.graphics.newImage(map_data[y][x].properties["sprite"])
				screen_x, screen_y = map:convertTileToPixel(y - 1, x - 1)

				if(map_data[y][x].properties["isFire"]) then
					local fire = csim_object:new(screen_y, screen_x, 0, spr)

					fire.rect = {}
					fire.rect.x = map_data[y][x].properties["x"]
					fire.rect.y = map_data[y][x].properties["y"]
					fire.rect.w = map_data[y][x].properties["w"]
					fire.rect.h = map_data[y][x].properties["h"]

					table.insert(fires, fire)
				elseif(map_data[y][x].properties["isMushroom"]) then
					local mushroom = csim_object:new(screen_y, screen_x, 0, spr)

					mushroom.rect = {}
					mushroom.rect.x = map_data[y][x].properties["x"]
					mushroom.rect.y = map_data[y][x].properties["y"]
					mushroom.rect.w = map_data[y][x].properties["w"]
					mushroom.rect.h = map_data[y][x].properties["h"]

					table.insert(mushrooms, mushroom)

				elseif(map_data[y][x].properties["isLock"]) then
					local lock = csim_object:new(screen_y, screen_x, 0, spr)

					lock.rect = {}
					lock.rect.x = map_data[y][x].properties["x"]
					lock.rect.y = map_data[y][x].properties["y"]
					lock.rect.w = map_data[y][x].properties["w"]
					lock.rect.h = map_data[y][x].properties["h"]

					table.insert(locks, lock)

				elseif(map_data[y][x].properties["isTrap"]) then
					local trap = csim_object:new(screen_y, screen_x, 0, spr)

					trap.rect = {}
					trap.rect.x = map_data[y][x].properties["x"]
					trap.rect.y = map_data[y][x].properties["y"]
					trap.rect.w = map_data[y][x].properties["w"]
					trap.rect.h = map_data[y][x].properties["h"]

					table.insert(traps, trap)

				elseif(map_data[y][x].properties["isFinal"]) then
					local final = csim_object:new(screen_y, screen_x, 0, spr)

					final.rect = {}
					final.rect.x = map_data[y][x].properties["x"]
					final.rect.y = map_data[y][x].properties["y"]
					final.rect.w = map_data[y][x].properties["w"]
					final.rect.h = map_data[y][x].properties["h"]

					table.insert(finals, final)

				end
			end
		end
	end

	map:removeLayer("Traps")
	return fires, locks, mushrooms, traps, finals
end

local win1_pos
local win2_pos
function csim_game.loadItems()
	local items = {}
	local wins = {}

	local width = map.layers["Items"].width
	local height = map.layers["Items"].height
	local map_data = map.layers["Items"].data

	for x=1,width do
		for y=1,height do
			if map_data[y] and map_data[y][x] then
				local spr = love.graphics.newImage(map_data[y][x].properties["sprite"])
				screen_x, screen_y = map:convertTileToPixel(y - 1, x - 1)

				if(map_data[y][x].properties["isWin"]) then
					local win = csim_object:new(screen_y, screen_x, 0, spr)

					win.rect = {}
					win.rect.x = map_data[y][x].properties["x"]
					win.rect.y = map_data[y][x].properties["y"]
					win.rect.w = map_data[y][x].properties["w"]
					win.rect.h = map_data[y][x].properties["h"]

					table.insert(wins, win)
				else
					local item = csim_object:new(screen_y, screen_x, 0, spr)

					item.rect = {}
					item.rect.x = map_data[y][x].properties["x"]
					item.rect.y = map_data[y][x].properties["y"]
					item.rect.w = map_data[y][x].properties["w"]
					item.rect.h = map_data[y][x].properties["h"]

					table.insert(items, item)

				end
			end
		end
	end

	win1_pos = wins[1].pos
	win2_pos = wins[2].pos
	map:removeLayer("Items")
	csim_debug.text("1:"..tostring(wins[1].pos.x).." "..tostring(wins[1].pos.y))
	csim_debug.text("2:"..tostring(wins[2].pos.x).." "..tostring(wins[2].pos.y))
	return wins, items
end

function csim_game.detectDynamicCollision(dynamic_objs, name)
	-- TODO: Check AABB collision against all dynamic objs
	-- Hint: Use a for loop and create boxes for the player and the items.
	-- csim_math.checkBoxCollision(min_a, max_a, min_b, max_b)
	for i=1, #players do
		local player_collider = players[i]:getComponent("collider")
		local min_a = csim_vector:new(players[i].pos.x + player_collider.rect.x,
						players[i].pos.y + player_collider.rect.y)

		local max_a = csim_vector:new(players[i].pos.x + player_collider.rect.x + player_collider.rect.w,
						players[i].pos.y + player_collider.rect.y + player_collider.rect.h)

		csim_debug.rect(min_a.x, min_a.y, player_collider.rect.w, player_collider.rect.h)

		for i=1,#dynamic_objs do
			local enemy_collider = dynamic_objs[i]:getComponent("collider")
			local min_b = csim_vector:new(dynamic_objs[i].pos.x + enemy_collider.rect.x,
						dynamic_objs[i].pos.y + enemy_collider.rect.y)

		  local max_b = csim_vector:new(dynamic_objs[i].pos.x + enemy_collider.rect.x + enemy_collider.rect.w,
						dynamic_objs[i].pos.y + enemy_collider.rect.y + enemy_collider.rect.h)

			csim_debug.rect(min_b.x, min_b.y, enemy_collider.rect.w, enemy_collider.rect.h)

			if(csim_math.checkBoxCollision(min_a, max_a, min_b, max_b)) then

					if (name=="items" or name=="mushrooms") then
						dynamic_objs[i] = nil
						love.audio.play(sounds["coin"])
						for n = i+1, #dynamic_objs do
								dynamic_objs[n-1] = dynamic_objs[n]
								coin_collected = coin_collected + 1
				   	end

					elseif (name=="enemies") then

						if ((max_a.y - min_b.y)>30) then
							love.audio.play(sounds["enemies"])
							csim_game.load()
						else
							dynamic_objs[i] = nil
							love.audio.play(sounds['deadenemy'])
							for n = i+1, #dynamic_objs do
									dynamic_objs[n-1] = dynamic_objs[n]
							end
						end
					elseif (name=="bees") then

						if ((max_a.y - min_b.y)>60) then
							love.audio.play(sounds["enemies"])
							csim_game.load()
						else
							dynamic_objs[i] = nil
							love.audio.play(sounds['deadenemy'])
							for n = i+1, #dynamic_objs do
									dynamic_objs[n-1] = dynamic_objs[n]
							end
						end
					elseif (name=="wins") then
						dynamic_objs[i] = nil
						--love.audio.play(sounds["coin"])
						for n = i+1, #dynamic_objs do
								dynamic_objs[n-1] = dynamic_objs[n]
				   	end
					elseif (name=="fires" or name=="traps" or name=="locks") then
						love.audio.play(sounds["enemies"])
						csim_game.load()

					elseif (name=="finals") then
						object_pos = dynamic_objs[i].pos
						dynamic_objs[i] = nil
						for n = i+1, #dynamic_objs do
								dynamic_objs[n-1] = dynamic_objs[n]
				   	end
						if (i==1) then
							players[1].pos.x = object_pos.x
							players[1].pos.y = object_pos.y+64*13
							players[2].pos.x = object_pos.x+64*26
							players[2].pos.y = object_pos.y-64*4
							final_pos_one = players[1].pos
							final_pos_two = players[2].pos
							player_one_only = true
						elseif (i==2) then
							players[2].pos.x = object_pos.x
							players[2].pos.y = object_pos.y+64*14
							players[1].pos.x = object_pos.x+64*8
							players[1].pos.y = object_pos.y-64*4
							final_pos_one = players[1].pos
							final_pos_two = players[2].pos
							player_two_only = true
						end
					end
				end
			end
		end
end

function csim_game.out(pos)
		if (pos.x<0 or pos.x>8194 or pos.y<0 or pos.y>1024 ) then
			 love.load()
		end
end

function csim_game.dowin()
		win_bool = true
end

function csim_game.layer2()
		players[1].pos.x = win1_pos.x - 300
		players[1].pos.y = win1_pos.y + 864
		players[2].pos.x = win2_pos.x + 200
		players[2].pos.y = win2_pos.y + 864
end

function csim_game.final_layer()
		players[1].pos = final_pos_one
		players[2].pos = final_pos_two

end

function csim_game.windraw()
			love.graphics.setColor(0.01, 1, 1)
			love.graphics.rectangle("fill", 0, csim_game.game_height/3, csim_game.game_width, csim_game.game_height/3)

			font = love.graphics.newFont('fonts/font.ttf', 50)
			love.graphics.setColor(1, 1, 1)
			love.graphics.setFont(font)
			love.graphics.printf("You Win !!!", 410, csim_game.game_height/3+80, csim_game.game_width)

end

function csim_game.update(dt)
	-- Move on x axis
	love.graphics.print("coin_collected:"..tostring(coin_collected), 20, 20)
	if (love.keyboard.isDown('left')) then
		players[1]:move(-2)
		players[2]:move(2)
		love.audio.play(sounds["step"])
	elseif(love.keyboard.isDown('right')) then
		players[1]:move(2)
		players[2]:move(-2)
		love.audio.play(sounds["step"])
	end

	-- Move on y axis
	for i=1, #players do
		if (love.keyboard.isDown('up') and players[i].is_on_ground) then
			players[i]:jump(i)
			love.audio.play(sounds["step"])
		end
	end

	if (love.keyboard.isDown('w')) then
		players[1].pos.x = win1_pos.x
		players[1].pos.y = win1_pos.y - 200
		players[2].pos.x = win2_pos.x
		players[2].pos.y = win2_pos.y - 200

		love.audio.play(sounds["step"])
	end


	for i=1, #players do
		players[i]:update(dt)
	end

	for i=1, #players do
			local player_rigid_body = players[i]:getComponent("rigidbody")

			-- TODO: Apply friction
			if(players[i].is_on_ground) then
				player_rigid_body:applyFriction(0.05)
			end
	-- TODO: Clamp acceleration
			player_rigid_body.vel.x = csim_math.clamp(player_rigid_body.vel.x, -10, 10)
	end

	for i=1, #enemies do
		enemies[i]:update(dt)
	end



	for i=1, #bees do
		--bees[i]:getComponent('steer'):seek(players[1].pos)
		local bee_body = bees[i]:getComponent("rigidbody")
		local x_val
		if (#bees>=2) then
				x_val = 0.1*math.random(-10, 10)
		else
				x_val = math.random(-10, 10)
		end

		local force = csim_vector:new(x_val, 0)
		bee_body:applyForce(force)
		local anti_gra = csim_vector:new(0, -9.8*0.001*math.random(30, 70))
		bee_body:applyForce(anti_gra)
		bees[i]:update(dt)
	end


	csim_game.detectDynamicCollision(items, "items")
	csim_game.detectDynamicCollision(enemies, "enemies")
	csim_game.detectDynamicCollision(bees, "bees")
	csim_game.detectDynamicCollision(wins, "wins")
  csim_game.detectDynamicCollision(fires, "fires")
	csim_game.detectDynamicCollision(locks, "locks")
	csim_game.detectDynamicCollision(mushrooms, "mushrooms")
	csim_game.detectDynamicCollision(traps, "traps")
	csim_game.detectDynamicCollision(finals, "finals")

	if(#bees == 0) then
		 final_win = true
	end

	if(#mushrooms==0) then
		for i=1,#locks do
				locks[i] = nil
				for n = i+1, #locks do
					  locks[n-1] = locks[n]
				end
		end
	end

	--love.audio.play(sounds['win'])
	--csim_game.out(player.pos)

	-- Camera is following the player

	if (player_one_only) then
	  	csim_camera.setPosition(players[1].pos.x - csim_game.game_width/2, players[1].pos.y - csim_game.game_height/2)
	elseif (player_two_only) then
			csim_camera.setPosition(players[2].pos.x - csim_game.game_width/2, players[2].pos.y - csim_game.game_height/2)
	else
			csim_camera.setPosition((players[1].pos.x+players[2].pos.x)/2 - csim_game.game_width/2, (players[1].pos.y+players[2].pos.y)/2 - csim_game.game_height/2)
	end

	-- Set background color
	love.graphics.setBackgroundColor(map.backgroundcolor[1]/255,
		map.backgroundcolor[2]/255, map.backgroundcolor[3]/255)
end

function csim_game.draw()
	-- Draw map


	map:draw(-csim_camera.x, -csim_camera.y)

	-- Draw the player sprite

	for i=1, #players do
		love.graphics.draw(players[i].spr, players[i].pos.x, players[i].pos.y)
	end

	-- Draw items
	for i=1,#items do
		love.graphics.draw(items[i].spr, items[i].pos.x, items[i].pos.y)
	end

	for i=1,#fires do
		love.graphics.draw(fires[i].spr, fires[i].pos.x, fires[i].pos.y)
	end

	for i=1,#locks do
		love.graphics.draw(locks[i].spr, locks[i].pos.x, locks[i].pos.y)
	end

	for i=1,#mushrooms do
		love.graphics.draw(mushrooms[i].spr, mushrooms[i].pos.x, mushrooms[i].pos.y)
	end

	for i=1,#traps do
		love.graphics.draw(traps[i].spr, traps[i].pos.x, traps[i].pos.y)
	end
	if (#wins ~= 0) then
		for i=1,#wins do
			love.graphics.draw(wins[i].spr, wins[i].pos.x, wins[i].pos.y)
		end
	elseif(not win_bool) then
		love.audio.play(sounds['tele'])
		csim_game.layer2()
		csim_game.dowin()
		--csim_game.dowin()
	end

	-- Draw enemies
	for i=1,#enemies do
		love.graphics.draw(enemies[i].spr, enemies[i].pos.x, enemies[i].pos.y)
	end

	for i=1,#bees do
		love.graphics.draw(bees[i].spr, bees[i].pos.x, bees[i].pos.y)
	end

	for i=1,#finals do
		if (finals[i]) then
			love.graphics.draw(finals[i].spr, finals[i].pos.x, finals[i].pos.y)
		end
	end
end

return csim_game
