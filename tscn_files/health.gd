extends HFlowContainer
@export var heart = preload("res://tscn_files/heartgui.tscn")
var num_hearts = 0
# Called when the node enters the scene tree for the first time.


func set_health(health):
	if num_hearts != 0:
		reset()
	for i in range(health):
		add_heart()

func delete_heart():
	if num_hearts > 0:
		var deleted_heart = get_child(num_hearts - 1)
		deleted_heart.delete()
		num_hearts -= 1

func add_heart():
	var new_heart = heart.instantiate()
	add_child(new_heart)
	num_hearts += 1
func reset():
	num_hearts = 0
	for i in get_children():
		remove_child(i)
		i.queue_free()
	pass
