extends Area2D

const marker = preload("res://Materials/UI/ArrowMarker.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ArrowDetectionAre_area_entered(area):
	var marker_instance = marker.instance()
	#get_tree().get_root(). get_node("World/YSort/Player/TurnAxis").rotation = get_local_mouse_position().angle() + 0.785
	marker_instance.position = global_position
	marker_instance.rotation = get_local_mouse_position().angle() + 0.785
	get_parent().add_child(marker_instance)
	if _on_ArrowDetectionAre_area_exited(area) == true:
		print("Area Exitted")

func _on_ArrowDetectionAre_area_exited(area):
	pass
