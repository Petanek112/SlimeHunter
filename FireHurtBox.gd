extends Area2D


func _on_EnemyFireHurtBox_area_entered(area):
	print("Calling to parent")
	get_parent().enemy_on_fire()
