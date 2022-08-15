extends "res://Materials/World/Environment/Tree.gd"

var waterSpirit = preload("res://Materials/Slimes/Bosses/WaterSpirit.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func enemy_on_fire():
	var waterSpirit_instance = waterSpirit.instance()
	get_parent().call_deferred("add_child", waterSpirit_instance)
	waterSpirit_instance.global_position = Vector2(global_position.x + 300, global_position.y)
	PlayerStats.TreeDestroyed = true
	queue_free()
