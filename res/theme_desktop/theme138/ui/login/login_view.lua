return 
{
    {
        plist = {
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_play",
            },
            {
                path = "root.btn_google",
            },
            {
                path = "root.btn_googleout",
            },
        },
        name = "login_view",
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
                    width = 1560,
                    height = 720,
                },
                type = "BLSprite",
                name = "login_bg",
                texture = "theme138/login/textures/login_bg.png",
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme138/login/spines/mist/Tongyong_baowu",
                },
                content_size = {
                    width = 1448.73,
                    height = 603.7,
                },
                type = "BLSpine",
                name = "mist",
            },
            {
                content_size = {
                    width = 510,
                    height = 705,
                },
                type = "BLSprite",
                name = "login_man",
                texture = "theme138/login/textures/login_man.png",
                position = {
                    y = -9.0,
                    x = 0.0,
                    z = 0,
                },
            },
            {
                name = "btn_play",
                texture_disable = "theme138/login/textures/btn_img.png",
                content_size = {
                    width = 410,
                    height = 101,
                },
                texture_normal = "theme138/login/textures/btn_img.png",
                texture_down = "theme138/login/textures/btn_img.png",
                position = {
                    y = -181.946,
                    x = 0.0,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 12,
            },
            {
                spine = {
                    defaultSkin = "default",
                    isLoop = true,
                    animation = "animation",
                    name = "theme138/login/spines/star/Tongyong_xingxing",
                },
                content_size = {
                    width = 270.5,
                    height = 270.5,
                },
                type = "BLSpine",
                name = "starAnim",
                position = {
                    y = 269.311,
                    x = -32.341,
                    z = 0,
                },
            },
            {
                name = "btn_google",
                texture_disable = "theme138/login/textures/signin.png",
                content_size = {
                    width = 410,
                    height = 101,
                },
                texture_normal = "theme138/login/textures/signin.png",
                texture_down = "theme138/login/textures/signin.png",
                position = {
                    y = -268.0,
                    x = 0.0,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 22,
            },
            {
                name = "btn_googleout",
                texture_disable = "theme138/login/textures/signout.png",
                content_size = {
                    width = 410,
                    height = 101,
                },
                texture_normal = "theme138/login/textures/signout.png",
                texture_down = "theme138/login/textures/signout.png",
                position = {
                    y = -268.0,
                    x = 0.0,
                    z = 0,
                },
                type = "BLButton",
                children = {
                },
                target = 29,
            },
        },
    },
}