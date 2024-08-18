extends "res://tscn_files/ninja.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D/AnimationPlayer.play("hanging")
	position.y = 150
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Sprite2D/AnimationPlayer.current_animation == "falling":
		position.y += 800*delta
	pass

func _on_playerdetection_area_entered(area):
	if area == get_node("/root/Node2D/Player") or area == get_node("/root/Node2D/Player/shield"):
		$Sprite2D/AnimationPlayer.play("falling")

func _on_visible_on_screen_notifier_2d_screen_entered():
	pass
