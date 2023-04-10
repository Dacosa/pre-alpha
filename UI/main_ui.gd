extends Control


@onready var Play = %Play
@onready var Credits = %Credits
@onready var Exit = %Exit


func _ready():
	Play.pressed.connect(_on_Play_pressed)
	Exit.pressed.connect(_on_Exit_pressed)
	Credits.pressed.connect(_on_Credits_pressed)

func _on_Play_pressed():
	get_tree().change_scene_to_file("res://UI/mapsmenu.tscn")

func _on_Exit_pressed():
	get_tree().quit()

func _on_Credits_pressed():
	get_tree().change_scene_to_file("res://UI/creditsmenu.tscn")
