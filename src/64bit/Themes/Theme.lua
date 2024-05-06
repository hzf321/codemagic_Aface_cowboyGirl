------------------------------------------------------------------------------------------------------------------------------
-- nsm
------------------------------------------------------------------------------------------------------------------------------
G_THEME_SYMBOL_TYPE = {
	NUMBER  	= 2,
	ONLINE  	= 3,
	SERIES  	= 4,
	COLCOUNT 	= 5,

}
local GameStoreType = {
	PUZZLE_I_V     = 1,
	PUZZLE_II_V    = 2,
	PUZZLE_II_H    = 3,
	SLOT_MACHINE_V = 4,
	SLOT_MACHINE_H = 5,
}
Theme = class("Theme", function() return cc.Node:create() end)

Theme.Tags = {
	Floor = 30000,
}

Theme.spinTimeConfig = { -- spin 时间控制
		[1] = 81/60,-- 欺骗 比基础spin多加的时间 --42/60 在基础spin时间为81帧的时候
		[2] = 181/60,-- 出现大象比基础spin多加的时间  -- 181/60,
		["base"] = 33/60,
		[0] = 39/60,
		["spinMinCD"] = 50/60,
}


CNT_IN_THEMECNT = 0
function Theme:ctor(id, portrait, count, maxlines, pay)
	self.game_store_version =self.game_store_version or  GameStoreType.PUZZLE_I_V
	self.themeid 	= id or 0
	self.themeResourceId = THEME_LIST[self.themeid]['resourceId']
	self.isPortrait = portrait or false -- true 是竖屏
	CNT_IN_THEMECNT = CNT_IN_THEMECNT + 1
	self.FirstFreeGameDelay = 0.5
	-- 声音配置表
	self:configAudioList()
	self:listenBaseEvent()

end
function Theme:setControl( ctl )	
	self.ctl = ctl
	self.spinActionConfig = self.spinActionConfig or {
		["spin_index"] = 2,
		["stop_index"] = 2,
		["fast_stop_index"] = 2,
	}
end
function Theme:listenBaseEvent()
	EventCenter:registerEvent(EVENTNAMES.THEME.PLAY_BACKGROUND, self.__cname, self.dealRecoverBgm, self)
end
function Theme:removeListenBaseEvent()
	EventCenter:removeEvent(EVENTNAMES.THEME.PLAY_BACKGROUND, self.__cname)
end
function Theme:setCurScene( theScene )
	self.curScene = theScene or bole.scene
end
function Theme:getCurScene( theScene )
	return self.curScene
end
function Theme:adjustThemeScale( theScaleParam )	
	self.curScene:adjustTheRootScale(1, SCREEN_RATIO*(theScaleParam or 1))
end

--for log
function Theme:setResInfo(key,value)	
	-- self.resInfo = self.resInfo or {}	
	-- self.resInfo[key] = value or 0
end

function Theme:getWinEffectPath()
	return "commonEffect/winCoinsEffects/default/"
end

function Theme:updateJackpotScale(ui)
	local maxWidth = ui.maxWidth
	if maxWidth then
		local tempWidth = ui:getContentSize().width
		local scale = maxWidth/tempWidth
		local endScale = (scale > ui.baseScale) and ui.baseScale or scale
		ui:setScale(endScale)
	end
-- body
end

--------------------------------------------------------------------------------------------------------------------------------
-- loading
-- 其中preLoadResAsync,checkResAndDeal,loadAllMusics都已经提到ThemeControl
--------------------------------------------------------------------------------------------------------------------------------
function Theme:onLoading_0( ... )
	bole.playMusic("09_game_loading", nil, nil, "sounds/")
end

function Theme:onLoading_100( ... )
	-- local duration = 0
	-- if bole.codeEnterThemeTime and type(bole.codeEnterThemeTime) == "number" then
	-- 	duration =  os.time() - bole.codeEnterThemeTime
	-- end
	-- Splunk:getInstance():send_codeInfo("inslotsuc", { t = duration})
end

function Theme:dumpTextures( ... )
    if appDebugMode then 
		local sss = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
		local sssArr = bole.splitStr(sss, "\n")
		for k,v in ipairs(sssArr) do
			print("["..k.."]  =  "..v)
		end
	end
end

function Theme:getThemeLoaddinView( ... )
	-- whj 修改逻辑 不再 去每个 主题下面去判断是否有资源
	local loadCsbFile = "theme_loading/theme" .. THEME_LIST[self.themeid]['resourceId'] .. "/loading2/theme" .. THEME_LIST[self.themeid]['loadingId'] .. "_loading.csb"
	if cc.FileUtils:getInstance():isFileExist(loadCsbFile) then
		if G_LOADING_VIEWS[self.themeid] then
			return G_LOADING_VIEWS[self.themeid].new(self)
		else
			if self.themeid == 3128 or self.themeid == 3139 or self.themeid == 3142 or self.themeid == 3137 then
				local csb = "stamps/loading/themeloading_h.csb"
				if THEME_LIST[self.themeid]['portrait'] == 1 then
					csb = "stamps/loading/themeloading_v.csb"
				end
				return G_LOADING_VIEWS["base"].new(self,csb)
			else
				return G_LOADING_VIEWS["base"].new(self)
			end
			
		end
	else
		if self.themeid == 3128 or self.themeid == 3139 or self.themeid == 3142 or self.themeid == 3137 then
			local csb = "stamps/loading/themeloading_h.csb"
			if THEME_LIST[self.themeid]['portrait'] == 1 then
				csb = "stamps/loading/themeloading_v.csb"
			end
			return G_LOADING_VIEWS["base"].new(self,csb)
		else
			return G_LOADING_VIEWS["public"].new(self)	
		end	
	end
end

function Theme:adjustThemeConfig( data )
	return data
end
function Theme:onInitConfig()
	------------------------------------------------------------
	-- 棋盘的初始化
	------------------------------------------------------------
	local boardConfig  		= self:getBoardConfig()
	self:initBoardAndReelConfig(boardConfig)
	-- self.normalKeyList, self.specialKeyList, self.pics, self.keys
	local normalSymbolList  	= self.ThemeConfig["theme_symbol_coinfig"]["normal_symbol_list"] or {}
	local specialSymbolList 	= self.ThemeConfig["theme_symbol_coinfig"]["special_symbol_list"] or {}
	local noRollSymbolList 		= self.ThemeConfig["theme_symbol_coinfig"]["no_roll_symbol_list"] or {}
	local specialSymbolConfig 	= self.ThemeConfig["theme_symbol_coinfig"]["special_symbol_config"] or {}
	local slotMachineKeyList    = self.ThemeConfig["theme_symbol_coinfig"]["slot_machine_symbol_list"] or {}

	self.RollSymbolInFreeList 	= self.ThemeConfig["theme_symbol_coinfig"]["roll_symbol_inFree_list"] or {}
	self.symbolZOrderList 		= self.ThemeConfig["theme_symbol_coinfig"]["symbol_zorder_list"] or {}
	self.symbolPosAdjustList    = self.ThemeConfig["theme_symbol_coinfig"]["symbol_pos_adjust_list"] or {}
	self:initPicsAndKeys(normalSymbolList, specialSymbolList, noRollSymbolList, specialSymbolConfig)
	self:initSlotMachineKeys(slotMachineKeyList)

	-- self.themeType, self.ThemeTypeConfig, self.lines, self.maxLine
	local themeType  		= self.ThemeConfig["theme_type"]
	local themeTypeConfig 	= self.ThemeConfig["theme_type_config"]
	self:initThemeType(themeType, themeTypeConfig)
	
end
function Theme:initPicsAndKeys( normalSymbolList, specialSymbolList, noRollSymbolList, specialSymbolConfig )
	self.pics = {}
	self.keys = {}
	for _,theSymbol in ipairs(normalSymbolList) do
		self.pics[theSymbol]  = "#theme"..self.themeResourceId.."_s_"..theSymbol..".png"
		table.insert(self.keys, theSymbol)
	end
	for _,theSymbol in ipairs(specialSymbolList) do
		self.pics[theSymbol]  = "#theme"..self.themeResourceId.."_s_"..theSymbol..".png"
		if theSymbol ~= "nil" then
			table.insert(self.keys, theSymbol)
		end
	end	
	for _,theSymbol in ipairs(noRollSymbolList) do
		self.pics[theSymbol]  = "#theme"..self.themeResourceId.."_s_"..theSymbol..".png"
	end		
	self.normalKeyList  	= normalSymbolList
	self.specialKeyList 	= specialSymbolList
	self.specialItemConfig  = specialSymbolConfig

end
function Theme:initSlotMachineKeys( slotMachineKeyList )
	if slotMachineKeyList and #slotMachineKeyList > 0 then
		local slotID = self:getThemeSmallSlot()
		for _,theSymbol in pairs(slotMachineKeyList) do
			self.pics[theSymbol]  = "#theme"..slotID.."_s_"..theSymbol..".png"
			table.insert(self.keys, theSymbol)
		end
	end
end
function Theme:initThemeType( themeType, themeTypeConfig )
	if themeType == "payLine" then
		self.lines   = self.ThemeConfig["theme_type_config"]["pay_lines"]
		self.maxLine = #self.lines
	elseif themeType == "ways" then
		self.ways = themeTypeConfig["ways_cnt"]
	end
	self.themeType 		 = themeType
	self.themeTypeConfig = themeTypeConfig		
end
function Theme:getThemeType( )
	return self.themeType or "payLine"
end
function Theme:initBoardAndReelConfig( boardConfig )
	-- self.col 				= 0
	-- self.colRowList  		= {}
	if not self.boardConfigList then return end
	for boardIndex,theConfig in pairs(self.boardConfigList) do
		if theConfig["reel_list_config"] then
			for boardReelIndx,theReelConfig in ipairs(theConfig["reelConfig"]) do
				theReelConfig["board_Index"] 		= boardIndex
				theReelConfig["board_reel_Index"] 	= boardReelIndx
			end 
		end
	end
end

function Theme:getThemeConfig()
end

function Theme:getBoardConfig( )
	return self.boardConfigList or {}
end
function Theme:getReelConfig( )
	return self.reelConfigList or {}
end
function Theme:getReelConfigPos( )
	return self.reelConfigListPos or {}
end

function Theme:adjustEnterThemeRet( data )
	return data
end

function Theme:onEnter( ... )
	-- ThemeEffectControl:getInstance():pubCheckLoadCommonRes( )
	self:initLayout()
	self:initSpinLayer()	
	self:initFreeSpinNode()
	self:refreshColCellsZOrder()
	self:modifyThemeLayout()	
	--commonMusic: 普通背景音乐
	-- self:dealMusic_PlayNormalLoopMusic()
	self.playNormalLoopMusic = true
	self:dealMusic_PlayEnterMusic()
    self.isFreeGameRecoverState = false
	self:unlockLobbyBtn()
end
function Theme:initLayout( )
	local s = cc.Director:getInstance():getWinSize()
	self.shakyNode = cc.NodeGrid:create()
	self:addChild(self.shakyNode)

	-- 初始化 场景
	self:initScene(self)

	local l_bg_zOrder 	  = 1
	local l_board_zOrder  = 3
	local l_modify_zOrder = 5
	local l_effect_zOrder = 7
	if not self.bgRoot then
		self.bgRoot 	 = cc.Node:create()
		self:addChild(self.bgRoot, l_bg_zOrder)
	end	

	-- 棋盘层
	if not self.boardRoot then
		self.boardRoot 	 = cc.Node:create()
		self:addChild(self.boardRoot, l_board_zOrder)
	end
	-- modify_node
	self.modifyNode  = cc.Node:create()
	self:addChild(self.modifyNode, l_modify_zOrder)
	-- 动画层
	if not self.animateNode then
		self.animateNode = cc.Node:create()
		self:addChild(self.animateNode,l_effect_zOrder)	
	end

	-- 多主题商店层
	if self.store_data and not self.storeCoinsNode then
		self.storeCoinsNode = cc.Node:create()
		self:addChild(self.storeCoinsNode,l_effect_zOrder)	
	end

	self:initSpinLayerBg()
		-- 初始化各个棋盘
	local boardConfigList 	= self:getBoardConfig()
	self.boardNodeList = self:initBoardNodes(boardConfigList)
end

function Theme:initSpinLayer( )
	self.spinLayer = SpinLayer.new(self, self.ctl)
	self.shakyNode:addChild(self.spinLayer,-1)	
end
function Theme:initScene(spinLayer)
	-- body
end
function Theme:initSpinLayerBg()
	local floor = self.bgRoot:getChildByTag(Theme.Tags.Floor)
	if floor then
		bole.addClickEvent(floor, function (  )
			if self.ctl and self.ctl.footer:isCanSpin() then
				self.ctl:toSpin()
			end
		end)
	end
end
function Theme:initBoardNodes(pBoardConfigList)
	local boardRoot 	  = self.boardRoot
	local boardConfigList = pBoardConfigList or self.boardConfigList or {}
	local reelZorder 	  = 100
	self.clipData = {}
	local pBoardNodeList = {}
	-- 棋盘初始化
	for boardIndex, theConfig in ipairs(boardConfigList) do
		local theBoardNode 	= nil
		local reelNodes = {}
		if theConfig["row_single"] then -- 一行使用一个裁剪区域 等距才可以
			theBoardNode = cc.Node:create()
			boardRoot:addChild(theBoardNode)
			local rowReelCnt = theConfig["rowReelCnt"]
   			local index = 0
   			local clipNode = nil
   			local reelNode = nil
   	   		for reelIndex,config in ipairs(theConfig["reelConfig"]) do
	   			 
   	   			if (reelIndex-1)%rowReelCnt == 0 then 
   	   				reelNode = cc.Node:create()
   	   				reelNode:setLocalZOrder(reelZorder)
   	   				
					local vex = {
						config["base_pos"], -- 第一个轴的左下角  下左边界
						cc.pAdd(config["base_pos"], cc.p(config["cellWidth"]*rowReelCnt, 0)),  -- 下右边界
						cc.pAdd(config["base_pos"], cc.p(config["cellWidth"]*rowReelCnt, config["cellHeight"])),-- 上右边界
						cc.pAdd(config["base_pos"], cc.p(0, config["cellHeight"])),-- 上左边界
					}
		   		    local stencil = cc.DrawNode:create()
		   		    stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))

		   		    local clipAreaNode = cc.Node:create()
		   		    clipAreaNode:addChild(stencil)
		   		    clipNode = cc.ClippingNode:create(clipAreaNode)
		   		   
					theBoardNode:addChild(clipNode)	
					clipNode:addChild(reelNode)
   	   			end
				reelNodes[reelIndex] = reelNode
   		    end
		elseif theConfig["single"] then
			theBoardNode = cc.Node:create()
			-- theBoardNode:setPosition(theConfig["base_pos"])
			boardRoot:addChild(theBoardNode)
			
   		    for reelIndex,config in ipairs(theConfig["reelConfig"]) do
				local reelNode = cc.Node:create()
				reelNode:setLocalZOrder(reelZorder)
				local vex = {
					config["base_pos"], -- 第一个轴的左下角  下左边界
					cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], 0)),  -- 下右边界
					cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], config["cellHeight"])),-- 上右边界
					cc.pAdd(config["base_pos"], cc.p(0, config["cellHeight"])),-- 上左边界
				}
	   		    local stencil = cc.DrawNode:create()
	   		    stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))

	   		    local clipAreaNode = cc.Node:create()
	   		    clipAreaNode:addChild(stencil)
	   		    local clipNode = cc.ClippingNode:create(clipAreaNode)
	   		    clipNode:addChild(reelNode)
				theBoardNode:addChild(clipNode)	
				reelNodes[reelIndex] = reelNode
   		    end
		else
			self.clipData["normal"] = {}
			local reelNode = cc.Node:create()
			reelNode:setLocalZOrder(reelZorder)
			theBoardNode = cc.Node:create()
			-- theBoardNode:setPosition(theConfig["base_pos"])
			boardRoot:addChild(theBoardNode)
			local clipAreaNode = cc.Node:create()
			-- print("zhf reelConfig",tool.lua_to_json(theConfig["reelConfig"]))
   		    for reelIndex,config in ipairs(theConfig["reelConfig"]) do
				local vex = {
					config["base_pos"], -- 第一个轴的左下角  下左边界
					cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], 0)),  -- 下右边界
					cc.pAdd(config["base_pos"], cc.p(config["cellWidth"], config["cellHeight"]*config["symbolCount"])),-- 上右边界
					cc.pAdd(config["base_pos"], cc.p(0, config["cellHeight"]*config["symbolCount"])),-- 上左边界
				}
				if theConfig["allow_over_range"] then
					vex[1] = cc.pAdd(vex[1], cc.p(-config["cellWidth"], 0))
					vex[4] = cc.pAdd(vex[4], cc.p(-config["cellWidth"], 0))

					vex[2] = cc.pAdd(vex[2], cc.p(config["cellWidth"], 0))
					vex[3] = cc.pAdd(vex[3], cc.p(config["cellWidth"], 0))
				end
	   		    local stencil = cc.DrawNode:create()
	   		    stencil:drawPolygon(vex, #vex, cc.c4f(1,1,1,1), 0, cc.c4f(1,1,1,1))
	   		    clipAreaNode:addChild(stencil)
				reelNodes[reelIndex] = reelNode

				self.clipData["normal"][reelIndex] = {}
				self.clipData["normal"][reelIndex]["vex"] = vex
				self.clipData["normal"][reelIndex]["stencil"] = stencil
   		    end
			local clipNode = cc.ClippingNode:create(clipAreaNode)

			theBoardNode:addChild(clipNode)	
			clipNode:addChild(reelNode)
		end		
	
		theBoardNode.reelNodes 	   = reelNodes
		theBoardNode.reelConfig    = theConfig["reelConfig"]
		theBoardNode.boardIndex    = boardIndex
		theBoardNode.getReelNode   = function(theSelf,index)
			return theSelf.reelNodes[index]
		end
		pBoardNodeList[boardIndex] = theBoardNode
	end

	self:initBoardTouchBtn(boardConfigList, pBoardNodeList)

	return pBoardNodeList
end

function Theme:initBoardTouchBtn(boardConfigList, pBoardNodeList)
	
end

function Theme:modifyThemeLayout( )
	-- body
end

function Theme:footerCopySpinBtnEvent( ... )
	if not G_THEME_FAST_TAG then 
		self.ctl.footer:copySpinBtnEvent()
	end
end

------------------------------------------------------------------------------------------------------------------------------------
-- enter_game
------------------------------------------------------------------------------------------------------------------------------------
function Theme:adjustTheme( data )
	-- todo
end

function Theme:enterThemeByBonus(data, callFunc )
	self.respinInFunc = callFunc
	return 
end
function Theme:enterThemeByFreespin( callFunc, data )
	self.freeSpinInFunc = callFunc
	return
end

function Theme:onEnterTheme( endCallFunc )

	-- if self.respinInFunc then
	-- 	self.respinInFunc()
	-- 	self.respinInFunc = nil
	-- end

	-- if self.freeSpinInFunc then
	-- 	self.freeSpinInFunc()
	-- 	self.freeSpinInFunc = nil
	-- end

	if endCallFunc then
		endCallFunc()
	end
end

-- 控制ackpotNotification显示时机
function Theme:canShowJackpotNotification()
	return true
end

-- whj 添加
function Theme:saveBonusCheckData( bonusData ) -- 没有断线的情况下进入bonus时候, 判断存在bonus_id校验字段, 直接赋值存储,同时覆盖掉原来的数据(每个主题里面单独控制是否需要清空数据)
	-- local data = {}
	-- data.bonus_id = bonusData.bonus_id
	-- LoginControl:getInstance():saveBonus(self.themeid, data)
end

function Theme:cleanBonusSaveData( data ) -- 断线的情况下进入bonus时候, 判断bonus_id校验字段本地与服务器不一致, 清除原来的数据(每个主题里面单独控制是否需要清空数据)
	-- cacheData = nil
	-- LoginControl:getInstance():saveBonus(self.themeid, nil)
end
-- whj 添加 end

------------------------------------------------------------------------------------------------------------------------------------
-- cell相关
------------------------------------------------------------------------------------------------------------------------------------
local notneed = {0,"0"} 
function Theme:createCellSprite( key, col, rowIndex)
	if key == "s" then key=11 end
	if key == "w" then key=1 end
	self.initialPics = self.initialPics or {}
	-- if self.specialItemConfig[key] then
	-- 	local colSet = self.specialItemConfig[key]["col_set"] or {}
	-- 	if colSet[col] then
	-- 		if colSet[col] == 0 then
	-- 			key = self:getNormalKey(col)
	-- 		elseif colSet[col] == 1 then
	-- 			if self.initialPics[col] then
	-- 				key = self:getNormalKey(col)
	-- 			else
	-- 				self.initialPics[col] = true
	-- 			end
	-- 		end
	-- 	end
	-- end
	------------------------------------------------------------
	-- --- 造假 缺失的 数据
	-- if tool.tableContainsValue(notneed,key) or key == 0 then
	-- 	print("修改 key 值 原来：key: ",key)
	-- 	key = math.random(2,8)
	-- 	print("修改之后 key: ",key)
	-- end

	local theCellNode   = cc.Node:create()
	local theCellFile   = self.pics[key]
	-- print("whj: key, theCellFile:  ",key,theCellFile)
	local theCellSprite = bole.createSpriteWithFile(theCellFile)
	theCellNode:addChild(theCellSprite)
	theCellNode.key 	  = key
	theCellNode.sprite 	  = theCellSprite
	theCellNode.curZOrder = 0
	------------------------------------------------------------
	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col )
	local theKey = theCellNode.key
	if self.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self.symbolZOrderList[theKey]
	end
	if self.symbolPosAdjustList[theKey] then
		theCellSprite:setPosition(self.symbolPosAdjustList[theKey])
	end
	return theCellNode
