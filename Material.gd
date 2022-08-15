extends RigidBody2D


export var impulseRange = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	apply_impulse(Vector2(0,0), Vector2(rand_range(-impulseRange,impulseRange),rand_range(-impulseRange,impulseRange)))

func _on_Area2D_area_entered(area):
	queue_free()
