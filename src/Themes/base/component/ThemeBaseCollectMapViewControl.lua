


ThemeBaseCollectMapViewControl = class("ThemeBaseCollectMapViewControl", ThemeBaseViewControlDelegate)
local cls = ThemeBaseCollectMapViewControl

function cls:ctor(_mainViewCtl)
	self._mainViewCtl = _mainViewCtl

	self.node = cc.Node:create()
	self._mainViewCtl:getCurScene():addToContent(self.node)

	self.gameConfig = self:getGameConfig()
end

-- function cls:initLayout( nodesList )
	
-- end

-- function cls:changeCollectLockState(shouUnlock)
-- 	self.collectView:changeCollectLockState(shouUnlock)
-- end

-- function cls:resetBoardShowByFeature( state )
-- 	self.collectView:resetBoardShowByFeature(  state )
-- end

-- -- ---------------------------------------------------------------------------------------------------------------------------------------
-- --@ 状态显示相关
-- function cls:hasMapData( mapInfo )
-- 	return self.mapLevel and self.mapPoints
-- end

-- function cls:updateMapData( mapInfo )
-- 	local _mapConfig = self.gameConfig.mapConfig

-- 	local _mapPoints 	= mapInfo.map_points
-- 	if _mapPoints > _mapConfig.maxMapPoints then
-- 		self.mapPoints = _mapConfig.maxMapPoints
-- 	elseif _mapPoints < 0 then
-- 		self.mapPoints = 0
-- 	else
-- 		self.mapPoints = _mapPoints
-- 	end
-- 	self.mapLevel 		= mapInfo.map_level
-- end

-- function cls:updateMapDataAndShowByEndFree( ... )
-- 	if self.mapLevel >= self.gameConfig.mapConfig.maxMapLevel then 
-- 		self.mapLevel = 0
-- 	end
-- 	self.mapPoints = 0

-- 	self:refreshMapDataShow()
-- end

-- function cls:refreshMapDataShow(  )
-- 	self:setCollectProgressImagePos()
-- 	self:setNextCollectTargetImage()
-- end

-- function cls:showCollectProgress( rets, curMapPoints, _mapPoints )
-- 	local _mapConfig = self.gameConfig.mapConfig

-- 	local isFull = _mapPoints >= _mapConfig.maxMapPoints

-- 	self.node:runAction(cc.Sequence:create(
-- 		cc.CallFunc:create(function ( ... )
-- 			self:showCoinsFlyToUp(rets) -- 显示收集动画
-- 		end),
-- 		cc.DelayTime:create(_mapConfig.flyToUpTime),
-- 		cc.CallFunc:create(function ( ... )
-- 			self:showProgressAnimation(_mapPoints, curMapPoints, isFull)
-- 			self:checkHasWinInThemeInfo(rets)	
-- 		end)))
-- end

-- function cls:showCoinsFlyToUp(rets)
-- 	self.collectView:showCoinsFlyToUp(rets)

-- end

-- function cls:showProgressAnimation(map_points, curMapPoints, isFull)
-- 	local _mapConfig = self.gameConfig.mapConfig

-- 	if map_points > _mapConfig.maxMapPoints then
-- 		map_points = _mapConfig.maxMapPoints
-- 	elseif map_points < 0 then
-- 		map_points = 0
-- 	end

-- 	local oldPosX 	= _mapConfig.movePerUnit * curMapPoints + _mapConfig.progressStartPosX
-- 	local startPos 	= cc.p(oldPosX, _mapConfig.progressPosY)
-- 	local newPosX 	= _mapConfig.movePerUnit * map_points + _mapConfig.progressStartPosX
-- 	local endPos 	= cc.p(newPosX, _mapConfig.progressPosY)

-- 	self.collectView:playProgressMoveAnim(startPos, endPos)

-- 	if isFull then 
-- 		self.node:runAction(
-- 			cc.Sequence:create(
-- 				cc.DelayTime:create(_mapConfig.singleMoveTime),
-- 				cc.CallFunc:create(function ( ... )
-- 					self:fullCollectAnimation()
-- 				end)))
-- 	end
-- end


