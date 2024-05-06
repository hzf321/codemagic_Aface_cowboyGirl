---
--- @program src 
--- @description:  
--- @author: rwb 
--- @create: 2021/01/20 13:30
---
local config = {}
local machine_status = {
    start   = 1,
    current = 2,
    collect = 3
}
config.machine_status = machine_status
config.spine_path = {
    popup_window = "spine/popup_window/spine",
    btn_start    = "spine/btn_start/spine",
    btn_collect  = "spine/btn_collect/spine",
    bg_light     = "spine/bg_light/spine",
    line_kuang   = "spine/win_kuang/mini_lhj",
}
config.audioList = {
    slot_popup   = "audio/slot_popup.mp3",
    slot_spin    = "audio/slot_spin.mp3",
    slot_win     = "audio/slot_win.mp3",
    common_click = "audio/click.mp3",
}
config.theme_config = {
    pays     = {
        12500000, 100000, 62500, 30000, 37500, 30000, 20000, 10000
    },
    reelKey  = {
        102, 103, 104, 105, 106, 107, 108, 109
    },
    base_bet = 5000,
}
config.dialog_config = {
    [1] = {

    },
    [3] = {
        baseScale = 0.85,
        maxWidth  = 480
    }
}
return config
