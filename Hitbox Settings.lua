-- Wait for the game to load
if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Variables
local HitboxEnabled = false
local TeamCheckEnabled = false
local HitboxSize = 15 -- Default Size

-- ==========================================
-- UI CREATION
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HitboxControlGUI"
ScreenGui.ResetOnSpawn = false

-- Try to parent to CoreGui (for executors), fallback to PlayerGui (for Studio)
local success = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ====================
-- TOGGLE MENU BUTTON
-- ====================
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 120, 0, 35)
ToggleButton.Position = UDim2.new(0.5, -60, 0, 15) -- Top Center of the screen
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Text = "Toggle UI"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

-- ====================
-- MAIN FRAME
-- ====================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 220)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = false -- Starts hidden by default (Optional, change to true if you want it open at launch)
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Hitbox Settings"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local HitboxToggle = Instance.new("TextButton")
HitboxToggle.Size = UDim2.new(0.9, 0, 0, 35)
HitboxToggle.Position = UDim2.new(0.05, 0, 0, 45)
HitboxToggle.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
HitboxToggle.Text = "Hitbox: OFF"
HitboxToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
HitboxToggle.Font = Enum.Font.GothamSemibold
HitboxToggle.TextSize = 14
HitboxToggle.Parent = MainFrame
Instance.new("UICorner", HitboxToggle).CornerRadius = UDim.new(0, 6)

local TeamCheckToggle = Instance.new("TextButton")
TeamCheckToggle.Size = UDim2.new(0.9, 0, 0, 35)
TeamCheckToggle.Position = UDim2.new(0.05, 0, 0, 90)
TeamCheckToggle.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
TeamCheckToggle.Text = "Team Check: OFF"
TeamCheckToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
TeamCheckToggle.Font = Enum.Font.GothamSemibold
TeamCheckToggle.TextSize = 14
TeamCheckToggle.Parent = MainFrame
Instance.new("UICorner", TeamCheckToggle).CornerRadius = UDim.new(0, 6)

local SizeInputLabel = Instance.new("TextLabel")
SizeInputLabel.Size = UDim2.new(0.35, 0, 0, 35)
SizeInputLabel.Position = UDim2.new(0.05, 0, 0, 135)
SizeInputLabel.BackgroundTransparency = 1
SizeInputLabel.Text = "Size:"
SizeInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SizeInputLabel.Font = Enum.Font.Gotham
SizeInputLabel.TextSize = 14
SizeInputLabel.TextXAlignment = Enum.TextXAlignment.Left
SizeInputLabel.Parent = MainFrame

local MinusButton = Instance.new("TextButton")
MinusButton.Size = UDim2.new(0.15, 0, 0, 35)
MinusButton.Position = UDim2.new(0.42, 0, 0, 135)
MinusButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinusButton.Text = "-"
MinusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusButton.Font = Enum.Font.GothamBold
MinusButton.TextSize = 16
MinusButton.Parent = MainFrame
Instance.new("UICorner", MinusButton).CornerRadius = UDim.new(0, 6)

local SizeInput = Instance.new("TextBox")
SizeInput.Size = UDim2.new(0.20, 0, 0, 35)
SizeInput.Position = UDim2.new(0.59, 0, 0, 135)
SizeInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SizeInput.Text = tostring(HitboxSize)
SizeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SizeInput.Font = Enum.Font.Gotham
SizeInput.TextSize = 14
SizeInput.Parent = MainFrame
Instance.new("UICorner", SizeInput).CornerRadius = UDim.new(0, 6)

local PlusButton = Instance.new("TextButton")
PlusButton.Size = UDim2.new(0.15, 0, 0, 35)
PlusButton.Position = UDim2.new(0.81, 0, 0, 135)
PlusButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlusButton.Text = "+"
PlusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusButton.Font = Enum.Font.GothamBold
PlusButton.TextSize = 16
PlusButton.Parent = MainFrame
Instance.new("UICorner", PlusButton).CornerRadius = UDim.new(0, 6)


-- ==========================================
-- UI INTERACTION & DRAGGING
-- ==========================================

-- Open/Close functionality
ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- Smooth Dragging Function for the GUI
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Make Toggle Button Draggable as well
local tDragging, tDragInput, tDragStart, tStartPos
ToggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		tDragging = true
		tDragStart = input.Position
		tStartPos = ToggleButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then tDragging = false end
		end)
	end
