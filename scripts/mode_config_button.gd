class_name ModeConfigButton extends Button

var game_scene = preload("res://scenes/game.tscn")
@export var config: ModeConfig

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_mode(config)
	pressed.connect(start_mode)
	
func set_mode(mode: ModeConfig):
	config = mode
	text = config.title

func start_mode():
	ModeManager.current_mode = config
	ModeManager.load_mode()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
