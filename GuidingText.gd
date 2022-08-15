extends Control

onready var text = $Label
onready var fireBowSprite = $FireBowUnlocked
onready var iceBowSprite = $IceBowUnlocked
onready var techBowSprite = $TechBowUnlocked

var playerStats = PlayerStats
var moved = false
var evaded = true   #Tohle je důležitý odendat, až budu chtít udělat roll rollstate
var shot = false
var arrowPickedUp = false
var storyIntroduction = false
var objectiveDefined = false

var fireBowEquipped = false
var iceBowEquipped = false
var techBowEquipped = false
# Called when the node enters the scene tree for the first time.
func _ready():
	text.text = str("Use WASD to move")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moved != true:
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
			text.text = str("Shoot with Left mouse click")
			moved = true
#	if evaded != true:
#		if moved == true and Input.is_action_just_pressed("ui_select"):
#			text.text = str("Shoot with Left mouse click")
#			evaded = true
	if shot != true:
		if moved == true and evaded == true and Input.is_action_just_pressed("ui_mouse"):
			text.text = str("Pickup your Arrow")
			shot = true
	if arrowPickedUp != true:
		if moved == true and evaded == true and shot == true and PlayerStats.arrowPickedUp == true:
			text.text = str("The Elemental Balance was destroyed by the Evil Spirits")
			arrowPickedUp = true
	if storyIntroduction != true:
		if moved == true and evaded == true and shot == true and arrowPickedUp == true:
			yield(get_tree().create_timer(6), "timeout")
			text.text = str("Wake them and restore the Harmony of the Elements")
			storyIntroduction = true
	if objectiveDefined != true:
		if moved == true and evaded == true and shot == true and arrowPickedUp == true and storyIntroduction == true:
			yield(get_tree().create_timer(6), "timeout")
			objectiveDefined = true
			self.hide()
			playerStats.TutorialFinished = true


	if playerStats.FireBowUnlocked == true and fireBowEquipped == false:
		text.text = str("Fire Bow Unlocked! Equip your Fire Bow by pressing 2")
		fireBowSprite.show()
		self.show()
		if Input.is_action_just_pressed("2"):
			fireBowEquipped = true
			self.hide()
			fireBowSprite.hide()
	if playerStats.IceBowUnlocked == true and iceBowEquipped == false:
		text.text = str("Ice Bow Unlocked!")
		iceBowSprite.show()
		self.show()
		if Input.is_action_just_pressed("3"):
			iceBowEquipped = true
			self.hide()
			iceBowSprite.hide()
	if playerStats.TechBowUnlocked == true and techBowEquipped == false:
		text.text = str("Tech Bow Unlocked!")
		techBowSprite.show()
		self.show()
		if Input.is_action_just_pressed("4"):
			techBowEquipped = true
			self.hide()
			techBowSprite.hide()
