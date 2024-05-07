return 
{
    {
        plist = {
            "theme138/inspect/packs/inspect.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_close",
            },
            {
                path = "root.btn_close_ok",
            },
        },
        name = "inspect_ad_pop",
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
                    width = 822,
                    height = 548,
                },
                frame = "prize_wholebg.png",
                type = "BLSprite",
                name = "prize_wholebg",
            },
            {
                content_size = {
                    width = 92,
                    height = 34,
                },
                frame = "TIPS.png",
                type = "BLSprite",
                name = "TIPS",
                position = {
                    y = 220.729,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 634,
                    height = 238,
                },
                frame = "font_ad.png",
                type = "BLSprite",
                name = "font_ad",
                position = {
                    y = 32.359,
                    x = 2.247,
                    z = 0,
                },
            },
            {
                name = "btn_close",
                frame_disable = "delete_btn.png",
                content_size = {
                    width = 68,
                    height = 70,
                },
                frame_down = "delete_btn.png",
                position = {
                    y = 207.03,
                    x = 376.341,
                    z = 0,
                },
                frame_normal = "delete_btn.png",
                type = "BLButton",
                children = {
                },
                target = 12,
            },
            {
                name = "btn_close_ok",
                frame_disable = "ok_btn.png",
                content_size = {
                    width = 335,
                    height = 114,
                },
                frame_down = "ok_btn.png",
                position = {
                    y = -192.979,
                    x = 0.0,
                    z = 0,
                },
                frame_normal = "ok_btn.png",
                type = "BLButton",
                children = {
                },
                target = 18,
            },
        },
    },
}