end)
ToggleButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then tDragInput = input end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == tDragInput and tDragging then
		local delta = input.Position - tDragStart
		ToggleButton.Position = UDim2.new(tStartPos.X.Scale, tStartPos.X.Offset + delta.X, tStartPos.Y.Scale, tStartPos.Y.Offset + delta.Y)
	end
end)

-- ==========================================
-- LOGIC & FUNCTIONS
-- ==========================================

local function ResetHitbox(player)
	pcall(function()
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			if hrp.Size.X ~= 2 then
				hrp.Size = Vector3.new(2, 2, 1)
				hrp.Transparency = 1
				hrp.BrickColor = BrickColor.new("Medium stone grey")
				hrp.Material = Enum.Material.Plastic
				hrp.CanCollide = false
			end
		end
	end)
end

local function ApplyHitbox(player)
	pcall(function()
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			if hrp.Size.X ~= HitboxSize then
				hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
				hrp.Transparency = 0.6 
				hrp.BrickColor = BrickColor.new("Bright blue")
				hrp.Material = Enum.Material.Neon
				hrp.CanCollide = false
			end
		end
	end)
end

-- Update buttons
HitboxToggle.MouseButton1Click:Connect(function()
	HitboxEnabled = not HitboxEnabled
	if HitboxEnabled then
		HitboxToggle.Text = "Hitbox: ON"
		HitboxToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	else
		HitboxToggle.Text = "Hitbox: OFF"
		HitboxToggle.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
		-- Instantly reset everyone when turned off
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				ResetHitbox(player)
			end
		end
	end
end)

TeamCheckToggle.MouseButton1Click:Connect(function()
	TeamCheckEnabled = not TeamCheckEnabled
	if TeamCheckEnabled then
		TeamCheckToggle.Text = "Team Check: ON"
		TeamCheckToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	else
		TeamCheckToggle.Text = "Team Check: OFF"
		TeamCheckToggle.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
	end
end)

-- Update size from typing manually
SizeInput.FocusLost:Connect(function()
	local newSize = tonumber(SizeInput.Text)
	if newSize and newSize > 0 then
		HitboxSize = newSize
	else
		SizeInput.Text = tostring(HitboxSize) -- Reset to valid previous size if invalid
	end
end)

-- Update size from the Plus/Minus Buttons
MinusButton.MouseButton1Click:Connect(function()
	HitboxSize = HitboxSize - 1
	if HitboxSize < 1 then HitboxSize = 1 end -- Prevents sizes of 0 or negative
	SizeInput.Text = tostring(HitboxSize)
end)

PlusButton.MouseButton1Click:Connect(function()
	HitboxSize = HitboxSize + 1
	SizeInput.Text = tostring(HitboxSize)
end)

-- ==========================================
-- NEW PLAYER & RESPAWN FIX
-- ==========================================
local function OnCharacterAdded(player, character)
	-- Wait slightly for the character's root part to load upon spawn
	local hrp = character:WaitForChild("HumanoidRootPart", 5)
	if hrp and HitboxEnabled then
		local isTeammate = false
		if TeamCheckEnabled and player.Team ~= nil and LocalPlayer.Team ~= nil then
			isTeammate = (player.Team == LocalPlayer.Team)
		end
		
		if not isTeammate then
			ApplyHitbox(player)
		end
	end
end

local function SetupPlayer(player)
	if player == LocalPlayer then return end
	
	-- Connect event for every time they respawn
	player.CharacterAdded:Connect(function(character)
		OnCharacterAdded(player, character)
	end)
	
	-- If they already have a character loaded in
	if player.Character then
		OnCharacterAdded(player, player.Character)
	end
end

-- Connect to players already in the game
for _, player in ipairs(Players:GetPlayers()) do
	SetupPlayer(player)
end

-- Connect to any new players that join the game
Players.PlayerAdded:Connect(SetupPlayer)


-- ==========================================
-- CONTINUOUS UPDATE (HEARTBEAT LOOP)
-- ==========================================
-- Kept as a fallback so if the game tries to revert the hitbox size, it forces it back
RunService.Heartbeat:Connect(function()
	if not HitboxEnabled then return end
	
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			
			-- Safe Team Validation 
			local isTeammate = false
			if TeamCheckEnabled and player.Team ~= nil and LocalPlayer.Team ~= nil then
				isTeammate = (player.Team == LocalPlayer.Team)
			end
			
			if isTeammate then
				ResetHitbox(player)
			else
				ApplyHitbox(player)
			end
		end
	end
end)
