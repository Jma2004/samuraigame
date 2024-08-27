extends Area2D


func _on_area_entered(area):
	if area == get_node("/root/Node2D/Player") or area == get_node("/root/Node2D/Player/shield"):
		Global.player_health += 5
		get_node("/root/Node2D/HUD/health").set_health(Global.player_health)
		queue_free()
	pass # Replace with function body.
