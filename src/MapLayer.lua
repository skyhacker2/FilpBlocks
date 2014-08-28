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
    self:init(opt)
    self:initBlocks(opt)
end

function MapLayer:init(opt)
    self._bg = cc.Sprite:create("res/map_bg.png")
    self._bg:setPosition(ws.width/2, ws.height/2)
    self:addChild(self._bg,0)
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
            local color = 1 or math.random(1,2) --随机显示颜色
            local x = startPtx + (j-1) * blockSize + (j-1) * self._breakLength 
            local block = Block.new(color)
            block:setPosition(x, y)
            block:setScale(blockSize/block:getContentSize().width)
            self:addChild(block)
            self._blocks[i][j] = block
        end
    end
end

-- 判断矩阵是否都是一样，游戏结束
function MapLayer:isGameOver() 
    local result = {0, 0, 0}
    for i = 1, #self._blocks do
        for j = 1, #self._blocks[i] do
            local color = self._blocks[i][j]:getColor()
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
    self._blocks[x][y]:nextColor(2)
    local left = x - 1
    local right = x + 1
    local top = y + 1
    local bottom = y - 1

    if left > 0 then
        self._blocks[left][y]:nextColor(2)
    end
    if bottom > 0 then
        self._blocks[x][bottom]:nextColor(2)
    end
    if right <= self._size then
        self._blocks[right][y]:nextColor(2)
    end
    if top <= self._size then
        self._blocks[x][top]:nextColor(2)
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
                return
            end
        end
    end
end

return MapLayer