extends Panel



func delete():
	$AnimationPlayer.play("break_heart")
	await $AnimationPlayer.animation_finished
	queue_free()
