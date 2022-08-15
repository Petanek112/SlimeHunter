extends StaticBody2D

var slimeTwin = preload("res://Materials/Slimes/Bosses/SlimeTwin.tscn")

onready var playerDetectionZone = $PlayerDetectionZone
onready var animatedSprite = $AnimatedSprite
onready var animationPlayer = $AnimationPlayer

onready var playerStats = PlayerStats

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playerDetectionZone.playerPresent != null:
		if playerStats.ObeliskCanBeActivated == true and Input.is_action_just_pressed("ui_accept"):
			animationPlayer.play("Charge")
			playerStats.ObeliskActivated = true
			var slimeTwin_instance = slimeTwin.instance()
			get_parent().call_deferred("add_child", slimeTwin_instance)
			slimeTwin_instance.global_position = Vector2(global_position.x + 200, global_position.y)
			var slimeTwin_instance2 = slimeTwin.instance()
			get_parent().call_deferred("add_child", slimeTwin_instance2)
			slimeTwin_instance2.global_position = Vector2(global_position.x - 200, global_position.y)
			playerStats.ObeliskCanBeActivated = false
