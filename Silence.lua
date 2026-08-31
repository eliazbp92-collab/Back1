-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService") 
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera


local function killLocalPlayer()
	local character = LocalPlayer.Character
	if not character then return end

	local currentHealth = 100
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	if playerGui then
		local mainGui = playerGui:FindFirstChild("Main")
		local healthLabel = mainGui and mainGui:FindFirstChild("Health") and mainGui.Health:FindFirstChild("TextLabel")
		if healthLabel and healthLabel:IsA("TextLabel") then
			local cleanText = string.gsub(healthLabel.Text, "[^%d]", "")
			currentHealth = tonumber(cleanText) or 100
		end
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.Health > 0 then
		currentHealth = math.max(currentHealth, humanoid.Health)
	end

	local damageRemote = ReplicatedStorage:FindFirstChild("LocalDamage", true) or ReplicatedStorage:FindFirstChild("ChangeHealth", true)

	if damageRemote then
		if damageRemote.Name == "LocalDamage" then
			damageRemote:FireServer(currentHealth, "SittingItOut", 1, nil)
		else
			damageRemote:FireServer("Damage", currentHealth)
		end
	end

	pcall(function()
		task.spawn(function()
			local pGui = LocalPlayer.PlayerGui
			local entityPage = pGui.Main.AfterDeath.Document.EntityPage

			local imgLabel = entityPage.DeathFrame.Entities.Button.ImageLabel
			imgLabel.Image = "rbxassetid://11535704098"
			entityPage.DeathFrame.EntityName.Text = "Silence"
			pGui.Main.AfterDeath.Document.ScorePage.OverseerNotes.Text = "Stay From the darkness of hill"
		end)
	end)
end

