extends ColorRect

var game_scene: PackedScene = load("res://scenes/game.tscn")
var all_ai: ModeConfig = preload("res://Modes/mode_all_ai.tres")
@onready var viewport = $SubViewport

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material.set_shader_parameter("tex", viewport.get_texture())
	
	ModeManager.current_mode = all_ai
	var blurred_game = game_scene.instantiate()
	viewport.add_child(blurred_game)
