class_name Pong extends Node2D

@export var initial_countdown := 3
@export var points_to_win = 5

@onready var p1 : Paddle = $PlayerPaddleController/Paddle
@onready var p2 : Paddle = $PlayerPaddleController2/Paddle
@onready var ball : Ball = $Ball
@onready var hud: HUD = $HUD
@onready var edge0 : EdgeDetector = $Edge0
@onready var edge1 : EdgeDetector = $Edge1

var scores: Array[int]

signal score_updated(player: int, score: int)

var paddle_margin = 40
var scene_width
var scene_height

func start_launch_sequence():
	ball.position = Vector2(scene_width/2, scene_height/2)
	ball.stop_ball()
	hud.start_countdown(initial_countdown)
	await get_tree().create_timer(initial_countdown).timeout
	ball.launch_at_random_angle()

# Called when the node enters the scene tree for the first time.
func _ready():
	scene_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	scene_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	var setup_paddle = func(paddle: Paddle, left: bool):
		paddle.position.x = paddle_margin if left else (scene_width - paddle.get_size().x) - paddle_margin 
		paddle.position.y = scene_height / 2 - paddle.get_size().y / 2
	setup_paddle.call(p1, true)
	setup_paddle.call(p2, false)
	var edges = [edge0, edge1]
	for edge in edges:
		scores.push_back(0)
		edge.ball_left_court.connect(on_ball_left_court)
	start_launch_sequence()

func on_ball_left_court(player_side: int):
	var scorer = int(!player_side)
	set_score(scorer, scores[scorer] + 1)
	await get_tree().create_timer(1.0).timeout
	start_launch_sequence()

func set_score(player: int, score: int):
	scores[player] = score
	score_updated.emit(player, score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
