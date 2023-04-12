extends Control


@onready var ExitCredits = %ExitCredits

func _ready():
	ExitCredits.pressed.connect(_on_ExitCredits_pressed)
	
func _on_ExitCredits_pressed():
	get_tree().change_scene_to_file("res://UI/main_ui.tscn")
	
