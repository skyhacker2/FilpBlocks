-- 翻转效果Layer
local FlipLayer = class("FlipLayer", function() return cc.Layer:create() end)

local MenuLayer = require("src/MainMenu")
local MapLayer = require("src/MapLayer")

function FlipLayer:ctor()
    self._menuLayer = MenuLayer.new()
    self:addChild(self._menuLayer)
    self._mapLayer = nil
    self._isMenuUp = false -- 反转时是否菜单在上方
    
    self:bindMenuEvent()
end

function FlipLayer:bindMenuEvent()
    local function onMenuTouch(sender, event)
        if event ~= ccui.TouchEventType.ended then
            return
        end
        if sender == self._menuLayer.simpleMenu then
            self:initMapLayer{size=3}
        end
        if sender == self._menuLayer.mediumMenu then
            self:initMapLayer{size=5}
        end
        if sender == self._menuLayer.hardMenu then
            self:initMapLayer{size=9}
        end
        if sender == self._menuLayer.settingMenu then
            self._menuLayer:toggleSubMenu()
        end
    end
    self._menuLayer.simpleMenu:addTouchEventListener(onMenuTouch)
    self._menuLayer.mediumMenu:addTouchEventListener(onMenuTouch)
    self._menuLayer.hardMenu:addTouchEventListener(onMenuTouch)
    self._menuLayer.settingMenu:addTouchEventListener(onMenuTouch)
end

function FlipLayer:initMapLayer(opt)
    if self._mapLayer ~= nil then
        self:removeChild(self._mapLayer,true)   
    end
    self._mapLayer = MapLayer.new(opt)
    self._mapLayer:setPosition(0, -60)
    self._mapLayer:setVisible(false)
    self._mapLayer.restartCallback = function(layer)
        self:flip() 
    end
    self:addChild(self._mapLayer)
    self:flip()
    
end

function FlipLayer:flip()
    local duration = 0.4
    local closeAction = cc.Sequence:create(
        cc.OrbitCamera:create(duration,1, 0, 0, 90, 0, 0),
        cc.Hide:create(),
        cc.DelayTime:create(duration)
    )
    local openAction = cc.Sequence:create(
        cc.DelayTime:create(duration),
        cc.Show:create(),
        cc.OrbitCamera:create(duration,1, 0, 270, 90, 0, 0)
    )
    if self._isMenuUp then
        self._mapLayer:runAction(closeAction)
        self._menuLayer:runAction(openAction)
        self._isMenuUp = false
    else
        self._mapLayer:runAction(openAction)
        self._menuLayer:runAction(closeAction)
        self._isMenuUp = true
    end
	
end


return FlipLayer