local function caycaycay(TweenBig, ShowStrong, TweenShrinking, MaxStrength, MaxRoughness)
	MaxStrength = MaxStrength or 7.5
	MaxRoughness = MaxRoughness or 60

	local TotalDuration = TweenBig + ShowStrong + TweenShrinking
	local elapsedTime = 0
	local tickCount = 0

	local connection
	connection = RunService.RenderStepped:Connect(function(deltaTime)
		elapsedTime = elapsedTime + deltaTime

		if elapsedTime >= TotalDuration then
			connection:Disconnect()
			return
		end

		local currentStrength = 0

		if elapsedTime <= TweenBig then
			local progress = elapsedTime / (TweenBig > 0 and TweenBig or 0.001)
			local eased = TweenService:GetValue(progress, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			currentStrength = MaxStrength * eased

		elseif elapsedTime <= (TweenBig + ShowStrong) then
			currentStrength = MaxStrength

		else
			local progress = (elapsedTime - TweenBig - ShowStrong) / (TweenShrinking > 0 and TweenShrinking or 0.001)
			local eased = TweenService:GetValue(progress, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			currentStrength = MaxStrength * (1 - eased)
		end

		tickCount = tickCount + deltaTime * MaxRoughness

		local noiseVal = Vector3.new(
			math.noise(tickCount, 0) * 0.5,
			math.noise(0, tickCount) * 0.5,
			math.noise(tickCount, tickCount) * 0.5
		)

		local shakeVector = noiseVal * currentStrength
		local posAccumulator = shakeVector * Vector3.new(0.05, 0.05, 0.05)
		local rotAccumulator = shakeVector * Vector3.new(1, 1, 1)

		local shakeCFrame = CFrame.new(posAccumulator) * CFrame.Angles(
			math.rad(rotAccumulator.X),
			math.rad(rotAccumulator.Y),
			math.rad(rotAccumulator.Z)
		)

		Camera.CFrame = Camera.CFrame * shakeCFrame
	end)

	return connection
end



local GameplayFolder = workspace:WaitForChild("GameplayFolder")
local RoomsFolder = GameplayFolder:WaitForChild("Rooms")

local function getSortedRooms()
	local rooms = {}
	for _, roomModel in ipairs(RoomsFolder:GetChildren()) do
		if roomModel:IsA("Model") then
			local lights = roomModel:FindFirstChild("Lights")
			if lights then
				local sign = lights:FindFirstChild("Sign", true)
				if sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("TextLabel") then
					local roomNum = tonumber(sign.SurfaceGui.TextLabel.Text)
					if roomNum then
						table.insert(rooms, {Model = roomModel, Number = roomNum})
					end
				end
			end
		end
	end
	table.sort(rooms, function(a, b)
		return a.Number > b.Number
	end)
	return rooms
end

local function isPlayerInLocker()
	for _, descendant in ipairs(workspace:GetDescendants()) do
		if descendant:IsA("Model") and descendant.Name == "Locker" then
			local folder = descendant:FindFirstChild("Folder")
			if folder then
				local playerIn = folder:FindFirstChild("PlayerIn")
				if playerIn and (playerIn.Value == true or playerIn.Value == LocalPlayer or playerIn.Value == LocalPlayer.Name) then
					return true
				end
			end
		end
	end
	return false
end

local oldGui = PlayerGui:FindFirstChild("SilenceHeardGui")
if oldGui then oldGui:Destroy() end

local SilenceHeardGui = Instance.new("ScreenGui")
SilenceHeardGui.Name = "SilenceHeardGui"
SilenceHeardGui.IgnoreGuiInset = true
SilenceHeardGui.ResetOnSpawn = false
SilenceHeardGui.DisplayOrder = 1000
SilenceHeardGui.Parent = PlayerGui

local HeardText = Instance.new("TextLabel")
HeardText.Name = "HeardText"
HeardText.AnchorPoint = Vector2.new(0.5, 0.5)
HeardText.Position = UDim2.fromScale(0.5, 0.42)
HeardText.Size = UDim2.fromOffset(700, 100)
HeardText.BackgroundTransparency = 1
HeardText.Text = "You were heard."
HeardText.TextColor3 = Color3.fromRGB(255, 255, 255)
HeardText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
HeardText.TextStrokeTransparency = 0.8
HeardText.TextScaled = true
HeardText.Font = Enum.Font.Oswald
HeardText.Visible = false
HeardText.ZIndex = 10
HeardText.Parent = SilenceHeardGui

local SilenceMonochromeTint = Lighting:FindFirstChild("SilenceMonochromeTint")
if not SilenceMonochromeTint then
	SilenceMonochromeTint = Instance.new("ColorCorrectionEffect")
	SilenceMonochromeTint.Name = "SilenceMonochromeTint"
	SilenceMonochromeTint.Saturation = 0
	SilenceMonochromeTint.Contrast = 0
	SilenceMonochromeTint.Brightness = 0
	SilenceMonochromeTint.TintColor = Color3.fromRGB(255, 255, 255)
	SilenceMonochromeTint.Enabled = false
	SilenceMonochromeTint.Parent = Lighting
end

local DEFAULT_POSITION = UDim2.fromScale(0.5, 0.42)
local shakeConnection = nil
local activeTweens = {}
local textSessionId = 0
local tintTween = nil
local tintSessionId = 0
local diedConnection = nil

local function StopShake()
	if shakeConnection then
		shakeConnection:Disconnect()
		shakeConnection = nil
	end
end

local function CancelTweens()
	for _, tween in ipairs(activeTweens) do
		tween:Cancel()
	end
	table.clear(activeTweens)
end

local function ResetText()
	textSessionId += 1
	StopShake()
	CancelTweens()

	HeardText.Visible = false
	HeardText.Position = DEFAULT_POSITION
	HeardText.Rotation = 0
	HeardText.TextTransparency = 0.8
	HeardText.TextStrokeTransparency = 0.8
	HeardText.TextColor3 = Color3.fromRGB(255, 255, 255)
end

local function StopMonochromeTint(immediate)
	tintSessionId += 1
	local currentSession = tintSessionId

	if tintTween then
		tintTween:Cancel()
		tintTween = nil
	end

	if immediate then
		SilenceMonochromeTint.Saturation = 0
		SilenceMonochromeTint.Contrast = 0
		SilenceMonochromeTint.Brightness = 0
		SilenceMonochromeTint.TintColor = Color3.fromRGB(255, 255, 255)
		SilenceMonochromeTint.Enabled = false
	else
		tintTween = TweenService:Create(SilenceMonochromeTint, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Saturation = 0,
			Contrast = 0,
			Brightness = 0,
			TintColor = Color3.fromRGB(255, 255, 255)
		})
		tintTween:Play()

		task.spawn(function()
			tintTween.Completed:Wait()
			if currentSession == tintSessionId then
				SilenceMonochromeTint.Enabled = false
				tintTween = nil
			end
		end)
	end
end

local function StartMonochromeTint(isRedTint)
	tintSessionId += 1

	if tintTween then
		tintTween:Cancel()
		tintTween = nil
	end

	SilenceMonochromeTint.Enabled = true
	SilenceMonochromeTint.TintColor = isRedTint and Color3.fromRGB(255, 110, 110) or Color3.fromRGB(255, 255, 255)

	local popTween = TweenService:Create(SilenceMonochromeTint, TweenInfo.new(0.01, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		Saturation = 0.2,
		Contrast = 0.15,
		Brightness = 0.25
	})
	popTween:Play()
	popTween.Completed:Wait()

	tintTween = TweenService:Create(SilenceMonochromeTint, TweenInfo.new(5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
		Saturation = -1,
		Contrast = 0.15,
		Brightness = -0.05
	})
	tintTween:Play()
end

local function StartText(duration)
	textSessionId += 1
	local currentSession = textSessionId

	StopShake()
	CancelTweens()

	HeardText.Visible = true
	HeardText.Position = DEFAULT_POSITION
	HeardText.Rotation = 0
	HeardText.TextTransparency = 0.8
	HeardText.TextStrokeTransparency = 0.8
	HeardText.TextColor3 = Color3.fromRGB(255, 255, 255)

	local startTime = os.clock()
	local maxTime = math.max(duration or 3, 0.01)

	shakeConnection = RunService.RenderStepped:Connect(function()
		if currentSession == textSessionId then
			local progress = math.clamp((os.clock() - startTime) / maxTime, 0, 1)
			local offsetMag = progress ^ 2 * 32 + 2
			local rotMag = progress ^ 2 * 10 + 1

			local offsetX = math.random(-math.floor(offsetMag), math.floor(offsetMag))
			local offsetY = math.random(-math.floor(offsetMag), math.floor(offsetMag))

			HeardText.Position = UDim2.new(
				DEFAULT_POSITION.X.Scale, DEFAULT_POSITION.X.Offset + offsetX,
				DEFAULT_POSITION.Y.Scale, DEFAULT_POSITION.Y.Offset + offsetY
			)
			HeardText.Rotation = math.random(-math.floor(rotMag), math.floor(rotMag))
		end
	end)
end

local function LaunchText(isRed)
	textSessionId += 1
	local currentSession = textSessionId

	StopShake()
	CancelTweens()

	if not HeardText.Visible then return end

	HeardText.Position = DEFAULT_POSITION
	HeardText.Rotation = 0
	HeardText.TextColor3 = Color3.fromRGB(255, 255, 255)

	local targetRotation = (math.random(1, 2) == 1) and -360 or 360
	local moveUpTween = TweenService:Create(HeardText, TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(0.5, 0.32)
	})
	table.insert(activeTweens, moveUpTween)
	moveUpTween:Play()

	local targetColor = isRed and Color3.fromRGB(255, 70, 70) or Color3.fromRGB(205, 170, 255)
	local rotateTween = TweenService:Create(HeardText, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		Rotation = targetRotation,
		TextColor3 = targetColor
	})
	table.insert(activeTweens, rotateTween)
	rotateTween:Play()

	task.spawn(function()
		moveUpTween.Completed:Wait()
		if currentSession ~= textSessionId then return end

		local moveDownTween = TweenService:Create(HeardText, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
			Position = UDim2.fromScale(0.5, 1.2)
		})
		table.insert(activeTweens, moveDownTween)
		moveDownTween:Play()
		moveDownTween.Completed:Wait()

		if currentSession == textSessionId then
			HeardText.Visible = false
		end
	end)
