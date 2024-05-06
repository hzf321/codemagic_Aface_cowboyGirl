local Deferred = require("UI/CreatorUI/Deferred")

local Vec2 = {}
Vec2.ZERO = {
    x = 0,
    y = 0
}

function Vec2.isSame(v1, v2)
    return (v1.x == v2.x) and (v1.y == v2.y)
end
function Vec2.vec2(x, y)
    return {
        x = x,
        y = y
    }
end
function Vec2.linearInterpolation(p1, p2, k)
    k = k or 0.5
    local k_ = 1 - k
    return Vec2.vec2(p1.x * k_ + p2.x * k, p1.y * k_ + p2.y * k)
end
-- vec1 - vec2
function Vec2.sub(v1, v2)
    return Vec2.vec2(v1.x - v2.x, v1.y - v2.y)
end
function Vec2.add(v1, v2)
    return Vec2.vec2(v1.x + v2.x, v1.y + v2.y)
end
function Vec2.mulk(v, k)
    v.x = v.x * k
    v.y = v.y * k
    return v
end
function Vec2.len2(v)
    return v.x ^ 2 + v.y ^ 2
end
function Vec2.len(v)
    return math.sqrt(Vec2.len2(v))
end
function Vec2.distance2(v1, v2)
    return Vec2.len2(Vec2.vec2(v1.x - v2.x, v1.y - v2.y))
end
function Vec2.distance(v1, v2)
    return Vec2.len(Vec2.vec2(v1.x - v2.x, v1.y - v2.y))
end

function Vec2.normalize(v)
    v = Vec2.vec2(v.x, v.y)
    -- Vec2.print( v, "normal : " )
    -- printf( "len2 %f", Vec2.len2(v) )
    local k = 1 / math.sqrt(Vec2.len2(v))
    -- printf( "%f", k )
    return Vec2.mulk(v, k)
end
function Vec2.arc_type1(v1, v2, k, fixLen)

    local v = Vec2.linearInterpolation(v1, v2, k)
    v = Vec2.normalize(v)
    return Vec2.mulk(v, fixLen)
end
function Vec2.print(v, info)
    info = info or ""
    print(info .. "%3.1f\t%3.1f", v.x, v.y)
end

function Vec2.tostring(v, title)
    title = title or ""
    return string.format("%s<%3.1f,%3.1f>", title, v.x, v.y)
end

-- v1->v2 延长线上的 距离 v2 dis 的位置
function Vec2.extendPos(v1, v2, dis)
    -- p2 + (p2-p1) * dis/len(p2-p1)
    local off = Vec2.sub(v2, v1)
    local scale = dis / Vec2.len(off)

    local right = Vec2.mulk(off, scale)
    return Vec2.add(v2, right)
end

-- *************************************** 
-- 配置 类型的 Action
-- *************************************** 
local ActionTransTool = {}
ActionTransTool.act_tbl = {}

-- 传入的是actConfig表内容
function ActionTransTool.transSingleParam(actItem)
    -- 如果 是 table 并且 存在 这些要素
    if type(actItem) == "table" then
        local act = ActionTransTool.translateAction(actItem)
        return act
    else
        if type(actItem) == "string" then
            if actItem == "Act" or actItem == "ActList" then
                print("old type act name detected :", tostring(actItem))
            end
        else
            print("not supported :", tostring(actItem))
        end
    end
end

function ActionTransTool.transParamList(actConfigList)
    local actList = {}
    for idx, item in ipairs(actConfigList) do
        local act = ActionTransTool.transSingleParam(item)
        table.insert(actList, act)
    end
    return actList
end

function ActionTransTool.translateAction(tbl)

    if tbl == nil then
        print("ActionTransTool.translateAction passed a nil info")
        return cc.DelayTime:create(0.01)
    end
    local line = ActionTransTool.getItemByName(tbl[1])
    local creator = line.creator

    local list = {}
    for idx = 2, #tbl do
        table.insert(list, tbl[idx])
    end

    local act = creator(unpack(list))

    return act
end

function ActionTransTool.getItemByName(actName)
    local lname = string.lower(actName)
    -- print( "search actName : ", lname )
    local ret = ActionTransTool.act_tbl[lname]
    assert(ret, string.format("act <<%s>> not found", lname))
    return ret
end

-- *************************************** 
-- table 式 actions 解析
-- *************************************** 
local ActAdapter = {}

