extends Node2D

export var Flower1 = preload("res://Materials/World/Environment/Flowers/Flower1Type.tscn")
export var Flower2 = preload("res://Materials/World/Environment/Flowers/Flower1Type.tscn")
export var Flower3 = preload("res://Materials/World/Environment/Flowers/Flower1Type.tscn")
export var Flower4 = preload("res://Materials/World/Environment/Flowers/Flower1Type.tscn")
export var Flower5 = preload("res://Materials/World/Environment/Flowers/Flower1Type.tscn")
export var Flower6 = preload("res://Materials/World/Environment/Flowers/Flower1Type.tscn")
export var Flower7 = preload("res://Materials/World/Environment/Flowers/Flower1Type.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var Flowers = [Flower1, Flower2, Flower3, Flower4, Flower5, Flower6, Flower7]
	var flower_instance =  Flowers[round(rand_range(0, 6))].instance()
	get_parent().call_deferred("add_child", flower_instance)
	flower_instance.global_position = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
