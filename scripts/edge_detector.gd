class_name EdgeDetector extends Area2D

signal ball_left_court(player: int)

@export var player_index := 0
@export var left_court_sfx: AudioStreamWAV

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _on_body_entered(body: Node2D) -> void:
	audio_stream_player.stream = left_court_sfx
	audio_stream_player.play()
	ball_left_court.emit(player_index)
