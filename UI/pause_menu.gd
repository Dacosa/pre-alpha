extends Control


@onready var Return = %Return
@onready var Retry = %Retry
@onready var Main_menu = %"Main_menu"


func _ready():
	Return.pressed.connect(_on_Return_pressed)
	Retry.pressed.connect(_on_Retry_pressed)
	Main_menu.pressed.connect(_on_Main_menu_pressed)
	hide()

func _input(event):
	if event.is_action_pressed("Pause") or event.is_action_pressed("Pause2"):
		show()
		get_tree().paused = true

func _on_Return_pressed():
	hide()
	get_tree().paused = false

func _on_Retry_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false

func _on_Main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/control_ui.tscn")
	
