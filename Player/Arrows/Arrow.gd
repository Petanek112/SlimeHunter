extends RigidBody2D

export var SPEED = 240
export var LIFE_TIME = 0.6

var fireArrow = false

onready var area_Collision = $Arrow_area/CollisionShape2D
onready var playerDetection = $PlayerDetection/CollisionShape2D
onready var timer = $Timer
onready var Particle = $Particle
onready var blinkingEffect = $BlinkingEffect

func _ready():
	blinkingEffect.hide()
	playerDetection.set_deferred("disabled", true)
	apply_impulse(Vector2(), Vector2(SPEED, 0).rotated(rotation - 0.785))
	timer.start(LIFE_TIME)
	
func _on_Arrow_body_entered(body):
	linear_damp = 10000
	angular_damp = 10000
	if fireArrow == true:
		$FireHitBox.set_deferred("monitorable", false)
	blinkingEffect.show()
	Particle.set_emitting(false)
	area_Collision.set_deferred("disabled", true)
	playerDetection.set_deferred("disabled", false)


func _on_PlayerDetection_area_entered(area):
	print("arrow_pickup")
	get_tree().get_root().get_node("World/YSort/Player").arrow_pickup()
	queue_free()

func _on_Timer_timeout():
	_on_Arrow_body_entered(0)

func _on_DespawnTimer_timeout():
	print("arrow_despawned")
	queue_free()
