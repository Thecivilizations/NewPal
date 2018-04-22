Fscene = class("Fcene")

function Fscene:init(bg,em,speedF,music)
	self.music = love.audio.newSource("Music/Fighting/"..music..".mp3")
	self.music:setLooping(true)
	love.audio.play(self.music)
	self.speedF = speedF
	self.background = love.graphics.newImage("/Asserts/Fighting_BG/"..bg..".png")
	self.scale = 1 --0.8
	self.showMagicList = false
	self.enemies = {}
	for k,v in pairs(em) do
		body = Enemies[v.e]
		for i=1,body.shadow do
			table.insert(Enemies[v.e].images,love.graphics.newImage("/Asserts/Fighting_EM/"..body.num.."-"..i..".png"))
		end
		for i=1,body.shadow do
			table.insert(Enemies[v.e].images,love.graphics.newImage("/Asserts/Fighting_EM/"..body.num.."-"..i+body.shadow..".png"))
		end
		for i=1,body.read do
			table.insert(Enemies[v.e].images,love.graphics.newImage("/Asserts/Fighting_EM/"..body.num.."-"..i+(body.shadow*2)..".png"))
			--print(i+(body.shadow*2))
		end
		table.insert(self.enemies,{e=table.copy(Enemies[v.e]),x=v.x,xm=0,ym=0,y=v.y,b=0,state = "stand",co=0,n=0,d=0,f=1,t=0,fo = 1})
	end
	--[[for k,v in pairs(self.enemies) do
		local b = self.enemies[k].e
		for q,w in pairs(v.e) do
			if q~="num" and q~="shadow" and q~="HP" then
				for o,p in pairs(w) do
					if type(p) == "number" then 
						if not self.enemies[k].e[q.."_s"] then
							self.enemies[k].e[q.."_s"] = {}
						end
						self.enemies[k].e[q.."_s"][o] = love.graphics.newImage("/Asserts/Fighting_EM/"..b.num.."-"..p+b.shadow..".png")
						self.enemies[k].e[q][o] = love.graphics.newImage("/Asserts/Fighting_EM/"..b.num.."-"..p..".png")
					end
				end
			end
		end
	end]]
	for k,v in pairs(Chars) do
		for q,w in pairs(Fighting_Char[v]) do
			local b = Fighting_Char[v]
			if type(w) == "table" and q~="num" and q~="shadow" and q~="card" then
				for o,p in pairs(w) do
					if type(p) == "number" then
						if not Fighting_Char[v][q.."_s"] then
							Fighting_Char[v][q.."_s"] = {}
						end
						Fighting_Char[v][q.."_s"][o] = love.graphics.newImage("/Asserts/Fighting_MC/"..b.shadow[1].."-"..p..".png")
						Fighting_Char[v][q][o] = love.graphics.newImage("/Asserts/Fighting_MC/"..b.num[1].."-"..p..".png")
					end
				end
			elseif type(w) == "number" and q~="card" then
				Fighting_Char[v][q] = love.graphics.newImage("/Asserts/Fighting_MC/"..b.num[1].."-"..w..".png")
				Fighting_Char[v][q.."_s"] = love.graphics.newImage("/Asserts/Fighting_MC/"..b.shadow[1].."-"..w..".png")
			elseif q=="card" then
				Fighting_Char[v][q] = love.graphics.newImage("/Asserts/System/"..b.card.."-".."3"..".png")
			end
		end
	end
	self.states = {{s = "stand",x = 0,xs = 300,y = 0,ys = 270,d = 0,f = 1,b=0,mlr = 0,o=1,co=0},{s = "stand",x = 0,xs = 460,y = 0,ys = 240,d = 0,f = 1,b=0,mlr=0,o=1,co=0}}
	self.skyflying = {} -- {x=x,y=y,alpha=alpha}
	self.attackChooseButton = 1
	self.drawButtons = false
	self.timer = 0
	self.enemyChoose = 1
	self.recordNum = 1
	self.chooseMode = false
	self.Act = 0
	self.recordObject = 0
	self.records = {}
	self.magicPlayer = {}
	self.shine = {}
	self.Numbers = {}
	self.isActing = false
	self.chooseType = 1
	self.BG = {}
	self.resume = false
end

