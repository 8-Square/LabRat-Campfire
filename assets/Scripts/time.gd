class_name Countdown extends Control

@onready var countdown: Label = $Countdown
@onready var timer: Timer = $Timer
@onready var final_time_label: Label = $CanvasLayer/FinalTimeLabel
@onready var stage_bit: StageBit = $"../../Player/StageBit"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: Player = $"../../Player"
@onready var texture_rect: TextureRect = $TextureRect
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var game_over_text: Label = $GameOverText
@onready var rat_death: AudioStreamPlayer = $RatDeath
@onready var main_menu_button: TextureButton = $MainMenuButton

var bts_timer: float = 180

var game_started 
var final_time: float
var game_status: bool = false
var before_level_change: float

var sewer_one = "res://assets/Scenes/Sewers/Game.tscn"
var sewer_two = "res://assets/Scenes/Sewers/SewerTwo.tscn"

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu_button.hide()
	texture_rect.hide()
	canvas_layer.hide()

func _input(event: InputEvent) -> void:
	var current_scene = get_tree().current_scene.scene_file_path
	if current_scene == sewer_one or current_scene == sewer_two:
	# Checks if game started
		if !game_started:
			if Input.is_action_just_pressed("move"):
				game_started = true


func _process(delta: float) -> void:
	# Countdown display 
	if bts_timer > 0 and game_started == true:
		bts_timer -= delta
		countdown.text = str(int(bts_timer))
	elif bts_timer <= 0 and game_started == true:
		print("GAME OVER")
		game_over()
	
	if Input.is_action_just_pressed("reset"):
		reset()
	skinStage()

func stop():
	game_started = false
func start():
	game_started = true
func reset():
	game_started = false

func skinStage():
	var current_scene = get_tree().current_scene.scene_file_path

	if current_scene == sewer_one:
		if bts_timer <= 80 and player.current_stage == 0:
			player.changeStage(1)
		elif bts_timer <= 50 and player.current_stage == 1:
			player.changeStage(2)
		elif bts_timer <= 30 and player.current_stage == 2:
			player.changeStage(3)

func game_over():
	texture_rect.show()
	main_menu_button.show()
	game_over_text.show()
	animation_player.play("game_over")
func player_death():
	animation_player.play("player_death")

func game_complete():
	canvas_layer.show()
	calc_final_score()

func change_level():
	stop()
	before_level_change = bts_timer
	get_tree().change_scene_to_file("res://assets/Scenes/Sewers/SewerTwo.tscn")
	bts_timer = before_level_change

func calc_final_score():
	final_time = bts_timer
	final_time = final_time*100 
	final_time_label.text = str(int(final_time))
	print(int(final_time))


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/Scenes/Main_Menu.tscn")
