class_name Player extends CharacterBody2D


@export var respawn_point: Node2D

@onready var stage_bit: StageBit = $StageBit
#@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D

const SPEED = 250
const SPRINT_SPEED = 400
const SPRINT_JUMP_VELOCITY = -375.0
const JUMP_VELOCITY = -350.0

var toggled_sprint: bool = false
var is_walking: bool = false

var can_control: bool = true


@export var allowed_direction := Vector2.RIGHT

@export var one_way_layer := 2
@export var pass_through_time := 0.2

var passing_through := false


func _ready() -> void:
	stage_bit.applySprite(0)
	animated_sprite = stage_bit.currentSprite()

func _physics_process(delta: float) -> void:
	# if can_control is off, player cant control, as the name implies....
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
			#stage_0.play()
		else:
			velocity.x = direction * SPEED
			# Sets walking animation
			animated_sprite.play("walk")
			animated_sprite.flip_h = velocity.x < 0
		is_walking = true
		
		# One way wall
		if is_touching_one_way_wall():
			pass_through_wall()
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



func is_touching_one_way_wall() -> bool:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() && (1 << (one_way_layer - 1)):
			return true
	return false


func pass_through_wall():
	passing_through = true
	
	# Disable collision with one-way wall layer
	set_collision_mask_value(one_way_layer, false)

	await get_tree().create_timer(pass_through_time).timeout

	# Re-enable collision
	set_collision_mask_value(one_way_layer, true)
	
	passing_through = false
