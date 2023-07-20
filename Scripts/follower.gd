extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -1000.0
const GRAVITY = 1500

@onready var target_detection = $target_detection
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var pivot = $Pivot
@onready var hit_hitbox = $Pivot/hit_area/hit_hitbox
@onready var hit_detection_area = $Pivot/hit_detection/hit_detection_area
@onready var hit_detection = $Pivot/hit_detection
@onready var audio_golpe_1 = $Audio_golpe1
@onready var audio_golpe_2 = $Audio_golpe2
@onready var audio_golpe_3 = $Audio_golpe3



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var target_chase = false
var awake = false
var target = null
var overlapping = []

func _ready():
	animation_tree.active = true
	hit_detection.body_entered.connect(_on_hit_detection_body_entered)

func _physics_process(delta):
	move_and_slide()
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if awake:
		#Mueve al NPC
		if target_chase:
			velocity.x = position.direction_to(target.position).x * SPEED
		else:
			velocity.x = 0
		if target != null:
			if (target.position.y - position.y) < -80 and is_on_floor():
				velocity.y = JUMP_VELOCITY
				
		#Animaciones
		if abs(velocity.x) > 100:
			playback.travel("run") 
		else:
			playback.travel("buff_idle")
		if velocity.x != 0:
			pivot.scale.x = sign(velocity.x)
			
		#Golpes
		
		
		

func launch(_v):
	playback.travel("Transform")
	await get_tree().create_timer(2).timeout
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
		

func _on_hit_detection_body_entered(body):
	if body.name == "Player" and awake:
		playback.travel("hit")
		
		if audio_golpe_1.get_playback_position() == 0 and audio_golpe_2.get_playback_position() == 0 and audio_golpe_3.get_playback_position() == 0:
			var index = randi_range(1,3) 
			if index == 1:
				get_tree().create_timer(0.5).timeout.connect(audio_golpe_3.play)
			elif index == 2:
				get_tree().create_timer(0.5).timeout.connect(audio_golpe_2.play)
			else: 
				get_tree().create_timer(0.5).timeout.connect(audio_golpe_1.play)
