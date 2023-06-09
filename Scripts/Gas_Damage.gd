extends damage_area


func _on_child_entered_tree(_node):
	get_tree().create_timer(3).timeout.connect(queue_free)
