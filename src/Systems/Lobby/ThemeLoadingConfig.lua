local ThemeLoadingConfig = {}

ThemeLoadingConfig.srcConfig =  -- loading_page1 全部解锁， loading_page2 部分解锁
{
    [188] = {"theme_loading/image/loading_page2.csb", "theme_loading/image/tip/loading_new2_active_takeorleave.png","#theme188_loading01_lbl.png"},
}

ThemeLoadingConfig.loading2_config = { -- logo 位置
    [2010] = { -- 使用默认图片
        logo = {
            path = "theme_loading/theme2010/loading2/bonus_loading_2010.png", 
            pos = cc.p(0, -29)
        }
    },
    [2013] = {
        logo = {
            path = "theme_loading/theme2013/loading2/bonus_loading_2013.png", 
            pos = cc.p(-4, -26)
        }
    },
    [2014] = {
        logo = {
            path = "theme_loading/theme2014/loading2/bonus_loading_2014.png", 
            pos = cc.p(-4, -26)
        }
    },
}

ThemeLoadingConfig.loading_logo_config = {
    
}

ThemeLoadingConfig.loading_bar_config = {
    [188] = {
        width      = 511,
        height     = 30,
        pos_bar    = cc.p(0, 10),
        bar_spine  = "theme_desktop/theme188/login/spines/bolt/spine"
    }
}

return ThemeLoadingConfig
