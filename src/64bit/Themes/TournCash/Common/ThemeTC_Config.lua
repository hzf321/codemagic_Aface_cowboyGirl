---
--- @program src 
--- @description:  
--- @author: rwb 
--- @create: 2021/05/10 12:17
---
---@program src
---@description:  theme2010 config
---@author: rwb
---@create: : 2021/02/22 19:00:00
local config = {}

local BONUS_SYMBOL = 13
local dialog_type = {
    --respin   = "respin",
    rank    = "rank",
    upgrade = "upgrade",
    --complete = "complete",
    --round    = "round",
    multi   = "multi",
    score   = "score",
    b_multi = "b_multi",
}
local fs_show_type = {
    start   = 1,
    more    = 2,
    collect = 3,
    choose  = 4,
}

config.STAGE_STEP = {
    WAIT    = 1,
    PLAY    = 2,
    FINISH  = 3,
    ALLOVER = 4
}
config.TEAM_TYPE = {
    RED  = 1,
    BLUE = 2
}

--config.SpinBoardType = {
--    Normal = 1,
--    Battle = 2,
--    Respin = 3,
--
--}

--config.SpinLayerType = {
--    Normal = 1,
--    Respin = 2,
--}
--local ReSpinStep = {
--    OFF     = 1,
--    Start   = 2,
--    Reset   = 3,
--    Over    = 4,
--    Playing = 5,
--}

--config.ReSpinStep = ReSpinStep
config.fs_show_type = fs_show_type

config.dialog_type = dialog_type

--config.baseColCnt = 5
--config.baseRowCnt = 3
--config.symbol_size = { G_CELL_WIDTH, G_CELL_HEIGHT }
--config.special_symbol = {
--    wild          = WILD,
--    collectSymbol = BONUS_SYMBOL,
--    --scatter       = SCATTER,
--    bonusSymbol   = BONUS_SYMBOL,
--    lockSymbol    = 18,
--}
--config.unlockBetList = {
--    Jackpot3 = 1, --minor
--    Collect  = 2,
--    Jackpot2 = 3, --major
--    Jackpot1 = 4, --grand
--}
config.jackpot_config = {
    width = { 400 },
    scale = { 1 },
    count = 1,
    name  = { "grand" },
    --unlock_fnt   = "theme230_jp_1.fnt",
    --lock_fnt     = "theme230_jp_2.fnt",
    --light_jp_img = "#theme230_b_jp_tip%s.png",
    --allowK = { [2010] = false },
    --jp_tip_pos   = { cc.p(0, 425), cc.p(-200, 345), cc.p(200, 345) },
    --jp_win_ani   = "animation%s_2",
    --jp_loop_ani  = "animation%s_1"
}
--config.symbol_config = {
--    ["scatter_key_list"]    = {  },
--    ["not_init_symbol_set"] = Set({
--        WILD, BONUS_SYMBOL
--    }),
--    ["notify_symbol_list"]  = Set({
--        BONUS_SYMBOL, -- scatter
--    }),
--    ["loop_symbol_list"]    = Set({
--        BONUS_SYMBOL, -- scatter
--    }),
--    ["low_symbol_list"]     = Set({
--        7, 8, 9, 10, 11, 12
--    }),
--}

config.init_config = {
    plistAnimate = {
        "image/plist/rank",
    },
}
config.collect_config = {
    collect_id      = BONUS_SYMBOL,
    fly_time        = 18 / 30,
    up_time         = 15 / 30,
    label_max_width = 102,
    label_max_scale = 1
}
config.rank_config = {
    head_frame    = {
        blue   = "#theme2010_rank_img03.png",
        red    = "#theme2010_rank_img06.png",
        purple = "#theme2010_rank_img02.png"
    },
    --flag_bg       = {
    --    blue   = "#tourncash_flag_img01.png",
    --    red    = "#tourncash_flag_img04.png",
    --    purple = "#tourncash_flag_img03.png",
    --
    --},
    rank_item     = {
        height = 120,
        width  = 180,
    },
    --battle_config = {
    --    stencil_bar = "#tourncash_ingame_bar02.png",
    --    img_bar     = "#tourncash_ingame_bar_img.png",
    --},
    --multi_img     = {
    --    "#theme2010_tip_multi_2.png",
    --    "#theme2010_tip_multi_3.png",
    --},
    team_ui       = {
        bg   = {
            normal = "#theme2010_rank_img14.png",
            red    = "#tourncash_ingame_img30.png",
            blue   = "#tourncash_ingame_img31.png",
        },
        mask = {
            red  = "#tourncash_ingame_img32.png",
            blue = "#theme2010_rank_img17.png",
        }
    }

}
config.multi_tip_config = {
    tip_desc  = "SPIN WITH X%s POINTS LEFT",
    tip_desc1 = "SPINS WITH X%s POINTS LEFT",
}

