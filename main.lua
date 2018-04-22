
io.stdout:setvbuf("no") --控制台输出窗口,优先输出如果没有则在程序结束后再输出的

--[[ 
	项目主体部分
	
--]]

math.randomseed(os.time())
class = require "middleclass"
require "Fighting_Char"
require "Fighting_Enemy"
require "Main_Char"
require "Fscene"
require "Magics"
require "MagicList"

function love.load() --资源加载回调函数，仅初始化时调用一次
	Fonts = {}
	Fonts["small"] = love.graphics.newFont("impact.ttf", 16)
	Fonts["big"] = love.graphics.newFont("impact.ttf", 30)
	Fonts["List"] = love.graphics.newFont("STXINGKA.TTF", 20)
 	Chars = {1,2}
 	love.graphics.setDefaultFilter("nearest", "nearest")
 	Ml = MagicList()
	Fs = Fscene("4-7",{{e=3,x=250,y=50},{e=4,x=120,y=30},{e=3,x=40,y=160}},400,"1")
	loadSystemAsserts()
	W,H = love.window.getDesktopDimensions()
	if love.system.getOS() == "Windows" then
		W = 640
		H = 480
	end
	Screen = love.graphics.newCanvas(W*2,H*2)
	shadowCanvas = love.graphics.newCanvas(W*2,H*2)
	deltaTime = 0
end



function love.update(dt) --更新回调函数，每周期调用
	Fs:update(dt)
	deltaTime = dt
end




function love.draw() --绘图回调函数，每周期调用
	love.graphics.setCanvas(Screen)
	Fs:draw()
	love.graphics.setCanvas(shadowCanvas)
	love.graphics.setColor(255, 255, 255, 6000*deltaTime)
	love.graphics.draw(Screen, (W-640*(H/480))/2,0,0,H/480)
	love.graphics.setColor(255, 255, 255, 255)
	--Ml:draw()
	love.graphics.setCanvas()
	love.graphics.draw(shadowCanvas,0,0)
	love.graphics.print(love.timer.getFPS())
end



function love.keypressed(key) --键盘检测回调函数，当键盘事件触发是调用
	Fs:keypressed(key)
	--Ml:keypressed(key)
end



function love.touchpressed(id,x,y) --回调函数释放鼠标按钮时触发。
	Fs:touchreleased(id,x,y)
end

function table.copy( obj )      
    local InTable = {};  
    local function Func(obj)  
        if type(obj) ~= "table" then   --判断表中是否有表  
            return obj;  
        end  
        local NewTable = {};  --定义一个新表  
        InTable[obj] = NewTable;  --若表中有表，则先把表给InTable，再用NewTable去接收内嵌的表  
        for k,v in pairs(obj) do  --把旧表的key和Value赋给新表  
            NewTable[Func(k)] = Func(v);  
        end  
        return setmetatable(NewTable, getmetatable(obj))--赋值元表  
    end  
    return Func(obj) --若表中有表，则把内嵌的表也复制了  
end  

function loadSystemAsserts()
	rt = love.graphics.newImage("Asserts/System/105-1.png")
	u = love.graphics.newImage("Asserts/System/19-1.png")
	r = love.graphics.newImage("Asserts/System/19-2.png")
	l = love.graphics.newImage("Asserts/System/19-3.png")
	d = love.graphics.newImage("Asserts/System/19-4.png")
	ml = love.graphics.newImage("Asserts/System/10-1.png")
	ir = love.graphics.newImage("Asserts/System/8-2.png")
	mcs = {}
	for i=1,10 do
		table.insert(mcs,love.graphics.newImage("Asserts/System/9-"..i..".png"))
	end
end