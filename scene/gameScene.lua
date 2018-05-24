-- game scene

-- place all the require statements here
local composer = require( "composer" )
local physics = require("physics")
local json = require( "json" )
local tiled = require( "com.ponywolf.ponytiled" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view

    -- start physics
    physics.start()
    physics.setGravity( 0, 32 )
    --physics.setDrawMode("hybrid")

    -- Load our map
	local filename = "assets/maps/level0.json"
	local mapData = json.decodeFile( system.pathForFile( filename, system.ResourceDirectory ) )
	map = tiled.new( mapData, "assets/maps" )
    --map.xScale, map.yScale = 0.85, 0.85

    -- our character
    local sheetOptionsIdle = require("assets.spritesheets.knight.knightIdle")
    local sheetIdleKnight = graphics.newImageSheet( "./assets/spritesheets/knight/knightIdle.png", sheetOptionsIdle:getSheet() )

    local sheetOptionsRun = require("assets.spritesheets.knight.knightRun")
    local sheetRunningKnight = graphics.newImageSheet( "./assets/spritesheets/knight/knightRun.png", sheetOptionsRun:getSheet() )

    -- sequences table
    local sequence_data = {
        -- consecutive frames sequence
        {
            name = "idle",
            start = 1,
            count = 10,
            time = 800,
            loopCount = 0,
            sheet = sheetIdleKnight
        },
        {
            name = "walk",
            start = 1,
            count = 10,
            time = 1000,
            loopCount = 1,
            sheet = sheetWalkingKnight
        }
    }

    local knight = display.newSprite( sheetIdleKnight, sequence_data )
    -- Add physics
	physics.addBody( knight, "dynamic", { density = 3, bounce = 0, friction =  1.0 } )
	knight.isFixedRotation = true
    knight.x = display.contentWidth * .5
    knight.y = 0
    knight:setSequence( "idle" )
    knight:play()
    
    -- Insert our game items in the correct back-to-front order
    sceneGroup:insert( map )
    sceneGroup:insert( knight )
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
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