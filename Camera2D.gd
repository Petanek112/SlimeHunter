extends Camera2D

onready var topLeft = $Limits/TopLeft
onready var bottomRight = $Limits/BottomRight

export var vector2min = Vector2(0.8,0.8)
export var vector2max = Vector2(4,4)


func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x
	pass
	
func _input(event):
	if get_tree().get_current_scene().get_filename() != "res://Scenes/Menu.tscn":
		if event is InputEventMouseButton:
			if event.is_pressed():
				if event.button_index == BUTTON_WHEEL_UP and zoom >= vector2min:
					zoom -= Vector2(0.1,0.1)
				if event.button_index == BUTTON_WHEEL_DOWN and zoom <= vector2max:
					zoom += Vector2(0.1,0.1)
