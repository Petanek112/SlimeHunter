extends Timer



func _on_BurningTimer_timeout():
	get_parent().enemy_back_to_normal()
