return 
{
    {
        plist = {
            "theme138/header_footer/packs/header.plist",
            "theme138/setting/packs/setting.plist",
        },
        controllerList = {
        },
        buttonList = {
            {
                path = "root.btn_close",
            },
            {
                path = "root.contrl_node.music_node.btn_music",
            },
            {
                path = "root.contrl_node.sound_node.btn_sound",
            },
            {
                path = "root.contrl_node.btn_gamerule",
            },
        },
        name = "setting_pop_v",
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
                scale = {
                    y = 200,
                    x = 300,
                },
                name = "btn_close",
                texture_disable = "commonpics/kong.png",
                content_size = {
                    width = 10,
                    height = 10,
                },
                texture_normal = "commonpics/kong.png",
                texture_down = "commonpics/kong.png",
                type = "BLButton",
                children = {
                },
                target = 3,
            },
            {
                position = {
                    y = 585.717,
                    x = 311.02,
                    z = 0,
                },
                type = "BLNode",
                name = "contrl_node",
                children = {
                    {
                        content_size = {
                            width = 336,
                            height = 279,
                        },
                        frame = "set_frame.png",
                        type = "BLSprite",
                        name = "bg",
                        position = {
                            y = -69.8,
                            x = -38.5,
                            z = 0,
                        },
                    },
                    {
                        position = {
                            y = -51.269,
                            x = -51.982,
                            z = 0,
                        },
                        scale = {
                            y = 0.65,
                            x = 0.65,
                        },
                        type = "BLNode",
                        name = "music_node",
                        children = {
                            {
                                content_size = {
                                    width = 171,
                                    height = 50,
                                },
                                frame = "switch_on.png",
                                type = "BLSprite",
                                name = "bg",
                                position = {
                                    y = 73.5,
                                    x = 154.5,
                                    z = 0,
                                },
                            },
                            {
                                content_size = {
                                    width = 90,
                                    height = 53,
                                },
                                frame = "switchicon.png",
                                type = "BLSprite",
                                name = "move",
                                position = {
                                    y = 72.5,
                                    x = 204.339,
                                    z = 0,
                                },
                            },
                            {
                                scale = {
                                    y = 7,
                                    x = 24,
                                },
                                name = "btn_music",
                                texture_disable = "commonpics/kong.png",
                                content_size = {
                                    width = 10,
                                    height = 10,
                                },
                                texture_normal = "commonpics/kong.png",
                                texture_down = "commonpics/kong.png",
                                position = {
                                    y = 73.667,
                                    x = 153.261,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 21,
                            },
                        },
                    },
                    {
                        position = {
                            y = -53.691,
                            x = -51.982,
                            z = 0,
                        },
                        scale = {
                            y = 0.65,
                            x = 0.65,
                        },
                        type = "BLNode",
                        name = "sound_node",
                        children = {
                            {
                                content_size = {
                                    width = 171,
                                    height = 50,
                                },
                                frame = "switch_on.png",
                                type = "BLSprite",
                                name = "bg",
                                position = {
                                    y = -43.5,
                                    x = 154.5,
                                    z = 0,
                                },
                            },
                            {
                                content_size = {
                                    width = 90,
                                    height = 53,
                                },
                                frame = "switchicon.png",
                                type = "BLSprite",
                                name = "move",
                                position = {
                                    y = -44.5,
                                    x = 204.339,
                                    z = 0,
                                },
                            },
                            {
                                scale = {
                                    y = 7,
                                    x = 24,
                                },
                                name = "btn_sound",
                                texture_disable = "commonpics/kong.png",
                                content_size = {
                                    width = 10,
                                    height = 10,
                                },
                                texture_normal = "commonpics/kong.png",
                                texture_down = "commonpics/kong.png",
                                position = {
                                    y = -42.097,
                                    x = 153.261,
                                    z = 0,
                                },
                                type = "BLButton",
                                children = {
                                },
                                target = 36,
                            },
                        },
                    },
                    {
                        scale = {
                            y = 6.9,
                            x = 29.4,
                        },
                        name = "btn_gamerule",
                        texture_disable = "commonpics/kong.png",
                        content_size = {
                            width = 10,
                            height = 10,
                        },
                        texture_normal = "commonpics/kong.png",
                        texture_down = "commonpics/kong.png",
                        position = {
                            y = -157.768,
                            x = -40.697,
                            z = 0,
                        },
                        type = "BLButton",
                        children = {
                        },
                        target = 44,
                    },
                },
            },
        },
    },
}