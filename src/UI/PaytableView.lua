
------------------------------------------------------------------------------------------------------------

local PaytableView = class("PaytableView", CCSNode)
---@param ctl
---@param page:指定打开某一页没有的话默认是1
function PaytableView:ctor( ctl, page )
    self.ctl        = ctl
    self.firstOpenPage = page
    self.cacheIndex = 0
    self.csb        = self.ctl.theme:getPic("csb/paytable.csb")
    CCSNode.ctor(self, self.csb)
    if PAD_TAG then
        self:setScale(0.9)
        self:setPositionY(0 - MARGIN_H/2 - 20)
    end
    self:initLayout()
end
function PaytableView:initLayout( ... )  -- 初始化各个节点
    self.root     = self.node:getChildByName("root")
    self.btnRoot   = self.root:getChildByName("btn_root")
    self.backNode  = self.btnRoot:getChildByName("node_back")
    self.btnBack   = self.backNode:getChildByName("btn_back")
    self.leftNode  = self.btnRoot:getChildByName("node_left")
    self.btnLeft   = self.leftNode:getChildByName("btn_left")
    self.rightNode = self.btnRoot:getChildByName("node_right")
    self.btnRight  = self.rightNode:getChildByName("btn_right")     
    self.spineNode = self.btnRoot:getChildByName("spine_node")
    if self.spineNode then
        self.spineNode:setVisible(false)
	end
    
    self.index = 1
   if SHRINKSCALE_H < 1 then
        local scale = bole.getAdaptScale(self.ctl.theme.isPortrait)
        self.btnRoot:setScale(scale)
    end
    self.pageRoot  = self.root:getChildByName("page_root")
    self.pageList  = {}
    self.pageCnt   = 0
    self.curPage   = 1
    local pageWith = FRAME_WIDTH
    if not self.ctl.theme.isPortrait then
        local scale = bole.getAdaptScale(self.ctl.theme.isPortrait)
        if pageWith <1560*scale then
            pageWith = 1560*scale
        end
    end
    self.pageWidth = self.ctl.theme.isPortrait and 720 or pageWith

    local front_page = self.pageRoot:getChildByName("page_front_1")
    if false and front_page then
        self.pageList[1] = front_page
        self.pageCnt   = 1
        if SHRINKSCALE_H < 1 then
            local scale = bole.getAdaptScale(self.ctl.theme.isPortrait)
            self.pageList[1]:setScale(scale)

            if self.ctl.theme.isPortrait then 
                local bg = self.pageList[1]:getChildByName("bg")
                bg:setScaleX(bg:getScaleX()/(scale))
            end
        end
        -- if not self.ctl.theme.isPortrait then 
            self.pageList[1]:setPositionX(0)
        -- end
        local desc_spine = front_page:getChildByName("desc_spine")
        if desc_spine and self.ctl.theme.gameRuleGMConfig and #self.ctl.theme.gameRuleGMConfig > 0  then
            desc_spine:removeAllChildren()
            for key,item in pairs( self.ctl.theme.gameRuleGMConfig) do
                local spineFile = self.ctl.theme:getPic(item)
                local _,s = bole.addSpineAnimation(desc_spine,nil,spineFile,cc.p(0,0),"animation",nil,nil,nil,true,true)
            end
        end
    elseif front_page then
        front_page:setVisible(false)
    end
    local startPageId = 0
    for i = 1, 100 do
        local temp_index = #self.pageList + 1
        startPageId = startPageId + 1
        self.pageList[#self.pageList + 1] = self.pageRoot:getChildByName("page_"..i)
        if not self.pageList[temp_index] then
            break
        elseif self.ctl.hideGameRuleList and self.ctl.hideGameRuleList[startPageId] then
            local pageNode = table.remove(self.pageList, #self.pageList)
            pageNode:setVisible(false)
        else
            self.pageCnt = self.pageCnt + 1

            if SHRINKSCALE_H < 1 then
                local scale = bole.getAdaptScale(self.ctl.theme.isPortrait)
                self.pageList[#self.pageList]:setScale(scale)

                if self.ctl.theme.isPortrait then 
                    local bg = self.pageList[#self.pageList]:getChildByName("bg")
                    if bole.isValidNode(bg) then 
                        bg:setScaleX(bg:getScaleX()/(scale))
                    end
                end
            end
            -- if not self.ctl.theme.isPortrait then
                self.pageList[#self.pageList]:setPositionX((#self.pageList-1)*self.pageWidth) --   
            -- end

            -- 自动填充muti 的操作
            local muti_node = self.pageList[#self.pageList]:getChildByName("muti_node")
            if muti_node then 
                local value -- local value = ThemeMuti[self.ctl.theme.themeid]
                if self.ctl.getPayMulti then 
                    value = self.ctl:getPayMulti()
                end
                if not value then 
                    value = ThemeMuti[self.ctl.theme.themeid]
                end

                for k,v in pairs(muti_node:getChildren()) do
                    local key = v:getName()
                    if value and value[key] then
                        for k2,v2 in pairs(v:getChildren()) do 
                            if value[key][k2] then
                                v2:setString(value[key][k2])
                            end
                        end
                    end
                end
            end

        end
    end

    self.page_count = #self.pageList
    self.currentPage = self.pageList[1]
    self.isMoved = true 
    if #self.pageList >= 2 then
        self.nextPage = self.pageList[2]
    end
    if self.firstOpenPage then
        local showPage = self.firstOpenPage

            if ActivityCenterControl:getInstance():isMasterTheme(self.ctl.theme.themeid) and front_page then
                showPage = showPage +1
            end
        if showPage< self.page_count then
            self.index = showPage
            self.firstOpenPage = showPage
            self:updateFirstPage()
        end

    end

    self.labelsTable = nil
    if self.spineNode then
        local spinePath = self.ctl.theme:getPic("spine/paytable/spine/back_to_game01")
        local skeleton = sp.SkeletonAnimation:create(spinePath..".json", spinePath..".atlas", 1)
        skeleton:setAnimation(0, "animation", true)
        self.spineNode:addChild(skeleton, 1)
    end
end
function PaytableView:updateFirstPage()

    local firstPage = self.pageList[self.index]
    self.currentPage = firstPage
    for key = 1,self.page_count do
       local  posX = -self.pageWidth* (self.index- key)
        self.pageList[key]:setPositionX(posX)
    end
    if self.index< self.page_count then
        self.nextPage = self.pageList[self.index+1]
    else
        self.nextPage = self.pageList[1]
    end
end
function PaytableView:show( ... )
    self:showActions()

    if self.ctl.theme.isPortrait then
        self:setPosition(cc.p(FRAME_HEIGHT/2,FRAME_WIDTH/2))
    else
        self:setPosition(cc.p(FRAME_WIDTH/2,FRAME_HEIGHT/2))
    end
    bole.scene:addChild(self)

    -- self.ctl.curScene:addToTop(self) -- self.ctl.curScene:addToFooterHeader(self, 99999)
    self:setVisible(false)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function()
        self:setVisible(true)
        self:runTimeLine(0, 25, false)    
    end), cc.DelayTime:create(0.5), cc.CallFunc:create(function()
        self:initEvent()
    end)))
end
function PaytableView:moveFunc(index,pageWidth)
    if self.page_count < 2 then return end
    self.nextPage = self.pageList[index]
    self.nextPage:setPosition(cc.p(self.currentPage:getPositionX() - pageWidth, self.currentPage:getPositionY()))-- 下一张图片设置在当前图片的位置
    self.isMoved = false
    self.nextPage:runAction(cc.Sequence:create(
        cc.MoveBy:create(0.5, cc.p(pageWidth,0)), -- 花两秒时间，向右移动145个像素
        cc.CallFunc:create(function() self.isMoved = true end) -- 设置标志位，说明已经移动完成
        ))

    local pic = self.currentPage -- 保存下当前的图片
    pic:runAction(cc.MoveBy:create(0.5,cc.p(pageWidth,0)))
    self.currentPage = self.nextPage -- 保存已经替换的当前图片
    self.nextPage = pic
end
function PaytableView:initEvent( ... )
    local function moveLeft()
        if self.isMoved then
            bole.playSounds("click")
            bole.playMusic("info/info_page_scroll", nil, nil, "sounds/")
            self.index = self.index + 1
            if self.index == self.page_count+1 then 
                self.index = 1
            end
            if self.moveFunc then
                self:moveFunc(self.index,-self.pageWidth)
            end
        end
    end
    local function moveRight( ... )
        if self.isMoved then
            bole.playSounds("click")
            bole.playMusic("info/info_page_scroll", nil, nil, "sounds/")
            self.index = self.index - 1
            if self.index == 0 then
                self.index = self.page_count
            end
            if self.moveFunc then
                self:moveFunc(self.index,self.pageWidth)
            end
        end
    end
    self:addTouchEvent(self.btnLeft, moveRight, -1) -- 向右滑动
    self:addTouchEvent(self.btnRight, moveLeft, 1) -- 向左滑动
    local function exit( ... )
        bole.playMusic("info/info_page_close", nil, nil, "sounds/")
        self:hide()
    end
    self:addTouchEvent(self.btnBack, exit)
    -- bole.addKeyboardEvent(self, exit, true)
end
function PaytableView:hide( ... )
    if not self.isHiding then
        bole.playSounds("click")
        self.isHiding = true
        local duaration = 25/60
        self:runTimeLine(40,65,false)
        self:runAction( cc.Sequence:create( cc.DelayTime:create(duaration), cc.RemoveSelf:create(), cc.CallFunc:create(function ( ... )
            -- 卸载 paytable 的资源
            local theme = self.ctl.theme
            self.ctl.header.isPaytableViewShowing = false
            self:hideActions(true)
            local pngList = ThemePngs[theme.themeid] -- 之后需要要确定是否需要 
            if pngList then 

                local textureCache = cc.Director:getInstance():getTextureCache()

                for k,v in pairs(pngList) do
                    if string.find(v[2], "paytable/") then
                        textureCache:removeTextureForKey(theme:getPic(v[2]))
                    end
                end
               
            end
        end)))
    end
end

return PaytableView