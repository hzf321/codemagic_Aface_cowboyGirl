
local screenDesign = {}

screenDesign.orientation = {
    Landscape = 1,              --横屏
    vertical = 2                --竖屏
}

screenDesign.desktopId  = {
    [108] = screenDesign.orientation.Landscape,     --西欧
    [138] = screenDesign.orientation.Landscape,     --女牛仔
    [164] = screenDesign.orientation.Landscape,     --玛雅文明
    [174] = screenDesign.orientation.Landscape,     --吸血鬼
    [177] = screenDesign.orientation.Landscape,     --神龙
    [186] = screenDesign.orientation.vertical,      --竖版埃及
    [188] = screenDesign.orientation.Landscape,     --宙斯
    [192] = screenDesign.orientation.vertical,      --袋鼠
    [194] = screenDesign.orientation.vertical,      --太空
    [220] = screenDesign.orientation.vertical,      --太阳神
    [225] = screenDesign.orientation.vertical,      --竖版森林精灵
    [230] = screenDesign.orientation.vertical,      --黄金矿工
    [231] = screenDesign.orientation.Landscape,     --横版森林精灵
    [240] = screenDesign.orientation.Landscape, 
    [244] = screenDesign.orientation.Landscape,     --犀牛
    [325] = screenDesign.orientation.Landscape,
}

screenDesign.getDesignResolution = function ()
    local orientation = screenDesign.desktopId[THEME_DESKTOP_ID]

    local size = {}
    if orientation == screenDesign.orientation.Landscape then    --横屏
        size.width = 1280
        size.height = 720
        size.orientation = screenDesign.orientation.Landscape
    else                                                         --竖屏
        size.width = 720
        size.height = 1280
        size.orientation = screenDesign.orientation.vertical
    end
    return size
end 

return screenDesign
