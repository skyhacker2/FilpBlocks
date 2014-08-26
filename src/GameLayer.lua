-- 游戏界面
local GameLayer = class("GameLayer", function() return cc.Layer:create() end)

function GameLayer.scene()
    local scene = cc.Scene:create()
    local layer = GameLayer:create()
    scene:addChild(layer)
    return scene
end

function GameLayer:create(opt)
    local layer = GameLayer.new()
    layer:init(opt)
    return layer
end

function GameLayer:init(opt)
    local opt = opt or {}
    cc.MenuItemFont:setFontName("黑体")
    cc.MenuItemFont:setFontSize(40)
    local hello = cc.MenuItemFont:create("Hello Eleven")
    local menu = cc.Menu:create(hello)
    self:addChild(menu)
end

return GameLayer