-- function cls:setNextCollectTargetImage(level)
-- 	local _mapConfig = self.gameConfig.mapConfig
-- 	local level = level or self:getMapLevel()

-- 	if not level then return end

--     level = level + 1
--     if level > _mapConfig.maxMapLevel then
--         level = 1
--     end
--     local showIndex = self.gameConfig.mapLevelConfig[level]

--     self.collectView:setNextCollectTargetImageByLevel(showIndex)

-- end

-- function cls:setCollectProgressImagePos(map_points) -- 显示 进度的点数
-- 	local _mapConfig = self.gameConfig.mapConfig
-- 	local map_points = map_points or self:getMapPoints()

-- 	if not map_points then return end
	
-- 	if map_points > _mapConfig.maxMapPoints then
-- 		map_points = _mapConfig.maxMapPoints
-- 	elseif map_points < 0 then
-- 		map_points = 0
-- 	end

-- 	local cur_posX = _mapConfig.movePerUnit * map_points + _mapConfig.progressStartPosX

-- 	self.collectView:setCollectProgress(cur_posX)
-- end

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- -- @ 集满动画
-- function cls:fullCollectAnimation()
-- 	self:playMusicByName("collect_full")

-- 	self.collectView:addfullCollectAnim()
-- end

-- function cls:stopCollectPartAnimation()
-- 	self.collectView:removeCollectFullAnimation()
-- end

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- --@ 地图相关
-- function cls:showStoreNode(isBonus)
--     local data = {}
--     data["mapLevel"] = self:getMapLevel()
--     data["mapPoints"] = self:getMapPoints()

--     self._mainViewCtl:setFeatureState(self.gameConfig.FeatureName.OpenMap, true)
--     self.isOpenStore = true
--     local theDialog = ThemeBaseMapGame_33.new(self, self:getPic("csb/map/"), data, self.gameConfig.mapConfig)
--     theDialog:showMapScene(isBonus)
--     self.storeNode = theDialog
-- end

-- function cls:closeStoreNode(isCollect)
--     if not self.isOpenStore then
--         return
--     end
--     self._mainViewCtl:setFeatureState(self.gameConfig.FeatureName.OpenMap, false)
--     self.isOpenStore = false

--     if isCollect then
--         self._mainViewCtl:setFooterBtnsEnable(true)
--     end

-- end

-- function cls:refreshNotEnoughMoney()
--     self:closeStoreNode()
-- end

---------------------------------------------------------------------------------------------------------------------------------------
--@ mainControl 方法
function cls:getMapLevel()
	return self.mapLevel -- self._mainViewCtl:getMapLevel()
end
function cls:getMapPoints()
	return self.mapPoints -- self._mainViewCtl:getMapPoints()
end
function cls:getCellPos(col, row)
	return self._mainViewCtl:getCellPos(col, row)
end

function cls:getPic(name)
	return self._mainViewCtl:getPic(name)
end

function cls:getGameConfig()
	return self._mainViewCtl:getGameConfig()
end


function cls:playMusicByName(name, singleton, loop)
	self._mainViewCtl:playMusicByName(name, singleton, loop)
end

function cls:checkHasWinInThemeInfo( rets )
	self._mainViewCtl:checkHasWinInThemeInfo( rets )
end

function cls:checkUnlockBtnCanTouch()
	return self._mainViewCtl:featureBtnCheckCanTouch()
end

function cls:unlockBtnClickEvent(_jptype)
	self._mainViewCtl:featureUnlockBtnClickEvent(_jptype)
end

function cls:checkFeatureIsLock( ftype )
	return self._mainViewCtl:checkFeatureIsLock( ftype )
end

function cls:hideActivitysNode()
	self._mainViewCtl:hideActivitysNode( )
end

function cls:showActivitysNode()
	self._mainViewCtl:showActivitysNode( )
end

function cls:setFooterBtnsEnable( state )
	self._mainViewCtl:setFooterBtnsEnable( state )
end

function cls:getCurScene()
	return self._mainViewCtl:getCurScene()
end

function cls:getSpineFile(file_name, notPathSpine)
    return self._mainViewCtl:getSpineFile(file_name, notPathSpine)
end

-- return ThemeBaseCollectMapViewControl