end
function Theme:updateCellSprite( theCellNode, key, col ) -- 控制 显示 cell 的 sprite 上面
	local theCellFile 	= self.pics[key]
	local theCellSprite = theCellNode.sprite
	bole.updateSpriteWithFile(theCellSprite, theCellFile)
	theCellNode.key 	  = key
	theCellNode.curZOrder = 0
	------------------------------------------------------------

	self:adjustWithTheCellSpriteUpdate( theCellNode, key, col )	
	local theKey = theCellNode.key
	if self.symbolZOrderList[theKey] then
		theCellNode.curZOrder = self.symbolZOrderList[theKey]
	end	
	theCellSprite:setAnchorPoint(cc.p(0.5, 0.5))
	if self.symbolPosAdjustList[theKey] then
		theCellSprite:setPosition(self.symbolPosAdjustList[theKey])
	else
		theCellSprite:setPosition(cc.p(0,0))
	end	
end
function Theme:adjustWithTheCellSpriteUpdate( theCellNode, key, col )
	-- todo
end
function Theme:refreshColCellsZOrder( pCol )
	self.spinLayer:refreshCellsZOrder(pCol)
end
------------------------------------------------------------------------------------------------------------------------------------
-- ways类型 和 line类型主题生效相关
-- 1，后续需要考虑配置化实现方式
------------------------------------------------------------------------------------------------------------------------------------
function Theme:drawWaysThemeAnimate( ways, layer, rets, specials,timeList, boardIndex)
	local draw 		= cc.Node:create()
	local symboldraw= cc.Node:create()
	local index 	= 0
	local itemList 	= rets["item_list"]
	local doFirst  = true
	local function drawEachWay(theWayData, tipIndex)
		self:showAllItem("draw")
		draw:removeAllChildren()
		local posList 		=theWayData["win_pos"]
		local effectStatus 	= "half" -- 播放每条线的动画
		for _, crPos in pairs(posList) do
			local col = crPos[1]
			local row = crPos[2]
			local sprite = self:drawPayLineItem(col, row, specials, itemList, effectStatus, tipIndex,symboldraw)
			if sprite then draw:addChild(sprite) end
		end
	end
	local function drawEachCRPosGroup(theGroupItem, theGroupCRPosList, tipIndex)
		self:showAllItem("draw")
		draw:removeAllChildren()
		local effectStatus 	= "half" -- 
		for _,crPos in ipairs(theGroupCRPosList) do
			local col = crPos[1]
			local row = crPos[2]
			local sprite = self:drawPayLineItem(col, row, specials, rets, effectStatus, tipIndex,symboldraw)
			if sprite then draw:addChild(sprite) end
		end
	end	
	local function drawAllWinPos(winPosList)
		self:showAllItem("draw")
		draw:removeAllChildren()
		local effectStatus 	= "all" -- 播放所有中奖动画
		if doFirst then
			effectStatus = "all_first"
			doFirst = false
		end		
		local tipIndex  	= 0
		for _, theData in pairs(winPosList) do
			local col = theData[1]
			local row = theData[2]
			local sprite = self:drawPayLineItem(col, row, specials, itemList, effectStatus, tipIndex,symboldraw)
			if sprite then draw:addChild(sprite) end			
		end
	end
	self.animateNode:addChild(symboldraw,1)
	symboldraw.animations = {}
	
	if self.themeAnimateKuang then -- whj 添加存放中奖连线框动画，让他始终在 动画曾的最上面，包括lock 动画
		self.themeAnimateKuang:addChild(draw,10)
	else
		self.animateNode:addChild(draw,10)
	end

	if rets["win_pos_list"] and #rets["win_pos_list"]>0 then
		local delay = 0		
		draw:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(function()
			local asList = {}
			local a1 = cc.CallFunc:create(function()
				drawAllWinPos(rets["win_pos_list"])
			end)
			local a2 = cc.DelayTime:create(timeList and timeList[1] or 3) -- 播放全条中奖连线是3秒
			table.insert(asList, a1)
			table.insert(asList, a2)
			local tipIndex = 0
			-- if self.winCRPosGroupList and bole.getTableCount(self.winCRPosGroupList)>0 then				
			-- 	for theItem,theCRPosList in pairs(self.winCRPosGroupList) do
			-- 		tipIndex = tipIndex + 1
			-- 		local g1 = cc.CallFunc:create(function()
			-- 			drawEachCRPosGroup(theItem, theCRPosList, tipIndex)
			-- 		end)
			-- 		local g2 = cc.DelayTime:create(timeList and timeList[2] or 1) -- 
			-- 		table.insert(asList, g1)
			-- 		table.insert(asList, g2)				
			-- 	end				
			-- end
			for index,theWayData in pairs(ways) do
				tipIndex = tipIndex + 1
				local curIndex = tipIndex -- whj 重新定义了一个参数用来索引当前的way的index。因为 for循环对tipIndex进行的修改在真正调用drawEachWay时候 tipIndex已经被更改成其他值了，所以定义local值只在当前循环中有效不会被更改
				local t1 = cc.CallFunc:create(function()
					drawEachWay(theWayData, curIndex)
				end)
				local t2 = cc.DelayTime:create(timeList and timeList[2] or 1) -- 延迟1秒去播放
				table.insert(asList, t1)
				table.insert(asList, t2)
			end
			draw:runAction(cc.RepeatForever:create(cc.Sequence:create(bole.unpack(asList))))
		end)))
	end
end
function Theme:drawLinesThemeAnimate( lines, layer, rets, specials,timeList, boardIndex)
	lines = lines or {}
	local itemList  = rets["item_list"]
	-- print("itemList: ",tool.lua_to_json(itemList))
	local draw 	    = cc.Node:create()
	local symboldraw= cc.Node:create()
	local doFirst   = true
	local function drawEachLine(theLineData, tipIndex)
		-- print("theLineData: ",tool.lua_to_json(theLineData))
		self:showAllItem("draw")
		local lineIndex = theLineData[1]
		local cols 		= self.lines[lineIndex]
		local begCol 	= 1 -- 开始的列
		local endCol 	= theLineData[2] -- 结束的列
		local symbol 	= theLineData[3] -- 中奖 symbol
		local adjustCol = 1 -- 每次增量 1 
		if theLineData[4] then
			begCol 		= #self.spinLayer.spins
			endCol 		= #self.spinLayer.spins - theLineData[2] + 1
			adjustCol 	= -1
		end
		local effectStatus 	= "half"
		for col = begCol, endCol, adjustCol do
			local row 	 = cols[col] + 1
			local sprite = self:drawPayLineItem(col+theLineData.col_ck, row, specials, itemList, effectStatus, tipIndex,symboldraw)
			if sprite then draw:addChild(sprite) end
		end
	end
	local function drawEachCRPosGroup(theGroupItem, theGroupCRPosList, tipIndex)
		self:showAllItem("draw")
		draw:removeAllChildren()
		local effectStatus 	= "half"
		for _,crPos in ipairs(theGroupCRPosList) do
			local col = crPos[1]
			local row = crPos[2]
			local sprite = self:drawPayLineItem(col, row, specials, itemList, effectStatus, tipIndex,symboldraw)
			if sprite then draw:addChild(sprite) end
		end
	end
	local function drawAllWinPos(winPosList)
		self:showAllItem("draw")
		draw:removeAllChildren()
		local effectStatus 	= "all"
		if doFirst then
			effectStatus = "all_first"
			doFirst = false
		end		
		local tipIndex      = 0
		for _, theData in pairs(winPosList) do
			local col = theData[1] -- 列
			local row = theData[2] -- 行
			local sprite = self:drawPayLineItem(col, row, specials, itemList, effectStatus, tipIndex,symboldraw)
			if sprite then draw:addChild(sprite) end			
		end
	end
	self.animateNode:addChild(symboldraw,2)
	if self.themeAnimateKuang then -- whj 添加存放中奖连线框动画，让他始终在 动画曾的最上面，包括lock 动画
		self.themeAnimateKuang:addChild(draw,10)
	else
		self.animateNode:addChild(draw,10)
	end
	
	if rets and rets["win_pos_list"] and #rets["win_pos_list"]>0 then
		local delay = 0		
		draw:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(function()
			local asList = {}
			local a1 = cc.CallFunc:create(function()
				drawAllWinPos(rets["win_pos_list"])
			end)

			local a2 = cc.DelayTime:create(timeList and timeList[1] or 3)
			table.insert(asList, a1) -- 同时播放动画放到数组中
			table.insert(asList, a2)
			local tipIndex = 0
			if self.winCRPosGroupList and bole.getTableCount(self.winCRPosGroupList)>0 then
				for theItem,theCRPosList in pairs(self.winCRPosGroupList) do
					tipIndex = tipIndex + 1
					local g1 = cc.CallFunc:create(function()
						drawEachCRPosGroup(theItem, theCRPosList, tipIndex)
					end)
					local g2 = cc.DelayTime:create(timeList and timeList[2] or 1)
					table.insert(asList, g1) -- 特殊的 单条线播放
					table.insert(asList, g2)
				end				
			end
			local sameTimePlay = false
			for index,theLineData in pairs(lines) do
				if theLineData.play_idx then sameTimePlay = true; break end

				tipIndex = tipIndex + 1
				local t1 = cc.CallFunc:create(function()
					draw:removeAllChildren()
					drawEachLine(theLineData, tipIndex)
				end)
				local t2 = cc.DelayTime:create(timeList and timeList[2] or 1)
				table.insert(asList, t1)-- 普通的单条线播放
				table.insert(asList, t2)
			end
			--多表同时播
			if sameTimePlay then
				for i=1, 100 do
					local iIndexs = {}
					for index,theLineData in ipairs(lines) do
						if theLineData.play_idx == i then
							table.insert(iIndexs, theLineData)
						end
					end
					if #iIndexs == 0 then
						break
					else
						local t1 = cc.CallFunc:create(function()
							draw:removeAllChildren()
							for k,v in ipairs(iIndexs) do
								drawEachLine(v, i)
							end
						end)
						local t2 = cc.DelayTime:create(timeList and timeList[2] or 1)
						table.insert(asList, t1) -- 线排序 然后播放动画
						table.insert(asList, t2)
					end
				end
			end
			draw:runAction(cc.RepeatForever:create(cc.Sequence:create(bole.unpack(asList))))
		end)))
	end	
end
function Theme:drawPayLineItem(reel, row, specials, itemList, effectStatus, tipIndex,parent) --想法子把smbol动画添加到sprite
	local sprite = cc.Sprite:create()
	sprite:setPosition(self:getCellPos(reel,row))
	local tt 		= itemList[reel][row]
	local action    = self:getItemAnimate(tt, reel, row, effectStatus,parent) -- 获得相应动画
	if action then	
		local s = self.spinLayer.spins[reel]:getRetCell(row) -- 获得相应位置 
		s:setCascadeOpacityEnabled(true) -- 子节点透明度随父节点变化
		if type(action) == "table" then
			local i = action[2]
			s = s:getChildren()[i]
			action = action[1]
		end
		s:runAction(action)
	end
	self:playCellRoundEffect(sprite, tt, reel, row, effectStatus) -- 播放中奖连线 调用每个主题本身的方法, 直接播放spine 动画来实现
	return sprite
end
function Theme:playCellRoundEffect(theSprite, item, col, row, effectStatus ) -- 通过图片自己制作帧动画 
	-- local animation = cc.Animation:create()
	-- local file  	= self.roundLightConfig["file"]
	-- local size  	= self.roundLightConfig["size"]
	-- local frame 	= self.roundLightConfig["frame"]
	-- local secFrame 	= self.roundLightConfig["sec_frame"]
	-- theSprite:setScaleX(self.cellWidth/size.width)
	-- theSprite:setScaleY(self.cellHeight/size.height)

	-- local interval = 1/secFrame
	-- local actionList = {}
	-- for i = 1, frame do
	-- 	local changeImg = cc.CallFunc:create(function()
	-- 			theSprite:setTexture(string.format(file, i))
	-- 			if self.roundLightConfig["additive"] then
	-- 				theSprite:setBlendFunc(gl.ONE, gl.ONE)
	-- 			end
	-- 		end)
	-- 	local delayTime = cc.DelayTime:create(interval)
	-- 	table.insert(actionList, changeImg)
	-- 	table.insert(actionList, delayTime)
	-- end
	-- theSprite:runAction(cc.RepeatForever:create(cc.Sequence:create( unpack(actionList))))

	-- if self.roundLightConfig["additive"] then
	-- 	theSprite:setBlendFunc(gl.ONE, gl.ONE)
	-- end
end
function Theme:getItemAnimate(item, col, row, effectStatus,parent)
	-- if effectStatus and effectStatus=="half" then   -- whj 注释掉 没有 symbol 动画的时候 进行代码的 透明度变化动画控制 (如果没有 symbol 动画，不需要动画)
	-- 	return Theme.getSingleItemAnimate(self, item)
	-- elseif effectStatus and (effectStatus=="all_first" or effectStatus=="all") then
	-- 	return Theme.getItemAnimate_4(self, item)
	-- end
end
function Theme:getItemAnimate_4(item)
	local fs = 40
	local objOp = 0
	local animate = cc.Sequence:create(
		cc.DelayTime:create(7/fs),
		cc.FadeTo:create(19/fs, 255*objOp),
		cc.DelayTime:create(10/fs), 
		cc.FadeTo:create(17/fs, 255),
		cc.DelayTime:create(7/fs))
	return cc.Sequence:create(animate, animate:clone())
end
function Theme:getSingleItemAnimate(item)
	local fs = 60
	local objOp = 0
	local animate = cc.Sequence:create(		
		cc.DelayTime:create(2/fs),
		cc.FadeTo:create(0, 255*objOp),
		cc.DelayTime:create(30/fs),		
		cc.FadeTo:create(0, 255),
		cc.DelayTime:create(28/fs))
	return cc.Sequence:create(animate)
end
------------------------------------------------------------------------------------------------------------------------------------
-- symbol动画播放相关
------------------------------------------------------------------------------------------------------------------------------------
------------------------------ a1
function Theme:runFullReelAnimation( sprite, startFrame, loopStartFrame, endFrame, loop )
	self.ctl.rets.runningAnimation = self.ctl.rets.runningAnimation or {}
	self.ctl.rets.runningAnimation[sprite] = true
	local cnt = 0
	local function onLoad(...)
		cnt = cnt + 1
		if cnt == loopStartFrame - 1 then
			self:showFullReelAnimation(sprite, startFrame, loopStartFrame, endFrame, loop)
		end
	end
	for i = 1, loopStartFrame - 1 do
		cc.Director:getInstance():getTextureCache():addImageAsync(self:getPic(string.format("wild/%d.png",i)), onLoad)
	end

	for i = loopStartFrame, endFrame do
		cc.Director:getInstance():getTextureCache():addImageAsync(self:getPic(string.format("wild/%d.png",i)), function(...)end)
	end
