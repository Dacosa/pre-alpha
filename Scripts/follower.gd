extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -1000.0
const GRAVITY = 1500

@onready var target_detection = $target_detection
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var target_chase = false
var awake = false
var target = null
var overlapping = []

func _physics_process(delta):
	move_and_slide()
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if awake:
		if target_chase:
			velocity.x = position.direction_to(target.position).x * SPEED
		else:
			velocity.x = 0
		if target != null:
			if (target.position.y - position.y) < -80 and is_on_floor():
				velocity.y = JUMP_VELOCITY

func launch(v):
	playback.travel("Transform")
	awake = true


func _on_area_2d_body_entered(body):
	if (body.name == "Player" or body.name == "Player2") and target == null:
		target = body
		target_chase = true
	

func _on_area_2d_body_exited(body):
	if body == target:
		target_chase = false # Replace with function body.
		target = null
		overlapping = target_detection.get_overlapping_bodies()
		for bodi in overlapping:
			if bodi.name == "Player":
				target = bodi
				target_chase = true
			if bodi.name == "Player2":
				target = bodi
				target_chase = true
		
		
		
		
