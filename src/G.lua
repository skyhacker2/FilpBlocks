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