-- << deprecated function implementation
function ActAdapter:Act(act)
    -- print( dump({...}) )
    print("Act is deprecated action adapter")
    local action = ActionTransTool.transSingleParam(act)
    return action
end
function ActAdapter:ActList(...)
    print("ActList is deprecated action adapter")
    print("please use ****L like function to replace")
    --
    local tbl = {...}
    local list = {}
    for idx = 2, #tbl do
        table.insert(list, tbl[idx])
    end
    return ActionTransTool.transParamList(list)
end
-- >> deprecated function implementation
--
function ActAdapter:BLSequence(actConfigList)
    local actList = ActionTransTool.transParamList(actConfigList)
    return cc.Sequence:create(actList)
end
function ActAdapter:BLSequenceLite(...)
    return self:BLSequence({...})
end

function ActAdapter:BLSpawn(actConfigList)
    local actList = ActionTransTool.transParamList(actConfigList)
    return cc.Spawn:create(actList)
end

function ActAdapter:BLSpawnLite(...)
    return self:BLSpawn({...})
end

function ActAdapter:BLEaseBack(out, action_)
    local action = ActionTransTool.transSingleParam(action_)
    return cc.EaseBack:create(out, action)
end

function ActAdapter:BLEaseExp(out, action_)
    local action = ActionTransTool.transSingleParam(action_)
    return cc.EaseExponential:create(out, action)
end

function ActAdapter:BLEaseSineIn(action_)
    local action = ActionTransTool.transSingleParam(action_)
    return cc.EaseSineIn:create(action)
end
function ActAdapter:BLEaseSineOut(action_)
    local action = ActionTransTool.transSingleParam(action_)
    return cc.EaseSineOut:create(action)
end
function ActAdapter:BLEaseSine(out, action_)
    if type(out) ~= "boolean" then
        assert(false, "wrong parameter of 'out' parameter")
    end

    if out == true then
        return self:BLEaseSineOut(action_)

    elseif out == false then
        return self:BLEaseSineIn(action_)
    end
end

function ActAdapter:BLEaseBounce(out, action_)
    local action = ActionTransTool.transSingleParam(action_)
    return cc.EaseBounce:create(out, action)
end
-- BLRepeatForever
function ActAdapter:BLRepeatForever(action_)
    local action = ActionTransTool.transSingleParam(action_)
    return cc.RepeatForever:create(action)
end

function ActAdapter:BLRepeat(action_, times)
    local action = ActionTransTool.transSingleParam(action_)
    return cc.Repeat:create(action, times)
end

function ActAdapter:EndlessSeq(actConfigList)
    local actList = ActionTransTool.transParamList(actConfigList)
    return cc.RepeatForever:create(cc.Sequence:create(actList))
end
--
function ActAdapter:EndlessSeqLite(...)
    return self:EndlessSeq({...})
end

function ActAdapter:ScaleToXY(...)
    return cc.ScaleTo:create(...)
end

function ActAdapter:ScaleByXY(...)
    return cc.ScaleBy:create(...)
end

--------------------------------------------------------------------------------
local function actHandler(target, name, isMem)
    if target == nil then
        print("error : ", name)
        return
    end
    isMem = (isMem == nil) and true or false
    if isMem then
        local a = handler(target, target[name])
        assert(a, name)
        return a
    else
        local a = function(...)
            return target[name](...)
        end
        assert(a, name)
        return a
    end
end

