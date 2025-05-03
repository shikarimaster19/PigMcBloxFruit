local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "KT Hub | Blox Fruits", HidePremium = false, SaveConfig = true, ConfigFolder = "KTFarm", IntroEnabled = true, IntroText = "KT Hub Loading..."})

-- Auto Farm Tab
local FarmTab = Window:MakeTab({
    Name = "🏴‍☠️ Auto Farm",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

FarmTab:AddToggle({
    Name = "Tự động Farm Level",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        while _G.AutoFarm do
            task.wait(1)
            print("Đang auto farm...")
        end
    end
})

FarmTab:AddButton({
    Name = "Chạy Redz Hub",
    Callback = function()
        local Settings = {
            JoinTeam = "Pirates",
            Translator = true
        }
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/BloxFruits/refs/heads/main/Source.lua"))(Settings)
        end)
        if not success then
            OrionLib:MakeNotification({
                Name = "KT Hub",
                Content = "Không thể chạy Redz Hub!",
                Time = 5
            })
        end
    end
})

-- Server Tab
local ServerTab = Window:MakeTab({
    Name = "🌐 Server Tools",
    Icon = "rbxassetid://4483362444",
    PremiumOnly = false
})

ServerTab:AddButton({
    Name = "Server Hop (Tìm server vắng)",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "KT Hub",
            Content = "Đang tìm server phù hợp...",
            Time = 3
        })

        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local PlaceId = game.PlaceId
        local CurrentJobId = game.JobId
        local ApiUrl = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"

        local function GetServers(cursor)
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
                    if playerCount == 0 then break end
                end
            end
            Cursor = Servers.nextPageCursor
            task.wait(0.2)
        until FoundServer or not Cursor

        if FoundServer then
            TPS:TeleportToPlaceInstance(PlaceId, FoundServer.id, Players.LocalPlayer)
        else
            OrionLib:MakeNotification({
                Name = "KT Hub",
                Content = "Không tìm thấy server phù hợp!",
                Time = 4
            })
        end
    end
})

-- Toggle UI bằng RightShift
OrionLib:Init()
