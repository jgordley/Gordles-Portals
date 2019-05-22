
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require( "physics" )
local vx, vy
local xdir, ydir
local width, height
physics.start()
physics.setGravity( 0, 0 )

--Swipe variables
local beginX 
local beginY  
local endX  
local endY 
 
local xDistance  
local yDistance
 
local bDoingTouch
local minSwipeDistance = 50
local totalSwipeDistanceLeft
local totalSwipeDistanceRight
local totalSwipeDistanceUp
local totalSwipeDistanceDown
local swipeDegrees = 0

local swipeIndicator

-- Initialize variables
local player
local game = true---GAME NOT DONE -> true

local backGroup
local mainGroup
local uiGroup

-- Portal variables
local portalOffset
local portalOffsetOrientation

local transportOffset
local directionRelative
local xtarget
local ytarget
local velocityMagnitude

local function backButton(event)
	if event.phase == "began" then
        composer.gotoScene("levelselect", {time=500, effect="crossFade"})
    end
end

local function loadPlayer(locationX, locationY)
	player = display.newImageRect( mainGroup, "player.png", 100, 100)
	player.x = locationX
	player.y = locationY
	physics.addBody( player, { radius=50, isSensor=true } )
	player.myName = "player"
	player.canTravel = true
	player.canRespawn = true
	player.vx = 0
	player.vy = -400
end

local function calcSwipeDirection(x1, x2, y1, y2)
	xc = x2-x1
	yc = y2-y1
	degrees = atan(yc/xc)
end

local function loadGoal(locationX, locationY)
	goal = display.newRect( mainGroup, 0, 0, 90, 90)
	goal.x = locationX
	goal.y = locationY
	physics.addBody( goal, { radius = 50, isSensor=true } )
	goal.myName = "goal"
end

local function orientation(direction)
	if(direction=="horizontal") then
		return 300, 25
	elseif(direction=="vertical") then
		return 25, 300
	else
		print("ORIENTATION ERROR")
	end
end

local function direction(object)
	xDifference = object.x-display.contentWidth/2
	yDifference = object.y-display.contentHeight/2

	if(math.abs(xDifference)>math.abs(yDifference)) then
		return -xDifference, 0
	else
		return 0, -yDifference
	end
end

local function loadPortals(portalName, x1, y1, orientation1, direction1, x2, y2, orientation2, direction2)
	width, height = orientation(orientation1)
	portalOne = display.newImageRect(mainGroup, portalName, width, height)
	portalOne.x = x1
	portalOne.y = y1
	physics.addBody(portalOne, {isSensor=true})
	portalOne.myName = "portal"
	portalOne.orientation = orientation1
	portalOne.direction = direction1

	width, height = orientation(orientation2)
	portalTwo = display.newImageRect(mainGroup, portalName, width, height)
	portalTwo.x = x2
	portalTwo.y = y2
	physics.addBody(portalTwo, {isSensor=true})
	portalTwo.myName = "portal"
	portalTwo.orientation = orientation2
	portalTwo.direction = direction2

	portalOne.partner = portalTwo
	portalTwo.partner = portalOne
end

local function loadBarrier(barrierName, x1, y1, width, height) 
	barrier1 = display.newImageRect(mainGroup, barrierName, width, height)
	barrier1.x = x1
	barrier1.y = y1
	barrier1.myName = "barrier"
	physics.addBody(barrier1, "dynamic", {bounce=1, isSensor=true})
end

local function setPlayerVelocity(vx, vy)
	player.vx = vx
	player.vy = vy
	player:setLinearVelocity(player.vx, player.vy)
end

local function trajectory(obj, col, targ, vx, vy)
	velocityMagnitude = math.sqrt(vx^2 + vy^2)

end

local function transport(object, objectCollided, target, xv, yv)

	print(objectCollided.orientation)
	print(objectCollided.myName)
	print(objectCollided.direction)

	-- Get the object offset from the portal on collision
	if objectCollided.orientation == "horizontal" then
		transportOffset = objectCollided.x - object.x
		print("Transport offset: " .. transportOffset)
	elseif objectCollided.orientation == "vertical" then
		transportOffset = objectCollided.y - object.y
		print("Transport offset: " .. transportOffset)
	end

	-- Determine the new x and y coordinates and transport the object
	if target.orientation == "horizontal" then
		if target.direction == "up" then
			xtarget = target.x-transportOffset
			ytarget = target.y
		elseif target.direction == "down" then
			xtarget = target.x+transportOffset
			ytarget = target.y
		end
	elseif target.orientation == "vertical" then
		if target.direction == "right" then
			xtarget = target.x 
			ytarget = target.y-transportOffset
		elseif target.direction == "left" then
			xtarget = target.x 
			ytarget = target.y+transportOffset
		end
	end
	object.x = xtarget
	object.y = ytarget

	xdir, ydir = direction(object)

	-- xdir, ydir = trajectory(object, objectCollided, target, xv, yv)
	object:setLinearVelocity(xdir, ydir)
end

local function fadeAndMove(object, xpos, ypos, xv, yv)
	object.x = xpos
	object.y = ypos
	xdir, ydir = direction(object)
	object:setLinearVelocity(xdir, ydir)
end

