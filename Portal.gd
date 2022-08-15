extends Sprite

onready var playerDetectionZone = $PlayerDetectionZone
onready var Fire = $Particles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Fire.emitting = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	seek_player();
	
func seek_player():
	if playerDetectionZone.can_see_player():
		Fire.emitting = true
		if Input.is_action_just_pressed("F"):
			print("Next Level")
			SceneManager.change_scene()


