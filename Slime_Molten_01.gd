extends "res://Materials/Slimes/Enemy.gd"

export var boomCooldown = 5

onready var boomTimer = $BoomTimer
onready var tween = $Tween
onready var hitBox = $HitBox
onready var fireHitBox = $FireHitBox
#onready var boomParticle = $BoomParticle


# Called when the node enters the scene tree for the first time.
func _ready():
	hitBox.monitorable = false
	fireHitBox.monitorable = false
	#boomParticle.emitting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playerDetectionZone.can_see_player():
		state = CHASE
		if boomTimer.time_left <= 0:
			tween.interpolate_property(sprite, "modulate", Color(1,1,1), Color(1,0.2,0.2), boomCooldown, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			boomTimer.start(boomCooldown)
	else:
		boomTimer.stop()
		tween.stop_all()
	if boomTimer.time_left <= 2 and boomTimer.time_left >= 0.1:
		#boomParticle.emitting = true
		pass
	else:
		#boomParticle.emitting = false
		pass
		
func _on_BoomTimer_timeout():
	print("Boom")
	hitBox.monitorable = true
	fireHitBox.monitorable = true
	yield(get_tree().create_timer(0.1), "timeout")
	if fireHitBox != null:
		print("Now fire")
		get_tree().get_root().get_node("World/YSort/Player").player_on_fire()
	if FireSpirit != true:
		stats.health -= MaxHp
	else:
		var enemyParticleEffect = EnemyParticleEffect.instance()
		get_parent().call_deferred("add_child", enemyParticleEffect)
		enemyParticleEffect.global_position = global_position
		boomTimer.start(boomCooldown)
