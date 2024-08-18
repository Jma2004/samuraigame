extends "res://tscn_files/level1.gd"
@export var mob2_scene: PackedScene
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mobtimer_timeout():
	mob_spawn(Vector2(Global.screen_bounds.pick_random(), y_position), 1, spawn)
	pass # Replace with function body.

func mob_spawn(position, speedscale, mob_scene):
	var mob = mob_scene.instantiate() 
	mob.position = position
	mob.speedscale = speedscale
	if (mob.position.x == bounds[0]):
		mob.scale.x = -1
	add_child(mob)
	mob.enemydeath.connect(_on_enemydeath)
	mob.stunplayer.connect(get_node("Player")._on_stunplayer)
	pass

func _on_stop_area_entered(area):
	$stop/CollisionShape2D.set_deferred("disabled", true)
	$Camera2D.set_process(false)
	spawn = mob_scene
	$mobtimer.start(3)
	$stop_timer.start(10)
	Global.screen_bounds = [10350, 11430]
	pass
	
func _on_stop_2_area_entered(area):
	$stop/CollisionShape2D.set_deferred("disabled", true)
	$Camera2D.set_process(false)
	$stop_timer.start(15)
	pass


func _on_whip_man_death():
	$stop_timer.timeout.emit()
	$stop_timer.stop()
	spawn = mob2_scene
	$mobtimer.start(5)
	pass # Replace with function body.

func spawn_boss(position):
	var boss = boss_scene.instantiate()
	boss.position = position
	boss.scale.x = -1
	add_child(boss)
	boss.enemydeath.connect(_on_bossdeath)
	num_bosses += 1
	
func _on_stop_3_area_entered(area):
	$mobtimer.stop()
	spawn = mob_scene
	
func _on_end_area_entered(area):
	$end/CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(1).timeout
	spawn_boss(Vector2(17500, y_position))
	await get_tree().create_timer(15).timeout
	level_completed.emit()
	pass # Replace with function body.
