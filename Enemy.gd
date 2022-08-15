extends KinematicBody2D



export var ACCELERATION = 300;
export var MAX_SPEED = 50;
export var FRICTION = 200;
export var WANDER_TARGET_RANGE = 8;
export var AutomaticalDespawnRange = 1000;
export var EnemyDeathEffect = preload("res://Materials/Particles/Effects/Slime_Green_Boom.tscn")
export var EnemyParticleEffect = preload("res://Materials/Particles/Slime Particles/Slime_Death_Green.tscn")
export var EnemyWalkingEffect = preload("res://Materials/Particles/Effects/Walking/GreenWalkingParticles.tscn")
export var WalkingEffectRangeY = 7.6;
export var HpBoost = preload("res://Materials/Particles/Boosts/HpBoost.tscn")
export var AmmoBoost = preload("res://Materials/Particles/Boosts/AmmoBoost.tscn")
export var greenMaterial = preload("res://Materials/Slimes/Walking/Green/GreenMaterial.tscn")
#export var chaseTimer = preload("res://Materials/Slimes/ChaseTimer.tscn")
export var MaxHp = 1
export var MaxMaterialDrop = 3
export var MinMaterialDrop = 1
export var greenSlime = false
export var blueSlime = false
export var redSlime = false
export var forestSlime = false
export var moltenSlime = false
export var chaosSlime = false
export var SlimeTwin = false
export var WaterSpirit = false
export var ForestSpirit = false
export var FireSpirit = false
export var DropsHpBoost = false
export var DropsAmmoBoost = false

var tree = preload("res://Materials/World/Environment/Tree_02.tscn")

enum{
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO;
var knockback = Vector2.ZERO;

var state = IDLE
var playerStats = PlayerStats

var slimeWalkingEffectActivated = false

var slimeTargetHouse = false

var takeFireDamage = false

var boomSlimeDeath = false

var hurt = false
var timerStarted = false

signal invincibilityEnded

onready var hurtbox = $HurtBox
onready var sprite = $AnimatedSprite
onready var stats = $Stats;    #referencing the nodes
onready var playerDetectionZone = $PlayerDetectionZone
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer
onready var burningTimer = $BurningTimer
onready var takingFireDamageTimer = $TakingFireDamageTimer
onready var chaseTimer = $ChaseTimer

func _ready():
	if forestSlime == false and moltenSlime == false and chaosSlime == false:
		if round(rand_range(1, 10)) == 1 and DropsAmmoBoost == false and $HealthBoost != null:
			DropsHpBoost = true
			$HealthBoost.visible = true
		if round(rand_range(1, 10)) == 1 and DropsHpBoost == false and $AmmoBoost != null:
			DropsAmmoBoost = true
			$AmmoBoost.visible = true
	state = pick_random_state([IDLE, WANDER])
	stats.health = MaxHp

func _physics_process(delta):
	destroy_if_player_away()
	walking_effect()
	chase_after_hurt(delta)
	#knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)  #Making friction
	#knockback = move_and_slide(knockback);

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta);
			seek_player();
			if wanderController.get_time_left() == 0:
				update_wander()
				
		WANDER:
			seek_player();
			if wanderController.get_time_left() == 0:
				update_wander()

			accelerate_towards_point(wanderController.target_position, delta) #Making the direction from bat to player + Normalized = cutting the line between them and replacing with 0 - 1

			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
#
		CHASE:
			var playerPresent = playerDetectionZone.playerPresent
#			var player = get_tree().get_root().get_node_or_null("World/YSort/Player")
#			if player != null:
#				accelerate_towards_point(player.global_position, delta)
			if playerPresent != null:

				accelerate_towards_point(playerPresent.global_position, delta)
			else:
				state = IDLE

#
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point) #Making the direction from bat to player + Normalized = cutting the line between them and replacing with 0 - 1
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0;

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 6))

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func destroy_if_player_away():
	if get_tree().get_root().get_node_or_null("World/YSort/Player") != null:
		var playerPosition = get_tree().get_root().get_node("World/YSort/Player").global_position
		if playerPosition.x <= self.global_position.x - AutomaticalDespawnRange or playerPosition.y <= self.global_position.y - AutomaticalDespawnRange or playerPosition.x >= self.global_position.x + AutomaticalDespawnRange or playerPosition.y >= self.global_position.y + AutomaticalDespawnRange:
			queue_free()
			
		
func pick_random_state(state_list):
	state_list.shuffle()              #Picking a rondom from list
	return state_list.pop_front()     #Picking a rondom from list

