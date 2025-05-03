loadstring(game:HttpGet(("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua")))()

       local Window = MakeWindow({
         Hub = {
         Title = "PigMc",
         Animation = "Youtube: PigMc"
         },
        Key = {
        KeySystem = false,
        Title = "Key System",
        Description = "",
        KeyLink = "",
        Keys = {"1234"},
        Notifi = {
        Notifications = true,
        CorrectKey = "Running the Script...",
       Incorrectkey = "The key is incorrect",
       CopyKeyLink = "Copied to Clipboard"
      }
    }
  })

       MinimizeButton({
       Image = "http://www.roblox.com/asset/?id=83190276951914",
       Size = {60, 60},
       Color = Color3.fromRGB(10, 10, 10),
       Corner = true,
       Stroke = false,
       StrokeColor = Color3.fromRGB(255, 0, 0)
      })
      
------ Tab
     local Tab1o = MakeTab({Name = "Script Farm"})
     local Tab2o = MakeTab({Name = "Server Hop"})
     
------- BUTTON
    
    AddButton(Tab1o, {
     Name = "Redz Hub",
    Callback = function()
	  local Settings = {
  JoinTeam = "Pirates"; -- Pirates/Marines
  Translator = true; -- true/false
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/BloxFruits/refs/heads/main/Source.lua"))(Settings)

    AddButton(Tab2o, {
     Name = "Server Hop",
    Callback = function()
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
            -- Ưu tiên server 0 người
            if playerCount == 0 then
                break
            end
        end
    end
    Cursor = Servers.nextPageCursor
    task.wait(0.2) -- tránh spam request
until FoundServer or not Cursor

if FoundServer then
    TPS:TeleportToPlaceInstance(PlaceId, FoundServer.id, Players.LocalPlayer)
else
    warn("Không tìm thấy server phù hợp (0-1 người, khác server hiện tại).")
end
  end
  })