end

local function CleanupAll()
	ResetText()
	StopMonochromeTint(true)
end

local function ConnectCharacter(char)
	if diedConnection then
		diedConnection:Disconnect()
		diedConnection = nil
	end
	local hum = char:WaitForChild("Humanoid", 5)
	if hum then
		diedConnection = hum.Died:Connect(CleanupAll)
	end
end

if LocalPlayer.Character then task.spawn(ConnectCharacter, LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(function(char)
	StopMonochromeTint(true)
	ConnectCharacter(char)
end)

local oldModel = workspace:FindFirstChild("Silence")
if oldModel then oldModel:Destroy() end

local Silence5 = "https://github.com/eliazbp92-collab/Back1/raw/main/Silenceretake.rbxm"
Silence5.Name = "Silence"
Silence5.Parent = workspace

local Silence = Silence5:FindFirstChild("RushNew") or Silence5:FindFirstChildWhichIsA("BasePart")
assert(Silence, "Không tìm thấy BasePart cho Silence!")
Silence.Anchored = true

local light = Silence:WaitForChild("PointLight", 2) or Instance.new("PointLight", Silence)

local function GetGitSound(GithubSnd, SoundName)
	local url = GithubSnd
	if not isfile(SoundName .. ".ogg") then
		writefile(SoundName .. ".ogg", game:HttpGet(url))
	end
	local sound = Instance.new("Sound")
	sound.SoundId = (getcustomasset or getsynasset)(SoundName .. ".ogg")
	return sound
end

local githubSound = GetGitSound("https://github.com/eoyoustme/Hardcore/blob/main/sound.ogg?raw=true", "SilenceGithubSound")
githubSound.Volume = 8
githubSound.RollOffMinDistance = 50
githubSound.RollOffMaxDistance = 100
githubSound.RollOffMode = Enum.RollOffMode.Inverse
githubSound.Parent = Silence

local distantSound = GetGitSound("https://github.com/eoyoustme/Impossible/blob/main/XRecorder_Edited_20260728_01.mp3?raw=true", "Distocac")
distantSound.Volume = 7
distantSound.Parent = workspace

local activeRoom = nil

local function ApplyPurpleTextureToRoom(roomObj)
	if not roomObj then return end
	local createdTextures = {}

	for _, part in ipairs(roomObj:GetDescendants()) do
		if part:IsA("BasePart") and part.Name ~= "Silence" and part.Transparency < 0.9 then
			if part.Size.Magnitude > 8 then
				for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
					local tex = Instance.new("Texture")
					tex.Texture = "rbxassetid://11306695974"
					tex.Color3 = Color3.fromRGB(170, 85, 255)
					tex.Face = face
					tex.StudsPerTileU = 48
					tex.StudsPerTileV = 48
					tex.Transparency = 0.66
					tex.Parent = part
					table.insert(createdTextures, tex)
				end
			end
		end
	end

	task.delay(0.2, function()
		for _, tex in ipairs(createdTextures) do
			if tex and tex.Parent then
				local tw = TweenService:Create(tex, TweenInfo.new(4, Enum.EasingStyle.Linear), {Transparency = 1})
				tw:Play()
				tw.Completed:Connect(function() tex:Destroy() end)
			end
		end
	end)
end

local function IsPlayerInRoom(roomObj)
	if not roomObj or not HRP then return false end
	local success, cf, size = pcall(function() return roomObj:GetBoundingBox() end)
	if not success or not cf or not size then return false end

	local localPos = cf:PointToObjectSpace(HRP.Position)
	return math.abs(localPos.X) <= (size.X / 2 + 5)
		and math.abs(localPos.Y) <= (size.Y / 2 + 10)
		and math.abs(localPos.Z) <= (size.Z / 2 + 5)
end

local function PlayStaticJumpscareUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "JumpscareOverlay"
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 999999
	screenGui.Parent = PlayerGui

	local imageLabel = Instance.new("ImageLabel")
	imageLabel.BackgroundTransparency = 1
	imageLabel.BorderSizePixel = 0
	imageLabel.Size = UDim2.new(1, 0, 1, 0)
	imageLabel.ScaleType = Enum.ScaleType.Stretch
	imageLabel.ImageTransparency = 0
	imageLabel.Visible = true
	imageLabel.Parent = screenGui
	imageLabel.ImageColor3 = Color3.fromRGB(85, 0, 127)

	local jumpscareImages = {
		"rbxassetid://134346506410955",
		"rbxassetid://7578853379",
		"rbxassetid://103846711769666",
		"rbxassetid://78199392475572"
	}

	local duration = 1.5
	local start = os.clock()
	local imageIndex = 1

	local tween = TweenService:Create(imageLabel, TweenInfo.new(duration, Enum.EasingStyle.Linear), {ImageTransparency = 1})
	tween:Play()

	while os.clock() - start < duration do
		imageLabel.Image = jumpscareImages[imageIndex]
		imageIndex = (imageIndex % #jumpscareImages) + 1
		task.wait(0.03)
	end

	tween.Completed:Wait()
	screenGui:Destroy()
end

local function CamNear()
	pcall(function()
		caycaycay(0.2,2.771,0.5,2.771,5.771)
	end)
end

local function FovKit(time, Fov, normalfov)
	task.spawn(function()
		local camera = workspace.CurrentCamera
		if not camera then return end

		local tweenIn = TweenService:Create(camera, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {FieldOfView = Fov})
		tweenIn:Play()
		tweenIn.Completed:Wait()

		task.wait(time)

		local tweenOut = TweenService:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {FieldOfView = normalfov})
		tweenOut:Play()
	end)
end

local Kill = true
local isChasing = false
local RemoveSilence

task.spawn(function()
	local roomIndex = 1
	local isFirstSpawn = true

	while Kill do
		if isChasing then break end

		local sortedRooms = getSortedRooms()
		local currentRoomData = sortedRooms[roomIndex]

		if currentRoomData and currentRoomData.Model then
			local roomObj = currentRoomData.Model
			activeRoom = roomObj

			local entityNodes = roomObj:FindFirstChild("EntityNodes")
			local entranceNode = entityNodes and entityNodes:FindFirstChild("Node") or roomObj.PrimaryPart

			if entranceNode then
				Silence.CFrame = entranceNode.CFrame * CFrame.new(0, 70, -35)
				ApplyPurpleTextureToRoom(roomObj)
				githubSound:Play()
				distantSound:Play()

				local tweenDown = TweenService:Create(
					Silence,
					TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ CFrame = entranceNode.CFrame * CFrame.new(0, 2, -35) }
				)
				tweenDown:Play()

				task.spawn(function()
					light.Range = 150
					TweenService:Create(light, TweenInfo.new(1, Enum.EasingStyle.Linear), { Range = 0 }):Play()
				end)

				if isFirstSpawn then
					isFirstSpawn = false
					task.spawn(CamNear)
					task.spawn(PlayStaticJumpscareUI)
				else
					task.spawn(CamNear)
				end

				local distance = (Silence.Position - HRP.Position).Magnitude
				if distance < 50 then
					FovKit(1, 120, 70)
				end

				local stayTime = (roomIndex == 1) and 7 or 2
				local elapsed = 0
				while elapsed < stayTime and Kill and not isChasing do
					task.wait(0.5)
					elapsed = elapsed + 0.5
				end

				if Kill and not isChasing then
					local tweenUp = TweenService:Create(
						Silence,
						TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{ CFrame = entranceNode.CFrame * CFrame.new(0, 70, -35) }
					)
					tweenUp:Play()
					tweenUp.Completed:Wait()

					roomIndex = roomIndex + 1
					if roomIndex > #sortedRooms then
						break
					end
				else
					break
				end
			else
				break
			end
		else
			task.wait(0.5)
			local recheckRooms = getSortedRooms()
			if roomIndex > #recheckRooms then
				break
			end
		end
	end

	if RemoveSilence and not isChasing then
		RemoveSilence()
	end
end)