end
function Theme:isAnimationSpriteRunning( sprite )
	return self.ctl.rets and self.ctl.rets.runningAnimation and self.ctl.rets.runningAnimation[sprite]
end
function Theme:showFullReelAnimation( sprite, startFrame, loopStartFrame, endFrame, loop, isLoop )
	local action = nil
	if not self:isAnimationSpriteRunning( sprite )  then return end
	if isLoop then
		local animation = cc.Animation:create()   
	    for i = loopStartFrame, endFrame do
	        animation:addSpriteFrameWithFile(self:getPic(string.format("wild/%d.png",i)))
	    end
	    animation:setDelayPerUnit(1 / 12)
	    loop = loop or 100
	    animation:setLoops(loop)
	    action = cc.Animate:create(animation)
	else
		local animation = cc.Animation:create()   
	    for i = startFrame, loopStartFrame-1 do
	        animation:addSpriteFrameWithFile(self:getPic(string.format("wild/%d.png",i)))
	    end
	    animation:setDelayPerUnit(1 / 12)
	    action = cc.Animate:create(animation)
	    if not self:isAnimationSpriteRunning( sprite )  then return end
	    action = cc.Sequence:create(action, cc.CallFunc:create(function()self:showFullReelAnimation(sprite, startFrame, loopStartFrame, endFrame, loop, true)end))
	end
	if not self:isAnimationSpriteRunning( sprite )  then return end
    sprite:runAction(action)
end
------------------------------ a1
function Theme:addCocosAnimation( parent, file, pos, frame, stencil, alphaThreshold, timeSpeed, isRetain, isForever )
	local ss 	= cc.CSLoader:createNode(file)
	local child = ss
	isForever 	= isForever or false
	if stencil then
		local clipNode = cc.ClippingNode:create(stencil)
		clipNode:addChild(ss)
		if alphaThreshold then
			clipNode:setAlphaThreshold(alphaThreshold)
		end
		child = clipNode
	end
	child:setPosition(pos)
	parent:addChild(child)

	local aa = cc.CSLoader:createTimeline(file)
	ss:runAction(aa)
	aa:gotoFrameAndPlay(0,frame,isForever)
	timeSpeed = timeSpeed or 2/3
	aa:setTimeSpeed(timeSpeed)
	local delay = frame/60/timeSpeed
	if not isRetain then
		child:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.RemoveSelf:create()))
	end
	return delay, ss
end

------------------------------ a5
function Theme:flyParticle( layer, startPos, objPos, listFile, flyTime, speed, flyDelay, pcallFun, callDelay )
	if not layer then return end
	flyDelay = flyDelay or 0.01
	callDelay = callDelay or 0
	local item = cc.ParticleSystemQuad:create( listFile )
	item:setVisible(false)
	local function callback( ... )
		item:runAction(cc.Sequence:create(
				cc.DelayTime:create(0.1), 
				cc.CallFunc:create(function()
					item:setEmissionRate(0)	
				end),
				cc.DelayTime:create(0.3), 
				cc.CallFunc:create(function()
					item:removeFromParent(true)
				end)	
			)
		)
	end
	if not flyTime then
		speed = speed or 100
		local length = cc.pGetDistance(startPos,objPos)
		flyTime = length/speed
	end
	layer:addChild(item)
	item:setPosition(startPos)
	item:runAction(cc.Sequence:create(cc.DelayTime:create(flyDelay), 
		cc.Show:create(), cc.MoveTo:create(flyTime, objPos), cc.CallFunc:create(function()
			callback()
		end))
	)
	item:runAction(cc.Sequence:create(cc.DelayTime:create(flyDelay), 
		cc.DelayTime:create(flyTime + callDelay), cc.CallFunc:create(function()
			if pcallFun then pcallFun() end			
		end))
	)
	return flyTime, item
end
------------------------------ a5
function Theme:flyParticleWithActionList( layer, startPos, actionList, listFile )
	if not layer then return end
	local item = cc.ParticleSystemQuad:create( listFile )
	layer:addChild(item)
	local function callback( ... )
		item:runAction(cc.Sequence:create(
				cc.DelayTime:create(0.1), 
				cc.CallFunc:create(function()
					item:setEmissionRate(0)	
				end),
				cc.DelayTime:create(0.3), 
				cc.CallFunc:create(function()
					item:removeFromParent(true)
				end)	
			)
		)
	end
	local a_1 = cc.CallFunc:create(function() callback() end)
	table.insert(actionList, a_1)
	item:setPosition(startPos)
	item:runAction(cc.Sequence:create(unpack(actionList)))
end
------------------------------ a7
function Theme:addFrameAnimation(parent, file, pos, frame, secFrame, isRetain, callFunc)
	local interval = 1/secFrame
	local sprite = cc.Sprite:create()
	local animation = cc.Animation:create()
	local sharedSpriteFrameCache = cc.SpriteFrameCache:getInstance()
	for i = 1, frame do
		local path = string.format(file, i)
		if string.byte(path) == 35 then
			path  = string.sub(path,2)
    		local tempSpriteFrame = sharedSpriteFrameCache:getSpriteFrame(path)
			animation:addSpriteFrame(tempSpriteFrame)
	    else 
			animation:addSpriteFrameWithFile(path)
	    end
	end
	animation:setDelayPerUnit(interval)
	if not isRetain then 
		animation:setLoops(1)
		sprite:runAction(cc.Sequence:create(
			cc.Animate:create(animation),
			cc.CallFunc:create(function( ... )
				if callFunc then 
					callFunc()
				end
			end),
			cc.RemoveSelf:create()))
	else
		sprite:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))
	end
	sprite:setPosition(pos)
	parent:addChild(sprite)
	return frame * interval, sprite
end

function Theme:addSpineAnimation(parent, zOrder, file, pos, animateName, completeCallback, callbackDelay, returnDelay, isRetain, isLoop, timeScale)
	local delay = returnDelay or 0
	callbackDelay = callbackDelay or 0
	zOrder = zOrder or 0
	if cc.FileUtils:getInstance():isFileExist(file..".json") then
		local skeleton = sp.SkeletonAnimation:create(file..".json", file..".atlas", 1)
		skeleton:setPosition(pos)
		skeleton:setAnimation(0, animateName, isLoop) 
		skeleton:setTimeScale(timeScale or 1)
		parent:addChild(skeleton, zOrder)
		skeleton:registerSpineEventHandler(function (event)
				if not isRetain then
					-- 延迟释放，否则会报错
					skeleton:runAction(cc.Sequence:create(
							cc.DelayTime:create(0),
							cc.RemoveSelf:create()
						))
				end
				if completeCallback then
					if callbackDelay == 0 then
						completeCallback()
					else
						self:runAction(cc.Sequence:create(
						cc.DelayTime:create(callbackDelay),
						cc.CallFunc:create(function()
							completeCallback()
						end)))
					end
				end
	        end, sp.EventType.ANIMATION_COMPLETE)
		return delay, skeleton
	else
		if appDebugMode then
			print("Spine not exist ",file)
			print(a.b)
		else
			bole.send_codeInfo(Splunk_Type.Error, {error = "Spine_not_exist", msg = file}, false)
		end
		return 0, nil
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- spin相关
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 说明：spin开始控制函数
-- 作用：在通用框架下，控制开始spin的时机
function Theme:spinControl( spinCallFun )
	spinCallFun()
end
function Theme:dealSpinSendData( data )
	-- todo
end
-- 说明：stop开始控制函数
-- 作用：在通用框架下，控制开始stop的时机
-- 注意：必须要与Theme:checkCanSetStopBtn( rets )共同进行控制
function Theme:stopControl( stopRet, stopCallFun )
	stopCallFun()
end
function Theme:adjustRecData( rets )
	-- if self.isShowWinNotify then
	-- 	rets["play_win_notify"] = true
	-- end
end
-- spin过程关键时刻
function Theme:onSpinBoard( )
	--commonMusic: 恢复背景音乐
	self:dealMusic_OutMuteLoopMusic()
end
function Theme:onStopBoard( )
	-- todo
	
end
function Theme:onFastStopBoard( )
	self:dealMusic_StopReelNotifyMusic()
end

function Theme:onSpinStart( )
	-- todo
	self:stopActionByTag(777)
	self:stopActionByTag(987)
	self.playGame = false
	self.canFastStop = true
	self.ExtraStopCD = 0
	self.hintMusicCnt = 0
	-- if bole.isMusicMute() then
		if self.playNormalLoopMusic then
			self:dealMusic_PlayNormalLoopMusic()
			self.playNormalLoopMusic = false
		end
	-- end
	 
	if self.playDelayFadeOutLoopMusic then
		self:stopDelayToFadeOutAction()
		self.playDelayFadeOutLoopMusic = false
	end
	if self.jackpotTips then
		for k,v in pairs(self.jackpotTips) do
			v:hide()
		end
	end
end
function Theme:onSpinStop( rets )
	--spins
end
function Theme:onAllReelStop( )
	local delayTime = 0;
	 
	for k,theCell in pairs(self.spinLayer.spins) do
		delayTime = delayTime + 0.05
		self.spinLayer:runAction(	
			cc.Sequence:create(
				cc.DelayTime:create(delayTime),
				cc.CallFunc:create(function ()
					theCell:diamondFly()
				end))
			)
	end
	-- body
end
function Theme:finshSpin( )
	-- todo
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- respin相关
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Theme:onRespinStart( )
	-- body
end
function Theme:onRespinStop( rets )
	-- body
end
function Theme:theme_respin( rets )
	self:runAction(cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(function()
		local respinList = rets["theme_respin"]
		if respinList and #respinList>0 then
			rets["item_list"] = table.remove(respinList, 1)
			local respinStopDelay = 1
			local endCallFunc 	  = self:getTheRespinEndDealFunc(rets)
			self:stopDrawAnimate()
			self.ctl:respin(respinStopDelay, endCallFunc)
		else
			rets["theme_respin"] = nil
			self.ctl:handleResult()
		end	
	end)))
end
function Theme:getTheRespinEndDealFunc( rets )
	local retDealFunc = function(outDealFunc)
		if outDealFunc then
			outDealFunc()
		end
	end
	return retDealFunc
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 其他关键时刻
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Theme:dealAboutBetChange(theBet, isPointBet)
	
end
-- 阶段处理
-- function Theme:set_win_coins( rets )
-- 	self.ctl:setWinCoins( rets )
-- end
function Theme:theme_deal_data( rets )
	rets["theme_deal_data"] = nil
	self.ctl:handleResult()
end
function Theme:theme_deal_show( rets )
	rets["theme_deal_show"] = nil
	self.ctl:handleResult()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- freespin相关：
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Theme:getItemListForFreeSpin()
	if self.ctl.rets then
		return self.ctl.rets.item_list
	else
		return nil
	end	
end
function Theme:getFreeRetForFreeSpin()
	if self.ctl.rets then
		return self.ctl.rets
	else
		return nil
	end	
end

function Theme:adjustFreeSpinMoreData( theData )
	-- todo
end
function Theme:adjustFreeSpinStartData( theData )
	-- todo
end
function Theme:adjustFreeSpinCollectData( theData )
	-- todo
end
function Theme:playStartFreeSpinDialog( theData )
	local theDialog = G_FREE_SPIN_DIALOGS["public"].new(self.ctl)
	theDialog:showStart(theData)
end
function Theme:playMoreFreeSpinDialog( theData )
	local theDialog = G_FREE_SPIN_DIALOGS["public"].new(self.ctl)
	theDialog:showMore(theData)
end
function Theme:playCollectFreeSpinDialog( theData )
	local theDialog = G_FREE_SPIN_DIALOGS["public"].new(self.ctl)
	theDialog:showCollect(theData)
end
function Theme:freeStartClicked( callFunc, isMore )
	callFunc()
	return
end
function Theme:onCollectFreeClick(fsData )
end
function Theme:free_spins_game( ret, theGameData, endCallfunc )
	endCallfunc()
end

function Theme:playBackBaseGameSpecialAnimation( theSpecials ,enterType )
	-- body
end
function Theme:playFreeSpinItemAnimation( theSpecials ,enterType) -- 第二个参数 是类型 freespin or morefreespin
	return 0
end
function Theme:enterFreeSpin(isResume)
	self:showAllItem()
	--commonMusic: freespin背景音乐
	self.playNormalLoopMusic = false
	self:laterCallBack(1,function(  )
		self:dealMusic_PlayFreeSpinLoopMusic()
	end)
end
function Theme:updateFreeBack( ... )
	return nil
end

function Theme:setDealFreeCollectState()
	self.ctl.spin_processing = true
	self.ctl.isProcessing  = true
end
function Theme:hideFreeSpinNode(...)	
	self:showAllItem()

	--commonMusic: 普通背景音乐
	--self:dealMusic_PlayNormalLoopMusic()
	if self.freeSpinNode then
		self.freeSpinNode:hideSelf()
	elseif self.ctl and self.ctl.footer and 
		self.ctl.footer.freeSpinNode and self.ctl.footer.normalFooter then
		self.ctl.footer:setFreeSpinLabel("")		
		self.ctl.footer.normalFooter:setVisible(true)
		self.ctl.footer.normalFooter:setOpacity(0)
		self.ctl.footer.normalFooter:runAction(cc.FadeIn:create(0.5))
		self.ctl.footer.freeSpinNode:runAction( 
			cc.Sequence:create(cc.FadeOut:create(0.5),
			cc.CallFunc:create(function() self.ctl.footer.freeSpinNode:setVisible(false) end)
			))
	end

	-- self:unlockLobbyBtn()
end
function Theme:initFreeSpinNode( )
	-- self.freeSpinNode
end
function Theme:showFreeSpinNode( count, sumCount, first)
	-- if self.freeSpinNode then
	-- 	self.freeSpinNode:setFreeSpinCnt()
	-- 	if first then
	-- 		self.freeSpinNode:showSelf()
	-- 	end
	-- else
	if self.ctl and self.ctl.footer then
		self.ctl.footer:setFreeSpinLabel(count, sumCount)
		self.ctl.footer:changeFreeSpinLayout()
	end

	self:lockLobbyBtn()
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 资源加载相关：
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Theme:loadAllMusics( )
	self:loadResMusic() --加载通用音效
	self:loadThemeMusics() --加载主题音效
end

function Theme:getBaseMusicList()
	local loadMuscList = 
	{
		self.audio_list.reel_stop,
		self.audio_list.reel_notify,
		self.audio_list.rollup01,
		self.audio_list.rollup02,
		self.audio_list.rollup03,
		self.audio_list.rollup04,
		self.audio_list.rollup01_end,
		self.audio_list.rollup02_end,
		self.audio_list.rollup03_end,
		self.audio_list.rollup04_end,

		self.audio_list.trigger_bell,
		self.audio_list.free_dialog_start_show,
		self.audio_list.free_dialog_start_click,
		self.audio_list.free_dialog_start_close,
		self.audio_list.free_dialog_more_show,
		self.audio_list.free_dialog_more_close,
		self.audio_list.free_dialog_collect_click,
		self.audio_list.free_dialog_collect_close,
		self.audio_list.free_dialog_collect_show,
		self.audio_list.transition_free, 
		self.audio_list.transition_bonus, 
		self.audio_list.transition_free_pick, 
		
		self.audio_list.bonus_start_show,	
		self.audio_list.bonus_end_show,		
		self.audio_list.pick_start_show,		
		self.audio_list.pick_end_show,		
		self.audio_list.wheel_start_show,	
		self.audio_list.wheel_end_show,		
		self.audio_list.win_jp_show,			
		self.audio_list.win_jp_click,
		self.audio_list.win_rapidpay_show,			
		self.audio_list.win_rapidpay_click,		
		self.audio_list.common_click, 		
	}
	return loadMuscList
end

function Theme:getLoadMusicList()
	return self:getBaseMusicList()
end

function Theme:loadThemeMusics( )
	local allMusicList = {}
	local tempMusicList = {}
	local basemusicList = self:getBaseMusicList() -- 加载主题定义音效
	local musicList = self:getLoadMusicList() -- 加载主题定义音效
	for _,baseAudioName in pairs(basemusicList) do
		if not tempMusicList[baseAudioName] then
			table.insert(allMusicList, baseAudioName)
			tempMusicList[baseAudioName] = 1
		end
	end
	for _,audioName in pairs(musicList) do
		if not tempMusicList[audioName] then
			table.insert(allMusicList, audioName)
			tempMusicList[audioName] = 1
		end
	end
	self:realLoadThemeMusics(allMusicList)
end

