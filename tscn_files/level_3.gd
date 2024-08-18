extends "res://tscn_files/level_2.gd"
var camera_speed = 85
var camera_acceleration = 0
var ninja_spawn_points
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Global.screen_bounds = [$Camera2D.get_screen_center_position().x - 576,
	$Camera2D.get_screen_center_position().x + 576]
	ninja_spawn_points = [$Camera2D.get_screen_center_position().x - 580, $Camera2D.get_screen_center_position().x + 580]
	camera_speed += camera_acceleration*delta
	$Camera2D.position.x += camera_speed*delta
	pass

func _on_mobtimer_timeout():
	ninja_spawn(Vector2(Global.screen_bounds[randi_range(0,1)], y_position), 1, spawn)
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

func _on_game_start():
	get_tree().paused = false
	$Player.set_process(true)
	$Player.set_process_input(true)
	$HUD.game_playing()
	disconnect("game_start", _on_game_start)
	pass # Replace with function body.


func _on_jumping_ninja_timer_timeout():
	ninja_spawn(Vector2(ninja_spawn_points.pick_random(), y_position - 400), 1, mob2_scene)
	pass # Replace with function body.


func _on_4882_area_entered(area):
	camera_speed = 150
	spawn = mob2_scene
	$mobtimer.start(4)
	pass # Replace with function body.


func _on_9982_area_entered(area):
	camera_speed = 210
	pass # Replace with function body.


func _on_23880_area_entered(area):
	camera_acceleration = 90/4
	$large_ninja_timer.start()
	pass # Replace with function body.


func _on_24200_area_entered(area):
	camera_acceleration = 0
	camera_speed = 300
	$large_ninja_timer.stop()
	pass # Replace with function body.


func _on_26800_area_entered(area):
	camera_acceleration = -30
	pass # Replace with function body.


func _on_27200_area_entered(area):
	camera_acceleration = 0
	camera_speed = 150
	$mobtimer.start(4)
	$jumping_ninja_timer.start(7)
	pass # Replace with function body.


func _on_36900_area_entered(area):
	camera_acceleration = 50
	$large_ninja_timer.start()
	pass # Replace with function body.


func _on_38250_area_entered(area):
	camera_acceleration = 0
	$large_ninja_timer.stop()
	pass # Replace with function body.


func _on_43000_area_entered(area):
	camera_speed = 150
	pass # Replace with function body.


func _on_48000_area_entered(area):
	camera_speed = 0
	level_completed.emit()
	pass # Replace with function body.


func _on_17000_area_entered(area):
	$mobtimer.stop()
	pass # Replace with function body.


func _on_large_ninja_timer_timeout():
	mob_spawn(Vector2(Global.screen_bounds[0], y_position), 2, mob_scene_2)
	pass # Replace with function body.


func _on_30500_area_entered(area):
	$jumping_ninja_timer.stop()
	$mobtimer.stop()
	pass # Replace with function body.



