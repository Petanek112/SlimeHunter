extends Control

onready var text = $Label
onready var tween = $Tween
onready var playerStats = PlayerStats

export var tutorialFinished = false
export var greenSlimesKilled = 0

export var Start = false
export var Meadow = false
export var Lake = false
export var DeepForest = false
export var Rocky = false

onready var area = START

enum{
	START,
	MEADOW,
	LAKE,
	DEEPFOREST,
	ROCKY
}

var textArrayStart = []
var textArrayMeadow = []
var textArrayLake = []
var textArrayDeepForest = []
var textArrayRocky = []

var textProgressStart = 0
var textProgressMeadow = 0
var textProgressLake = 0
var textProgressDeepForest = 0
var textProgressRocky = 0

var questActiveStart = 0
var questActiveMeadow = 0
var questActiveLake = 0
var questActiveDeepForest = 0
var questActiveRocky = 0

var questBoolArrayStart = []
var questBoolArrayMeadow = []
var questBoolArrayLake = []
var questBoolArrayDeepForest = []
var questBoolArrayRocky = []

var firstGreenSlimesKilled = false
var firstFlowersType1Picked = false
var firstFlowersType2Picked = false
var firstFlowersType7Picked = false
var firstBlueSlimesKilled = false
var firstRedSlimesKilled = false

var tweenWasActivated = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if playerStats.questLocationAfterExit != 0:
		area != START
#	if Start == true:
#		show()
	continue_questing_text()
	for x in range(50):
		questBoolArrayStart.append(false)
		questBoolArrayMeadow.append(false)
		questBoolArrayLake.append(false)
		questBoolArrayDeepForest.append(false)
		questBoolArrayRocky.append(false)
	questBoolArrayStart[0] = true
	questBoolArrayMeadow[0] = true
	questBoolArrayLake[0] = true
	questBoolArrayDeepForest[0] = true
	questBoolArrayRocky[0] = true
	print("LoadedArea:")
	print(playerStats.questLocationAfterExit)
	loadingData()
	matching_area_and_load()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print(playerStats.SolarActivated)
	continue_questing_text()
	setting_textArray()
	area_changed()
	match area: 
		START:
			startArea_Quests()
			playerStats.questLocationAfterExit = 0
#			print("Start is true")
		MEADOW:
			meadowArea_Quests()
			playerStats.questLocationAfterExit = 1
#			print("Meadow is true")
		LAKE:
			lakeArea_Quests()
			playerStats.questLocationAfterExit = 2
		DEEPFOREST:
			deepForestArea_Quests()
			playerStats.questLocationAfterExit = 3
		ROCKY:
			rockyArea_Quests()
			playerStats.questLocationAfterExit = 4
			
	if Input.is_action_just_pressed("ui_focus_next"):
		quest_progression()

func setting_textArray():
	textArrayStart = [
	"Finish Tutorial",
	"Kill 6 Green Slimes " + str(playerStats.greenSlimesKilled) + " / 6",
	"Pick 10 Violet Flowers with E/ F " + str(playerStats.flowerType1) + " / 10",
	"Kill 6 Blue Slimes " + str(playerStats.blueSlimesKilled) + " / 6",
	"Pick 8 Yellow Flowers " + str(playerStats.flowerType2) + " / 8",
	"Kill 1 Forest Slime (Down from the House) " + str(playerStats.forestSlimesKilled) + " / 1",
	"Starter Area Completed, find Another Area",
	]
	textArrayMeadow = [
	"Kill 8 Green Slimes " + str(playerStats.greenSlimesKilled) + " / 8",
	"Pick 10 Blue Flowers  " + str(playerStats.flowerType3) + " / 10",
	"Pick 16 Mullein " + str(playerStats.flowerType5) + " / 16",
	"Kill 10 Green Slimes " + str(playerStats.greenSlimesKilled) + " / 10",
	"Kill 5 Red Slimes " + str(playerStats.redSlimesKilled) + " / 5",
	"Activate the Obelisk with E/ F",
	"Kill the Slime Twins",
	"Meadow Area Completed, find Another Area",
	]
	textArrayLake = [
	"Kill 8 Blue Slimes " + str(playerStats.blueSlimesKilled) + " / 8",
	"Pick 8 Blue Flowers " + str(playerStats.flowerType3) + " / 8",
	"Kill 2 Chaos Slimes " + str(playerStats.chaosSlimesKilled) + " / 2",
	"Kill 4 Red Slimes " + str(playerStats.redSlimesKilled) + " / 4",
	"Find and use Fire to Destroy the Tree blocking the Island (Right side of Map)",
	"Kill the Water Spirit",
	"Lake Area Completed, find Another Area",
	]
	textArrayDeepForest = [
	"Pick 6 Brown Mushrooms " + str(playerStats.flowerType6) + " / 6",
	"Kill 8 Blue Slimes " + str(playerStats.blueSlimesKilled) + " / 8",
	"Kill 4 Chaos Slimes " + str(playerStats.chaosSlimesKilled) + " / 4",
	"Pick 5 Red Mushrooms " + str(playerStats.flowerType7) + " / 5",
	"Kill 2 Forest Slimes " + str(playerStats.forestSlimesKilled) + " / 2",
	"Find the Blessed Tree and Activate it with E/F (Middle of Forest)",
	"Kill the Forest Spirit",
	"DeepForest Area Completed, find Another Area",
	]
	textArrayRocky = [
	"Kill 2 Molten Slimes " + str(playerStats.moltenSlimesKilled) + " / 2",
	"Pick 4 Fire Flowers " + str(playerStats.flowerType8) + " / 4",
	"Kill 4 Molten Slimes " + str(playerStats.moltenSlimesKilled) + " / 4",
	"Pick 6 Fire Flowers " + str(playerStats.flowerType8) + " / 6",
	"Find the Ritual Circle and Activate it with E/F (Middle of Lava Area)",
	"Kill the Fire Spirit",
	"Lava Area Completed, find Another Area",
	]
		
