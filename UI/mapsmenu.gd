extends Control


@onready var mapa_1 = %Mapa1
@onready var mapa_2 = %Mapa2
@onready var mapa_3 = %Mapa3
@onready var Back = %Back
@onready var audio_stream_player = $AudioStreamPlayer


func _ready():
	mapa_1.pressed.connect(_on_mapa_1_pressed)
	mapa_2.pressed.connect(_on_mapa_2_pressed)
	mapa_3.pressed.connect(_on_mapa_3_pressed)
	Back.pressed.connect(_on_Back_pressed)
	

func _on_mapa_1_pressed():
	get_tree().change_scene_to_file("res://Scenes/mapa_1.tscn")

func _on_mapa_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/mapa_2.tscn")

func _on_mapa_3_pressed():
	get_tree().change_scene_to_file("res://Scenes/mapa_3.tscn")

func _on_Back_pressed():
	self.hide()
	get_parent().main_menu.show()
	get_parent().audio_stream_player.bus = "Master"
