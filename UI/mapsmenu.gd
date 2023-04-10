extends Control


@onready var mapa_1 = %Mapa1
@onready var mapa_2 = %Mapa2
@onready var mapa_3 = %Mapa3


func _ready():
	mapa_1.pressed.connect(_on_mapa_1_pressed)
	mapa_2.pressed.connect(_on_mapa_2_pressed)
	mapa_3.pressed.connect(_on_mapa_3_pressed)

func _on_mapa_1_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_mapa_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_mapa_3_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
