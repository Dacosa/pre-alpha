extends Control


func _ready():
	hide()


func player1_win():
	show()
	get_tree().paused = true
	
