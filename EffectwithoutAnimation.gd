extends Node2D

onready var sound = $AudioStreamPlayer

func _ready():
# warning-ignore:return_value_discarded
#	self.connect("animation_finished", self, "_on_animation_finished") #1. Signal, 2. Object with function 3. Function
	#sound.play();
	pass


func _on_animation_finished():
	pass
	#queue_free();


func _on_AudioStreamPlayer_finished():
	queue_free()
