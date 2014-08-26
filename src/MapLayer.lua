-- 地图
local MapLayer = class("MapLayerLayer",function() return cc.Layer:create() end)

local ws = cc.Director:getInstance():getWinSize()

function MapLayer:ctor(opt)
    cclog("MapLayer:ctor")
    self._bg = nil
    self._blocks = nil
    self:init(opt)
end

function MapLayer:init(opt)
    local opt = opt or {}
    self._bg = cc.Sprite:create("res/map_bg.png")
    self._bg:setPosition(ws.width/2, ws.height/2)
    self:addChild(self._bg,0)
end

return MapLayer