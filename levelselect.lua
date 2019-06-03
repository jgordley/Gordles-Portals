local composer = require( "composer" )

local scene = composer.newScene()

local backGroup
local mainGroup
local uiGroup

local levelScript = require("levelinfo")
local levels = {}

local function handleSelect(event) 
	if event.phase == "began" then
        levelScript.level(event.target.number)
        composer.gotoScene("game", {time=500, effect="crossFade"})
        composer.removeScene(scene)
    end
end

local function goBack(event)
	if event.phase == "began" then
		composer.gotoScene("menu", {time=500, effect="crossFade"})
	end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	-- Set up display groups
	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )  -- Insert into the scene's view group

	mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
	sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert( uiGroup )    -- Insert into the scene's view group
	
	-- Load the background
	local background = display.newImageRect( backGroup, "background.png", display.contentWidth, display.contentHeight )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	
	local numCounter = 1
	for i=1, 5 do
		for j=1,3 do
			levels[numCounter] = display.newImageRect(uiGroup, "portal_red.png", display.contentWidth/5, display.contentWidth/5)
			levels[numCounter].x = j*display.contentWidth/4
			levels[numCounter].y = (i+0.25)*display.contentHeight/7
			levels[numCounter].number = numCounter
			levels[numCounter].numberText = display.newText( uiGroup, numCounter, levels[numCounter].x, levels[numCounter].y, native.systemFontBold, 60)
			levels[numCounter]:addEventListener( "touch", handleSelect )
			numCounter=numCounter+1
		end
	end

	local backButton = display.newImageRect(uiGroup, "portal_blue.png", display.contentWidth/5, display.contentWidth/5)
	backButton.x = display.contentWidth-(display.contentWidth/5)
	backButton.y = display.contentHeight-(display.contentWidth/5)
	backButton.backText = display.newText(uiGroup, "Back", backButton.x, backButton.y, native.systemFontBold, 60)
	backButton:addEventListener("touch", goBack)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
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

