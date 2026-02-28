class_name Player extends CharacterBody2D

@export var respawn_point: Node2D


@onready var stage_0: AnimatedSprite2D = $Stage0

const SPEED = 250
const SPRINT_SPEED = 400
const JUMP_VELOCITY = -350.0

var toggled_sprint: bool = false
var is_walking: bool = false



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	# Movement
	if direction:
		if toggled_sprint == true:
			velocity.x = direction * SPRINT_SPEED
		else:
			velocity.x = direction * SPEED
			# Sets walking animation
			stage_0.play("walk")
		is_walking = true
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		is_walking = false
		stage_0.play("idle")
	
	# Sprinting code thingy (toggles sprinting)
	if Input.is_action_just_pressed("sprint"):
		toggled_sprint = !toggled_sprint

	move_and_slide()




# Spikes/Death Loop
func check_spikes():
	pass
