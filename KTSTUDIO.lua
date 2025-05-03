local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

-- Tạo giao diện chính
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "KT_UI"

-- KHỞI ĐỘNG FRAME
local startup = Instance.new("Frame", gui)
startup.Size = UDim2.new(0, 300, 0, 150)
startup.Position = UDim2.new(0.5, -150, 0.5, -75)
startup.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local title = Instance.new("TextLabel", startup)
title.Size = UDim2.new(1, 0, 0.4, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = ""
title.TextScaled = true
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1

local loading = Instance.new("TextLabel", startup)
loading.Size = UDim2.new(1, 0, 0.4, 0)
loading.Position = UDim2.new(0, 0, 0.5, 0)
loading.Text = "Đang khởi động... [0%]"
loading.TextScaled = true
loading.TextColor3 = Color3.new(0.7, 0.7, 0.7)
loading.Font = Enum.Font.Gotham
loading.BackgroundTransparency = 1

-- GIAO DIỆN CHÍNH
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 220, 0, 200)
menu.Position = UDim2.new(0, 90, 0.5, -100)
menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menu.Visible = false

local hubTitle = Instance.new("TextLabel", menu)
hubTitle.Size = UDim2.new(1, 0, 0, 30)
hubTitle.Position = UDim2.new(0, 0, 0, 0)
hubTitle.Text = "KT STUDIO"
hubTitle.TextScaled = true
hubTitle.TextColor3 = Color3.new(1, 1, 1)
hubTitle.Font = Enum.Font.GothamBold
hubTitle.BackgroundTransparency = 1

local btn1 = Instance.new("TextButton", menu)
btn1.Size = UDim2.new(1, -20, 0, 40)
btn1.Position = UDim2.new(0, 10, 0, 50)
btn1.Text = "Chạy Redz Hub"
btn1.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
btn1.TextColor3 = Color3.new(1, 1, 1)
btn1.Font = Enum.Font.Gotham

local btn2 = Instance.new("TextButton", menu)
btn2.Size = UDim2.new(1, -20, 0, 40)
btn2.Position = UDim2.new(0, 10, 0, 100)
btn2.Text = "Server Hop"
btn2.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
btn2.TextColor3 = Color3.new(1, 1, 1)
btn2.Font = Enum.Font.Gotham

-- NÚT KT
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.Text = "KT"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Visible = false
toggleBtn.BorderSizePixel = 0
toggleBtn.AutoButtonColor = false
toggleBtn.ZIndex = 2
toggleBtn.AnchorPoint = Vector2.new(0.5, 0.5)
toggleBtn.ClipsDescendants = false

local uicorner = Instance.new("UICorner", toggleBtn)
uicorner.CornerRadius = UDim.new(1, 0)

-- DRAG MƯỢT FULL THIẾT BỊ
local dragging = false
local dragStart, startPos

local function updateInput(input)
	local delta = input.Position - dragStart
	toggleBtn.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

toggleBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = toggleBtn.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateInput(input)
	end
end)

-- CLICK toggle
toggleBtn.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

-- REDZ
btn1.MouseButton1Click:Connect(function()
    -- Official Redz
    local Settings = {
        JoinTeam = "Pirates"; -- Pirates/Marines
        Translator = true; -- true/false
    }
    loadstring(game:HttpGet("https://raw.githubusercontent.com/newredz/BloxFruits/refs/heads/main/Source.luau"))(Settings)
end)

-- SERVER HOP
btn2.MouseButton1Click:Connect(function()
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local PlaceId = game.PlaceId
    local CurrentJobId = game.JobId
    local ApiUrl = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"

    function GetServers(cursor)
        local url = ApiUrl .. ((cursor and "&cursor="..cursor) or "")
        local response = game:HttpGet(url)
        return Http:JSONDecode(response)
    end

    local FoundServer = nil
    local Cursor = nil

    repeat
        local Servers = GetServers(Cursor)
        for _, server in ipairs(Servers.data) do
            local playerCount = server.playing or 0
            local serverId = server.id

            if serverId ~= CurrentJobId and playerCount <= 1 then
                FoundServer = server
                if playerCount == 0 then
                    break
                end
            end
        end
        Cursor = Servers.nextPageCursor
        task.wait(0.2)
    until FoundServer or not Cursor

    if FoundServer then
        TPS:TeleportToPlaceInstance(PlaceId, FoundServer.id, Players.LocalPlayer)
    else
        warn("Không tìm thấy server phù hợp (0-1 người, khác server hiện tại).")
    end
end)

-- HIỆU ỨNG KHỞI ĐỘNG
coroutine.wrap(function()
	startup.Visible = true
	local text = "KT STUDIO"
	for i = 1, #text do
		title.Text = string.sub(text, 1, i)
		wait(0.08)
	end
	for i = 0, 100, 5 do
		loading.Text = "Đang khởi động... ["..i.."%]"
		wait(0.05)
	end
	wait(0.3)
	startup:Destroy()
	toggleBtn.Visible = true
end)()
