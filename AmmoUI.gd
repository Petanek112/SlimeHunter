extends Control

var ammo = 4 setget set_ammo
var max_ammo = 4 setget set_max_ammo

onready var AmmoUIFull = $AmmoUIFull
onready var AmmoUIFullFire = $AmmoUIFullFire
onready var AmmoUIFullTech = $AmmoUIFullTech
onready var AmmoUIFullIce = $AmmoUIFullIce
onready var AmmoUIEmpty = $AmmoUIEmpty

func set_ammo(value):
	ammo = clamp(value, 0, max_ammo)
	
func _process(_delta):
	if AmmoUIFull != null:
		if get_tree().get_root().get_node("World/YSort/Player").element == 0:
			AmmoUIFull.show()
			AmmoUIFull.rect_size.x = ammo * 11
		else:
			AmmoUIFull.hide()
			
		if get_tree().get_root().get_node("World/YSort/Player").element == 1:
			AmmoUIFullFire.show()
			AmmoUIFullFire.rect_size.x = ammo * 11
		else:
			AmmoUIFullFire.hide()
			
		if get_tree().get_root().get_node("World/YSort/Player").element == 2:
			AmmoUIFullTech.show()
			AmmoUIFullTech.rect_size.x = ammo * 11
		else:
			AmmoUIFullTech.hide()
			
		if get_tree().get_root().get_node("World/YSort/Player").element == 3:
			AmmoUIFullIce.show()
			AmmoUIFullIce.rect_size.x = ammo * 11
		else:
			AmmoUIFullIce.hide()
			
func set_max_ammo(value):
	max_ammo = max(value, 1)
	self.ammo = min(ammo, max_ammo);
	if AmmoUIEmpty != null:
		AmmoUIEmpty.rect_size.x = max_ammo * 11
		
func _ready():
	self.max_ammo = PlayerStats.max_ammo
	self.ammo = PlayerStats.ammo
	PlayerStats.connect("ammo_changed", self, "set_ammo")
	PlayerStats.connect("max_ammo_changed", self, "set_max_ammo")
