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
    self._flipLayer = require("src/FlipLayer").new()
    self:addChild(self._flipLayer)
    self._title = cc.Sprite:create("res/title.png")
    self._title:setPosition(ws.width/2,ws.height/1.15)
    self:addChild(self._title)
    -- 显示广告
    local entry = nil
    entry = scheduler:scheduleScriptFunc(function()
        showAds()
        scheduler:unscheduleScriptEntry(entry)
    end,1,false)
end

function GameLayer:initWelcomeLayer()
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