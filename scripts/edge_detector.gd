class_name EdgeDetector extends Area2D

signal ball_left_court(player: int)

@export var player_index := 0


func _on_body_entered(body: Node2D) -> void:
	ball_left_court.emit(player_index)
