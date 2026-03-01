class_name BackupPlayer extends CharacterBody2D

@export var respawn_point: Node2D

@onready var stage_bit: StageBit = $StageBit
@onready var animated_sprite: AnimatedSprite2D

# Tilemap, for death loop
@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"

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
	
	check_spikes()
	move_and_slide()


func reset() -> void:
	can_control = false
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.4).timeout
	global_position = respawn_point.global_position
	can_control = true

# Spikes/Death Loop
func check_spikes():
	# Gets cells (Squares) in tilemap 
	var cell: Vector2i = tile_map_layer.local_to_map(tile_map_layer.to_local(global_position))
	# Gets data of current cell (square) of tilemap 
	var tile_data: TileData = tile_map_layer.get_cell_tile_data(cell)
	
	# checks for data and if it has damage_block (for deaht of player)
	if tile_data:
		if tile_data.get_custom_data("DamageTile") or tile_data.get_custom_data("damage_block") and can_control:
			print("PLAYER DIED")
			can_control = false
			reset()
			


# RANDOM, PROBABLY GONNA REMOVE
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


# Spikes/Death Loop
func check_spikes():
	# Gets cells (Squares) in tilemap 
	var cell: Vector2i = tile_map_layer.local_to_map(tile_map_layer.to_local(global_position))
	# Gets data of current cell (square) of tilemap 
	var tile_data: TileData = tile_map_layer.get_cell_tile_data(cell)
	# checks for data and if it has damage_block (for deaht of player)
	#if tile_data:
		#if (tile_data.get_custom_data("DamageTile") or tile_data.get_custom_data("damage_block")) and can_control:
			#print("PLAYER DIED")
			#death_count += 1
			#reset()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider == tile_map_layer:
			# Convert collision point to tile coordinates
			var tile_pos = tile_map_layer.local_to_map(collision.get_position())     
			# Check if there's a tile at this position
			if tile_map_layer.get_cell_source_id(tile_pos) != -1:
				if tile_map_layer.get_cell_tile_data(tile_pos):
					if tile_data.get_custom_data("damage_block") and can_control:
					#reset()
						print("HITTING THE RIGHT ONE..?")
