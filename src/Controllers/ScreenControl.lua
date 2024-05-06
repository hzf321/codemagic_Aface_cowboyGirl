ScreenControl = class("ScreenControl")

ScreenOrientation = {
    Landscape = 1,
    vertical = 2
}

function ScreenControl:getInstance( ... )
    if not self._instance then
        self._instance = ScreenControl.new()
    end
    return self._instance
end

function ScreenControl:ctor()
    self.isPortrait = false
    self.orientation = ScreenOrientation.Landscape
    self.preOrientation = ScreenOrientation.Landscape
    self:reset()
end


function ScreenControl:reset()
    
end

function ScreenControl:setScreenOrientation(isPortrait)
    self.isPortrait = isPortrait
    if self.isPortrait then
        self.preOrientation = self.orientation
        self.orientation = ScreenOrientation.vertical
    	bole.setScreenOrientation(ScreenOrientation.vertical) 
    else
        self.preOrientation = self.orientation
        self.orientation = ScreenOrientation.Landscape
        if bole.isThemeScene() then
            bole.setScreenOrientation(ScreenOrientation.Landscape) 
        else
            local screenDesign = require "screenDesign"
            local screenDesignSize = screenDesign:getDesignResolution()
            bole.setScreenOrientation(screenDesignSize.orientation) 
        end
    end
end

function ScreenControl:resetScreenOrientation( )
    if self.isPortrait then
        bole.setScreenOrientation(ScreenOrientation.vertical)
    else
        bole.setScreenOrientation(ScreenOrientation.Landscape) 
    end
end

function ScreenControl:resumeScreenOrientation()
    if self.preOrientation == ScreenOrientation.vertical then
        self:setScreenOrientation(true)
    else
        self:setScreenOrientation(false)
    end
end

function ScreenControl:reconnect()
    self.isPortrait = false
    self.orientation = ScreenOrientation.Landscape
    self.preOrientation = ScreenOrientation.Landscape
end