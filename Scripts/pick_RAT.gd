extends Pickable


@onready var gas_toxico = $gas_toxico


var damage_gas_area = preload("res://Scenes/Gas_Damage.tscn")
@onready var marker_2d = $Marker2D


func passive_on():
	gas_toxico.emitting = true

func passive_off():
	get_tree().create_timer(5).timeout.connect(queue_free)
	# Tiempo de vida, luego de ser botado
	#gas_toxico.emitting = false
	


func _on_timer_timeout():
	if gas_toxico.emitting == true:
		var new_damage_area = damage_gas_area.instantiate()
		get_parent().add_child(new_damage_area)
		new_damage_area.global_position = marker_2d.global_position


