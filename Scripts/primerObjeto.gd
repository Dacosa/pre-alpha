extends RigidBody2D

	
func push(forceDir :int,dir : Vector2):
	apply_central_impulse(Vector2(forceDir, dir.y * abs(forceDir)))

