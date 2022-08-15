extends Node2D

onready var spawnRateTimer = $SpawnRateTimer
onready var area = $Area2D
onready var collision = $Area2D/CollisionShape2D

export var spawnRate = 2.1
export var spawnRangeX = 100
export var spawnRangeY = 100
export var spawnType = 0
export var slimeCapacity = 10

var spawnRateTimerOut = false
#var slimeCap = 0
var spawnerStopped = false

var greenSign = preload("res://Materials/World/Environment/Signs/GreenSign.tscn")
var blueSign = preload("res://Materials/World/Environment/Signs/BlueSign.tscn")
var redSign = preload("res://Materials/World/Environment/Signs/RedSign.tscn")
var moltenSign = preload("res://Materials/World/Environment/Signs/MoltenSign.tscn")
var forestSign = preload("res://Materials/World/Environment/Signs/ForestSign.tscn")
var chaosSign = preload("res://Materials/World/Environment/Signs/ChaosSign.tscn")

var greenSlime = preload("res://Materials/Slimes/Walking/Slime_Green_01.tscn")
var blueSlime = preload("res://Materials/Slimes/Walking/Slime_Blue_01.tscn")
var redSlime = preload("res://Materials/Slimes/Walking/Slime_Red_01.tscn")
var moltenSlime = preload("res://Materials/Slimes/Walking/Slime_Molten_01.tscn")
var forestSlime = preload("res://Materials/Slimes/Walking/Slime_Forest_01.tscn")
var chaosSlime = preload("res://Materials/Slimes/Walking/Slime_Chaos_01.tscn")

var signType = [greenSign,
	blueSign,
	redSign,
	moltenSign,
	forestSign,
	chaosSign]
	
var slimeType = [greenSlime,
	blueSlime,
	redSlime,
	moltenSlime,
	forestSlime,
	chaosSlime]
	
# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_signs()
	set_collision_shape()

	spawnRateTimerOut = true

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	slimeSpawn()
	
func set_collision_shape():
	area.scale = Vector2(spawnRangeX, spawnRangeY)
#	collision.shape.extents = Vector2(spawnRange, spawnRange)
	pass

func spawn_signs():
	var sign_instance1 = signType[spawnType].instance()
	sign_instance1.position = Vector2(global_position.x + spawnRangeX,global_position.y)
	get_tree().get_root().get_node("World/YSort").call_deferred("add_child", sign_instance1)
	var sign_instance2 = signType[spawnType].instance()
	sign_instance2.position = Vector2(global_position.x,global_position.y + spawnRangeY)
	get_tree().get_root().get_node("World/YSort").call_deferred("add_child", sign_instance2)
	var sign_instance3 = signType[spawnType].instance()
	sign_instance3.position = Vector2(global_position.x - spawnRangeX,global_position.y)
	get_tree().get_root().get_node("World/YSort").call_deferred("add_child", sign_instance3)
	var sign_instance4 = signType[spawnType].instance()
	sign_instance4.position = Vector2(global_position.x ,global_position.y - spawnRangeY)
	get_tree().get_root().get_node("World/YSort").call_deferred("add_child", sign_instance4)
	var sign_instance5 = signType[spawnType].instance()
	sign_instance5.position = Vector2(global_position.x + spawnRangeX,global_position.y + spawnRangeY)
	get_tree().get_root().get_node("World/YSort").call_deferred("add_child", sign_instance5)
	var sign_instance6 = signType[spawnType].instance()
	sign_instance6.position = Vector2(global_position.x - spawnRangeX,global_position.y - spawnRangeY)
	get_tree().get_root().get_node("World/YSort").call_deferred("add_child", sign_instance6)
	var sign_instance7 = signType[spawnType].instance()
	sign_instance7.position = Vector2(global_position.x + spawnRangeX,global_position.y - spawnRangeY)
	get_tree().get_root().get_node("World/YSort").call_deferred("add_child", sign_instance7)
	var sign_instance8 = signType[spawnType].instance()
	sign_instance8.position = Vector2(global_position.x - spawnRangeX,global_position.y + spawnRangeY)
	get_tree().get_root().get_node("World/YSort").call_deferred("add_child", sign_instance8)
	
func slimeSpawn():
	var slimeCap = area.get_overlapping_bodies()
	if spawnRateTimerOut == true and spawnerStopped == false:
		var slime_instance = slimeType[spawnType].instance()
		slime_instance.global_position = Vector2(global_position.x - rand_range(-spawnRangeX,spawnRangeX),global_position.y - rand_range(-spawnRangeY,spawnRangeY))
		get_tree().get_root().get_node("World/YSort/Slimes").call_deferred("add_child", slime_instance)
		spawnRateTimer.start(spawnRate)
		slimeCap = area.get_overlapping_bodies()
		spawnRateTimerOut = false
	if slimeCap.size() >= slimeCapacity:
		spawnerStopped = true
	else:
		spawnerStopped = false
#			print("Wave released")
#			slime_instance.slimeTargetHouse = true
		
func _on_SpawnRateTimer_timeout():
	spawnRateTimerOut = true

