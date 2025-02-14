class_name PlayerPaddleController extends Node2D

@export var down_input = "p1_move_down"
@export var up_input = "p1_move_up"

var paddle : Paddle

func _ready() -> void:
	paddle = get_child(0)

func _process(delta):
	var input = Input.get_axis(down_input, up_input)
	paddle.move(-input)
