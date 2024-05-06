
-- for CCLuaEngine traceback

function __G__TRACKBACK__(msg)
    require("Utils/Log")
    local errMsg = "LUA ERROR: "..tostring(msg).."\n"..tostring(debug.traceback())

    print("----------------------------------------")
    print(errMsg)
    print("----------------------------------------")

    if debugXpCall then
        debugXpCall()
    end

    return msg
end


function __G__ReloadLua__( files )
    local table = bole.splitStr(files,",")
    for i,f in pairs(table) do
        print("reload file "..f)
        package.loaded[f] = nil
        require(f)
    end
    if appDebugMode then
        bole.showMessageBox("Reload lua finished")
    end
end

function __G_INIT_GARBAGE__()
	collectgarbage("collect")
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
--    math.randomseed(os.time())
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
end


function __G_DEBUG(d)
	if d then
		local director = cc.Director:getInstance()
    	--turn on display FPS
    	director:setDisplayStats(true)
    	--set FPS. the default value is 1.0/60 if you don't call this
    	director:setAnimationInterval(1.0 / 60)
    end
end

__G_INIT_GARBAGE__()

function setDesignSolution( ... )
    
    local director = cc.Director:getInstance()
    local glView   = director:getOpenGLView()
    local screenDesign = require "screenDesign"
    local screenDesignSize = screenDesign:getDesignResolution()
    DESIGN_WIDTH    = 1280
    DESIGN_HEIGHT   = 720
    PAD_TAG         = false
    if nil == glView then
        glView = cc.GLViewImpl:createWithRect("Lua Tests", cc.rect(0,0,DESIGN_WIDTH,DESIGN_HEIGHT))
        director:setOpenGLView(glView)
    end
    local designSize = {width = DESIGN_WIDTH, height = DESIGN_HEIGHT}
    local policy = cc.ResolutionPolicy.FIXED_HEIGHT
    SCREEN_RATIO = 1
    MARGIN_W     = 0
    MARGIN_H     = 0
    MARGIN_H2    = 0
    -- REAL_SCREEN_WIDTH = DESIGN_WIDTH
    local screenSize = glView:getFrameSize()
    SCREEN_WIDTH = screenSize.width
    SCREEN_HEIGHT = screenSize.height
    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
        glView:setFrameSize(screenSize.width, screenSize.height)
    else
        if screenDesignSize.orientation == 2 then
            glView:setFrameSize(screenSize.height, screenSize.width)
        end
    end
    glView:setDesignResolutionSize(designSize.width, designSize.height, policy)
    -- bole.setScreenOrientation(1) 
    
    local winSize = cc.Director:getInstance():getWinSize()
    FRAME_WIDTH = winSize.width
    FRAME_HEIGHT = winSize.height

    -- local winSize = cc.Director:getInstance():getWinSize()
    local h_scale = FRAME_WIDTH/DESIGN_WIDTH
    local v_scale = FRAME_HEIGHT/DESIGN_HEIGHT
    SHRINKSCALE_H = FRAME_WIDTH/DESIGN_WIDTH > FRAME_HEIGHT/DESIGN_HEIGHT and FRAME_HEIGHT/DESIGN_HEIGHT or FRAME_WIDTH/DESIGN_WIDTH 
    SHRINKSCALE_V = FRAME_HEIGHT/DESIGN_WIDTH > FRAME_WIDTH/DESIGN_HEIGHT and FRAME_WIDTH/DESIGN_HEIGHT or FRAME_HEIGHT/DESIGN_WIDTH 

    if h_scale > 1.2 then
        h_scale = 1.2
    end
    HEADER_FOOTER_SCALE_H = h_scale < 1 and h_scale or 1  
    HEADER_FOOTER_SCALE_V = 1  

    HEADER_FOOTER_RATE_H = h_scale > 1 and h_scale or 1   
    HEADER_FOOTER_RATE_V = 1

    HEADER_FOOTER_RATE = 1
    HEADER_FOOTER_SCALE = 1

    SCREENSCALE_H = SCREEN_HEIGHT/DESIGN_HEIGHT
    SCREENSCALE_V = SCREEN_HEIGHT/DESIGN_HEIGHT
end

setDesignSolution();