config.dialog_config = {

    [dialog_type.score] = {
        [fs_show_type.collect] = {
            bg          = {
                isAction  = true,
                stepScale = { { 0 }, { 6 / 30, 0 }, { 5 / 30, 1.2 }, { 5 / 30, 0.95 }, { 5 / 30, 1 } },
                --stepEndScale = { { 1 }, { 6 / 30, 1 }, { 4 / 30, 1.25 }, { 11 / 30, 0 } },
            },
            label_node  = {
                isAction  = true,
                stepScale = { { 0 }, { 8 / 30, 0 }, { 5 / 30, 1.12 }, { 5 / 30, 1 } },
                --stepEndScale = { { 1 }, { 8 / 30, 1 }, { 7 / 30, 1.24 }, { 7 / 30, 0 } },
            },
            label_node2 = {
                isAction  = true,
                stepScale = { { 0 }, { 10 / 30, 0 }, { 5 / 30, 1.2 }, { 5 / 30, 0.95 }, { 5 / 30, 1 } },
                --stepEndScale = { { 1 }, { 13 / 30, 1.12 }, { 6 / 30, 0 } },
            },
            font_multi  = {
                isFont = true,
            },
            maxWidth    = 230
        },

    },
    [dialog_type.multi] = {
        [fs_show_type.more] = {
            bg          = {
                name        = "dialog_multi_bg",
                startAction = { "animation", true }
            },
            label_node1 = {
                isAction  = true,
                stepScale = { { 0 }, { 1 / 30, 0.2 }, { 5 / 30, 1.1 }, { 5 / 30, 0.95 }, { 5 / 30, 1.03 }, { 5 / 30, 0.98 }, { 5 / 30, 1 } },
                --stepEndScale = { { 1 }, { 8 / 30, 1 }, { 7 / 30, 1.24 }, { 7 / 30, 0 } },
            },
            label_node2 = {
                isAction  = true,
                stepScale = { { 0 }, { 5 / 30, 0.2 }, { 6 / 30, 1.1 }, { 5 / 30, 0.95 }, { 5 / 30, 1.03 }, { 5 / 30, 0.98 }, { 5 / 30, 1 } },
                --stepEndScale = { { 1 }, { 13 / 30, 1.12 }, { 6 / 30, 0 } },
            },
            label_node3 = {
                isAction  = true,
                stepScale = { { 0 }, { 10 / 30, 0.2 }, { 6 / 30, 1.1 }, { 5 / 30, 0.95 }, { 5 / 30, 1.03 }, { 5 / 30, 0.98 }, { 5 / 30, 1 } },
                --stepEndScale = { { 1 }, { 13 / 30, 1.12 }, { 6 / 30, 0 } },
            },
            label_multi = {
                isFont = true,
            },
            spins       = {
                isFont = true,
            },
        },

    },
}
config.csb_list = {
    rank_item                          = "rank/rank_item.csb",
    rank_tip                           = "rank/rank_tip.csb",
    ["dialog_" .. dialog_type.score]   = "dialog/dialog_score.csb",
    ["dialog_" .. dialog_type.multi]   = "dialog/dialog_multi.csb",
    ["dialog_" .. dialog_type.b_multi] = "dialog/dialog_b_multi.csb",
}
config.spine_path = {
    ---base
    long_label      = "long_logo/bt_tc",
    prize_pool      = "base/jp",
    collect_receive = "base/jieshou",
    stage_bg        = "base/jsk",
    ---rank
    rank_bg         = "rank/paiming",
    rank_frame      = "rank/txk",
    rank_mask       = "rank/rank_zhezhu",
    rank_tip_bg     = "dialog/rank_tip/tishikuang",
    rank_tip_multi  = "dialog/rank_tip/x2x3",
    rank_change     = "dialog/rank/rank",
    ---collect
    collect_fly     = "item/13/spine",
    base_board      = "bg/qipanxunhuan",
    base_bg         = "bg/bg",
    ---battle
    battle_bg       = "battle/jdt",
    battle_lizi     = "battle/jdt_lizi",
    battle_lead     = "battle/lingxian",

    ---bubble
    balloon_fly     = "balloon/qiqiu",
    balloon_big_fly = "balloon/qiqiu",
    balloon_touch   = "balloon/qiqiudianji",
    --- dialog
    dialog_start    = "dialog/go/321",
    dialog_jump     = "dialog/respin/jieshou",
    dialog_multi_bg = "dialog/multi/txt_bg",

}
config.particle_path = {
    bonus_tail      = "kuangshilizi.plist",
    bonus_lizi_tail = "kuangshilizi2.plist",
}

