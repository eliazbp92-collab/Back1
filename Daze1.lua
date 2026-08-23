local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local function spawnShocker()
	local shockerModel = game:GetObjects("rbxassetid://116613156273767")[1]
	local camera = Workspace.CurrentCamera

	local rootPart = shockerModel:FindFirstChild("HumanoidRootPart") or shockerModel:FindFirstChildWhichIsA("BasePart")
	shockerModel.PrimaryPart = rootPart
	shockerModel.Parent = Workspace

	local oogaBoogaaPart = shockerModel:WaitForChild("Base")
	local horrorScream = oogaBoogaaPart:WaitForChild("HORROR SCREAM 15")
	local sb = oogaBoogaaPart:WaitForChild("PlaySound")
	local sb2 = oogaBoogaaPart:WaitForChild("Repent")

	sb.Volume = 1.5
	sb:Play()
	sb2:Play()

	local followConnection
	local startTime = tick()

	followConnection = RunService.RenderStepped:Connect(function()
		if tick() - startTime < 2 then
			local targetCFrame = camera.CFrame * CFrame.new(0, 0, -20)
			shockerModel:PivotTo(CFrame.lookAt(targetCFrame.Position, camera.CFrame.Position))
		else
			if followConnection then
				followConnection:Disconnect()
			end
		end
	end)

	task.wait(2)

	sb:Stop()
	sb2:Stop()
	horrorScream:Play()

	local startPos = rootPart.Position
	local targetDirection = (hrp.Position - startPos).Unit
	local endPos = startPos + (targetDirection * 70)

	local dashInfo = TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local dashTween = TweenService:Create(rootPart, dashInfo, {
		CFrame = CFrame.lookAt(endPos, endPos + targetDirection)
	})

	local hitConnection
	local hasHit = false

	hitConnection = RunService.RenderStepped:Connect(function()
		if hasHit or not hrp then return end

		local distance = (rootPart.Position - hrp.Position).Magnitude
		if distance <= 4.5 then 
			hasHit = true
			humanoid:TakeDamage(30)

			pcall(function()
				ReplicatedStorage.GameStats["Player_".. player.Name].Total.DeathCause.Value = "Shocker"
				firesignal(ReplicatedStorage.RemotesFolder.DeathHint.OnClientEvent, {
					"You encountered Shocker...",
					"Dodge out of its path when it charges!"
				}, "Blue")
			end)
		end
	end)

	dashTween:Play()

	dashTween.Completed:Connect(function()
		if hitConnection then hitConnection:Disconnect() end
	end)

	task.delay(5, function()
		if hitConnection then hitConnection:Disconnect() end
		if shockerModel and shockerModel.Parent then
			shockerModel:Destroy()
		end
	end)

	pcall(function()
		local achievementGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))()
		achievementGiver({
			Title = "Shocking Experience",
			Desc = "Look at me.",
			Reason = "Encounter Shocker.",
			Image = "rbxassetid://17857830685"
		})
	end)
end

spawnShocker()
