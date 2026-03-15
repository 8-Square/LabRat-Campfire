class_name EndPortal extends Node2D


@onready var countdown: Countdown = $"../CanvasLayer/Countdown"
@onready var player: Player = $"../Player"

var sewer_one = "res://assets/Scenes/Sewers/Game.tscn"
var sewer_two = "res://assets/Scenes/Sewers/SewerTwo.tscn"
var sewer_three = "res://assets/Scenes/Sewers/SewerThree.tscn"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	var current_scene = get_tree().current_scene.scene_file_path
	if body is Player:
		if current_scene == sewer_one or current_scene == sewer_two:
			countdown.stop()
			countdown.change_level()
			#get_tree().change_scene_to_file("res://assets/Scenes/Sewers/SewerTwo.tscn")
		if current_scene == sewer_three:
			countdown.stop()
			countdown.game_complete()
		
		
	
