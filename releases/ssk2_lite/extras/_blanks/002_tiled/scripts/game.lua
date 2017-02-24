-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
-- game.lua - Game Module
-- =============================================================
local common 		= require "scripts.common"
local factoryMgr 	= ssk.factoryMgr
local physics 		= require "physics"

-- =============================================================
-- Localizations
-- =============================================================
-- Commonly used Lua Functions
local getTimer          = system.getTimer
local mRand					= math.random
local mAbs					= math.abs
--
-- Common SSK Display Object Builders
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
--
-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
--
-- Common SSK Helper Functions
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = ssk.misc.normRot;local easyAlert = ssk.misc.easyAlert
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale


local RGTiled = ssk.tiled

-- =============================================================
-- Locals
-- =============================================================
local layers

-- =============================================================
-- Module Begins
-- =============================================================
local game = {}


-- ==
--    init() - One-time initialization only.
-- ==
function game.init()

	--
	-- Mark game as not running
	--
	common.gameIsRunning = false

	--
	-- Initialize all factories
	--
	factoryMgr.init()

	--
	-- Trick: Start physics, then immediately pause it.
	-- Now it is ready for future interactions/settings.
	physics.start()
	physics.pause()

	-- Clear Score, Couins, Distance Counters
	common.score 		= 0
	common.coins 		= 0
	common.distance 	= 0
end


-- ==
--    stop() - Stop game if it is running.
-- ==
function game.stop()
 
	--
	-- Mark game as not running
	--
	common.gameIsRunning = false

	--
	-- Pause Physics
	physics.setDrawMode("normal")	
	physics.pause()
end

-- ==
--    destroy() - Remove all game content.
-- ==
function game.destroy() 
	--
	-- Reset all of the factories
	--
	factoryMgr.reset( )

	-- Destroy Existing Layers
	if( layers ) then
		ignoreList( { "onDied" }, layers )
		display.remove( layers )
		layers = nil
	end

	-- Clear Score, Couins, Distance Counters
	common.score 		= 0
	common.coins 		= 0
	common.distance 	= 0
end


-- ==
--    start() - Start game actually running.
-- ==
function game.start( group, params )
	params = params or { debugEn = false }

	game.destroy() 

	--
	-- Mark game as running
	--
	common.gameIsRunning = true

	--
	-- Configure Physics
	--
	physics.start()
	physics.setGravity( common.gravityX, common.gravityY )
	if( params.hybridEn ) then
		physics.setDrawMode("hybrid")	
	end

	--
	-- Create Layers
	--
	layers = ssk.display.quickLayers( group, 
		"underlay", 
		"world", 
			{ "background", "content", "foreground" },
		"interfaces" )

	--
	-- Create a background color	
	--
	newRect( layers.underlay, centerX, centerY, 
		      { w = fullw, h = fullh, fill = hexcolor("#2FBAB4") })


	--
	-- Create One Touch Easy Input
	--
	--ssk.easyInputs.oneTouch.create(layers.underlay, { debugEn = params.debugEn, keyboardEn = true } )
	--ssk.easyInputs.twoTouch.create(layers.underlay, { debugEn = params.debugEn, keyboardEn = true } )
	--ssk.easyInputs.oneStick.create( layers.underlay, { debugEn = true, joyParams = { doNorm = true } } )
	--ssk.easyInputs.twoStick.create( layers.underlay, { debugEn = true, joyParams = { doNorm = true } } )
	--ssk.easyInputs.oneStickOneTouch.create( layers.underlay, { debugEn = true, joyParams = { doNorm = true } } )


	--
	-- Create HUDs
	--
	--factoryMgr.new( "scoreHUD", layers.interfaces, centerX, top + 40 )
	--factoryMgr.new( "coinsHUD", layers.interfaces, left + 10, top + 70, { iconSize = 40, fontSize = 36 } )
	--factoryMgr.new( "distanceHUD", layers.interfaces, centerX, top + 70, { fontSize = 36 } )

  

   --table.dump(RGTiled, nil, "RGTiled")   
   local level = RGTiled.new()
   
   table.dump(level, nil, "level")   
   level.setLevelsPath( "levels" )

   level.load( "level1", {} )

   --table.dump(level, nil, "level loaded")   

   local objects = level.getRecords()
   --table.dump(objects,nil,"objects")

   local images = level.getImages()
   --table.dump(images,nil,"images")

   local function callFactory( rec, num )   	
   	local img = level.getImage( rec.gid )
   	local path = img.image
   	if( rec.gid == 3 ) then
   		factoryMgr.new( "platform", layers.content, rec.x, rec.y, 
   			{ width = rec.width, height = rec.height } )
   	elseif( rec.gid == 7 ) then
   		factoryMgr.new( "player", layers.content, rec.x, rec.y, 
   			{ world = layers.world } )
   	else
   		print("GID", rec.gid)
   	end
	end

	level.forEach( callFactory )

end


return game



