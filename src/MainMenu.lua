local MainMenu = class("MainMenu",function() return cc.Layer:create() end)

local ws = cc.Director:getInstance():getWinSize()

function MainMenu:ctor()
    self.simpleMenu = nil
    self.middleMenu = nil
    self.hardMenu = nil
    self:initMenu()
end

function MainMenu:initMenu()
    local simpleLabel = cc.Label:createWithTTF("简 单","res/font/DroidSansFallback.ttf", 90)
    self.simpleMenu = cc.MenuItemLabel:create(simpleLabel)
    self.simpleMenu:setPosition(0,150)
    
    local middleLabel = cc.Label:createWithTTF("中 等","res/font/DroidSansFallback.ttf", 90)
    self.middleMenu = cc.MenuItemLabel:create(middleLabel)
    self.middleMenu:setPosition(0,0)
    
    local hardLabel = cc.Label:createWithTTF("困 难","res/font/DroidSansFallback.ttf", 90)
    self.hardMenu = cc.MenuItemLabel:create(hardLabel)
    self.hardMenu:setPosition(0,-150)
    
    local menu = cc.Menu:create(self.simpleMenu, self.middleMenu, self.hardMenu)
    self:addChild(menu)
end

return MainMenu