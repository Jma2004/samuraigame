extends "res://tscn_files/level_3.gd"




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	MusicPlayer.stop()
	pass


func _on_ninja_enemydeath():
	level_completed.emit()
	pass # Replace with function body.



func _on_ninja_area_entered(area):
	$Boss_health.text = "Boss Health: " + str($ninja.health - 1)
	pass # Replace with function body.



