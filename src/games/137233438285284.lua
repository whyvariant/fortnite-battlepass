return function(elements)
    local env = getgenv()
    local plr = game:GetService("Players").LocalPlayer

    local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Paper"):WaitForChild("Remotes")
    local mainEvent = remotes:WaitForChild("__remoteevent")
    local mainFunction = remotes:WaitForChild("__remotefunction")
    local eggsFolder = workspace:WaitForChild("Eggs")
    
    local plot = workspace:WaitForChild("Plots"):WaitForChild(plr.Name)
    local buyBtns = plot:WaitForChild("Buttons"):WaitForChild("BuyChickens")
    local cashText = plr.PlayerGui:WaitForChild("Main"):WaitForChild("Currencies"):WaitForChild("Cash"):WaitForChild("List"):WaitForChild("Amount")

    local suffixes = {
        "K","M","B","T","Qd","Qn","Sx","Sp","Oc","No","De",
        "UDe","DDe","TDe","QdDe","QnDe","SxDe","SpDe","OcDe","NoDe","Vt",
        "UVt","DVt","TVt","QdVt","QnVt","SxVt","SpVt","OcVt","NoVt","Tg",
        "UTg","DTg","TTg","QdTg","QnTg","SxTg","SpTg","OcTg","NoTg","qg",
        "Uqg","Dqg","Tqg","Qdqg","Qnqg","Sxqg","Spqg","Ocqg","Noqg","Qg",
        "UQg","DQg","TQg","QdQg","QnQg","SxQg","SpQg","OcQg","NoQg","sg",
        "Usg","Dsg","Tsg","Qdsg","Qnsg","Sxsg","Spsg","Ocsg","Nosg","Sg",
        "USg","DSg","TSg","QdSg","QnSg","SxSg","SpSg","OcSg","NoSg","Og",
        "UOg","DOg","TOg","QdOg","QnOg","SxOg","SpOg","OcOg","NoOg","Ng",
        "UNg","DNg","TNg","QdNg","QnNg","SxNg","SpNg","OcNg","NoNg","Ce","UCe"
    }
    local suffixValue = {}
    for i, suf in ipairs(suffixes) do suffixValue[suf] = 1000 ^ i end

    local function parseSuffixedNumber(str)
        str = str:gsub("[%$,%s]", "")
        local numberPart, suffixPart = str:match("^(-?%d*%.?%d+)(%a*)$")
        local base = tonumber(numberPart)
        if suffixPart == "" then return base end
        local multiplier = suffixValue[suffixPart]
        return base * (multiplier or 1)
    end

    -- 1. Egg Auto-Collect (Triggers only when an egg spawns)
    env.AutoCollectEggs = false
    local eggConnection

    elements:Toggle("Auto Collect Eggs", false, function(state)
        env.AutoCollectEggs = state
        
        if state then
            -- Instantly collect existing
            for _, egg in ipairs(eggsFolder:GetChildren()) do
                mainEvent:FireServer("Collect Egg", egg.Name)
                egg:Destroy()
            end
            
            -- Listen for new ones and collect instantly
            eggConnection = eggsFolder.ChildAdded:Connect(function(egg)
                if not env.AutoCollectEggs then return end
                task.wait(0.05)
                mainEvent:FireServer("Collect Egg", egg.Name)
                egg:Destroy()
                mainFunction:InvokeServer("Deposit Eggs")
            end)
            
            -- Infinite loop to deposit eggs constantly
            task.spawn(function()
                while env.AutoCollectEggs do
                    pcall(function() mainFunction:InvokeServer("Deposit Eggs") end)
                    task.wait()
                end
            end)
        else
            if eggConnection then eggConnection:Disconnect() end
        end
    end)

    -- 2. Chicken Auto-Buy
    env.AutoBuyChickens = false
    elements:Toggle("Auto Buy Chickens", false, function(state)
        env.AutoBuyChickens = state
        if not state then return end
        task.spawn(function()
            while env.AutoBuyChickens do
                local tobuy = 0
                local result = parseSuffixedNumber(cashText.Text)
                
                if parseSuffixedNumber(buyBtns.Buy100.Button.UI.Cost.Text) <= result then
                    tobuy = 100
                elseif parseSuffixedNumber(buyBtns.Buy25.Button.UI.Cost.Text) <= result then
                    tobuy = 25
                elseif parseSuffixedNumber(buyBtns.Buy5.Button.UI.Cost.Text) <= result then
                    tobuy = 5
                elseif parseSuffixedNumber(buyBtns.Buy1.Button.UI.Cost.Text) <= result then
                    tobuy = 1
                end
                
                if tobuy > 0 then
                    pcall(function() mainFunction:InvokeServer("Buy Chickens", tobuy) end)
                end
                task.wait()
            end
        end)
    end)

    -- 3. Auto Cash & Merge (Synced up for max speed)
    env.AutoFarmCash = false
    elements:Toggle("Auto Cash & Merge", false, function(state)
        env.AutoFarmCash = state
        if not state then return end
        task.spawn(function()
            while env.AutoFarmCash do
                pcall(function() 
                    mainFunction:InvokeServer("Collect Cash") 
                    mainFunction:InvokeServer("Upgrade Process Level")
                    mainFunction:InvokeServer("Merge Chickens")
                end)
                task.wait()
            end
        end)
    end)
end
