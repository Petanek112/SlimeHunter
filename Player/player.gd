extends KinematicBody2D #Musí být přesně název NODE      #Můžeme extendnout jinej script

const veins = preload("res://Materials/Slimes/Walking/Forest/Veins.tscn")
const questCompletionParticles = preload("res://Materials/Particles/QuestCompleted.tscn")

enum{
	MOVE,
	ROLL,
	SHOOT
}

enum{
	NORMAL,
	FIRE,
	TECH,
	ICE,
}
var state = MOVE;
var velocity = Vector2.ZERO;
var roll_vector = Vector2.DOWN;
var stats = PlayerStats
var anim_direction
var animFinished
var takeFireDamage
var stunnable = true

onready var bow = $Bow
onready var animationPlayer = $AnimationPlayer # We don't know if it is in the scene yet but onready fixes it  $ Getting acces to a component or a child
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
#onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $HurtBox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var hurtSound = $AudioStreamPlayerHurt
onready var sprite = $Sprite
onready var bow_timer = $Bow/Timer
onready var timer = $Timer
onready var rollTimer = $RollTimer
onready var rollEndTimer = $RollEndTimer
onready var pickupArea = $PickupArea


export var cooloff = 0.1
export var Max_Speed = 150;
export var Acceleration = 800;
export var Friction = 600;
export var RollSpeed = 360;
export var rollCooldown = 3;
export var element = NORMAL;
#export var MaxHp = 5;
#export var MaxAmmo = 4;
export var healthRegenTime = 2
export var ammoRegenTime = 2
export var stunDuration = 2
export var stunActive = false
export var stunLength = 4

func _ready():
	randomize()
	#stats.connect("no_health", self, "queue_free")
	animationTree.active = true;
	#swordHitbox.knockback_vector = roll_vector;
	#stats.max_health = MaxHp
	#stats.health = stats.max_health
	#stats.max_ammo = MaxAmmo
	#stats.ammo = stats.max_ammo
	self.global_position.x = stats.playerPosX
	self.global_position.y = stats.playerPosY

func _physics_process(delta):   #Update Function
	match state:
		MOVE:
			move_state(delta);
		ROLL:
			roll_state();
		SHOOT:
			shooting_state();
			
	match element:
		NORMAL:
			normal_element();
		FIRE:
			fire_element();
		TECH:
			tech_element();
		ICE:
			ice_element();
	
	player_out_of_health()
	arrows_not_pickupable()
	
func move_state(delta):
	var input_vector = Vector2.ZERO;
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up");
	if bow_timer.time_left == 0:
		Animation_loop(input_vector);
	input_vector = input_vector.normalized();
	
	if Input.is_action_just_pressed("ui_mouse") and bow_timer.time_left == 0 and stats.ammo != 0:
		var strange_vector = get_local_mouse_position().normalized()
		strange_vector = Vector2(round(strange_vector.x), round(strange_vector.y))
		#print(strange_vector)
		animationTree.set("parameters/Idle/blend_position", get_local_mouse_position().normalized())
		animationTree.set("parameters/Run/blend_position", get_local_mouse_position().normalized())
		animationState.travel("Idle")
		Animation_loop(strange_vector)
		state = SHOOT
		timer.start(cooloff)
	elif input_vector != Vector2.ZERO and timer.time_left == 0 and stunActive != true:
		roll_vector = input_vector;
		#swordHitbox.knockback_vector = input_vector;
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		#animationTree.set("parameters/Attack/blend_position", input_vector)
		#animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * Max_Speed, Acceleration * delta)   #Makes friction
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, Friction * delta)
	
	move();
	
	
	if Input.is_action_just_pressed("ui_mouse"):
		pass
		
#	if Input.is_action_just_pressed("ui_roll"):
#		if rollEndTimer.time_left == 0:
#			state = ROLL;
	
	
func Animation_loop(input_vector):
	match input_vector:
		Vector2(-1,0):
			anim_direction = "L"
			bow.position = Vector2(-8, -10)
		Vector2(1,0):
			anim_direction = "R"
			bow.position = Vector2(8, -10)
		Vector2(0,1):
			anim_direction = "D"
			bow.position = Vector2(0, -2)
		Vector2(0,-1):
			anim_direction = "U"
			bow.position = Vector2(0, -18)
		Vector2(-1,-1):
			anim_direction = "L"
			bow.position = Vector2(-4, -14)
		Vector2(-1,1):
			anim_direction = "L"
			bow.position = Vector2(-4, -6)
		Vector2(1,-1):
			anim_direction = "R"
			bow.position = Vector2(4, -14)
		Vector2(1,1):
			anim_direction = "R"
			bow.position = Vector2(4, -6)


func shooting_state():
	velocity = Vector2.ZERO;
	state = MOVE
	
func roll_state():
	velocity = roll_vector * RollSpeed;
	move()
	if rollTimer.time_left == 0:
		rollTimer.start(0.1)
		rollEndTimer.start(rollCooldown)
		print("RollStarted")
	
	
func move():
	velocity = move_and_slide(velocity);
	
#func roll_animation_finished():
	#velocity = velocity * 0.8;
	#state = MOVE;
	
func attack_animation_finished():
	state = MOVE;
	
