extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$next_button.next_scene = "res://tscn_files/level_" + str(Global.level) + ".tscn"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#display player variables
	$health.text = "Health: " + str(Global.player_health)
	$lives.text = "Lives: " + str(Global.player_lives)
	$shield.text = "Shield: " + str(Global.player_shield)
	$speed.text = "Speed: " + str(Global.player_speed)
	$points.text = "Points: " + str(Global.player_points)
	
	#disable buttons if maximum is reached
	if Global.player_health >= 7 or Global.player_points < 5:
		$add_health.disabled = true
	if Global.player_shield >= 10 or Global.player_points < 10:
		$add_shield.disabled = true
	if Global.player_speed >= 5 or Global.player_points < 5:
		$add_speed.disabled = true
	if Global.player_lives >= 5 or Global.player_points < 20:
		$add_lives.disabled = true
	pass


func _on_add_health_pressed():
	Global.player_health += 1
	Global.player_points -= 5
	pass # Replace with function body.



func _on_add_speed_pressed():
	Global.player_speed += 1
	Global.player_points -= 5
	pass # Replace with function body.


func _on_add_shield_pressed():
	Global.player_shield += 1
	Global.player_points -= 10
	pass # Replace with function body.


func _on_add_lives_pressed():
	Global.player_lives += 1
	Global.player_points -= 20
	pass # Replace with function body.
