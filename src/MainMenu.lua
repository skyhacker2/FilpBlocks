local MainMenu = class("MainMenu",function() return cc.Layer:create() end)

local ws = cc.Director:getInstance():getWinSize()

function MainMenu:ctor()
    self.simpleMenu = nil
    self.middleMenu = nil
    self.hardMenu = nil
    self.moreMenu = nil
    self.vibrationMenu = nil
    self.musicMenu = nil
    self.colorNumMenu = nil
    self.rateMenu = nil
    self._isSubMenuShown = false
    self:initMenu()
    self:initSubMenu()
    self:bindSubMenuEvent()
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
    
    self.moreMenu = ccui.Button:create("res/more_btn.png")
    self.moreMenu:setPosition(ws.width/2, -300)
    self.moreMenu:runAction(createMenuAction(cc.p(ws.width/2, 350),0.2))
    self:addChild(self.moreMenu)
    
    self.settingMenu = ccui.Button:create("res/setting_btn.png")
    self.settingMenu:setPosition(ws.width/2,-400) 
    self.settingMenu:runAction(createMenuAction(cc.p(ws.width/2,200),0.3))
    self:addChild(self.settingMenu)
end

function MainMenu:initSubMenu()
    function createMenu(text)
        local label = cc.Label:createWithTTF(text,"res/font/BradleyHandITC.TTF", 60)
        return cc.MenuItemLabel:create(label)
    end
    
    local x, y, marginTop = ws.width/2, -100, 100
    local isVibration = cc.UserDefault:getInstance():getBoolForKey("vibration",true)
    print(isVibration)
    self.vibrationMenu = createMenu("Vibration: "..(isVibration and "On" or "Off"))
    self.vibrationMenu:setPosition(x, y)
    y = y - marginTop
    
    local isMusicOn = cc.UserDefault:getInstance():getBoolForKey("music",true)
    self.musicMenu = createMenu("Music: "..(isMusicOn and "On" or "Off"))
    self.musicMenu:setPosition(x, y)
    y = y - marginTop
    
    local colorNum = cc.UserDefault:getInstance():getIntegerForKey("color_num",2)
    print(colorNum)
    self.colorNumMenu = createMenu("Color: " .. (colorNum == 2 and 2 or 3))
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

function MainMenu:bindSubMenuEvent()
    -- 设置振动
    self.vibrationMenu:registerScriptTapHandler(function() 
        local isVibrationOn = cc.UserDefault:getInstance():getBoolForKey("vibration",true)
        if isVibrationOn then
            cc.UserDefault:getInstance():setBoolForKey("vibration",false)
        	self.vibrationMenu:setString("Vibration: Off")
        else
            cc.UserDefault:getInstance():setBoolForKey("vibration",true)
            self.vibrationMenu:setString("Vibration: On")
        end
    end)
    
    -- 设置音乐
    self.musicMenu:registerScriptTapHandler(function()
        local isMusicOn = cc.UserDefault:getInstance():getBoolForKey("music",true)
        if isMusicOn then
            cc.UserDefault:getInstance():setBoolForKey("music",false)
            self.musicMenu:setString("Music: Off")
        else
            cc.UserDefault:getInstance():setBoolForKey("music",true)
            self.musicMenu:setString("Music: On")
        end
    end)
    -- 设置颜色
    self.colorNumMenu:registerScriptTapHandler(function()
        local colorNum = cc.UserDefault:getInstance():getIntegerForKey("color_num",2)
        if colorNum == 2 then
            cc.UserDefault:getInstance():setIntegerForKey("color_num",3)
            self.colorNumMenu:setString("Color: 3")
        else
            cc.UserDefault:getInstance():setIntegerForKey("color_num",2)
            self.colorNumMenu:setString("Color: 2")
        end
    end)
    
    -- 给我们评分
    self.rateMenu:registerScriptTapHandler(function()
        rateApp() 
    end)
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

local  function createMoveUpAction(pos, delay)
    return cc.Sequence:create(
        cc.DelayTime:create(delay),
        cc.EaseOut:create(cc.MoveTo:create(0.2,pos), 2.5) 
    )
end

function MainMenu:showSubMenu()
    self:stopMenusActions()
    local x, y = self.simpleMenu:getPosition()
    self.simpleMenu:runAction(createMoveOutAction(cc.p(-120,y),0))
    
    x, y = self.mediumMenu:getPosition()
    self.mediumMenu:runAction(createMoveOutAction(cc.p(-120,y),0.03))
    
    x, y = self.hardMenu:getPosition()
    self.hardMenu:runAction(createMoveOutAction(cc.p(-120,y),0.06))
    
    x, y = self.moreMenu:getPosition()
    self.moreMenu:runAction(createMoveOutAction(cc.p(-120,y),0.1))
    
    x, y = self.settingMenu:getPosition()
    self.settingMenu:runAction(createMoveUpAction(cc.p(x,800),0.15))
    
    -- 子菜单
    x, y = self.vibrationMenu:getPosition()
    self.vibrationMenu:runAction(createMoveUpAction(cc.p(x, 650),0.15))
    
    x, y = self.musicMenu:getPosition()
    self.musicMenu:runAction(createMoveUpAction(cc.p(x,550),0.15))
    
    x, y = self.colorNumMenu:getPosition()
    self.colorNumMenu:runAction(createMoveUpAction(cc.p(x,450), 0.15))
    
    x, y = self.rateMenu:getPosition()
    self.rateMenu:runAction(createMoveUpAction(cc.p(x,350),0.15))
end

function MainMenu:hideSubMenu()
    self:stopMenusActions()
    local x, y = self.simpleMenu:getPosition()
    print(x, y)
    self.simpleMenu:runAction(createMoveInAction(cc.p(ws.width/2,y),0.2))

    x, y = self.mediumMenu:getPosition()
    self.mediumMenu:runAction(createMoveInAction(cc.p(ws.width/2,y),0.3))

    x, y = self.hardMenu:getPosition()
    self.hardMenu:runAction(createMoveInAction(cc.p(ws.width/2,y),0.4))

    x, y = self.moreMenu:getPosition()
    self.moreMenu:runAction(createMoveInAction(cc.p(ws.width/2,y),0.5))
    
    x, y = self.settingMenu:getPosition()
    self.settingMenu:runAction(createMoveInAction(cc.p(x,200),0))
    
    -- 子菜单
    x, y = self.vibrationMenu:getPosition()
    self.vibrationMenu:runAction(createMoveOutAction(cc.p(x, -100),0))

    x, y = self.musicMenu:getPosition()
    self.musicMenu:runAction(createMoveOutAction(cc.p(x,-100),0))
    
    x, y = self.colorNumMenu:getPosition()
    self.colorNumMenu:runAction(createMoveOutAction(cc.p(x,-100), 0))

    x, y = self.rateMenu:getPosition()
    self.rateMenu:runAction(createMoveOutAction(cc.p(x,-100),0))
    
    
end

function MainMenu:stopMenusActions()
    self.simpleMenu:stopAllActions()
    self.mediumMenu:stopAllActions()
    self.hardMenu:stopAllActions()
    self.settingMenu:stopAllActions()
    self.vibrationMenu:stopAllActions()
    self.musicMenu:stopAllActions()
    self.colorNumMenu:stopAllActions()
    self.rateMenu:stopAllActions()
end

return MainMenu