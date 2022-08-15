extends "res://Materials/World/Environment/Tree.gd"

var forestSpirit = preload("res://Materials/Slimes/Bosses/ForestSpirit.tscn")

onready var playerDetectionZoneForActivation = $PlayerDetectionZoneForActivation
onready var animatedSpriteActivation = $AnimatedSpriteActivation

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playerDetectionZoneForActivation.playerPresent != null:
		if PlayerStats.BlessedTreeCanBeActivated == true and Input.is_action_just_pressed("ui_accept"):
			$Sprite.hide()
			animatedSpriteActivation.show()
			animatedSpriteActivation.play()
			PlayerStats.BlessedTreeCanBeActivated = false


func _on_AnimatedSpriteActivation_animation_finished():
	PlayerStats.BlessedTreeActivated = true
	var forestSpirit_instance = forestSpirit.instance()
#	get_tree().get_root().get_node("World/YSort").call_deferred("add_child", forestSpirit_instance)
	get_tree().get_root().get_node("World/YSort").add_child(forestSpirit_instance)
	forestSpirit_instance.global_position = Vector2(global_position.x, global_position.y)
