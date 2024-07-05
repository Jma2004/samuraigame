extends "res://tscn_files/level_2.gd"
var camera_speed = 85 + 5*Global.player_speed
var ninja_spawn_points

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Global.screen_bounds = [$Camera2D.get_screen_center_position().x - 576,
	$Camera2D.get_screen_center_position().x + 576]
	ninja_spawn_points = [$Camera2D.get_screen_center_position().x - 580, $Camera2D.get_screen_center_position().x + 580]
	$Camera2D.position.x += camera_speed*delta
	pass

func _on_mobtimer_timeout():
	ninja_spawn(Vector2(Global.screen_bounds[randi_range(0,1)], y_position), 1, mob2_scene)
	pass

func ninja_spawn(position, speedscale, mob_scene):
	var mob = mob_scene.instantiate() 
	mob.position = position
	mob.speedscale = speedscale
	mob.enemydeath.connect(_on_enemydeath)
	mob.stunplayer.connect(get_node("Player")._on_stunplayer)
	mob.throw_shuriken.connect(_on_ninja_throw_shuriken)
	add_child(mob)
	pass
	
func _on_ninja_throw_shuriken(item, direction, location):
	var spawned_star = item.instantiate()
	add_child.call_deferred(spawned_star)
	spawned_star.direction = direction
	spawned_star.position = location
	pass # Replace with function body.

func _on_ninja_throw_bomb(item, location):
	var bomb = item.instantiate()
	add_child.call_deferred(bomb)
	bomb.position = location
	pass # Replace with function body.

func _on_enemydeath():
	kills += 1 
	$HUD/Score.text = "Score: " + str(kills)
	
func _on_area_2d_area_entered(area):
	level_completed.emit()
	camera_speed = 0
	pass # Replace with function body.


func _on_area_2d_3_area_entered(area):
	$mobtimer.start()
	pass # Replace with function body.

func _on_game_start():
	get_tree().paused = false
	$Player.set_process(true)
	$Player.set_process_input(true)
	$HUD.game_playing()
	disconnect("game_start", _on_game_start)
	MusicPlayer.play()
	pass # Replace with function body.


func _on_jumping_ninja_timer_timeout():
	ninja_spawn(Vector2(ninja_spawn_points.pick_random(), y_position - 400), 1, mob2_scene)
	pass # Replace with function body.


func _on_camera_speed_up_area_entered(area):
	camera_speed *= 2
	pass # Replace with function body.


func _on_jumping_ninja_start_area_entered(area):
	$jumping_ninja_timer.start()
	pass # Replace with function body.


func _on_end_of_forest_area_entered(area):
	$jumping_ninja_timer.stop()
	$mobtimer.stop()
	pass # Replace with function body.
