extends Node2D
@export var mob_scene: PackedScene
@export var mob_scene_2: PackedScene
@export var boss_scene: PackedScene
var spawn
var bounds
var kills = 0
var end = false
@export var y_position = 471
@export var num_bosses = 0
var speedscale = 1
signal game_start
signal boss_spawn
signal level_completed
@export var next_level = 2
@export var player_start_position = Vector2(571, y_position)
@export var checkpoint_position:= 576
@export var check_point_music: AudioStreamMP3
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.ground = y_position
	start_screen()
	$next_button.hide()
	$next_button.disabled = true
	pass # Replace with function body.


func _on_mobtimer_timeout():
	mob_spawn(Vector2(Global.screen_bounds[randi_range(0, 1)], y_position), speedscale, spawn)
	pass # Replace with function body.
	
func mob_spawn(position, speedscale, mob_scene):
	var mob = mob_scene.instantiate()
	mob.position = position
	mob.speedscale = speedscale
	if (mob.position.x == Global.screen_bounds[0]):
		mob.scale.x = -1
	add_child(mob) 
	mob.enemydeath.connect(_on_enemydeath)
	pass
	
func spawn_boss(position):
	var boss = boss_scene.instantiate()
	boss.position = position
	if position.x == Global.screen_bounds[0]:
		boss.velocity = -1
	add_child.call_deferred(boss)
	boss.boss_death.connect(_on_bossdeath)
	num_bosses += 1
	
func _on_bossdeath():
	kills += 1
	$HUD/Score.text = "Score: " + str(kills)
	num_bosses -= 1
	if num_bosses == 0:
		level_completed.emit()
	pass
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


func _on_boss_spawn():
	$mobtimer.stop()
	spawn_boss(Vector2(Global.screen_bounds[1], y_position))
	if kills >= 10:
		spawn_boss(Vector2(bounds[0], y_position))
	pass # Replace with function body.


func _on_player_is_dead():
	Global.player_points += kills
	$HUD/Message.text = "Game Over\n You defeated " + str(kills) + " enemies\n"
	$HUD.game_over()
	$mobtimer.stop()
	$game_over.start()
	$next_button.disabled = true
	pass # Replace with function body.

	
func start_screen():
	$HUD.start_message($HUD.start_text)
	$Player/AnimationPlayer.play("RESET")
	$mobtimer.stop()
	if !game_start.is_connected(_on_game_start):
		game_start.connect(_on_game_start)
	if !Global.checkpoint_reached:
		$Player.position = player_start_position
	else:
		$Player.position = Vector2(checkpoint_position, y_position)
		$Camera2D.position.x = checkpoint_position - 575
		Global.screen_bounds = [checkpoint_position - 576, checkpoint_position + 576]
		$Music.stop()
	not_playing()

func _on_game_over_timeout():
	get_tree().call_group("enemy", "queue_free")
	Global.player_died.emit()
	pass # Replace with function body.

func not_playing():
	get_tree().paused = true
	pass
	
func _on_hud_start_game():
	game_start.emit()
	pass # Replace with function body.


func _on_bosstimer_timeout():
	$mobtimer.start()
	pass # Replace with function body.


func _on_next_button_pressed():
	Global.player_points += kills
	if Global.player_health <= 0:
		Global.player_health = 1
	pass # Replace with function body.


func _on_level_completed():
	$next_button.show()
	$next_button.disabled = false
	$HUD.win_message($HUD.win_text)
	Global.level = next_level
	pass # Replace with function body.


func _on_stop_timer_timeout():
	$stop_timer.stop()
	$mobtimer.stop()
	$Camera2D.set_process(true)
	pass # Replace with function body.


func _on_stop_area_entered(area):
	$stop/CollisionShape2D.set_deferred("disabled", true)
	spawn = mob_scene
	$Camera2D.set_process(false)
	$mobtimer.start()
	$stop_timer.start()
	Global.screen_bounds = [7395, 8535]
	pass # Replace with function body.


func _on_stop_2_area_entered(area):
	$stop2/CollisionShape2D.set_deferred("disabled", true)
	spawn = mob_scene_2
	$Camera2D.set_process(false)
	$mobtimer.wait_time = 3
	$mobtimer.start()
	$stop_timer.start()
	Global.screen_bounds = [10410, 11540]
	pass # Replace with function body.


func _on_stop_3_area_entered(area):
	$stop3/CollisionShape2D.set_deferred("disabled", true)
	Global.screen_bounds = [15010, 16140]
	$Camera2D.set_process(false)
	spawn = mob_scene
	await $Boss2.enemydeath
	$end_timer.start()
	end = true
	spawn_boss(Vector2(Global.screen_bounds[0], y_position))
	spawn_boss(Vector2(Global.screen_bounds[1], y_position))
	pass # Replace with function body.


func _on_end_timer_timeout():
	level_completed.emit()
	pass # Replace with function body.

func _on_music_finished():
	$Music.play()
	pass # Replace with function body.
