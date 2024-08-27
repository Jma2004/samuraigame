extends Area2D
@export var direction = Vector2(1, 0)
@export var speed = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += delta*direction*speed
	pass


func _on_visible_on_screen_notifier_2d_screen_entered():
	$AnimationPlayer.play("rolling")
	set_process(true)
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass # Replace with function body.


func _on_area_entered(area):
	$AnimationPlayer.play("broken")
	set_process(false)
	await $AnimationPlayer.animation_finished
	queue_free()
	pass # Replace with function body.
