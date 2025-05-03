-- Tải Rayfield UI
loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "KT Hub | Blox Fruits",
   LoadingTitle = "KT Hub Loading...",
   LoadingSubtitle = "Đang khởi động...",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "KTFarm", -- Lưu cấu hình
      FileName = "KTFarm_Config"
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

-- Tab Auto Farm
local MainTab = Window:CreateTab("🏴‍☠️ Auto Farm", 4483362458)

MainTab:CreateToggle({
   Name = "Tự động Farm Level",
   CurrentValue = false,
   Flag = "AutoFarm",
   Callback = function(Value)
      _G.AutoFarm = Value
      while _G.AutoFarm do
         task.wait(1)
         -- Gọi hàm farm ở đây
         print("Đang auto farm...")
      end
   end
})

MainTab:CreateButton({
   Name = "Chạy Redz Hub",
   Callback = function()
      local Settings = {
         JoinTeam = "Pirates",
         Translator = true
      }
      task.spawn(function()
         local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/BloxFruits/refs/heads/main/Source.lua"))(Settings)
         end)
         if not success then
            Rayfield:Notify({
               Title = "KT Hub",
               Content = "Không thể chạy Redz Hub!",
               Duration = 5
            })
         end
      end)
   end
})

-- Tab Server
local ServerTab = Window:CreateTab("🌐 Server Tools", 4483362444)

ServerTab:CreateButton({
   Name = "Server Hop (Tìm server vắng)",
   Callback = function()
      Rayfield:Notify({
         Title = "KT Hub",
         Content = "Đang tìm server phù hợp...",
         Duration = 3
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
         Rayfield:Notify({
            Title = "KT Hub",
            Content = "Không tìm thấy server phù hợp!",
            Duration = 4
         })
      end
   end
})