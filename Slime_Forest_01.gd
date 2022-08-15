extends "res://Materials/Slimes/Enemy.gd"


onready var stunTimer = $StunTimer

export var stunCooldown = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	forestSlime = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playerDetectionZone.can_see_player():
		print("Player Stunned")
		var player = get_tree().get_root().get_node("World/YSort/Player")
		if player.stunActive != true:
			player.stun_player()
			#stunTimer.start(stunCooldown)

