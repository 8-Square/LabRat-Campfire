class_name Countdown extends Control

@onready var countdown: Label = $Countdown
@onready var timer: Timer = $Timer

var bts_timer: float = 100

var game_started 
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#await 

func _input(event: InputEvent) -> void:
	# Checks if game started
	if !game_started:
		if Input.is_action_just_pressed("move"):
			game_started = true


func _process(delta: float) -> void:
	# Countdown display 
	if bts_timer > 0:
		bts_timer -= delta
		countdown.text = str(int(bts_timer))
		
	if Input.is_action_just_pressed("reset"):
		reset()
	

func reset():
	bts_timer = 100
	game_started = false
