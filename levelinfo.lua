-------------------------------------------------------------
--
--
-- Level information to be loaded
--
--
-------------------------------------------------------------

-- Properties to be set
local levels = {}

-- Offsets with buffer calculation
local portalOffsetTop = display.safeScreenOriginY + 12.5
local portalOffsetBottom = display.safeScreenOriginY + display.safeActualContentHeight - 12.5

-- Level One ------------------------------------------------

local function levelOne()

	--Clear previous table and barriers
	_portals = {}
	_barriers = {}
	--Portal Sets
	_numPortalSets = 1
	_numBarriers = 1

	--Portals
	local portal1 = {}
	portal1.color = "portal_yellow.png"
	portal1.x = display.contentCenterX
	portal1.y = portalOffsetBottom
	portal1.orientation = "horizontal"
	portal1.direction = "up"

	local portal2 = {}
	portal2.color = "portal_yellow.png"
	portal2.x = display.contentCenterX
	portal2.y = portalOffsetTop
	portal2.orientation = "horizontal"
	portal2.direction = "down"

	--Barriers
	local barrier1 = {}
	barrier1.color = "portal_red.png"
	barrier1.width = display.contentWidth
	barrier1.height = 25
	barrier1.x = display.contentCenterX
	barrier1.y = 3*display.contentHeight/5
	barrier1.rotationVal = 0

	--Player and Goal
	_player.x = display.contentCenterX
	_player.y = display.contentCenterY
	_goal.x = display.contentCenterX
	_goal.y = 4*display.contentHeight/5

	table.insert( _portals, portal1 )
	table.insert( _portals, portal2 )
	table.insert( _barriers, barrier1 )
end

local function levelTwo()

	--Clear previous table and barriers
	_portals = {}
	_barriers = {}
	--Portal Sets
	_numPortalSets = 4
	_numBarriers = 3

	--Portals
	local portal1 = {}
	portal1.color = "portal_yellow.png"
	portal1.x = display.contentWidth-12.5
	portal1.y = 5*display.contentHeight/6
	portal1.orientation = "vertical"
	portal1.direction = "left"

	local portal2 = {}
	portal2.color = "portal_yellow.png"
	portal2.x = display.contentWidth-12.5
	portal2.y = display.contentHeight/6
	portal2.orientation = "vertical"
	portal2.direction = "left"

	local portal3 = {}
	portal3.color = "portal_blue.png"
	portal3.x = 12.5
	portal3.y = display.contentHeight/6
	portal3.orientation = "vertical"
	portal3.direction = "right"

	local portal4 = {}
	portal4.color = "portal_blue.png"
	portal4.x = 12.5
	portal4.y = 3*display.contentHeight/5
	portal4.orientation = "vertical"
	portal4.direction = "right"

	local portal5 = {}
	portal5.color = "portal_pink.png"
	portal5.x = display.contentWidth-12.5
	portal5.y = 3*display.contentHeight/5
	portal5.orientation = "vertical"
	portal5.direction = "left"

	local portal6 = {}
	portal6.color = "portal_pink.png"
	portal6.x = display.contentWidth-12.5
	portal6.y = 2*display.contentHeight/5
	portal6.orientation = "vertical"
	portal6.direction = "left"

	local portal7 = {}
	portal7.color = "portal_purple.png"
	portal7.x = 12.5
	portal7.y = 5*display.contentHeight/6
	portal7.orientation = "vertical"
	portal7.direction = "right"

	local portal8 = {}
	portal8.color = "portal_purple.png"
	portal8.x = 12.5
	portal8.y = 2*display.contentHeight/5
	portal8.orientation = "vertical"
	portal8.direction = "right"

	--Barriers
	local barrier1 = {}
	barrier1.color = "portal_red.png"
	barrier1.width = display.contentWidth
	barrier1.height = 25
	barrier1.x = display.contentCenterX
	barrier1.y = 5*display.contentHeight/7

	local barrier2 = {}
	barrier2.color = "portal_red.png"
	barrier2.width = display.contentWidth
	barrier2.height = 25
	barrier2.x = display.contentCenterX
	barrier2.y = 2*display.contentHeight/7

	local barrier3 = {}
	barrier3.color = "portal_red.png"
	barrier3.width = 25
	barrier3.height = 200
	barrier3.x = display.contentWidth/6
	barrier3.y = 2*display.contentHeight/5

	--Player and Goal
	_player.x = display.contentCenterX
	_player.y = 5*display.contentHeight/6
	_goal.x = 2*display.contentWidth/5
	_goal.y = 2*display.contentHeight/5
	-- _goal.x = display.contentCenterX
	-- _goal.y = display.contentHeight-150

	table.insert( _portals, portal1 )
	table.insert( _portals, portal2 )
	table.insert( _portals, portal3 )
	table.insert( _portals, portal4 )
	table.insert( _portals, portal5 )
	table.insert( _portals, portal6 )
	table.insert( _portals, portal7 )
	table.insert( _portals, portal8 )
	table.insert( _barriers, barrier1 )
	table.insert( _barriers, barrier2 )
	table.insert( _barriers, barrier3 )
end


function levels.level(num)
	if(num==1) then
		levelOne()
	elseif(num==2) then
		levelTwo()
	elseif(num==3) then
		levelThree()
	elseif(num==4) then
	elseif(num==5) then
	end
end

return levels