class_name Player extends CharacterBody2D

@export var respawn_point: Node2D

const SPEED = 400
const SPRINT_SPEED = 600
const JUMP_VELOCITY = -350.0

var toggled_sprint: bool = false

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
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func toggle_sprint():
	pass

# Spikes/Death Loop
func check_spikes():
	pass