func _on_HurtBox_area_entered(area):  
	print("area entered")              #You call down (which is this) and signal up !!!!
	stats.health -= area.damage;
	hurt = true
	#if area == get_tree().get_root().get_node("World/YSort/Detailed/Alchemy_House"):
	#	print("Alchemy House reached")
	#	stats.health -= stats.health
	#knockback = area.knockback_vector * 120;
	hurtbox.create_hit_effect();
	hurtbox.start_invincibility(0.4)


func chase_after_hurt(delta):
	if hurt == true:
		state = CHASE
		var player = get_tree().get_root().get_node_or_null("World/YSort/Player")
		if player != null:
			accelerate_towards_point(player.global_position, delta)
		if timerStarted == false:
			chaseTimer.start(3)
			timerStarted = true
		if chaseTimer.time_left <= 0.1:
			print("hurt=false")
			timerStarted = false
			hurt = false
		
		
func _on_Stats_no_health():
	if forestSlime == true:
		var tree_instance = tree.instance()
		tree_instance.position = self.global_position
	if SlimeTwin == true:
		playerStats.SlimeTwinsKillCount += 1
	if WaterSpirit == true:
		playerStats.WaterSpiritKilled = true
	if ForestSpirit == true:
		playerStats.ForestSpiritKilled = true
	killCounter()
	materialDropLoop()
	boost_check()
	queue_free()
	print("Death Effects")
	var enemyDeathEffect = EnemyDeathEffect.instance()
	var enemyParticleEffect = EnemyParticleEffect.instance()
	get_parent().call_deferred("add_child", enemyDeathEffect)
	get_parent().call_deferred("add_child", enemyParticleEffect)
	enemyDeathEffect.flip_h = velocity.x < 0;
	enemyDeathEffect.global_position = global_position
	enemyParticleEffect.global_position = global_position

func killCounter():
	if greenSlime == true:
		playerStats.greenSlimesKilled += 1
	if blueSlime == true:
		playerStats.blueSlimesKilled += 1
	if redSlime == true:
		playerStats.redSlimesKilled += 1
	if moltenSlime == true:
		playerStats.moltenSlimesKilled += 1
	if forestSlime == true:
		playerStats.forestSlimesKilled += 1
	if chaosSlime == true:
		playerStats.chaosSlimesKilled += 1

func materialDropLoop():
	var maxMaterial = round(rand_range(MinMaterialDrop, MaxMaterialDrop))
	for x in maxMaterial:
		var greenMaterial_instance = greenMaterial.instance()
		greenMaterial_instance.position = self.global_position
		get_parent().call_deferred("add_child", greenMaterial_instance)
		
func _on_HurtBox_invincibility_started():
	animationPlayer.play("Start")

func _on_HurtBox_invincibility_ended():
	animationPlayer.play("Stop")
	emit_signal("invincibilityEnded")

func enemy_on_fire():
	sprite.modulate = Color(1,0,0)
	takeFireDamage = true
	print("FireDamage")
	take_fire_damage()
	print("BurningTimer")
	burningTimer.start(4)
	
func enemy_back_to_normal():
	print("BurningEnded")
	takeFireDamage = false
	sprite.modulate = Color(1,1,1)

func take_fire_damage():
	if takeFireDamage == true and stats.health >= 0:
		stats.health -= 1
		takingFireDamageTimer.start(1)

func take_fire_damage_delay(): #Important for some reason, maybe I damaged it :/
	pass
	
func boost_check():
	if DropsHpBoost == true:
		var HpBoost_instance = HpBoost.instance()
		get_parent().call_deferred("add_child", HpBoost_instance)
		HpBoost_instance.global_position = global_position
	if DropsAmmoBoost == true:
		var AmmoBoost_instance = AmmoBoost.instance()
		get_parent().call_deferred("add_child", AmmoBoost_instance)
		AmmoBoost_instance.global_position = global_position

	
func walking_effect():
	pass
#	if sprite.frame == 1:
#		slimeWalkingEffectActivated = false
#	if sprite.frame == 3 and slimeWalkingEffectActivated == false:
#		var EnemyWalkingEffect_instance = EnemyWalkingEffect.instance()
#		get_parent().get_parent().call_deferred("add_child", EnemyWalkingEffect_instance)
#		EnemyWalkingEffect_instance.global_position = Vector2(global_position.x - 2, global_position.y + WalkingEffectRangeY)
#		slimeWalkingEffectActivated = true
