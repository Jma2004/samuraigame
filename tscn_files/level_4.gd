extends "res://tscn_files/level_3.gd"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_screen():
	$boss_health.set_health(10)
	$HUD.start_message("It's too dangerous ahead. \nI cannot let you pass")
	$Player/AnimationPlayer.play("RESET")
	$Player.velocity = Vector2.ZERO
	$old_man.set_process(false)
	$boss_health.hide()
	if !game_start.is_connected(_on_game_start):
		game_start.connect(_on_game_start)
	not_playing()

func _on_game_start():
	get_tree().paused = false
	$Player.set_process(true)
	$Player.set_process_input(true)
	$HUD.game_playing()
	disconnect("game_start", _on_game_start)
	$old_man.set_process(true)
	$boss_health.show()
	pass # Replace with function body.

func _on_player_is_dead():
	Global.player_points += kills
	$HUD/Message.text = "You are not strong enough yet"
	$HUD.game_over()
	$game_over.start()
	$next_button.disabled = true
	pass # Replace with function body.


func _on_boss_hit():
	$boss_health.delete_heart()
	pass # Replace with function body.



func _on_level_completed():
	Global.player_points += 30
	$next_button.show()
	$next_button.disabled = false
	$HUD.win_message($HUD.win_text)
	Global.level = next_level
	pass # Replace with function body.