function Fscene:update(dt)
	self.timer = self.timer + 60*dt
	for k,v in pairs(self.Numbers) do
		v.t = v.t - 40*dt
		if v.t <= 0 then
			self.Numbers[k] = nil
		end
	end
	for k,v in pairs(self.states) do
		if v.s == "stand" then
			if v.d<1 and not self.isActing then
				self.states[k].d = self.states[k].d + CChars[Chars[k]].Speed/self.speedF*dt
			elseif v.d>1 then
				self.states[k].d = 1
			end
		elseif v.s == "magic" then
			if v.d<1 and not self.isActing then
				--print(Magics[v.mlr].readTime)
				self.states[k].d = self.states[k].d + CChars[Chars[k]].Speed/self.speedF/Magics[v.mlr].readTime*dt
			elseif v.d>1 then
				self.states[k].d = 0
				self.isActing = true
				--print(v.mlr)
				self:playMagicAttackAnimation(k,Magics[v.mlr].ch/24*60,Magics[v.mlr].ed/24*60)
				self.shine = Magics[v.mlr].shine
				if v.o>0 then
					if Magics[v.mlr].im ~= 1 and Magics[v.mlr].im ~= 3 then
						for q,l in pairs(Magics[v.mlr].Animations) do
							table.insert(self.magicPlayer,{o=v.o,ty = Magics[v.mlr].im,mg = v.mlr,p=k,b=l,t=self.timer,x=self.enemies[v.o].x,y=self.enemies[v.o].y,tr = 0,i = love.graphics.newImage("/Asserts/Magic/115-1.png")})
						end
					else
						for q,l in pairs(Magics[v.mlr].Animations) do
							table.insert(self.magicPlayer,{o=v.o,ty = Magics[v.mlr].im,mg = v.mlr,p=k,b=l,t=self.timer,x=self.states[v.o].xs,y=self.states[v.o].ys,tr = 0,i = love.graphics.newImage("/Asserts/Magic/115-1.png")})
						end
					end
				else
					for q,l in pairs(Magics[v.mlr].Animations) do
						table.insert(self.magicPlayer,{o=v.o,ty = Magics[v.mlr].im,mg = v.mlr,p=k,b=l,t=self.timer,x=0,y=0,tr = 0,i = love.graphics.newImage("/Asserts/Magic/115-1.png")})
					end
				end
			end
		elseif v.s == "weak" then
			if v.d<1 and not self.isActing then
				self.states[k].d = self.states[k].d + CChars[Chars[k]].Speed/self.speedF*dt/1.5
			elseif v.d>1 then
				self.states[k].d = 1
			end
		end
		if CChars[Chars[k]].HP < CChars[Chars[k]].MHP/5 and v.s ~= "magic" then
			v.s = "weak"
		elseif CChars[Chars[k]].HP > CChars[Chars[k]].MHP/5 and v.s == "weak" then
			v.s = "stand"
		end
		if CChars[Chars[k]].HP<= 0 then
			CChars[Chars[k]].HP = 0
			v.s = "dead"
			v.d = 0
		end
		if v.b >0 and v.s ~= "magic" and v.s ~= "def" then
			v.b = v.b-100*dt
			v.s = "hitback"
		elseif v.b >0 then
			v.b = v.b-100*dt
		else
			if v.s == "hitback" or v.s == "def" then
				v.s = "stand"
			end
			v.b = 0
		end
		if v.co >0 then
			v.co = v.co - 40*dt
		else
			v.co = 0
		end
	end
	local re
	for k,v in pairs(self.enemies) do
		self.enemies[k].n = self.enemies[k].n -60 *dt
		self.enemies[k].co = self.enemies[k].co - 300*6*dt
		if v.b>0 then
			self.enemies[k].b = self.enemies[k].b -80*dt
		else
			self.enemies[k].b = 0
		end
		if self.enemies[k].n<0 then
			self.enemies[k].co = 0
			self.enemies[k].b = 0
		end
		if not self.isActing then
			self.enemies[k].d = self.enemies[k].d + self.enemies[k].e.speed/self.speedF*dt
		end
		if v.d > 1 and v.state == "stand" then
			self.enemies[k].state = "normalAttack"
			self.enemies[k].fo = math.random(1,#self.states)
			if v.e.normalPlayerAnimation then
				table.insert(self.magicPlayer,{o=v.o,b=v.e.normalPlayerAnimation,t=self.timer,x=self.states[v.fo].xs,y=self.states[v.fo].ys,tr = 0,i = love.graphics.newImage("/Asserts/Magic/115-1.png")})
			end
			self.enemies[k].t= self.timer
			self.isActing = true
		elseif v.state == "normalAttack" then
			for i = 1,#v.e.normalAttack,2 do
				if self.timer - v.t > v.e.normalAttack[i+1] and v.e.normalAttack[i+2] then
					self.enemies[k].f = v.e.normalAttack[i+2]
				elseif self.timer - v.t > v.e.normalAttack[i+1] then
					self.enemies[k].f = 1
					self.enemies[k].state = "stand"
					self.isActing = false
					self.enemies[k].d = 0
					self.enemies[k].xm = 0
					self.enemies[k].ym = 0
				end
			end
			if v.e.normalAttackMove then
				if v.f == v.e.normalAttackMove then
					self.enemies[k].xm = self.enemies[k].xm + (self.states[v.fo].xs-v.x)*dt*1/(20/60)
					self.enemies[k].ym = self.enemies[k].ym + (self.states[v.fo].ys-v.y)*dt*1/(20/60)
				end
			end
			if v.f == v.e.back and self.states[v.fo].b == 0 then
				self.states[v.fo].b = 20
				local damage
				if math.random(1,5) == 1 and self.states[v.fo].s ~= "magic" then
					self.states[v.fo].s = "def"
				else
					if (v.e.attack-0.8*(CChars[Chars[v.fo]].Def)) > v.e.lAttack then
						damage = math.floor((v.e.attack-0.8*(CChars[Chars[v.fo]].Def))*math.random(80,120)/100)
						CChars[Chars[v.fo]].HP = CChars[Chars[v.fo]].HP - damage
						table.insert(self.Numbers,{x=self.states[v.fo].xs+60,y=self.states[v.fo].ys,tex=damage,t=60,col={225,204,51,255}})
					else
						CChars[Chars[v.fo]].HP = CChars[Chars[v.fo]].HP - v.e.lAttack
						table.insert(self.Numbers,{x=self.states[v.fo].xs+60,y=self.states[v.fo].ys,tex=v.e.lAttack,t=60,col={225,204,51,255}})
					end
				end

			end
		end
		if v.e.HP <= 0 then
			re = k
			self.enemyChoose = 1
			table.insert(self.skyflying,{x=v.x,y=v.y,alpha=255,ym=0,img = v.e.images[1]})
		end
	end
	if re then
		table.remove(self.enemies,re)
	end
	local remove
	for k,v in pairs(self.records) do
		if self.states[v.id].s == "hit" then
			for q,w in pairs(v.c) do
				if self.timer - v.time > w and self.states[v.id].s == "hit" then
					if q>=3 then
						self.states[v.id].x = 0
						self.states[v.id].y = 0
						self.states[v.id].f = 1
						self.states[v.id].s = "stand"
						self.isActing = false
						remove = k
					end
					if q==2 then
						self.enemies[v.at].b = 10
						self.enemies[v.at].n = 10
						self.enemies[v.at].co = 300
						local damage = CChars[Chars[v.id]].Attack - self.enemies[v.at].e.defen*0.8 + math.random(-5,5)
						local col = {225,204,51,255}
						local cr = false
						if damage < 1 then
							damage = 1
						end
						if math.random(1,6) == 1 then
							damage = damage * 3
							cr = true
							col = {255,0,85,255}
						end
						if not v.damaged then
							self.enemies[v.at].e.HP = self.enemies[v.at].e.HP - damage
							table.insert(self.Numbers,{x=self.enemies[v.at].x+60,y=self.enemies[v.at].y,tex=damage,t=60,col=col})
						end
						v.damaged = true
					end
					self.states[v.id].f = q+1
				end
			end
		end
		if self.states[v.id].s == "magic" then
			if self.timer - v.time > v.ct then
				self.states[v.id].f = 2
			end
			if self.timer - v.time > v.ce then
				self.states[v.id].s = "stand"
				self.states[v.id].f = 1
				self.isActing = false
				remove = k
			end
		end
		if self.states[v.id].s == "hit" and self.states[v.id].f == 2 then
			self.states[v.id].x = self.states[v.id].x-70/60*dt*(self.states[v.id].xs-self.enemies[self.records[v.id].at].x)*2
			self.states[v.id].y = self.states[v.id].y-70/60*dt*(self.states[v.id].ys-self.enemies[self.records[v.id].at].y)*2
		end
	end
	if remove then
		table.remove(self.records,remove)
	end
	if #self.magicPlayer==0 and self.scale < 1 then
		self.scale = self.scale + 0.5*dt
	elseif #self.magicPlayer==0 then
		self.scale = 1
	end
end

function Fscene:keypressed(key)
	if key == "up" and not self.showMagicList then
		self.attackChooseButton = 1
	elseif key =="right" and not self.showMagicList then
		self.attackChooseButton = 2
		if self.chooseType == 1 then
			if self.enemyChoose>1 then
				self.enemyChoose = self.enemyChoose - 1
			end
		else
			if self.enemyChoose<#self.states then
				self.enemyChoose = self.enemyChoose + 1
			end
		end
	elseif key =="down" and not self.showMagicList then
		self.attackChooseButton = 3
	elseif key == "left" then
		self.attackChooseButton = 4
		if self.chooseType == 1 then
			if self.enemyChoose<#self.enemies then
				self.enemyChoose = self.enemyChoose + 1
			end
		else
			if self.enemyChoose>1 then
				self.enemyChoose = self.enemyChoose - 1
			end
		end
	end
	if key == "return" and self.drawButtons and not self.chooseMode and not self.showMagicList then
		self.isActing = true
		self.drawButtons = false
		for k,v in pairs(self.states) do
			if v.d == 1 then
				if self.attackChooseButton == 1 and #self.enemies==1 then
					self:playNormalAttackAnimation(k,1)
					self.states[k].d = 0
					self.recordNum = k
				elseif self.attackChooseButton == 1 then
					self.chooseMode = true
					self.chooseType = 1
					self.drawButtons = false
					self.recordNum = k
					self.Act = 0
				end
				--[[if self.attackChooseButton == 4 and #self.enemies==1 then
					self.states[self.recordNum].d = 0
					self.chooseMode = false
					self.states[self.recordNum].s = "magic"
					self.states[self.recordNum].f = 1
					self.isActing = false
				elseif self.attackChooseButton == 4 then
					self.states[k].d = 0
					self.chooseMode = true
					self.drawButtons = false
					self.recordNum = k
					self.Act = 1
				end]]
				if self.attackChooseButton == 4 then
					Ml.player = k
					self.showMagicList = true
				end
				return
			end
		end
	elseif key=="return" and self.chooseMode and self.Act == 0 then
		self.states[self.recordNum].d = 0
		self.chooseMode = false
		self:playNormalAttackAnimation(self.recordNum,self.enemyChoose)
	elseif key=="return" and self.chooseMode and self.Act == 1 then
		self.states[self.recordNum].d = 0
		self.chooseMode = false
		self.states[self.recordNum].s = "magic"
		self.states[self.recordNum].f = 1
		self.isActing = false
		self.states[self.recordNum].o = self.enemyChoose
		self.enemyChoose = 1
	end
	if self.showMagicList then
		Ml:keypressed(key)
		if key=="return" then
			for k,v in pairs(self.states) do
				if v.d == 1 then
					self.states[k].mlr = Ml:getID()
					self.showMagicList = false
					if (#self.enemies==1 and Magics[Ml:getID()].ty == "sa") or Magics[Ml:getID()].ty == "aa" then
						print("END")
						self.states[k].d = 0
						self.chooseMode = false
						self.states[k].s = "magic"
						self.states[k].f = 1
						self.states[k].o = 0
						self.isActing = false
					elseif (#Chars==1 and Magics[Ml:getID()].ty == "sr") or Magics[Ml:getID()].ty == "ar" then
						self.states[k].d = 0
						self.chooseMode = false
						self.states[k].s = "magic"
						self.states[k].f = 1
						self.states[k].o = 0
						self.isActing = false
					else
						self.states[k].d = 0
						self.chooseMode = true
						if Magics[Ml:getID()].ty == "sr" then
							self.chooseType = 2
						else
							self.chooseType = 1
						end
						self.drawButtons = false
						self.recordNum = k
						self.Act = 1
					end
				end
				self.enemyChoose = 1
			end
			Ml.select = 1
		end
	end
end

function Fscene:draw()
	love.graphics.clear()
	self.drawButtons = false
	love.graphics.translate((1/self.scale-1)*320*0.8, (1/self.scale-1)*240*0.8)
	love.graphics.scale(self.scale, self.scale)
	love.graphics.draw(self.background, -80, -60)
	for k,v in pairs(self.BG) do
		love.graphics.draw(v.img, v.x, v.y)
	end
	for k,v in pairs(self.enemies) do
		local fe = v.f
		if v.state == "stand" then
			fe = v.e[v.state][math.floor(self.timer/2)%#v.e[v.state]+1]
		end
		love.graphics.setColor(0, 0, 0, 150)
		--love.graphics.draw(v.e.images[v.e[v.state][fe]+v.e.shadow], v.x-v.b+v.xm, v.y-v.b+v.ym)
		love.graphics.draw(v.e.images[fe+v.e.shadow], v.x-v.b+v.xm, v.y-v.b+v.ym)
		love.graphics.setColor(255+v.co, 255+v.co, 255+v.co, 255)
		love.graphics.draw(v.e.images[fe], v.x-v.b+v.xm, v.y-v.b+v.ym)
		--love.graphics.draw(v.e.images[v.e[v.state][fe]], v.x-v.b+v.xm, v.y-v.b+v.ym)
	end
	for k,v in pairs(self.states) do
		p = self.states[k]
		if v.s=="hit" or v.s=="magic" then
			love.graphics.setColor(0,0,0,150)
			--print(v.s,v.f)
			love.graphics.draw(Fighting_Char[Chars[k]][v.s.."_s"][v.f],p.xs+v.x+v.b,p.ys+v.y+v.b)
			love.graphics.setColor(255+v.b*10+v.co*10, 255+v.b*10+v.co*10, 255+v.b*10+v.co*10, 255)
			love.graphics.draw(Fighting_Char[Chars[k]][v.s][v.f],p.xs+v.x+v.b,p.ys+v.y+v.b)
		else
			love.graphics.setColor(0,0,0,150)
			love.graphics.draw(Fighting_Char[Chars[k]][v.s.."_s"],p.xs+v.x+v.b,p.ys+v.y+v.b)
			love.graphics.setColor(255+v.b*10+v.co*10, 255+v.b*10+v.co*10, 255+v.b*10+v.co*10, 255)
			love.graphics.draw(Fighting_Char[Chars[k]][v.s],p.xs+v.x+v.b,p.ys+v.y+v.b)
		end
	end
	if self.chooseMode and self.chooseType == 1 then
		local v = self.enemies[self.enemyChoose]
		local fe = v.f
		if v.state == "stand" then
			fe = math.floor(self.timer/2)%#v.e[v.state]+1
		end
		love.graphics.setColor(500, 500, 500, 500)
		love.graphics.draw(v.e.images[v.e[v.state][fe]], v.x-v.b, v.y-v.b)
	elseif self.chooseMode and self.chooseType == 2 then
		local v = self.states[self.enemyChoose]
		print(self.enemyChoose)
		local fe = v.f
		love.graphics.setColor(500, 500, 500, 500)
		if v.s=="hit" or v.s=="magic" then
			love.graphics.draw(Fighting_Char[Chars[self.enemyChoose]][v.s][v.f],v.xs+v.x+v.b,v.ys+v.y+v.b)
		else
			love.graphics.draw(Fighting_Char[Chars[self.enemyChoose]][v.s],v.xs+v.x+v.b,v.ys+v.y+v.b)
		end
	end
	for k,v in pairs(self.skyflying) do
		self.skyflying[k].alpha = self.skyflying[k].alpha - 255*2*deltaTime
		self.skyflying[k].ym = self.skyflying[k].ym - 200*deltaTime
		love.graphics.setColor(255, 255, 255, v.alpha)
		love.graphics.setBlendMode("add")
		love.graphics.draw(v.img,v.x,v.y+v.ym)
		love.graphics.setBlendMode("alpha")
		love.graphics.draw(v.img,v.x,v.y)
	end
	love.graphics.setColor(255,255,255,255)
	local delete
	for k,v in pairs(self.magicPlayer) do
		if self.scale > 0.8 and v.o==0 and math.floor((self.timer-v.t-v.b[2])*24/60)<v.b[4] then
			self.scale = self.scale - 0.5*deltaTime/#self.magicPlayer
		elseif v.o==0 and math.floor((self.timer-v.t-v.b[2])*24/60)<v.b[4] then
			self.scale = 0.8
		end
		if math.floor((self.timer-v.t-v.b[2])*24/60)>0 and math.floor((self.timer-v.t-v.b[2])*24/60)<v.b[4] and math.floor((self.timer-v.t-v.b[2])*24/60) ~= v.tr then
			self.magicPlayer[k].i = nil
			collectgarbage()
			self.magicPlayer[k].i = love.graphics.newImage("/Asserts/Magic/"..v.b[3].."-"..math.floor((self.timer-v.t-v.b[2])*24/60)..".png")
			self.magicPlayer[k].tr = math.floor((self.timer-v.t-v.b[2])*24/60)
		elseif math.floor((self.timer-v.t-v.b[2])*24/60)>v.b[4] then
			self.magicPlayer[k] = nil
			delete = k
			collectgarbage()
			self.shine = {}
		end
		for q,w in pairs(self.shine) do
			if v.o>0 then
				if math.floor((self.timer-v.t-v.b[2])*24/60)==w and Magics[v.mg].im~=1 and Magics[v.mg].im ~= 3 then
					self.enemies[v.o].n = 10
					self.enemies[v.o].co = 300
				elseif math.floor((self.timer-v.t-v.b[2])*24/60)==w then
					self.states[v.o].co = 20
				end
			else
				for y,u in pairs(self.enemies) do
					if math.floor((self.timer-v.t-v.b[2])*24/60)==w and Magics[v.mg].im~=1 and Magics[v.mg].im ~= 3 then
						self.enemies[y].n = 10
						self.enemies[y].co = 300
					end
				end
				for y,u in pairs(self.states) do
					if math.floor((self.timer-v.t-v.b[2])*24/60)==w and (Magics[v.mg].im~=1 or Magics[v.mg].im ~= 3) then
						self.states[y].co = 20
					end
				end
			end
			if not v.p then
				v.p = -1
			end
			if math.floor((self.timer-v.t-v.b[2])*24/60) == self.shine[#self.shine] and v.p>0 and Magics[v.mg].im~=1 and Magics[v.mg].im ~= 3 and not v.attacked then
				if v.o > 0 then
					local damage = (CChars[Chars[v.p]].Matk*0.6-self.enemies[v.o].e.defen*0.4)*((10-self.enemies[v.o].e.Mdef[v.ty])*0.2)*Magics[v.mg].attack+math.random(-5,5)
					if damage < Magics[v.mg].low then
						damage = Magics[v.mg].low
					end
					damage = math.ceil(damage)
					self.enemies[v.o].e.HP = self.enemies[v.o].e.HP - damage
					table.insert(self.Numbers,{x=self.enemies[v.o].x+60,y=self.enemies[v.o].y,tex=damage,t=60,col={225,204,51,255}})
					self.magicPlayer[k].attacked = true
					if Magics[v.mg].stay then
						table.insert(self.BG,{img = self.magicPlayer[k].i,x=v.x+v.b[5],y=v.y+v.b[6]})
					end
				else
					for y,u in pairs(self.enemies) do
						local damage = (CChars[Chars[v.p]].Matk*0.6-self.enemies[y].e.defen*0.4)*((10-self.enemies[y].e.Mdef[v.ty])*0.2)*Magics[v.mg].attack+math.random(-5,5)
						if damage < Magics[v.mg].low then
							damage = Magics[v.mg].low
						end
						damage = math.ceil(damage)
						self.enemies[y].e.HP = self.enemies[y].e.HP - damage
						table.insert(self.Numbers,{x=self.enemies[y].x+60,y=self.enemies[y].y,tex=damage,t=60,col={225,204,51,255}})
						self.magicPlayer[k].attacked = true
					end
					if Magics[v.mg].stay then
						table.insert(self.BG,{img = self.magicPlayer[k].i,x=v.x+v.b[5],y=v.y+v.b[6]})
					end
				end
				self.shine = {}
			elseif math.floor((self.timer-v.t-v.b[2])*24/60) == self.shine[#self.shine] and v.p>0 and not v.attacked then
				if v.o > 0 then
					local damage = Magics[v.mg].attack
					if damage+CChars[Chars[v.o]].HP> CChars[Chars[v.o]].MHP then
						damage = CChars[Chars[v.o]].MHP - CChars[Chars[v.o]].HP
					end
					CChars[Chars[v.o]].HP = CChars[Chars[v.o]].HP + damage
					table.insert(self.Numbers,{x=self.states[v.o].xs+60,y=self.states[v.o].ys,tex=damage,t=60,col={0,221,0,255}})
					self.magicPlayer[k].attacked = true
				else
					for y,u in pairs(self.states) do
						local damage = Magics[v.mg].attack
						if damage+CChars[Chars[y]].HP> CChars[Chars[y]].MHP then
							damage = CChars[Chars[y]].MHP - CChars[Chars[y]].HP
						end
						CChars[Chars[y]].HP = CChars[Chars[y]].HP + damage
						table.insert(self.Numbers,{x=self.states[y].xs+60,y=self.states[y].ys,tex=damage,t=60,col={0,221,0,255}})
						self.magicPlayer[k].attacked = true
					end
				end
				self.shine = {}
			end
		end
		love.graphics.setBlendMode(v.b[1])
		love.graphics.draw(v.i,v.x+v.b[5],v.y+v.b[6])
		love.graphics.setBlendMode("alpha")
	end
	if delete then
		print(delete)
		table.remove(self.magicPlayer,delete)
	end
	love.graphics.setFont(Fonts.big)
	for k,v in pairs(self.Numbers) do
		love.graphics.setColor(0, 0, 0, 150)
		love.graphics.print(v.tex, v.x+1, v.y+v.t/1.5+1)
		love.graphics.setColor(v.col)
		love.graphics.print(v.tex, v.x, v.y+v.t/1.5)
		love.graphics.setColor(255, 255, 255, 255)
	end
	love.graphics.setFont(Fonts.small)
	love.graphics.scale(1/self.scale, 1/self.scale)
	love.graphics.translate(-(1/self.scale-1)*320*0.8, -(1/self.scale-1)*240*0.8)
	love.graphics.setFont(Fonts.small)
	for k,v in pairs(self.states) do
		local quad = love.graphics.newQuad(0, 112, 144, -112*v.d,144,112)
		local quad2 = love.graphics.newQuad(0, 112, 144*v.d, -112, 144, 112)
		love.graphics.setColor(150, 150, 150, 255)
		love.graphics.draw(Fighting_Char[Chars[k]].card,-130+150*k,480-112)
		love.graphics.setColor(255, 255, 255, 255)
		if v.s == "magic" then
			love.graphics.draw(Fighting_Char[Chars[k]].card,quad2,-130+150*k,480)
		else
		    love.graphics.draw(Fighting_Char[Chars[k]].card,quad,-130+150*k,480)
		end
		love.graphics.setColor(255, 30, 30, 255)
		love.graphics.print(CChars[Chars[k]].HP.."/"..CChars[Chars[k]].MHP,-40+150*k,480-48,0,0.8)
		love.graphics.setColor(30, 30, 255, 255)
		love.graphics.print(CChars[Chars[k]].MP.."/"..CChars[Chars[k]].MMP,-49+150*k,480-30,0,0.76)
		love.graphics.setColor(255, 255, 255, 255)
		if v.d>=1 and v.s == "stand" then
			self.isActing = true
			self.drawButtons = true
		end
	end
	if self.drawButtons and not self.chooseMode then
		love.graphics.setColor(155, 155, 155, 255)
		love.graphics.draw(u, 520, 10)
		love.graphics.draw(r, 520+46, 10+30)
		love.graphics.draw(d, 520, 10+60)
		love.graphics.draw(l, 520-46, 10+30)
		if self.attackChooseButton == 1 then
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(u, 520, 10)
		elseif self.attackChooseButton == 2 then
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(r, 520+46, 10+30)
		elseif self.attackChooseButton == 3 then
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(d, 520, 10+60)
		elseif self.attackChooseButton == 4 then
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(l, 520-46, 10+30)
		end
	end
	if self.showMagicList then
		Ml:draw()
	end
end

function Fscene:playNormalAttackAnimation(id,atk)
	self.records[id]={id = id,time = self.timer,c = {20,40,50},at = atk,damaged = false}
	self.states[id].s = "hit"
end

function Fscene:playMagicAttackAnimation(id,time,time2,at)
	self.records[id]={id = id,time = self.timer,ct = time,ce = time2,at = at,damaged = false}
	self.states[id].s = "magic"
end

function Fscene:touchreleased(id,x,y)
	if y<100 and not self.showMagicList then
		self.attackChooseButton = 1
	elseif x>W-100 and not self.showMagicList then
		self.attackChooseButton = 2
		if self.chooseType == 1 then
			if self.enemyChoose>1 then
				self.enemyChoose = self.enemyChoose - 1
			end
		else
			if self.enemyChoose<#self.states then
				self.enemyChoose = self.enemyChoose + 1
			end
		end
	elseif y>H-100 and not self.showMagicList then
		self.attackChooseButton = 3
	elseif x<100 then
		self.attackChooseButton = 4
		if self.chooseType == 1 then
			if self.enemyChoose<#self.enemies then
				self.enemyChoose = self.enemyChoose + 1
			end
		else
			if self.enemyChoose>1 then
				self.enemyChoose = self.enemyChoose - 1
			end
		end
	end
	if x>100 and x<W-100 and y>100 and y<H-100 and self.drawButtons and not self.chooseMode and not self.showMagicList then
		self.isActing = true
		self.drawButtons = false
		for k,v in pairs(self.states) do
			if v.d == 1 then
				if self.attackChooseButton == 1 and #self.enemies==1 then
					self:playNormalAttackAnimation(k,1)
					self.states[k].d = 0
					self.recordNum = k
				elseif self.attackChooseButton == 1 then
					self.chooseMode = true
					self.chooseType = 1
					self.drawButtons = false
					self.recordNum = k
					self.Act = 0
				end
				--[[if self.attackChooseButton == 4 and #self.enemies==1 then
					self.states[self.recordNum].d = 0
					self.chooseMode = false
					self.states[self.recordNum].s = "magic"
					self.states[self.recordNum].f = 1
					self.isActing = false
				elseif self.attackChooseButton == 4 then
					self.states[k].d = 0
					self.chooseMode = true
					self.drawButtons = false
					self.recordNum = k
					self.Act = 1
				end]]
				if self.attackChooseButton == 4 then
					Ml.player = k
					self.showMagicList = true
				end
				return
			end
		end
	elseif x>100 and x<W-100 and y>100 and y<H-100 and self.chooseMode and self.Act == 0 then
		self.states[self.recordNum].d = 0
		self.chooseMode = false
		self:playNormalAttackAnimation(self.recordNum,self.enemyChoose)
	elseif x>100 and x<W-100 and y>100 and y<H-100 and self.chooseMode and self.Act == 1 then
		self.states[self.recordNum].d = 0
		self.chooseMode = false
		self.states[self.recordNum].s = "magic"
		self.states[self.recordNum].f = 1
		self.isActing = false
		self.states[self.recordNum].o = self.enemyChoose
		self.enemyChoose = 1
	end
	if self.showMagicList then
		Ml:touchreleased(id,x,y)
		if x>100 and x<W-100 and y>100 and y<H-100 then
			for k,v in pairs(self.states) do
				if v.d == 1 then
					self.states[k].mlr = Ml:getID()
					self.showMagicList = false
					if (#self.enemies==1 and Magics[Ml:getID()].ty == "sa") or Magics[Ml:getID()].ty == "aa" then
						self.states[self.recordNum].d = 0
						self.chooseMode = false
						self.states[self.recordNum].s = "magic"
						self.states[self.recordNum].f = 1
						self.isActing = false
					elseif (#Chars==1 and Magics[Ml:getID()].ty == "sr") or Magics[Ml:getID()].ty == "ar" then
						self.states[self.recordNum].d = 0
						self.chooseMode = false
						self.states[self.recordNum].s = "magic"
						self.states[self.recordNum].f = 1
						self.isActing = false
					else
						self.states[k].d = 0
						self.chooseMode = true
						if Magics[Ml:getID()].ty == "sr" then
							self.chooseType = 2
						else
							self.chooseType = 1
						end
						self.drawButtons = false
						self.recordNum = k
						self.Act = 1
					end
				end
				self.enemyChoose = 1
			end
			Ml.select = 1
		end
	end
end