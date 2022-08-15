extends AnimatedSprite

func _ready():
# warning-ignore:return_value_discarded
	self.connect("animation_finished", self, "_on_animation_finished") #1. Signal, 2. Object with function 3. Function
	play();


func _on_animation_finished():
	queue_free();
