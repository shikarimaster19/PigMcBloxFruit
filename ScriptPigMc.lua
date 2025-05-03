-- Tải Akiri UI
loadstring(game:HttpGet("https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/Akiri%20Lib/Akiri%20Lib%20Source.lua"))()

-- Tạo cửa sổ
local Window = Akiri:Create({
    Title = "KT Hub | Blox Fruits",
    Subtitle = "by shikarimaster19",
    TabSize = 120
})

-- Tab Auto Farm
local FarmTab = Window:Tab("🏴‍☠️ Auto Farm")

FarmTab:Toggle("Tự động Farm Level", false, function(Value)
    _G.AutoFarm = Value
    while _G.AutoFarm do
        task.wait(1)
        print("Đang auto farm...")
    end
end)

FarmTab:Button("Chạy Redz Hub", function()
    local Settings = {
        JoinTeam = "Pirates",
        Translator = true
    }
    task.spawn(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/BloxFruits/main/Source.lua"))(Settings)
        end)
        if not success then
            Akiri:Notify("Lỗi", "Không thể chạy Redz Hub", 5)
        end
    end)
end)

-- Tab Server
local ServerTab = Window:Tab("🌐 Server Tools")

ServerTab:Button("Server Hop (Tìm server vắng)", function()
    Akiri:Notify("KT Hub", "Đang tìm server phù hợp...", 3)

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
        Akiri:Notify("KT Hub", "Không tìm thấy server phù hợp!", 4)
    end
end)
