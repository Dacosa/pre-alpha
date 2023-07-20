extends RigidBody2D

var respawn_pos = Vector2(0, 0)
var need_reset = false

var sprite_scale

func _ready():
	respawn_pos = self.get_position()
	sprite_scale = $Sprite2D.scale
	set_contact_monitor(true)
	set_max_contacts_reported(3)

func _physics_process(_delta):
	var bodies = get_colliding_bodies()
	for body in bodies:
		if body.has_method("launch"): #check colliding body is in the "players" group
			body.launch(linear_velocity) #whatever u want to do (i.e, damage the player)

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
	await get_tree().create_timer(3).timeout
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color.RED, 2)
	tween.parallel().tween_property($Sprite2D, "scale", sprite_scale/4, 2)

	await get_tree().create_timer(2).timeout
	var tween2 = get_tree().create_tween()
	tween2.tween_property($Sprite2D, "scale", sprite_scale, 0.5)
	tween2.parallel().tween_property($Sprite2D, "offset", Vector2(0,0), 0.5)

	$Sprite2D.modulate = Color.WHITE
	$Sprite2D.offset.y = 250
	
	linear_velocity = Vector2(0, 0)
	rotation = 0
	global_transform.origin = respawn_pos
	
	
