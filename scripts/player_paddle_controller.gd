class_name PlayerPaddleController extends Node2D

@export var down_input = "p1_move_down"
@export var up_input = "p1_move_up"

var paddle : Paddle

# Called when the node enters the scene tree for the first time.
func _ready():
	paddle = get_child(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input = Input.get_axis(down_input, up_input)
	paddle.move(-input)
