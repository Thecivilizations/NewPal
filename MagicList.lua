MagicList = class("MagicList")

function MagicList:init()
	self.player = 1
	self.select = 1
end

function MagicList:draw()
	love.graphics.setFont(Fonts.List)
	love.graphics.draw(ir, 9, 0)
	love.graphics.draw(ml, 9, 158)
	for k,v in pairs(CChars[self.player].Magics) do
		love.graphics.setColor(0, 0, 0, 120)
		love.graphics.print(Magics[v].name,(k-1)%3*(600/3)+51,216+math.floor((k-1)/3)*30)
		if self.select == k then
			love.graphics.setColor(100,200,200, 255)
		else
			love.graphics.setColor(100,100,150, 255)
		end
		love.graphics.print(Magics[v].name,(k-1)%3*(600/3)+50,215+math.floor((k-1)/3)*30)
		love.graphics.setColor(255, 255, 255, 255)
	end
	love.graphics.draw(mcs[Magics[CChars[self.player].Magics[self.select]].im],20,35)
end

function MagicList:keypressed(key)
	if key == "right" and CChars[self.player].Magics[self.select+1] then
		self.select = self.select + 1
	elseif key == "left" and self.select>1 then
		self.select = self.select - 1
	elseif key == "down" and CChars[self.player].Magics[self.select+3] then
		self.select = self.select + 3
	elseif key == "up" and self.select>3 then
		self.select = self.select - 3
	end
end

function MagicList:touchreleased(id,x,y)
	if x>W-100 and CChars[self.player].Magics[self.select+1] then
		self.select = self.select + 1
	elseif x<100 and self.select>1 then
		self.select = self.select - 1
	elseif y>H-100 and CChars[self.player].Magics[self.select+3] then
		self.select = self.select + 3
	elseif y<100 and self.select>3 then
		self.select = self.select - 3
	end
end

function MagicList:getID()
	return CChars[self.player].Magics[self.select]
end