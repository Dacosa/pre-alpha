extends RigidBody2D

var respawn_pos = Vector2(0, 0)
var need_reset = false

func _ready():
	respawn_pos = self.get_position()

#Por ahora solo respawnea cuando le pegan, idealmente respawnea si se mueve
#func _process(delta):
#	if need_reset == false and self.get_position() != respawn_pos:
#		need_reset = true
#
#	if need_reset == true:
#		reset()
	
func push(forceDir :int,dir : Vector2):
	apply_central_impulse(Vector2(forceDir, dir.y * abs(forceDir)))
	#Por ahora solo respawnea cuando le pegan, idealmente respawnea si se mueve
	reset()

	
func reset():
	await get_tree().create_timer(2).timeout
	linear_velocity = Vector2(0, 0)
	rotation = 0
	global_transform.origin = respawn_pos
	
