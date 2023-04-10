extends CharacterBody2D


const DASH_SPEED = 500.0
const SPIN_SPEED = 1000.0
const RUN_SPEED = 450
const JUMP_VELOCITY = -500.0
const GRAVITY = 1500
const ACCELERATION = 2000

const MAX_JUMP_TIME = 0.2
const MAX_AIRBORNE_TIME = 0.1

var current_jump_time = 0
var current_airborne_time = 0
var jumping = false
var falling = false
var direction = 1
var landing_count = 0



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
		
	#fast fall
	if falling and Input.is_action_just_pressed("move_down"):
		velocity.y = 700
		
	#jumping
	if Input.is_action_just_pressed("jump") and current_airborne_time < MAX_AIRBORNE_TIME:
		jumping = true
		current_jump_time = 0
	
	if jumping and current_jump_time <= MAX_JUMP_TIME:
		velocity.y = JUMP_VELOCITY
	
	current_jump_time += delta
	current_airborne_time += delta
	
	if Input.is_action_just_released("jump"):
		jumping = false
		
	var move_input_x = Input.get_axis("move_left", "move_right")
	var move_input_y = Input.get_axis("move_up", "move_down")
	
	#air spin
	if Input.is_action_just_pressed("air_spin") and not is_on_floor():
		velocity.x = move_input_x * SPIN_SPEED
		velocity.y = move_input_y * SPIN_SPEED

	
	if move_input_x:
		direction = move_input_x
	
	if playback.get_current_node() == "DASH" and is_on_floor():
		if velocity.x * direction < 0:
			playback.start("TURN")
		velocity.x = direction * DASH_SPEED
	else:
		velocity.x = move_toward(velocity.x, direction * RUN_SPEED, ACCELERATION * delta)
	
	if playback.get_current_node() == "LAND_BEGIN":
		#after x amount of frames, allow moving 
		##implement wavedash here
		#keep dash momentum by 
		
		#animation cancel?
		if landing_count < 5:
			velocity.x = 0
			landing_count += 1
		elif Input.is_action_pressed("any"):
			landing_count = 0
			playback.next()
		
		
		
	move_and_slide()

	
	# animation
	
	if is_on_floor():
		if abs(velocity.x) > 100 or move_input_x:
			direction = move_input_x
			playback.travel("RUN")
		else:
			playback.travel("IDLE")
	else:
		#if Input.is_action_just_pressed("air_spin"):
		#	playback.travel("AIR_SPIN")
		if velocity.y < 0:
			playback.travel("JUMP")
		else:
			falling = true
			playback.travel("FALL")

	if move_input_x and is_on_floor():
		pivot.scale.x = sign(move_input_x)



