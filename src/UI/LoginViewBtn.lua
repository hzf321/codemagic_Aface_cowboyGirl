
local function getPic(name)
    return "loading/"..name
end

------------------ login view btn Node ----------------------
LoginViewBtnNode = class("LoginViewBtnNode", function ( ... ) return cc.Node:create() end)

function LoginViewBtnNode:ctor()
    self.isChinese = LanguageController:getInstance():getLanguageKey() == "Chinese"

    self.isNewUser = false
    if UserGuideControl:getInstance() and UserGuideControl:getInstance():getFreeCoins() > 0 then
        self.isNewUser = true
    end

    LoginControl:getInstance():onShowUserLoginButton()
    local function onFacebookConnect(sender,eventType)
        -- if eventType == ccui.TouchEventType.began then
        --     bole.playMusic("03_layer_open")
        -- else
        if eventType == ccui.TouchEventType.ended then
            bole.playMusic("03_layer_open")
            local function connected( ... )
                LoginControl:getInstance():facebookLoggedIn()
            end 
            LoginControl:getInstance():onFacebookClick()
            Facebook:getInstance():login(connected)
        end
    end

    local function  onHuaweiLogin( sender,eventType )
        -- if eventType == ccui.TouchEventType.began then
        --     bole.playMusic("03_layer_open")
        -- else
        if eventType == ccui.TouchEventType.ended then
            bole.playMusic("03_layer_open")
            local function connected( ... )
                LoginControl:getInstance():hmsLoggedIn()
            end 
            LoginControl:getInstance():onHuaiweiClick()
            HMS:getInstance():login(connected)
        end
    end

    local function onAppleLogin( sender,eventType )
        -- if eventType == ccui.TouchEventType.began then
        --     bole.playMusic("03_layer_open")
        -- else
        if eventType == ccui.TouchEventType.ended then
            bole.playMusic("03_layer_open")
            local function connected( ... )
                LoginControl:getInstance():AppleLoggedIn()
            end 
            LoginControl:getInstance():onAppleClick()
            PluginCommon:getInstance():signWithApple(connected)
        end
    end

    local function  onGuestLogin( sender,eventType )
        -- if eventType == ccui.TouchEventType.began then
        --     bole.playMusic("03_layer_open")
        -- else
        if eventType == ccui.TouchEventType.ended then
            bole.playMusic("03_layer_open")
            LoginControl:getInstance():onGuestClick()
            LoginControl:getInstance():rejectFacebookLogin()
            sender:setTouchEnabled(false)

            libMM.setIntegerForKey("UserGuide_login", math.floor(bole.getServerTime() / 1000))
        end
    end

    local function  onNewUserLogin( sender,eventType )
        -- if eventType == ccui.TouchEventType.began then
        --     bole.playMusic("03_layer_open")
        -- else
        if eventType == ccui.TouchEventType.ended then
            bole.playMusic("03_layer_open")
            LoginControl:getInstance():onNewUserClick()
            LoginControl:getInstance():rejectFacebookLogin()
            sender:setTouchEnabled(false)

            libMM.setIntegerForKey("UserGuide_login", math.floor(bole.getServerTime() / 1000))
        end
    end

    self.loginNode = cc.Node:create()
    self:addChild(self.loginNode)

    local tips = cc.Sprite:create(getPic("facebook_tips.png"))
    if tips then
        tips:setName("facebook_tips")
        tips:setPositionY(-329)
        tips:setPositionX(self.isChinese and 0 or 10)
        self.loginNode:addChild(tips)

        local function privacyFunc(sender, eventType)
            if eventType == ccui.TouchEventType.began then
                bole.playMusic("03_layer_open")
            elseif eventType == ccui.TouchEventType.ended then
                LoginControl:getInstance():openPrivacyPolicyUrl()
            end
        end
        local btn_privacy = self:newButton(getPic("loading_btn13.png"), getPic("loading_btn14.png"))
        btn_privacy:setName("btn_privacy")
        btn_privacy:setPosition(self.isChinese and cc.p(131, -330) or cc.p(270, -341))
        self.loginNode:addChild(btn_privacy)
        btn_privacy:setTouchEnabled(true)
        btn_privacy:addTouchEventListener(privacyFunc)

        local function serviceFunc(sender, eventType)
            if eventType == ccui.TouchEventType.began then
                bole.playMusic("03_layer_open")
            elseif eventType == ccui.TouchEventType.ended then
                LoginControl:getInstance():openTermsOfServiceUrl()
            end
        end
        local btn_service = self:newButton(getPic("loading_btn11.png"), getPic("loading_btn12.png"))
        btn_service:setName("btn_service")
        btn_service:setPosition(self.isChinese and cc.p(364, -330) or cc.p(-245, -341))
        self.loginNode:addChild(btn_service)
        btn_service:setTouchEnabled(true)
        btn_service:addTouchEventListener(serviceFunc)
        
    end

    -- 是否是审核模式
    -- if IS_CHECK then
    --     -- self.processNode:setVisible(false)

    --     local pos = cc.p(0, -265)9+
    --     self.btn = self:newButton(getPic("login_new_user_btn1.png"), getPic("login_new_user_btn2.png"))
    --     self.loginNode:addChild(self.btn)
    --     self.btn:setPosition(pos)
    --     self.btn:addTouchEventListener(onGuestLogin)
    --     return
    -- end

    local fb_login_before = Facebook:getInstance():hasLoginBefore() 

    local fb_path = (fb_login_before and "loadbt_facebook_ng" or "loadbt_facebook")

    local btn_posy = -263
    local fb_position = cc.p(50, btn_posy)
    if Config.platform == "android" or Config.platform == "amazon" then
        fb_position = cc.p(-135, btn_posy)
    end
    self.fbButton = self:newButton(getPic(fb_path .. ".png"),getPic(fb_path .. "02.png"))
    self.loginNode:addChild(self.fbButton)
    self.fbButton:setPosition(fb_position)
    self.fbButton:setTouchEnabled(true)
    self.fbButton:addTouchEventListener(onFacebookConnect)
    self.fbButton:setVisible(not self.isNewUser)

    local later_position = cc.p(325, btn_posy)
    if Config.platform == "android" or Config.platform == "amazon" then
        later_position = cc.p(168, btn_posy)
    end
    self.guestButton = self:newButton(getPic("loadbt_denglu.png"),getPic("loadbt_denglu02.png"))
    self.loginNode:addChild(self.guestButton)
    self.guestButton:setPosition(later_position)
    self.guestButton:addTouchEventListener(onGuestLogin)
    self.guestButton:setVisible(not self.isNewUser)

    if Config.platform == "huawei" and not self.isNewUser then
        self.huaweiButton = self:newButton(getPic("loadbt_huawei.png"),getPic("loadbt_huawei02.png"))
        self.loginNode:addChild(self.huaweiButton)
        self.huaweiButton:setPosition(-275, btn_posy)
        self.huaweiButton:addTouchEventListener(onHuaweiLogin)
    end

    if PluginCommon:getInstance():isAppleLoginAvailable() and not self.isNewUser then
        self.appleButton = self:newButton(getPic("loading_apple_btn01.png"),getPic("loading_apple_btn02.png"))
        self.loginNode:addChild(self.appleButton)
        self.appleButton:setPosition(-300, btn_posy)
        self.appleButton:addTouchEventListener(onAppleLogin)
    end

    if self.isNewUser then
        self.newUserButton = self:newButton(getPic("login_new_user_btn1.png"), getPic("login_new_user_btn2.png"))
        self.loginNode:addChild(self.newUserButton)
        self.newUserButton:setPosition(0, btn_posy + 5)
        self.newUserButton:addTouchEventListener(onNewUserLogin)

        local layer = cc.LayerColor:create( cc.c4b(0, 0, 0, 0))
        self.loginNode:addChild(layer, 1000)
        local listener = cc.EventListenerTouchOneByOne:create()
        listener:registerScriptHandler(function(touch, event)
            local location = touch:getLocation()
            -- print("zhf location ",location.x,location.y, User:getInstance().user_id)
            bole.send_codeInfo(Splunk_Type.ACTION, {current = "touch",position="loadind", pX = location.x, pY = location.y}, false)
            return false
        end,cc.Handler.EVENT_TOUCH_BEGAN)
        self.loginNode:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, layer)
    end
end

function LoginViewBtnNode:newButton(img1, img2, img3 )
    local button = ccui.Button:create()
    button:setContentSize(1000,3000)
    img2 = img2 or ""
    img3 = img3 or ""
    button:loadTextures(img1,img2, img3)
    return button
end