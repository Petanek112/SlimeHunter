extends Control

onready var text = $Label

export var Type1 = false
export var Type2 = false
export var Type3 = false
export var Type4 = false
export var Type5 = false
export var Type6 = false
export var Type7 = false
export var Type8 = false

var stats = PlayerStats
var flowerNumber = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stats.flowerType1 != flowerNumber and Type1 == true:
		print("Number Changed")
		flowerNumber = stats.flowerType1
		text.text = (" " + str(flowerNumber))
	if stats.flowerType2 != flowerNumber and Type2 == true:
		flowerNumber = stats.flowerType2
		text.text = (" " + str(flowerNumber))
	if stats.flowerType3 != flowerNumber and Type3 == true:
		flowerNumber = stats.flowerType3
		text.text = (" " + str(flowerNumber))
	if stats.flowerType4 != flowerNumber and Type4 == true:
		flowerNumber = stats.flowerType4
		text.text = (" " + str(flowerNumber))
	if stats.flowerType5 != flowerNumber and Type5 == true:
		flowerNumber = stats.flowerType5
		text.text = (" " + str(flowerNumber))
	if stats.flowerType6 != flowerNumber and Type6 == true:
		flowerNumber = stats.flowerType6
		text.text = (" " + str(flowerNumber))
	if stats.flowerType7 != flowerNumber and Type7 == true:
		flowerNumber = stats.flowerType7
		text.text = (" " + str(flowerNumber))
	if stats.flowerType8 != flowerNumber and Type8 == true:
		flowerNumber = stats.flowerType8
		text.text = (" " + str(flowerNumber))