local ori_act_tbl = {
    -- deprecated 
    ["Act"] = {
        creator = actHandler(ActAdapter, "Act")
    },
    ["ActList"] = {
        creator = actHandler(ActAdapter, "ActList")
    },
    -- roatate
    ["RotateBy"] = {
        creator = actHandler(cc.RotateBy, "create")
    },
    ["RotateTo"] = {
        creator = actHandler(cc.RotateTo, "create")
    },
    -- scale
    ["ScaleTo"] = {
        creator = actHandler(cc.ScaleTo, "create")
    },
    ["ScaleToXY"] = {
        creator = actHandler(ActAdapter, "ScaleToXY")
    },
    -- scale
    ["ScaleBy"] = {
        creator = actHandler(cc.ScaleBy, "create")
    },
    ["ScaleByXY"] = {
        creator = actHandler(ActAdapter, "ScaleByXY")
    },
    -- animate
    --  [ "Animate"    ] = { creator=actHandler( cc.Animate        , "create"          ) },
    --  [ "AnimateMod" ] = { creator=actHandler( cc.Animate        , "createFromMod"   ) },
    --  [ "AnimateLoop"] = { creator=actHandler( cc.Animate        , "createWithLoop"  ) },
    --
    ["EndlessSeq"] = {
        creator = actHandler(ActAdapter, "EndlessSeq")
    },
    ["EndlessSeqL"] = {
        creator = actHandler(ActAdapter, "EndlessSeqLite")
    },
    ["Endless"] = {
        creator = actHandler(ActAdapter, "BLRepeatForever")
    },
    ["Repeat"] = {
        creator = actHandler(ActAdapter, "BLRepeat")
    },
    --
    ["Seq"] = {
        creator = actHandler(ActAdapter, "BLSequence")
    },
    ["SeqL"] = {
        creator = actHandler(ActAdapter, "BLSequenceLite")
    },
    ["Spawn"] = {
        creator = actHandler(ActAdapter, "BLSpawn")
    },
    ["SpawnL"] = {
        creator = actHandler(ActAdapter, "BLSpawnLite")
    },
    --
    ["EaseExp"] = {
        creator = actHandler(ActAdapter, "BLEaseExp")
    },
    ["EaseBack"] = {
        creator = actHandler(ActAdapter, "BLEaseBack")
    },
    ["EaseSineIn"] = {
        creator = actHandler(ActAdapter, "BLEaseSineIn")
    },
    ["EaseSineOut"] = {
        creator = actHandler(ActAdapter, "BLEaseSineOut")
    },
    ["EaseSine"] = {
        creator = actHandler(ActAdapter, "BLEaseSine")
    },
    ["EaseBounce"] = {
        creator = actHandler(ActAdapter, "BLEaseBounce")
    },
    --
    ["FadeTo"] = {
        creator = actHandler(cc.FadeTo, "create")
    },
    ["FadeOut"] = {
        creator = actHandler(cc.FadeOut, "create")
    },
    ["FadeIn"] = {
        creator = actHandler(cc.FadeIn, "create")
    },
    -- ["Visible"] = {
    --     creator = actHandler(cc.ActionVisible, "create")
    -- },
    --
    ["Delay"] = {
        creator = actHandler(cc.DelayTime, "create")
    },
    -- 
    ["MoveBy"] = {
        creator = actHandler(cc.MoveBy, "create")
    },
    ["MoveTo"] = {
        creator = actHandler(cc.MoveTo, "create")
    },
    ["JumpTo"] = {
        creator = actHandler(cc.JumpTo, "create")
    },
    ["BezierTo"] = {
        creator = actHandler(cc.BezierTo, "create")
    },
    --
    ["ProgressTo"] = {
        creator = actHandler(cc.ProgressTo, "create")
    },
    ["Callfun"] = {
        creator = actHandler(cc.CallFunc, "create")
    },
    --
    ["SkewTo"] = {
        creator = actHandler(cc.SkewTo, "create")
    },
    ["SkewBy"] = {
        creator = actHandler(cc.SkewBy, "create")
    }
}
-- 别名
ori_act_tbl["EaseExponential"] = ori_act_tbl["EaseExp"]
-- ori_act_tbl["ActionVisible"] = ori_act_tbl["Visible"]
ori_act_tbl["RepeatForever"] = ori_act_tbl["Endless"]
ori_act_tbl["Sequence"] = ori_act_tbl["Seq"]
ori_act_tbl["DelayTime"] = ori_act_tbl["Delay"]

local act_tbl = ActionTransTool.act_tbl
-- 复制一份 副本 小写
for name, item in pairs(ori_act_tbl) do
    act_tbl[string.lower(name)] = item
end

-- *************************************** 
-- ActionTools 一些通用动画
-- *************************************** 
local ActionTools = {}

local ActionTool_flySingleItem_fConfig = {
    f = 200,
    t = 200,
    endScale = {
        x = 0.0001,
        y = 0.0001
    },
    t_fly = 0.6
}

