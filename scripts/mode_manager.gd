extends Node

var default_mode: ModeConfig = preload("res://Modes/mode_ai_medium.tres")

var current_mode: ModeConfig:
	get():
		if !current_mode:
			return default_mode
		return current_mode
	set(v):
		current_mode = v
