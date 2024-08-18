extends Node2D
var jumping_ninja = preload("res://tscn_files/ninja.tscn")
var ninja = preload("res://tscn_files/ninja.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.screen_bounds = [0, 1152]
	Global.ground = 468
	Global.player_health = 30005
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ninja_throw_shuriken(shuriken, direction, location):
	var spawned_star = shuriken.instantiate()
	add_child.call_deferred(spawned_star)
	spawned_star.direction = direction
	spawned_star.position = location
	pass # Replace with function body.


func _on_timer_timeout():
	mob_spawn(Vector2(Global.screen_bounds[randi_range(0, 1)], Global.ground - 300), 1, jumping_ninja)
	pass # Replace with function body.

func ninja_spawn(position, speedscale, mob_scene):
	var mob = mob_scene.instantiate() 
	mob.position = position
	mob.speedscale = speedscale
	if (mob.position.x == Global.screen_bounds[1]):
		mob.scale.x = -1
	mob.throw_shuriken.connect(_on_ninja_throw_shuriken)
	add_child(mob)
	pass


func _on_ninja_throw_bomb(item, location):
	var bomb = item.instantiate()
	add_child.call_deferred(bomb)
	bomb.position = location
	pass # Replace with function body.
	
func mob_spawn(position, speedscale, mob_scene):
	var mob = mob_scene.instantiate() 
	mob.position = position
	mob.speedscale = speedscale
	if(mob.position.x == Global.screen_bounds[1]):
		mob.scale.x = -1
	add_child(mob)	
