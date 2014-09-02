-- 方块
local Block = class("Block", function() return cc.Sprite:create() end)

-- 颜色对应的纹理图片
local textureStrs = {"res/block1.png", "res/block2.png"}

function Block:ctor(color)
    self.color = color or 1
    self:setAnchorPoint(cc.p(0.5,0.5))
    self:setTexture(textureStrs[self.color])
end

function Block:nextColor()
    self:nextColorDelay(0)
end

-- 延迟翻转
function Block:nextColorDelay(delay)
    self.color = self.color % #textureStrs + 1
    --print(self._color)
    local delay = cc.DelayTime:create(delay)
    local callfunc = cc.CallFunc:create(function() 
        self:setTexture(textureStrs[self.color]) end)
    -- 翻转效果
    local orbit = cc.OrbitCamera:create(0.15,1, 0, 0, 90, 0, 0)
    local orbit2 = cc.OrbitCamera:create(0.15,1, 0, 90, 90, 0, 0)
    self:runAction(cc.Sequence:create(delay, orbit, callfunc, orbit2))
end

return Block