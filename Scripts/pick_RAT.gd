extends Pickable

@onready var gas_toxico = $gas_toxico
@onready var marker_2d = $Marker2D
@onready var sprite_2d = $Sprite2D
@onready var audio_lanzar = $Audio_lanzar


var damage_gas_area = preload("res://Scenes/Gas_Damage.tscn")
var velocity_min = 250
var velocity_max = 300
var rotation_lock = true
var was_grabbed = false
var launch_speed = Vector2(800,-400)
var direction_x = randi_range(-1,1)
var scale_in0 = -1
var respawn_pos

func _ready():
	respawn_pos = self.get_position()

func _integrate_forces(_state):
	if !was_grabbed:
		natural_movement()


func passive_on():
	was_grabbed = true

func passive_off():
	lock_rotation = false
	gas_toxico.emitting = true
	
	# Lanzamiento
	linear_velocity = Vector2(launch_speed.x*scale.x, launch_speed.y)
	audio_lanzar.play()
	
	# Tiempo de vida, luego de ser botado

	respawn()

func _on_damage_area_timer_timeout():
	if gas_toxico.emitting == true:
		var new_damage_area = damage_gas_area.instantiate()
		get_parent().add_child(new_damage_area)
		new_damage_area.global_position = marker_2d.global_position


func natural_movement():
	linear_velocity.x = randf_range(velocity_min, velocity_max)*direction_x
	
	if direction_x == -1 or direction_x == 1:
		scale.x = direction_x
	else:
		scale.x = scale_in0

func direction_change():
	direction_x = randi_range(-1,1)
	scale_in0 = randi_range(-1,0)
	if scale_in0 == 0:
		scale_in0 += 1

	# Animation
	if direction_x == 1 or direction_x == -1:
		sprite_2d.frame = 1
	else: # n == 0
		sprite_2d.frame = 0

func _on_direction_timer_timeout():
	if !was_grabbed:
		direction_change()

func respawn():

	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(0,0,0,0), 1).set_delay(5)

	await get_tree().create_timer(8).timeout
	var tween2 = get_tree().create_tween()
	tween2.tween_property($Sprite2D, "modulate", Color(1,1,1,1), 0.5)
	
	linear_velocity = Vector2(0, 0)
	rotation = 0
	global_transform.origin = respawn_pos
	was_grabbed = false
	gas_toxico.emitting = false
	lock_rotation = true
	
