-- 游戏界面
local GameLayer = class("GameLayer", function() return cc.Layer:create() end)

local ws = cc.Director:getInstance():getWinSize()
local scheduler = cc.Director:getInstance():getScheduler()

local stack = {}

function GameLayer.scene(opt)
    local scene = cc.Scene:create()
    local layer = GameLayer.new(opt)
    scene:addChild(layer)
    return scene
end

function GameLayer:ctor(opt)
    local opt = opt or {}
    self:init(opt)
    showAds()
end

function GameLayer:init(opt)
    local opt = opt or {}
    local bg = cc.Sprite:create("res/game_bg.jpg")
    bg:setPosition(ws.width/2, ws.height/2)
    self:addChild(bg, 0)
    self._flipLayer = require("src/FlipLayer").new()
    self:addChild(self._flipLayer)
end


return GameLayer