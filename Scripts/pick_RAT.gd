extends Pickable

@onready var gas_toxico = $gas_toxico
@onready var marker_2d = $Marker2D

var damage_gas_area = preload("res://Scenes/Gas_Damage.tscn")
var velocity_min = Vector2(50, self.linear_velocity.y)
var velocity_max = 150
var rotation_lock = true
var was_grabbed = false

func _ready():
	pass


func _physics_process(delta):
	if freeze == true:
		rotation_lock = false
	
	if !was_grabbed:
		linear_velocity = velocity_min

func passive_on():
	pass

func passive_off():
	lock_rotation = false
	gas_toxico.emitting = true
	was_grabbed = true
	self.linear_velocity = Vector2(50,50)
	
	# Tiempo de vida, luego de ser botado
	get_tree().create_timer(15).timeout.connect(queue_free)

func _on_timer_timeout():
	if gas_toxico.emitting == true:
		var new_damage_area = damage_gas_area.instantiate()
		get_parent().add_child(new_damage_area)
		new_damage_area.global_position = marker_2d.global_position


