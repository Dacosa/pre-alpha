extends Control



func _ready():
	hide()


func player2_win():
	show()
	get_tree().paused = true
	
