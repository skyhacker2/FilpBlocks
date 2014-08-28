-- 游戏界面
local GameLayer = class("GameLayer", function() return cc.Layer:create() end)

local ws = cc.Director:getInstance():getWinSize()
local scheduler = cc.Director:getInstance():getScheduler()

local stack = {}

function GameLayer.scene(opt)
    local scene = cc.Scene:create()
    local layer = GameLayer.new(opt)
    scene:addChild(layer)
    return scene
end

function GameLayer:ctor(opt)
    local opt = opt or {}
    self._mapLayer = nil
    self._timeLabel = nil
    self._restartMenu = nil
    self._usedTime = opt.usedTime or 0
    self._preTime = os.time()
    self._logicId = nil
    self._size = opt.size or 3
    self:init(opt)
    self:initMapLayer(opt)
    
    -- node events
    function onNodeEvent(event)
        if event == "onExit" and  self._logicId then
            scheduler:unscheduleScriptEntry(self._logicId)
        end
    end
    self:registerScriptHandler(onNodeEvent)
    
    -- 注册触摸事件
    function onTouchBegan(touch, event)
        return true
    end
    function onTouchEnded(touch, event)
        self._mapLayer:onTouchEnded(touch, event)
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)

    local dispatcher = self:getEventDispatcher()

    dispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    
end

function GameLayer:init(opt)
    local opt = opt or {}
    local bg = cc.Sprite:create("res/game_bg.jpg")
    bg:setPosition(ws.width/2, ws.height/2)
    self:addChild(bg, 0)
    
    -- 闹钟
    local clock = cc.Sprite:create("res/clock.png")
    clock:setPosition(ws.width/1.6,ws.height/1.3)
    self:addChild(clock)
    self._timeLabel = cc.Label:createWithSystemFont("00:00","黑体",60)
    self._timeLabel:setAnchorPoint(1, 0.5)
    self._timeLabel:setPosition(ws.width/1.05, ws.height/1.3)
    self:addChild(self._timeLabel)
    
    -- 重新开始按钮
    self._restartMenu = cc.MenuItemImage:create("res/restart_btn.png","res/restart_btn.png")
    self._restartMenu:registerScriptTapHandler(function() self:restart() end)
    local menu = cc.Menu:create(self._restartMenu)
    menu:setPosition(ws.width/2,150)
    self:addChild(menu)
    
    self:scheduleUpdateWithPriorityLua(function() self:updateTime() end, 0)
    
end

function GameLayer:initMapLayer(opt)
    self._mapLayer = require("src/MapLayer").new(opt)
    self._mapLayer:setPosition(0, -60)
    self:addChild(self._mapLayer)
    
    math.randomseed(os.time())
    self:randomTouch()
    --self._logicId = scheduler:scheduleScriptFunc(function() self:logic() end,0.01,false)
end

function GameLayer:updateTime()
    if self._mapLayer:isGameOver() then
        return
    end
    local now = os.time()
    local interval = now -  self._preTime
    self._usedTime = self._usedTime + interval
    self._preTime = now
    local displayText = G.formatTime(self._usedTime)
    self._timeLabel:setString(displayText)
end

function GameLayer:logic()
    if self._mapLayer:isGameOver() then
        return
    end
    
    -- 测试代码
    local x, y = math.random(1,self._size), math.random(1,self._size)
    self._mapLayer:touchIn(x, y)
    print(x, y)
    --[[
    if #stack >0 then
        self._mapLayer:touchIn(stack[#stack][1], stack[#stack][2])
        table.remove(stack,#stack)
    else
        print('finish')
    end
    ]]
end

-- 随机点击， 用来测试
function GameLayer:randomTouch()
    local count = math.random(5,10)
    print('touch count = ' .. count)
    for i = 1, count do
        local x, y = math.random(1, self._size), math.random(1, self._size)
        self._mapLayer:touchIn(x, y)
        stack[#stack+1] = {x, y}
    end
end

-- 重新开始
function GameLayer:restart()
    self._usedTime = 0
    self:randomTouch()
end

return GameLayer