class_name EndPortal extends Node2D


@onready var countdown: Countdown = $"../CanvasLayer/Countdown"
@onready var player: Player = $"../Player"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		countdown.stop()
		get_tree().change_scene_to_file("res://assets/Scenes/Sewers/SewerTwo.tscn")
		
