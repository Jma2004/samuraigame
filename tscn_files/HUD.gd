extends CanvasLayer
var health = 3
signal start_game
# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$Health.text = "HEALTH: " + str(health)
	$Score.text = "Score: 0"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func start_message():
	$Message.text = "DEFEAT THE BANDITS!\n Press Start or hit Enter to begin"
	$Message.show()
	$Health.hide()
	$Score.hide()
	$Controls.show()
	$Button.show()
	pass
func game_over():
	$Message.show()
	$Score.hide()
	$Health.hide()
func win_message():
	$Message.text = "YOU DEFEATED THE BANDITS!\n The village is saved! \nGOOD JOB!"
	$Message.show()
	$Health.hide()
func game_playing():
	$Message.hide()
	$Score.show()
	$Health.show()
	$Button.hide()
	$Controls.hide()

func _on_controls_pressed():
	$Message.text = "USE ARROW KEYS TO MOVE\n WASD to attack\n SPACE to jump\n MOBILE:SWIPE to ATTACK and TAP to Move"
	$Message.show()
	$Health.hide()
	pass # Replace with function body.


func _on_button_pressed():
	start_game.emit()
	pass # Replace with function body.
