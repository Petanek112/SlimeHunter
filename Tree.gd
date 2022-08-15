extends StaticBody2D

onready var playerDetectionZone = $PlayerDetectionZone

export var NumberOfMosses = 0
export var NumberOfBranches = 0
export var HasSprite = false

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var randomNumber = rng.randf_range(-0.2, +0.2)
	self.scale.x += randomNumber
	self.scale.y += randomNumber
	
	if HasSprite != false:
		$Sprite.speed_scale += randomNumber
	
	if randi() % 8 == 1 and (NumberOfMosses == 1 or NumberOfMosses == 2):
		$Moss1.show() 
	if randi() % 8 == 1 and NumberOfMosses == 2:
		$Moss2.show() 
	if randi() % 6 == 1 and (NumberOfBranches == 1 or NumberOfBranches == 2):
		$Branch1.show() 
	if randi() % 6 == 1 and NumberOfBranches == 2:
		$Branch2.show() 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().get_root().get_node_or_null("World/YSort/Player") != null:
		var playerPresent = playerDetectionZone.playerPresent
		if playerPresent != null:
			self.modulate = Color(1,1,1,0.7)
		else:
			self.modulate = Color(1,1,1,1)

func _on_TreeDestructionArea_area_entered(area):
	queue_free()
