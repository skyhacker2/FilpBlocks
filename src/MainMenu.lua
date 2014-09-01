local MainMenu = class("MainMenu",function() return cc.Layer:create() end)

local ws = cc.Director:getInstance():getWinSize()

function MainMenu:ctor()
    self.simpleMenu = nil
    self.middleMenu = nil
    self.hardMenu = nil
    self.vibrationMenu = nil
    self.musicMenu = nil
    self.colorNumMenu = nil
    self.rateMenu = nil
    self._isSubMenuShown = false
    self:initMenu()
    self:initSubMenu()
end

function MainMenu:initMenu()
    local function createMenuAction(pos, delay)
        local action = cc.Sequence:create(
            cc.DelayTime:create(delay),
            cc.MoveTo:create(0.2,cc.p(pos.x,pos.y - 200)), 
            cc.EaseElasticOut:create(cc.MoveTo:create(1.5,pos))  
        )
        return action
    end
    
    self.simpleMenu = ccui.Button:create("res/easy_btn.png")
    self.simpleMenu:setPosition(ws.width/2, 0) 
    self.simpleMenu:runAction(createMenuAction(cc.p(ws.width/2,800), 0))
    self:addChild(self.simpleMenu)
    
    self.mediumMenu = ccui.Button:create("res/medium_btn.png")
    self.mediumMenu:setPosition(ws.width/2,-100)
    self.mediumMenu:runAction(createMenuAction(cc.p(ws.width/2, 650), 0.1))
    self:addChild(self.mediumMenu)
    
    self.hardMenu = ccui.Button:create("res/hard_btn.png")
    self.hardMenu:setPosition(ws.width/2, -200)
    self.hardMenu:runAction(createMenuAction(cc.p(ws.width/2,500),0.2))
    self:addChild(self.hardMenu)
    
    self.settingMenu = ccui.Button:create("res/setting_btn.png")
    self.settingMenu:setPosition(ws.width/2,-300) 
    self.settingMenu:runAction(createMenuAction(cc.p(ws.width/2,350),0.3))
    self:addChild(self.settingMenu)
end

function MainMenu:initSubMenu()
    function createMenu(text)
        local label = cc.Label:createWithTTF(text,"res/font/BradleyHandITC.TTF", 60)
        return cc.MenuItemLabel:create(label)
    end
    
    local x, y, marginTop = ws.width + 200, 650, 100
    self.vibrationMenu = createMenu("Vibration: On")
    self.vibrationMenu:setPosition(x, y)
    y = y - marginTop
    
    self.musicMenu = createMenu("Music: On")
    self.musicMenu:setPosition(x, y)
    y = y - marginTop
    
    self.colorNumMenu = createMenu("Color: 2")
    self.colorNumMenu:setPosition(x, y)
    y = y - marginTop
    
    self.rateMenu  = createMenu("Rate App")
    self.rateMenu:setPosition(x, y)
    
    
    local menu = cc.Menu:create(self.vibrationMenu, self.musicMenu, 
                                self.colorNumMenu, self.rateMenu)
    menu:setAnchorPoint(0,0)
    menu:setPosition(0,0)
    self:addChild(menu)
    
end

function MainMenu:toggleSubMenu()
    if self._isSubMenuShown then
        self:hideSubMenu()
        self._isSubMenuShown = false
    else
        self:showSubMenu()
        self._isSubMenuShown = true
    end
end

local function createMoveOutAction(pos, delay)
    return cc.Sequence:create(
        cc.DelayTime:create(delay),
        cc.MoveTo:create(0.1,pos)
    )
end

local function createMoveInAction(pos, delay)
    return cc.Sequence:create(
        cc.DelayTime:create(delay),
        cc.EaseElasticOut:create(cc.MoveTo:create(1.5,pos))
    )
end

local  function createMoveFunc(pos, delay)
    return cc.Sequence:create(
        cc.DelayTime:create(delay),
        cc.MoveTo:create(0.3,pos) 
    )
end

function MainMenu:showSubMenu()
    
    local x, y = self.simpleMenu:getPosition()
    self.simpleMenu:runAction(createMoveOutAction(cc.p(x-450,y),0))
    
    x, y = self.mediumMenu:getPosition()
    self.mediumMenu:runAction(createMoveOutAction(cc.p(x-450,y),0.05))
    
    x, y = self.hardMenu:getPosition()
    self.hardMenu:runAction(createMoveOutAction(cc.p(x-450,y),0.1))
    
    x, y = self.settingMenu:getPosition()
    self.settingMenu:runAction(createMoveFunc(cc.p(x,800),0.15))
end

function MainMenu:hideSubMenu()
    
    local x, y = self.simpleMenu:getPosition()
    print(x, y)
    self.simpleMenu:runAction(createMoveInAction(cc.p(x+450,y),0.2))

    x, y = self.mediumMenu:getPosition()
    self.mediumMenu:runAction(createMoveInAction(cc.p(x+450,y),0.3))

    x, y = self.hardMenu:getPosition()
    self.hardMenu:runAction(createMoveInAction(cc.p(x+450,y),0.4))
    
    x, y = self.settingMenu:getPosition()
    self.settingMenu:runAction(createMoveFunc(cc.p(x,350),0))
end


return MainMenu