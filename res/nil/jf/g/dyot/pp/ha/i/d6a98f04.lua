return 
{
    {
        plist = {
        },
        controllerList = {
        },
        buttonList = {
        },
        name = "lobby_view",
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
                    y = 0,
                    x = 0,
                    z = 0,
                },
                type = "BLNode",
                name = "bg_node",
                children = {
                    {
                        position = {
                            y = 0,
                            x = 0,
                            z = 0,
                        },
                        type = "BLNode",
                        name = "bg_temp",
                        children = {
                            {
                                content_size = {
                                    width = 1560,
                                    height = 720,
                                },
                                type = "BLSprite",
                                name = "bg_2",
                                texture = "theme138/lobby/textures/bg2.png",
                                position = {
                                    y = 0.0,
                                    x = 1560.0,
                                    z = 0,
                                },
                            },
                            {
                                content_size = {
                                    width = 1560,
                                    height = 720,
                                },
                                type = "BLSprite",
                                name = "bg_1",
                                texture = "theme138/lobby/textures/bg1.png",
                                children = {
                                    {
                                        content_size = {
                                            width = 510,
                                            height = 705,
                                        },
                                        type = "BLSprite",
                                        name = "man",
                                        texture = "theme138/login/textures/login_man.png",
                                        position = {
                                            y = 360.0,
                                            x = 668.893,
                                            z = 0,
                                        },
                                    },
                                },
                            },
                        },
                    },
                    {
                        name = "lobby_bg",
                        content_size = {
                            width = 1560,
                            height = 720,
                        },
                        texture = "theme138/lobby/textures/bg3.png",
                        position = {
                            y = 0.0,
                            x = 3120.0,
                            z = 0,
                        },
                        type = "BLSprite",
                        children = {
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
                                position = {
                                    y = 360.0,
                                    x = 780.0,
                                    z = 0,
                                },
                            },
                        },
                    },
                },
            },
            {
                content_size = {
                    width = 1280,
                    height = 720,
                },
                type = "BLScrollView",
                name = "theme_sv",
                scrollView = {
                    viewSize = {
                        width = 220,
                        height = 400,
                    },
                    direction = 0,
                    inertia = true,
                    elastic = true,
                },
            },
        },
    },
}