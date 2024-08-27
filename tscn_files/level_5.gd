extends "res://tscn_files/level_2.gd"
@onready var player = $Player
var snowball = preload("res://tscn_files/snowball.tscn")
var bear = preload("res://tscn_files/bear.tscn")
var new_bear = bear.instantiate()
var num_minibosses = 4

func _on_stop_area_entered(area):
	$Camera2D.set_process(false)
	$stop_timer.start()
	$stop/CollisionShape2D.set_deferred("disabled", true)
	pass


func _on_snowball_timer_timeout():
	spawn_snowballs(Vector2(player.position.x, 0))
	pass # Replace with function body.
	
func spawn_snowballs(position):
	var new_snowball = snowball.instantiate()
	new_snowball.position = position
	new_snowball.direction = Vector2(0, 1)
	add_child.call_deferred(new_snowball)
	
func _on_stop_timer_timeout():
	$Camera2D.set_process(true)

func _on_spawn_bear_area_entered(area):
	$snowball_timer.stop()
	spawn_bear()
	pass # Replace with function body.

func spawn_bear():
	new_bear.position = Vector2(Global.screen_bounds[0], y_position + 20)
	add_child.call_deferred(new_bear)
	$snow_animation.speed_scale = 2

func _on_slow_bear_area_entered(area):
	new_bear.stop()
	Global.checkpoint_reached = true
	$snow_animation.speed_scale = 0.5
	var fade_out = get_tree().create_tween()
	fade_out.tween_property($Music, "volume_db", -80, 2)
	fade_out.tween_property($Music, "playing", false, 0)
	pass # Replace with function body.


func _on_start_snowballs_area_entered(area):
	$snowball_timer.start()
	pass # Replace with function body.
	
func _on_stop_2_area_entered(area):
	$Camera2D.set_process(false)
	$stop_timer.start(10)


func _on_spawn_enemies_area_entered(area):
	$mobtimer.start(4)
	spawn = mob_scene
	pass # Replace with function body.
func _on_mobtimer_timeout():
	mob_spawn(Vector2(Global.screen_bounds[1], y_position), 1, spawn)


func _on_mob_timer_stop_area_entered(area):
	$mobtimer.stop()
	pass # Replace with function body.

func _on_miniboss_death():
	num_minibosses -= 1
	if num_minibosses == 0:
		$stop/CollisionShape2D.set_deferred("disabled", true)
		if !$Camera2D.is_processing():
			$Camera2D.set_process(true)

func start_snow():
	$snow_animation.play("snow")


func _on_start_boss_music_area_entered(area):
	$Camera2D.camera_speed = 200
	$Music.stream = check_point_music
	$Music.volume_db = -3
	var fade_snow = get_tree().create_tween()
	fade_snow.tween_property($ParallaxBackground, "visible", false, 2)
	pass # Replace with function body.


func _on_final_boss_boss_appeared():
	pass # Replace with function body.


func _on_boss_stop_area_entered(area):
	$Music.play()
	$Camera2D.set_process(false)
	$boss_stop/CollisionShape2D.set_deferred("disabled", true)
	$HUD/boss_health.set_health(21)
	pass # Replace with function body.


func _on_boss_stop_2_area_entered(area):
	$snowball_timer.start(4)
	$Camera2D.set_process(false)
	$boss_stop2/CollisionShape2D.set_deferred("disabled", true)
	pass # Replace with function body.


func _on_boss_stop_3_area_entered(area):
	$Camera2D.set_process(false)
	$snowball_timer.start(4)
	pass # Replace with function body.


func _on_final_boss_defeated():
	$Camera2D.set_process(true)
	pass # Replace with function body.


func _on_stop_player_area_entered(area):
	$stop_player/CollisionShape2D.set_deferred("disabled",true)
	player.set_process(false)
	player.set_process_input(false)
	$Player/AnimationPlayer.play("RESET")
	await get_tree().create_timer(2).timeout
	player.set_process(true)
	player.set_process_input(true)
	pass # Replace with function body.


func _on_stop_player_2_area_entered(area):
	$Player/AnimationPlayer.play("RESET")
	$stop_player2/CollisionShape2D.set_deferred("disabled",true)
	player.set_process(false)
	player.set_process_input(false)
	await get_tree().create_timer(2).timeout
	player.set_process(true)
	player.set_process_input(true)
	pass # Replace with function body.


func _on_stop_player_3_area_entered(area):
	$snowball_timer.stop()
	$Player/AnimationPlayer.play("RESET")
	$stop_player3/CollisionShape2D.set_deferred("disabled",true)
	player.set_process(false)
	player.set_process_input(false)
	await get_tree().create_timer(2).timeout
	player.set_process(true)
	player.set_process_input(true)
	pass # Replace with function body.


func _on_final_boss_hit():
	$HUD/boss_health.delete_heart()
	pass # Replace with function body.

func _on_final_boss_shoot_beam(item, position, direction):
	var beam = item.instantiate()
	beam.position = position
	beam.direction = direction/abs(direction)
	add_child.call_deferred(beam)
	pass # Replace with function body.

func stop_snowballs():
	$snowball_timer.stop()
