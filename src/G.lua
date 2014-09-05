-- 全局对象

G = {}

function G.formatTime(second)
    local mm = math.floor(second / 60)
    if mm < 10 then
        mm = '0' .. mm
    else
        mm = '' .. mm
    end
    local ss = math.floor(second % 60)
    if ss < 10 then
        ss = '0' .. ss
    else
        ss = '' .. ss
    end
    return mm ..":"..ss
end
function G.takeScreenshot()
    local size = cc.Director:getInstance():getVisibleSize()
    local texture = cc.RenderTexture:create(size.width, size.height)
    texture:setPosition(size.width / 2, size.height / 2)
    texture:begin()
    cc.Director:getInstance():getRunningScene():visit()
    texture:endToLua()
    texture:saveToFile("screenshot.png", cc.IMAGE_FORMAT_PNG)
    print("saved")
end