local MainMenu = class("MainMenu",function() return cc.Layer:create() end)

local ws = cc.Director:getInstance():getWinSize()

function MainMenu:ctor()
    self.simpleMenu = nil
    self.middleMenu = nil
    self.hardMenu = nil
    self:initMenu()
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


return MainMenu