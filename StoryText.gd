extends Control

onready var text = $Label
onready var tween = $Tween

var textArray = [
	"Oh God, how did I get here? The last thing I remember is jumping on some wooden cart.",
	"Maybe I should stop drinking anything that looks like booze",
	"And why are here slimes everywhere?",
	"I remember that my father used to experiment with some potions somewhere around here"
]
var textProgress = 0
var textFinished = false

# Called when the node enters the scene tree for the first time.
func _ready():
	start_monologue()
	

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		start_monologue()

func no_monologue():
	text.text = str("")

func start_monologue():
	if textProgress < textArray.size():
		text.text = textArray[textProgress]
		text.percent_visible = 0
		tween.interpolate_property(text,"percent_visible", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	else:
		queue_free()
	textProgress += 1
