extends Node2D

var gameIsPaused = false
onready var creditsButton = $YSort/Buttons/CreditsButton
onready var startButton = $YSort/Buttons/StartButton
onready var continueButton = $YSort/Buttons/ContinueButton
onready var optionsButton = $YSort/Buttons/OptionsButton
onready var exitButton = $YSort/Buttons/ExitButton
onready var backButton = $YSort/Buttons/BackButton
onready var saveButton = $YSort/Buttons/SaveButton
onready var loadButton = $YSort/Buttons/LoadButton
onready var credits = $YSort/Text/Credits
onready var options = $YSort/Options


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().paused == false and get_tree().get_current_scene().get_filename() != "res://Scenes/Menu.tscn":
		self.hide()
		
	if get_tree().get_current_scene().get_filename() == "res://Scenes/Menu.tscn":
		position += Vector2(0, 50) * delta
		if position.y >= 2000:
			position.y = 0;
	
	if Input.is_action_just_pressed("ui_end") and gameIsPaused == false:
		yield(get_tree().create_timer(0.1), "timeout")
		self.show()
		print("game is paused")
		get_tree().paused = true
		startButton.hide()
		continueButton.show()
		gameIsPaused = true

		
	if Input.is_action_just_pressed("ui_end") or continueButton.pressed == true and gameIsPaused == true:
		yield(get_tree().create_timer(0.1), "timeout")
		self.hide()
		print("game is unpaused")
		get_tree().paused = false
		gameIsPaused = false
		startButton.show()

		
	if creditsButton.pressed == true:
		startButton.hide()
		continueButton.hide()
		optionsButton.hide()
		creditsButton.hide()
		exitButton.hide()
		backButton.show()
		credits.show()
		
	if backButton.pressed == true and gameIsPaused == false:
		startButton.show()
		continueButton.show()
		optionsButton.show()
		creditsButton.show()
		exitButton.show()
		backButton.hide()
		credits.hide()
		options.hide()
		
	if backButton.pressed == true and gameIsPaused == true:
		startButton.hide()
		continueButton.show()
		optionsButton.show()
		creditsButton.show()
		exitButton.show()
		backButton.hide()
		credits.hide()
		options.hide()
		
	if optionsButton.pressed == true:
		continueButton.hide()
		startButton.hide()
		optionsButton.hide()
		creditsButton.hide()
		exitButton.hide()
		backButton.show()
		options.show()


func _on_MasterVolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_MusicVolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)

func _on_SFXVolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
	
func _on_FullscreenButton_toggled(button_pressed):
	if button_pressed == true:
		OS.window_fullscreen = true
	if button_pressed != true:
		OS.window_fullscreen = false

func _on_ExitButton_pressed():
	print("Exit Pressed")
	if get_tree().get_current_scene().get_filename() == "res://Scenes/BigLevel.tscn":
		var playerPosX = get_tree().get_root().get_node("World/YSort/Player").global_position.x
		var playerPosY = get_tree().get_root().get_node("World/YSort/Player").global_position.y
		_on_SaveButton_pressed(playerPosX, playerPosY)
	get_tree().quit()
	
func _on_StartButton_pressed():
	print("StartPressed")
	if get_tree().get_current_scene().get_filename() == "res://Scenes/Menu.tscn":
		get_tree().change_scene("res://Scenes/BigLevel.tscn")
	if get_tree().get_current_scene().get_filename() != "res://Scenes/Menu.tscn":
		get_tree().paused = false
		get_tree().change_scene("res://Scenes/Menu.tscn")
		
#		yield(get_tree().create_timer(0.1), "timeout")
#		_on_StartButton_pressed()
		
const SAVE_DIR = "user://saves/"
var save_path = SAVE_DIR + "save.dat"
var playerStats = PlayerStats

func _on_SaveButton_pressed(playerPosX, playerPosY):
	var data = {
	"Health" : playerStats.health,
	"MaxHealth" : playerStats.max_health,
	"Ammo" : playerStats.ammo,
	"MaxAmmo" : playerStats.max_ammo,
	"FireBowUnlocked" : playerStats.FireBowUnlocked,
	"TechBowUnlocked" : playerStats.TechBowUnlocked,
	"IceBowUnlocked" : playerStats.IceBowUnlocked,
	"SlimeMat" : playerStats.slimeMat,
	"Thunder" : playerStats.ThunderActivated,
	"Dark" : playerStats.DarkActivated,
	"Solar" : playerStats.SolarActivated,
	"Forest" : playerStats.ForestActivated,
	"questActiveStart" : playerStats.questActiveStart,
	"questActiveMeadow" : playerStats.questActiveMeadow,
	"questActiveLake" : playerStats.questActiveLake,
	"questActiveDeepForest" : playerStats.questActiveDeepForest,
	"questActiveRocky" : playerStats.questActiveRocky,
	"questLocationAfterExit" : playerStats.questLocationAfterExit,
	"playerPosX" : playerPosX,
	"playerPosY" : playerPosY,
	"ObeliskCanBeActivated" : playerStats.ObeliskCanBeActivated,
	"BlessedTreeCanBeActivated" : playerStats.BlessedTreeCanBeActivated,
	}
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	
	var file = File.new()
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		file.store_var(data)
		file.close()
		print("DataSaved")
		print(data)


func _on_ContinueButton_pressed():
	if gameIsPaused == false:
		get_tree().change_scene("res://Scenes/BigLevel.tscn")
		var file = File.new()
		if file.file_exists(save_path):
			var error = file.open(save_path, File.READ)
			if error == OK:
				var loaded_data = file.get_var()
				file.close()
				print("DataLoaded")
				print(loaded_data)
				playerStats.health = loaded_data["Health"]
				playerStats.max_health = loaded_data["MaxHealth"]
				playerStats.ammo = loaded_data["Ammo"]
				playerStats.max_ammo = loaded_data["MaxAmmo"]
				playerStats.FireBowUnlocked = loaded_data["FireBowUnlocked"]
				playerStats.TechBowUnlocked = loaded_data["TechBowUnlocked"]
				playerStats.IceBowUnlocked = loaded_data["IceBowUnlocked"]
				playerStats.slimeMat = loaded_data["SlimeMat"]
				playerStats.ThunderActivated = loaded_data["Thunder"]
				playerStats.DarkActivated = loaded_data["Dark"]
				playerStats.SolarActivated = loaded_data["Solar"]
				playerStats.ForestActivated = loaded_data["Forest"]
				playerStats.questActiveStart = loaded_data["questActiveStart"]
				playerStats.questActiveMeadow = loaded_data["questActiveMeadow"]
				playerStats.questActiveLake = loaded_data["questActiveLake"]
				playerStats.questActiveDeepForest = loaded_data["questActiveDeepForest"]
				playerStats.questActiveRocky = loaded_data["questActiveRocky"]
				playerStats.questLocationAfterExit = loaded_data["questLocationAfterExit"]
				playerStats.playerPosX = loaded_data["playerPosX"]
				playerStats.playerPosY = loaded_data["playerPosY"]
				playerStats.ObeliskCanBeActivated = loaded_data["ObeliskCanBeActivated"]
				playerStats.BlessedTreeCanBeActivated = loaded_data["BlessedTreeCanBeActivated"]
			

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		_on_ExitButton_pressed()

