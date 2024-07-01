extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_old_man_throw_shuriken(item, direction, location):
	var spawned_star = item.instantiate()
	add_child.call_deferred(spawned_star)
	spawned_star.direction = direction
	spawned_star.position = location
	spawned_star.monitorable = false
	pass # Replace with function body.
