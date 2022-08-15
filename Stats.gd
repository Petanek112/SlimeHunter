extends Node
export(int) var max_health = 8 setget set_max_health
var health = max_health setget set_health

export(int) var max_ammo = 6 setget set_max_ammo
var ammo = max_ammo setget set_ammo

export(int) var player_max_speed = 150

export(int) var slimeMat = 0 #setget set_slimeMat

export(int) var flowerType1 = 0 #setget set_flowerType1
export(int) var flowerType2 = 0 #setget set_flowerType2
export(int) var flowerType3 = 0 #setget set_flowerType3
export(int) var flowerType4 = 0 #setget set_flowerType4
export(int) var flowerType5 = 0 #setget set_flowerType5
export(int) var flowerType6 = 0 #setget set_flowerType6
export(int) var flowerType7 = 0 #setget set_flowerType7
export(int) var flowerType8 = 0 #setget set_flowerType8


export(int) var flowerType2Big = 0
export(int) var flowerType4Big = 0
export(int) var flowerType6Big = 0

export(bool) var StartLocated = false
export(bool) var MeadowLocated = false
export(bool) var LakeLocated = false
export(bool) var DeepForestLocated = false
export(bool) var RockyLocated = false

export(bool) var ThunderActivated = false
export(bool) var DarkActivated = false
export(bool) var SolarActivated = false
export(bool) var ForestActivated = false

export(bool) var ObeliskCanBeActivated = false
export(bool) var ObeliskActivated = false
export(bool) var BlessedTreeCanBeActivated = false
export(bool) var BlessedTreeActivated = false
export(bool) var RitualCanBeActivated = false
export(bool) var RitualActivated = false
export(bool) var TreeDestroyed = false
export(bool) var TutorialFinished = false

export(int) var SlimeTwinsKillCount = 0
export(bool) var WaterSpiritKilled = false
export(bool) var ForestSpiritKilled = false
export(bool) var FireSpiritKilled = false

export(int) var greenSlimesKilled = 0
export(int) var blueSlimesKilled = 0
export(int) var redSlimesKilled = 0
export(int) var forestSlimesKilled = 0
export(int) var moltenSlimesKilled = 0
export(int) var chaosSlimesKilled = 0

export(int) var questActiveStart = 0
export(int) var questActiveMeadow = 0
export(int) var questActiveLake = 0
export(int) var questActiveDeepForest = 0
export(int) var questActiveRocky = 0

export(int) var questLocationAfterExit

export(int) var playerPosX = 0
export(int) var playerPosY = 0

export(bool) var FireBowUnlocked = false
export(bool) var TechBowUnlocked = false
export(bool) var IceBowUnlocked = false

export(bool) var arrowPickedUp = false

signal health_changed(value);
signal no_health;
signal max_health_changed(value)


signal ammo_changed(value);
signal no_ammo;
signal max_ammo_changed(value)

func _ready():
	self.health = max_health;
	self.ammo = max_ammo;
	
func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health);

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")






func set_max_ammo(value):
	max_ammo = value
	self.ammo = min(ammo, max_ammo)
	emit_signal("max_ammo_changed", max_ammo);

func set_ammo(value):
	ammo = value
	emit_signal("ammo_changed", ammo)
	if ammo >= max_ammo:
		ammo = max_ammo
	if ammo <= 0:
		emit_signal("no_ammo")
