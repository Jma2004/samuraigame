extends CanvasLayer
var health = 3
signal start_game
@export var start_text := "start"
@export var win_text := "win"
# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$Score.text = "Score: 0"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Health.text = "HEALTH: " + str(Global.player_health)
	$Lives.text = "LIVES: " + str(Global.player_lives)
	pass
func start_message(start_text):
	$Message.text = start_text + "\nPress Start or Enter to Begin"
	$Message.show()
	$Health.hide()
	$Score.hide()
	$Controls.show()
	$Button.show()
	$Lives.hide()
	$pause_button.hide()
	pass
func game_over():
	$Message.show()
	$Score.hide()
	$Health.hide()
	$Lives.hide()
	$pause_button.hide()
func win_message(win_text):
	$Message.text = win_text + "\nPress Enter or Next to Continue"
	$Message.show()
func game_playing():
	$Message.hide()
	$Score.show()
	$Health.show()
	$Button.hide()
	$Controls.hide()
	$Lives.show()
	$pause_button.show()
	
func _on_controls_pressed():
	$Message.text = "USE ARROW KEYS TO MOVE\n WASD to attack\n SPACE to jump\n MOBILE:SWIPE to ATTACK and TAP to Move"
	$Message.show()
	$Health.hide()
	pass # Replace with function body.


func _on_button_pressed():
	start_game.emit()
	pass # Replace with function body.


func _on_pause_button_toggled(button_pressed):
	get_tree().paused = not get_tree().paused
	pass # Replace with function body.
