extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().get_current_scene().get_filename() != "res://Scenes/Menu.tscn":
		self.hide()

	if pressed == true:
		print("StartPressed")
		get_tree().change_scene("res://Scenes/BigLevel.tscn")
