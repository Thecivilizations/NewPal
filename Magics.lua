Magics = {}
Magics[1] = {
	name = "御剑术",
	attack = 1,
	low = 60,
	ty = "sa",
	readTime = 0.3,
	ch = 10,
	ed = 26,
	im = 4,
	shine = {12,14,16,18,20,22,24,26},
	Animations = {{"alpha",0,85,26,-55,-40}},
}

Magics[2] = {
	name = "观音咒",
	attack = 110,
	ty = "sr",
	readTime = 0.01,
	ch = 90,
	ed = 35,
	im = 1,
	shine = {6,12,18},
	Animations = {{"add",0,88,35,-315,-240}}
}

Magics[3] = {
	name = "元灵归心术",
	attack = 220,
	ty = "sr",
	readTime = 0.01,
	ch = 90,
	ed = 29,
	im = 1,
	shine = {6,12,18},
	Animations = {{"add",0,15,29,-65,-40}}
}

Magics[4] = {
	name = "万剑诀",
	attack = 1.3,
	low = 80,
	ty = "aa",
	readTime = 0.4,
	ch = 15,
	ed = 33,
	im = 4,
	shine = {23,25,28,30,32},
	Animations = {{"alpha",0,83,33,-50,-50}},
	stay = true,
}

Magics[5] = {
	name = "炎咒",
	attack = 1.2,
	low = 70,
	ty = "sa",
	readTime = 0.3,
	ch = 1,
	ed = 20,
	im = 9,
	shine = {5,6,10,13,16},
	Animations = {{"add",0,27,20,-55,-190}},
}

Magics[6] = {
	name = "五气朝元",
	attack = 250,
	ty = "ar",
	readTime = 0.1,
	ch = 90,
	ed = 60,
	im = 1,
	shine = {30,33,36,39,42,45},
	Animations = {{"add",0,143,60,100,100}}
}