-- Walkspeed Hub
-- Delta Executor Compatible
-- No while true used
-- Added Auto Save/Load (Saves settings to Executor's workspace folder)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

local TARGET_SPEED = 30
local ENABLED = false
local LOOP_ENABLED = false
local loopConnection

local character
local humanoid

local SAVE_FILE_NAME = "WalkspeedHub_Save.json"

-- ===== Save & Load System =====
local function saveSettings()
	if writefile then
		local data = {
			speed = TARGET_SPEED,
			enabled = ENABLED,
			loopEnabled = LOOP_ENABLED
		}
		local success, json = pcall(function() return HttpService:JSONEncode(data) end)
		if success then
			pcall(function() writefile(SAVE_FILE_NAME, json) end)
		end
	end
end

local function loadSettings()
	if isfile and readfile and isfile(SAVE_FILE_NAME) then
		local success, json = pcall(function() return readfile(SAVE_FILE_NAME) end)
		if success and json then
			local successDecode, data = pcall(function() return HttpService:JSONDecode(json) end)
			if successDecode and type(data) == "table" then
				TARGET_SPEED = data.speed or 30
				ENABLED = data.enabled or false
				LOOP_ENABLED = data.loopEnabled or false
			end
		end
	end
end

-- ===== Character Setup =====
local function setupCharacter(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")

	if ENABLED and humanoid then
		humanoid.WalkSpeed = TARGET_SPEED
	end
end

if player.Character then
	setupCharacter(player.Character)
end

player.CharacterAdded:Connect(setupCharacter)

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WalkSpeedGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui -- better for executor

-- Helper function to add UICorner
local function addUICorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent
end

-- Open Button
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 120, 0, 40)
openBtn.Position = UDim2.new(0, 20, 0.5, -20)
openBtn.Text = "WalkSpeed"
openBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Active = true
openBtn.Draggable = true
openBtn.Parent = screenGui
addUICorner(openBtn, 8) 

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 270, 0, 220)
frame.Position = UDim2.new(0.5, -135, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Visible = false
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui
addUICorner(frame, 12) 

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "Walkspeed Hub"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = frame
addUICorner(closeBtn, 6) 

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.8, 0, 0, 35)
toggleBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
toggleBtn.Text = "WalkSpeed: OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Parent = frame
addUICorner(toggleBtn, 8) 

-- Loop Button
local loopBtn = Instance.new("TextButton")
loopBtn.Size = UDim2.new(0.8, 0, 0, 35)
loopBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
loopBtn.Text = "Loop WalkSpeed: OFF"
loopBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
loopBtn.TextColor3 = Color3.new(1,1,1)
loopBtn.Parent = frame
addUICorner(loopBtn, 8)

-- ================== Speed Controls Row ==================

-- -- (Minus 5) Button
local minusMinusBtn = Instance.new("TextButton")
minusMinusBtn.Size = UDim2.new(0, 35, 0, 30)
minusMinusBtn.Position = UDim2.new(0, 10, 0.7, 0)
minusMinusBtn.Text = "--"
minusMinusBtn.BackgroundColor3 = Color3.fromRGB(140,0,0) 
minusMinusBtn.TextColor3 = Color3.new(1,1,1)
minusMinusBtn.Parent = frame
addUICorner(minusMinusBtn, 6)

-- - (Minus 1) Button
local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 35, 0, 30)
minusBtn.Position = UDim2.new(0, 50, 0.7, 0)
minusBtn.Text = "-"
minusBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
minusBtn.TextColor3 = Color3.new(1,1,1)
minusBtn.Parent = frame
addUICorner(minusBtn, 6)

-- Speed Input
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 100, 0, 30)
speedBox.Position = UDim2.new(0.5, -50, 0.7, 0) 
speedBox.Text = tostring(TARGET_SPEED)
speedBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Parent = frame
addUICorner(speedBox, 6)

-- + (Plus 1) Button
local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 35, 0, 30)
plusBtn.Position = UDim2.new(1, -85, 0.7, 0)
plusBtn.Text = "+"
plusBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
plusBtn.TextColor3 = Color3.new(1,1,1)
plusBtn.Parent = frame
addUICorner(plusBtn, 6)

-- ++ (Plus 5) Button
local plusPlusBtn = Instance.new("TextButton")
plusPlusBtn.Size = UDim2.new(0, 35, 0, 30)
plusPlusBtn.Position = UDim2.new(1, -45, 0.7, 0)
plusPlusBtn.Text = "++"
plusPlusBtn.BackgroundColor3 = Color3.fromRGB(0,140,0)
plusPlusBtn.TextColor3 = Color3.new(1,1,1)
plusPlusBtn.Parent = frame
addUICorner(plusPlusBtn, 6)


-- ===== Load Previous Data & Update UI =====
loadSettings()

speedBox.Text = tostring(TARGET_SPEED)

if ENABLED then
	toggleBtn.Text = "WalkSpeed: ON"
	toggleBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
end

if LOOP_ENABLED then
	loopBtn.Text = "Loop WalkSpeed: ON"
	loopBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
	loopConnection = RunService.Heartbeat:Connect(function()
		if humanoid then
			humanoid.WalkSpeed = TARGET_SPEED
		end
	end)
end

-- ===== Functions =====
local function updateSpeed()
	speedBox.Text = tostring(TARGET_SPEED)
	if humanoid and ENABLED then
		humanoid.WalkSpeed = TARGET_SPEED
	end
	saveSettings() -- Auto-save when changed
end

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

toggleBtn.MouseButton1Click:Connect(function()
	ENABLED = not ENABLED
	
	if ENABLED then
		toggleBtn.Text = "WalkSpeed: ON"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
		updateSpeed()
	else
		toggleBtn.Text = "WalkSpeed: OFF"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
		if humanoid then
			humanoid.WalkSpeed = 16
		end
	end
	saveSettings() -- Auto-save when changed
end)

loopBtn.MouseButton1Click:Connect(function()
	LOOP_ENABLED = not LOOP_ENABLED
	
	if LOOP_ENABLED then
		loopBtn.Text = "Loop WalkSpeed: ON"
		loopBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
		
		loopConnection = RunService.Heartbeat:Connect(function()
			if humanoid then
				humanoid.WalkSpeed = TARGET_SPEED
			end
		end)
	else
		loopBtn.Text = "Loop WalkSpeed: OFF"
		loopBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
		
		if loopConnection then
			loopConnection:Disconnect()
			loopConnection = nil
		end
	end
	saveSettings() -- Auto-save when changed
end)

speedBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local num = tonumber(speedBox.Text)
		if num then
			TARGET_SPEED = math.clamp(num, 1, 200)
			updateSpeed()
		end
	end
end)

-- Number Adjuster Buttons
minusMinusBtn.MouseButton1Click:Connect(function()
	TARGET_SPEED = math.clamp(TARGET_SPEED - 5, 1, 200)
	updateSpeed()
end)

minusBtn.MouseButton1Click:Connect(function()
	TARGET_SPEED = math.clamp(TARGET_SPEED - 1, 1, 200)
	updateSpeed()
end)

plusBtn.MouseButton1Click:Connect(function()
	TARGET_SPEED = math.clamp(TARGET_SPEED + 1, 1, 200)
	updateSpeed()
end)

plusPlusBtn.MouseButton1Click:Connect(function()
	TARGET_SPEED = math.clamp(TARGET_SPEED + 5, 1, 200)
	updateSpeed()
end)
