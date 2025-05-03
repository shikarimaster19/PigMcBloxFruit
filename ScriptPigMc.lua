local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kavo-UI/Library/main/source.lua"))()
local Window = Library.CreateLib("KT Hub | Blox Fruits", "Midnight")

-- Auto Farm Tab
local AutoFarmTab = Window:NewTab("Auto Farm")
local AutoFarmSection = AutoFarmTab:NewSection("Farm Level")

AutoFarmSection:NewToggle("Tự động Farm Level", "Tự farm theo level", function(state)
    _G.AutoFarm = state
    if state then
        print("AutoFarm bật")
        while _G.AutoFarm do
            task.wait(1)
            print("Đang auto farm...")
        end
    else
        print("AutoFarm tắt")
    end
end)

AutoFarmSection:NewButton("Chạy Redz Hub", "Gọi script Redz", function()
    print("Đang chạy Redz Hub...")
    local Settings = {
        JoinTeam = "Pirates",
        Translator = true
    }
    task.spawn(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/BloxFruits/main/Source.lua"))(Settings)
        end)
        if not success then
            warn("Không thể chạy Redz Hub!", err)
        end
    end)
end)

-- Server Tab
local ServerTab = Window:NewTab("Server Tools")
local ServerSection = ServerTab:NewSection("Server Tools")

ServerSection:NewButton("Server Hop", "Tìm server vắng", function()
    print("Đang tìm server vắng...")
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
        warn("Không tìm thấy server phù hợp!")
    end
end)
