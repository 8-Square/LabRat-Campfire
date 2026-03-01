class_name StageBit extends Node

@export var stage_skins: Array[AnimatedSprite2D]

var animated_sprite: AnimatedSprite2D

func applySprite(skin_index: int) -> void:
	for i in range(stage_skins.size()):
		stage_skins[i].visible = (i == skin_index)
	animated_sprite = stage_skins[skin_index]
	animated_sprite.play("idle")
	

func currentSprite() -> AnimatedSprite2D:
	return animated_sprite