function Theme:realLoadThemeMusics(musicList)
	-- self:setResInfo("d_t",0)--主题音效	
	if musicList and #musicList>0 then	
		self.loadedMusicList = self.loadedMusicList or {}
		local fileUtiles 	   = cc.FileUtils:getInstance()
		local needLoadMusicList = {}	
		for _,audioName in pairs(musicList) do
			if fileUtiles:isFileExist(self:getPic(audioName)) then
				if not self.loadedMusicList[audioName] then
					table.insert(needLoadMusicList, self:getPic(audioName))
					self.loadedMusicList[audioName] = 1
				end
			end
		end

		--- whj 添加预加载主题通用音效
		local commonMusicList = self:getCommonLoadMusicList()
		if commonMusicList and #commonMusicList >0 then 
			for _,audioFile in pairs(commonMusicList) do
				if fileUtiles:isFileExist(audioFile) then
					if not self.loadedMusicList[audioFile] then
						table.insert(needLoadMusicList, audioFile)
						self.loadedMusicList[audioFile] = 1
					end
				end
			end
		end

		local themeCnt = CNT_IN_THEMECNT
		local loadFunc = function()
			if themeCnt ~= CNT_IN_THEMECNT then return end
			-- if self.addLoadResCnt then
			-- 	self.addLoadResCnt()
			-- end

		end
		local tempMusics = AudioControl:preloadAudio(nil, needLoadMusicList, {}, loadFunc)
		self.loadMusicList = self.loadMusicList or {}
		for _,mmusic in pairs(tempMusics) do
			table.insert(self.loadMusicList, mmusic)
		end
		-- self.objLoadCnt = self.objLoadCnt + #self.loadMusicList - 2
		-- self.objLoadCnt = self.objLoadCnt + #self.loadMusicList 
		-- self:setResInfo("d_t",#self.loadMusicList or 0)--主题音效
	end
end

-- whj 添加获得需要加载通用音效的方法
function Theme:getCommonLoadMusicList()
	local commonMusicList = {}

	if self.audio_win_list then 
		for _,v in pairs(self.audio_win_list) do 
			table.insert(commonMusicList, v)
		end
	end
	if self.slot_audio_list then
		for _,v in pairs(self.slot_audio_list) do
			table.insert(commonMusicList, self:getSlotPath(v))
		end
	end

	return commonMusicList
end

function Theme:unloadThemeMusics()
	AudioControl:stopGroupAudio("music")
	self.loadMusicList = self.loadMusicList or {}
	if self.loadMusicList and #self.loadMusicList>0 then		
		for k,v in pairs(self.loadMusicList) do
			 AudioControl:unloadEffect(v)
		end
	end
	self.loadMusicList = {}
	self.loadedMusicList = {}
end

function Theme:loadResMusic( )

end

function Theme:checkResAndDeal( endCallFunc )
	if endCallFunc then
		endCallFunc()
	end
end

function Theme:checkStoreRes(download_controller)
	if self.game_store_version == GameStoreType.PUZZLE_II_V then
		if download_controller:needDownload(2, "theme_store_game2") then
			self.downloadingRatio = self.downloadingRatio + 2
		end
	end
	if self.game_store_version == GameStoreType.PUZZLE_I_V then
		if download_controller:needDownload(2, "theme_store_game") then
			self.downloadingRatio = self.downloadingRatio + 2
		end
	end
	if self.game_store_version == GameStoreType.PUZZLE_II_H then
		if download_controller:needDownload(2, "theme_store_game2horizon") then
			self.downloadingRatio = self.downloadingRatio + 2
		end
	end
	if self.game_store_version == GameStoreType.SLOT_MACHINE_V then
		if download_controller:needDownload(3, "2008") then
			self.downloadingRatio = self.downloadingRatio + 2
		end
	end
	if self.game_store_version == GameStoreType.SLOT_MACHINE_H then
		if download_controller:needDownload(3, "2009") then
			self.downloadingRatio = self.downloadingRatio + 2
		end
	end
end

function Theme:downloadPuzzleStoreRes(download_controller, onSuccess_store, onProgress_store, onError_store, force)
	if self.game_store_version == GameStoreType.PUZZLE_II_V then
		if download_controller:needDownload(2, "theme_store_game2")then
			download_controller:download(2, "theme_store_game2", onSuccess_store, onProgress_store, onError_store, force)
		end
	end
	if self.game_store_version == GameStoreType.PUZZLE_I_V then
		if download_controller:needDownload(2, "theme_store_game")then
			download_controller:download(2, "theme_store_game", onSuccess_store, onProgress_store, onError_store, force)
		end
	end
	if self.game_store_version == GameStoreType.PUZZLE_II_H then
		if download_controller:needDownload(2, "theme_store_game2horizon")then
			download_controller:download(2, "theme_store_game2horizon", onSuccess_store, onProgress_store, onError_store, force)
		end
	end
	if self.game_store_version == GameStoreType.SLOT_MACHINE_V then
		if download_controller:needDownload(3, "2008")then
			download_controller:download(3, "2008", onSuccess_store, onProgress_store, onError_store, force)
		end
	end
	if self.game_store_version == GameStoreType.SLOT_MACHINE_H then
		if download_controller:needDownload(3, "2009")then
			download_controller:download(3, "2009", onSuccess_store, onProgress_store, onError_store, force)
		end
	end
end

function Theme:downloadPuzzleThemeLoading(download_controller)
	if self.game_store_version == GameStoreType.PUZZLE_I_V then
		if download_controller:needDownload(1, "2002") then
			download_controller:download(1, "2002")
		end
	end

	if self.game_store_version == GameStoreType.PUZZLE_II_V then
		if download_controller:needDownload(1, "2005") then
			download_controller:download(1, "2005")
		end
	end

	if self.game_store_version == GameStoreType.PUZZLE_II_H then
		if download_controller:needDownload(1, "2007") then
			download_controller:download(1, "2007")
		end
	end
end

-- whj 添加 下载主题资源
function Theme:downloadThemeRes( endCallFunc,force )

	--目前是单机不需要下载，自动加载
	if self.ctl and self.ctl.loadingView and self.ctl.loadingView.autoLoading then 
		self.ctl.loadingView:autoLoading(endCallFunc)
		return 
	end

	if self.downloadingThemePercents then
		return
	end
	self.downloadingThemePercents = 0
	self.downloadingRatio        = 0

	local download_controller = DownloadController:getInstance()
	local need_store          = (ThemeStoreRes and ThemeStoreRes[self.themeResourceId] ~= nil)

	if download_controller:needDownload(3, tostring(self.themeResourceId)) then
		self.downloadingRatio = self.downloadingRatio + 2
	end
	if need_store then
		self:checkStoreRes(download_controller)
		self:downloadPuzzleThemeLoading(download_controller)
	end
	if self.downloadingRatio > 0 then
		local dir = string.format("theme_resource/theme%d/", self.themeResourceId)
		local isSucceed       = false
		local theme_percent   = 0
		local store_percent   = 0
		local downloadingThemePercent = 0
		local downloadingStorePercent = 0
		local callback_called = false

		local function remove()
			if self.ctl and not self.ctl.loadingView or not self.downloadingThemePercents then return end
			self.downloadingThemePercents = 0
			if self.ctl and self.ctl.header then
				self.ctl.header:toLobbyScene()
			end
			
		end

		local function onSuccess_theme ()
			if not self.downloadingRatio then 
				return 
			end
			theme_percent = 100
			self.downloadingThemePercents = (theme_percent + store_percent) / self.downloadingRatio

			-- if self.downloadingThemePercents == 80 then
			if self.downloadingThemePercents == 50 then
				isSucceed = true
			end

		    if self.ctl and not self.ctl.loadingView or not self.downloadingThemePercents then return end

		    -- if self.downloadingThemePercents == 80 then
		    if self.downloadingThemePercents == 50 then
				Splunk:getInstance():send_codeInfo(Splunk_Type.ACTION,{current = "download_theme_success", bid = self.themeResourceId})
				endCallFunc()
				callback_called = true
			end
			
		end

		local function onSuccess_store ()
			if not self.downloadingRatio then return end
			store_percent = 100
			self.downloadingThemePercents = (theme_percent + store_percent) / self.downloadingRatio

			-- if self.downloadingThemePercents == 80 then
			if self.downloadingThemePercents == 50 then
				isSucceed = true
			end

		    if self.ctl and not self.ctl.loadingView or not self.downloadingThemePercents then return end

		    -- if self.downloadingThemePercents == 80 then
		    if self.downloadingThemePercents == 50 then
				endCallFunc()
				callback_called = true
			end
			
		end

		local function onError_theme (errorCode)
			isSucceed = false
			Splunk:getInstance():send_codeInfo(Splunk_Type.Error,{error = "onError_theme", msg = "onError_theme", tid = self.themeResourceId})
		    if self.ctl and not self.ctl.loadingView or not self.downloadingThemePercents then return end


			remove()

		end

		local function onError_store(errorCode)
			isSucceed = false
			Splunk:getInstance():send_codeInfo(Splunk_Type.Error,{error = "onError_store", msg = "onError_store", tid = self.themeResourceId})
			-- if errorCode == 3 then
			-- 	local zipfile = cc.UserDefault:getInstance():getStringForKey(bole.resourceServer.."theme_store_game.zip", "")
			-- 	cc.FileUtils:getInstance():removeFile(zipfile)
			-- end

		    if self.ctl and not self.ctl.loadingView or not self.downloadingThemePercents then return end

			remove()

		end

		local _load_start_theme = 0
		local _load_start_store = 0
		local function onProgress_theme (percent,curByte,totalByte)
			if self.ctl and self.ctl.loadingView and self.downloadingRatio and self.downloadingThemePercents and percent > downloadingThemePercent then
				downloadingThemePercent = percent
				self.downloadingThemePercents = (downloadingThemePercent + downloadingStorePercent) / self.downloadingRatio

				if _load_start_theme == 0 then 
					_load_start_theme = 1
					if self.ctl.loadingView.addTotalByte then 
						self.ctl.loadingView:addTotalByte(totalByte)
					end
				end

				if self.ctl.loadingView.setPercent then 
					self.ctl.loadingView:setPercent(self.downloadingThemePercents)
				end

		    end
		end

		local function onProgress_store (percent,curByte,totalByte)
			if self.ctl and self.ctl.loadingView and self.downloadingRatio and self.downloadingThemePercents and percent > downloadingStorePercent then
				downloadingStorePercent = percent
				self.downloadingThemePercents = (downloadingThemePercent + downloadingStorePercent) / self.downloadingRatio

				if _load_start_store == 0 then 
					_load_start_store = 1
					if self.ctl.loadingView.addTotalByte then 
						self.ctl.loadingView:addTotalByte(totalByte)
					end
				end

				if self.ctl.loadingView.setPercent then 
					self.ctl.loadingView:setPercent(self.downloadingThemePercents)
				end

		    end
		end

		if self.ctl and self.ctl.loadingView then
			self.downloadingThemePercents = 0

			if self.ctl.loadingView.setPercent then 
				self.ctl.loadingView:setPercent(0)
			end
		end

		if download_controller:needDownload(3, tostring(self.themeResourceId)) then
			Splunk:getInstance():send_codeInfo(Splunk_Type.ACTION,{current = "download_theme_start", bid = self.themeResourceId})
			download_controller:download(3, tostring(self.themeResourceId), onSuccess_theme, onProgress_theme, onError_theme, force)
		end

		if need_store then
			self:downloadPuzzleStoreRes(download_controller, onSuccess_store, onProgress_store, onError_store, force)
		end
	else
		if self.ctl and not self.ctl.loadingView or not self.downloadingThemePercents then return end
		endCallFunc()
	end

	
end

function Theme:preLoadResAsync( endCallFunc )
	self.themeLoadResStart = os.time()

	self.csbList = self.csbList or {}

	self.loadResEndCallFunc = endCallFunc
	self.curLoadCnt = 0
	self.objLoadCnt = 0
	local themeCnt = CNT_IN_THEMECNT
	local function addLoadResCnt( obj )
		if themeCnt ~= CNT_IN_THEMECNT then return end
		if not self.ctl.loadingView then return end
		self.curLoadCnt = self.curLoadCnt + 1
		local percent = self.curLoadCnt / self.objLoadCnt * 100
		
		if self.ctl.loadingView.setPercent then 
			if not self.downloadingThemePercents or self.downloadingThemePercents==0 then
				self.ctl.loadingView:setPercent(percent)
			else
				self.ctl.loadingView:setPercent(50+percent/2) 
			end
		end

		if self.curLoadCnt>self.objLoadCnt then
			if self.loadResEndCallFunc then
				self.loadResEndCallFunc()
				self.loadResEndCallFunc = nil
				self:onLoading_100()
				self:preLoadOtherResources()
			end
		end
	end
	self.addLoadResCnt = addLoadResCnt
	self:onLoading_0()
	
	local textureCache = cc.Director:getInstance():getTextureCache()
    if self.plistAnimate then
		self:preLoadCacheImgs(addLoadResCnt, self.plistAnimate,"plist", 1)
	end
	if self.preSlotPngs then
		self:preLoadCacheImgs(addLoadResCnt, self.preSlotPngs,"slot_machine", 2)
	end
end

function Theme:tryLoadPlistImages()
	if self.plistAnimate then
		self:preLoadCacheImgs(nil, self.plistAnimate,"plist", 1)
	end
	if self.preSlotPngs then
		self:preLoadCacheImgs(nil, self.preSlotPngs,"slot_machine", 2)
	end
end

function Theme:preLoadCacheImgs(callFun, imageList, key, load_type)
	local spriteFrameCache = cc.SpriteFrameCache:getInstance()
	local textureCache = cc.Director:getInstance():getTextureCache()

	for index, objName in ipairs(imageList) do

		local thePicFile
		local thePlistFile
		if load_type == 1 then
			thePicFile = self:getPic(objName .. ".png")
			thePlistFile = self:getPic(objName .. ".plist")
			if self:isExistFile(objName .. ".png") then
				thePicFile = self:getPic(objName .. ".png")
			elseif self:isExistFile(objName .. ".pvr.ccz") then
				thePicFile = self:getPic(objName .. ".pvr.ccz")
			else
				thePicFile = nil
			end
		elseif load_type == 2 then
			thePicFile = self:getSlotPath(objName .. ".png")
			thePlistFile = self:getSlotPath(objName .. ".plist")
		end
		if thePicFile then
			self.objLoadCnt = self.objLoadCnt + 1
			textureCache:addImageAsync(thePicFile, function(...)
				spriteFrameCache:addSpriteFrames(thePlistFile)
				if callFun then
					callFun(key)
				end
			end)
		end
	end
end
function Theme:removePreLoadCacheImgs(imageList,load_type)
	local spriteFrameCache = cc.SpriteFrameCache:getInstance()
	local textureCache = cc.Director:getInstance():getTextureCache()
	local thePicFile
	local thePlistFile
	for index, objName in ipairs(imageList) do
		if load_type == 1 then
			thePicFile = self:getPic(objName .. ".png")
			thePlistFile = self:getPic(objName .. ".plist")
		elseif load_type == 2 then
			thePicFile = self:getSlotPath(objName .. ".png")
			thePlistFile = self:getSlotPath(objName .. ".plist")
		end
		if thePicFile then
			if spriteFrameCache:isSpriteFramesWithFileLoaded(thePlistFile) then
				spriteFrameCache:removeSpriteFramesFromFile(thePlistFile)
				textureCache:removeTextureForKey(thePicFile)
			end
		end
	end

end
function Theme:preLoadOtherResources( ... )
	self:loadAllMusics()
	self.specialPicFileList = self.specialPicFileList or ThemePngs[self.themeResourceId]
	local textureCache = cc.Director:getInstance():getTextureCache()
	if self.specialPicFileList and #self.specialPicFileList>0 then
		for _,thePicConfig in ipairs(self.specialPicFileList) do
			local thePicFile = nil
			if thePicConfig[1] == 1 then
				thePicFile = self:getPic(thePicConfig[2])
			else
				thePicFile = thePicConfig[2]
			end
			if thePicFile then
				if not string.find(thePicFile, "paytable/") and cc.FileUtils:getInstance():isFileExist(thePicFile) then	
					-- self.objLoadCnt = self.objLoadCnt + 1
					textureCache:addImageAsync(thePicFile, function(...)
						--if themeCnt ~= CNT_IN_THEMECNT then return end
						-- addLoadResCnt({key='b',keyTotal = 'b_t'})
					end)
				end	
			end
		end			
	end

	self.commonFileList = CommnonThemeRes
	self:preLoadImgs(nil,self.commonFileList,"common_file_list")


	self.storePicFileList = ThemeStoreRes[self.themeResourceId]
	self:preLoadImgs(nil,self.storePicFileList,"store_file_list")
end

function Theme:preLoadImgs(callFun,imageList,key)
	local textureCache = cc.Director:getInstance():getTextureCache()
	if imageList and #imageList>0 then
		for _, thePicConfig in ipairs(imageList) do
			local thePicFile = nil
			if thePicConfig[1] == 1 then
				-- 主题内
				thePicFile = self:getPic(thePicConfig[2])
			elseif thePicConfig[1] == 2 then
				-- 包内
				thePicFile = thePicConfig[2]
			elseif thePicConfig[1] == 3 then
				-- winEffect  通用的路径
				thePicFile = self:getWinEffectPath() .. thePicConfig[2]
			elseif thePicConfig[1] == 4 then
				--other theme
				thePicFile = self:getSlotPath(thePicConfig[2])
			end
			if thePicFile then
				-- self.objLoadCnt = self.objLoadCnt + 1
				textureCache:addImageAsync(thePicFile, function(...)
					if callFun then
						callFun(key)
					end
				end)
			end
		end
	end
end
function Theme:removeLoadImgs(imageList)
	local textureCache = cc.Director:getInstance():getTextureCache()
	if imageList and #imageList>0 then
		for _, thePicConfig in ipairs(imageList) do
			local thePicFile = nil
			if thePicConfig[1] == 1 then
				-- 主题内
				thePicFile = self:getPic(thePicConfig[2])
			elseif thePicConfig[1] == 2 then
				-- 包内
				thePicFile = thePicConfig[2]
			elseif thePicConfig[1] == 3 then
				-- winEffect  通用的路径
				thePicFile = self:getWinEffectPath() .. thePicConfig[2]
			elseif thePicConfig[1] == 4 then
				--other theme
				thePicFile = self:getSlotPath(thePicConfig[2])
			end
			textureCache:removeTextureForKey(thePicFile)
		end
	end
end
function Theme:unloadRes( )
	local textureCache = cc.Director:getInstance():getTextureCache()
    if self.plistAnimate then
		self:removePreLoadCacheImgs(self.plistAnimate,1)
	end
	if self.preSlotPngs then
		self:removePreLoadCacheImgs(self.preSlotPngs,2)
	end
	if self.frameAnimate then
		for index,objData in ipairs(self.frameAnimate) do
			for i=1,objData[2] do
				local fileName = string.format(self:getPic(objData[1]), i)
				textureCache:removeTextureForKey(fileName)
			end
		end
	end
	if self.specialPicFileList then
		self:removeLoadImgs(self.specialPicFileList)
	end
	if self.commonFileList then
		self:removeLoadImgs(self.commonFileList)
	end

	if self.storePicFileList then
		self:removeLoadImgs(self.storePicFileList)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- spin reel action
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Theme:startCalculateRequestTime( isStartSpin )
	if self.spinLayer then 
		self.spinLayer:startCalculateRequestTime(isStartSpin)
	end
end

function Theme:adjustThemeReels( ret )
	-- todo
end
function Theme:spinBoard( spinTag )
	self.fastStopMusicTag     = nil
	self.reelStopMusicTagList = {}
	self.spinCacheTag = spinTag
	self:onSpinBoard(self.spinCacheTag) -- 播放音效
	if G_THEME_FAST_TAG then
		self.isTurbo = true
	else 
		self.isTurbo = false
	end
	self.spinLayer:spin(self:getSpinConfig(self.spinCacheTag))
end
function Theme:getSpinConfig( spinTag )
	local spinConfig = {}
	local cacheDelay_start = 0
	for col,_ in pairs(self.spinLayer.spins) do
		-- 上弹数据获取 
		local theStartAction = self:getSpinColStartAction(col)
		-- print("zhf theStartAction",lua_to_json(theStartAction))
		-- 上弹之后加速运动数据获取
		
		local theReelConfig = {
			["col"]     = col,
			["action"]  = theStartAction,
			["delay"] 	= 0,
		}
		-- theReelConfig.action[1] = theStartAction
		-- theReelConfig.action[2] = theAction
		table.insert(spinConfig, theReelConfig)
		-- cacheDelay_start = cacheDelay_start + (addStartDelay or 0) +(addDelay or 0)
	end	
	return spinConfig
end

function Theme:stopBoard(ret, endCallFunc,interval)
	self:onStopBoard(self.spinCacheTag)
	local theItemList = ret["item_list"] -- ret["reelItem_list"] or 
	self.spinLayer:stop(self:getStopConfig(ret,self.spinCacheTag,interval), theItemList,ret["item_list_up"],ret["item_list_down"],endCallFunc)
end
function Theme:getStopConfig(ret, spinTag ,interval)
	local stopConfig 	   = {}
	for col = 1,#self.spinLayer.spins do
		local theAction = self:getSpinColStopAction(ret["theme_info"], col,interval)
		table.insert(stopConfig, {col, theAction})
	end	
	return stopConfig
end 

function Theme:fastStopBoard( )
	self:onFastStopBoard(self.spinCacheTag)
	self.spinLayer:fastStop()
end

function Theme:getFastStopConfig( spinTag )
	local fastStopConfig = {}
	local cacheDelay 	 = 0
	for col,_ in pairs(self.spinLayer.spins) do
		local theAction,addDelay = self:getSpinColFastSpinAction(col)
		local theReelConfig = {
			["col"]     = col,
			["action"]  = theAction,
			["delay"] 	= cacheDelay,
		}
		table.insert(fastStopConfig, theReelConfig)
		cacheDelay = cacheDelay + (addDelay or 0)		
	end
	return fastStopConfig
end

function Theme:checkNeedNotify( pCol )
	return self:checkSpeedUp(pCol)
end

function Theme:getSpinColStartAction( pCol, speedScale )
	local spinConfigIndex  = self.spinActionConfig["start_index"] or 1
	local startActionConfig = nil
	startActionConfig = table.copy(G_START_CONFIG[spinConfigIndex]["normal"])
	startActionConfig["cell_height"] = self.cellHeight
	local spinAction = G_SELF_FUNC:getSpinColStartAction(startActionConfig)
	if speedScale then 
		spinAction.deal_param.obj_speed = spinAction.deal_param.speed * speedScale
	end
	local nextDelay  = startActionConfig["next_delay"]
	return spinAction,nextDelay
end

function Theme:getSpinColStopAction(themeInfoData, pCol, speedScale )
	local specialType = themeInfoData["special_type"]
	local stopAction = G_SELF_FUNC:getSpinColStopAction(stopActionConfig)
	local nextDelay  = stopActionConfig["next_delay"]
	return stopAction,nextDelay
end
function Theme:getSpinColFastSpinAction( pCol, speedScale )
	local spinAction = G_SELF_FUNC:getSpinColFastStopAction(spinActionConfig)
	local nextDelay  = spinActionConfig["next_delay"]
	
	return spinAction,nextDelay
end

-- whj 添加 通用计算主题 延迟时间
function Theme:getCurSpinLayerSpinActionTime(stopDelayList, downBounceT, checkStopColCnt, autoSDMult, autoDBTMult )
    local _stopDelay = stopDelayList[1]
    local _downBounceTime = downBounceT
    if self.spinLayer.spins and #self.spinLayer.spins>0 then
        local tColCnt = #self.spinLayer.spins
        local checkBoardCnt = math.floor(tColCnt/(checkStopColCnt or 5))
        if checkBoardCnt == 1 then 
            _stopDelay = stopDelayList[1]
        elseif checkBoardCnt == 2 then 
            _stopDelay = stopDelayList[2]
        elseif checkBoardCnt >= 3 then 
            _stopDelay = stopDelayList[3]
        end
    end

    if self.isTurbo then 
        _stopDelay = _stopDelay * ( autoSDMult or 1 )
        _downBounceTime = _stopDelay * ( autoDBTMult or 1 )
    end

    return _stopDelay, _downBounceTime
end
-- end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- spin layer相关
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Theme:onReelStart( pCol )
	-- todo	
end
function Theme:onReelStop( pCol )
	-- if not self.reelStopMusicTagList[pCol] then
	-- 	self:dealMusic_StopReelNotifyMusic(pCol)
	-- 	self:dealMusic_PlayReelStopMusic(pCol)
	-- end
	-- self.reelStopMusicTagList[pCol] = true
	self:stopReelNotifyEffect(pCol)
end

function Theme:getUpdateKeyWithIndex( col, index, key )
	local retKey = nil


	return retKey
end

function Theme:checkPlaySymbolNotifyEffect( pCol )
	local reelSymbolState = self.notifyState[pCol]
	if not self.fastStopMusicTag and reelSymbolState and bole.getTableCount(reelSymbolState)>0 then -- 判断是否播放特殊symbol的动画
		self:dealMusic_PlaySpecialSymbolStopMusic(pCol)
		self:playSymbolNotifyEffect(pCol, reelSymbolState)
		self.notifyState[pCol] = {}
		return true
	else
		if pCol == #self.spinLayer.spins then
			local tmp = self.hintMusicCnt
			for k,v in ipairs(self.notifyState) do
			 	if bole.getTableCount(v) > 0 then
					self.hintMusicCnt = self.hintMusicCnt + 1
					self:playSymbolNotifyEffect(k, v)
					self.notifyState[k] = {}
				end
			end
			self:dealMusic_StopReelNotifyMusic()
			if self.hintMusicCnt > tmp then
				self.hintMusicCnt = self.hintMusicCnt - 1 
				self:dealMusic_PlaySpecialSymbolStopMusic(pCol)
				return true
			end
		end

		return false
	end
end
-- 滚轴滚到底部
function Theme:onReelFallBottom( pCol )
	-- 标志位
	self.reelStopMusicTagList[pCol] = true	
	-- 列停音效，提示动画相关
	if not self:checkPlaySymbolNotifyEffect(pCol) then
		self:dealMusic_PlayReelStopMusic(pCol)
	end
	self:stopReelNotifyEffect(pCol)
	-- self:asHintTime(pCol)
end
function Theme:onReelFastFallBottom( pCol )
	self.reelStopMusicTagList[pCol] = true
	-- 列停音效，提示动画相关
	if not self.fastStopMusicTag then
		local hasNotify = false
		for col=pCol,#self.spinLayer.spins do
			local reelSymbolState = self.notifyState[col]
			if reelSymbolState and bole.getTableCount(reelSymbolState)>0 then
				hasNotify = true
				break
			end
		end
		if not hasNotify then
			self:dealMusic_PlayReelStopMusic(pCol)
		end	
		
	end
	self.fastStopMusicTag = self.fastStopMusicTag or "allow_music"
	self:checkPlaySymbolNotifyEffect(pCol)
	self:stopReelNotifyEffect(pCol)
	-- self:asHintTime(pCol)
end
function Theme:onReelNotifyStopBeg( pCol )
	self:playReelNotifyEffect(pCol)	
	self:dealMusic_PlayReelNotifyMusic(pCol)
end

function Theme:asHintTime( pCol )
end

function Theme:hideActivitysNode( ... )
	EventCenter:pushEvent(EVENTNAMES.ACTIVITY_THEME.ALL_HIDE_ACTION)
end
function Theme:showActivitysNode( ... )
	EventCenter:pushEvent(EVENTNAMES.ACTIVITY_THEME.ALL_SHOW_ACTION)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 音效相关
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Theme:configAudioList( )
	self.audio_list =
	{
		-- base
		base_background  		= "audio/base/base_bgm.mp3",
		reel_stop        		= "audio/base/reel_stop.mp3",
		anticipation 	 		= "audio/base/anticipation.mp3", -- 特殊下砸声音
		trigger_bell	 		= "audio/base/bell.mp3",
		symbol_scatter   		= "audio/base/symbol_scatter.mp3",
		reel_notify		 		= "audio/base/reel_notify.mp3",

		transition_free 		= "audio/base/transition_free.mp3", 	-- base 切屏
		transition_bonus 		= "audio/base/transition_bonus.mp3",	-- bonus 切屏
		transition_free_pick 	= "audio/base/transition_free.mp3", 	-- 进入Free之前的 freeRandomPick 游戏 first 游戏

		-- free
		free_background  		= "audio/free/free_bgm.mp3",
		retrigger_bell	 		= "audio/base/bell_fg.mp3",
		theme_store_coin_fly     = "store/audio/theme_store_coins_fly.mp3",
		theme_store_tip          = "store/audio/dialog_in.mp3",

		-- bonus
		bonus_background 		= "audio/bonus/bonus_bgm.mp3",
		wheel_background 		= "audio/wheel/wheel_bgm.mp3",
		-- rollup
		rollup01		 		= "audio/base/win1.mp3",
		rollup01_end	 		= "audio/base/win1end.mp3",
		rollup02		 		= "audio/base/win2.mp3",
		rollup02_end	 		= "audio/base/win2end.mp3",
		rollup03		 		= "audio/base/win3.mp3",
		rollup03_end	 		= "audio/base/win3end.mp3",
		rollup04		 		= "audio/base/win4.mp3",
		rollup04_end	 		= "audio/base/win4end.mp3",

		-- 弹窗
		free_dialog_start_show 	= "audio/free/free_dialog_start_show.mp3",
		free_dialog_start_close = "audio/free/free_dialog_start_close.mp3",
		free_dialog_more_show 	= "audio/free/free_dialog_more_show.mp3",
		free_dialog_more_close  = "audio/free/free_dialog_more_close.mp3",
		free_dialog_collect_show  = "audio/free/free_dialog_collect_show.mp3",
		free_dialog_collect_click = "audio/free/free_dialog_collect_click.mp3",
		free_dialog_collect_close = "audio/free/free_dialog_collect_close.mp3",

		bonus_start_show		= "audio/bonus/bonus_start_show.mp3",
		bonus_end_show			= "audio/bonus/bonus_end_show.mp3",
		pick_start_show			= "audio/pick/pick_start_show.mp3",
		pick_end_show			= "audio/pick/pick_end_show.mp3",
		wheel_start_show		= "audio/wheel/wheel_start_show.mp3",
		wheel_end_show			= "audio/wheel/wheel_end_show.mp3",
		win_jp_show				= "audio/base/win_jp_show.mp3",	  -- win jp 弹窗显示音效
		win_jp_click			= "audio/base/win_jp_click.mp3",  -- win jp 弹窗点击音效
		win_rapidpay_show		= "audio/base/win_rapidpay_show.mp3",  -- win rapidpay 弹窗点击音效	
		win_rapidpay_click		= "audio/base/win_rapidpay_click.mp3",  -- win rapidpay 弹窗点击音效
		common_click 			= "audio/base/click.mp3", -- 通用点击音效
	}

	-- whj 新加 rollup 伴随的人声
	self.audio_win_list = {
		commonrollup03			= "sounds/bigwin/common_win3.mp3",
		commonrollup03_end		= "sounds/bigwin/common_win3end.mp3",
		commonrollup04			= "sounds/bigwin/common_win4.mp3",
		commonrollup04_end		= "sounds/bigwin/common_win4end.mp3",

		peopelrollup01			= "sounds/bigwin/win_bigwin.mp3",
		peopelrollup02			= "sounds/bigwin/win_hugewin.mp3",
		peopelrollup03			= "sounds/bigwin/win_massivewin.mp3",
		peopelrollup04			= "sounds/bigwin/win_apocalypticwin.mp3",
	}
	if self.game_store_version == GameStoreType.SLOT_MACHINE_V or self.game_store_version == GameStoreType.SLOT_MACHINE_H then
		self:initSlotMachineMusic()
	end
end
function Theme:initSlotMachineMusic()
	--slot
	self.slot_audio_list = {}
	self.slot_audio_list.slot_popup = "audio/slot_popup.mp3"
	self.slot_audio_list.slot_spin = "audio/slot_spin.mp3"
	self.slot_audio_list.slot_win = "audio/slot_win.mp3"
end

-- 播放音效
function Theme:playMusic( name, singleton, loop )
	if name and self:isExistFile(name) then
		local audioFile = self:getPic(name)
		AudioControl:playEffect(audioFile,loop, singleton)
	end
end
function Theme:playSlotMusic( name, singleton, loop )
	local file = self.slot_audio_list[name]
	if name then
		local audioFile = self:getSlotPath(file)
		AudioControl:playEffect(audioFile,loop, singleton)
	end
end


-- 播放音效 通用音效
function Theme:playCommonMusic( audioFile, singleton, loop )
	if audioFile and cc.FileUtils:getInstance():isFileExist(audioFile) then
		AudioControl:playEffect(audioFile, loop, singleton)
	end
end

-- 播放音效
function Theme:playEffectWithInterval( name, interval, loop, singleton )
	if name and self:isExistFile(name) then
		local audioFile = self:getPic(name)
		AudioControl:playEffectWithInterval(audioFile,interval, loop, singleton)
	end
end

-- 停止音效
function Theme:stopMusic( name, isCleanSingle )
	if self:isExistFile(name) then
		local audioFile = self:getPic(name)
		AudioControl:stopEffect(audioFile)
	end
end
function Theme:stopSlotMusic( name, singleton, loop )
	local path= self.slot_audio_list[name]
	if path then
		local audioFile = self:getSlotPath(path)
		AudioControl:stopEffect(audioFile,loop, singleton)
	end
end

-- 停止音效 通用音效
function Theme:stopCommonMusic( audioFile, isCleanSingle )
	if cc.FileUtils:getInstance():isFileExist(audioFile) then
		AudioControl:stopEffect(audioFile)
	end
end

-- 播放背景音乐
function Theme:playLoopMusic( name)
	-- if self:isExistFile(name) and bole.isMusicMute() then
	if self:isExistFile(name) then
		local singleton = true
		local loop = true
		local audioFile = self:getPic(name)
		AudioControl:playMusic("music", audioFile, singleton, loop)
	end
	-- end
end

-- 结束所有背景音乐
function Theme:stopAllLoopMusic( )
	AudioControl:stopGroupAudio("music")
end

function Theme:refreshAllAudioVolume( )
	AudioControl:refreshAllAudioVolume()
end
-- 结束背景音乐
function Theme:stopLoopMusicForStage( stageType)
end

-- 播放base game的背景音乐
function Theme:dealMusic_PlayNormalLoopMusic()
	-- 播放背景音乐
	AudioControl:stopGroupAudio("music")
	self:playLoopMusic(self.audio_list.base_background)
end
function Theme:dealRecoverBgm()
	if self and self.audio_list and self.audio_list.base_background then
		self:dealMusic_PlayNormalLoopMusic()
	end
end

-- 播放free games的背景音乐
function Theme:dealMusic_PlayFreeSpinLoopMusic()
	-- 播放背景音乐
	AudioControl:stopGroupAudio("music")
	self:playLoopMusic(self.audio_list.free_background)
       
	AudioControl:volumeGroupAudio(1)
end

-- 播放bonus game的背景音乐
function Theme:dealMusic_EnterBonusGame()
	-- 播放背景音乐
	AudioControl:stopGroupAudio("music")
	self:playLoopMusic(self.audio_list.bonus_background)
       
end

-- 结束bonus game的背景音乐
function Theme:dealMusic_ExitBonusGame()
	local name = self.audio_list.base_background
	local stageType = 1
	if self.ctl.freewin then
		name = self.audio_list.free_background
		stageType = 2
	end

	-- 播放背景音乐
	self:playLoopMusic(name)
       
end

function Theme:dealMusic_ExitPickGame()
	local name = self.audio_list.free_background
	-- 播放背景音乐
	self:playLoopMusic(name)
       
end

-- 转轮停止声音
function Theme:dealMusic_PlayReelStopMusic( pCol )
	self:playEffectWithInterval(self.audio_list["reel_stop"],0.1,false)
end

function Theme:playRollupSound( mul )
	local winLevel
	if mul <= 0 then
		winLevel = nil
	elseif mul < 5 then
		winLevel = 1
	elseif mul < 10 then
		winLevel = 2
	elseif mul < 25 then
		winLevel = 3
	else
		winLevel = 4
	end

	local audioName
	if winLevel then
		if self.audio_win_list["commonrollup0"..winLevel] and self:isExistCommonFile(self.audio_win_list["commonrollup0"..winLevel]) then 
			audioName = self.audio_win_list["commonrollup0"..winLevel]
			self:playCommonMusic(audioName, true, true)
		else
			audioName = self.audio_list["rollup0" .. winLevel]
			local audioName = self.audio_list["rollup0" .. winLevel]
			self:playMusic(audioName, true, true)
		end
		
	end

	-- whj 新加 人声
	local peopelLevel
	if mul >=10 and mul<25 then 
		peopelLevel = 1
	elseif mul >=25 and mul<50 then 
		peopelLevel = 2
	elseif mul >=50 and mul<100 then 
		peopelLevel = 3
	elseif mul >=100 then 
		peopelLevel = 4
	end
	if peopelLevel then 
		local audioName2 = self.audio_win_list["peopelrollup0"..peopelLevel]
		self:playCommonMusic(audioName2)
	end
end

-- 结束rollup声音
function Theme:stopRollupSound( mul )
	local winLevel
	if mul <= 0 then
		winLevel = nil
	elseif mul < 5 then
		winLevel = 1
	elseif mul < 10 then
		winLevel = 2
	elseif mul < 25 then
		winLevel = 3
	else
		winLevel = 4
	end

	if winLevel then
		if self.audio_win_list["commonrollup0" .. winLevel] and self:isExistCommonFile(self.audio_win_list["commonrollup0" .. winLevel]) then 
			local stopAudioName = self.audio_win_list["commonrollup0" .. winLevel]
			self:stopCommonMusic(stopAudioName, true)
		else
			local stopAudioName = self.audio_list["rollup0" .. winLevel]
			self:stopMusic(stopAudioName, true)
		end

		if self.audio_win_list["commonrollup0"..winLevel.."_end"] and self:isExistCommonFile(self.audio_win_list["commonrollup0"..winLevel.."_end"]) then
			local audioName = self.audio_win_list["commonrollup0"..winLevel.."_end"]
			self:playCommonMusic(audioName)
		else
			local audioName = self.audio_list["rollup0" .. winLevel .. "_end"]
			self:playMusic(audioName)
		end

		-- local stopAudioName = self.audio_list["rollup0" .. winLevel]
		-- local audioName = self.audio_list["rollup0" .. winLevel .. "_end"]
		-- self:stopMusic(stopAudioName, true)
		-- self:playMusic(audioName)
	end

	-- whj 新加 人声
	local peopelLevel
	if mul >=10 and mul<25 then 
		peopelLevel = 1
	elseif mul >=25 and mul<50 then 
		peopelLevel = 2
	elseif mul >=50 and mul<100 then 
		peopelLevel = 3
	elseif mul >=100 then 
		peopelLevel = 4
	end
	if peopelLevel then
		local stopAudioName2 = self.audio_win_list["peopelrollup0" .. winLevel]
		self:stopCommonMusic(stopAudioName2, true)
	end
end
-- 结束rollup行为，默认调用stopRollupSound
function Theme:stopRollUpFunction(mul)
	self:stopRollupSound(mul)
end

function Theme:dealMusic_PlayWinMusic( rets, totalBet )
end

-- 进入主题
function Theme:dealMusic_PlayEnterMusic( )
	-- self:laterCallBack(0.8,function ()
	-- 	AudioControl:playSpecialEffect(self:getPic('audio/welcome.mp3'))
	-- end)
	-- self:laterCallBack(0.5,function ()
	-- 	AudioControl:playSpecialEffect(self:getPic('audio/n1.mp3'))
	-- end)
end

-- symbol音效相关
function Theme:dealMusic_PlayThemeItemMusic( name, isSingle )
	-- if isSingle == nil then
	-- 	isSingle = true
	-- end
	self:playMusic(name, isSingle)
end

-- 打铃音效相关
function Theme:dealMusic_PlayTriggerBellMusic()
	self:playMusic(self.audio_list.trigger_bell, false)
end

local delay_fade_out_loop = 123111
function Theme:setDelayToFadeOutLoopMusic( ... ) -- 新增，静音音效
	if self.ctl:noFeatureLeft() and not self.ctl.autoSpin and not self.playDelayFadeOutLoopMusic then 
		self.playDelayFadeOutLoopMusic = true
		self:stopActionByTag(delay_fade_out_loop)

		local action = cc.Sequence:create(
			cc.DelayTime:create(4), 
			cc.CallFunc:create(function()
				self:dealMusic_FadeLoopMusic(2,1,0)
			end))
		action:setTag(delay_fade_out_loop)

		self:runAction(action)
	end

end

function Theme:stopDelayToFadeOutAction( ... )
	self:stopActionByTag(delay_fade_out_loop)
	self:dealMusic_OutMuteLoopMusic()
end

-- 声音从最大声音渐变到静音
function Theme:dealMusic_FadeOutLoopMusic()
	-- if self.nowMusicValue == 0 then
	-- 	return nil
	-- end
	self:dealMusic_FadeLoopMusic(1,1,0)
	-- if not self.fadeMusicActionNode then
	-- 	self.fadeMusicActionNode = cc.Node:create()
	-- 	self:addChild(self.fadeMusicActionNode)
	-- end
	-- local nowMusicVolume = AudioControl:getVolume() or beginVolume
	-- self.fadeMusicTag = true
	-- local groupName   = "loop"
	-- local fadeDur     = 1
 --    local interval    = 1/10
 --    local actionList  = {}
 --    local frame       = math.modf(fadeDur/interval)
 --    local begVolume   = 1
 --    local endVolume   = 0
 --    local perChangeVolume = (endVolume-begVolume)/frame
 --    ----------------------------------------------------------------------
 --    local begDelay    = 1.5
 --    local delayTime   = cc.DelayTime:create(begDelay)
 --    table.insert(actionList, delayTime)
 --    for i = 1, frame do
 --        local changeAction = cc.CallFunc:create(function()
 --        		if self.fadeMusicTag then
	--         		AudioControl:volumeGroupAudio(begVolume+perChangeVolume*i)
	--         	end
 --            end)
 --        local delayTime = cc.DelayTime:create(interval)
 --        table.insert(actionList, delayTime)
 --        table.insert(actionList, changeAction)
 --    end
 --    self.fadeMusicActionNode:runAction(cc.Sequence:create( unpack(actionList) ))
end

-- 延迟delay秒后，经过duration时间，声音从beginVolume线性变化到endVolume
function Theme:dealMusic_FadeLoopMusic(duration, beginVolume, endVolume, delay)
	-- if self.nowMusicValue == endVolume then
	-- 	return nil
	-- end
	
	-- self.nowMusicValue = endVolume
	if not self.fadeMusicActionNode then
		self.fadeMusicActionNode = cc.Node:create()
		self:addChild(self.fadeMusicActionNode)
	end
	local nowMusicVolume = AudioControl:getVolume() or beginVolume
	if (nowMusicVolume - endVolume) < 0.01 and (nowMusicVolume - endVolume) > -0.01 then
		return
	end
	self.fadeMusicTag = true
	local groupName   = "loop"
	local fadeDur     = duration or 1
    local interval    = 1/10
    local actionList  = {}
    local frame       = math.modf(fadeDur/interval)
    local begVolume   = nowMusicVolume or 0
    local endVolume   = endVolume or 1
    local perChangeVolume = (endVolume-begVolume)/frame
    ----------------------------------------------------------------------
    local begDelay    = delay or 0
    local delayTime   = cc.DelayTime:create(begDelay)
    table.insert(actionList, delayTime)
    for i = 1, frame do
        local changeAction = cc.CallFunc:create(function()
			if self.fadeMusicTag then
				AudioControl:volumeGroupAudio(begVolume+perChangeVolume*i)
			end
		end)
        local delayTime = cc.DelayTime:create(interval)
        table.insert(actionList, delayTime)
        table.insert(actionList, changeAction)
    end
    self.fadeMusicActionNode:stopAllActions()
    self.fadeMusicActionNode:runAction(cc.Sequence:create( unpack(actionList) ))
end
-- 滚轮音效相关
function Theme:dealMusic_PlayReelNotifyMusic( pCol ) -- 最后一列激励音效

	if self.playR1Col == nil then
		-- print("whj: self.audio_list.reel_notify,",self.audio_list.reel_notify)
		self:playMusic(self.audio_list.reel_notify, true, true)
	end
	self.playR1Col = pCol
	-- print("whj: self.playR1Col ",self.playR1Col)
end
function Theme:dealMusic_StopReelNotifyMusic( pCol )
	if not self.playR1Col then return end
	
	if self.playR1Col == pCol and pCol < #self.spinLayer.spins and self:checkNeedNotify(pCol+1) then
		return
	end
	self.playR1Col = nil
	self:stopMusic(self.audio_list.reel_notify,true)
end

-- freespin音效相关
function Theme:dealMusic_PlayFSEnterMusic( ) -- 进入freespin 弹窗显示的音效
	self:playMusic(self.audio_list.free_dialog_start_show)
end
function Theme:dealMusic_StopFSEnterMusic( )
	self:stopMusic(self.audio_list.free_dialog_start_show)
end
function Theme:dealMusic_PlayFSEnterClickMusic( )
	self:playMusic(self.audio_list.free_dialog_start_close)
end

-- retrigger
function Theme:dealMusic_PlayFSMoreMusic( )
	self:playMusic(self.audio_list.free_dialog_more_show)
end

function Theme:dealMusic_StopFSMoreMusic( )
	-- self:stopMusic(self.audio_list.retrigger_bell) -- whj 
	-- self:stopMusic(self.audio_list.free_dialog_more_show)
end
function Theme:dealMusic_PlayFSMoreClickMusic( )
	self:playMusic(self.audio_list.free_dialog_more_close)
end

--Free Game 收集音乐
function Theme:dealMusic_PlayFSCollectMusic( )
	self:playMusic(self.audio_list.free_dialog_collect_show)
end
function Theme:dealMusic_StopFSCollectMusic( )
	self:stopMusic(self.audio_list.free_dialog_collect_show)
end
function Theme:dealMusic_PlayFSCollectClickMusic()
	self:playMusic(self.audio_list.free_dialog_collect_click)
end
function Theme:dealMusic_PlayFSCollectEndMusic( )
	self:playMusic(self.audio_list.free_dialog_collect_close)
end


function Theme:playEffect( name, volume)
	local audioFile = "audio/"..name
	if self:isExistFile(audioFile..".mp3") then
		audioFile = self:getPic(audioFile..".mp3")
	elseif self:isExistFile(audioFile..".ogg") then
		audioFile = self:getPic(audioFile..".ogg")
	elseif self:isExistFile(audioFile..".wav") then
		audioFile = self:getPic(audioFile..".wav")
	else
		return
	end
	AudioControl:playEffect(audioFile,false )
end

local tag_n3_playing = 33333
function Theme:dealMusic_NoWinMusic()
	if not self._music_no_Cnt then
		self._music_no_Cnt = 0
		--确定 v.mp3 个数，上限20
		for i=1,20 do
			if self:isExistFile("audio/no win "..i..".mp3") then
				self._music_no_Cnt = self._music_no_Cnt + 1
			else
				break
			end
		end
	end
	if self.NoWinCnt >= 4 and not self.n3_playing and math.random(0,99) < 3 and self._music_no_Cnt>=1 then
		-- AudioControl:playSpecialEffect(string.format(self:getPic("audio/no win %d.mp3"), math.random(1,self._music_no_Cnt)))
		self:lockThemeVoices()
	end
end
function Theme:dealMusic_PlaySpecialSpeedMusic() -- 突然加速的音效(打鼓)
	bole.playMusic("special_speed", nil, nil, self:getPic("audio/"))
end 



 

-- 滚轮音效相关
function Theme:dealMusic_TouchBtnSpinMusic( )
	bole.playMusic("14_reel_click", nil, nil, "sounds/")
end

function Theme:dealMusic_PlaySpecialSymbolStopMusic( pCol )
	self.hintMusicCnt = self.hintMusicCnt + 1
	self:playMusic(self.audio_list["anticipation"])--..self.hintMusicCnt
end


-- bonus game音效
function Theme:dealMusic_PlayBGEnterMusic( )
	self:playMusic("b1")
end
function Theme:dealMusic_StopBGEnterMusic( )
	self:stopMusic("b1")
end
function Theme:dealMusic_PlayBGEnterClickMusic( )
	self:playMusic("b2")
end
function Theme:dealMusic_PlayBGCollectMusic( )
	self:playMusic("b3")
end
function Theme:dealMusic_StopBGCollectMusic( )
	self:stopMusic("b3")
end
function Theme:dealMusic_PlayBGCollectClickMusic( )
	self:playMusic("b4")
end
-- 背景音效相关
local normalLoopAudioFile    = "audio/s0.mp3"
local freespinLoopAuidoFile  = "audio/s1.mp3"
local bonusGameLoopAuidoFile = "audio/s4.mp3"




-- 静音
function Theme:dealMusic_MuteLoopMusic( )
	local groupName = "loop"
	self.nowMusicValue = 0
	AudioControl:volumeGroupAudio(0)
	self:dealMusic_OutLoopMusicFade()
	self:stopActionByTag(777)
end
-- 把声音恢复成最大
function Theme:dealMusic_OutMuteLoopMusic( )
	local groupName = "loop"
	self.nowMusicValue = 1
	AudioControl:volumeGroupAudio(1)
	self:dealMusic_OutLoopMusicFade()
end
-- 设置loop类型音乐的声音大小
function Theme:dealMusic_SetLoopMusic(volume)
	if not volume then return end
	local groupName = "loop"
	self.nowMusicValue = volume
	self:dealMusic_OutLoopMusicFade()
	AudioControl:volumeGroupAudio(volume)
end

-- 停止音乐渐变动作
function Theme:dealMusic_OutLoopMusicFade( )
	if self.fadeMusicActionNode then
		self.fadeMusicTag = false
		bole.cleanAction(self.fadeMusicActionNode)
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 动画相关
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Theme:playSymbolNotifyEffect( pCol, reelSymbolState )
	-- todo
end
function Theme:playReelNotifyEffect( pCol )
	-- todo
end
function Theme:stopReelNotifyEffect( pCol )
	-- todo
end

function Theme:checkInFreeSpin()
	return self.ctl.freewin
end
---------------------------------------------------------
function Theme:cleanStatus( stillEffect )
	self:cleanSpecialSymbolState()
	self:cleanSpecialTagState()
	self:stopDrawAnimate()
end
function Theme:stopDrawAnimate( )
	self:showAllItem()
	self.spinLayer:stopChildActions()
	self:clearAnimate()
	self:clearStoreCoinData()
	-- self:showAllHideItem()
end
function Theme:cleanSpecialTagState( )
	-- todo
end
function Theme:clearAnimate( ... )

	self.animateNode:removeAllChildren()
	if self.themeAnimateKuang then 
		self.themeAnimateKuang:removeAllChildren()
	end
	
	self:cleanAnimateList()
	self:cleanCellState()
end
function Theme:cleanAnimateList( ... )
	self.animatesList = self.animatesList or {}
	for k,node in pairs(self.animatesList) do
		if not node.isRetain then
			node:removeFromParent()
		end
	end
	-- isRetain的节点必须自行删除，因为此表不进行缓冲
	self.animatesList = {}
end

function Theme:cleanCellState( ... ) -- cell visible状态设置成 true
	self.spinLayer:setSymbolStatus(true)
end 

-- 说明：收到spin数据时，是否允许此次spin快速停止
-- 参数：rets, 此次spin的相关结果数据
function Theme:checkCanSetStopBtn( rets )
	return true
end
---------------------------------------------------------
function Theme:getNormalKey( col )
	if self:checkInFreeSpin() and #self.RollSymbolInFreeList>0 then
		local theKey 	= self.RollSymbolInFreeList[math.random(1, #self.RollSymbolInFreeList)]
		return theKey		
	else
		local theKey 	= self.normalKeyList[math.random(1, #self.normalKeyList)]
		return theKey
	end
end

function Theme:getCellPos( col, row ) -- 从上向下 一次 是 123  横向 从做到右 是 123
	local retPos = self.spinLayer:getCellPos( col, row )
	return retPos
end
function Theme:getCellScenePos( col, row )
	local basePos = cc.p(self.spinLayer:getPosition())
	local cellPos = self.spinLayer:getCellPos(col,row)
	local retPos  = cc.pAdd(basePos, cellPos)
	return retPos
end
function Theme:getPic( name )
	return string.format("theme_resource/theme%d/%s", self.themeResourceId, name)
end
function Theme:getSlotPath(name)
	local slotID = self:getThemeSmallSlot()
	return string.format("theme_resource/theme%d/%s", slotID, name)

end
function Theme:getThemeSmallSlot()
	if self.game_store_version == GameStoreType.SLOT_MACHINE_V then
		return 2008
	end
	if self.game_store_version == GameStoreType.SLOT_MACHINE_H then
		return 2009
	end
end
function Theme:addAnimateNode( ... )
	self.animatesList = self.animatesList or {}
	local retNode = cc.Node:create()
	table.insert(self.animatesList, retNode)
	return retNode
end

function Theme:onReelOutOffView( col, cellNode )

end

function Theme:changeItemKey( col, row, key )
	-- local theCellNode 	= self.spinLayer.spins[col]:getRetCell(row)
	-- local theCellFile 	= self.pics[key] or self.specialPics[key]
	-- local theCellSprite = theCellNode.sprite
	-- local itemList  = self.ctl:getRetMatrix()
	-- if itemList then
	-- 	itemList[col][row] = key
	-- end
	-- bole.updateSpriteWithFile(theCellSprite, theCellFile)
	-- theCellNode.key 	  = key
	-- theCellNode.curZOrder = 0
	-- if self.symbolZOrderList[key] then
	-- 	theCellNode.curZOrder = self.symbolZOrderList[key]
	-- end	
	-- if self.symbolPosAdjustList[key] then
	-- 	theCellSprite:setPosition(self.symbolPosAdjustList[key])
	-- else
	-- 	theCellSprite:setPosition(cc.p(0,0))
	-- end		
	-- self:refreshColCellsZOrder(col)
	-- return theCellNode
end
function Theme:changeItemListKey( col, row, key )
	local itemList  = self.ctl:getRetMatrix()
	if itemList then
		itemList[col][row] = key
	end
end
function Theme:changeItemNormalKey( col, row )
	local key 		= self:getNormalKey(col)
	self:changeItemKey(col, row, key)
end

function Theme:showAllItem(showState) -- 没啥作用
	-- for col=1, self.col do
	-- 	local rowCnt = self.colRowList[col]
	-- 	for row=1, rowCnt+2 do --  这种写法 用来 控制 最上面和 最下面在最上层显示
	-- 		local theCellNode = self.spinLayer.spins[col]:getRetCell(row)
	-- 		-- 禁止setVisble(true),相关动画使用透明度来实现,关于动画期间隐藏某cell上的sprite使用setVisible(false)
	-- 		-- theCellNode.sprite:setVisible(true)
	-- 		theCellNode.sprite:setOpacity(255)
	-- 	end
	-- end
end

------------------------------------------------------------------
-- 滚轴相关
------------------------------------------------------------------
function Theme:getFrames(col)
	local n = math.random(10, 20)
	local ret = {}
	for i = 1, n do
		local t = math.random(1,#self.keys)
		ret[i] = self.keys[t]
	end
	return ret
end

-- 假滚轴相关
function Theme:getMainReel( )
	return nil
end
function Theme:getFreeReel( )
	return nil
end
function Theme:getBonusReel( )
	return nil
end
function Theme:getReelRandomIndex(col, reelDataList, isSingleReel)
	local retIndex = math.random(1, #reelDataList)
	if isSingleReel then
		local proIndex = retIndex
		local theIndex = proIndex+1
		local function checkTheIndex()
			local proKey = reelDataList[proIndex]
			local theKey = reelDataList[theIndex]
			if not theKey or not proKey then
				return false
			end
			if proKey == theKey then
				return true
			end
			local theSet = {111, 101}--"b", "d"
			if type(theKey) == "string" and not theSet[theKey] then
				local tbData  = bole.splitStr(theKey, "_")
				local theNum  = tonumber(tbData[2])
				if theNum and theNum==1 then
					return false
				else
					return true
				end
			end
			return false
		end
		while checkTheIndex() do			
			proIndex = retIndex+1
			theIndex = proIndex+1
			retIndex = proIndex
		end
	end
	return retIndex
end

function Theme:genSpecials( pWinPosList ) -- 应该都需要重写 这个方法 如果用到滚轴 激励的 话 -- 或者直接传入keyList
	local theKeySet  = {} -- Set({"w"})

	local speicalKey = self.specialKeyList and Set(self.specialKeyList) or {}
	-- print("whj: speicalKey",tool.lua_to_json(speicalKey))
	local specials 	 = {} -- {["s"]={}, ["b"]={}, ["j"]={}}
	
	if self.specialKeyList then  
		for k , v in pairs(self.specialKeyList) do 
			specials[v] = {}
		end
	else
		specials = {}
	end
	
	local itemList   = self.ctl:getRetMatrix()
	local winPosList = pWinPosList or self.ctl:getWinPosList()
	local winTagList = {}
	for _,crPos in pairs(winPosList) do
		winTagList[crPos[1]]    	   = winTagList[crPos[1]] or {}
		winTagList[crPos[1]][crPos[2]] = true
	end

	-- 关于"s","b","j"三种处理策略的解决方案：
	-- 1，数个数：
	-- 		直接通过specials[theKey]进行播放
	-- 2，payline相关（ej:线3上有3个scatter;线4上有4个scatter;线20上有3个scatter）:
	-- 		后端告知对应symbol所中的线的index,然后结合payline与specials[theKey]进行播放
	-- 		提示策略与数个数相同（每一条线都会串到最后）
	-- 3，从左到右连续出现
	-- 		直接判断specials[theKey][col]是否连续
	if itemList and winPosList then
		for col,colItemList in pairs(itemList) do
			for row,theKey in pairs(colItemList) do
				if theKeySet[theKey] then -- 这部分功能不知道干嘛用的
					specials[theKey] 		= specials[theKey] or {}
					specials[theKey][col] 	= specials[theKey][col] or {}
					if winTagList[col] and winTagList[col][row] then
						specials[theKey][col][row] = "win"
					else
						specials[theKey][col][row] = "normal"
					end
				elseif speicalKey[theKey] then
					specials[theKey][col] 	   	= specials[theKey][col] or {}
					specials[theKey][col][row] 	= true
				-- elseif theKey=="b" then  -- whj 修改 先去掉因为没有特殊的 b,j symbol
				-- 	specials[theKey][col] 		= specials[theKey][col] or {}
				-- 	specials[theKey][col][row] 	= true
				-- elseif theKey=="j" then
				-- 	specials[theKey][col] 		= specials[theKey][col] or {}
				-- 	specials[theKey][col][row]  = true
				end
			end
		end
	end
	self.ctl.specials = specials	
end

function Theme:genSpecialSymbolState( rets )
	rets = rets or self.ctl.rets
	if not self.checkItemsState then
		local cItemList   = rets.item_list
		local checkConfig = self.specialItemConfig
		self.checkItemsState = {}  -- 都已列作为项， 各列各个sybmol相关状态，分为后面有可能，单列就有可能中，已经中了，后续没有可能中了
		self.speedUpState 	 = {}  -- 加速的列控制
		self.notifyState 	 = {}  -- 播放特殊symbol滚轴停止的时候的动画位置
		for itemKey,theItemConfig in pairs(checkConfig) do
			local itemType     = theItemConfig["type"]
			local itemCnt  	   = 0
			local isBreak 	   = false
			if itemType then
				for col=1, #self.spinLayer.spins do
					local colItemList  = cItemList[col]
					local colRowCnt    = self.spinLayer.spins[col].row -- self.colRowList[col]
					local curColMaxCnt = theItemConfig["col_set"][col] or colRowCnt
					-- 判断_当前列之前_是否已经中了feature(通过之前列itemKey个数判断)
					local isGetFeature = false
					if itemCnt >= theItemConfig["min_cnt"] then
						isGetFeature = true
					end

					-- 判断是否可能中feature或者更大的feature   一般用于滚轴加速
					local willGetFeatureInCol = false
					if not isBreak and curColMaxCnt>0 and (itemCnt+curColMaxCnt)>=theItemConfig["min_cnt"] then
						willGetFeatureInCol = true
						-- 此情况下，会进行特殊操作，将其状态记到self.speedUpState中
						self.speedUpState[col] = self.speedUpState[col] or {}
						self.speedUpState[col][itemKey] = true
					end
					
					-- 判断当前列加上之后所有列是否有可能中feature
					local willGetFeatureInAfterCols = false
					if not isBreak then
						local sumCnt = 0
						for tempCol=col, #self.spinLayer.spins do
							sumCnt = sumCnt + (theItemConfig["col_set"][tempCol] or colRowCnt)
						end
						if sumCnt>0 and (itemCnt+sumCnt)>=theItemConfig["min_cnt"] then
							willGetFeatureInAfterCols = true				
						end
					end
					-- 当前列提示相关状态
					self.notifyState[col] = self.notifyState[col] or {}
					if not isBreak and curColMaxCnt>0 and willGetFeatureInAfterCols then
						for row, theItem in pairs(colItemList) do
							if theItem == itemKey then
								self.notifyState[col][itemKey] = self.notifyState[col][itemKey] or {}
								table.insert(self.notifyState[col][itemKey], {col, row})
							end
						end
					end
					-- itemKey对应在此列对应的状态
					--	1==》之前列没有中，当前列有可能中
					--	2==》之前列没有中，当前列不可能中，但后续列有可能中
					--  3==》之前列没有中，当前列和后续列没有可能中
					-- 	4==》之前列已经中，当前列不可能再中，而且后续列也不可能再种中
					-- 	5==》之前列已经中，当前列不可能再中，而且后续列有可能再中
					-- 	6==》之前列已经中，当前列有可能再中更多
					-- 检查提示 			==》1，2，5，6
					-- 不做任何操作		==》4
					-- 停止相关提示动画	==》3
					self.checkItemsState[col] = self.checkItemsState[col] or {}
					self.checkItemsState[col][itemKey] = {}
					self.checkItemsState[col][itemKey]["pos_list"]={}
					if not isGetFeature then
						if willGetFeatureInCol then
							self.checkItemsState[col][itemKey]["state"] = 1
						elseif willGetFeatureInAfterCols then
							self.checkItemsState[col][itemKey]["state"] = 2
						else
							self.checkItemsState[col][itemKey]["state"] = 3
						end
					else
						if willGetFeatureInCol then
							self.checkItemsState[col][itemKey]["state"] = 6
						elseif willGetFeatureInAfterCols then
							self.checkItemsState[col][itemKey]["state"] = 5
						else
							self.checkItemsState[col][itemKey]["state"] = 4
						end
					end
					for row, theItem in pairs(colItemList) do
						if theItem == itemKey then
							itemCnt = itemCnt + 1
							table.insert(self.checkItemsState[col][itemKey]["pos_list"], {col,row})
						end
					end
					if itemType == G_THEME_SYMBOL_TYPE.SERIES then
						local hasTheKey    = false
						for row,theKey in ipairs(colItemList) do
							if theKey == itemKey then
								hasTheKey = true
								break
							end
						end
						if hasTheKey then
							isBreak = true
						end
					end
				end
			end
		end		
	end
end

function Theme:cleanSpecialSymbolState()
	self.checkItemsState = nil
	self.speedUpState 	 = nil
	self.notifyState	 = nil	
end
function Theme:checkSpeedUp(checkCol)
	local isNeedSpeedUp = false
	if self.speedUpState and self.speedUpState[checkCol] and bole.getTableCount(self.speedUpState[checkCol])>0 then
		isNeedSpeedUp = true
	end
	return isNeedSpeedUp
end
function Theme:checkGetNotifyItems(checkCol)
	return self.notifyState[checkCol]
end

function Theme:isExistFile(path)
	return cc.FileUtils:getInstance():isFileExist(self:getPic(path))
end

function Theme:isExistCommonFile(path)
	return cc.FileUtils:getInstance():isFileExist(path)
end

function Theme:laterCallBack(time, func)
	self:runAction(cc.Sequence:create(cc.DelayTime:create(time), cc.CallFunc:create(func)))
end

function Theme:fixEnterBoard()
	return nil
end

----------------jackpot相关-----------------------
function Theme:getThemeJackpotConfig()
	-- 配置格式请参考LuckyDrums
	-- num_of_link, num_of_total, config
	return nil
end

function Theme:initialJackpotNode()
	local jpConfig = self:getThemeJackpotConfig()
	if jpConfig == nil then return end

	-- 配置服务器传来的jackpot
	local link_config       = jpConfig.link_config or {}
	local jackpotController = JackpotControl:getInstance()
	local bet               = self.ctl:getCurTotalBet()
	local baseBet           = self.baseBet
	local betMul            = bet / baseBet
	local allowKList        = jpConfig.allowK or {}
	local allowK            = allowKList[self.themeid] or false
	for i=1, #link_config do
		local jp_level = link_config[i]
		jackpotController:configJackpotUI (self.themeid, jp_level, betMul, self.jackpotLabels[i], allowK, true)
	end

	-- 配置本地的jackpot
	local local_config = jpConfig.local_config or {}
	local startIndex   = #link_config
	for i=1, #local_config do
		local jpValue = local_config[i][2] * bet
		self.jackpotLabels[i+startIndex]:setString(self:formatJackpotMeter(jpValue))

		local max_width = local_config[i][3]
		local max_scale = local_config[i][4]
		if max_width and max_scale then
			bole.shrinkLabel (self.jackpotLabels[i+startIndex], max_width, max_scale)
		end
	end
end

function Theme:updateJackpotByBet(bet)
	local jpConfig = self:getThemeJackpotConfig()
	if jpConfig == nil then return end

	-- 更新服务器传来的jackpot
	local link_config  = jpConfig.link_config or {}
	self.jackpotLabels = self.jackpotLabels or {}
	local baseBet      = self.baseBet
	for i=1, #link_config do
		if self.jackpotLabels[i] then
			self.jackpotLabels[i]:updateBet(bet/baseBet)
		end
	end

	-- 更新本地jackpot
	local local_config = jpConfig.local_config or {}
	local startIndex   = #link_config
	for i=1, #local_config do
		if self.jackpotLabels[i+startIndex] then
			local jpValue = local_config[i][2] * bet
			self.jackpotLabels[i+startIndex]:setString(self:formatJackpotMeter(jpValue))

			local max_width = local_config[i][3]
			local max_scale = local_config[i][4]
			if max_width and max_scale then
				bole.shrinkLabel (self.jackpotLabels[i+startIndex], max_width, max_scale)
			end
		end
	end
end

function Theme:getJackpotValue(incrementList,mul) -- progressive_list  mul 倍数
	local jpConfig = self:getThemeJackpotConfig()
	if jpConfig == nil then return end
	mul = mul or 1
	-- 更新服务器reset值
	local link_config       = jpConfig.link_config or {}
	local incrementList     = incrementList or {}
	local bet               = self.ctl:getCurTotalBet()
	local baseBet           = self.baseBet
	local betMul            = bet / baseBet
	local jpData            = {}
	for i=1, #link_config do
		local increment = incrementList[i] or 0
		jpData[i]       = self:getResetValue(link_config[i],mul) + increment
	end

	-- 更新本地reset值
	local local_config = jpConfig.local_config or {}
	local startIndex   = #link_config
	for i=1, #local_config do
		local jpValue        = local_config[i][2] * bet
		jpData[i+startIndex] = jpValue
	end

	return jpData
end

function Theme:getResetValue(jp_level,mul)
	mul           = mul or 1
	local bet     = self.ctl:getCurTotalBet()
	local baseBet = self.baseBet
	local betMul  = bet / baseBet

	local resetValue = JackpotControl:getInstance():getResetValue(self.themeid, jp_level, betMul) * mul

	return resetValue
end

function Theme:lockJackpotMeters(lock,index)
	local jpConfig = self:getThemeJackpotConfig()
	if jpConfig == nil then return end

	local link_config = jpConfig.link_config or {}
	for i=1, #link_config do
		local single_lock = (index and index == i) or true
		if self.jackpotLabels[i] and single_lock then
			self.jackpotLabels[i]:lockJackpotMeter(lock)
		end
	end

end

function Theme:formatJackpotMeter(n)
	local jpConfig = self:getThemeJackpotConfig()
	if jpConfig == nil then return end

	local allowKList = jpConfig.allowK or {}
	local allowK     = allowKList[self.themeid] or false

	local last = ""
	if allowK then
		n = n / 1000
		n = math.floor(n)
		last = "K"
	end

	return FONTS.format(n, true) .. last

end

function Theme:getBtnFlashInfo()
	return {
		flashFile  		= COMMON_PICS_PATH.."flash.png",
		-- btnStartFile    = self:getPic("xxxxxxxx.png"),
		-- btnCollectFile  = self:getPic("xxxxxxxx.png"),
	}
end

function Theme:lockThemeVoices(time)
	self.n3_playing = true
	self:stopActionByTag(tag_n3_playing)
	local action = cc.Sequence:create(cc.DelayTime:create(time or 3), cc.CallFunc:create(function()
		self.n3_playing = false
	end))
	action:setTag(tag_n3_playing)
	self:runAction(action)
end

function Theme:getHeader( )
	if self.ctl and self.ctl.getHeader then
		return self.ctl:getHeader()
	end
end

function Theme:lockLobbyBtn()
	-- if self.ctl and self.ctl.header then
	-- 	self.ctl.header:LobbyBtnState(false)
	-- end
end

function Theme:unlockLobbyBtn()
	if self.ctl and self.ctl.header then
		self.ctl.header:LobbyBtnState(true)
	end
end

function Theme:unloadPngs(tPngs)
	local textureCache = cc.Director:getInstance():getTextureCache()
	for k,v in pairs(tPngs) do
		local path = ""
		if v[1] == 1 then
			path = self:getPic(v[2])
		else
			path = v[2]
		end
		if path ~= "" then
			textureCache:removeTextureForKey(path)
		end
	end
end

function Theme:preloadPngs(tPngs)
	local textureCache = cc.Director:getInstance():getTextureCache()
	for k,v in pairs(tPngs) do
		local path = ""
		if v[1] == 1 then
			path = self:getPic(v[2])
		else
			path = v[2]
		end
		if path ~= "" then
			cc.Director:getInstance():getTextureCache():addImageAsync(path, function ()
			end)
		end
	end
end

-----------------------------------------------------------------------------------
-- 长屏显示logo 相关
-----------------------------------------------------------------------------------
function Theme:adaptationLongScreen( pro )
	pro = pro or 1.14  -- 1460/1280
	if HEADER_FOOTER_RATE_H >= pro then
		return true
	end
	return false
end
---@desc 适配logo 的Y值和scale
---@param myLogoHeight:logo的height 默认180(1460-1280)
---@param maxScale:适配logo 的size,根据屏幕的增加的宽度适配
---@param apaptType :/1:居中/2:向上/3:靠下（在top增加的空白区域里）
---
function Theme:adaptationLogoLabelPos(myLogoHeight,maxScale,apaptType, activityHeight)
    myLogoHeight = myLogoHeight or 180
    maxScale = maxScale or 1
	apaptType = apaptType or 1
    local winSize = cc.Director:getInstance():getWinSize()
    local Height = math.max(winSize.width, winSize.height)
    local addY = bole.getAdaptWidth() / 2

    local headerHeight = 80
    local activityHeight = activityHeight or 100
    local sticky = (headerHeight + activityHeight)


    local posY = Height / 2 - sticky - addY / 2
	if apaptType == 2 then
		posY = Height / 2 - sticky - myLogoHeight/2
	elseif apaptType == 3 then
		posY = Height / 2 - sticky - addY +myLogoHeight/2
	end
    if bole.isIphoneX() and apaptType < 3 then
        posY = posY - 50
    end
    if bole.isIphoneX() then
        addY = addY - 30
    end
    local addScale = 1
    addScale = (addY * 2) / myLogoHeight
    if addScale > maxScale then
        addScale = maxScale
    end
    return posY, addScale

end
---@desc 添加logo 节点的位置
---@param filePath:logo spine的路径
function Theme:initLongLogoNode(filePath,myLogoHeight,maxScale, animName,apaptType, activityHeight)
    if self:adaptationLongScreen() and filePath then
    	local animName = animName or "animation"
		if not self.longLogoNode then
			self.longLogoNode = cc.Node:create()
			self.mainThemeScene:addChild(self.longLogoNode)
		end
        local posY, addScale = self:adaptationLogoLabelPos(myLogoHeight,maxScale,apaptType, activityHeight)
        local _, s = self:addSpineAnimation(self.longLogoNode, nil, self:getPic(filePath), cc.p(0, posY), animName, nil, nil, nil, true, true)
        s:setScale(addScale)
        self.longLogoLableImg = s
    end
end
function Theme:initLongLogoNodeII(path)
	if  self:adaptationLongScreen() and path then
		local posY, scale = self:getLogoLabelPos()
		--self.logoLabelNode =  self.middle_node
		if not self.longLogoNode then
			self.longLogoNode = cc.Node:create()
			self.mainThemeScene:addChild(self.longLogoNode)
		end
		local _, s = self:addSpineAnimation(self.longLogoNode, nil, self:getPic(path), cc.p(0, 0), "animation", nil, nil, nil, true, true)
		self.logoLabelImg = s
		self.logoLabelImg:setScale(scale)
		bole.adaptComponent(self.logoLabelImg, ComponentType.Top, 0, posY, true)
	end
end




function Theme:getLogoLabelPos()

	local headerHeight = self:getHeaderWidth()
	local activityHeight = self:getBActivityWidth()
	if bole.isIphoneX() then
		headerHeight = headerHeight + self:iphoneXMoveDown()
	end
	local scale = 1
	local emptyPos = bole.getAdaptReelBoardY()*2
	if emptyPos < 180 then
		scale = emptyPos / 180
		if scale > 1.2 then
			scale = 1.2
		end
	end
	local moveY =  bole.getAdaptReelBoardY() + headerHeight + activityHeight
	return moveY, scale
end
function Theme:getHeaderWidth()
	local header_height = 60
	return header_height
end
function Theme:getBActivityWidth()
	return 100
end
function Theme:iphoneXMoveDown()
	return 60
end

-----------------------------------------------------------------------------------
-- 修改bet 相关
-----------------------------------------------------------------------------------
function Theme:changeBet(theBet)
	
end	

function Theme:getRollUpBet(ret) -- 进行 bet 设置
	return nil
end
-----------------------------------------------------------------------------------
-- elephant 主题 相关
-----------------------------------------------------------------------------------
function Theme:onjackpot_diskwin( ... )
 	return 0
end

function Theme:onThemeInfo(specialData,callFunc)
 	if callFunc then
 		callFunc()
 	end
end

function Theme:onSpecialWin( ... )
	return 0
end

function Theme:closeblackFloor()
end

function Theme:onExit( )
	self:unloadRes()
	self:removeListenBaseEvent()
	EventCenter:pushEvent(EVENTNAMES.THEME.EXIT_THEME)

end

function Theme:getFSCollectDelay(fs_win)
	fs_win = fs_win or 0
	local delay = (fs_win > 0 and 2.7 or 0)
	return delay
end

function Theme:updatedFreeSpinCount( remainingCount,totalCount)
	self.ctl.footer:setFreeSpinLabel(remainingCount, totalCount)
	self.ctl.footer:changeFreeSpinLayout()
end

function Theme:setFreeGameRecoverState(data)
	if data["free_spins"] and data["free_spins"] >= 0 then -- 断线重连如果是最后一次freespin 的时候就不在进行这个操作
		self.isFreeGameRecoverState = true
	end
end


-----------------------------------------------------------------------------------
-- 多主题商店 相关
-----------------------------------------------------------------------------------
function Theme:initThemeStoreNodeLayout()
	if not self.isThemeStoreOpen then return end
	local digitals = self.storeLabelDigitals or 7
	local store = self.store_node:getChildByName("store")
	self.storeLayoutList = {}
	local store_logo_node = store:getChildByName("logo_node")
	self.storeLayoutList.logoAniNode = store_logo_node:getChildByName("ani_node")
    local label_node = store:getChildByName("label_node")
	self.storeLayoutList.label = label_node:getChildByName("label_coin")
	inherit(self.storeLayoutList.label, LabelNumRoll)
	local function fontFormat(num)
	    return FONTS.formatByCount2(num, digitals, true)
	end
	self.storeLayoutList.label:nrInit(0, 25, fontFormat)
	self.storeCredits = self.store_data.map_credits or 0
	self.storeLayoutList.label:setString(FONTS.formatByCount2(self.storeCredits,digitals,true))
	self:showOrHideStoreNode(true)
end

function Theme:showStoreNodeLogoLoopAnimation()
	if not self.storeLayoutList.logoAniNode then return end
	local file = self:getPic("store/spine/store_logo/spine")
	self:addSpineAnimation(self.storeLayoutList.logoAniNode,nil,file,cc.p(0,0),"animation1",nil,nil,nil,true,true,nil)
end

function Theme:enableStoreBtn(enable,isFirst)
	if not self.btn_storeOpen or not self.btn_storeInfo or not self.isThemeStoreOpen then return end
	local isShow = enable and self.ctl and not self.ctl.autoSpin
	self.btn_storeOpen:setVisible(isShow)
	self.btn_storeOpen:setTouchEnabled(isShow)
	self.btn_storeInfo:setVisible(isShow)
	self.btn_storeInfo:setTouchEnabled(isShow)
	
	if enable and isFirst then
		self:initStoreOpenBtnEvent(self.btn_storeOpen)
		self:initStoreInfoBtnEvent(self.btn_storeInfo)
	end
end

function Theme:initStoreOpenBtnEvent(btn)
	-- 点击按钮
	local pressFunc = function(obj)
	    -- btn:setTouchEnabled(false)
        self:openStore(btn)
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end

	-- 设置按钮
	btn:addTouchEventListener(onTouch)
end

function Theme:openStore(btn)
	if not self.store_data then return end
	local digitals = self.storeLabelDigitals or 7
	local data = self.store_data
	--local data = {}
	data.themeCtl = self.ctl
	data.theme = self
	data.delay = 0
	local endCallFunc = function()
		self:enableStoreBtn(true)
		self.storeCredits = self.store_data.map_credits or 0
		self.storeLayoutList.label:setString(FONTS.formatByCount2(self.storeCredits,digitals,true))
	end

	-- PopupController:getInstance():popupDialogDirectly("theme_store_game", data,endCallFunc)
	self:showStoreDialog(data, endCallFunc)
end

function Theme:showStoreDialog(data, callback)
	if self.game_store_version == GameStoreType.PUZZLE_II_V then
		PopupController:getInstance():popupDialogDirectly("theme_store_game2", data, callback)
	elseif self.game_store_version == GameStoreType.PUZZLE_I_V then
		PopupController:getInstance():popupDialogDirectly("theme_store_game", data, callback)
	elseif self.game_store_version == GameStoreType.PUZZLE_II_H then
		PopupController:getInstance():popupDialogDirectly("theme_store_game2horizon", data, callback)
	end
end

function Theme:initStoreInfoBtnEvent(btn)
	-- 点击按钮
	local pressFunc = function(obj)
	    -- btn:setTouchEnabled(false)
        self:showThemeStoreTipDialog(1)
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end

	-- 设置按钮
	btn:addTouchEventListener(onTouch)
end

function Theme:showOrHideStoreNode(isShow)
	if not self.isThemeStoreOpen then return end
	if isShow then
	    self.store_node:setVisible(isShow)
	    self.storeLayoutList.logoAniNode:removeAllChildren()
		self:showStoreNodeLogoLoopAnimation()
	else
		self.store_node:setVisible(false)
		self.storeLayoutList.logoAniNode:removeAllChildren()
	end
end

function Theme:updateDataOutOfStore(data)
	self.store_data = self.store_data  or {}
	self.store_data.card_status = data.card_status
	self.store_data.map_credits = data.map_credits
	self.store_data.puzzle_page = data.puzzle_page
	self.store_data.duplicate_list = data.duplicate_list
	self.store_data.progress_list = data.progress_list
	self.store_data.disconnection = data.disconnection
	self.store_data.first_time_guide = data.first_time_guide
end

function Theme:getThemeStoreData(data,store_type)
	local store_data = {}
	store_data.avg_bet          = data[store_type].avg_bet
	store_data.card_status      = data[store_type].card_status
	store_data.map_credits      = data[store_type].map_credits
	store_data.puzzle_page      = data[store_type].puzzle_page
	store_data.duplicate_list   = data[store_type].duplicate_list
	store_data.progress_list    = data[store_type].progress_list
    store_data.disconnection    = data[store_type].disconnection
    store_data.fg_disconnection = data[store_type].fg_disconnection
    store_data.first_time_guide = data[store_type].first_time_guide

	return store_data
end


function Theme:playStoreCoinsFlyAnimation(data,end_pos,coin_pos,move_time,scale)
	if not data then return end

	local function clearPreviousAnimation()
		if self.storeFlyNodeList then
			for k,v in pairs(self.storeFlyNodeList) do
				v:stopAllActions()
				v:removeAllChildren()
			end
		end
		self.storeCoinsFlyNode:removeAllChildren()
		self.storeFlyNodeList = nil		
	end
	clearPreviousAnimation()
	self.storeFlyNodeList = {}
	
	local file = self:getPic("store/spine/store_coins/spine")
	coin_pos = coin_pos or self.coin_pos or cc.p(40,-35)
	end_pos = end_pos or cc.pAdd(cc.p(self.store_node:getPosition()),cc.p(390,640))
	end_pos = cc.pSub(end_pos,coin_pos)
	move_time = move_time or 0.5
    for i = 1,bole.getTableCount(data) do
    	for j = 1,bole.getTableCount(data[i]) do
    		if data[i][j] > 0 then
    			local key = data[i][j]/5
    			local aniName1 = "animation"..key
    			local aniName2 = "animation"..key.."_1"

    			self.storeFlyNodeList[i.."_"..j] = cc.Node:create()
    			self.storeCoinsFlyNode:addChild(self.storeFlyNodeList[i.."_"..j])
    			local cell = self.spinLayer.spins[i]:getRetCell(j)
    			local pos = self:getCellPos(i,j)
    			--print("wy_playStoreCoinsFlyAnimation",pos,pos.x,pos.y)
    			self.storeFlyNodeList[i.."_"..j]:setPosition(pos)
    			self.storeFlyNodeList[i.."_"..j]:runAction(cc.Sequence:create(
    				cc.CallFunc:create(function()
    					local _, s = self:addSpineAnimation(self.storeFlyNodeList[i.."_"..j],nil,file,coin_pos,aniName1,nil,nil,nil,false,false,nil)
    					s:setScale(scale or 1)
    					self:stopMusic(self.audio_list.theme_store_coin_fly)
    					self:playMusic(self.audio_list.theme_store_coin_fly,true)
    					if cell.coinSprite then
    						cell.coinSprite:removeAllChildren()
    						cell.coinSprite:setVisible(false)
    					end
    				end),
    				cc.DelayTime:create(0.3),
    				cc.CallFunc:create(function()
    					local _, s = self:addSpineAnimation(self.storeFlyNodeList[i.."_"..j],nil,file,coin_pos,aniName2,nil,nil,nil,false,false,nil)
						s:setScale(scale or 1)
    				end),
    				cc.MoveTo:create(move_time,end_pos),		
    				cc.CallFunc:create(function()					
    					self.storeFlyNodeList[i.."_"..j]:removeAllChildren()    					
    				end)
    			))
    		end
    	end
    end
    self:laterCallBack(0.8,function()
		self:showStoreNodeReceiveCoinsAnimation()
	end)
end

function Theme:showStoreNodeReceiveCoinsAnimation()
	if self.storeLayoutList.label then
		local rollupDuration = 0.5
		local new_value = self.store_data.map_credits or 0
		--print("wy_showStoreNodeReceiveCoinsAnimation_label","old_value= ",self.storeCredits,"new_value= ",new_value)
		self.storeLayoutList.label:nrStartRoll(self.storeCredits,new_value,rollupDuration)
		self.storeCredits = new_value
		-- local oriScaleX = self.storeLayoutList.label:getScaleX()
		-- local oriScaleY = self.storeLayoutList.label:getScaleY()
		-- self.storeLayoutList.label:runAction(cc.Sequence:create(
		-- 	cc.CallFunc:create(function()
		-- 		local value = self.store_data.map_credits or 0
		-- 		print("wy_showStoreNodeReceiveCoinsAnimation_value",value)
		-- 		self.storeLayoutList.label:setString(FONTS.formatByCount2(value,7,true))
		-- 	end),
		-- 	cc.ScaleTo:create(0.2,oriScaleX*1.5,oriScaleY*1.5),			
		-- 	cc.ScaleTo:create(0.1,oriScaleX,oriScaleY)
		-- ))
	end
	if self.storeLayoutList.logoAniNode then 
		local file = self:getPic("store/spine/store_logo/spine")
		local function callback()
			self.storeLayoutList.logoAniNode:removeAllChildren()
			self:showStoreNodeLogoLoopAnimation()
		end
		--self.storeLayoutList.logoAniNode:removeAllChildren()
		self:addSpineAnimation(self.storeLayoutList.logoAniNode,5,file,cc.p(0,0),"animation2",nil,nil,nil,false,false,nil)
	end
	
end


function Theme:fixStoreCoinsRet(item_list) -- 用于正常停止时的Coin数据重构
	--print("wy_fixStoreCoinsRet",tool.lua_to_json(item_list))
	self.ctl.resultCoinsCache = {}
	for k,v in pairs (item_list) do
		local reelList = tool.tableClone(v)
		table.insert(reelList,1,0) -- 插入 第一条数据
		if self.isTurbo then
			for i=1,3 do -- 插入后面几条数据
				reelList[#reelList+1] = 0
			end
		else
			for i=1,6 do -- 插入后面几条数据
				reelList[#reelList+1] = 0
			end
		end

		table.insert(self.ctl.resultCoinsCache,reelList)
	end
end

function Theme:clearStoreCoinData()
	self.ctl.resultCoinsCache = {}
end

function Theme:updateCellOtherAssets(theCellNode, key, col) -- 更新Cell Sprite上其他图片，如商店角标Coins
	if not self.storeCoinsComeList then return end
	if not self.showReSpinBoard then
		local coin_pos = self.coin_pos or cc.p(40,-35)
		if self.storeCoinsComeList and theCellNode and key and key > 0 then
			local theSpriteFile = "#theme_store_coin"..key..".png"
			if not theCellNode.coinSprite then
				theCellNode.coinSprite = cc.Node:create()
				theCellNode:addChild(theCellNode.coinSprite,100)
			end
			local sprite = bole.createSpriteWithFile(theSpriteFile)
			sprite:setPosition(coin_pos)
			sprite:setVisible(true)
			theCellNode.coinSprite:addChild(sprite)
			theCellNode.coinSprite:setVisible(true)
		end		
	end
end

function Theme:updateCellFastOtherAssets(pCol) --暂时不用
	if self.storeCoinsComeList and bole.getTableCount(self.storeCoinsComeList) > 0 then
		local coin_pos = self.coin_pos or cc.p(40,-35)
		for i = 1,bole.getTableCount(self.storeCoinsComeList[pCol]) do
			local key = self.storeCoinsComeList[pCol][i]
			if key > 0 then
				local theSpriteFile = "#theme_store_coin"..key..".png"
				local cell = self.spinLayer.spins[pCol]:getRetCell(i)
				if not cell.coinSprite then
					cell.coinSprite = cc.Node:create()
					cell:addChild(cell.coinSprite)
				end
				local sprite = bole.createSpriteWithFile(theSpriteFile)
				sprite:setPosition(coin_pos)
				cell.coinSprite:addChild(sprite)
			end
		end
	end
end
function Theme:getCoinInfoKey(col)
	if not self.storeCoinsComeList then return end
	col = col or 1
	local key = self.storeCoinsComeList[col][1]
	return key
end

function Theme:getFlyCoinsData(data)
	self.storeCoinsComeList = nil
	if data["theme_info"] and data["theme_info"]["map_credit_list"] then
		self.storeCoinsComeList = data["theme_info"]["map_credit_list"]
		self:fixStoreCoinsRet(self.storeCoinsComeList)
	end
	--print("wy_getFlyCoinsData",tool.lua_to_json(data["theme_info"]))
end

-- store Tip
function Theme:showThemeStoreTipDialog(tip_type,callback)
	-- if self.themeStoreTipDialog then return end 
	tip_type = tip_type or 1
	local data = {}
	data.type = tip_type
	local endCallFunc = function()
	 --    if not self.ctl.autoSpin then
		--    self:enableStoreBtn(true)
		-- end
		self.themeStoreTipDialog = nil
	end
	--PopupController:getInstance():addDialogToPopupTail("theme_store_tip", data, endCallFunc)
	self.themeStoreTipDialog = ThemeStoreGameTipsDialog.new(data,self,endCallFunc)
	self.themeStoreTipDialog:show()
end

function Theme:hideThemeStoreTipDialog()
	if not self.themeStoreTipDialog then return end 
	self.themeStoreTipDialog:hide()
end

function Theme:runStartAni()
	
end

--------------------------------------------------------
     -- tip 类
--------------------------------------------------------


ThemeStoreGameTipsDialog = class("ThemeStoreGameTipsDialog", CCSNode)

local tip_type = 
{
	rules = 1,
	unfinish = 2,
}


function ThemeStoreGameTipsDialog:ctor(data,theme,callback) 
	self.tip_type = data.type or 1
	self.theme = theme
	self.csb  = self.theme:getPic("store/csb/store_tips.csb")
	self.callback = callback
	self.isPortrait = true
	if self.isPortrait then
	   
	end
	CCSNode.ctor(self, self.csb)
end

function ThemeStoreGameTipsDialog:loadControls()
	self.dimmer = self.node:getChildByName("dimmer_node")
	self.dimmer:setOpacity(0)
	self.dimmer:setVisible(true)
	self.pop_node = self.node:getChildByName("pop_node")
	self.pop_node:setScale(0)
	self.pop_node:setVisible(true)

	local tip_rule_node = self.pop_node:getChildByName("rule_tip")
	local tip_unfinis_node = self.pop_node:getChildByName("unfinish_tip")
	if self.tip_type == tip_type.rules then
		tip_unfinis_node:setVisible(false)
	elseif self.tip_type == tip_type.unfinish then
		tip_rule_node:setVisible(false)
	end

	self.btn_close = self.pop_node:getChildByName("btn_close")
end

function ThemeStoreGameTipsDialog:show()
	self.theme.curScene:addToContentFooter(self)
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.dimmer:runAction(cc.FadeIn:create(0.3))
			self.pop_node:runAction(cc.Sequence:create(
				cc.ScaleTo:create(0.3,1.2,1.2),
				cc.ScaleTo:create(0.1,1,1)
			))
			self.theme:playMusic(self.theme.audio_list.theme_store_tip)
		end),
		cc.DelayTime:create(0.35),
		cc.CallFunc:create(function()
			self.pop_node:runAction(cc.Sequence:create(
				cc.DelayTime:create(5),
				cc.CallFunc:create(function()
					self:hide()
				end)
			))
			self.btn_close :setTouchEnabled(true)
			self:initCloseEvent()
		end)
	))
end

function ThemeStoreGameTipsDialog:initCloseEvent()
	local pressFunc = function(obj)
	    self.btn_close:setTouchEnabled(false)
	    self:hide()
	end

	local function onTouch(obj, eventType)
		if eventType == ccui.TouchEventType.ended then
			pressFunc(obj)
		end
	end
	-- 设置按钮
	self.btn_close:addTouchEventListener(onTouch)
end

function ThemeStoreGameTipsDialog:hide()
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function()
			self.pop_node:stopAllActions()
			self.dimmer:runAction(cc.FadeOut:create(0.3))
			self.pop_node:runAction(cc.FadeOut:create(0.3))
		end),
		cc.DelayTime:create(0.35),
		cc.CallFunc:create(function()
			if self.callback then
				self.callback()
			end
		end),
		cc.RemoveSelf:create()
	))
end







