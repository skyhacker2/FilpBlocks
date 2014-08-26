-- 卸载所有src/下的模块
for k, v in pairs(package.loaded) do
    if(string.find(k, "^src/")) then
        package.loaded[k] = nil
    end
end
require "Cocos2d"
require "Cocos2dConstants"

-- cclog
cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(640, 1136, 0)
	cc.FileUtils:getInstance():addSearchResolutionsOrder("src");
	cc.FileUtils:getInstance():addSearchResolutionsOrder("res");
    --support debug
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or 
       (cc.PLATFORM_OS_ANDROID == targetPlatform) or (cc.PLATFORM_OS_WINDOWS == targetPlatform) or
       (cc.PLATFORM_OS_MAC == targetPlatform) then
        cclog("result is ")
		--require('debugger')()
        
    end
    
    -- run
	
	if cc.Director:getInstance():getRunningScene() then
		cc.Director:getInstance():replaceScene(require("src/GameLayer").scene())
	else
		cc.Director:getInstance():runWithScene(require("src/GameLayer").scene())
	end

end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
