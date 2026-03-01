extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pass


func _on_play_button_pressed():
	animation_player.play("start")
	await animation_player.animation_finished
	print("Moving to game")
	get_tree().change_scene_to_file("res://assets/Scenes/Sewers/Game.tscn")
	



func _on_quit_button_pressed() -> void:
	get_tree().quit()
