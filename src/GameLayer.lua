-- 游戏界面
local GameLayer = class("GameLayer", function() return cc.Layer:create() end)

local ws = cc.Director:getInstance():getWinSize()
local scheduler = cc.Director:getInstance():getScheduler()

local stack = {}

function GameLayer.scene()
    local scene = cc.Scene:create()
    local layer = GameLayer.new()
    scene:addChild(layer)
    return scene
end

function GameLayer:ctor()
    self:initWelcomeLayer()
end

function GameLayer:init()
    local bg = cc.Sprite:create("res/game_bg.jpg")
    bg:setPosition(ws.width/2, ws.height/2)
    self:addChild(bg, 0)
    self._flipLayer = require("FlipLayer").new()
    self:addChild(self._flipLayer)
    self._title = cc.Sprite:create("res/title.png")
    self._title:setPosition(ws.width/2,ws.height/1.15)
    self:addChild(self._title)
    
    self.tips = cc.Label:createWithTTF("All blocks have the same color, you win",
        "res/font/BradleyHandITC.TTF", 30)
    self.tips:setPosition(ws.width/2,920)
    self:addChild(self.tips) 
    
    -- 显示广告
--    local entry = nil
--    entry = scheduler:scheduleScriptFunc(function()
--        showAds()
--        scheduler:unscheduleScriptEntry(entry)
--    end,1,false)
    
    -- 返回键
    local backListener = cc.EventListenerKeyboard:create()
    backListener:registerScriptHandler(function(keyCode, event)
        -- 小米的的返回键是6 = =！
        if keyCode == cc.KeyCode.KEY_BACKSPACE or keyCode == 6 then
            cc.Director:getInstance():endToLua()
        end
    end,cc.Handler.EVENT_KEYBOARD_RELEASED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(backListener, self)
end

function GameLayer:initWelcomeLayer()
    cc.SimpleAudioEngine:getInstance():playEffect("res/start.wav")
    
    local welcome = cc.Sprite:create("res/welcome.jpg")
    welcome:setPosition(ws.width/2,ws.height/2)
    self:addChild(welcome)
    local entry = nil
    entry = scheduler:scheduleScriptFunc(function()
         scheduler:unscheduleScriptEntry(entry)
         self:removeChild(welcome,true)
         self:init()
    end, 1,false)
end


return GameLayer