extends Area2D

var playerPresent = null 


func can_see_player():
	return playerPresent != null;

func _on_PlayerDetectionZone_body_entered(body):
	playerPresent = body


func _on_PlayerDetectionZone_body_exited(body):
	playerPresent = null
