extends CanvasLayer
var health = 3
signal start_game
@export var start_text: String
@export var win_text: String
var music_player
# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$Score.text = "Score: 0"
	music_player = get_node("/root/Node2D/Music")
	get_node("/root/Node2D/Player").area_entered.connect(on_player_hit)
	$health.set_health(Global.player_health)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func start_message(start_text):
	$Message.text = start_text + "\nPress Start or Enter to Begin"
	$Message.show()
	$Controls.show()
	$Button.show()
	$pause_button.hide()
	pass
func game_over():
	$Message.show()
	$pause_button.hide()
func win_message(win_text):
	$Message.text = win_text + "\nPress Enter or Next to Continue"
	$Message.show()
func game_playing():
	$Message.hide()
	$Button.hide()
	$Controls.hide()
	$pause_button.show()
	
func _on_controls_pressed():
	$Message.text = "USE ARROW KEYS TO MOVE\n WASD to attack\n SPACE to jump\n MOBILE:SWIPE to ATTACK and TAP to Move"
	$Message.show()
	pass # Replace with function body.


func _on_button_pressed():
	start_game.emit()
	pass # Replace with function body.


func _on_pause_button_toggled(button_pressed):
	get_tree().paused = not get_tree().paused
	pass # Replace with function body.


func _on_music_button_toggled(button_pressed):
	if button_pressed:
		music_player.volume_db = -80
	else:
		music_player.volume_db = -10
	pass # Replace with function body.

func on_player_hit(area):
	if Global.player_health >= 0:
		$health.call_deferred("delete_heart")
