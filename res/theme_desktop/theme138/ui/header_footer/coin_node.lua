return 
{
    {
        plist = {
            "theme138/header_footer/packs/header.plist",
        },
        controllerList = {
        },
        buttonList = {
        },
        name = "coin_node",
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
                    width = 218,
                    height = 43,
                },
                frame = "kuang_2.png",
                type = "BLSprite",
                name = "coin_bg",
            },
            {
                content_size = {
                    width = 50,
                    height = 52,
                },
                frame = "icon_coin.png",
                type = "BLSprite",
                name = "sp_coin",
                position = {
                    y = -1.648,
                    x = -101.312,
                    z = 0,
                },
            },
            {
                horizontal_align = 0,
                font_size = 32,
                name = "label_coins",
                content_size = {
                    width = 99,
                    height = 32,
                },
                vertical_align = 1,
                text = "12,35,46",
                lineHeight = 32,
                position = {
                    y = 3.94,
                    x = 2.431,
                    z = 0,
                },
                overflow = 0,
                type = "BLBMFont",
                font_name = "theme138/ad_reward/fonts/coin_num.fnt",
            },
            {
                name = "starAnim",
                spine = {
                    defaultSkin = "default",
                    isLoop = false,
                    animation = "",
                    name = "theme138/login/spines/star/Tongyong_xingxing",
                },
                content_size = {
                    width = 270.5,
                    height = 270.5,
                },
                visible = false,
                position = {
                    y = 9.012,
                    x = -100.819,
                    z = 0,
                },
                type = "BLSpine",
            },
        },
    },
}