func startArea_Quests():
	if Start == true:
		show()
		if playerStats.TutorialFinished == true and questBoolArrayStart[0] == true:
			quest_progression()
		if playerStats.greenSlimesKilled >= 6 and questBoolArrayStart[1] == true:
			quest_progression()
			playerStats.greenSlimesKilled = 0
		if playerStats.flowerType1 >= 10 and questBoolArrayStart[2] == true:
			quest_progression()
		if playerStats.blueSlimesKilled >= 6 and questBoolArrayStart[3] == true:
			quest_progression()
			playerStats.blueSlimesKilled = 0
		if playerStats.flowerType2 >= 8 and questBoolArrayStart[4] == true:
			quest_progression()
		if playerStats.forestSlimesKilled >= 1 and questBoolArrayStart[5] == true:
			quest_progression()
			playerStats.forestSlimesKilled = 0
	
func meadowArea_Quests():
	if Meadow == true:
		show()
		if playerStats.greenSlimesKilled >= 8 and questBoolArrayMeadow[0] == true:
			quest_progression()
			playerStats.greenSlimesKilled = 0
		if playerStats.flowerType3 >= 10 and questBoolArrayMeadow[1] == true:
			quest_progression()
			playerStats.flowerType3 = 0
		if playerStats.flowerType5 >= 16 and questBoolArrayMeadow[2] == true:
			quest_progression()
		if playerStats.greenSlimesKilled >= 10 and questBoolArrayMeadow[3] == true:
			quest_progression()
			playerStats.greenSlimesKilled = 0
		if playerStats.redSlimesKilled >= 5 and questBoolArrayMeadow[4] == true:
			quest_progression()
			playerStats.redSlimesKilled = 0
			playerStats.ObeliskCanBeActivated = true
		if playerStats.ObeliskActivated == true and questBoolArrayMeadow[5] == true:
			quest_progression()
			print("Spawn the twins")
			playerStats.ThunderActivated = true
		if playerStats.SlimeTwinsKillCount == 2 and questBoolArrayMeadow[6] == true:
			quest_progression()
			print("Slime Twins Slayed")
			print("FireBow Unlocked")
			playerStats.FireBowUnlocked = true
		
func lakeArea_Quests():
	if Lake == true:
		show()
		if playerStats.blueSlimesKilled >= 8 and questBoolArrayLake[0] == true:
			quest_progression()
			playerStats.blueSlimesKilled = 0
		if playerStats.flowerType3 >= 8 and questBoolArrayLake[1] == true:
			quest_progression()
		if playerStats.chaosSlimesKilled >= 2 and questBoolArrayLake[2] == true:
			quest_progression()
			playerStats.chaosSlimesKilled = 0
		if playerStats.redSlimesKilled >= 4 and questBoolArrayLake[3] == true:
			quest_progression()
			playerStats.redSlimesKilled = 0
		if playerStats.TreeDestroyed == true and questBoolArrayLake[4] == true:
			quest_progression()
			print("Spawn Water Spirit")
			playerStats.ThunderActivated = false
		if playerStats.WaterSpiritKilled == true and questBoolArrayLake[5] == true:
			quest_progression()
			print("Water Spirit Killed")
		