--------------------------------------------------------------------------------
-- 6. LOGIC HEARTBEAT MINIGAME KHI NÚP TRONG TỦ (PRESSURE LOCKER)
--------------------------------------------------------------------------------
local inMinigame = false

local function StartHeartbeatMinigame()
	if inMinigame or not isChasing then return end
	inMinigame = true

	local isPC = UserInputService.KeyboardEnabled

	local heartbeatGui = Instance.new("ScreenGui")
	heartbeatGui.Name = "HeartbeatMinigame"
	heartbeatGui.IgnoreGuiInset = true
	heartbeatGui.DisplayOrder = 999999
	heartbeatGui.Parent = LocalPlayer.PlayerGui

	local mainButton = Instance.new("ImageButton")
	mainButton.Name = "HeartLabel"
	mainButton.Image = "rbxassetid://8419306829"
	mainButton.Size = UDim2.new(0, 100, 0, 100)
	mainButton.Position = UDim2.new(0.5, 0, 0.95, 0)
	mainButton.AnchorPoint = Vector2.new(0.5, 0.95)
	mainButton.BackgroundTransparency = 1
	mainButton.Parent = heartbeatGui

	local checkingLocker = true
	task.spawn(function()
		while checkingLocker and inMinigame do
			task.wait(0.1)
			if not isPlayerInLocker() then
				Humanoid.Health = 0
				if heartbeatGui and heartbeatGui.Parent then heartbeatGui:Destroy() end
				if RemoveSilence then RemoveSilence() end
				break
			end
		end
	end)

	task.wait(2)

	if not Kill or Humanoid.Health <= 0 or not isPlayerInLocker() then
		checkingLocker = false
		heartbeatGui:Destroy()
		inMinigame = false
		if RemoveSilence then RemoveSilence() end
		return
	end

	local successClicks = 0
	local targetClicks = 5
	local lives = 2

	for i = 1, targetClicks do
		if not Kill or Humanoid.Health <= 0 or not isPlayerInLocker() then break end

		local clickedCorrectly = false
		local hasClickedThisRound = false
		local roundFinished = false

		local ring = Instance.new("ImageLabel")
		ring.Name = "ShrinkingRing"
		ring.Image = "rbxassetid://8419306829"
		ring.ImageTransparency = 0.7
		ring.BackgroundTransparency = 1
		ring.AnchorPoint = Vector2.new(0.5, 0.5)
		ring.Position = UDim2.new(0.5, 0, 0.5, 0)
		ring.Size = UDim2.new(2.5, 0, 2.5, 0)
		ring.Parent = mainButton

		local shrinkTween = TweenService:Create(ring, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
		shrinkTween:Play()

		local startTime = os.clock()
		local clickConn, keyConn

		local function registerInput()
			if hasClickedThisRound or roundFinished then return end
			hasClickedThisRound = true

			local timeElapsed = os.clock() - startTime
			if timeElapsed >= 0.35 and timeElapsed <= 0.8 then
				clickedCorrectly = true
				roundFinished = true
			else
				lives = lives - 1
				if lives <= 0 then Humanoid.Health = 0 end
				roundFinished = true
			end
		end

		clickConn = mainButton.MouseButton1Click:Connect(registerInput)

		if isPC then
			keyConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if input.KeyCode == Enum.KeyCode.Space and not gameProcessed then
					registerInput()
				end
			end)
		end

		local elapsed = 0
		while elapsed < 0.8 and not roundFinished and Humanoid.Health > 0 and isPlayerInLocker() do
			task.wait(0.02)
			elapsed = elapsed + 0.02
		end

		if clickConn then clickConn:Disconnect() end
		if keyConn then keyConn:Disconnect() end
		if ring then ring:Destroy() end

		if Humanoid.Health <= 0 or not isPlayerInLocker() then break end

		if not hasClickedThisRound then
			lives = lives - 1
			if lives <= 0 then
			killLocalPlayer()
				break
			end
		end

		if clickedCorrectly then successClicks = successClicks + 1 end
		task.wait(0.1)
	end

	checkingLocker = false
	heartbeatGui:Destroy()

	if successClicks == targetClicks and Humanoid.Health > 0 then
		if RemoveSilence then RemoveSilence() end
	else
		killLocalPlayer()
		if RemoveSilence then RemoveSilence() end
	end

	inMinigame = false
