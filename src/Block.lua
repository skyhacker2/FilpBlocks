-- 方块
local Block = class("Block", function() return cc.Sprite:create() end)

-- 颜色对应的纹理图片
local textureStrs = {"res/block1.png", "res/block2.png", "res/block3.png"}

function Block:ctor(color)
    self._color = color or 1
    self:setTexture(textureStrs[self._color])
end

function Block:nextColor(max)
    local max = max or #textureStrs
    self._color = self._color % max + 1
    --print(self._color)
    self:setTexture(textureStrs[self._color])
end

function Block:getColor()
    return self._color
end

return Block