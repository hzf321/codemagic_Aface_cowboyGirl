return 
{
    {
        plist = {
            "theme138/lobby/packs/lobby.plist",
            "theme138/header_footer/packs/header.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_lock",
            },
        },
        name = "lobby_theme_lock",
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
                name = "theme_logo",
                content_size = {
                    width = 292,
                    height = 415,
                },
                frame = "rukou_2.png",
                position = {
                    y = -204.912,
                    x = 0.0,
                    z = 0,
                },
                type = "BLSprite",
                anchor = {
                    y = 0,
                    x = 0.5,
                },
            },
            {
                name = "lock_spine",
                content_size = {
                    width = 279,
                    height = 133,
                },
                frame = "lock_1.png",
                position = {
                    y = -71.616,
                    x = 2.173,
                    z = 0,
                },
                type = "BLSprite",
                children = {
                    {
                        content_size = {
                            width = 56,
                            height = 75,
                        },
                        frame = "lock_2.png",
                        type = "BLSprite",
                        name = "lock",
                        position = {
                            y = 66.5,
                            x = 139.5,
                            z = 0,
                        },
                    },
                },
            },
            {
                scale = {
                    y = 33.5,
                    x = 25,
                },
                name = "btn_lock",
                texture_disable = "commonpics/kong.png",
                content_size = {
                    width = 10,
                    height = 10,
                },
                texture_normal = "commonpics/kong.png",
                texture_down = "commonpics/kong.png",
                position = {
                    y = 0.0,
                    x = -9.0,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 12,
            },
            {
                position = {
                    y = -123.685,
                    x = 37.577,
                    z = 0,
                },
                type = "BLNode",
                name = "tip_node",
                children = {
                    {
                        content_size = {
                            width = 202,
                            height = 112,
                        },
                        frame = "unlock_4.png",
                        type = "BLSprite",
                        anchor = {
                            y = 0.5,
                            x = 0,
                        },
                        name = "tip_bg",
                    },
                    {
                        scale = {
                            y = 0.8,
                            x = 0.8,
                        },
                        name = "diamonds_logo",
                        content_size = {
                            width = 62,
                            height = 47,
                        },
                        frame = "icon_zuanshi.png",
                        position = {
                            y = -13.504,
                            x = 72.068,
                            z = 0,
                        },
                        type = "BLSprite",
                    },
                    {
                        horizontal_align = 0,
                        font_size = 32,
                        name = "label_diamonds",
                        content_size = {
                            width = 58,
                            height = 32,
                        },
                        vertical_align = 1,
                        text = "1000",
                        lineHeight = 32,
                        position = {
                            y = -15.265,
                            x = 137.998,
                            z = 0,
                        },
                        overflow = 0,
                        type = "BLBMFont",
                        font_name = "theme138/lobby/fonts/tip_num.fnt",
                    },
                },
            },
        },
    },
}