function ActionTools.flySingleItem(cfg, fConfig)
    cfg.isClear = ((cfg.isClear == nil) and {true} or {cfg.isClear})[1]
    local fConfig = fConfig or {}
    setmetatable(fConfig, {
        __index = ActionTool_flySingleItem_fConfig
    })
    local d = Deferred.new()
    local item = cfg.item
    local parent = item:getParent()
    local lPosTo = parent:convertToNodeSpace(cfg.targetGPos)
    local yJump = 50
    local tJump = 0.6
    local xOff = (cfg.idx - ((cfg.total + 1) / 2)) * 100
    local lPosFrom = Vec2.vec2(item:getPosition())
    local controlMidPos = Vec2.vec2(0, math.random(fConfig.f, fConfig.t))

    local bCofnig = {Vec2.add(lPosFrom, Vec2.mulk(Vec2.sub(controlMidPos, lPosFrom), 0.5)),
                     Vec2.add(lPosTo, Vec2.mulk(Vec2.sub(controlMidPos, lPosTo), 0.5)), lPosTo}
    local t_fly = fConfig.t_fly
    local maxTotalTime = 3
    local t_int = math.min(maxTotalTime / cfg.total, 0.03)
    local cfgAct = {"SeqL", -- 逐个弹出
    {"delay", t_int * cfg.idx + (cfg.subIdx * 0.02)},
                    {"SpawnL", {"SeqL", {"EaseSineOut", {"BezierTo", t_fly, bCofnig}}},
                     {"SeqL", {"ScaleToXY", t_fly, fConfig.endScale.x, fConfig.endScale.x}}}, {"FadeTo", 0.1, 0},
                    {"Callfun", function()
        if cfg.isClear then
            item:removeFromParentAndCleanup()
        end
        d:resolve()
    end}}
    item:runAction(ActionTools.translate(cfgAct))
    return d
end

-- fly end 不隐藏
function ActionTools.flySingleItem2(cfg, fConfig)
    cfg.isClear = ((cfg.isClear == nil) and {true} or {cfg.isClear})[1]
    local fConfig = fConfig or {}
    setmetatable(fConfig, {
        __index = ActionTool_flySingleItem_fConfig
    })
    local d = Deferred.new()
    local item = cfg.item
    local parent = item:getParent()
    local lPosTo = parent:convertToNodeSpace(cfg.targetGPos)
    local yJump = 50
    local tJump = 0.6
    local xOff = (cfg.idx - ((cfg.total + 1) / 2)) * 100
    local lPosFrom = Vec2.vec2(item:getPosition())
    local controlMidPos = Vec2.vec2(0, math.random(fConfig.f, fConfig.t))

    local bCofnig = {Vec2.add(lPosFrom, Vec2.mulk(Vec2.sub(controlMidPos, lPosFrom), 0.5)),
                     Vec2.add(lPosTo, Vec2.mulk(Vec2.sub(controlMidPos, lPosTo), 0.5)), lPosTo}
    local t_fly = fConfig.t_fly
    local maxTotalTime = 3
    local t_int = math.min(maxTotalTime / cfg.total, 0.03)
    local cfgAct = {"SeqL", -- 逐个弹出
    {"delay", t_int * cfg.idx + (cfg.subIdx * 0.02)},
                    {"SpawnL", {"SeqL", {"EaseSineOut", {"BezierTo", t_fly, bCofnig}}},
                     {"SeqL", {"ScaleToXY", t_fly, fConfig.endScale.x, fConfig.endScale.x}}},
                    {"Callfun", function()
        if cfg.isClear then
            item:removeFromParentAndCleanup()
        end
        d:resolve()
    end}}
    item:runAction(ActionTools.translate(cfgAct))
    return d
end

ActionTools.translate = ActionTransTool.translateAction
ActionTools.translateAction = function(...)
    print("deprecated function [[ActionTools.translateAction]]")
    return ActionTransTool.translateAction(...)
end

function ActionTools.flyTo(node, gPos, cfg)
    cfg = cfg or {}
    local d = Deferred.new()
    ActionTools.flySingleItem({
        item = node,
        targetGPos = gPos,
        idx = cfg.idx or 1,
        total = cfg.total or 1,
        subIdx = 1,
        isClear = cfg.isClear
    }, {
        endScale = cfg.endScale or nil,
        t_fly = cfg.t_fly or nil
    }):next(function()
        d:resolve()
    end)
    return d
end

function ActionTools.flyTo2(node, gPos, cfg)
    cfg = cfg or {}
    local d = Deferred.new()
    ActionTools.flySingleItem2({
        item = node,
        targetGPos = gPos,
        idx = cfg.idx or 1,
        total = cfg.total or 1,
        subIdx = 1,
        isClear = cfg.isClear
    }, {
        endScale = cfg.endScale or nil,
        t_fly = cfg.t_fly or nil
    }):next(function()
        d:resolve()
    end)
    return d
end

function ActionTools.randomRange(from, to)
    if from > to then
        return ActionTools.randomRange(to, from)
    end
    return math.random() * (to - from) + from
end

return ActionTools
