local passed = false

local allowedList = {
  2626396605,
  660549561
}

if table.find(allowedList, game.Players.LocalPlayer.UserId) then
    passed = true
else
    passed = false
end

repeat task.wait() until passed == true
