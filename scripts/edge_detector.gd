class_name EdgeDetector extends Area2D

signal ball_left_court(player: int)

@export var player_index := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	ball_left_court.emit(player_index)