func deepForestArea_Quests():
	if DeepForest == true:
		show()
		if playerStats.flowerType6 >= 6 and questBoolArrayDeepForest[0] == true:
			quest_progression()
			playerStats.flowerType6 = 0
		if playerStats.blueSlimesKilled >= 8 and questBoolArrayDeepForest[1] == true:
			quest_progression()
			playerStats.blueSlimesKilled = 0
		if playerStats.chaosSlimesKilled >= 4 and questBoolArrayDeepForest[2] == true:
			quest_progression()
			playerStats.chaosSlimesKilled = 0
		if playerStats.flowerType7 >= 5 and questBoolArrayDeepForest[3] == true:
			quest_progression()
			playerStats.flowerType7 = 0
		if playerStats.forestSlimesKilled >= 2 and questBoolArrayDeepForest[4] == true:
			quest_progression()
			playerStats.forestSlimesKilled = 0
			playerStats.BlessedTreeCanBeActivated = true
		if playerStats.BlessedTreeActivated == true and questBoolArrayDeepForest[5] == true:
			quest_progression()
		if playerStats.ForestSpiritKilled == true and questBoolArrayDeepForest[6] == true:
			quest_progression()
			print("Forest Spirit Killed")
		
func rockyArea_Quests():
	if Rocky == true:
		show()
		if playerStats.moltenSlimesKilled >= 2 and questBoolArrayRocky[0] == true:
			quest_progression()
			playerStats.moltenSlimesKilled = 0
		if playerStats.flowerType8 >= 4 and questBoolArrayRocky[1] == true:
			quest_progression()
			playerStats.flowerType8 = 0
		if playerStats.moltenSlimesKilled >= 4 and questBoolArrayRocky[2] == true:
			quest_progression()
			playerStats.moltenSlimesKilled = 0
		if playerStats.flowerType8 >= 6 and questBoolArrayRocky[3] == true:
			quest_progression()
			playerStats.flowerType8 = 0
			playerStats.RitualCanBeActivated = true
		if playerStats.RitualActivated == true and questBoolArrayRocky[4] == true:
			quest_progression()
		if playerStats.FireSpiritKilled == true and questBoolArrayRocky[5] == true:
			quest_progression()
			print("Fire Spirit Killed")
		
func continue_questing_text():
	if Start == true:
		if textProgressStart < textArrayStart.size():
			text.text = textArrayStart[textProgressStart]
			tween_check()
	if Meadow == true:
		if textProgressMeadow < textArrayMeadow.size():
			text.text = textArrayMeadow[textProgressMeadow]
			tween_check()
	if Lake == true:
		if textProgressLake < textArrayLake.size():
			text.text = textArrayLake[textProgressLake]
			tween_check()
	if DeepForest == true:
		if textProgressDeepForest < textArrayDeepForest.size():
			text.text = textArrayDeepForest[textProgressDeepForest]
			tween_check()
	if Rocky == true:
		if textProgressRocky < textArrayRocky.size():
			text.text = textArrayRocky[textProgressRocky]
			tween_check()

func quest_progression():
	tweenWasActivated = false
	get_tree().get_root().get_node("World/YSort/Player").quest_completed()
	
	if Start == true:
		textProgressStart += 1
		questActiveStart += 1
		questBoolArrayStart[questActiveStart] = true
		questBoolArrayStart[questActiveStart - 1] = false
		playerStats.questActiveStart = questActiveStart
		
	if Lake == true:
		textProgressLake += 1
		questActiveLake += 1
		questBoolArrayLake[questActiveLake] = true
		questBoolArrayLake[questActiveLake - 1] = false
		playerStats.questActiveLake = questActiveLake

	if Meadow == true:
		textProgressMeadow += 1
		questActiveMeadow += 1
		questBoolArrayMeadow[questActiveMeadow] = true
		questBoolArrayMeadow[questActiveMeadow - 1] = false
		playerStats.questActiveMeadow = questActiveMeadow

	if DeepForest == true:
		textProgressDeepForest += 1
		questActiveDeepForest += 1
		questBoolArrayDeepForest[questActiveDeepForest] = true
		questBoolArrayDeepForest[questActiveDeepForest - 1] = false
		playerStats.questActiveDeepForest = questActiveDeepForest

	if Rocky == true:
		textProgressRocky += 1
		questActiveRocky += 1
		questBoolArrayRocky[questActiveRocky] = true
		questBoolArrayRocky[questActiveRocky - 1] = false
		playerStats.questActiveRocky = questActiveRocky

	

