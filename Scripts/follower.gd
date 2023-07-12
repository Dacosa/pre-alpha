extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var target_chase = false
var awake = false
var target = null


func _physics_process(delta):
	if awake:
		if target_chase:
			position += (target.position - position)/(SPEED)

func launch(v):
	awake = true


func _on_area_2d_body_entered(body):
	target = body
	#animar y que espere un poco
	target_chase = true
	


func _on_area_2d_body_exited(body):
	pass # Replace with function body.
