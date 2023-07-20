extends Control

@onready var Play = %Play
@onready var Credits = %Credits
@onready var Exit = %Exit


func _ready():
	Play.pressed.connect(_on_Play_pressed)
	Exit.pressed.connect(_on_Exit_pressed)
	Credits.pressed.connect(_on_Credits_pressed)
	

func _on_Play_pressed():
	self.hide()
	get_parent().mapsmenu.show()
	get_parent().audio_stream_player.bus = "filter"

func _on_Exit_pressed():
	get_parent().get_tree().quit()

func _on_Credits_pressed():
	self.hide()
	get_parent().creditsmenu.show()
	get_parent().audio_stream_player.bus = "filter"
