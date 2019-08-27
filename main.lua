--[[ 
-- LOADING SCREEN
-- Uncomment to activate
-- Can be an image for example

love.graphics.clear(255,255,255)
local w, h = love.window.getMode()

> love.graphics.draw(...)
> love.graphics.print(...)
> ...

love.graphics.present()
]]--

--log to IDE
io.stdout:setvbuf("no")

class = require('lib.hump.class')
keys = require('lib.keys')
utils = require('src.utils')

-- Load Libraries
local ScreenManager = require('lib.ScreenManager')
--

-- Load Screens
local TitleScreen = require('src.screens.TitleScreen')
local GameScreen = require('src.screens.GameScreen')
--


-- Load Game
function love.load()
	love.graphics.setDefaultFilter( "nearest", "nearest", 1 )
	font = love.graphics.newFont("assets/fonts/zpix.ttf", 12)
	font:setFilter( "nearest", "nearest", 0 )
	love.graphics.setFont(font)
	
	local screenManager = ScreenManager()
	
	-- Register your screens here (A screen with the path '/' is mandatory!)
	screenManager:register('/', TitleScreen)
	screenManager:register('game', GameScreen)
	
	-- Load the main screen. Only needed if you didn't register a screen with path "/"
	--screenManager:view('test/index', 'Wow!')
end
--


