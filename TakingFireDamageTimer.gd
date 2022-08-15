extends Timer


func _on_TakingFireDamageTimer_timeout():
	get_parent().take_fire_damage_delay()
