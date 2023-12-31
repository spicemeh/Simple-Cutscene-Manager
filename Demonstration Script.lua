--[[
To setup your location and focus marker you will need to create 2 folders or models, one of them will have your location markers and the other will have your focus markers.
After creating the folders/models you can now put a bunch of parts inside of them and move them around. The location points will be where your camera moves and the focus points will be where your camera
will focus.
]]
local CSMan = require(game.ServerStorage:WaitForChild("CutsceneManager")) -- requiring the module

task.wait(3) -- waiting 3 seconds for stuff to load in

local cutsceneManager = CSMan.new() -- creating a new manager


local tweenTable = {TweenInfo.new(2, Enum.EasingStyle.Quad)} -- you can avoid this and just put all of your tweenInfos inside the NewSettings argument
local sets = CSMan.NewSettings({table.unpack(tweenTable)}) -- unpacking "tweenTable" to avoid tables inside tables

local cutscene = cutsceneManager:NewCutscene(nil, "MyCutscene", workspace.CutsceneMarkers.FocusPoints, workspace.CutsceneMarkers.LocationPoints, sets)
--[[^^^ creating a new cutscene, first argument is the movement amount, you can either choose how many moves you want or let it "calculate"
the max movements. 2nd argument is the name of your cutscene. The 3rd and 4th arguments are the folders or models that include your focus and location
markers which should be regular parts. The last argument is the settings which we already made.
]]
cutscene.Ended.Event:Connect(function(cutscene) -- This is a simple event called "Ended" which will get fired when the cutscene ends.
	print(cutscene.Name.." ended.") 
end)

cutsceneManager:Play(cutscene) -- This will start the cutscene, you just need to give it the cutscene that you want to play.

cutsceneManager:DeleteCutscene(cutscene) -- This will delete the cutscene.
