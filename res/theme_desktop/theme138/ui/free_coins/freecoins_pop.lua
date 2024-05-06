return 
{
    {
        plist = {
            "theme138/ad_reward/packs/ad_reward.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_close",
            },
            {
                path = "root.btn_collect",
            },
        },
        name = "freecoins_pop",
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
                content_size = {
                    width = 927,
                    height = 656,
                },
                type = "BLSprite",
                name = "bg",
                texture = "theme138/ad_reward/texture_atlas/ad_reward/kuang_2.png",
                children = {
                    {
                        content_size = {
                            width = 419,
                            height = 73,
                        },
                        frame = "freecoin.png",
                        type = "BLSprite",
                        name = "freecoin",
                        position = {
                            y = 561.479,
                            x = 463.5,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 595,
                            height = 39,
                        },
                        frame = "freecoin_2.png",
                        type = "BLSprite",
                        name = "font1",
                        position = {
                            y = 495.225,
                            x = 463.5,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 432,
                            height = 98,
                        },
                        frame = "kuang.png",
                        type = "BLSprite",
                        name = "kuang",
                        position = {
                            y = 199.073,
                            x = 463.5,
                            z = 0,
                        },
                    },
                    {
                        content_size = {
                            width = 89,
                            height = 97,
                        },
                        frame = "coin.png",
                        type = "BLSprite",
                        name = "coin",
                        position = {
                            y = 197.14,
                            x = 273.894,
                            z = 0,
                        },
                    },
                },
            },
            {
                name = "btn_close",
                texture_disable = "theme138/ad_reward/texture_atlas/ad_reward/close.png",
                content_size = {
                    width = 68,
                    height = 70,
                },
                texture_normal = "theme138/ad_reward/texture_atlas/ad_reward/close.png",
                texture_down = "theme138/ad_reward/texture_atlas/ad_reward/close.png",
                position = {
                    y = 212.716,
                    x = 450.459,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 18,
            },
            {
                name = "btn_collect",
                frame_disable = "free_collect.png",
                content_size = {
                    width = 405,
                    height = 95,
                },
                frame_down = "free_collect.png",
                position = {
                    y = -225.205,
                    x = 2.5,
                    z = 0,
                },
                frame_normal = "free_collect.png",
                type = "BLButton",
                children = {
                },
                target = 25,
            },
            {
                horizontal_align = 0,
                font_size = 15,
                name = "label_coins",
                content_size = {
                    width = 270,
                    height = 50,
                },
                vertical_align = 0,
                text = "5.000.000",
                lineHeight = 50,
                position = {
                    y = -122.768,
                    x = 0.0,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme138/ad_reward/fonts/guide.fnt",
            },
            {
                content_size = {
                    width = 417,
                    height = 28,
                },
                frame = "freecoin_3.png",
                type = "BLSprite",
                name = "des_seconds",
                position = {
                    y = -291.365,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                horizontal_align = 1,
                font_size = 30,
                name = "label_seconds",
                content_size = {
                    width = 78.75,
                    height = 30,
                },
                vertical_align = 1,
                text = "3600",
                lineHeight = 30,
                position = {
                    y = -289.989,
                    x = 64.678,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme138/ad_reward/fonts/freeLabel.fnt",
            },
        },
    },
}