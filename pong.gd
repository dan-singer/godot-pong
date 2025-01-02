extends Node2D

@onready var p1 : Paddle = $PlayerPaddleController/Paddle
@onready var p2 : Paddle = $PlayerPaddleController2/Paddle
@onready var ball : Ball = $Ball
var paddle_margin = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	var scene_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var scene_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	var setup_paddle = func(paddle: Paddle, left: bool):
		paddle.position.x = paddle_margin if left else (scene_width - paddle.get_size().x) - paddle_margin 
		paddle.position.y = scene_height / 2 - paddle.get_size().y / 2
	setup_paddle.call(p1, true)
	setup_paddle.call(p2, false)
	ball.position = Vector2(scene_width/2, scene_height/2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
