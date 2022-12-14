extends Line2D

var target
var point
export(NodePath) var targetPath
export var trailLenght = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(targetPath)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_deferred("global_position", Vector2(0, 0))
	global_rotation = 0
	point = target.global_position
	add_point(point)
	while get_point_count() > trailLenght:
		remove_point(0)
	
