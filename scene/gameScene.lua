-- game scene

-- place all the require statements here
local composer = require( "composer" )
local physics = require("physics")
local json = require( "json" )
local tiled = require( "com.ponywolf.ponytiled" )
 
local scene = composer.newScene()

-- you need these to exist the entire scene
-- this is called "forward reference"
local map = nil
local knight = nil
local rightArrow = nil
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local function onRightArrowTouch( event )
    if ( event.phase == "began" ) then
        if knight.sequence ~= "run" then
            knight.sequence = "run"
            knight:setSequence( "run" )
            knight:play()
        end

    elseif ( event.phase == "ended" ) then
        if knight.sequence ~= "idle" then
            knight.sequence = "idle"
            knight:setSequence( "idle" )
            knight:play()
        end
    end
    return true
end 
 
local moveKnight = function( event )
    
    if knight.sequence == "run" then
        transition.moveBy( knight, { 
            x = 10, 
            y = 0, 
            time = 0 
            } )
    end
end 
 
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
            name = "run",
            start = 1,
            count = 10,
            time = 1000,
            loopCount = 0,
            sheet = sheetRunningKnight
        }
    }

    knight = display.newSprite( sheetIdleKnight, sequence_data )
    -- Add physics
	physics.addBody( knight, "dynamic", { density = 3, bounce = 0, friction =  1.0 } )
	knight.isFixedRotation = true
    knight.id = "knight"
    knight.sequence = "idle"
    knight.x = 500
    knight.y = 500
    knight:setSequence( "idle" )
    knight:play()

    -- add move arrow
    rightArrow = display.newImage( "./assets/sprites/items/rightArrow.png" )
    rightArrow.x = 260
    rightArrow.y = display.contentHeight - 200
    rightArrow.alpha = 0.75
    rightArrow.id = "right arrow"
    
    -- Insert our game items in the correct back-to-front order
    sceneGroup:insert( map )
    sceneGroup:insert( knight )
    sceneGroup:insert( rightArrow )
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- add in code to check charater movement
        rightArrow:addEventListener( "touch", onRightArrowTouch )
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        Runtime:addEventListener( "enterFrame", moveKnight )
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

        -- good practise to remove every event listener you create
        rightArrow:removeEventListener( "touch", onRightArrowTouch )
        Runtime:removeEventListener( "enterFrame", moveKnight )
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