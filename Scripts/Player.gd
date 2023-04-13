extends CharacterBody2D


const DASH_SPEED = 400.0
const DODGE_SPEED = 1000.0
const FINAL_SPIN_SPEED = 0
const RUN_SPEED = 350
const JUMP_VELOCITY = -400.0
const SECOND_JUMP_VELOCITY = -600.0
const GRAVITY = 1500
const ACCELERATION = 2000
const AIR_DRIFT = 300

const MAX_JUMP_TIME = 0.2
const MAX_AIRBORNE_TIME = 0.1

var current_jump_time = 0
var current_airborne_time = 0
var jumping = false
var falling = false
var direction = 1
var landing_count = 0
var dodge_count = 0
var second_jump = true
var jump_count = 0
var dodged = false



@onready var pivot = $Pivot
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")

func _ready():
	animation_tree.active = true
#	Engine.time_scale = 0.2

func hit():
	pass

func _physics_process(delta):
	
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if is_on_floor():
		current_airborne_time = 0
		falling = false
		second_jump = true
		dodge_count = 0
		
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
	
	#second jump
	if Input.is_action_just_pressed("jump") and not is_on_floor() and second_jump:
		velocity.y = SECOND_JUMP_VELOCITY
		second_jump = false
	
	#move input vars
	var move_input_x = Input.get_axis("move_left", "move_right")
	var move_input_y = Input.get_axis("move_up", "move_down")
	
	#air spin
	"""
	if Input.is_action_just_pressed("air_dodge") and not is_on_floor() and dodge_count == 0:
		velocity.x = move_input_x * DODGE_SPEED
		velocity.y = move_input_y * DODGE_SPEED
	
	if playback.get_current_node() == "AIR_DODGE":
		if dodge_count < 20:
			dodge_count += 1
			velocity *= 0.99
		elif dodge_count == 25:
			velocity.x *= 0.2
	"""
	
	if move_input_x != 0:
		direction = move_input_x
	
	#dash and dance
	if playback.get_current_node() == "DASH" and is_on_floor():
		if velocity.x * direction < 0:
			playback.start("TURN")
		velocity.x = direction * DASH_SPEED
	else:
		velocity.x = move_toward(velocity.x, move_input_x * RUN_SPEED, ACCELERATION * delta)
	
	#landing and wavedash??
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
		jump_count = 0
		dodged = false
		if abs(velocity.x) > 100 or move_input_x:
			playback.travel("RUN")
		elif move_input_y == 1:
			playback.travel("CROUCHING")
		elif Input.is_action_just_pressed("attack"):
			playback.travel("PUNCH")
		else:
			playback.travel("IDLE")
	else:
		#if Input.is_action_just_pressed("air_spin"):
		#	playback.travel("AIR_SPIN")
		if Input.is_action_just_pressed("jump") and jump_count < 2:
			jump_count += 1
			playback.travel("JUMP")
		
		elif Input.is_action_just_pressed("air_dodge") and not dodged:
			jump_count = 2
			dodged = true
			#playback.start("AIR_DODGE")
		elif velocity.y > 0:
			falling = true
			playback.travel("FALL")

	if move_input_x and is_on_floor():
		pivot.scale.x = sign(move_input_x)
		



