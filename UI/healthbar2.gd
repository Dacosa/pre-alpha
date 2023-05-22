extends MarginContainer


@onready var texture_progress_bar = $TextureProgressBar


func set_health(value):
	texture_progress_bar.value = value
