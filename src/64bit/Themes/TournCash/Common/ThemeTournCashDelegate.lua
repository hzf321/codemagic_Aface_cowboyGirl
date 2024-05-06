---
--- @program src 
--- @description:  
--- @author: rwb 
--- @create: 2021/05/10 14:28
---
local ThemeTournCashDelegate = class("ThemeTournCashDelegate")
local cls = ThemeTournCashDelegate
function cls:ctor(ctl)
    self.tcCommonCtl = ctl
    self.themeCtl = self.tcCommonCtl.themeCtl
    self.gameConfig = self.tcCommonCtl.gameConfig
end
function cls:getCommonConfig()
    return self.tcCommonCtl:getCommonConfig()
end
function cls:getPic(name)
    return string.format("theme_tourn_cash/%s", name)
end
function cls:getSpineFile(file_name, notPathSpine)
    local path2 = self.gameConfig.spine_path[file_name]
    --libDebug.printTable("rwb_spine_path", self.gameConfig.spine_path)
    local path = string.format("theme_tourn_cash/spine/%s", path2)
    return path
end
function cls:getFntFilePath(file_name)
    local path = string.format("theme_tourn_cash/font/%s", file_name)
    return path
end
function cls:getParticleFile(file_name)
    local path2 = self.gameConfig.particle_path[file_name]
    local path = string.format("theme_tourn_cash/particle/%s", path2)
    return path
end
function cls:getCsbPath(file_name)
    local path2 = self.gameConfig.csb_list[file_name]
    local path = string.format("theme_tourn_cash/csb/%s", path2)
    return path
end
function cls:getCellPos(...)
    return self.themeCtl:getCellPos(...)
end
function cls:laterCallBack(...)
    self.themeCtl:laterCallBack(...)
end
function cls:playMusicByName(file_name, singleton, loop)
    if self.tcCommonCtl.audio_list and self.tcCommonCtl.audio_list[file_name] then
        self.themeCtl:playCommonMusic(self.tcCommonCtl.audio_list[file_name], singleton, loop)
    end
end
function cls:stopMusicByName(file_name, isCleanSingle)
    if self.tcCommonCtl.audio_list and self.tcCommonCtl.audio_list[file_name] then
        self.themeCtl:stopCommonMusic(self.tcCommonCtl.audio_list[file_name], isCleanSingle)
    end
end

return cls