return 
{
    {
        plist = {
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
                path = "root.btn_privacy",
            },
            {
                path = "root.btn_service",
            },
        },
        name = "setting_pop",
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
                    width = 811,
                    height = 557,
                },
                frame = "prize_wholebg.png",
                type = "BLSprite",
                name = "bg",
                position = {
                    y = -5.0,
                    x = -11.0,
                    z = 0,
                },
            },
            {
                content_size = {
                    width = 199,
                    height = 34,
                },
                frame = "settings_tittle.png",
                type = "BLSprite",
                name = "sp_title",
                position = {
                    y = 226.393,
                    x = -15.708,
                    z = 0,
                },
            },
            {
                name = "btn_close",
                frame_disable = "delete_btn.png",
                content_size = {
                    width = 70,
                    height = 70,
                },
                frame_down = "delete_btn.png",
                position = {
                    y = 209.712,
                    x = 373.376,
                    z = 0,
                },
                frame_normal = "delete_btn.png",
                type = "BLButton",
                children = {
                },
                target = 9,
            },
            {
                position = {
                    y = 0,
                    x = 0,
                    z = 0,
                },
                type = "BLNode",
                name = "contrl_node",
                children = {
                    {
                        position = {
                            y = 0,
                            x = 0,
                            z = 0,
                        },
                        type = "BLNode",
                        name = "music_node",
                        children = {
                            {
                                content_size = {
                                    width = 213,
                                    height = 68,
                                },
                                frame = "text_music.png",
                                type = "BLSprite",
                                name = "text_music",
                                position = {
                                    y = 74.5,
                                    x = -204.0,
                                    z = 0,
                                },
                            },
                            {
                                content_size = {
                                    width = 172,
                                    height = 51,
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
                                    y = 71.5,
                                    x = 154.921,
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
                                target = 27,
                            },
                        },
                    },
                    {
                        position = {
                            y = 0,
                            x = 0,
                            z = 0,
                        },
                        type = "BLNode",
                        name = "sound_node",
                        children = {
                            {
                                content_size = {
                                    width = 245,
                                    height = 50,
                                },
                                frame = "text_sounds.png",
                                type = "BLSprite",
                                name = "text_sound",
                                position = {
                                    y = -46.0,
                                    x = -187.0,
                                    z = 0,
                                },
                            },
                            {
                                content_size = {
                                    width = 172,
                                    height = 51,
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
                                    y = -45.5,
                                    x = 213.5,
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
                                target = 45,
                            },
                        },
                    },
                },
            },
            {
                name = "btn_privacy",
                frame_disable = "text_privacy policy.png",
                content_size = {
                    width = 204,
                    height = 33,
                },
                frame_down = "text_privacy policy.png",
                position = {
                    y = -179.956,
                    x = -182.0,
                    z = 0,
                },
                frame_normal = "text_privacy policy.png",
                type = "BLButton",
                children = {
                },
                target = 54,
            },
            {
                name = "btn_service",
                frame_disable = "text_terms of service.png",
                content_size = {
                    width = 233,
                    height = 33,
                },
                frame_down = "text_terms of service.png",
                position = {
                    y = -179.956,
                    x = 174.5,
                    z = 0,
                },
                frame_normal = "text_terms of service.png",
                type = "BLButton",
                children = {
                },
                target = 61,
            },
        },
    },
}