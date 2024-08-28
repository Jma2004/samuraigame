extends Node2D
var end_song = preload("res://game_music/por um amor.mp3")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.screen_bounds = [100, 1042]
	get_tree().paused = true
	$HUD.start_message("Defeat the Challenger")
	pass # Replace with function body.


func _on_hud_start_game():
	$HUD/boss_health.set_health($challenger.health)
	get_tree().paused = false
	$HUD.game_playing()
	pass # Replace with function body.


func _on_challenger_hit():
	$HUD/boss_health.delete_heart()
	pass # Replace with function body.


func _on_player_is_dead():
	var game_over = create_tween()
	game_over.set_parallel(true)
	game_over.tween_property($Music, "volume_db", -80, 3)
	game_over.tween_property($TileMap, "modulate", Color(0.01,0.01,0.01), 3)
	game_over.tween_property($HUD, "visible", false, 3)
	game_over.tween_property($challenger, "modulate", Color(0.01,0.01,0.01), 3)
	game_over.set_parallel(false)
	game_over.tween_property($Player, "position", Vector2(576, 471), 3)
	game_over.tween_property($Music, "stream", end_song, 0)
	game_over.tween_property($Music, "volume_db", -3, 0)
	game_over.tween_property($Music, "playing", true, 0)
	game_over.tween_property($game_over, "visible", true, 0)
	await get_tree().create_timer(3).timeout
	$challenger.queue_free()
	pass # Replace with function body.


func _on_challenger_died():
	$game_over.text = "HOLY COW!!"
	var game_over = create_tween()
	game_over.set_parallel(true)
	game_over.tween_property($Music, "volume_db", -80, 3)
	game_over.tween_property($TileMap, "modulate", Color(0.01,0.01,0.01), 3)
	game_over.tween_property($challenger, "modulate", Color(0.01,0.01,0.01), 3)
	game_over.tween_property($HUD, "visible", false, 3)
	game_over.set_parallel(false)
	game_over.tween_property($Music, "stream", end_song, 0)
	game_over.tween_property($Music, "volume_db", -3, 0)
	game_over.tween_property($Music, "playing", true, 0)
	game_over.tween_property($game_over, "visible", true, 0)
	$challenger.queue_free()
	pass # Replace with function body.
