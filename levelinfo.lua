-------------------------------------------------------------
--
--
-- Level information to be loaded
--
--
-------------------------------------------------------------

-- Properties to be set
local levels = {}

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
	portal1.y = display.contentHeight-12.5
	portal1.orientation = "horizontal"

	local portal2 = {}
	portal2.color = "portal_yellow.png"
	portal2.x = display.contentCenterX
	portal2.y = 12.5
	portal2.orientation = "horizontal"

	--Barriers
	local barrier1 = {}
	barrier1.color = "portal_red.png"
	barrier1.width = display.contentWidth
	barrier1.height = 25
	barrier1.x = display.contentCenterX
	barrier1.y = display.contentCenterY + 300

	--Player and Goal
	_player.x = display.contentCenterX
	_player.y = display.contentCenterY + 100
	_goal.x = display.contentCenterX
	_goal.y = display.contentHeight-250

	table.insert( _portals, portal1 )
	table.insert( _portals, portal2 )
	table.insert( _barriers, barrier1 )
end

local function levelTwo()

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
	portal1.y = display.contentHeight-12.5
	portal1.orientation = "horizontal"

	local portal2 = {}
	portal2.color = "portal_yellow.png"
	portal2.x = display.contentCenterX
	portal2.y = 12.5
	portal2.orientation = "horizontal"

	--Barriers
	local barrier1 = {}
	barrier1.color = "portal_yellow.png"
	barrier1.width = display.contentWidth
	barrier1.height = 25
	barrier1.x = display.contentCenterX
	barrier1.y = display.contentCenterY + 200

	--Player and Goal
	_player.x = display.contentCenterX
	_player.y = display.contentCenterY + 100
	_goal.x = display.contentCenterX
	_goal.y = display.contentHeight-150

	table.insert( _portals, portal1 )
	table.insert( _portals, portal2 )
	table.insert( _barriers, barrier1 )
end


function levels.level(num)
	if(num==1) then
		levelOne()
	elseif(num==2) then
		levelTwo()
	elseif(num==3) then
	elseif(num==4) then
	elseif(num==5) then
	end
end

return levels