local play = game:GetService("ReplicatedStorage"):WaitForChild("Comms").Receive

local CSMan = {}
CSMan.__index = CSMan

function CSMan.new()
	local newCutsceneManager = setmetatable({}, CSMan)
	
	newCutsceneManager.Cutscenes = {}
	
	return newCutsceneManager
end

function CSMan:NewCutscene(movementAmount : number?, name : string, FocusPointsFolder : Folder | Model, LocationPointsFolder : Folder | Model, sets : {{TweenInfo}&{Player}})
	if self.Cutscenes[name] then warn("A cutscene with the same name already exists. Please delete the existing one if you wish to create a new cutscene with the same name.") return end
	
	self.Cutscenes[name] = {}
	
	local newCutscene = self.Cutscenes[name]
	newCutscene.FocusPoints = FocusPointsFolder:GetChildren()
	newCutscene.LocationPoints = LocationPointsFolder:GetChildren()
	
	if not movementAmount then
		if movementAmount == 0 or #newCutscene.FocusPoints == 0 or #newCutscene.LocationPoints == 0 then 
			warn("Must have at least 1 focus and location point.") 
			self:DeleteCutscene(name)
			return 
		end
		
		if #newCutscene.LocationPoints >= #newCutscene.FocusPoints then
			movementAmount = #newCutscene.LocationPoints
		else
			movementAmount = #newCutscene.FocusPoints
		end
	end
	
	newCutscene.Movements = movementAmount
	newCutscene.Settings = sets
	newCutscene.Name = name
	
	--events
	newCutscene.Ended = Instance.new("BindableEvent")
	--
	
	return newCutscene
end

function CSMan.NewSettings(tweenInfo : {TweenInfo}, players : {Players}?)
	if not tweenInfo then warn("No valid argument provided.") return end
	if #tweenInfo < 1 then warn("Must have at least 1 tweenInfo inside the table.") return end
	
	if not players or #players == 0 then players = game.Players:GetPlayers() end
	
	local sets = {}
	sets.Tweens = tweenInfo
	sets.Players = players
	
	return sets
end

function CSMan:Play(cutscene)
	if not cutscene then warn("Must have a valid cutscene argument.") return end

	local moves : number = cutscene.Movements
	local plrs : {Player} = cutscene.Settings.Players
	local tweenSets : {TweenInfo} = cutscene.Settings.Tweens
	local focusPoints : {Instance} = cutscene.FocusPoints
	local locationPoints : {Instance} = cutscene.LocationPoints
	
	local focusPoint, locationPoint, tweenInfo
	
	for move = 1, moves, 1 do
		if focusPoints[move] then focusPoint = focusPoints[move] end
		if locationPoints[move] then locationPoint = locationPoints[move] end
		if tweenSets[move] then tweenInfo = tweenSets[move] end
		
		for _, plr in plrs do
			if plr and type(plr) == Instance and plr:IsA("Player") then continue end
			play:FireClient(plr, {tweenInfo}, locationPoint, focusPoint)
		end
		task.wait(tweenInfo.Time)
	end

	cutscene.Ended:Fire(cutscene)
end

function CSMan:DeleteCutscene(cutscene)
	if not cutscene then warn("No cutscene provided.") return end
	
	if self.Cutscenes[cutscene.Name] then 
		self.Cutscenes[cutscene.Name].Ended:Destroy()
		table.remove(self.Cutscenes, table.find(self.Cutscenes, cutscene))
	else 
		warn(string.format("A cutscene by the name of \"%s\" does not exist.", cutscene.Name)) 
		return 
	end
end

return CSMan
