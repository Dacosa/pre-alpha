extends RigidBody2D


		
func _on_area_2d_area_entered(_area):
	push(1000)
	
func push(force : int):
	apply_central_impulse(Vector2(force,0))

