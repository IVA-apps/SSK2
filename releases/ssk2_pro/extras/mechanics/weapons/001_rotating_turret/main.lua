-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2017 (All Rights Reserved)
-- =============================================================
--  main.lua (11/14)
-- =============================================================
-- Kernel: Rotating Turret
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- LOAD & INITIALIZE - SSK 2
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init( { launchArgs 				= ..., 
	            enableAutoListeners 	= true,
	            exportCore 				= true,
	            exportColors 			= true,
	            exportSystem 			= true,
	            exportSystem 			= true,
	            gameFont 				= "Prime.ttf",
	            debugLevel 				= 0 } )
-- =============================================================

local kernel = require "scripts.rotating_turret"
kernel.runDemo()