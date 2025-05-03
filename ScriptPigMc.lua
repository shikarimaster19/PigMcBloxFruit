-- Tải thư viện Kavo UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("KT Hub | Blox Fruits", "Midnight")

-- Tab Auto Farm
local AutoFarmTab = Window:NewTab("Auto Farm")
local AutoFarmSection = AutoFarmTab:NewSection("Farm Level")

AutoFarmSection:NewToggle("Tự động Farm Level", "Tự farm quái theo level", function(state)
    _G.AutoFarm = state
    while _G.AutoFarm do
        task.wait(1)
        print("Đang auto farm...")
    end
end)

AutoFarmSection:NewButton("Chạy Redz Hub", "Chạy script Redz", function()
    local Settings = {
        JoinTeam = "Pirates",
        Translator = true
    }
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/BloxFruits/main/Source.lua"))(Settings)
    end)
    if not success then
        warn("Không thể chạy Redz Hub:", err)
    end
end)

-- Tab Server Tools
local ServerTab = Window:NewTab("Server Tools")
local ServerSection = ServerTab:NewSection("Server Hop")

ServerSection:NewButton("Tìm Server Vắng", "Tự động chuyển server vắng", function()
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
        warn("Không tìm thấy server phù hợp (0-1 người).")
    end
end)