config.audioList = {
    balloon_fly    = "audio/rank/balloon1.mp3",
    balloon_touch  = "audio/rank/balloon2.mp3",
    balloon_num    = "audio/rank/balloonnum.mp3",

    ranktop1       = "audio/rank/ranktop1.mp3",
    ranktop10      = "audio/rank/ranktop8.mp3",
    rankup         = "audio/rank/rankup.mp3",
    winscore1      = "audio/rank/winscore1.mp3",
    winscore2      = "audio/rank/winscore2.mp3",

    doubletip_in   = "audio/rank/doubletip1.mp3",
    doubletip_out  = "audio/rank/doubletip2.mp3",
    doubletip_in2  = "audio/rank/doubletip3.mp3",
    doubletip_out2 = "audio/rank/doubletip4.mp3",
    sound_num_go   = "audio/rank/countdown1.mp3",
    sound_num_10   = "audio/rank/countdown5.mp3",
    ---collect
    symbol_bonus   = "audio/base/symbol_bonus1.mp3",
    collect_fly    = "audio/base/symbol_fly.mp3",

    --- dialog
    dialog_double  = "audio/rank/dialog_double.mp3",
    dialog_double2 = "audio/rank/dialog_double2.mp3",
    dialog_double3 = "audio/rank/dialog_double3.mp3",
    dialog_mul     = "audio/base/dialog_mul.mp3",
    mul            = "audio/base/mul.mp3",
    rollnum        = "audio/base/rollnum.mp3",

    second_1       = "audio/second/1.mp3",
    second_2       = "audio/second/2.mp3",
    second_3       = "audio/second/3.mp3",
    second_4       = "audio/second/4.mp3",
    second_5       = "audio/second/5.mp3",
    second_6       = "audio/second/6.mp3",
    second_7       = "audio/second/7.mp3",
    second_8       = "audio/second/8.mp3",
    second_9       = "audio/second/9.mp3",
    second_10      = "audio/second/10.mp3",
}
config.all_img_path = {
    { 2, "theme_tourn_cash/font/tourncash_dialog_fnt13.png" },
    { 2, "theme_tourn_cash/font/tourncash_ingame_fnt01.png" },
    { 2, "theme_tourn_cash/font/tourncash_ingame_fnt02.png" },
    { 2, "theme_tourn_cash/font/tourncash_ingame_fnt03.png" },
    { 2, "theme_tourn_cash/font/tourncash_ingame_fnt04.png" },
    { 2, "theme_tourn_cash/font/tourncash_ingame_fnt07.png" },
    { 2, "theme_tourn_cash/font/tourncash_ingame_fnt08.png" },
    { 2, "theme_tourn_cash/font/tourncash_ingame_fnt09.png" },
    { 2, "theme_tourn_cash/font/tourncash_ingame_fnt10.png" },
    { 2, "theme_tourn_cash/font/tourncash_ingame_fnt11.png" },
    { 2, "theme_tourn_cash/font/tourncash_ingame_fnt12.png" },
    { 2, "theme_tourn_cash/font/tourncash_ingame_fnt13.png" },
    { 2, "theme_tourn_cash/font/tourncash_ingame_fnt14.png" },
    { 2, "theme_tourn_cash/font/tourncash_ingame_fnt16.png" },
    { 2, "theme_tourn_cash/font/tourncash_ingame_theme_fnt01.png" },
    { 2, "theme_tourn_cash/font/tourncash_rank_fnt03.png" },
    { 2, "theme_tourn_cash/image/bg/theme2010_ingame_bg01.png" },
    { 2, "theme_tourn_cash/image/bg/theme2010_ingame_bg03.png" },
    { 2, "theme_tourn_cash/image/bg/theme2010_ingame_bg04.png" },
    { 2, "theme_tourn_cash/image/plist/dialog.png" },
    { 2, "theme_tourn_cash/image/plist/rank.png" },
    { 2, "theme_tourn_cash/spine/balloon/qiqiu.png" },
    { 2, "theme_tourn_cash/spine/balloon/qiqiudianji.png" },
    { 2, "theme_tourn_cash/spine/base/i.png" },
    { 2, "theme_tourn_cash/spine/base/jieshou.png" },
    { 2, "theme_tourn_cash/spine/base/jp.png" },
    { 2, "theme_tourn_cash/spine/base/jsk.png" },
    { 2, "theme_tourn_cash/spine/battle/jdt.png" },
    { 2, "theme_tourn_cash/spine/battle/jdt_lizi.png" },
    { 2, "theme_tourn_cash/spine/battle/lingxian.png" },
    { 2, "theme_tourn_cash/spine/bg/bg.png" },
    { 2, "theme_tourn_cash/spine/dialog/go/321.png" },
    { 2, "theme_tourn_cash/spine/dialog/multi/txt_bg.png" },
    { 2, "theme_tourn_cash/spine/dialog/rank/rank.png" },
    { 2, "theme_tourn_cash/spine/dialog/rank_tip/tishikuang.png" },
    { 2, "theme_tourn_cash/spine/dialog/rank_tip/x2x3.png" },
    { 2, "theme_tourn_cash/spine/long_logo/bt_tc.png" },
    { 2, "theme_tourn_cash/spine/paytable/spine/back_to_game01.png" },
    { 2, "theme_tourn_cash/spine/rank/paiming.png" },
    { 2, "theme_tourn_cash/spine/rank/rank_zhezhu.png" },
    { 2, "theme_tourn_cash/spine/rank/txk.png" },
}

return config
