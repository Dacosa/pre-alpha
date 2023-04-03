extends CharacterBody2D


const DASH_SPEED = 600.0
const RUN_SPEED = 450
const JUMP_VELOCITY = -500.0
const GRAVITY = 1500
const ACCELERATION = 1000

const MAX_JUMP_TIME = 0.2
const MAX_AIRBORNE_TIME = 0.1

var current_jump_time = 0
var current_airborne_time = 0
var jumping = false
var falling = false



@onready var pivot = $Pivot
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")

func _ready():
	animation_tree.active = true
#	Engine.time_scale = 0.2

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if is_on_floor():
		current_airborne_time = 0
		falling = false
		
	if falling and Input.is_action_just_pressed("move_down"):
		velocity.y = 700
		

	if Input.is_action_just_pressed("jump") and current_airborne_time < MAX_AIRBORNE_TIME:
		jumping = true
		current_jump_time = 0
	
	if jumping and current_jump_time <= MAX_JUMP_TIME:
		velocity.y = JUMP_VELOCITY
	
	current_jump_time += delta
	current_airborne_time += delta
	
	if Input.is_action_just_released("jump"):
		jumping = false
	

	var move_input = Input.get_axis("move_left", "move_right")
	
	if playback.get_current_node() == "DASH":
		velocity.x = move_input * DASH_SPEED
	else:
		velocity.x = move_toward(velocity.x, move_input * RUN_SPEED, ACCELERATION * delta)
	

	move_and_slide()

	
	# animation
	
	if is_on_floor():
		if abs(velocity.x) > 100 or move_input:
			playback.travel("RUN")
		else:
			playback.travel("IDLE")
	else:
		if velocity.y < 0:
			playback.travel("JUMP")
		else:
			falling = true
			playback.travel("FALL")

	if move_input:
		pivot.scale.x = sign(move_input)