end

--------------------------------------------------------------------------------
-- 7. CHUỖI TRUY ĐUỔI (CHASE SEQUENCE)
--------------------------------------------------------------------------------
local lastPos = HRP.Position
local damageInterval = 0.054
local thread = nil

local function StartChaseSequence()
	if isChasing then return end
	isChasing = true

	StartText(3)
	LaunchText(true)
	StartMonochromeTint(true)

	task.wait(3)

	local currentChaseTween = nil

	while Kill do
		task.wait(damageInterval)

		-- Kiểm tra trốn tủ theo chuẩn Pressure
		if isPlayerInLocker() then
			if currentChaseTween then
				currentChaseTween:Cancel()
				currentChaseTween = nil
			end

			if Silence and Silence.Parent then
				Silence.Anchored = true
			end

			if not inMinigame then
				StartHeartbeatMinigame()
			end
		end

		-- Đuổi theo khi người chơi ngoài tủ
		if not inMinigame and not isPlayerInLocker() then
			local currentPos = HRP.Position

			if Humanoid.Health > 0 then
				Silence.Anchored = true

				local s = Instance.new("Sound")
				s.SoundId = "rbxassetid://7861818231"
				s.Volume = 0.5
				s.Parent = workspace
				s:Play()
				Debris:AddItem(s, 2)

				local SPEED_STUDS_PER_SECOND = 28
				local targetCFrame = HRP.CFrame
				local distance = (targetCFrame.Position - Silence.Position).Magnitude
				local duration = distance / SPEED_STUDS_PER_SECOND

				if duration <= 0 then duration = 0.05 end

				currentChaseTween = TweenService:Create(
					Silence,
					TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
					{CFrame = targetCFrame}
				)
				currentChaseTween:Play()

				local movedInRoom = IsPlayerInRoom(activeRoom) and (currentPos - lastPos).Magnitude > 0.3

				if distance <= 9 or movedInRoom then
					killLocalPlayer()

					local sound = Instance.new("Sound")
					sound.SoundId = "rbxassetid://4988621968"
					sound.Volume = 10
					sound.PlaybackSpeed = 0.7
					sound.Parent = workspace
					sound:Play()
					Debris:AddItem(sound, 3)

					if RemoveSilence then RemoveSilence() end
					break
				end
			end
			lastPos = currentPos
		end
	end
end


thread = task.spawn(function()
	while Kill and not isChasing do
		task.wait(0.1)
		local currentPos = HRP.Position
		if IsPlayerInRoom(activeRoom) and (currentPos - lastPos).Magnitude > 0.3 then
			StartChaseSequence()
			break
		end
		lastPos = currentPos
	end
end)

local Removed = false

RemoveSilence = function()
	if Removed then return end
	Removed = true
	Kill = false

	StopMonochromeTint()

	if thread then
		task.cancel(thread)
		thread = nil
	end

	if Silence5 and Silence5.Parent then
		Silence5:Destroy()
	end
end
