-- 地图
local MapLayer = class("MapLayerLayer",function() return cc.Layer:create() end)
local Block = require("src/Block")
local ws = cc.Director:getInstance():getWinSize()
local scheduler = cc.Director:getInstance():getScheduler()
function MapLayer:ctor(opt)
    cclog("MapLayer:ctor")
    local opt = opt or {}
    self._bg = nil
    self._blocks = {}
    self._breakLength = 25 / 4 --方块之间间隔的宽度
    self._matrix = nil
    self._size = nil
    self._usedTime = opt.usedTime or 0
    self._preTime = os.time()
    self:init(opt)
    self:initBlocks(opt)
    self:bindEvent()
    
    -- 测试
    --math.randomseed(os.time())
    --self._testId = scheduler:scheduleScriptFunc(function() self:test() end,0.01, false)
end

function MapLayer:init(opt)
    self._bg = cc.Sprite:create("res/map_bg.png")
    self._bg:setPosition(ws.width/2, ws.height/2)
    self:addChild(self._bg,0)
    
    -- 闹钟
    local clock = cc.Sprite:create("res/clock.png")
    clock:setPosition(50,ws.height/1.23)
    self:addChild(clock)
    self.timeLabel = cc.Label:createWithTTF("00:00","res/font/BradleyHandITC.TTF",60)
    self.timeLabel:setAnchorPoint(0.5, 0.5)
    self.timeLabel:setPosition(180, ws.height/1.23)
    self:addChild(self.timeLabel)

    -- 重新开始按钮
    self.restartMenu = cc.MenuItemImage:create("res/restart_btn.png","res/restart_btn.png")
    
    local menu = cc.Menu:create(self.restartMenu)
    menu:setPosition(ws.width/1.2,ws.height/1.23)
    self:addChild(menu)
    
    self:scheduleUpdateWithPriorityLua(function(dt) self:update(dt) end,0)
    
end

function MapLayer:initBlocks(opt)
    self._size = opt.size or 3
    --每一个方块的大小
    local blockSize = math.floor((self._bg:getContentSize().width - (self._size+1) * self._breakLength)/self._size)
    print(blockSize)
    -- 左下角方块的坐标
    local startPtx = self._bg:getPositionX() - self._bg:getContentSize().width/2 +
                     self._breakLength + blockSize/2
    local startPty = self._bg:getPositionY() - self._bg:getContentSize().height/2 +
                     self._breakLength + blockSize/2
                         
    for i = 1, self._size do
        local y = startPty + (i-1) * blockSize + (i-1) * self._breakLength
        self._blocks[i] = {}
        for j = 1, self._size do
            local color = math.random(1,2) --随机显示颜色
            local x = startPtx + (j-1) * blockSize + (j-1) * self._breakLength 
            local block = Block.new(color)
            block:setPosition(x, y)
            block:setScale(blockSize/block:getContentSize().width)
            self:addChild(block, 100)
            self._blocks[i][j] = block
        end
    end
    --self:touchIn(1,1)
end

-- 判断矩阵是否都是一样，游戏结束
function MapLayer:isWin() 
    local result = {0, 0, 0}
    for i = 1, #self._blocks do
        for j = 1, #self._blocks[i] do
            local color = self._blocks[i][j].color
            result[color] = result[color] + 1
        end
    end
    for i = 1, #result do
        if result[i] == self._size * self._size then
            return true
        end
    end
    return false
end

