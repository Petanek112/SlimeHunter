extends Node2D


var fireSpirit = preload("res://Materials/Slimes/Bosses/FireSpirit.tscn")

onready var playerDetectionZone = $PlayerDetectionZone

onready var playerStats = PlayerStats

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playerDetectionZone.playerPresent != null:
		if playerStats.RitualCanBeActivated == true and Input.is_action_just_pressed("ui_accept"):
			playerStats.RitualActivated = true
			var fireSpirit_instance = fireSpirit.instance()
			get_parent().call_deferred("add_child", fireSpirit_instance)
			fireSpirit_instance.global_position = Vector2(global_position.x, global_position.y)
			playerStats.RitualCanBeActivated = false
