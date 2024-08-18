extends Node2D
var health_points = 5
var speed_points = 5
var shield_points = 10
var lives_points = 20
# Called when the node enters the scene tree for the first time.
func _ready():
	$slow_down.hide()
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
	if Global.player_points <  health_points:
		$add_health.disabled = true
	if Global.player_shield >= 10 or Global.player_points < shield_points:
		$add_shield.disabled = true
	if Global.player_speed >= 5 or Global.player_points < speed_points:
		$add_speed.disabled = true
	if Global.player_lives >= 5 or Global.player_points < lives_points:
		$add_lives.disabled = true
	if Global.player_points < speed_points:
		$slow_down.disabled = true
	pass


func _on_add_health_pressed():
	Global.player_health += 1
	Global.player_points -= 5
	pass # Replace with function body.



func _on_add_speed_pressed():
	Global.player_speed += 1
	Global.player_points -= 5
	if Global.player_speed == 5:
		$slow_down.disabled = false
		$slow_down.show()
		$add_speed.hide()
	pass # Replace with function body.


func _on_add_shield_pressed():
	Global.player_shield += 1
	Global.player_points -= 10
	pass # Replace with function body.


func _on_add_lives_pressed():
	Global.player_lives += 1
	Global.player_points -= 20
	pass # Replace with function body.


func _on_slow_down_pressed():
	Global.player_speed -= 1
	Global.player_points -= 5
	if Global.player_speed == 0:
		$add_speed.disabled = false
		$add_speed.show()
		$slow_down.hide()
	pass # Replace with function body.