-- 胜利动画
function MapLayer:win()
    
    -- 胜利页面
    local scheduleId = nil
    function createWinLayer()
        local line = cc.Sprite:create("res/line.png")
        line:setPosition(ws.width/2,760)
        self:addChild(line)
        -- 时间标签
        local timeLabel = cc.Label:createWithTTF("Time","res/font/BradleyHandITC.TTF", 60)
        timeLabel:setColor(cc.c3b(113,140,142))
        timeLabel:setPosition(ws.width/2,700)
        local time = cc.Label:createWithTTF(G.formatTime(self._usedTime),"res/font/BradleyHandITC.TTF",38)
        time:setColor(cc.c3b(113,140,142))
        time:setPosition(ws.width/2,660)
        self:addChild(timeLabel)
        self:addChild(time)
        
        -- 最好时间
        local best = cc.UserDefault:getInstance():getDoubleForKey("time_"..self._size,999999999)
        if best > self._usedTime then
            best = self._usedTime
            cc.UserDefault:getInstance():setDoubleForKey("time_"..self._size,best)
        end
        local bestLabel = cc.Label:createWithTTF("Best","res/font/BradleyHandITC.TTF",60)
        bestLabel:setPosition(ws.width/2,590)
        bestLabel:setColor(cc.c3b(113,140,142))
        self:addChild(bestLabel)
        local best = cc.Label:createWithTTF(G.formatTime(self._usedTime),"res/font/BradleyHandITC.TTF",38)
        best:setColor(cc.c3b(113,140,142))
        best:setPosition(ws.width/2,550)
        self:addChild(best)
        --按钮
        local okBtn = ccui.Button:create("res/ok_btn.png")
        okBtn:setPosition(ws.width/3,450)
        okBtn:addTouchEventListener(function(sender, event)
            if event == ccui.TouchEventType.ended then
                self:unscheduleUpdate()
                if self.restartCallback ~= nil then
                    self.restartCallback(self)
                end
            end 
        end)
        self:addChild(okBtn)
        
        -- 分享
        local shareBtn = ccui.Button:create("res/share_btn.png")
        shareBtn:setPosition(ws.width/3*2,450)
        self:addChild(shareBtn)
        scheduler:unscheduleScriptEntry(scheduleId)
    end
    scheduleId = scheduler:scheduleScriptFunc(createWinLayer,0.4,false)
    
    function createWinAction(pos)
        local angle = math.random(0,360)
        local t = math.random(1,2) 
        local spawn = cc.Spawn:create(
            cc.MoveTo:create(t, cc.p(pos.x,pos.y - 1000)), 
            cc.RotateTo:create(t, angle)
        )
        return cc.Sequence:create(cc.DelayTime:create(0.4),spawn)
    end
    for i = 1, #self._blocks do
        for j = 1, #self._blocks[i] do
            local x, y = self._blocks[i][j]:getPositionX(), self._blocks[i][j]:getPositionY()
            self._blocks[i][j]:runAction(createWinAction(cc.p(x,y)))
        end
    end
end

function MapLayer:touchIn(x, y)
    self._blocks[x][y]:nextColor()
    local left = x - 1
    local right = x + 1
    local top = y + 1
    local bottom = y - 1

    if left > 0 then
        self._blocks[left][y]:nextColorDelay(0)
    end
    if bottom > 0 then
        self._blocks[x][bottom]:nextColorDelay(0)
    end
    if right <= self._size then
        self._blocks[right][y]:nextColorDelay(0)
    end
    if top <= self._size then
        self._blocks[x][top]:nextColorDelay(0)
    end
end

-- 触摸事件
function MapLayer:onTouchEnded(touch, event)
    local location = self:convertToNodeSpace(touch:getLocation())
    for i = 1, #self._blocks do
        for j = 1, #self._blocks[i] do
            local block = self._blocks[i][j]
            if cc.rectContainsPoint(block:getBoundingBox(),location) then
                self:touchIn(i,j)
                vibrate()
                return
            end
        end
    end
end

-- 更新函数
function MapLayer:update(dt)
    if self:isWin() then
        self:unscheduleUpdate()
        self:win()
        --scheduler:unscheduleScriptEntry(self._testId)
        return
    end
    self._usedTime = self._usedTime + dt
    self._preTime = now
    local displayText = G.formatTime(self._usedTime)
    self.timeLabel:setString(displayText)
end

function MapLayer:bindEvent()
    -- 重新开始按钮事件
    self.restartMenu:registerScriptTapHandler(function()
        self:unscheduleUpdate()
        if self.restartCallback ~= nil then
            self.restartCallback(self)
        end 
    end)
    -- 注册触摸事件
    function onTouchBegan(touch, event)
        if self:isVisible() then
            return true
        else
            return false
        end
    end
    function onTouchEnded(touch, event)
        self:onTouchEnded(touch, event)
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
    local dispatcher = self:getEventDispatcher()
    dispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

-- 测试
function MapLayer:test()
    local x, y = math.random(1,self._size), math.random(1,self._size)
    self:touchIn(x, y)
end


return MapLayer