

local parentClass = ThemeBaseViewControlDelegate
ThemeBaseStoreVControl = class("ThemeBaseStoreVControl", ThemeBaseViewControlDelegate)
local cls = ThemeBaseStoreVControl

function cls:ctor(_mainViewCtl)

	parentClass.ctor(self, _mainViewCtl)
	-- self._mainViewCtl = _mainViewCtl
	-- self.node = cc.Node:create()
	-- self._mainViewCtl:getCurScene():addToContent(self.node)
	-- self.gameConfig = self:getGameConfig()

	-- self:initPotpCmd()
end

-- need rewrite 初始化节点 newView 
function cls:initLayout( nodesList )
	self._view = ThemeBaseStoreView.new(self, nodesList)
end

-- 解锁相关 
function cls:changeStoreLockState(shouUnlock)
	self._view:changeStoreLockState(shouUnlock)
end

-- need rewrite
function cls:storeStopCtl(stopRet)
	if stopRet.theme_info then 
		self.featurePoints = stopRet.theme_info.map_points
		if stopRet.theme_info.delta_map_info then 
			local themeMap = stopRet.theme_info.delta_map_info
			if themeMap.delta_map_points and themeMap.delta_map_points > 0 then 
				self.collectStore = true
				-- self.flyCoinList = tool.tableClone()
				-- store related
				self:getFlyCoinsData(themeMap.delta_map_pos)
			else
				self:updateBaseShowFeatureCnt()
			end
		end
	end
end

function cls:checkHasStoreCollect( )
	return self.collectStore
end

-- need rewrite
function cls:refreshStoreData(data)

    self.isThemeStoreOpen = true
    if data.theme_map and self.theme_map.credits then
        self.featurePoints = self.theme_map.credits
    end
end


function cls:getFlyCoinsData(delta_map_pos)

	self.storeCoinsComeList = nil
	if delta_map_pos then
		self.storeCoinsComeList = delta_map_pos
		self:fixStoreCoinsRet(self.storeCoinsComeList)
	end
end

function cls:fixStoreCoinsRet(item_list) -- 用于正常停止时的Coin数据重构
	self.resultCoinsCache = {}
	local isTurbo = self._mainViewCtl:getIsTrubo()
	for k,v in pairs (item_list) do
		local reelList = tool.tableClone(v)
		table.insert(reelList,1,0) -- 插入 第一条数据
		if isTurbo then
			for i=1,3 do -- 插入后面几条数据
				reelList[#reelList+1] = 0
			end
		else
			for i=1,6 do -- 插入后面几条数据
				reelList[#reelList+1] = 0
			end
		end

		table.insert(self.resultCoinsCache, reelList)
	end
end

function cls:onSpinStartStore( )
	self.storeCoinsComeList = nil
	self.collectStore = nil

	if self.isStoreClick then
		self:closeStoreNode( true )
	end
end

function cls:clearStoreCoinData( ... )
	self.resultCoinsCache = nil
end

-- need rewrite
function cls:updateBaseShowFeatureCnt(value)
end

function cls:updateCellStoreAssets(cell,colid)

	if self.isThemeStoreOpen and self.resultCoinsCache and #self.resultCoinsCache > 0 then
		local theCoinKey = table.remove(self.resultCoinsCache[colid], #self.resultCoinsCache[colid])
		self._view:updateCellStoreAssets(cell,theCoinKey,colid)
	end
end

function cls:updateCellFastStoreAssets(pCol)
	
	if self.storeCoinsComeList and self.storeCoinsComeList[pCol] and bole.getTableCount(self.storeCoinsComeList[pCol]) > 0 then
		local coin_pos = self.coin_pos or cc.p(40,-35)
		
		self._view:updateCellFastStoreAssets(pCol, self.storeCoinsComeList[pCol])
	end

end

function cls:asHintTimeStore(col) 
    if self.storeCoinsComeList and self.storeCoinsComeList[col] then
    	self._view:addStoreCoinsAnim(col, self.storeCoinsComeList[col])
    end
end

function cls:showThemeInfoCollectStore(ret, nextFunc)
	self.collectStore = false
	local coinFlyTotalTime = self.gameConfig.store_config and self.gameConfig.store_config.coinFlyTotalTime
    if self.storeCoinsComeList and bole.getTableCount(self.storeCoinsComeList) > 0 then
		local _flyCoinList = tool.tableClone(self.storeCoinsComeList)

		self._view:clearCellStoreSpriteByList(_flyCoinList)

		self.node:runAction(cc.Sequence:create(
			cc.CallFunc:create(function ( ... )
				self._view:playCollectCellCoinsAnim()
			end),
			cc.DelayTime:create(coinFlyTotalTime or 0.5),
			cc.CallFunc:create(function(...)

				self:storeCollectOverShow()

				if nextFunc then 
					nextFunc(ret)
				end
			end)
		))
    else
        if nextFunc then 
			nextFunc(ret)
		end
    end
end

------------------------------------------------------------------------------------------------------------------------------
-- @store node start
function cls:showStoreNode()
    if self.isStoreClick then
        return
    end
    self.isStoreClick = true
    self:setFooterBtnsEnable(false) -- 禁掉按钮
	self:hideActivitysNode()
	self:hideBoosterDimmer()
	self:resetStoreData()
	self._view:initAndShowStoreNode()
end

function cls:closeStoreNode(isAnim)
    if not self.isStoreClick then
        return
    end
    self.isStoreClick = false

    self._view:playCloseStoreAnim(isAnim)

    if self._mainViewCtl:noFeatureLeft() then
    	self:setFooterBtnsEnable(true)
        self:showActivitysNode()
    end
end

function cls:isShowStoreNode( ... )
	return self.isStoreClick
end

function cls:themeBuySpecial(special_data)
	special_data = special_data or {}
	bole.potp:send(THEME_MAP,special_data,true)
end


-----------------------------------------------------------------------------------------------------------------
-- @协议相关
function cls:registerCmd( cmd ) -- 注册相关事件回调
	bole.potp:registerCmd(cmd, self.oncmd, self)
end
function cls:getCmds( )
	return {THEME_MAP}
end
function cls:initPotpCmd() -- 服务器命令初始化 进行实践注册
	local cmds = self:getCmds()
	for _,c in pairs(cmds) do
		self:registerCmd(c)
	end
end

function cls:unregisterPotpCmds()
	local cmds = self:getCmds()
	for _,c in pairs(cmds) do
		bole.potp:unregisterCmd(c)
	end
end

function cls:oncmd(cmd, data) -- 回调方法
	if self._mainViewCtl and (not self._mainViewCtl:getRequestStatus()) then 
		return
	end
	if cmd == THEME_MAP then 
		if self.overBuySpecialItem then self:overBuySpecialItem(data) end
	end
end

-----------------------------------------------------------------------------------------------------------------
function cls:onExit( ... )
	self:unregisterPotpCmds()
end
-----------------------------------------------------------------------------------------------------------------

function cls:checkUnlockBtnCanTouch()
	return self._mainViewCtl:featureBtnCheckCanTouch()
end

function cls:unlockBtnClickEvent(_jptype)
	self._mainViewCtl:featureUnlockBtnClickEvent(_jptype)
end

function cls:checkFeatureIsLock( ftype )
	return self._mainViewCtl:checkFeatureIsLock( ftype )
end

