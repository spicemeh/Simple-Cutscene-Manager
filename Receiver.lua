local tweenService = game:GetService("TweenService")
local cam = workspace.CurrentCamera

game:GetService("ReplicatedStorage"):WaitForChild("Comms").Receive.OnClientEvent:Connect(function(tweenInfo : TweenInfo, location : CFrame, focus : CFrame)
	cam.CameraType = Enum.CameraType.Scriptable
	tweenInfo = TweenInfo.new(table.unpack(tweenInfo))
	
	local goals = {
		CFrame = CFrame.new(location.CFrame.Position, focus.CFrame.Position)
	}
	
	local tween = tweenService:Create(cam, tweenInfo, goals):Play()
end)
