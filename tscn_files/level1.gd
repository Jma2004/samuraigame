extends Node2D
@export var mob_scene: PackedScene
@export var boss_scene: PackedScene
var bounds
var kills = 0
@export var y_position = 471
var num_enemies = 0
var speedscale = 1
signal game_start
signal boss_spawn
signal level_completed
@export var next_level = 2
@export var win_condition := 20
@export var player_start_position = Vector2(571, y_position)
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.ground = y_position
	start_screen()
	bounds = [get_viewport_rect().end.x, 0]
	$next_button.hide()
	$next_button.disabled = true
	MusicPlayer.stream = MusicPlayer.music[Global.level]
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mobtimer_timeout():
	if num_enemies%5 == 0 and num_enemies > 0: #every 5 enemies spawned, increase the speed
		speedscale += 0.1
		if $mobtimer.wait_time > 1:
			$mobtimer.wait_time -= 0.2
		if kills > 20 and $bosstimer.wait_time > 1: #spawn boss every 5 enemies spawned
			$bosstimer.wait_time -= 0.1
		spawn_boss(Vector2(bounds[0], y_position))
		if kills > 5:
			spawn_boss(Vector2(bounds[1], y_position))
			num_enemies += 1
	else:
		mob_spawn(Vector2(Global.screen_bounds[randi_range(0, 1)], y_position), speedscale, mob_scene)
	num_enemies += 1
	pass # Replace with function body.
	
func mob_spawn(position, speedscale, mob_scene):
	var mob = mob_scene.instantiate()
	mob.position = position
	mob.speedscale = speedscale
	if (mob.position.x == bounds[0]):
		mob.scale.x = -1
	add_child(mob)
	mob.enemydeath.connect(_on_enemydeath)
	pass
	
func spawn_boss(position):
	if num_enemies >= 15:
		$bosstimer.start()
	$mobtimer.stop()
	var boss = boss_scene.instantiate()
	boss.position = position
	if position.x == bounds[0]:
		boss.velocity = -1
	add_child(boss)
	boss.boss_death.connect(_on_bossdeath)
	
func _on_bossdeath():
	kills += 1
	if kills >= 30:
		$HUD/Message.text = "You are too good\nYou should probably stop"
	elif kills > 25:
		$HUD/Message.text = "You're Amazing!"
	$HUD/Score.text = "Score: " + str(kills)
	if !$bosstimer.is_stopped():
		$bosstimer.stop()
	if $mobtimer.is_stopped():
		$mobtimer.start()
	if kills == win_condition && Global.player_health != 0:
		level_completed.emit()
	pass
func _on_enemydeath():
	kills += 1 
	$HUD/Score.text = "Score: " + str(kills)
	if kills >= 30:
		$HUD/Message.text = "You are too good\nYou should probably stop"
	elif kills > 20:
		$HUD/Message.text = "You're Amazing!"
	if kills == win_condition && Global.player_health != 0:
		level_completed.emit()
	

func _on_game_start():
	get_tree().paused = false
	$Player.set_process(true)
	$Player.set_process_input(true)
	$HUD.game_playing()
	$mobtimer.start()
	disconnect("game_start", _on_game_start)
	MusicPlayer.play()
	pass # Replace with function body.


func _on_boss_spawn():
	$mobtimer.stop()
	spawn_boss(Vector2(bounds[1], y_position))
	if kills >= 10:
		spawn_boss(Vector2(bounds[0], y_position))
	pass # Replace with function body.


func _on_player_is_dead():
	Global.player_points += kills
	$HUD/Message.text = "Game Over\n You defeated " + str(kills) + " enemies\n"
	if kills >= 30:
		$HUD/Message.text += "You are too good\nYou should probably stop"
	elif kills >= 20:
		$HUD/Message.text += "You're Amazing!"
	elif kills >= 15:
		$HUD/Message.text += "You're pretty good"
	elif kills >= 10:
		$HUD/Message.text += "Not bad."
	elif kills < 5:
		$HUD/Message.text += "You Blow."
	$HUD.game_over()
	$mobtimer.stop()
	$game_over.start()
	$next_button.disabled = true
	pass # Replace with function body.

	
func start_screen():
	$HUD.start_message($HUD.start_text)
	get_tree().call_group("enemy", "queue_free")
	$Player/AnimationPlayer.play("RESET")
	$Player.position = player_start_position
	$Player.velocity = Vector2.ZERO
	$mobtimer.stop()
	if !game_start.is_connected(_on_game_start):
		game_start.connect(_on_game_start)
	not_playing()

func _on_game_over_timeout():
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



