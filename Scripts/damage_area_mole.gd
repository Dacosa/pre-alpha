class_name damage_area
extends Area2D


func _ready():
	body_entered.connect(_on_hazard_entered)
	body_exited.connect(_on_hazard_exit)

func _on_hazard_entered(body: Node):
	if body.has_method("take_damage"):
		body.take_damage()
		
func _on_hazard_exit(body: Node):
	if body.has_method("not_take_damage"):
		body.not_take_damage()
