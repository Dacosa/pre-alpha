extends Control

@onready var panel_container = $PanelContainer
@onready var main_menu = $Main_menu
@onready var mapsmenu = $mapsmenu
@onready var creditsmenu = $Creditsmenu
@onready var audio_stream_player = $AudioStreamPlayer
@onready var animation_player = $AnimationPlayer

var skip_intro = false



func _ready():
	mapsmenu.hide()
	creditsmenu.hide()
	get_tree().create_timer(6).timeout.connect(panel_container.queue_free)

func _physics_process(_delta):
	if Input.is_action_just_pressed("any") and skip_intro == false:
		if audio_stream_player.volume_db != -15:
			animation_player.set_speed_scale(100)
			get_tree().create_timer(0.5).timeout.connect(panel_container.queue_free)
			skip_intro = true

