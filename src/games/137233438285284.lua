-- Chicken Farm Module (PlaceId: 137233438285284)
return function(elements)
    local env = getgenv()
    local plr = game:GetService("Players").LocalPlayer

    local remotes = game:GetService("ReplicatedStorage").Paper.Remotes
    local mainEvent = remotes.__remoteevent
    local mainFunction = remotes.__remotefunction
    local eggsFolder = workspace.Eggs
    
    local plot = workspace.Plots[plr.Name]
    local buyBtns = plot.Buttons.BuyChickens
    local cashText = plr.PlayerGui.Main.Currencies.Cash.List.Amount

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

    elements:Label("Eggs")
    env.AutoCollectEggs = false
    elements:Toggle("Auto Collect Eggs", false, function(state)
        env.AutoCollectEggs = state
        if not state then return end
        task.spawn(function()
            while env.AutoCollectEggs do
                for _, egg in ipairs(eggsFolder:GetChildren()) do
                    if not env.AutoCollectEggs then break end
                    mainEvent:FireServer("Collect Egg", egg.Name)
                    egg:Destroy()
                end
                pcall(function() mainFunction:InvokeServer("Deposit Eggs") end)
                task.wait(0.5)
            end
        end)
    end)

    elements:Label("Chickens")
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
                task.wait(0.2)
            end
        end)
    end)

    elements:Label("Income")
    env.AutoFarmCash = false
    elements:Toggle("Auto Collect Cash & Merge", false, function(state)
        env.AutoFarmCash = state
        if not state then return end
        task.spawn(function()
            while env.AutoFarmCash do
                pcall(function()
                    mainFunction:InvokeServer("Collect Cash")
                    mainFunction:InvokeServer("Upgrade Process Level")
                    mainFunction:InvokeServer("Merge Chickens")
                end)
                task.wait(0.5)
            end
        end)
    end)
end
