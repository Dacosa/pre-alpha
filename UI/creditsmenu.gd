extends Control


@onready var ExitCredits = %ExitCredits

func _ready():
	ExitCredits.pressed.connect(_on_ExitCredits_pressed)
	
func _on_ExitCredits_pressed():
	self.hide()
	get_parent().main_menu.show()
	get_parent().audio_stream_player.bus = "Master"
	
