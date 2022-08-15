extends Position2D

const arrow = preload("res://Materials/Player/Arrows/Arrow.tscn")
const fire_arrow = preload("res://Materials/Player/Arrows/FireArrow.tscn")
const tech_arrow = preload("res://Materials/Player/Arrows/TechArrow.tscn")
const ice_arrow = preload("res://Materials/Player/Arrows/IceArrow.tscn")

var stats = PlayerStats

export var DURATION = 0.08

onready var bow = $Sprite
onready var timer = $Timer
onready var animation = $ShootAnimation


func _ready():
	hide() == true

func _process(delta):
	able_to_shoot()
	var mouse_position = get_local_mouse_position()
	bow.rotation = mouse_position.angle() + 0.785
	pass

func able_to_shoot():
	if timer.time_left == 0:
		if stats.ammo != 0:
			if Input.is_action_just_pressed("ui_mouse"):
				print("YES")
				var mouse_position = get_local_mouse_position()
				bow.rotation = mouse_position.angle() + 0.785
				shoot(mouse_position)
				timer.start(DURATION)

func shoot(mouse_position):
	print("shoot")
	show() == true
	if get_parent().element == 0:
		animation.play("Shoot")
	if get_parent().element == 1:
		animation.play("FireShoot")
	if get_parent().element == 2:
		animation.play("TechShoot")
	if get_parent().element == 3:
		animation.play("IceShoot")
	

func _on_FireAnimation_animation_finished(anim_name):
	if get_parent().element == 0:
		instance_arrow()
	if get_parent().element == 1:
		instance_fire_arrow()
	if get_parent().element == 2:
		instance_tech_arrow()
	if get_parent().element == 3:
		instance_ice_arrow()
	stats.ammo -= 1
	print(stats.ammo)
	hide() == true

func instance_arrow():
	var arrow_instance = arrow.instance()
	arrow_instance.position = global_position
	arrow_instance.rotation = get_local_mouse_position().angle() + 0.785
	get_parent().get_parent().add_child(arrow_instance)
	
	
func instance_fire_arrow():
	var fire_arrow_instance = fire_arrow.instance()
	fire_arrow_instance.position = global_position
	fire_arrow_instance.rotation = get_local_mouse_position().angle() + 0.785
	get_parent().get_parent().add_child(fire_arrow_instance)
	
func instance_tech_arrow():
	var tech_arrow_instance = tech_arrow.instance()
	tech_arrow_instance.position = global_position
	tech_arrow_instance.rotation = get_local_mouse_position().angle() + 0.785
	get_parent().get_parent().add_child(tech_arrow_instance)

func instance_ice_arrow():
	var ice_arrow_instance = ice_arrow.instance()
	ice_arrow_instance.position = global_position
	ice_arrow_instance.rotation = get_local_mouse_position().angle() + 0.785
	get_parent().get_parent().add_child(ice_arrow_instance)
