-- 游戏界面
local GameLayer = class("GameLayer", function() return cc.Layer:create() end)

local ws = cc.Director:getInstance():getWinSize()
local scheduler = cc.Director:getInstance():getScheduler()
function GameLayer.scene(opt)
    local scene = cc.Scene:create()
    local layer = GameLayer.new(opt)
    scene:addChild(layer)
    return scene
end

function GameLayer:ctor(opt)
    local opt = opt or {}
    self._mapLayer = nil
    self._timeLabel = nil
    self._restartMenu = nil
    self._usedTime = opt.usedTime or 0
    self._preTime = os.time()
    self:init(opt)
    self:initMapLayer(opt)
end

function GameLayer:init(opt)
    local opt = opt or {}
    local bg = cc.Sprite:create("res/game_bg.jpg")
    bg:setPosition(ws.width/2, ws.height/2)
    self:addChild(bg, 0)
    
    -- 闹钟
    local clock = cc.Sprite:create("res/clock.png")
    clock:setPosition(ws.width/1.6,ws.height/1.3)
    self:addChild(clock)
    self._timeLabel = cc.Label:createWithSystemFont("00:00","黑体",60)
    self._timeLabel:setAnchorPoint(1, 0.5)
    self._timeLabel:setPosition(ws.width/1.05, ws.height/1.3)
    self:addChild(self._timeLabel)
    
    -- 重新开始按钮
    self._restartMenu = cc.MenuItemImage:create("res/restart_btn.png","res/restart_btn.png")
    local menu = cc.Menu:create(self._restartMenu)
    menu:setPosition(ws.width/2,150)
    self:addChild(menu)
    
    --self:scheduleUpdateWithPriorityLua(handler,priority)
    print(os.time())
    
end

function GameLayer:initMapLayer(opt)
    self._mapLayer = require("src/MapLayer").new(opt)
    self._mapLayer:setPosition(0, -50)
    self:addChild(self._mapLayer)
end

return GameLayer