func tween_check():
	if tweenWasActivated == false:
		text.percent_visible = 0
		tween.interpolate_property(text,"percent_visible", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		tweenWasActivated = true
		
func area_changed():
	if playerStats.StartLocated == true:
		area = START
		playerStats.DarkActivated = false
		playerStats.SolarActivated = false
		if Meadow == true:
			hide()
		if Lake == true:
			hide()
		if DeepForest == true:
			hide()
		if Rocky == true:
			hide()
	if playerStats.MeadowLocated == true:
		area = MEADOW
		playerStats.DarkActivated = false
		playerStats.SolarActivated = false
		if Start == true:
			hide()
		if Lake == true:
			hide()
		if DeepForest == true:
			hide()
		if Rocky == true:
			hide()
	if playerStats.LakeLocated == true:
		area = LAKE
		playerStats.DarkActivated = false
		playerStats.SolarActivated = false
		if Start == true:
			hide()
		if Meadow == true:
			hide()
		if DeepForest == true:
			hide()
		if Rocky == true:
			hide()
	if playerStats.DeepForestLocated == true:
		area = DEEPFOREST
		playerStats.DarkActivated = true
		playerStats.SolarActivated = false
		if Start == true:
			hide()
		if Meadow == true:
			hide()
		if Lake == true:
			hide()
		if Rocky == true:
			hide()
	if playerStats.RockyLocated == true:
		area = ROCKY
		playerStats.DarkActivated = false
		playerStats.SolarActivated = true
		if Start == true:
			hide()
		if Meadow == true:
			hide()
		if Lake == true:
			hide()
		if DeepForest == true:
			hide()


func loading_quests():
	textProgressStart += playerStats.questActiveStart
	questActiveStart += playerStats.questActiveStart
	textProgressMeadow += playerStats.questActiveMeadow
	questActiveMeadow += playerStats.questActiveMeadow
	textProgressLake += playerStats.questActiveLake
	questActiveLake += playerStats.questActiveLake
	textProgressDeepForest += playerStats.questActiveDeepForest
	questActiveDeepForest += playerStats.questActiveDeepForest
	textProgressRocky += playerStats.questActiveRocky
	questActiveRocky += playerStats.questActiveRocky

func matching_area_and_load():
	if playerStats.questLocationAfterExit == 0:
		area = START
		print("StartAreaLoaded")
	if playerStats.questLocationAfterExit == 1:
		area = MEADOW
		print("MeadowAreaLoaded")
	if playerStats.questLocationAfterExit == 2:
		area = LAKE
		print("LakeAreaLoaded")
	if playerStats.questLocationAfterExit == 3:
		area = DEEPFOREST
	if playerStats.questLocationAfterExit == 4:
		area = ROCKY

func loadingData():
	for n in playerStats.questActiveStart:
		textProgressStart += 1
		questActiveStart += 1
		questBoolArrayStart[questActiveStart] = true
		questBoolArrayStart[questActiveStart - 1] = false
		print("StartQuestUpdated")
	for n in playerStats.questActiveMeadow:
		textProgressMeadow += 1
		questActiveMeadow += 1
		questBoolArrayMeadow[questActiveMeadow] = true
		questBoolArrayMeadow[questActiveMeadow - 1] = false
		print("MeadowQuestUpdated")
	for n in playerStats.questActiveLake:
		textProgressLake += 1
		questActiveLake += 1
		questBoolArrayLake[questActiveLake] = true
		questBoolArrayLake[questActiveLake - 1] = false
		print("LakeQuestUpdated")
	for n in playerStats.questActiveDeepForest:
		textProgressDeepForest += 1
		questActiveDeepForest += 1
		questBoolArrayDeepForest[questActiveDeepForest] = true
		questBoolArrayDeepForest[questActiveDeepForest - 1] = false
	for n in playerStats.questActiveRocky:
		textProgressRocky += 1
		questActiveRocky += 1
		questBoolArrayRocky[questActiveRocky] = true
		questBoolArrayRocky[questActiveRocky - 1] = false
