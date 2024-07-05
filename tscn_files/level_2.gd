extends "res://tscn_files/level1.gd"
@export var mob2_scene: PackedScene
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mobtimer_timeout():
	if num_enemies < 5:
		mob_spawn(Vector2(Global.screen_bounds[randi_range(0,1)], y_position), 1, mob_scene)
	elif num_enemies >= 5 && num_enemies < 10:
		mob_spawn(Vector2(Global.screen_bounds[randi_range(0,1)], y_position), 1, mob2_scene)
	elif num_enemies >= 10 and num_enemies < 15:
		mob_spawn(Vector2(Global.screen_bounds[randi_range(0,1)], y_position), 1, boss_scene)
	elif num_enemies >= 15:
		var enemy_array = [mob_scene, mob2_scene, boss_scene]
		mob_spawn(Vector2(Global.screen_bounds[randi_range(0,1)], y_position), speedscale, enemy_array.pick_random())
		if speedscale < 2:
			speedscale += 0.01
		if $mobtimer.wait_time > 2:
			$mobtimer.wait_time -= 0.2
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
	mob.stunplayer.connect(get_node("Player")._on_stunplayer)
	pass