func _on_HurtBox_area_entered(area):
	stats.health -= area.damage;
	hurtSound.play()
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect();
	#var playerHurtSound = PlayerHurtSound.instance()
	#get_tree().current_scene.add_child(playerHurtSound)

func _on_HurtBox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_HurtBox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")

func arrow_pickup():
	print("arrow_pickup")
	stats.arrowPickedUp = true
	stats.ammo += 1

func _on_RollTimer_timeout():
	print("rollFinished")
	state = MOVE

func player_out_of_health():
	if stats.health <= 0:
		print("Player out of Health")
# warning-ignore:return_value_discarded
		self.hide()
		Max_Speed = 0
		yield(get_tree().create_timer(3), "timeout")
		get_tree().change_scene("res://Scenes/Menu.tscn")
		stats.health = stats.max_health
		stats.ammo = stats.max_ammo
		stats.slimeMat = 0


func _on_HealthRegenTimer_timeout():
	if stats.health != stats.max_health:
		stats.health += 1

func _on_AmmoRegenTimer_timeout():
	if stats.ammo != stats.max_ammo:
		stats.ammo += 1
	
func arrows_not_pickupable():
	if stats.ammo == stats.max_ammo:
		pickupArea.monitorable = false
	else:
		pickupArea.monitorable = true

func stun_player():
	#var playerMaxSpeed = Max_Speed
	#Max_Speed = 0
	if stunnable == true:
		stunnable = false
		stunActive = true 
		rollEndTimer.start()
		yield(get_tree().create_timer(0.3), "timeout")
		var veins_instance = veins.instance()
		veins_instance.position = Vector2(self.global_position.x, self.global_position.y - 8)
		get_parent().get_parent().add_child(veins_instance)
		print("VeinsInstanced")
		yield(get_tree().create_timer(stunDuration), "timeout")
		#Max_Speed = playerMaxSpeed
		veins_instance.queue_free()
		stunActive = false
		yield(get_tree().create_timer(4), "timeout")
		stunnable = true

func player_on_fire():
	
	modulate = Color(1,0,0)
	takeFireDamage = true
	print("PlayerTakingFireDamage")
	take_fire_damage()
	yield(get_tree().create_timer(4), "timeout")
	takeFireDamage = false
	modulate = Color(1,1,1)
	pass

func _on_PlayerFireHurtBox_body_entered(body):
	pass
	# player_on_fire()
	
func _on_PlayerFireHurtBox_area_entered(area):
	player_on_fire()
	
func _on_PlayerFireHurtBox_body_exited(body):
	player_on_fire()
	
func take_fire_damage():
	if takeFireDamage == true and stats.health >= 0:
		stats.health -= 1
		yield(get_tree().create_timer(1), "timeout")
		take_fire_damage()
		
func quest_completed():
	var questCompletionParticles_instance = questCompletionParticles.instance()
	get_parent().call_deferred("add_child", questCompletionParticles_instance)
	questCompletionParticles_instance.global_position = global_position

func _on_PlayerHealthBoostArea_area_entered(area):
	stats.max_health += 1
	stats.health += 1

func _on_PlayerAmmoBoostArea_area_entered(area):
	stats.ammo += 1
	
func _on_MaterialPickupArea_area_entered(area):
	stats.slimeMat += 1
	
func flower_pickup(flowerType):
	if flowerType == 0:
		stats.flowerType1 += 1
	if flowerType == 1:
		stats.flowerType2 += 1
	if flowerType == 2:
		stats.flowerType3 += 1
	if flowerType == 3:
		stats.flowerType4 += 1
	if flowerType == 4:
		stats.flowerType5 += 1
	if flowerType == 5:
		stats.flowerType6 += 1
	if flowerType == 6:
		stats.flowerType7 += 1
	if flowerType == 7:
		stats.flowerType8 += 1
	if flowerType == 21:
		stats.flowerType2Big += 1
	if flowerType == 22:
		stats.flowerType4Big += 1
	if flowerType == 23:
		stats.flowerType6Big += 1
	
func normal_element():
	if Input.is_action_just_pressed("2") and stats.FireBowUnlocked == true:
		element = FIRE
	if Input.is_action_just_pressed("3") and stats.TechBowUnlocked == true:
		element = TECH
	if Input.is_action_just_pressed("4") and stats.IceBowUnlocked == true:
		element = ICE
		
func fire_element():
	if Input.is_action_just_pressed("1"):
		element = NORMAL
	if Input.is_action_just_pressed("3") and stats.TechBowUnlocked == true:
		element = TECH
	if Input.is_action_just_pressed("4") and stats.IceBowUnlocked == true:
		element = ICE
	
func tech_element():
	if Input.is_action_just_pressed("2") and stats.FireBowUnlocked == true:
		element = FIRE
	if Input.is_action_just_pressed("1"):
		element = NORMAL
	if Input.is_action_just_pressed("4") and stats.IceBowUnlocked == true:
		element = ICE
		
func ice_element():
	if Input.is_action_just_pressed("2") and stats.FireBowUnlocked == true:
		element = FIRE
	if Input.is_action_just_pressed("3") and stats.TechBowUnlocked == true:
		element = TECH
	if Input.is_action_just_pressed("1"):
		element = NORMAL







