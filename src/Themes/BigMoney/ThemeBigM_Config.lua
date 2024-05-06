--[[
Author: xiongmeng
Date: 2020-11-19 16:05:16
LastEditors: xiongmeng
LastEditTime: 2020-12-24 11:58:08
Description: 
--]]
local config = {}
config.fs_show_type = {
    start = 1,
    more = 2,
    collect = 3,
}

config.csb_list = {
    dialog_free = "csb/dialog_free.csb",
    dialog_wheel = "csb/dialog_wheel.csb",
    dialog_booster = "csb/dialog_booster.csb",
    dialog_mapfree = "csb/map_free.csb",
    dialog_jp = "csb/dialog_jp.csb",
    dialog_gameMaster = "csb/master_start.csb",
}

config.dialog_config = {
    ["gamemaster"] = {
        bg         = {
            name        = "dialog_wheel",
            startAction = { "animation3", false },
            loopAction  = { "animation3_1", true },
            endAction   = { "animation3_2", false },
        },
        btn_node   = {
            isAction     = true,
            stepScale    = { { 0 }, { 18 / 30, 0 }, { 12 / 30, 1.2 }, { 10 / 30, 1 } },
            stepEndScale = { { 1 }, { 13 / 30, 1.12 }, { 6 / 30, 0 } },
        },
        btn        = {
            name    = "dialog_btn",
            aniName = "animation",
        },
    },
    ["free_start"] = {
        bg         = {
            name        = "dialog_free",
            startAction = { "animation%s", false },
            loopAction  = { "animation%s_1", true },
            endAction   = { "animation%s_2", false },
            formatname = true
        },
        label_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 3 / 30, 0 }, { 9 / 30, 1.08 }, { 7 / 30, 1 } },
            stepEndScale = { { 1 }, { 5 / 30, 1 }, { 8 / 30, 1.08 }, { 6 / 30, 0 } },

            stepFade     = { { 0 }, { 5 / 30, 0 }, { 7 / 30, 255 } },
            stepEndFade  = { { 255 }, { 13 / 30, 255 }, { 7 / 30, 0 } },    
        },
        ad_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 6 / 30, 0}, { 9 / 30, 1.08 }, { 7 / 30, 1 } },
            stepEndScale = { { 1 }, { 8 / 30, 1 }, { 7 / 30, 1.08 }, { 7 / 30, 0 } },

            stepFade     = { { 0 }, { 6 / 30, 0 }, { 7 / 30, 255 } },
            stepEndFade  = { { 255 }, { 15 / 30, 255 }, { 7 / 30, 0 } },
        },
        pig_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 6 / 30, 0}, { 9 / 30, 1.08 }, { 7 / 30, 1 } },
            stepEndScale = { { 1 }, { 8 / 30, 1 }, { 7 / 30, 1.08 }, { 7 / 30, 0 } },

            stepFade     = { { 0 }, { 6 / 30, 0 }, { 7 / 30, 255 } },
            stepEndFade  = { { 255 }, { 15 / 30, 255 }, { 7 / 30, 0 } },
        },
        btn_node   = {
            isAction     = true,
            stepScale    = { { 0 }, { 11 / 30, 0 }, { 7 / 30, 1.08 }, { 7 / 30, 1 } },
            stepEndScale = { { 1 }, { 10 / 30, 1.08 }, { 8 / 30, 0 } },
        },
        btn        = {
            name    = "dialog_btn",
            aniName = "animation",
        },
    },
    ["free_more"] = {
        bg         = {
            name        = "dialog_free",
            startAction = { "animation%s", false },
            loopAction  = { "animation%s_1", true },
            endAction   = { "animation%s_2", false },
            formatname = true
        },
        label_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 3 / 30, 0 }, { 9 / 30, 1.08 }, { 7 / 30, 1 } },
            stepEndScale = { { 1 }, { 5 / 30, 1 }, { 8 / 30, 1.08 }, { 6 / 30, 0 } },

            stepFade     = { { 0 }, { 5 / 30, 0 }, { 7 / 30, 255 } },
            stepEndFade  = { { 255 }, { 13 / 30, 255 }, { 7 / 30, 0 } },    
        },
    },
    ["free_collect"] = {
        bg         = {
            name        = "dialog_free",
            startAction = { "animation%s", false },
            loopAction  = { "animation%s_1", true },
            endAction   = { "animation%s_2", false },
            formatname = true
        },
        label_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 3 / 30, 0 }, { 9 / 30, 1.08 }, { 7 / 30, 1 } },
            stepEndScale = { { 1 }, { 5 / 30, 1 }, { 8 / 30, 1.08 }, { 6 / 30, 0 } },

            stepFade     = { { 0 }, { 5 / 30, 0 }, { 7 / 30, 255 } },
            stepEndFade  = { { 255 }, { 13 / 30, 255 }, { 7 / 30, 0 } },    
        },
        ad_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 11 / 30, 0 }, { 7 / 30, 1.08 }, { 7 / 30, 1 } },
            stepEndScale = { { 1 }, { 10 / 30, 1.08 }, { 8 / 30, 0 } },

            stepFade     = { { 0 }, { 6 / 30, 0 }, { 7 / 30, 255 } },
            stepEndFade  = { { 255 }, { 15 / 30, 255 }, { 7 / 30, 0 } },
        },
        btn_node   = {
            isAction     = true,
            stepScale    = { { 0 }, { 11 / 30, 0 }, { 7 / 30, 1.08 }, { 7 / 30, 1 } },
            stepEndScale = { { 1 }, { 10 / 30, 1.08 }, { 8 / 30, 0 } },
        },
        btn        = {
            name    = "dialog_btn",
            aniName = "animation",
        },
        maxWidth   = 505,
    },
    ["wheel_start"] = {
        bg         = {
            name        = "dialog_wheel",
            startAction = { "animation5", false },
            loopAction  = { "animation5_1", true },
            endAction   = { "animation5_2", false },
        },
        btn_node   = {
            isAction     = true,
            stepScale    = { { 0 }, { 18 / 30, 0 }, { 12 / 30, 1.2 }, { 10 / 30, 1 } },
            stepEndScale = { { 1 }, { 13 / 30, 1.12 }, { 6 / 30, 0 } },
        },
        btn        = {
            name    = "dialog_btn",
            aniName = "animation",
        },
    },
    ["wheel_collect"] = {
        bg         = {
            name        = "dialog_wheel",
            startAction = { "animation%s", false },
            loopAction  = { "animation%s_1", true },
            endAction   = { "animation%s_2", false },
            formatname = true
        },
        label_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 8 / 30, 0 }, { 7 / 30, 1.12 }, { 7 / 30, 1 } },
            stepEndScale = { { 1 }, { 8 / 30, 1 }, { 7 / 30, 1.24 }, { 7 / 30, 0 } },
            stepFade     = { { 0 }, { 5 / 30, 0 }, { 7 / 30, 255 } },
            stepEndFade  = { { 255 }, { 18 / 30, 255 }, { 7 / 30, 0 } },
        },
        label_content = {
            isAction     = true,
            stepScale    = { { 0 }, { 8 / 30, 0 }, { 7 / 30, 1.12 }, { 7 / 30, 1 } },
            stepEndScale = { { 1 }, { 8 / 30, 1 }, { 7 / 30, 1.24 }, { 7 / 30, 0 } },
            stepFade     = { { 0 }, { 5 / 30, 0 }, { 7 / 30, 255 } },
            stepEndFade  = { { 255 }, { 18 / 30, 255 }, { 7 / 30, 0 } },
        },
        btn_node   = {
            isAction     = true,
            stepScale    = { { 0 }, { 18 / 30, 0 }, { 12 / 30, 1.2 }, { 10 / 30, 1 } },
            stepEndScale = { { 1 }, { 13 / 30, 1.12 }, { 6 / 30, 0 } },
        },
        ad_node   = {
            isAction     = true,
            stepScale    = { { 0 }, { 18 / 30, 0 }, { 12 / 30, 1.2 }, { 10 / 30, 1 } },
            stepEndScale = { { 1 }, { 13 / 30, 1.12 }, { 6 / 30, 0 } },
        },
        btn        = {
            name    = "dialog_btn",
            aniName = "animation",
        },
        maxWidth   = 650,
    },
    ["map_free_start"] = {
        bg         = {
            name        = "dialog_wheel",
            startAction = { "animation%s", false },
            loopAction  = { "animation%s_1", true },
            endAction   = { "animation%s_2", false },
            formatname = true
        },
        label_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 8 / 30, 0 }, { 7 / 30, 1.12 }, { 7 / 30, 1 } },
            stepEndScale = { { 1 }, { 8 / 30, 1 }, { 7 / 30, 1.24 }, { 7 / 30, 0 } },
            stepFade     = { { 0 }, { 5 / 30, 0 }, { 7 / 30, 255 } },
            stepEndFade  = { { 255 }, { 18 / 30, 255 }, { 7 / 30, 0 } },
        },
        booster_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 8 / 30, 0 }, { 7 / 30, 1.12 }, { 7 / 30, 1 } },
            stepEndScale = { { 1 }, { 8 / 30, 1 }, { 7 / 30, 1.24 }, { 7 / 30, 0 } },
            stepFade     = { { 0 }, { 5 / 30, 0 }, { 7 / 30, 255 } },
            stepEndFade  = { { 255 }, { 18 / 30, 255 }, { 7 / 30, 0 } },
        },
        pig_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 8 / 30, 0 }, { 7 / 30, 1.12 }, { 7 / 30, 1 } },
            stepEndScale = { { 1 }, { 8 / 30, 1 }, { 7 / 30, 1.24 }, { 7 / 30, 0 } },
            stepFade     = { { 0 }, { 5 / 30, 0 }, { 7 / 30, 255 } },
            stepEndFade  = { { 255 }, { 18 / 30, 255 }, { 7 / 30, 0 } },
        },
        btn_node   = {
            isAction     = true,
            stepScale    = { { 0 }, { 18 / 30, 0 }, { 12 / 30, 1.2 }, { 10 / 30, 1 } },
            stepEndScale = { { 1 }, { 13 / 30, 1.12 }, { 6 / 30, 0 } },
        },
        btn        = {
            name    = "dialog_btn",
            aniName = "animation",
        },
    },
    ["map_free_collect"] = {
        bg         = {
            name        = "dialog_wheel",
            startAction = { "animation%s", false },
            loopAction  = { "animation%s_1", true },
            endAction   = { "animation%s_2", false },
            formatname = true
        },
        label_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 8 / 30, 0 }, { 7 / 30, 1.12 }, { 7 / 30, 1 } },
            stepEndScale = { { 1 }, { 8 / 30, 1 }, { 7 / 30, 1.24 }, { 7 / 30, 0 } },
            stepFade     = { { 0 }, { 5 / 30, 0 }, { 7 / 30, 255 } },
            stepEndFade  = { { 255 }, { 18 / 30, 255 }, { 7 / 30, 0 } },
        },
        booster_node = {
            isAction     = true,
            stepScale    = { { 0 }, { 8 / 30, 0 }, { 7 / 30, 1.12 }, { 7 / 30, 1 } },
            stepEndScale = { { 1 }, { 8 / 30, 1 }, { 7 / 30, 1.24 }, { 7 / 30, 0 } },
            stepFade     = { { 0 }, { 5 / 30, 0 }, { 7 / 30, 255 } },
            stepEndFade  = { { 255 }, { 18 / 30, 255 }, { 7 / 30, 0 } },
        },
        btn_node   = {
            isAction     = true,
            stepScale    = { { 0 }, { 18 / 30, 0 }, { 12 / 30, 1.2 }, { 10 / 30, 1 } },
            stepEndScale = { { 1 }, { 13 / 30, 1.12 }, { 6 / 30, 0 } },
        },
        btn        = {
            name    = "dialog_btn",
            aniName = "animation",
        },
        maxWidth   = 674,
    },
    ["jp_collect"] = {
        bg         = {
            name        = "dialog_jp",
            startAction = { "animation%s", false },
            loopAction  = { "animation%s_1", true },
            endAction   = { "animation%s_2", false },
            formatname = true
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
            stepScale    = { { 0 }, { 18 / 30, 0 }, { 12 / 30, 1.2 }, { 10 / 30, 1 } },
            stepEndScale = { { 1 }, { 13 / 30, 1.12 }, { 6 / 30, 0 } },
        },
        btn        = {
            name    = "dialog_btn",
            aniName = "animation",
        },
        maxWidth   = 674,
    },
    ["black_common"] = {
        stepFade     = { { 0 },  { 8 / 30, 200 } },
        stepEndFade  = { { 200 }, { 8 / 30, 0 } },
    }
}

config.spine_path = {
    dialog_free = "dialog/freetanchuang",
    dialog_wheel = "dialog/xiaozhutanchuang",
    dialog_btn   = "dialog/anniu",
    dialog_jp    = "dialog/jptanchuang",

}
return config



