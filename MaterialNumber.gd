extends RichTextLabel

var stats = PlayerStats



func _process(delta):
	set_text(" " + str(stats.slimeMat))
