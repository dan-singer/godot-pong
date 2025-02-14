extends Node

var game_scene: PackedScene = preload("res://scenes/game.tscn")
var default_mode: ModeConfig = preload("res://Modes/mode_2P.tres")

var current_mode: ModeConfig:
	get():
		if !current_mode:
			return default_mode
		return current_mode
	set(v):
		current_mode = v

func load_mode():
	get_tree().change_scene_to_packed(game_scene)
