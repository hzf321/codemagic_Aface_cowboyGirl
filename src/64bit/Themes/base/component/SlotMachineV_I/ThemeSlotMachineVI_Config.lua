--[[
Author: xiongmeng
Date: 2021-03-25 18:39:37
LastEditors: xiongmeng
LastEditTime: 2021-04-26 21:32:11
Description: 
--]]
local config = {}
local machine_status = {
    start   = 1,
    current = 2,
    collect = 3
}
config.machine_status = machine_status
config.spine_path = {
    btn_common    = "spine/btn_common/spine",
    bg_light     = "spine/bg_light/spine",
    line_kuang   = "spine/win_kuang/xlhjzhongjiang",
    dialog_free  = "spine/dialog/spine",
}
config.csb_list = {
    dialog = "csb/slot_machine_v_popup.csb",
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
    ["dailog_start"] = {
        bg         = {
            name        = "dialog_free",
            startAction = { "animation2", false },
            loopAction  = { "animation2_1", true },
            endAction   = { "animation2_2", false },
        },
        btn_node   = {
            isAction     = true,
            stepScale    = { { 0 }, { 18 / 30, 0 }, { 12 / 30, 1.2 }, { 10 / 30, 1 } },
            stepEndScale = { { 1 }, { 13 / 30, 1.12 }, { 6 / 30, 0 } },
        },
        btn        = {
            name    = "btn_common",
            aniName = "animation",
        },
    },
    ["dailog_collect"] = {
        bg         = {
            name        = "dialog_free",
            startAction = { "animation1", false },
            loopAction  = { "animation1_1", true },
            endAction   = { "animation1_2", false },
        },
        label_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 8 / 30, 0 }, { 7 / 30, 1.12 }, { 7 / 30, 1 } },
            stepEndScale = { { 1 }, { 8 / 30, 1 }, { 7 / 30, 1.24 }, { 7 / 30, 0 } },

            stepFade     = { { 0 }, { 5 / 30, 0 }, { 7 / 30, 255 } },
            stepEndFade  = { { 255 }, { 18 / 30, 255 }, { 7 / 30, 0 } },
        },
        btn_node   = {
            isAction     = true,
            stepScale    = { { 0 }, { 12 / 30, 0.5 }, { 9 / 30, 1.13 }, { 10 / 30, 1 } },
            stepEndScale = { { 1 }, { 8 / 30, 1.13 }, { 8 / 30, 0.5 } },

            stepFade     = { { 0 }, { 12 / 30, 0 }, { 5 / 30, 255 } },
            stepEndFade  = { { 255 }, { 13 / 30, 255 }, { 5 / 30, 0 } },
        },
        btn        = {
            name    = "btn_common",
            aniName = "animation",
        },
        maxWidth   = 675,
    },
    ["black_common"] = {
        stepFade     = { { 0 },  { 8 / 30, 200 } },
        stepEndFade  = { { 200 }, { 8 / 30, 0 } },
    }
}
return config