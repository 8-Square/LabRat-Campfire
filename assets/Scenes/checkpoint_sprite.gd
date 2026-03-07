extends Sprite2D

func _ready() -> void:
	update_sprite()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		#body.checkpoint($Marker2D.global_position)
		GlobalCheckpoint.checkpoint_pos = $Marker2D.global_position
		if GlobalCheckpoint.previous_checkpoint_node:
			GlobalCheckpoint.previous_checkpoint_node.update_sprite()
		GlobalCheckpoint.previous_checkpoint_node = self
		update_sprite()

func update_sprite() -> void:
	if $Marker2D.global_position == GlobalCheckpoint.checkpoint_pos:
		frame = 1
	else:
		frame = 0
	
