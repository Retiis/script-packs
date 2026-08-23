task.wait(1)

local ScriptPacksCore = Instance.new("ScreenGui")
ScriptPacksCore.Name = "ScriptPacksCore"
ScriptPacksCore.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScriptPacksCore.ResetOnSpawn = false
ScriptPacksCore.Parent = game:GetService("CoreGui")

local textlabel = Instance.new("TextLabel")
textlabel.Size = UDim2.new(1, 0, 0, 36)
textlabel.BackgroundTransparency = 1
textlabel.TextStrokeTransparency = 0
textlabel.TextSize = 30
textlabel.Font = Enum.Font.SourceSans
textlabel.TextColor3 = Color3.new(1, 1, 1)
textlabel.Position = UDim2.new(0, 0, 0, -36)
textlabel.Parent = ScriptPacksCore
textlabel.Text = "loading.. (0/4)"

if _G.scriptPacks == nil then
    textlabel.Text = "_G.scriptPacks is missing!"
    return
end
if _G.scriptPacks.skipGameLoading == nil then
    textlabel.Text = "_G.scriptPacks.skipGameLoading is missing!"
    return
end
if _G.scriptPacks.delayBetweenExecutingScripts == nil then
    textlabel.Text = "_G.scriptPacks.delayBetweenExecutingScripts is missing!"
    return
end
if _G.scriptPacks.genreToLoad == nil then
    textlabel.Text = "_G.scriptPacks.genreToLoad is missing!"
    return
end

print("_G.scriptPacks are all good")

if _G.scriptPacksAlreadyExecutedInOneGame == 1 then
    textlabel.Text = "script-packs was already executed in this session!"
    print("scriptPacks already executed")
    return
end

textlabel.Text = "_G.scriptPacks initialised! (1/4)"
textlabel.Text = "_G.scriptPacks.settings initialised! (2/4)"

repeat task.wait() until _G.scriptPacks.skipGameLoading == true or game:IsLoaded()
textlabel.Text = "game loaded (3/4)"

local genres = {
	pvp = {"https://raw.githubusercontent.com/RetiiAyo/script-packs/main/genres/pvp.lua"},
	universal = {"https://raw.githubusercontent.com/RetiiAyo/script-packs/main/genres/universal.lua"},
	mmtwo = {"https://raw.githubusercontent.com/RetiiAyo/script-packs/main/genres/mm2.lua"},
	mm2 = {"https://raw.githubusercontent.com/RetiiAyo/script-packs/main/genres/mm2.lua"} -- alias
}

if not success or type(genres) ~= "table" then
    textlabel.Text = "Failed to load genres list!"
    warn("genre-json.lua error:", genres)
    return
end

if _G.scriptPacks.genreToLoad == "custom" and type(_G.scriptPacks.customScripts) == "table" then
    textlabel.Text = "custom genre selected, trying to load scripts"
    for i, v in pairs(_G.scriptPacks.customScripts) do
        local ok, err = pcall(function()
            loadstring(game:HttpGet(v))()
        end)
        if not ok then
            warn("Custom script failed:", v, err)
        end
        textlabel.Text = "custom script loaded! (" .. i .. "/" .. #_G.scriptPacks.customScripts .. ")"
        task.wait(_G.scriptPacks.delayBetweenExecutingScripts)
    end
else
    if not genres[_G.scriptPacks.genreToLoad] then
        textlabel.Text = "selected genre doesn't exist."
    else
        textlabel.Text = "genre exists, trying to load scripts"
        local scriptList = genres[_G.scriptPacks.genreToLoad]
        for i, v in pairs(scriptList) do
            local ok, err = pcall(function()
                loadstring(game:HttpGet(v))()
            end)
            if not ok then
                warn("Script failed:", v, err)
            end
            textlabel.Text = "script loaded! (" .. i .. "/" .. #scriptList .. ")"
            task.wait(_G.scriptPacks.delayBetweenExecutingScripts)
        end
        _G.scriptPacksAlreadyExecutedInOneGame = 1
    end
end

textlabel.Text = "everything was successfully executed! (4/4)"
task.wait(3)
ScriptPacksCore:Destroy()
