task.wait(1)

local ScriptPacksCore = Instance.new("ScreenGui")
ScriptPacksCore.Name = "ScriptPacksCore"
ScriptPacksCore.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScriptPacksCore.ResetOnSpawn = false

--syn.protect_gui(ScriptPacksCore)
ScriptPacksCore.Parent = game:GetService("CoreGui")

local textlabel = Instance.new("TextLabel")
textlabel.Size = UDim2.new(1, 0, 0, 36)
textlabel.Text = "Loading.."
textlabel.BackgroundTransparency = 1
textlabel.TextStrokeTransparency = 0
textlabel.TextSize = 30
textlabel.Font = Enum.Font.SourceSans
textlabel.TextColor3 = Color3.new(1, 1, 1)
textlabel.Position = UDim2.new(0, 0, 0, -36)
textlabel.Parent = ScriptPacksCore

textlabel.Text = "loading.. (0/4)"
if _G.scriptPacks == nil then textlabel.Text = "_G.scriptPacks is missing!" return end
if _G.scriptPacks.skipGameLoading == nil then textlabel.Text = "_G.scriptPacks.skipGameLoading is missing!" return end;
if _G.scriptPacks.delayBetweenExecutingScripts == nil then textlabel.Text = "_G.scriptPacks.delayBetweenExecutingScripts is missing!" return end;
if _G.scriptPacks.genreToLoad == nil then textlabel.Text = "_G.scriptPacks.genreToLoad is missing!" return end;
print("_G.scriptPacks are all good")

if _G.scriptPacksAlreadyExecutedInOneGame == 1 then textlabel.Text = "script-packs was already executed in this session!" print("scriptPacks already executed") return end 

textlabel.Text = "_G.scriptPacks initialised! (1/4)"
textlabel.Text = "_G.scriptPacks.settings initialised! (2/4)"
repeat task.wait() until _G.scriptPacks.skipGameLoading == true or game:IsLoaded();
textlabel.Text = "game loaded (3/4)"

local genres = loadstring(game:HttpGet("https://raw.githubusercontent.com/RetiiAyo/script-packs/main/genre-json.lua"))();

if _G.scriptPacks.genreToLoad == "custom" and _G.scriptPacks.customScripts ~= nil then
	textlabel.Text = "custom genre selected, trying to load scripts"
	for i, v in pairs(_G.scriptPacks.customScripts) do
		loadstring(game:HttpGet(v))();
		textlabel.Text = "custom script loaded! ("..i.."/"..#_G.scriptPacks.customScripts..")"
		task.wait(_G.scriptPacks.delayBetweenExecutingScripts);
	end;
else
	if not genres[_G.scriptPacks.genreToLoad] then
	textlabel.Text = "selected genre doesn't exist."
else
	textlabel.Text = "genre exists, trying to load scripts"
	for i, v in pairs(genres[_G.scriptPacks.genreToLoad]) do
		loadstring(game:HttpGet(v))();
		textlabel.Text = "script loaded! ("..i.."/"..#genres[_G.scriptPacks.genreToLoad]..")"
		task.wait(_G.scriptPacks.delayBetweenExecutingScripts);
	end;
	_G.scriptPacksAlreadyExecutedInOneGame = 1
    end;
end;
textlabel.Text = "everything was successfully executed! (4/4)"
task.wait(3)
ScriptPacksCore:Destroy()
