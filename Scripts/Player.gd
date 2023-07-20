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
var strength = 1000

var pickable: Pickable = null
var grabbed = false

var max_x = 0.3 
var min_x = -0.3 
var max_y = 0.3 
var min_y = -0.3 

const rest_time = 2
var time = rest_time
const MAX_HEALTH = 100
var health = 100:
	set(value):
		health = value
		healthbar.set_health(health)
	get:
		return health
var in_damage = false

var teabagging = 0
var crouching = false


@onready var pivot = $Pivot
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var punch_hitbox = $Pivot/PuchHitbox
#Pickable
@onready var pickablemarker = $Pivot/pickablemarker
@onready var pickablearea = $pickablearea


@onready var healthbar = $CanvasLayer/healthbar

@onready var victory_words_2 = $CanvasLayer/Victory_words_2



func _ready():
	animation_tree.active = true
	punch_hitbox.body_entered.connect(_on_body_entered)
#	Engine.time_scale = 0.2		

	#Pickable
	pickablearea.body_entered.connect(_on_pickable_enter)
	pickablearea.body_exited.connect(_on_pickable_exit)


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
	
	#fix controller values
	if move_input_x > 0:
		max_x = max(max_x, move_input_x)
		move_input_x /= max_x
	else:
		min_x = min(min_x, move_input_x)
		move_input_x /= -min_x
	if move_input_y > 0:
		max_y = max(max_y, move_input_y)
		move_input_y /= max_y
	else:
		min_y = min(min_y, move_input_y)
		move_input_y /= -min_y
	
	#print(move_input_x," ", move_input_y)
	
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
	#Change direction
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
		elif move_input_y > 0.7:
			playback.travel("CROUCHING")
			if not crouching:
				crouching = true
				teabagging += 1
		elif Input.is_action_just_pressed("attack"):
			playback.travel("PUNCH")
		else:
			crouching = false
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
		
	
	#Pickable
	if Input.is_action_just_pressed("pick") and pickable and pickable != null:
		grabbed = !grabbed
		pickable.freeze = grabbed
		
	if pickable and grabbed and pickable != null:
		pickable.passive_on()
		pickable.global_position = lerp(pickable.global_position, pickablemarker.global_position , 0.4 )
		pickable.scale.x=pivot.scale.x
		pickable.rotation = 0
		
	if grabbed and pickable == null:
		grabbed = !grabbed
		
	if !grabbed and Input.is_action_just_pressed("pick"):
		if pickable and pickable != null:
			pickable.passive_off()
	
	
	if in_damage == true:
		if health > 0 and time >= rest_time:
			playback.start("TAKE_DAMAGE")
			health -= 10
			time = 0
		else:
			return
	
	#Defeat
	if health <= 0:
		victory_words_2.player2_win()
		
	if teabagging == 10:
		health = MAX_HEALTH
		teabagging = 0
		crouching = false



func _on_body_entered(body: Node):
	if body.has_method("push"):
		body.push(strength * direction, Input.get_vector("move_left", "move_right", "move_up", "move_down"))


# Pickable object
func _on_pickable_enter(body: Node):
	if body is Pickable and not grabbed:
		pickable = body
		
func _on_pickable_exit(body: Node):
	if body == pickable and not grabbed:
		pickable = null
 
func launch(v):
	if v.length() > 100:
		if health > 0 and time == rest_time:
			playback.start("TAKE_DAMAGE")
			health -= 10*floor(v.length()/50)
			time = 0
		velocity = v
		

func get_smashed(_direction):
	health -= 50
	velocity.x = _direction.x*1200
	velocity.y = -1200
		
#healthbar, damage
func take_damage():
	in_damage = true
func not_take_damage():
	in_damage = false
func _on_timer_timeout():
	if time < rest_time:
		time +=1
	else:
		pass