local function handleDeath(player1)
	print("died")
	player1.x = _player.x
	player1.y = _player.y
	player1.canRespawn = true
end

local function handleWin(player1, goal1)
	print("victory")
	display.remove(player1)
	display.remove(goal1)

	local nextLevelButton = display.newImageRect(uiGroup, "portal_blue.png", display.contentWidth/3, display.contentHeight/10)
	nextLevelButton.x = display.contentCenterX
	nextLevelButton.y = display.contentCenterY + 150
	nextLevelButton.text = display.newText(uiGroup, "Next Level", nextLevelButton.x, nextLevelButton.y, native.systemFont, 60)
	nextLevelButton:addEventListener("touch", backButton)

	local winText = display.newText( uiGroup, "Nice!", display.contentCenterX, display.contentCenterY-50, native.systemFont, 80 )
end

local function onCollision(event)
	if(event.phase == "began") then
		local obj1 = event.object1
		local obj2 = event.object2

		if(obj1.myName == "player" and obj1.canTravel and obj2.myName == "portal" and game) then
			vx, vy = obj1:getLinearVelocity()
			obj1.canTravel=false
			timer.performWithDelay(200, function() return transport(obj1, obj2, obj2.partner, vx, vy) end, 1)
			timer.performWithDelay(500, function() obj1.canTravel=true end, 1)
		elseif(obj2.myName == "player" and obj2.canTravel and obj1.myName == "portal" and game) then
			vx, vy = obj2:getLinearVelocity()
			obj2.canTravel=false
			timer.performWithDelay(200, function() return transport(obj2, obj1, obj1.partner, vx, vy) end, 1)
			timer.performWithDelay(500, function() obj2.canTravel=true end, 1)
		elseif(obj1.myName == "player" and obj2.myName == "barrier" and obj1.myName == true and game) then
			obj1.canRespawn = false
			timer.performWithDelay(1, function() return handleDeath(obj1) end, 1)
		elseif(obj1.myName == "barrier" and obj2.myName == "player" and obj2.canRespawn == true and game) then
			obj2.canRespawn = false
			timer.performWithDelay(1, function() return handleDeath(obj2) end, 1)
		elseif(obj1.myName == "player" and obj2.myName == "goal") then
			print(obj1.myName)
			print("collided with")
			print(obj2.myName)
			game = false
			handleWin(obj1, obj2)
			--timer.performWithDelay(1, function() return handleWin(obj1, obj2) end, 1)
		elseif(obj1.myName == "goal" and obj2.myName == "player") then
			print(obj1.myName)
			print("collided with")
			print(obj2.myName)
			game = false 
			handleWin(obj1, obj2)
			--timer.performWithDelay(1, function() return handleWin(obj2, obj1) end, 1)
		end
	end
end

function checkSwipeDirection()
	if bDoingTouch == true then
		xDistance = endX-beginX
		yDistance = endY-beginY
		swipeDegrees = math.atan(yDistance/xDistance)
		print(swipeDegrees)
		if xDistance>=0 then
			setPlayerVelocity(400*math.cos(swipeDegrees), 400*math.sin(swipeDegrees))
		else
			setPlayerVelocity(-400*math.cos(swipeDegrees), -400*math.sin(swipeDegrees))
		end
	end
end
 
 function swipe(event)
        if event.phase == "began" then
        	bDoingTouch = true
            beginX = event.x
            beginY = event.y
            swipeIndicator = display.newImageRect(uiGroup, "portal_red.png", 5, 0)
            swipeIndicator.x = player.x
            swipeIndicator.y = player.y
        elseif event.phase == "moved" then
        	swipeIndicator.width = math.sqrt((beginX-event.x)^2 +(beginY-event.y)^2)
        	swipeIndicator.height = 5;
        elseif event.phase == "ended"  then
            endX = event.x
            endY = event.y
            checkSwipeDirection();
            bDoingTouch = false
            display.remove(swipeIndicator)
        end
end
 
Runtime:addEventListener("touch", swipe)

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
	endX = 0
	endY = 0

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	physics.pause()  -- Temporarily pause the physics engine

	-- Set up display groups
	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )  -- Insert into the scene's view group

	mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
	sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert( uiGroup )    -- Insert into the scene's view group
	
	-- Load the background
	local background = display.newImageRect( backGroup, "background.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	
	-- Load the player
	loadPlayer(_player.x, _player.y)
	loadGoal(_goal.x, _goal.y)

	-- Load the portals
	for i=1,_numPortalSets do
		portal1 = _portals[i]
		portal2 = _portals[i+1]
		loadPortals(portal1.color, portal1.x, portal1.y, portal1.orientation, portal1.direction, portal2.x, portal2.y, portal2.orientation, portal2.direction)
	end

	-- Load the barriers
	for i=1,_numBarriers do
		barrier1 = _barriers[i]
		loadBarrier(barrier1.color, barrier1.x, barrier1.y, barrier1.width, barrier1.height)
	end

	-- Display lives and score
	
	-- StartPlayerMovement
	--player:setLinearVelocity(0, -400)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
		Runtime:addEventListener( "collision", onCollision )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener( "collision", onCollision )
		Runtime:removeEventListener("touch", swipe)
		physics.pause()
		composer.removeScene( "game" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
