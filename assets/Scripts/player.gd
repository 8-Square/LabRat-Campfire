class_name Player extends CharacterBody2D

@export var respawn_point: Node2D
@onready var stage_bit: StageBit = $StageBit
# @onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D

const SPEED = 250
const SPRINT_SPEED = 400
const SPRINT_JUMP_VELOCITY = -375.0
const JUMP_VELOCITY = -350.0

var toggled_sprint: bool = false
var is_walking: bool = false
var can_control: bool = true

func _ready() -> void:
		stage_bit.applySprite(0)
		animated_sprite = stage_bit.currentSprite()

func _physics_process(delta: float) -> void:
		# if can_control is off, player can't control, as the name implies....
		if !can_control:
				velocity = Vector2.ZERO
				move_and_slide()
				return

		# Add the gravity.
		if not is_on_floor():
				velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
				if toggled_sprint == true:
						velocity.y = SPRINT_JUMP_VELOCITY
				else:
						velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("left", "right")

		# Movement
		if direction:
				if toggled_sprint == true:
						velocity.x = direction * SPRINT_SPEED
						# stage_0.play()
				else:
						velocity.x = direction * SPEED
						# Sets walking animation
						animated_sprite.play("walk")
						animated_sprite.flip_h = velocity.x < 0
				is_walking = true
		else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				animated_sprite.play("idle")

		# Sprinting code thingy (toggles sprinting)
		if Input.is_action_just_pressed("sprint"):
				toggled_sprint = !toggled_sprint

		if Input.is_action_just_pressed("reset"):
				reset()

		move_and_slide()

func reset() -> void:
		can_control = false
		velocity = Vector2.ZERO
		await get_tree().create_timer(0.2).timeout
		global_position = respawn_point.global_position
		can_control = true

# Spikes/Death Loop
func check_spikes():
		pass

@export var one_way_layer := 2  # Set the collision layer of your one-way wall
@export var pass_through_time := 0.2  # Time to pass through the wall

var passing_through := false
var original_collision_layer := 0

func _ready2():
		# Store the original collision layer for restoration later
		original_collision_layer = collision_layer

func _physics_process2(delta):
		var input_dir = Input.get_axis("ui_left", "ui_right")
		velocity.x = input_dir * 200  # Adjust your speed here
		move_and_slide()

		# If pressing left or right, check for collision and pass through if possible
		if input_dir != 0 and not passing_through:
				if is_touching_one_way_wall(input_dir):
						pass_through_wall()

func is_touching_one_way_wall(input_dir: float) -> bool:
		# Loop through all collisions from the previous movement
		for i in range(get_slide_collision_count()):
				var collision = get_slide_collision(i)
				# Check if the player is colliding with a wall on the specified layer
				if collision.get_collider().collision_layer & (1 << (one_way_layer - 1)):
						var normal = collision.get_normal()
						# If moving right, check if we're colliding with the left side of the wall
						if input_dir > 0 and normal.x < 0:
								return true
						# If moving left, check if we're colliding with the right side of the wall
						elif input_dir < 0 and normal.x > 0:
								return true
		return false

func pass_through_wall():
		# Start the pass-through process
		passing_through = true
		# Temporarily disable collision with the one-way wall layer by setting the collision layer to 0
		collision_layer = 0
		# Wait for a brief period and then re-enable collision
		await get_tree().create_timer(pass_through_time).timeout
		# Restore the original collision layer
		collision_layer = original_collision_layer
		passing_through = false
