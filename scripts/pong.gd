class_name Pong extends Node2D

@export var initial_countdown := 3
@export var points_to_win = 5
@export var p0_human_controller_scene: PackedScene
@export var p1_human_controller_scene: PackedScene
@export var ai_controller_scene: PackedScene
@export var paddle_scene: PackedScene
@export var front_end_scene: PackedScene = preload("res://scenes/game.tscn")

@onready var ball : Ball = $Ball
@onready var hud: HUD = $HUD
@onready var edge0 : EdgeDetector = $Edge0
@onready var edge1 : EdgeDetector = $Edge1

var scores: Array[int]

signal score_updated(player: int, score: int)
signal game_over(winner: int)

var paddle_margin = 40
var scene_width
var scene_height
var winner := -1

func start_launch_sequence():
	ball.position = Vector2(scene_width/2, scene_height/2)
	ball.stop_ball()
	hud.start_countdown(initial_countdown)
	await get_tree().create_timer(initial_countdown).timeout
	ball.launch_at_random_angle()
	
func make_player(rules: PlayerRules, index: int):
	var setup_paddle = func(paddle: Paddle, left: bool):
		paddle.position.x = paddle_margin if left else (scene_width - paddle.get_size().x) - paddle_margin 
		paddle.position.y = scene_height / 2 - paddle.get_size().y / 2
		
	var controller
	var paddle: Paddle = paddle_scene.instantiate()
	if rules.is_bot:
		controller = ai_controller_scene.instantiate()
		controller.max_speed = rules.bot_speed
	else:
		var scene = p0_human_controller_scene if index == 0 else p1_human_controller_scene
		controller = scene.instantiate()
	controller.add_child(paddle)
	add_child(controller)
	setup_paddle.call(paddle, index == 0)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	scene_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	scene_height = ProjectSettings.get_setting("display/window/size/viewport_height")

	make_player(ModeManager.current_mode.p0Rules, 0)
	make_player(ModeManager.current_mode.p1Rules, 1)
	var edges = [edge0, edge1]
	for edge in edges:
		scores.push_back(0)
		edge.ball_left_court.connect(on_ball_left_court)
	start_launch_sequence()

func on_ball_left_court(player_side: int):
	var scorer = int(!player_side)
	set_score(scorer, scores[scorer] + 1)
	if winner == -1:
		await get_tree().create_timer(1.0).timeout
		start_launch_sequence()

func set_score(player: int, score: int):
	scores[player] = score
	score_updated.emit(player, score)
	if score == points_to_win:
		winner = player
		game_over.emit(winner)
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_packed(front_end_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
