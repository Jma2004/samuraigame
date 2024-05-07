extends Node2D
@export var mob_scene: PackedScene
@export var boss_scene: PackedScene
var bounds
var kills = 0
var y_position = 471
var num_enemies = 0
var speedscale = 1
signal game_start
signal boss_spawn
# Called when the node enters the scene tree for the first time.
func _ready():
	start_screen()
	bounds = [get_viewport_rect().end.x, 0]
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mobtimer_timeout():
	if num_enemies%5 == 0 and num_enemies > 0:
		speedscale += 0.1
		if $mobtimer.wait_time > 1:
			$mobtimer.wait_time -= 0.5
		if kills > 20 and $bosstimer.wait_time > 1:
			$bosstimer.wait_time -= 2
		spawn_boss(Vector2(bounds[0], y_position))
		if kills > 5:
			spawn_boss(Vector2(bounds[1], y_position))
			num_enemies += 1
	else:
		mob_spawn(Vector2(bounds[randi_range(0, 1)], y_position), speedscale)
	num_enemies += 1
	pass # Replace with function body.
func mob_spawn(position, speedscale):
	var attackstring = ["upslash", "downslash", "sideslash"]
	var mob = mob_scene.instantiate()
	mob.position = position
	mob.speedscale = speedscale
	mob.attackstring = attackstring[randi_range(0, 2)]
	if (mob.position.x == bounds[0]):
		mob.scale.x = -1
	add_child(mob)
	mob.enemydeath.connect(_on_enemydeath)

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
	$HUD/Score.text = "Score: " + str(kills)
	if !$bosstimer.is_stopped():
		$bosstimer.stop()
	if $mobtimer.is_stopped():
		$mobtimer.start()
	pass
func _on_enemydeath():
	kills += 1 
	$HUD/Score.text = "Score: " + str(kills)
	

func _on_game_start():
	get_tree().paused = false
	$Player.set_process(true)
	$Player.set_process_input(true)
	$HUD.game_playing()
	$mobtimer.start()
	$Music.play()
	disconnect("game_start", _on_game_start)
	pass # Replace with function body.


func _on_boss_spawn():
	$mobtimer.stop()
	spawn_boss(Vector2(bounds[1], y_position))
	if kills >= 10:
		spawn_boss(Vector2(bounds[0], y_position))
	pass # Replace with function body.


func _on_player_area_entered(area):
	$HUD/Health.text = "HEALTH: " + str($Player.health - 1)
	pass # Replace with function body.


func _on_player_is_dead():
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
	$Music.stop()
	pass # Replace with function body.

	
func start_screen():
	$HUD.start_message()
	$HUD/Health.text = "HEALTH: 3"
	get_tree().call_group("enemy", "queue_free")
	$Player/AnimationPlayer.play("RESET")
	$Player.position = Vector2(get_viewport_rect().get_center().x, y_position)
	$Player.health = 3
	$Player.velocity = Vector2.ZERO
	$mobtimer.stop()
	if !game_start.is_connected(_on_game_start):
		game_start.connect(_on_game_start)
	not_playing()

func _on_game_over_timeout():
	get_tree().reload_current_scene()
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
