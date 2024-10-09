extends Node2D
var enemy1 = preload("res://tscn_files/base_enemy.tscn")
var boss1 = preload("res://tscn_files/boss_1.tscn")
var enemy2 = preload("res://tscn_files/enemy_2.tscn")
var enemy3 = preload("res://tscn_files/enemy_3.tscn")
var red_enemy = preload("res://tscn_files/red_enemy.tscn")
var old_man = preload("res://tscn_files/old_man.tscn")
var final_boss = preload("res://tscn_files/final_boss.tscn")
var ninja = preload("res://tscn_files/ninja.tscn")
var whip_man = preload("res://tscn_files/whip_man.tscn")
var enemies = [enemy1, boss1, enemy2, enemy3, ninja, whip_man, red_enemy]
var kills = 0
var old_man_instance = old_man.instantiate()
var final_boss_instance = final_boss.instantiate()
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	$HUD.start_message("Defeat the ghosts of your past enemies")
	Global.ground = 446
	pass # Replace with function body.


func _on_timer_timeout():
	if $Timer.wait_time > 1:
		$Timer.wait_time -= 0.1
	var mob = enemies.pick_random()
	var instance = mob.instantiate()
	instance.position = Vector2(Global.screen_bounds.pick_random(), 446)
	instance.enemydeath.connect(on_enemy_death)
	$TileMap.add_child(instance)
	pass # Replace with function body.


func _on_ninja_throw_bomb(item, location):
	var bomb = item.instantiate()
	add_child.call_deferred(bomb)
	bomb.position = location
	pass # Replace with function body.
	
func _on_ninja_throw_shuriken(shuriken, direction, location):
	var spawned_star = shuriken.instantiate()
	add_child.call_deferred(spawned_star)
	spawned_star.direction = direction
	spawned_star.position = location
	pass # Replace with function body.
	
func _on_final_boss_shoot_beam(item, position, direction):
	var beam = item.instantiate()
	beam.position = position
	beam.direction = direction/abs(direction)
	add_child.call_deferred(beam)
	pass # Replace with function body.


func _on_hud_start_game():
	get_tree().paused = false
	$HUD.game_playing()
	spawn_old_man()
	spawn_final_boss()
	$finalboss_timer.start()
	pass # Replace with function body.


func _on_player_is_dead():
	Global.level = 7
	Global.player_points += kills
	$Timer.stop()
	$oldman_timer.stop()
	$finalboss_timer.stop()
	var fade_out = create_tween()
	fade_out.tween_property(self, "modulate", Color(0,0,0,1), 3)
	fade_out.parallel().tween_property($TileMap, "modulate", Color(0,0,0,1), 3)
	fade_out.parallel().tween_property($Music, "volume_db", -80, 3)
	await get_tree().create_timer(3).timeout
	Global.player_died.emit()
	pass # Replace with function body.

func spawn_old_man():
	old_man_instance.attacking = true
	old_man_instance.throw_shuriken.connect(_on_ninja_throw_shuriken)
	old_man_instance.position = Vector2(200 ,446)
	old_man_instance.enemydeath.connect(on_enemy_death)
	old_man_instance.enemydeath.connect(on_oldman_death)
	$TileMap.add_child(old_man_instance)
	pass

func spawn_final_boss():
	final_boss_instance.shoot_beam.connect(_on_final_boss_shoot_beam)
	final_boss_instance.position = Vector2(900 ,446)
	final_boss_instance.final_phase = true
	final_boss_instance.health = 21
	final_boss_instance.died.connect(on_enemy_death)
	final_boss_instance.died.connect(on_finalboss_death)
	$TileMap.add_child(final_boss_instance)
	pass

func on_oldman_death():
	old_man_instance.queue_free()
	
func on_finalboss_death():
	final_boss_instance.queue_free()
	
func on_enemy_death():
	kills += 1
	$HUD/Score.text = "Score: " + str(kills)
func _on_music_finished():
	$Music.play()
	pass # Replace with function body.


