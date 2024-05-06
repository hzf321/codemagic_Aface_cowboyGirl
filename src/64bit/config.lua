
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = true

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false

COMMON_PICS_PATH = "commonpics/"
COMMON_FONTS_PATH = "commonfonts/"

-- for module display
CC_DESIGN_RESOLUTION = {
    width = 1280,
    height = 720,
    autoscale = "FIXED_HEIGHT",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.34 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return {autoscale = "FIXED_WIDTH"}
        end
    end
}

Splunk_Type = {
	RECORD = "record",         -- pid  1
	ACTION = "action",         -- action ""
	Error = "client_error",    -- error ""
	CoinError = "coin_error",  -- coin_error "" 
	Guide = "guide"            -- pid 1
}
