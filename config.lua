--
-- For more information on config.lua see the Project Configuration Guide at:
-- https://docs.coronalabs.com/guide/basics/configSettings
--
local aspectRatio = display.pixelHeight / display.pixelWidth
application =
{
	content =
	{
		width = 768, --aspectRatio > 1.5 and 768 or math.ceil( 1024 / aspectRatio ),
     	height = 1366,--aspectRatio < 1.5 and 1024 or math.ceil( 768 * aspectRatio ),
      	scale = "letterBox",
      	fps = 60,
	},
}
