
local composer = require( "composer" )

local scene = composer.newScene()

local levelScript = require("levelinfo")

_portals = {}
_barriers = {}
_numPortalSets = 0
_numBarriers = 0
_goal = {}
_player = {}
_canSwipe = false

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

-- Initialize variables
local player

local backGroup
local mainGroup
local uiGroup

local function gotoLevel()
    composer.gotoScene( "levelselect", { time=500, effect="crossFade" } )
end

local function loadPlayer(locationX, locationY)
	player = display.newImageRect( mainGroup, "player.png", 100, 100)
	player.x = locationX
	player.y = locationY
	physics.addBody( player, { radius=50, isSensor=true } )
	player.myName = "menuPlayer"
	player.canTravel = true
end

local function orientation(direction)
	if(direction=="horizontal") then
		return 300, 25
	elseif(direction=="vertical") then
		return 25, 300
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

local function loadPortals(portalName, x1, y1, orientation1, x2, y2, orientation2)
	width, height = orientation(orientation1)
	portalOne = display.newImageRect(mainGroup, portalName, width, height)
	portalOne.x = x1
	portalOne.y = y1
	physics.addBody(portalOne, {isSensor=true})

	width, height = orientation(orientation2)
	portalTwo = display.newImageRect(mainGroup, portalName, width, height)
	portalTwo.x = x2
	portalTwo.y = y2
	physics.addBody(portalTwo, {isSensor=true})

	portalOne.partner = portalTwo
	portalTwo.partner = portalOne
end

local function fadeAndMove(object, xpos, ypos, xv, yv)
	object.x = xpos
	object.y = ypos
	xdir, ydir = direction(object)
	object:setLinearVelocity(xdir, ydir)
end


local function onCollision(event)
	if(event.phase == "began") then
		local obj1 = event.object1
		local obj2 = event.object2

		if(obj1.myName == "menuPlayer" and obj1.canTravel) then
			vx, vy = obj1:getLinearVelocity()
			obj1.canTravel=false
			timer.performWithDelay(100, function() return fadeAndMove(obj1, obj2.partner.x, obj2.partner.y, vx, vy) end, 1)
			timer.performWithDelay(500, function() obj1.canTravel=true end, 1)
		elseif(obj2.myName == "menuPlayer" and obj2.canTravel) then
			vx, vy = obj2:getLinearVelocity()
			obj2.canTravel=false
			timer.performWithDelay(100, function() return fadeAndMove(obj2, obj1.partner.x, obj1.partner.y, vx, vy) end, 1)
			timer.performWithDelay(500, function() obj2.canTravel=true end, 1)
		end
	end
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

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
	loadPlayer(display.contentCenterX,display.contentHeight-100)

	-- Load the portal
	loadPortals("portal_red.png", display.contentCenterX, 12.5, "horizontal", 12.5, display.contentCenterY, "vertical")
	loadPortals("portal_yellow.png", display.contentCenterX, display.contentHeight-12.5 ,"horizontal", 
	display.contentWidth-12.5, display.contentCenterY, "vertical")
	
	-- StartPlayerMovement
	player:setLinearVelocity(0, -400)

	local title = display.newText( uiGroup, "Portals", display.contentCenterX, 100, native.systemFont, 60 )
    title.x = display.contentCenterX
    title.y = 200

    local playButton = display.newImageRect(uiGroup, "portal_blue.png", display.contentWidth/2, display.contentHeight/10)
   	playButton.x = display.contentCenterX
   	playButton.y = display.contentCenterY
    playButton.text = display.newText( uiGroup, "Play", playButton.x, playButton.y, native.systemFont, 50 )
    playButton.alpha=0.7
 
    playButton:addEventListener( "tap", gotoLevel )
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
		physics.pause()
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

