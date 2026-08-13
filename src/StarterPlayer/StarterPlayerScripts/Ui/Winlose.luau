local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local module = {}
local WinLoseFrame = Players.LocalPlayer.PlayerGui:WaitForChild("LobbyGui").WinLoseFrame
local WinLoseScreen = ReplicatedStorage:WaitForChild("Ui"):WaitForChild("WinLoseScreen")
function DestroyOldFrame()
	local OldFrame = WinLoseFrame:FindFirstChild("WinLoseScreen")
	if OldFrame then
		OldFrame:Destroy()
	end
end
function module.activate()
	ReplicatedStorage.Event.Win.OnClientEvent:Connect(function(Team)
		print(Team)
		DestroyOldFrame()
		local Clone = WinLoseScreen:Clone()
		Clone.Parent = WinLoseFrame
		if Team == Teams.Nextbots then
			Clone.Title.Text = "Nextbots Won"
			Clone.TextContainer.SurvivingReward.Visible = false
			Clone.TextContainer.WinningReward.Text = "Gained Tokens for win: " .. tostring(500)
			print("yo")
		elseif Team == Teams.Survivor then
			print("Ich exestiere")
			Clone.Title.Text = "Survivor  Won"
			Clone.TextContainer.WinningReward.Text = "Gained Tokens for win: " .. tostring(200)
			Clone.TextContainer.SurvivingReward.Visible = false
		end
	end)
	ReplicatedStorage.Event.Lose.OnClientEvent:Connect(function(Team, TokensEaned: number)
		DestroyOldFrame()
		local Clone = WinLoseScreen:Clone()
		Clone.Parent = WinLoseFrame
		if Team == Teams.Survivor then
			Clone.TextContainer.WinningReward.Visible = false
			Clone.Title.Text = "You Died"
			Clone.TextContainer.SurvivingReward.Text = "Gained Tokens for surived time: " .. tostring(TokensEaned)
		else
			print("Future I will give Coins For Kills")
		end
	end)
end

return module
