local composer = require("composer")

local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

local Starfield = require("starfield")
local Player = require("player")
local StickLib = require("lib_analog_stick")
local fireButton = require("fireButton")
local bullet = require("bullet")
local enemy = require("enemy")
local catmullromspline = require("catmullromspline")

local sheetInfo = require("shooterSheet")
local shooterSheet = graphics.newImageSheet( "assets/images/shooterSheet.png", sheetInfo:getSheet() )

local scene = composer.newScene()

local starfield
local player
local fireButtonA
local counterA
local fireButtonB
local counterB
local enemyTable = {}

local backGroup = display.newGroup()
local playerShotGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local stick

system.activate("multitouch")

-----------------------------------------------------------
local function loadEnemys()

	math.randomseed(os.time())

	for i= 1,10 do

		local x = i*display.contentHeight/8
		local y = 100
		local e = enemy.new(shooterSheet, sheetInfo:getFrameIndex("enemyRed1"), 400, 5)
		e:create(x, y, mainGroup)
		physics.addBody(e.ship, {radius=e.ship.width/2.5, isSensor=true})

		local cmrs = catmullromspline.new({{x = 0, y=300},
			{x = -200, y = 400}, 
			{x = 0, y = 500}, 
			{x = 200, y = 400},
			{x = 0, y=300}}, 5)
	
		local path = cmrs:create()

		e:setPath(path)
		table.insert(enemyTable, e)
	end

	for i= 1,10 do

		local x = i*display.contentHeight/8-20
		local y = 300
		local e = enemy.new(shooterSheet, sheetInfo:getFrameIndex("enemyBlue4"), 400, 5)
		e:create(x, y, mainGroup)
		physics.addBody(e.ship, {radius=e.ship.width/2.5, isSensor=true})

		local cmrs = catmullromspline.new({{x = 0, y=-300},
			{x = -200, y = 400}, 
			{x = 0, y = 500}, 
			{x = 200, y = 400},
			{x = 0, y=-300}}, 5)

		local path = cmrs:create()

		e:setPath(path)
		table.insert(enemyTable, e)
	end	
end

-----------------------------------------------------------
local function onCollision(event)

	if(event.phase == "began") then

		local obj1 = event.object1
		local obj2 = event.object2

		if( (obj1.name == "playerLaser" and obj2.name == "enemy") or
			(obj1.name == "enemy" and obj2.name == "playerLaser")) 
		then

			if(obj1.name == "playerLaser") then display.remove(obj1) end
			if(obj2.name == "playerLaser") then display.remove(obj2) end

			if(obj1.name == "enemy") then

				obj1.hit(obj2.getPower())
		 	end
			if(obj2.name == "enemy") then

				obj2.hit(obj1.getPower())
			end
		end
	end
end

-----------------------------------------------------------
local function update(event)

	player:setStick(stick:getAngle(), stick:getDistance())
	
	starfield:update()

    player:update()

	counterA = counterA + 1
    counterB = counterB + 1

    if (fireButtonA.down == true) then

    	if counterA > 5 then

			local shoot = bullet.new(shooterSheet, sheetInfo:getFrameIndex("laserBlue01"), 0, -600, 1)
			shoot:create(player.ship.x, player.ship.y, "playerLaser")
			physics.addBody(shoot.image, "kinematic")
			shoot.image:setLinearVelocity(0, shoot.speedPerSecond)
			playerShotGroup:insert(shoot.image)

			counterA = 0
		end
    end

    if (fireButtonB.down == true) then

    	if counterB > 30 then

	    	local shoot = bullet.new(shooterSheet, sheetInfo:getFrameIndex("laserRed01"), 0, -600, 5)
	    	shoot:create(player.ship.x, player.ship.y, "playerLaser")
	    	physics.addBody(shoot.image, "kinematic")
			shoot.image:setLinearVelocity(0, shoot.speedPerSecond)
	    	playerShotGroup:insert(shoot.image)

	    	counterB = 0
	    end
    end

    local j

    for j=playerShotGroup.numChildren, 1, -1 do
    	if playerShotGroup[j].y < 0 then
    		display.remove(playerShotGroup[j])
    		playerShotGroup[j] = nil
    	end
    end

    for i = #enemyTable, 1, -1 do

    	if(enemyTable[i].health < 1) then

    		display.remove(enemyTable[i].ship)
    		table.remove(enemyTable, i)
    	end
    end

    for i = #enemyTable, 1, -1 do

    	enemyTable[i]:update()
    end
end

-----------------------------------------------------------
function scene:create(event)

	physics.pause()

	-- Create stick
	stick = StickLib.NewStick(
	{
		x = display.contentWidth*.15,
		y = display.contentHeight*.85,
		imageSheet = shooterSheet,
		imageMain = sheetInfo:getFrameIndex("joystickMain"),
		imageThumb = sheetInfo:getFrameIndex("joystickThumb"),
		scale = 2.0,
		borderSize = 64,
		snapBackSpeed = .2,
		R = 255,
		G = 0, 
		B = 0
	})

	-- the starfield
	starfield = Starfield.new (600, 2, 2)
	starfield:create(backGroup)

	-- the player
	player = Player.new(shooterSheet, sheetInfo:getFrameIndex("playerShip1_blue"), 400, 20)
	player:create(display.contentWidth/2, display.contentHeight-100, mainGroup)
	physics.addBody(player.ship, {isSensor=true})

	-- firebuttonA
	fireButtonA = fireButton.new(shooterSheet, sheetInfo:getFrameIndex("joystickFireA"), 2.0)
	fireButtonA:create(display.contentWidth*.75, display.contentHeight*.85, uiGroup)

	-- firebuttonB
	fireButtonB = fireButton.new(shooterSheet, sheetInfo:getFrameIndex("joystickFireB"), 2.0)
	fireButtonB:create(display.contentWidth*.90, display.contentHeight*.85, uiGroup)

	-- joystick
	uiGroup:insert(stick)
	player:setStickMaxDistance(stick:getMaxDistance())

	counterA = 0
	counterB = 0

	loadEnemys()

	physics.start()
end

-----------------------------------------------------------
function scene:show(event)

	local phase = event.phase

	if (phase == "will") then

	elseif (phase == "did") then

		physics.start()
	end
end

-----------------------------------------------------------
function scene:hide(event)
end

-----------------------------------------------------------
function scene:destroy(event)
end

-----------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

Runtime:addEventListener("enterFrame", update)
Runtime:addEventListener("collision", onCollision)

-----------------------------------------------------------
return scene