extends Node2D

export var Thunder = false
export var Darkness = false
export var Solar = false
export var Forest = false
var playerStats = PlayerStats
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Thunder == true:
		if playerStats.ThunderActivated == true:
			self.show()
		else:
			self.hide()
	if Darkness == true:
		if playerStats.DarkActivated == true:
			self.show()
		else:
			self.hide()
	if Solar == true:
		if playerStats.SolarActivated == true:
			self.show()
		else:
			self.hide()
	if Forest == true:
		if playerStats.ForestActivated == true:
			self.show()
		else:
			self.hide()
