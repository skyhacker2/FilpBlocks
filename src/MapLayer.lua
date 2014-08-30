-- 地图
local MapLayer = class("MapLayerLayer",function() return cc.Layer:create() end)
local Block = require("src/Block")
local ws = cc.Director:getInstance():getWinSize()

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
end

function MapLayer:init(opt)
    self._bg = cc.Sprite:create("res/map_bg.png")
    self._bg:setPosition(ws.width/2, ws.height/2)
    self:addChild(self._bg,0)
    
    -- 闹钟
    local clock = cc.Sprite:create("res/clock.png")
    clock:setPosition(50,ws.height/1.22)
    self:addChild(clock)
    self.timeLabel = cc.Label:createWithTTF("00:00","res/font/DroidSansFallback.ttf",60)
    self.timeLabel:setAnchorPoint(0.5, 0.5)
    self.timeLabel:setPosition(180, ws.height/1.22)
    self:addChild(self.timeLabel)

    -- 重新开始按钮
    self.restartMenu = cc.MenuItemImage:create("res/restart_btn.png","res/restart_btn.png")
    
    local menu = cc.Menu:create(self.restartMenu)
    menu:setPosition(ws.width/1.3,ws.height/1.22)
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
end

-- 判断矩阵是否都是一样，游戏结束
function MapLayer:isGameOver() 
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
    if self:isGameOver() then
        return
    end
    local now = os.time()
    local interval = now -  self._preTime
    self._usedTime = self._usedTime + interval
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
        return true
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

return MapLayer