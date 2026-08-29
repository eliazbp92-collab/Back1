if workspace:FindFirstChild("IsM") then
	return
else
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

local heartModelUrl = "https://github.com/eoyoustme/Impossible/raw/main/Heart.rbxm"

local function getgithubmodeL(url)
	if not (writefile and getcustomasset and request) then 
		warn("Exploit environment does not support request/writefile/getcustomasset")
		return nil 
	end
	local fileName = string.match(url, "([^/]+)$") or "temp_model.rbxm"
	local response = request({Url = url, Method = "GET"})
	if response.StatusCode ~= 200 then return nil end
	writefile(fileName, response.Body)
	local assetId = getcustomasset(fileName)
	local success, result = pcall(function() return game:GetObjects(assetId)[1] end)
	return success and result or nil
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
HeardText.TextColor3 = Color3.fromRGB(124,124,124)
HeardText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
HeardText.TextStrokeTransparency = 0.6
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
local DEFAULT_SIZE = UDim2.fromOffset(700, 100)
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
	HeardText.Size = DEFAULT_SIZE
	HeardText.Rotation = 0
	HeardText.TextTransparency = 0
	HeardText.TextStrokeTransparency = 0.6
	HeardText.TextColor3 = Color3.fromRGB(124,124,124)
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
	SilenceMonochromeTint.TintColor = isRedTint and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(255, 255, 255)

	local popTween = TweenService:Create(SilenceMonochromeTint, TweenInfo.new(0.01, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		Saturation = 0.2,
		Contrast = 0.15,
		Brightness = 0.25
	})
	popTween:Play()
	popTween.Completed:Wait()

	tintTween = TweenService:Create(SilenceMonochromeTint, TweenInfo.new(5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
		Saturation = -1,
		Contrast = 0.2,
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
	HeardText.Size = UDim2.fromOffset(850, 130) 
	HeardText.Rotation = 0
	HeardText.TextTransparency = 0
	HeardText.TextStrokeTransparency = 0.1
	HeardText.TextColor3 = Color3.fromRGB(255, 30, 30)

	local popScaleTween = TweenService:Create(HeardText, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = DEFAULT_SIZE
	})
	table.insert(activeTweens, popScaleTween)
	popScaleTween:Play()

	local startTime = os.clock()
	local maxTime = math.max(duration or 3, 0.01)

	shakeConnection = RunService.RenderStepped:Connect(function()
		if currentSession == textSessionId then
			local progress = math.clamp((os.clock() - startTime) / maxTime, 0, 1)
			local offsetMag = progress ^ 1.8 * 40 + 4
			local rotMag = progress ^ 1.8 * 14 + 2

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
	HeardText.TextColor3 = Color3.fromRGB(255, 45, 45)

	local targetRotation = (math.random(1, 2) == 1) and -360 or 360
	local moveUpTween = TweenService:Create(HeardText, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(0.5, 0.30),
		Size = UDim2.fromOffset(780, 115)
	})
	table.insert(activeTweens, moveUpTween)
	moveUpTween:Play()

	local targetColor = isRed and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(205, 170, 255)
	local rotateTween = TweenService:Create(HeardText, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		Rotation = targetRotation,
		TextColor3 = targetColor
	})
	table.insert(activeTweens, rotateTween)
	rotateTween:Play()

	task.spawn(function()
		moveUpTween.Completed:Wait()

		if currentSession ~= textSessionId then return end

		local moveDownTween = TweenService:Create(HeardText, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
			Position = UDim2.fromScale(0.5, 1.3),
			Size = UDim2.fromOffset(600, 80)
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

if LocalPlayer.Character then
	task.spawn(ConnectCharacter, LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(char)
	StopMonochromeTint(true)
	ConnectCharacter(char)
end)

local oldModel = workspace:FindFirstChild("Silence")
if oldModel then oldModel:Destroy() end

local Silence5 = "https://github.com/eliazbp92-collab/Back1/raw/main/Place_131351567799504_Model_Silence_1787970104.rbxm"
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

local githubSound = GetGitSound("https://github.com/eoyoustme/Hardcore/blob/main/sound.ogg?raw=true", "SilenceGi00thubSound")
githubSound.Volume = 8
githubSound.RollOffMinDistance = 50
githubSound.RollOffMaxDistance = 100
githubSound.RollOffMode = Enum.RollOffMode.Inverse
githubSound.Parent = Silence

local distantSound = GetGitSound("https://github.com/eoyoustme/Impossible/blob/main/XRecorder_Edited_20260728_01.mp3?raw=true", "Distocac")
distantSound.Volume = 7
distantSound.Parent = workspace

local activeRoom = nil
local is = true

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
					task.spawn(function()
						while is do
							wait(0.05)
							tex.StudsPerTileU = Random.new():NextInteger(30,50)
							tex.StudsPerTileV = Random.new():NextInteger(30,50)
						end
					end)
				end
			end
		end
	end

	task.delay(0.2, function()
		for _, tex in ipairs(createdTextures) do
			if tex and tex.Parent then
				local tw = TweenService:Create(tex, TweenInfo.new(4, Enum.EasingStyle.Linear), {Transparency = 1})
				tw:Play()
				tw.Completed:Connect(function()
					tex:Destroy()
				end)
			end
		end
	end)
end

local function IsPlayerInRoom(roomObj)
	if not roomObj or not HRP then return false end
	local success, cf, size = pcall(function()
		return roomObj:GetBoundingBox()
	end)
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
	imageLabel.Position = UDim2.new(0, 0, 0, 0)
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

	local info = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local tween = TweenService:Create(imageLabel, info, {ImageTransparency = 1})
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
		local CameraShaker = require(game.ReplicatedStorage.CameraShaker)
		local camera = game.Workspace.CurrentCamera
		local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
			camera.CFrame = camera.CFrame * shakeCf
		end)
		camShake:Start()
		camShake:ShakeOnce(40, 20, 0, 2, 2, 12)
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
local currentRooms = workspace:WaitForChild("CurrentRooms")
local RemoveSilence

task.spawn(function()
	local latestVal = ReplicatedStorage.GameData.LatestRoom.Value
	local currentRoomIndex = math.max(0, latestVal - 4)
	local isFirstSpawn = true

	while Kill do
		if isChasing then
			task.wait(0.2)
		else
			local roomObj = currentRooms:FindFirstChild(tostring(currentRoomIndex)) or currentRooms:FindFirstChild(currentRoomIndex)

			if roomObj then
				activeRoom = roomObj
				local entrance = roomObj:WaitForChild("RoomEntrance", 2) or roomObj.PrimaryPart

				if entrance then
					Silence.CFrame = entrance.CFrame * CFrame.new(0, 70, -35)
					ApplyPurpleTextureToRoom(roomObj)
					githubSound:Play()
					distantSound:Play()

					local tweenDown = TweenService:Create(
						Silence,
						TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{ CFrame = entrance.CFrame * CFrame.new(0, 2, -35) }
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

					local targetMaxRoomActually = ReplicatedStorage.GameData.LatestRoom.Value
					local stayTime = (currentRoomIndex >= targetMaxRoomActually) and 7 or 2

					local elapsed = 0
					while elapsed < stayTime and Kill and not isChasing do
						task.wait(0.5)
						elapsed = elapsed + 0.5
					end

					local targetMaxRoom = ReplicatedStorage.GameData.LatestRoom.Value + 1 
					if currentRoomIndex < targetMaxRoom and Kill and not isChasing then
						local tweenUp = TweenService:Create(
							Silence,
							TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
							{ CFrame = entrance.CFrame * CFrame.new(0, 70, -35) }
						)
						tweenUp:Play()
						tweenUp.Completed:Wait()
						currentRoomIndex = currentRoomIndex + 1
					elseif not isChasing then
						break
					end
				else
					break
				end
			else
				task.wait(0.5)
				if currentRoomIndex > ReplicatedStorage.GameData.LatestRoom.Value then
					break
				end
			end
		end
	end

	if RemoveSilence and not isChasing then
		RemoveSilence()
	end
end)

local minigameActive = false
local minigameCooldown = false
local isImmune = false -- [THÊM MỚI] Trạng thái bất tử
local soundList = {}

local function setupHeartbeatUI()
	local MainUI = PlayerGui:WaitForChild("MainUI")
	local MainFrame = MainUI:WaitForChild("MainFrame")

	local heartbeatFrame = MainFrame:FindFirstChild("Heartbeat")
	if not heartbeatFrame then
		local downloadedModel = getgithubmodeL(heartModelUrl)
		if downloadedModel then
			downloadedModel.Name = "Heartbeat"
			downloadedModel.Parent = MainFrame
			heartbeatFrame = downloadedModel
		else
			warn("Không thể tải UI Heart.rbxm!")
		end
	end
	return heartbeatFrame
end

task.spawn(setupHeartbeatUI)

local function playMinigameSound(parent, soundObj, speed)
	if not soundObj then return end
	local clone = soundObj:Clone()
	clone.Volume = soundObj.Volume
	clone.PlaybackSpeed = speed or soundObj.PlaybackSpeed
	clone.TimePosition = 0
	clone.Looped = false
	clone.Parent = parent
	table.insert(soundList, clone)
	clone:Play()
	clone.Destroying:Once(function()
		local idx = table.find(soundList, clone)
		if idx then table.remove(soundList, idx) end
	end)
	return clone
end

local function cleanupMinigameSounds()
	local clonedList = table.clone(soundList)
	table.clear(soundList)
	for _, snd in ipairs(clonedList) do
		if snd and snd.Parent then
			snd:Stop()
			snd:Destroy()
		end
	end
end

local function runSilenceMinigame(beatInterval, beatTimings)
	beatInterval = beatInterval or 0.6
	beatTimings = (typeof(beatTimings) == "table" and #beatTimings > 0) and beatTimings or {beatInterval, beatInterval, beatInterval, beatInterval}

	if minigameActive or minigameCooldown or isImmune then return false end
	cleanupMinigameSounds()
	minigameActive = true

	local Heartbeat_2 = setupHeartbeatUI()
	if not Heartbeat_2 then 
		minigameActive = false 
		return false
	end

	local Heart = Heartbeat_2:FindFirstChild("Heart")
	local ActualHeart = Heart and Heart:FindFirstChild("ActualHeart")
	local Heartbeat = Heart and Heart:FindFirstChild("Heartbeat")
	local Messup = Heart and Heart:FindFirstChild("Messup")
	local Engage = Heart and Heart:FindFirstChild("Engage")
	local TextLabel = Heartbeat_2:FindFirstChild("TextLabel")

	Heartbeat_2:SetAttribute("HeartbeatOwner", "Silence")

	local u52 = Color3.fromRGB(196, 40, 40)
	local u47 = Color3.fromRGB(126, 245, 255)
	local u57 = Color3.fromRGB(162, 162, 162)

	local topText = Heartbeat_2:FindFirstChild("SilenceTopText") or (TextLabel and TextLabel:Clone())
	if topText then
		topText.Name = "SilenceTopText"
		topText.Parent = Heartbeat_2
		topText.AnchorPoint = Vector2.new(0.5, 0.5)
		topText.Position = UDim2.fromScale(0.5, 0.22)
		topText.Size = UDim2.fromOffset(700, 50)
		topText.Font = Enum.Font.Oswald
		topText.Text = "Keep your heartbeat still."
		topText.TextColor3 = Color3.fromRGB(255, 255, 255)
		topText.TextTransparency = 1
		topText.Visible = false
	end

	local bottomText = Heartbeat_2:FindFirstChild("SilenceBottomText") or (TextLabel and TextLabel:Clone())
	if bottomText then
		bottomText.Name = "SilenceBottomText"
		bottomText.Parent = Heartbeat_2
		bottomText.AnchorPoint = Vector2.new(0.5, 0.5)
		bottomText.Position = UDim2.fromScale(0.5, 0.28)
		bottomText.Size = UDim2.fromOffset(700, 40)
		bottomText.Font = Enum.Font.Oswald
		bottomText.Text = "She won't detect you."
		bottomText.TextColor3 = Color3.fromRGB(190, 190, 190)
		bottomText.TextTransparency = 1
		bottomText.Visible = false
	end

	local countdownText = Heart:FindFirstChild("SilenceBeatCountdown") or (TextLabel and TextLabel:Clone())
	if countdownText then
		countdownText.Name = "SilenceBeatCountdown"
		countdownText.Parent = Heart
		countdownText.AnchorPoint = Vector2.new(0.5, 0.5)
		countdownText.Position = UDim2.fromScale(0.5, 0.5)
		countdownText.Size = UDim2.fromScale(0.65, 0.65)
		countdownText.BackgroundTransparency = 1
		countdownText.Font = Enum.Font.Oswald
		countdownText.TextScaled = true
		countdownText.TextColor3 = Color3.fromRGB(255, 255, 255)
		countdownText.TextTransparency = 1
		countdownText.ZIndex = Heart.ZIndex + 2
		countdownText.Visible = false
	end

	local inputHint = Heart:FindFirstChild("SilenceInputHint") or (TextLabel and TextLabel:Clone())
	if inputHint then
		inputHint.Name = "SilenceInputHint"
		inputHint.Parent = Heart
		inputHint.AnchorPoint = Vector2.new(0, 0.5)
		inputHint.Position = UDim2.new(8, 0, 0.5, 0)
		inputHint.Size = UDim2.fromOffset(420, 70)
		inputHint.BackgroundTransparency = 1
		inputHint.Font = Enum.Font.Oswald
		inputHint.Text = "SPACE / A BUTTON / TAP"
		inputHint.TextScaled = false
		inputHint.TextSize = 36
		if inputHint:FindFirstChildOfClass("UITextSizeConstraint") then
			inputHint:FindFirstChildOfClass("UITextSizeConstraint"):Destroy()
		end
		inputHint.TextWrapped = false
		inputHint.TextXAlignment = Enum.TextXAlignment.Left
		inputHint.TextColor3 = Color3.fromRGB(255, 255, 255)
		inputHint.TextTransparency = 1
		inputHint.ZIndex = Heart.ZIndex + 2
		inputHint.Visible = false
	end

	if not Heart or not ActualHeart then
		minigameActive = false
		return false
	end

	local function beat()
		playMinigameSound(Heart, Heartbeat)
		ActualHeart.Size = UDim2.new(1.28, 0, 1.28, 0)
		local tweenDur = math.min(0.32, beatInterval * 0.55)
		TweenService:Create(ActualHeart, TweenInfo.new(tweenDur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
	end

	local function flashRed()
		playMinigameSound(Heart, Messup)
		ActualHeart.ImageColor3 = u52
		ActualHeart.Size = UDim2.new(1.4, 0, 1.4, 0)
		TweenService:Create(ActualHeart, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
	end

	Heartbeat_2.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
	Heartbeat_2.Visible = true
	TweenService:Create(Heartbeat_2, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 0.25}):Play()

	ActualHeart.ImageColor3 = u57
	ActualHeart.Visible = true
	Heart.ImageColor3 = u57
	Heart.ImageTransparency = 1
	Heart.Visible = true
	Heart.Position = UDim2.new(0.5, 0, 2, 0)

	local heartTween = TweenService:Create(Heart, TweenInfo.new(3, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.95, 0)})
	heartTween:Play()
	playMinigameSound(Heart, Engage)

	if TextLabel then TextLabel.Visible = false end

	if topText then
		topText.Visible = true
		TweenService:Create(topText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
	end

	task.wait(0.6)

	if bottomText then
		bottomText.Visible = true
		TweenService:Create(bottomText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
	end

	heartTween.Completed:Wait()

	if topText then TweenService:Create(topText, TweenInfo.new(0.4), {TextTransparency = 1}):Play() end
	if bottomText then TweenService:Create(bottomText, TweenInfo.new(0.4), {TextTransparency = 1}):Play() end
	task.wait(0.4)

	if TextLabel then
		TextLabel.Visible = true
		TextLabel.Text = "Listen..."
	end

	local targetCount = #beatTimings + 1
	if countdownText then
		countdownText.Text = tostring(targetCount)
		countdownText.TextTransparency = 1
		countdownText.Visible = true
		TweenService:Create(countdownText, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
	end

	for i = 1, targetCount do
		if not Character:GetAttribute("Hiding") then
			minigameActive = false
			return false
		end
		if countdownText then countdownText.Text = tostring(targetCount - i + 1) end
		beat()
		local waitTime = beatTimings[i] or beatInterval
		task.wait(waitTime)
	end

	if TextLabel then TextLabel.Text = "Keep the beat." end
	if inputHint then
		inputHint.Text = "SPACE / A BUTTON / TAP"
		inputHint.Position = UDim2.new(8, 0, 0.5, 0)
		inputHint.TextTransparency = 1
		inputHint.Visible = true
		TweenService:Create(inputHint, TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 0, Position = UDim2.new(1.15, 0, 0.5, 0)}):Play()
	end

	Heart.ImageColor3 = Color3.fromRGB(189, 189, 189)
	TweenService:Create(Heart, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0.3}):Play()

	local clickTimes = {}
	local minigameFinished = false
	local minigameSuccess = false
	local tolerance = 0.3
	local startTime = os.clock()

	local inputConn
	inputConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if minigameFinished or not Character:GetAttribute("Hiding") then return end

		local isValidInput = false
		if input.KeyCode == Enum.KeyCode.ButtonA or input.KeyCode == Enum.KeyCode.Space then
			isValidInput = true
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			isValidInput = true
		elseif input.UserInputType == Enum.UserInputType.Touch then
			local pos = input.Position
			local absPos = Heart.AbsolutePosition
			local absSize = Heart.AbsoluteSize
			if pos.X >= absPos.X and pos.X <= absPos.X + absSize.X and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y then
				isValidInput = true
			end
		end

		if not isValidInput then return end

		local now = os.clock()
		if #clickTimes == 0 then
			table.insert(clickTimes, now)
			beat()
			if targetCount <= 1 and not minigameFinished then
				minigameFinished = true
				minigameSuccess = true
			end
			return
		end

		local targetDelay = beatTimings[#clickTimes] or beatInterval
		local diff = math.abs(now - (clickTimes[#clickTimes] + targetDelay))

		if diff > tolerance then
			flashRed()
			if not minigameFinished then
				minigameFinished = true
				minigameSuccess = false
			end
			return
		end

		table.insert(clickTimes, now)
		beat()

		if #clickTimes >= targetCount and not minigameFinished then
			minigameFinished = true
			minigameSuccess = true
		end
	end)

	while not minigameFinished do
		if not Character:GetAttribute("Hiding") then
			inputConn:Disconnect()
			minigameActive = false
			return false
		end

		local now = os.clock()
		if #clickTimes ~= 0 then
			if #clickTimes < targetCount then
				local lastBeat = clickTimes[#clickTimes]
				local expectedNext = beatTimings[#clickTimes] or beatInterval
				if lastBeat + expectedNext + tolerance < now then
					flashRed()
					if not minigameFinished then
						minigameFinished = true
						minigameSuccess = false
					end
				end
			end
		elseif startTime + (beatInterval * 4) + 1 < now then
			flashRed()
			if not minigameFinished then
				minigameFinished = true
				minigameSuccess = false
			end
		end
		task.wait()
	end

	inputConn:Disconnect()
	cleanupMinigameSounds()

	if inputHint then
		TweenService:Create(inputHint, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {TextTransparency = 1, Position = UDim2.new(8, 0, 0.5, 0)}):Play()
	end

	if TextLabel then TextLabel.Text = minigameSuccess and "Steady." or "Irregular!" end

	local resultColor = minigameSuccess and u47 or u52
	Heart.ImageColor3 = resultColor
	Heart.ImageTransparency = 0
	ActualHeart.ImageColor3 = resultColor

	TweenService:Create(Heart, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
	TweenService:Create(ActualHeart, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageColor3 = u57}):Play()

	task.wait(0.6)

	if TextLabel then TextLabel.Visible = false TextLabel.Text = "" end
	if topText then topText.Visible = false end
	if bottomText then bottomText.Visible = false end
	if countdownText then countdownText.Visible = false end
	if inputHint then inputHint.Visible = false end

	TweenService:Create(Heart, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 2, 0)}):Play()
	TweenService:Create(Heartbeat_2, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()

	task.wait(0.4)
	Heartbeat_2.Visible = false
	Heart.Visible = false
	Heart.ImageTransparency = 1
	Heart.ImageColor3 = u57
	Heart.Position = UDim2.new(0.5, 0, 2, 0)
	ActualHeart.Visible = false
	ActualHeart.ImageColor3 = u57
	ActualHeart.Size = UDim2.new(1, 0, 1, 0)

	if Heartbeat_2:GetAttribute("HeartbeatOwner") == "Silence" then
		Heartbeat_2:SetAttribute("HeartbeatOwner", nil)
	end

	minigameActive = false
	return minigameSuccess
end

local lastPos = HRP.Position
local damageInterval = 0.054
local thread = nil

local function StartChaseSequence()
	if isChasing or isImmune then return end
	isChasing = true

	StartText(3)
	task.wait(3)

	StartMonochromeTint(true)
	LaunchText(true)

	local currentChaseTween = nil

	while Kill and isChasing do
		task.wait(damageInterval)

		if Character:GetAttribute("Hiding") then
			if currentChaseTween then
				currentChaseTween:Cancel()
				currentChaseTween = nil
			end

			if Silence and Silence.Parent then
				Silence.Anchored = true
			end

			if not minigameActive and not minigameCooldown and not isImmune then
				local passed = runSilenceMinigame(0.6, {0.6, 0.6, 0.6, 0.6})

				if passed then
					isChasing = false
					isImmune = true
					minigameCooldown = true

					StopMonochromeTint(false)
					ResetText()

					if Silence and Silence.Parent and activeRoom then
						local entrance = activeRoom:FindFirstChild("RoomEntrance") or activeRoom.PrimaryPart
						if entrance then
							Silence.CFrame = entrance.CFrame * CFrame.new(0, 70, -35)
						end
					end

					-- Kích hoạt đếm ngược 7 giây bất tử & cooldown minigame
					task.delay(7, function()
						isImmune = false
						minigameCooldown = false
					end)

					break
				else
					if not isImmune then
						Humanoid.Health = 0
						if ReplicatedStorage:FindFirstChild("GameStats") and ReplicatedStorage.GameStats:FindFirstChild("Player_".. LocalPlayer.Name) then
							ReplicatedStorage.GameStats["Player_".. LocalPlayer.Name].Total.DeathCause.Value = "Silence"
						end
						if RemoveSilence then 
							RemoveSilence() 
						end
					end
					break
				end
			end
		end

		local yes = Character:GetAttribute("Crouching")
		if not minigameActive and not Character:GetAttribute("Hiding") and not yes and not isImmune then
			local currentPos = HRP.Position

			pcall(function()
				require(LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption("", true)
			end)

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

				local movedUncrouchedInRoom = IsPlayerInRoom(activeRoom) and not Character:GetAttribute("Crouching") and (currentPos - lastPos).Magnitude > 0.3

				if distance <= 9 and movedUncrouchedInRoom and not isImmune then
					Humanoid.Health = 0

					if ReplicatedStorage:FindFirstChild("GameStats") and ReplicatedStorage.GameStats:FindFirstChild("Player_".. LocalPlayer.Name) then
						ReplicatedStorage.GameStats["Player_".. LocalPlayer.Name].Total.DeathCause.Value = "Silence"
					end

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
	while Kill do
		task.wait(0.1)
		if not isChasing and not isImmune then
			local currentPos = HRP.Position
			if IsPlayerInRoom(activeRoom) and not Character:GetAttribute("Crouching") and (currentPos - lastPos).Magnitude > 0.3 then
				StartChaseSequence()
			end
			lastPos = currentPos
		end
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
end
