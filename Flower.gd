extends Sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	var x = rand_range(0.7, 0.9)
	self.scale = Vector2(x,x)
	self.global_position = Vector2(global_position.x + rand_range(-5,5),global_position.y + rand_range(-5,5))
	var randomInteger = randi() % 4
	if randomInteger == 1:
		flip_h
	if round(rand_range(0,1)) == 0:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
