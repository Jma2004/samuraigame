extends Node2D
var health_points = 5
var speed_points = 5
var shield_points = 10
var lives_points = 20
# Called when the node enters the scene tree for the first time.
func _ready():
	$next_button.next_scene = "res://tscn_files/level_" + str(Global.level) + ".tscn"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#display player variables
	$health.text = "Health: " + str(Global.player_health)
	$shield.text = "Shield: " + str(Global.player_shield)
	$speed.text = "Speed: " + str(Global.player_speed)
	$points.text = "Points: " + str(Global.player_points)
	
	#disable buttons if maximum is reached
	if Global.player_points < health_points:
		$add_health.disabled = true
	if Global.player_shield >= 10 or Global.player_points < shield_points:
		$add_shield.disabled = true
	if Global.player_speed >= 5 or Global.player_points < speed_points:
		$add_speed.disabled = true
	else:
		$add_speed.disabled = false
	if Global.player_points < speed_points or Global.player_speed <= 0:
		$slow_down.disabled = true
	else:
		$slow_down.disabled = false
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



func _on_slow_down_pressed():
	Global.player_speed -= 1
	Global.player_points -= 5
	pass # Replace with function body.
