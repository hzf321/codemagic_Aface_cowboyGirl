return 
{
    {
        plist = {
            "theme138/header_footer/packs/footer.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.totalbet_node.btn_subbet",
            },
            {
                path = "root.totalbet_node.btn_addbet",
            },
            {
                path = "root.maxbet_node.btn_maxbet",
            },
            {
                path = "root.spin_node.auto_node.btn_disappear",
            },
            {
                path = "root.spin_node.auto_node.btn_fast",
            },
            {
                path = "root.spin_node.auto_node.btn_500",
            },
            {
                path = "root.spin_node.auto_node.btn_100",
            },
            {
                path = "root.spin_node.auto_node.btn_50",
            },
            {
                path = "root.spin_node.auto_node.btn_20",
            },
            {
                path = "root.spin_node.auto_node.btn_10",
            },
            {
                path = "root.spin_node.btn_spin",
            },
            {
                path = "root.spin_node.btn_autostop",
            },
        },
        name = "theme_footer",
    },
    {
        position = {
            y = 0,
            x = 0,
            z = 0,
        },
        type = "BLNode",
        name = "root",
        children = {
            {
                position = {
                    y = -7.239,
                    x = 0,
                    z = 0,
                },
                type = "BLNode",
                name = "bg_node",
                children = {
                    {
                        content_size = {
                            width = 1560,
                            height = 139,
                        },
                        frame = "big_back_half.png",
                        type = "BLSprite",
                        name = "right_bg",
                        position = {
                            y = 68.2,
                            x = 0.0,
                            z = 0,
                        },
                    },
                },
            },
            {
                position = {
                    y = 43.064,
                    x = -429.625,
                    z = 0,
                },
                type = "BLNode",
                name = "totalbet_node",
                children = {
                    {
                        content_size = {
                            width = 322,
                            height = 74,
                        },
                        frame = "wnzi_back.png",
                        type = "BLSprite",
                        name = "totalbet_bg",
                    },
                    {
                        content_size = {
                            width = 322,
                            height = 74,
                        },
                        frame = "wnzi_back.png",
                        type = "BLSprite",
                        name = "small_bg",
                    },
                    {
                        horizontal_align = 0,
                        font_size = 32,
                        name = "label_totalbet",
                        content_size = {
                            width = 174,
                            height = 32,
                        },
                        vertical_align = 1,
                        text = "6.000.000",
                        lineHeight = 32,
                        position = {
                            y = 6.448,
                            x = -7.935,
                            z = 0,
                        },
                        overflow = 0,
                        type = "BLBMFont",
                        font_name = "theme138/header_footer/fonts/coins_font03.fnt",
                    },
                    {
                        name = "btn_subbet",
                        frame_disable = "minus_h03.png",
                        content_size = {
                            width = 71,
                            height = 40,
                        },
                        frame_down = "minus_h02.png",
                        position = {
                            y = -1.774,
                            x = -135.563,
                            z = 0,
                        },
                        frame_normal = "minus_h01.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 18,
                    },
                    {
                        name = "btn_addbet",
                        frame_disable = "plus_h03.png",
                        content_size = {
                            width = 71,
                            height = 40,
                        },
                        frame_down = "plus_h02.png",
                        position = {
                            y = -0.753,
                            x = 134.418,
                            z = 0,
                        },
                        frame_normal = "plus_h01.png",
                        type = "BLButton",
                        children = {
                        },
                        target = 25,
                    },
                    {
                        content_size = {
                            width = 83,
                            height = 15,
                        },
                        frame = "totalbetzit.png",
                        type = "BLSprite",
                        name = "sp_totalbet",
                        position = {
                            y = -33.566,
                            x = -6.258,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 0,
                            height = 0,
                        },
                        scale = {
                            y = 5,
                            x = 5,
                        },
                        type = "BLParticle",
                        name = "max_bet_particle",
                        particle = {
                            path = "theme138/header_footer/particles/max_bet_liziwenjian01_1.plist",
                            playOnLoad = false,
                            texture = "",
                        },
                    },
                    {
                        position = {
                            y = 0,
                            x = 0,
                            z = 0,
                        },
                        type = "BLNode",
                        name = "max_bet_choosed",
                    },
                },
            },
            {
                position = {
                    y = 50.09,
                    x = 0,
                    z = 0,
                },
                type = "BLNode",
                name = "totalwin_node",
                children = {
                    {
                        name = "win_particle",
                        particle = {
                            path = "theme138/header_footer/particles/winParticle.plist",
                            playOnLoad = false,
                            texture = "",
                        },
                        content_size = {
                            width = 0,
                            height = 0,
                        },
                        visible = false,
                        position = {
                            y = 2.0,
                            x = 0.0,
                            z = 0,
                        },
                        type = "BLParticle",
                    },
                    {
                        content_size = {
                            width = 97,
                            height = 17,
                        },
                        frame = "totalwin.png",
                        type = "BLSprite",
                        name = "sp_totalwin",
                        position = {
                            y = -36.14,
                            x = 0.0,
                            z = 0,
                        },
                    },
                    {
                        position = {
                            y = 3.949,
                            x = 0,
                            z = 0,
                        },
                        type = "BLNode",
                        name = "coin_node",
                    },
                    {
                        position = {
                            y = -1.305,
                            x = 0,
                            z = 0,
                        },
                        type = "BLNode",
                        name = "win_node",
                        children = {
                            {
                                horizontal_align = 0,
                                font_size = 32,
                                name = "label_win",
                                content_size = {
                                    width = 151,
                                    height = 32,
                                },
                                vertical_align = 1,
                                text = "10,100",
                                lineHeight = 32,
                                position = {
                                    y = 17.374,
                                    x = 0.0,
                                    z = 0,
                                },
                                overflow = 0,
                                type = "BLBMFont",
                                font_name = "theme138/header_footer/fonts/winCoins.fnt",
                            },
                            {
                                horizontal_align = 0,
                                font_size = 32,
                                name = "label_win2",
                                content_size = {
                                    width = 151,
                                    height = 32,
                                },
                                vertical_align = 1,
                                text = "10,100",
                                lineHeight = 32,
                                position = {
                                    y = 17.374,
                                    x = 0.0,
                                    z = 0,
                                },
                                overflow = 0,
                                type = "BLBMFont",
                                font_name = "theme138/header_footer/fonts/winCoins.fnt",
                            },
                        },
                    },
                },
            },
            {
                position = {
                    y = 39.947,
                    x = 308.048,
                    z = 0,
                },
                type = "BLNode",
                name = "maxbet_node",
                children = {
                    {
                        target = 60,
                        frame_disable = "maxbet_03.png",
                        content_size = {
                            width = 110,
                            height = 83,
                        },
                        frame_down = "maxbet_02.png",
                        frame_normal = "maxbet_01.png",
                        type = "BLButton",
                        children = {
                        },
                        name = "btn_maxbet",
                    },
                },
            },
            {
                scale = {
                    y = 1,
                    x = 0.8,
                },
                name = "reward_effect",
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme138/header_footer/spines/reward_effect/zhousi_jianglilanlizi",
                },
                content_size = {
                    width = 711.04,
                    height = 281.98,
                },
                position = {
                    y = 38.551,
                    x = -2.15,
                    z = 0,
                },
                type = "BLSpine",
            },
            {
                position = {
                    y = 42.992,
                    x = 502.738,
                    z = 0,
                },
                type = "BLNode",
                name = "spin_node",
                children = {
                    {
                        position = {
                            y = 170,
                            x = 0,
                            z = 0,
                        },
                        children = {
                            {
                                content_size = {
                                    width = 191,
                                    height = 272,
                                },
                                frame = "freegamespin_back.png",
                                type = "BLSprite",
                                name = "auto_bg",
                            },
                            {
                                scale = {
                                    y = 120,
                                    x = 160,
                                },
                                name = "btn_disappear",
                                texture_disable = "commonpics/kong.png",
                                content_size = {
                                    width = 10,
                                    height = 10,
                                },
                                texture_normal = "commonpics/kong.png",
                                texture_down = "commonpics/kong.png",
                                position = {
                                    y = 157.0,
                                    x = 0.0,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 76,
                            },
                            {
                                name = "btn_fast",
                                frame_disable = "anxia_fast.png",
                                content_size = {
                                    width = 180,
                                    height = 44,
                                },
                                texture_normal = "theme138/header_footer/textures/kong13345.png",
                                frame_down = "anxia_fast.png",
                                position = {
                                    y = 110.0,
                                    x = 0.0,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 83,
                            },
                            {
                                name = "btn_500",
                                frame_disable = "anxia_500.png",
                                content_size = {
                                    width = 180,
                                    height = 44,
                                },
                                texture_normal = "theme138/header_footer/textures/kong13345.png",
                                frame_down = "anxia_500.png",
                                position = {
                                    y = 65.0,
                                    x = 0.0,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 90,
                            },
                            {
                                name = "btn_100",
                                frame_disable = "anxia_100.png",
                                content_size = {
                                    width = 180,
                                    height = 44,
                                },
                                texture_normal = "theme138/header_footer/textures/kong13345.png",
                                frame_down = "anxia_100.png",
                                position = {
                                    y = 20.0,
                                    x = 0.0,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 97,
                            },
                            {
                                name = "btn_50",
                                frame_disable = "anxia_50.png",
                                content_size = {
                                    width = 180,
                                    height = 44,
                                },
                                texture_normal = "theme138/header_footer/textures/kong13345.png",
                                frame_down = "anxia_50.png",
                                position = {
                                    y = -25.0,
                                    x = 0.0,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 104,
                            },
                            {
                                name = "btn_20",
                                frame_disable = "anxia_20.png",
                                content_size = {
                                    width = 180,
                                    height = 44,
                                },
                                texture_normal = "theme138/header_footer/textures/kong13345.png",
                                frame_down = "anxia_20.png",
                                position = {
                                    y = -70.0,
                                    x = 0.0,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 111,
                            },
                            {
                                name = "btn_10",
                                frame_disable = "anxia_10.png",
                                content_size = {
                                    width = 180,
                                    height = 44,
                                },
                                texture_normal = "theme138/header_footer/textures/kong13345.png",
                                frame_down = "anxia_10.png",
                                position = {
                                    y = -115.0,
                                    x = 0.0,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 118,
                            },
                        },
                        type = "BLNode",
                        name = "auto_node",
                        visible = false,
                    },
                    {
                        name = "btn_spin",
                        frame_disable = "spin_03.png",
                        content_size = {
                            width = 255,
                            height = 83,
                        },
                        frame_down = "spin_02.png",
                        position = {
                            y = -5.0,
                            x = -2.0,
                            z = 0,
                        },
                        frame_normal = "spin_01.png",
                        type = "BLButton",
                        children = {
                            {
                                scale = {
                                    y = 0.9,
                                    x = 0.9,
                                },
                                name = "label_spin",
                                content_size = {
                                    width = 94,
                                    height = 32,
                                },
                                frame = "SPIN.png",
                                position = {
                                    y = 52.5,
                                    x = 104.094,
                                    z = 0,
                                },
                                type = "BLSprite",
                            },
                            {
                                content_size = {
                                    width = 136,
                                    height = 15,
                                },
                                frame = "HOLDFORAUTO.png",
                                type = "BLSprite",
                                name = "label_hold",
                                position = {
                                    y = 21.57,
                                    x = 104.594,
                                    z = 0,
                                },
                            },
                            {
                                scale = {
                                    y = 0.9,
                                    x = 0.9,
                                },
                                name = "label_stop",
                                content_size = {
                                    width = 106,
                                    height = 32,
                                },
                                frame = "STOP.png",
                                position = {
                                    y = 52.5,
                                    x = 104.094,
                                    z = 0,
                                },
                                type = "BLSprite",
                            },
                        },
                        target = 126,
                    },
                    {
                        name = "btn_autostop",
                        frame_disable = "spin_03.png",
                        content_size = {
                            width = 255,
                            height = 83,
                        },
                        frame_down = "spin_02.png",
                        position = {
                            y = -5.0,
                            x = -2.0,
                            z = 0,
                        },
                        frame_normal = "spin_01.png",
                        type = "BLButton",
                        children = {
                            {
                                scale = {
                                    y = 0.9,
                                    x = 0.9,
                                },
                                name = "label_stop",
                                content_size = {
                                    width = 106,
                                    height = 32,
                                },
                                frame = "STOP.png",
                                position = {
                                    y = 49.976,
                                    x = 104.094,
                                    z = 0,
                                },
                                type = "BLSprite",
                            },
                            {
                                scale = {
                                    y = 0.9,
                                    x = 0.9,
                                },
                                name = "label_stopfast",
                                content_size = {
                                    width = 106,
                                    height = 32,
                                },
                                frame = "STOP.png",
                                position = {
                                    y = 42.589,
                                    x = 104.094,
                                    z = 0,
                                },
                                type = "BLSprite",
                            },
                            {
                                horizontal_align = 0,
                                font_size = 32,
                                name = "label_normal",
                                content_size = {
                                    width = 25,
                                    height = 32,
                                },
                                vertical_align = 0,
                                text = "09",
                                lineHeight = 32,
                                position = {
                                    y = 22.725,
                                    x = 104.094,
                                    z = 0,
                                },
                                overflow = 0,
                                type = "BLBMFont",
                                font_name = "theme138/header_footer/fonts/auto_fnt01.fnt",
                            },
                            {
                                horizontal_align = 0,
                                font_size = 32,
                                name = "label_pressed",
                                content_size = {
                                    width = 25,
                                    height = 32,
                                },
                                vertical_align = 0,
                                text = "09",
                                lineHeight = 32,
                                position = {
                                    y = 22.725,
                                    x = 104.094,
                                    z = 0,
                                },
                                overflow = 0,
                                type = "BLBMFont",
                                font_name = "theme138/header_footer/fonts/auto_fnt01.fnt",
                            },
                        },
                        target = 142,
                    },
                },
            },
        },
    },
}