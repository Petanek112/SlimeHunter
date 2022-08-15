extends Area2D

export var Flower1 = false
export var Flower2 = false
export var Flower3 = false
export var Flower4 = false
export var Flower5 = false
export var Flower6 = false
export var Flower7 = false
export var Flower8 = false
export var Flower2Big = false
export var Flower4Big = false
export var Flower6Big = false

var FlowerType
var playerNear = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if Flower1 == true:
		FlowerType = 0
	if Flower2 == true:
		FlowerType = 1
	if Flower3 == true:
		FlowerType = 2
	if Flower4 == true:
		FlowerType = 3
	if Flower5 == true:
		FlowerType = 4
	if Flower6 == true:
		FlowerType = 5
	if Flower7 == true:
		FlowerType = 6
	if Flower8 == true:
		FlowerType = 7
	if Flower2Big == true:
		FlowerType = 21
	if Flower4Big == true:
		FlowerType = 22
	if Flower6Big == true:
		FlowerType = 23


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.get_action_strength("ui_accept") and playerNear == true:
		get_tree().get_root().get_node("World/YSort/Player").flower_pickup(FlowerType)
		get_parent().queue_free()

func _on_FlowerArea2D_body_entered(body):
	playerNear = true

func _on_FlowerArea2D_body_exited(body):
	playerNear = false
